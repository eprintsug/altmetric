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
        my( $self ) = @_;

        my $session = $self->{session};

        my $frag = $session->xml->create_document_fragment;

        my ( $type, $id ) = $session->call( [ "altmetric", "get_type_and_id" ], $self->{processor}->{eprint} );

        return $frag if ( !defined $type || !defined $id );

	# If an API key has been defined, use the API (via local cgi) method to render the data.
	# If there is no API key, fall back to the Altmetric embed javascript method.

	if( defined $session->config( "altmetric", "api_key" ) )
	{
        	my $div = $frag->appendChild( $session->make_element( 'div', id => 'altmetric_summary_page', "data-altmetric-id-type" => $type, "data-altmetric-id" => $id ) );

		my $phr = "default_content";
		if( $session->get_lang->has_phrase( $self->html_phrase_id( $phr ) ) )
		{
			$div->appendChild( $self->html_phrase( $phr, default_link => $session->render_link( "https://www.altmetric.com/details/$type/$id" ) ) );
		}

		$frag->appendChild( $session->make_javascript( <<EOJ ) );
new EP_Altmetric_Badge( 'altmetric_summary_page' );
EOJ

	}
	else
	{
        	my $div = $session->make_element( 'div',
			id => 'altmetric_summary_page',
			"data-altmetric-id-type" => $type,
			"data-altmetric-id" => $id,
			( defined $session->config( "altmetric", "badge_attributes" ) ? %{$session->config( "altmetric", "badge_attributes" )} : undef ),
		);
		$frag->appendChild( $div );

		my $script = $session->make_element( "script",
                        src =>( defined $session->config( "altmetric", "embed_url" )
                                ? $session->config( "altmetric", "embed_url" )
                                : "https://embed.altmetric.com/assets/embed.js"
                        ),
                        type => 'text/javascript',
                );
                $frag->appendChild( $script );
	}

        return $frag;
}

1;
