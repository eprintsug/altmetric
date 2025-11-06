var EP_Altmetric_Badge = Class.create( {

	initialize: function(id) {

		if( id == null )
			return;

		this.element = $( id );
		if( this.element == null )
			return;

		this.altmetric_id = this.element.getAttribute( 'data-altmetric-id' );
		this.altmetric_id_type = this.element.getAttribute( 'data-altmetric-id-type' );
		
		if( this.altmetric_id == null || this.altmetric_id_type == null )
			return;

		this.callback();
	},

	callback: function() {
		new Ajax.Request( eprints_http_cgiroot + "/altmetric?id_type=" + this.altmetric_id_type + "&id=" + this.altmetric_id, {
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

		// get link text displayed before it is replaced by the badge (or use a default value)
		var linktext = this.element.innerHTML.stripTags().strip().replace(/\n/g,' ').replace(/\s+/g,' ') || "View details on Altmetric's website";

		// v2 returns 'html' value
		if( json.html != null )
		{
			this.element.update( json.html );
		}
		else
		{
			// pre-v2 way of doing things. This has been left in case people have a local copy of the cgi script
			var img = new Element( 'img', { 'src': json.images.medium, 'class': 'altmetric_donut' } );
	
			this.element.update( img );

			var details_panel = new Element( 'div', { 'class': 'altmetric_details_panel' } );
			this.element.insert( details_panel );

			/* From: https://api.altmetric.com/data-endpoints-counts.html#response-object, 'cited_by_[ ]_counts' available are:
			  posts (combined total of below)
			  fbwalls, feeds, gplus, msm, rdts, qna, tweeters, bluesky, wikipedia, policies, guidelines, patents, videos
			  Any of the above can be added to the array below.
			*/
			var types = [ 'fbwalls','feeds','gplus','msm','rdts','qna','tweeters','bluesky','wikipedia','policies','guidelines','patents','videos' ];
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
			// RM removed as connotea was discontinued in 2013
			// 'connotea',
			var readers = [ 'mendeley','citeulike' ];
			data = new Hash( json.readers );

			for( var i=0; i < readers.length; i++ )
			{
				var value = data.get( readers[i] );
				if( ( value != null ) && ( value != 0 ) )
				{
					var row = new Element( 'div', { 'class': 'altmetric_row altmetric_' + readers[i] } );
					var figure = new Element( 'span' );
					figure.update( value );
					row.update( figure );
					details_panel.insert( row );
				}
			}

		} //end html else
		
		var altlink = new Element( 'a', { 'href': json.details_url + '&domain=' + document.domain, 'class': 'altmetric_details', 'target': '_blank' } );
		altlink.update( linktext );
		
		this.element.insert( new Element( 'div', { 'style' : 'clear:both' } ) );

		this.element.insert( altlink );
	},

} );
