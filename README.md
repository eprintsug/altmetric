# Altmetric #

<img align="right" height="200" src="altmetric_example.png">
Display altmetric badges on summary pages. Visit the altmetric web-site for more information: http://www.altmetric.com/

This plugin should work out-of-the-box. 

There are some configuration options available, these are detailed in the z_altmetric.pl file.

Originally developed by Sébastien François (https://github.com/sebastfr); updated by @drtjmb.
Now maintained by *us* - eprintsug!

## Version history ##

### Version 2.0.0
- Updates description of some sources (twitter -> X) and adds new sources (Bluesky)
- Improve accessibility by removing CSS before/after text
- Renders details panel on server, allowing phrases to be used for better internationalisation
- Uses `JSON` module to output content
- Uses `EPrints::DOI` module if available when getting DOI from eprint


See https://details-page-api-docs.altmetric.com/data-endpoints-counts.html#response-object and
 https://help.altmetric.com/support/solutions/folders/6000237990 for details of 'cited by' data.


### Version 1.3.0 (not released as an EPM) ###
- Adds user-agent in request made to Altmetric API
- Displays default phrase (supports multiple languages) with link to Altmetric site before badge is displayed. See the [altmetric.xml phrase file](lib/lang/en/phrases/altmetric.xml#L9).
- Above phrase is also used when the badge is displayed 
- If there is no Altmetric-supported identifier in the record, the EPrints Box is not rendered

If you add internationalised phrases to your repository and they don't appear to work, make sure the 'auto' javascript file has been reloaded.

### Version 1.2.0 ###
Adds the repository domain to the link back to Altmetric. This can enable more data to be shown.
See note in z_altmetric.pl for details on how to register your repository domain.

### Version 1.1.0 ###
Adds ability to use other IDs supported by Altmetric API e.g. ISBN.
The data used from the EPrint is now a config option so repositories can tailor this to suit the data they hold. See cfg.d/z_altmetric.pl.

The attributes used for the rendering have changed to:

* `data-altmetric-id`
* `data-altmetric-id-type`

If you are integrating the Altmetrics using something other than the `EPrints::Plugin::Screen::EPrint::Box::Altmetric` class, 
you will need to change how you render the attributes yourself!

## Displaying Altmetric data without using this plugin ##

The Altmetric team also provide a wrapper script that can be used to add Altmetric badges to your pages. Details are provided
on their support site: https://help.altmetric.com/support/solutions/articles/6000241753-adding-badges-in-eprints
