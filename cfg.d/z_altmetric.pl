### Altmetric Summary Page Widget
# November 2025
# Altmetric are now requiring a key when calling the API.
# This extension has been re-written to use API-based methods if a key is defined, but
# fall back to the embedded badges if not.
#
# ----------
#
# For the Altmetric badges to work properly you need to contact support@altmetric.com 
# and give them the domain your IR is hosted on.
# If you skip this step users may not see the full details for each article
#   e.g. only the most recent tweets or likes may be shown.
#
########################################################################################


# API key - see http://api.altmetric.com/index.html#keys
#$c->{altmetric}->{api_key} = "";

# Enable the widget
$c->{plugins}{"Screen::EPrint::Box::Altmetric"}{params}{disable} = 0;

# Position
$c->{plugins}->{"Screen::EPrint::Box::Altmetric"}->{appears}->{summary_bottom} = 25;
$c->{plugins}->{"Screen::EPrint::Box::Altmetric"}->{appears}->{summary_right} = undef;

# If you are not using an API key, these are the attributes that will be used for the badge display.
# Please see: https://badge-docs.altmetric.com/customizations.html#data-attributes, or try the
# 'Badge generator': https://badge-docs.altmetric.com/badge-playground.html and copy the attributes
# into this hash.
#
# The plugin will handle the identifier attribute (data-doi, data-isbn, data-arxiv-id etc.)
$c->{altmetric}->{badge_attributes} = {
	'data-badge-type'    => 'donut',
	'data-badge-details' => 'right',
	'data-condensed'     => 'true'.
};


# Altmetric API URL
$c->{altmetric}->{base_url} = "https://api.altmetric.com/v1";

# Altmetric Embed URL (only used when API key is not set)
# There is a default value for this in the rendered box. If a different URL was needed
# this can be defined here:
# $c->{altmetric}->{embed_url} = "https://embed.altmetric.com/assets/embed.js";


# These are the id_types we support. If the get_type_and_id function below will return other things
# please add them to a config option:
# $c->{altmetric}->{allowed_types} = [ 'doi', 'isbn' ];

# If you want to change the order that the Altmetric sources are displayed in, or omit a source, 
# you can define the following config option (and change the order or remove members of it):
# $c->{altmetric}->{sources} = [qw / fbwalls feeds gplus msm rdts qna tweeters bluesky wikipedia policies guidelines patents videos / ];
#
# To change the text used to describe a source, please see the altmetric phrases file.

# Function to return id type and id.
# For supported id_types, check the Altmetrics API reference
# Currently their API supports: doi, isbn, arXivID, PMID, ads and uri.
# If an Eprints has multiple usable identifiers, the first returned value will be used.
$c->{altmetric}{get_type_and_id} = sub {
	my( $eprint ) = @_;

	# recent-ish addition to EPrints core
	my $use_ep_doi = eval "require EPrints::DOI" || 0;

	if( $eprint->exists_and_set( "doi" ) ){
		if( $use_ep_doi )
		{
			my $doi = EPrints::DOI->parse( $eprint->value( "doi" ) );
			return( "doi", $doi->to_string( noprefix => 1 ) ) if $doi;
		}
		else
		{
			return( "doi", $eprint->value( "doi" ) );
		}
	}

	if( $eprint->exists_and_set( "isbn" ) ){
		return( "isbn", $eprint->value( "isbn" ) );
	}

	# id_numbers that have 10. in them (rudimentary doi check)
	if( $eprint->exists_and_set( "id_number" ) )
	{
		# use a good check if possible
		if( $use_ep_doi )
		{
			my $doi = EPrints::DOI->parse( $eprint->value( "id_number" ) );
			return( "doi", $doi->to_string( noprefix => 1 ) ) if $doi;
		}
		# or a rudimentary check if necessary	
		elsif( $eprint->value( "id_number" ) =~ /\b10./ ){
			return( "doi", $eprint->value( "id_number" ) );
		}
	}

	#other fields could be checked and returned here.
};
