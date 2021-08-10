package EPrints::Plugin::Screen::EPrint::Box::Altmetric;

our @ISA = ( 'EPrints::Plugin::Screen::EPrint::Box' );

use strict;

sub can_be_viewed
{
        my( $self ) = @_;

        return 0 if( !defined $self->{processor}->{eprint} );
        return 0 if( !$self->{session}->can_call( "altmetric", "get_type_and_id" ) );
		
        return 1;
}

sub render
{
        my( $self ) = @_;

        my $session = $self->{session};

        my $frag = $session->xml->create_document_fragment;

        my ( $type, $id ) = $session->call( [ "altmetric", "get_type_and_id" ], $self->{processor}->{eprint} );

        return $frag if ( !defined $type || !defined $id );
		
        my $div = $frag->appendChild( $session->make_element( 'div', id => 'altmetric_summary_page', "data-altmetric-id-type" => $type, "data-altmetric-id" => $id ) );

		$frag->appendChild( $session->make_javascript( <<EOJ ) );
new EP_Altmetric_Badge( 'altmetric_summary_page' );
EOJ

        return $frag;
}

1;
