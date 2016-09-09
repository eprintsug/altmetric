### Altmetric Summary Page Widget

# Enable the widget
$c->{plugins}{"Screen::EPrint::Box::Altmetric"}{params}{disable} = 0;

# Position
$c->{plugins}->{"Screen::EPrint::Box::Altmetric"}->{appears}->{summary_bottom} = 25;
$c->{plugins}->{"Screen::EPrint::Box::Altmetric"}->{appears}->{summary_right} = undef;

# Altmetric API URL
$c->{altmetric}->{base_url} = "http://api.altmetric.com/v1";

# Optional API key - see http://api.altmetric.com/index.html#keys
# $c->{altmetric}->{api_key} = "";

# Function to return id type and id.
# For supported id_types, check the Altmetrics API reference
# Currently, this supports doi, isbn, arXivID, PMID, ads and uri.
# If an Eprints has multiple usable identifiers, the first returned value will be used.
$c->{altmetric}{get_type_and_id} = sub {
        my( $eprint ) = @_;

        if( $eprint->exists_and_set( "doi" ) ){
                return( "doi", $eprint->value( "doi" ) );
        }
        if( $eprint->exists_and_set( "isbn" ) ){
                return( "isbn", $eprint->value( "isbn" ) );
        }

		# id_numbers that have 10. in them (rudimentary doi check)
        if( $eprint->exists_and_set( "id_number" ) && ( $eprint->value( "id_number" ) =~ /\b10./ ) ){
		        
                return( "doi", $eprint->value( "id_number" ) );	
		}

		#other fields could be checked and returned here.
};
