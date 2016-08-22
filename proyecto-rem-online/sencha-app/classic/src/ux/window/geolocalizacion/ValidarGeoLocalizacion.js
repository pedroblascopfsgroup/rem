/**
 */
Ext.define('HreRem.ux.window.geolocalizacion.ValidarGeoLocalizacion', {
    extend		: 'HreRem.view.common.WindowBase',
    alias: 'widget.uxvalidargeolocalizacion',    
    requires: ['HreRem.ux.window.geolocalizacion.GeolocalizacionController', 'HreRem.ux.window.geolocalizacion.GeolocalizacionModel'],
    layout: 'fit',
    width	: Ext.Element.getViewportWidth() /1.2,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'validargeolocalizacionwindowref',
    controller: 'geolocalizacion',
    viewModel: {
        type: 'geolocalizacion'
    },
    closable: true,
    
    listeners: {
    	
    	destroy: function() {
    		var me = this;
    		me.gmapPanel.destroy();
    		me.coordenadasPanel.destroy();    		
    	}
    },
    
    /**
     * Info que podemos recibir al abrir la ventana
     * @type 
     */
    geoCodeAddr: null,
    
    /**
     * Info que podemos recibir al abrir la ventana
     */
    latLng: null,
    
    
    initComponent: function() {
    	var me = this,
    	center = null,
    	marker = {
            draggable: true,
            listeners: {
            	dragstart: function() {
            		me.actualizaDireccion("");
            		me.coordenadasPanel.setStyle("opacity", "0.5");
            	},
            	drag: function(marker) {
					me.actualizaPosicion(marker.latLng)								
            	},
            	dragend: function(marker) {
            		me.geocodePosition(marker.latLng);
            		me.coordenadasPanel.setStyle("opacity", "1");
            	}
            	
            	
            }
        };
    	
    	me.setTitle(HreRem.i18n('title.verificacion.direccion'));
    	
    	if(RemValidations.latValidation(me.latLng.latitud) && RemValidations.lngValidation(me.latLng.longitud)) {
    		center = new google.maps.LatLng(me.latLng.latitud, me.latLng.longitud);
    	} else {
	    	center =  {
			            geoCodeAddr: me.geoCodeAddr,
			            marker: marker
			};
    	}
    	
    	me.gmapPanel = Ext.create('HreRem.ux.panel.GMapPanel', {
		        gmapType: 'map',
		        center: center,
		        mapOptions : {
		        	zoom: 15,
		        	mapTypeId: google.maps.MapTypeId.ROADMAP
		        },
		        listeners: {
		        	mapready: function(gmap, map) {
		        		me.addSearchBox(gmap, map);
		        		me.actualizaPosicion(map.getCenter());
		        		me.actualizaDireccion(me.geoCodeAddr);
		        		map.addListener('dragstart', function() {
							me.coordenadasPanel.setStyle("opacity", "0.5");
						});
						map.addListener('dragend', function() {
							me.coordenadasPanel.setStyle("opacity", "1");
						});
						if(Ext.isEmpty(center.marker)) {
							marker.position = map.getCenter();
							gmap.addMarker(marker);
							me.geocodePosition(map.getCenter());
						}
		        		
		        	}
		        	
		        }
		});
		
		
		me.coordenadasPanel= Ext.create('Ext.form.Panel',{
			cls: 'panel-base panel-coordenadas',
			floating: true,
			alwaysOnTop: true,
			bodyPadding: 5,
			width: 250,
			height: 350,
		    layout: 'anchor',
		    defaults: {
		       anchor: '100%',
		       labelAlign: 'top'
		    },
		    defaultType: 'textfield',
			items: [
			    	{
				    	reference: 'fieldlatitud',
				    	readOnly: true,
				        fieldLabel: 'Latitud',
				        bind: '{latitud}'
			    	},{
				        reference: 'fieldlongitud',
				        readOnly: true,
				        fieldLabel: 'Longitud',
				        bind: '{longitud}'
			        
			    	},{
				        xtype: 'textarea',
				        readOnly: true,
				        height: 30,
				        reference: 'fieldDireccionCoincidente',
				        fieldLabel: 'Direccion coincidente más cercana',
				        width: 200,
				        bind: '{direccion}'			        
			    	},
				    {
				    	xtype: 'label',
				    	html: '<span class="title-aviso-red">'+HreRem.i18n('txt.aviso').toUpperCase()+'</span><br><span>'+HreRem.i18n('txt.aviso.mapa.cambio.direccion')+'</span>' 
				    }
			],
			    buttons: [{
			        text: HreRem.i18n('btn.validar'),
			        handler: 'onClickGuardarCoordenadas'
			    }]
		});
		
		me.items=[me.gmapPanel,me.coordenadasPanel];		

    	me.callParent();
			
    	me.coordenadasPanel.showAt(0,50);
    },
    
    actualizaPosicion: function(posicion) {
    	
    	var me = this;    	
    	me.getViewModel().set("latitud",posicion.lat());
    	me.getViewModel().set("longitud",posicion.lng());
    	
    },
    
    actualizaDireccion: function(direccion) {
    	var me = this;
    	me.getViewModel().set("direccion", direccion);
    },
    
    addSearchBox: function(gmap,map) {
    	var me = this,    		        		
		input = "";
		gmap.body.insertHtml("beforeBegin", "<input id='pac-input' class='gmap-search-box' type='text' placeholder='Buscar dirección ....'>"); 
		input = document.getElementById('pac-input');
		me.searchBoxField = new google.maps.places.SearchBox(input);
		map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

		map.addListener('bounds_changed', function() {
			me.searchBoxField.setBounds(me.getMap().getBounds());
		});
		
		me.searchBoxField.addListener('places_changed', function(a,b,c) {
		    var places = me.searchBoxField.getPlaces();		
		    if (places.length == 0) {
		      return;
		    } 
		    me.reloadMap(places[0].geometry.location);
		    me.actualizaPosicion(places[0].geometry.location);
		    me.actualizaDireccion(places[0].formatted_address);		    
		});
    },
  	
  	geocodePosition: function (pos) {
  		var me = this;
  		
  		if(Ext.isEmpty(me.gmapPanel.geocoder)) {  			  		
  			me.gmapPanel.geocoder = new google.maps.Geocoder();
  		}

	  	me.gmapPanel.geocoder.geocode({latLng: pos}, function(responses) {
			    
			    if (responses && responses.length > 0) {
			      me.actualizaDireccion(responses[0].formatted_address);
			    } else {
			      me.actualizaDireccion(HreRem.i18n("txt.aviso.direcion.sin.determinar"));
			    }
		});
  	},
  	
  	getMap: function() {
  		
  		var me = this;  		
  		return  me.gmapPanel.gmap;
  	},
  	
  	reloadMap: function(location) {
  		var me = this; 		
  		var marker = me.refreshMarker(location);  		
  		me.gmapPanel.createMap(location, marker);
  	},
  	refreshMarker: function(location) {
  		
  		var me = this,
  		marker =  null;
  		
  		if(!Ext.isEmpty(me.gmapPanel.center) && !Ext.isEmpty(me.gmapPanel.center.marker)) {
  			marker = me.gmapPanel.center.marker; 
  			marker.position = location;
  		} 		
  		
  		return marker; 		
  		
  	}

    
});