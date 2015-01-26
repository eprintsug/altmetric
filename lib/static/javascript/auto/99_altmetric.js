var EP_Altmetric_Badge = Class.create( {

        initialize: function(id) {

		if( id == null )
			return;

		this.element = $( id );
		if( this.element == null )
			return;

		this.doi = this.element.getAttribute( 'data-doi' );

		if( this.doi == null )
			return;

		this.callback();
        },

	callback: function() {

                new Ajax.Request( eprints_http_cgiroot + "/altmetric?doi=" + this.doi, {
                                method: 'get',
                                onSuccess: this.draw.bind(this),
                                onFailure: function(response) {  }.bind(this) 
                }); 
	},

	draw: function(response) {

                var json = response.responseText.evalJSON();

		if( json.error != null && json.error )
		{
			var errp = new Element( 'p', { 'class': 'altmetric_error' } );
			errp.update( json.message );
			this.element.update( errp );
			return;
		}

		var img = new Element( 'img', { 'src': json.images.medium, 'class': 'altmetric_donut' } );
	
		this.element.update( img ); 

		var details_panel = new Element( 'div', { 'class': 'altmetric_details_panel' } );
		this.element.insert( details_panel );

		// TODO: add 'delicious', 'forum'
		var types = [ 'tweeters', 'rdts', 'feeds', 'gplus', 'msm', 'fbwalls', 'videos' ];
		var data = new Hash( json );

		for( var i=0; i < types.length; i++ )
		{
			var value = data.get( "cited_by_" + types[i] + "_count" );
			if( value != null )
			{
				var row = new Element( 'div', { 'class': 'altmetric_row altmetric_' + types[i] } );
				var figure = new Element( 'span' );
				figure.update( value );
				row.update( figure );
				details_panel.insert( row );
			}
		}

		details_panel.insert( new Element( 'br' ) );

		var readers = [ 'mendeley', 'connotea', 'citeulike' ];
		data = new Hash( json.readers );
	
		for( var i=0; i < readers.length; i++ )
		{
			var value = data.get( readers[i] );
			if( value != null )
			{
				var row = new Element( 'div', { 'class': 'altmetric_row altmetric_' + readers[i] } );
				var figure = new Element( 'span' );
				figure.update( value );
				row.update( figure );
				details_panel.insert( row );
			}
		}
		
		var altlink = new Element( 'a', { 'href': json.details_url, 'class': 'altmetric_details', 'target': '_blank' } );
		altlink.update( "View details on Altmetric's website" );
		
		this.element.insert( new Element( 'div', { 'style' : 'clear:both' } ) );

		this.element.insert( altlink );
	},

} );
