Ext.define('HreRem.view.precios.historico.HistoricoPropuestaActivosList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'historicopropuestaactivoslist',

    bind: {
        store: '{activosPropuesta}'
    },
    loadAfterBind: false,
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.detalle.activos.propuesta'));
        
        me.listeners = {	    	
    			rowdblclick: 'onHistoricoActivosListDobleClick'
    	    };
        
        me.columns= [
        
		        {	        	
		            dataIndex: 'numActivo',
		            text: HreRem.i18n('header.numero.activo.haya'),
		            flex: 1		        	
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
		            dataIndex: 'direccion',
		            text: HreRem.i18n('header.direccion'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'municipio',
		            text: HreRem.i18n('header.municipio'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'codigoPostal',
		            text: HreRem.i18n('header.codigo.postal'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'provincia',
		            text: HreRem.i18n('header.provincia'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'descripcionEstadoActivo',
		            text: HreRem.i18n('header.estado'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'motivoDescarte',
		            text: HreRem.i18n('header.motivo.descarte'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'precioMinimoAutorizado',
		            text: HreRem.i18n('header.precio.minimo.autorizado'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'precioAprobadoVenta',
		            text: HreRem.i18n('header.precio.aprobado.venta'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'precioAprobadoRenta',
		            text: HreRem.i18n('header.precio.apobado.renta'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'precioDescuentoAprobado',
		            text: HreRem.i18n('header.precio.descuento.autorizado'),
		            flex: 1
		        },
		        {	        	
		            dataIndex: 'precioDescuentoPublicado',
		            text: HreRem.i18n('header.precio.descuento.publicado'),
		            flex: 1
		        }
        ];
        
        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPropuestaPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{activosPropuesta}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    }


});

