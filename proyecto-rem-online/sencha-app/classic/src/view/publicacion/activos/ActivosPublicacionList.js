Ext.define('HreRem.view.publicacion.activos.ActivosPublicacionList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'activospublicacionlist',
	bind: {
		store: '{activospublicacion}'
	},
	
    initComponent: function () {
     	
     	var me = this;
     	me.setTitle(HreRem.i18n('title.publicaciones.activos.comercializables.grid'));
	    me.listeners = {	    	
			rowdblclick: 'onActivosPublicacionListDobleClick'
	    };
	    var estadoRenderer =  function(value) {
        	var src = '',
        	alt = '',
        	valor = (value == "true");
        	
        	if (valor) {
        		src = 'icono_OK.svg';
        		alt = 'OK';
        	} else { 
        		src = 'icono_KO.svg';
        		alt = 'KO';
        	} 

        	return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        };  
	    me.columns = [
	    
		        {
	            	text	 : HreRem.i18n('header.activos.publicacion.numActivo'),
	                flex	 : 1,
	                dataIndex: 'numActivo'
	            },
	            {
	            	text	 : HreRem.i18n('header.activos.publicacion.tipo'),
	                flex	 : 1,
	                dataIndex: 'tipoActivoDescripcion'
	            },
	            {
	            	text	 : HreRem.i18n('header.activos.publicacion.subtipo'),
	                flex	 : 1,
	                dataIndex: 'subtipoActivoDescripcion'
	            },
		        {
	            	text	 : HreRem.i18n('header.activos.publicacion.direccion'),
	                flex	 : 1,
	                dataIndex: 'direccion'
	            },
	            {
		            text: HreRem.i18n('header.activos.estado.publicacion'),           
		            flex: 1,
		            dataIndex: 'estadoPublicacionDescripcion'
		        },
		        {
		            text: HreRem.i18n('header.activos.publicacion.admision'),
		            renderer: estadoRenderer,	           
		            flex: 0.5,
		            dataIndex: 'admision',
		            align: 'center'
		        },
		        {
		            text: HreRem.i18n('header.activos.publicacion.gestion'),
		            renderer: estadoRenderer,	           
		            flex: 0.5,
		            dataIndex: 'gestion',
		            align: 'center'
		        },
		        {
		            text: HreRem.i18n('header.activos.publicacion.publicacion.venta'),
		            renderer: estadoRenderer,	           
		            flex: 0.5,
		            dataIndex: 'okventa',
		            align: 'center'
		        },
		        {
		            text: HreRem.i18n('header.activos.publicacion.publicacion.alquiler'),
		            renderer: estadoRenderer,	           
		            flex: 0.5,
		            dataIndex: 'okalquiler',
		            align: 'center'
		        },
		        {
		            text: HreRem.i18n('header.activos.publicacion.precio'),
		            renderer: estadoRenderer,	           
		            flex: 0.5,
		            dataIndex: 'precio',
		            align: 'center'
		        }
	        ];
	        
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPublicacionPaginationToolbar',
	            displayInfo: true,
	            bind: {
	                store: '{activospublicacion}'
	            }
	        }
	    ];
	    
	    me.callParent();
	    
    }
    
});