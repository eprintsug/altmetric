#####################################################################
#
# EPrints::Plugin::Screen::EPMC::Altmetric
#
######################################################################

package EPrints::Plugin::Screen::EPMC::Altmetric;

@ISA = ( 'EPrints::Plugin::Screen::EPMC' );

use strict;

sub new
{
	my( $class, %params ) = @_;

	my $self = $class->SUPER::new( %params );

	$self->{actions} = [qw( enable disable configure )];
	$self->{disable} = 0; # always enabled, even in lib/plugins
	
	$self->{package_name} = "altmetric";

	return $self;
}

# Inherited actions:
# action_enable
# action_disable

sub allow_configure { shift->can_be_viewed( @_ ) }

=item action_configure

Allow editing of the config file. Useful for adding API key.

=cut

sub action_configure
{
	my( $self ) = @_;

	my $epm = $self->{processor}->{dataobj};
	my $epmid = $epm->id;

	foreach my $file ($epm->installed_files)
	{
		my $filename = $file->value( "filename" );
		next if $filename !~ m#^epm/$epmid/cfg/cfg\.d/(.*)#;
		my $url = $self->{repository}->current_url( host => 1 );
		$url->query_form(
			screen => "Admin::Config::View::Perl",
			configfile => "cfg.d/$1",
		);
		$self->{repository}->redirect( $url );
		exit( 0 );
	}

	$self->{processor}->{screenid} = "Admin::EPM";

	$self->{processor}->add_message( "error", $self->html_phrase( "missing" ) );
}

1;
