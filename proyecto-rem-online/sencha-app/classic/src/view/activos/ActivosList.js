Ext.define('HreRem.view.activos.ActivosList', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'activoslist',
	requires: ['HreRem.ux.panel.GMapPanel'],	
	
    bind: {
        store: '{activos}'
    },
    loadAfterBind: false,
    
    initComponent: function () {
     	
     	var me = this;
     	
     	var estadoRenderer =  function(value) {
        	
        	var src = '',
        	alt = '';
        	
        	if (value) {
        		src = 'icono_OK.svg';
        		alt = 'OK';
        	} else { 
        		src = 'icono_KO.svg';
        		alt = 'KO';
        	} 

        	return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        }; 
        
 
        
        var carteraRenderer =  function(value) {
        	var src = CONST.IMAGENES_CARTERA[value.toUpperCase()],
        	alt = value;
        	if(Ext.isEmpty(src)) {
        		return '<div class="min-text-logo-cartera">'+value.toUpperCase()+'</div>';	
        	}else {
        		return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="50px"></div>';
        	}
        };
     	
     	me.setTitle(HreRem.i18n('title.activos'));
 		me.ventanaImagen = Ext.create('Ext.window.Window', {
	        cls: 'activoslist-imgactivo-window',
	        header: false,
		    height: 200,
		    width: 300,
		    resizable: false,
		    layout: 'fit',
		    items: { 
		        xtype: 'image',
		        alt: 'Imagen Activo',
		        cls: 'activoslist-imgactivo-img'
		    }
		});
		
		me.ventanaMapa = Ext.create('Ext.window.Window', {
	        cls: 'activoslist-mapactivo-window',	        
		    height: 200,
		    width: 300,
		    resizable: false,
		    layout: 'fit',
		    closeAction: 'hide'
		}).show().hide();
		
		me.gmapConfig = {
			xtype: 'uxgmappanel',
	        gmapType: 'map',
	        center: {},
	        mapOptions : {
	        	disableDefaultUI: true,
	            mapTypeId: google.maps.MapTypeId.ROADMAP,
	            zoom: 16
	        },
	        listeners: {
	        	mapready: function(gmap, map) {
					if(!Ext.isEmpty(map.center) && !Ext.isEmpty(map.center.marker)){
						gmap.addMarker(map.center.marker);
					}	        		
	        	}	        	
	        }
		},	
		
		me.listeners = {
			// Listener para el doble click en la lista de activos
			rowdblclick: 'onActivosListDobleClick',
			
			// Listener para el mostrar la imagen del activo en el over del icono
			itemmouseenter: function( view, rec, item, index, e, eOpts ) {
				if (e.position.colIdx == 0) {
					var row = Ext.fly(view.getRow(rec));
					me.ventanaImagen.down('image').setSrc('/pfs/activo/getFotoPrincipalById.htm?id=' + rec.get("id"));
					me.ventanaImagen.setPosition(row.getX()+15, row.getY() - 210);
					me.ventanaImagen.show();
					me.ventanaMapa.hide();
					
				}
			},
			itemmouseleave: function( view, rec, item, index, e, eOpts ) {
					me.ventanaImagen.hide();
				
			}
	
	    };
	    
		me.columns = [		 

		        {
			        xtype: 'actioncolumn',
			        width: 30,	
			        hideable: false,
			        items: [{
			           	iconCls: 'app-activos-list-ico ico-camara'
			        }]
	    		} ,
	    		
	    		{
			        xtype: 'actioncolumn',
			        width: 30,
					hideable: false,
					items: [
					        	{
						            getClass: function(v, meta, rec) {
						                if (Ext.isEmpty(rec.get('tokenGmaps'))) {
						                    return 'app-activos-list-ico ico-ubicacion-no';
						                } else {
						                    this.items[0].handler = function(grid, rowIndex, colIndex, item, e, rec) {
						                    	me.ventanaImagen.hide();
							                 	var token = rec.get("tokenGmaps");
							                 	var latitud = rec.get("latitud");
							                 	var longitud = rec.get("longitud");
							                 	var title = "Activo " + rec.get("numActivo");
							                 	var gmap = Ext.create('HreRem.ux.panel.GMapPanel', me.gmapConfig);	
							                 	me.ventanaMapa.removeAll();
							                 	me.ventanaMapa.show();							                 								                 	
							                 	gmap.configurarMapa(latitud, longitud, token, title);
							                 	me.ventanaMapa.add(gmap);
												me.ventanaMapa.setPosition(e.getX()+15, e.getY() - 210);													
												
			                    
				            				};
						                    return 'app-activos-list-ico ico-ubicacion';
						                }
						            }
					        	}
					 ]
	    		},  		
	    		
		        {
		        	
		            dataIndex: 'numActivo',
		            text: HreRem.i18n('header.numero.activo.haya'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'tipoActivoDescripcion',
		            text: HreRem.i18n('header.tipo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'subtipoActivoDescripcion',
		            text: HreRem.i18n('header.subtipo'),
		            flex: 1
		        },
		        {
		            dataIndex: 'entidadPropietariaDescripcion',
		            text: HreRem.i18n('header.entidad.propietaria'),
		            width: 70,
		            renderer: carteraRenderer
		        },
		        {
		            dataIndex: 'tipoTituloActivoDescripcion',
		            text: HreRem.i18n('header.origen'),
		            flex: 1
		        },
		        {
		            dataIndex: 'nombreVia',
		            text: HreRem.i18n('header.via'),
		            flex: 1,
		            renderer: function(value, cell, record) {

		            	var tipoVia = record.get("tipoVia");
		            	if(!Ext.isEmpty(tipoVia)) {
		            		return value + ", " + Ext.util.Format.capitalize(data.tipoVia.descripcion.toLowerCase())
		            	}
		            	return value
		            }
		        },
		        {
		            dataIndex: 'localidadDescripcion',
		            text: HreRem.i18n('header.municipio'),
		            flex: 1
		        },
		        {
		            dataIndex: 'provinciaDescripcion',
		            text: HreRem.i18n('header.provincia'),
		            flex: 1
		        },
		        {
		            dataIndex: 'codPostal',
		            text: HreRem.i18n('header.codigo.postal'),
		            flex: 0.5           
		        },
		        {
		            text: HreRem.i18n('header.dpto.comercial'),
		            flex: 0.5,
		            dataIndex: 'situacionComercial'
		        },
		        {
		            text: HreRem.i18n('header.dpto.admision'),
		            renderer: estadoRenderer,	           
		            flex: 0.5,
		            dataIndex: 'admision',
		            align: 'center'
		        },
		        {
		            text: HreRem.i18n('header.dpto.gestion'),
		            renderer: estadoRenderer,
		            flex: 0.5,
		            dataIndex: 'gestion',
		            align: 'center'
		        },
		        {
					dataIndex: 'selloCalidad',
		            text     : HreRem.i18n('header.dpto.calidad'),
		            flex     : 0.5,            
		            align: 'center',
		            renderer: function(value) {
		            	if(value) 
		            	return '<div> <img src="resources/images/sello_calidad_grid.svg" alt="Rating" width="20px"></div>';	
		            }
		        },	
		        {
		        	dataIndex: 'flagRating',
		            text     : HreRem.i18n('header.rating'),
		            flex     : 0.5,            
		            align: 'center',
		            renderer: function(value) {
		            	if(!Ext.isEmpty(value) && value != 0) 
		            	return '<div> <img src="resources/images/rating_'+value+'_listado.svg" alt="Rating" width="20px"></div>';	
		            }
		        }
		
		    ];
		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{activos}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   },
   
   closeWindows: function() {
   	
   		var me = this; 
   		
   		me.ventanaImagen.hide();
		me.ventanaMapa.hide();
   	
   }
});