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

