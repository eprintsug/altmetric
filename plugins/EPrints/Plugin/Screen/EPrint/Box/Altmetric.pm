package EPrints::Plugin::Screen::EPrint::Box::Altmetric;

our @ISA = ( 'EPrints::Plugin::Screen::EPrint::Box' );

use strict;

sub can_be_viewed
{
        my( $self ) = @_;

        return 0 if $self->{session}->get_secure;

        return 0 if( !defined $self->{processor}->{eprint} || !$self->{processor}->{eprint}->exists_and_set( 'id_number' ) );

        return 1;
}

sub render
{
        my( $self ) = @_;

        my $session = $self->{session};
        my $eprint = $self->{processor}->{eprint};

	my $frag = $session->xml->create_document_fragment;

        my $div = $frag->appendChild( $session->make_element( 'div', id => 'altmetric_summary_page', "data-doi" => $eprint->value( 'id_number' ) ) );

	$frag->appendChild( $session->make_javascript( <<EOJ ) );
new EP_Altmetric_Badge( 'altmetric_summary_page' );
EOJ

	return $frag;
}

1;
