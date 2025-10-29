package EPrints::Plugin::Screen::EPrint::Box::Altmetric;

our @ISA = ( 'EPrints::Plugin::Screen::EPrint::Box' );

use strict;

sub can_be_viewed
{
	my( $self ) = @_;

	return 0 if( !defined $self->{processor}->{eprint} );
	return 0 if( !$self->{session}->can_call( "altmetric", "get_type_and_id" ) );

	# prevent box being rendered if type or id are not available
	my ( $type, $id ) = $self->{session}->call( [ "altmetric", "get_type_and_id" ], $self->{processor}->{eprint} );
	return 0 if ( !defined $type || !defined $id );

	return 1;
}

sub render
{
	my( $self, $no_embed_js ) = @_; #$no_embed_js is used by the EPScript method when multiple badges could appear on a page

	my $session = $self->{session};

	my $frag = $session->xml->create_document_fragment;

	my ( $type, $id ) = $session->call( [ "altmetric", "get_type_and_id" ], $self->{processor}->{eprint} );

	return $frag if ( !defined $type || !defined $id );

	# If an API key has been defined, use the API (via local cgi) method to render the data.
	# If there is no API key, fall back to the Altmetric embed javascript method.

	if( defined $session->config( "altmetric", "api_key" ) )
	{
		my $t = EPrints::Utils::generate_token( 8 );
		my $div = $frag->appendChild( $session->make_element( 'div', id => "altmetric_summary_page_$t", class => 'altmetric_summary_page', "data-altmetric-id-type" => $type, "data-altmetric-id" => $id ) );

		my $phr = "default_content";
		if( $session->get_lang->has_phrase( $self->html_phrase_id( $phr ) ) )
		{
			$div->appendChild( $self->html_phrase( $phr, default_link => $session->render_link( "https://www.altmetric.com/details/$type/$id" ) ) );
		}

		$frag->appendChild( $session->make_javascript( <<EOJ ) );
new EP_Altmetric_Badge( 'altmetric_summary_page_$t' );
EOJ

	}
	else
	{
		my $div = $session->make_element( 'div',
			class => 'altmetric-embed',
			"data-$type" => $id,
			( defined $session->config( "altmetric", "badge_attributes" ) ? %{$session->config( "altmetric", "badge_attributes" )} : undef ),
		);
		$frag->appendChild( $div );

		# add Altmetric's embed script
		$frag->appendChild( $self->render_embed_script ) unless $no_embed_js;
	}

	return $frag;
}

sub render_embed_script
{
	my( $self ) = @_;

        my $session = $self->{session};

	my $script = $session->make_element( "script",
		src =>( defined $session->config( "altmetric", "embed_url" )
			? $session->config( "altmetric", "embed_url" )
			: "https://embed.altmetric.com/assets/embed.js"
		),
		type => 'text/javascript',
	);
	return $script;
}

# These methods may be useful if the badge should be 

package EPrints::Script::Compiled;

sub run_altmetric_badge
{
	my( $self, $state, $eprint, $test ) = @_;

	if( !defined $eprint->[0] || ref( $eprint->[0] ) ne "EPrints::DataObj::EPrint" )
	{
		$self->runtime_error( "Can only call altmetric_badge() on eprint objects, not " . ref( $eprint->[0] ) );
	}

	my $processor = EPrints::ScreenProcessor->new(
		session  => $state->{session},
		eprint   => $eprint->[0],
		eprintid => $eprint->[0]->get_id
	);

	my $box = $state->{session}->plugin( "Screen::EPrint::Box::Altmetric", processor => $processor );
	if( !defined $box )
	{
		$self->runtime_error( "Problem creating Screen::EPrint::Box::Altmetric" );
	}

	if( $test )
	{
		return [ 0, "BOOLEAN" ] if( !defined $box || !$box->can_be_viewed );
		return [ 1, "BOOLEAN" ];
	}

	return [ $box->render(1), "XHTML" ]; #don't include embed javascript by default in case this is used on a page that will display multiple badges

}

sub run_altmetric_embed_script
{
	my( $self, $state ) = @_;

	#my $box = $state->{session}->plugin( "Screen::EPrint::Box::Altmetric", processor => $processor );
	#my $box = $state->{session}->plugin( "Screen::EPrint::Box::Altmetric", session => $state->{session} );
	my $box = $state->{session}->plugin( "Screen::EPrint::Box::Altmetric" );

	if( !defined $box )
	{
		$self->runtime_error( "Problem creating Screen::EPrint::Box::Altmetric" );
	}

	return [ $box->render_embed_script, "XHTML" ];
}
1;
