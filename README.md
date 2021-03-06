# Altmetric #

<img align="right" height="200" src="altmetric_example.png">
Display altmetric badges on summary pages. Visit the altmetric web-site for more information: http://www.altmetric.com/

Originally developed by Sébastien François (https://github.com/sebastfr); updated by @drtjmb.
Now maintained by *us* - eprintsug!

**Version 1.2.0**: Adds the repository domain to the link back to Altmetric. This can enable more data to be shown.
See note in z_altmatric.pl for details on how to register your repository domain.

**Version 1.1.0**: Adds ability to use other IDs supported by Altmetric API e.g. ISBN.
The data used from the EPrint is now a config option so repositories can tailor this to suit the data they hold. See cfg.d/z_altmetric.pl.

The attributes used for the rendering have changed to:

* `data-altmetric-id`
* `data-altmetric-id-type`

If you are integrating the Altmetrics using something other than the `EPrints::Plugin::Screen::EPrint::Box::Altmetric` class, 
you will need to change how you render the attributes yourself!
