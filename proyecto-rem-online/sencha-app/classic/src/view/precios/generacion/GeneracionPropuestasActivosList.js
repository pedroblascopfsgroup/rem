Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasActivosList', {
	extend		: 'HreRem.view.common.GridBase',
    xtype		: 'generacionpropuestasactivoslist',

    bind: {
        store: '{activos}'
    },
    
    loadAfterBind: false,
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.detalle.activos.preciar.repreciar'));
        
        me.columns= [
        
		        {	        	
		            dataIndex: 'numActivo',
		            text: HreRem.i18n('header.numero.activo.haya'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'entidadPropietariaDescripcion',
		            text: HreRem.i18n('header.cartera'),
		            flex: 1		        	
		        },
		        {
		        	dataIndex: 'estadoFisicoCodigo',
		        	text: HreRem.i18n('header.estado'),
		        	hidden: true
		        },
		        {	        	
		            dataIndex: 'tipoActivoDescripcion',
		            text: HreRem.i18n('header.tipo'),
		            flex: 1,
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'subtipoActivoDescripcion',
		            text: HreRem.i18n('header.subtipo'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'direccion',
		            text: HreRem.i18n('header.direccion'),
		            flex: 1.5,
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'municipio',
		            text: HreRem.i18n('header.municipio'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'codigoPostal',
		            text: HreRem.i18n('header.codigo.postal'),
		            flex: 1,
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'provincia',
		            text: HreRem.i18n('header.provincia'),
		            flex: 1,
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'conPosesion',
		            text: HreRem.i18n('header.con.posesion'),
		            flex: 1,
		            hidden: true,
		            renderer: Utils.rendererNumberToSiNo
		        },
		        {	        	
		            dataIndex: 'conCargas',
		            text: HreRem.i18n('header.con.cargas'),
		            flex: 1,
		            hidden: true,
		            renderer: Utils.rendererNumberToSiNo
		        },
		        {	        	
		            dataIndex: 'conTasacion',
		            text: HreRem.i18n('header.con.tasacion'),
		            flex: 1,
		            renderer: Utils.rendererNumberToSiNo,
		            hidden: true
		        },
		        {	        	
		            dataIndex: 'tieneMediador',
		            text: HreRem.i18n('header.tiene.mediador'),
		            flex: 1,
		            hidden: true,
		            renderer: Utils.rendererNumberToSiNo
		        },
		        {	        	
		            dataIndex: 'estadoInformeComercial',
		            text: HreRem.i18n('header.estado.informe.comercial'),
		            flex: 1,
		            hidden: true,
		            renderer: function(value) {
		            	var record = me.lookupController().getViewModel().get("comboEstadoInformeComercial").findRecord("codigo", value);
		            	if(Ext.isEmpty(record)) {
		            		return "-";
		            	} else {
		            		return record.get("descripcion");
		            	}
		            	
		            }
		        },
		        {
		        	dataIndex:'fsvVenta',
		            text: HreRem.i18n('header.fsv.venta'),
		            renderer: Utils.rendererCurrency,
		            flex: 1
		        },
		       	{
		        	dataIndex:'fsvRenta',
		            text: HreRem.i18n('header.fsv.renta'),
		            renderer: Utils.rendererCurrency,
		            flex: 1
		        },		        
		        {
		        	dataIndex:'precioAprobadoVenta',
		            text: HreRem.i18n('header.precio.aprobado.venta'),
		            renderer: Utils.rendererCurrency,
		            flex: 1
		        },
		        {
		        	dataIndex:'precioAprobadoRenta',
		            text: HreRem.i18n('header.precio.apobado.renta'),
		            renderer: Utils.rendererCurrency,
		            flex: 1
		        },
		        {
		        	dataIndex:'precioMinimoAutorizado',
		            text: HreRem.i18n('header.precio.minimo.autorizado'),
		            renderer: Utils.rendererCurrency,
		            flex: 1
		        }/*,
		        {
		        	dataIndex:'precioDescuentoAprobado',
		            text: HreRem.i18n('header.precio.descuento.autorizado'),
		            renderer: Utils.rendererCurrency,
		            flex: 1
		        },
		        {
		        	dataIndex:'precioDescuentoPublicado',
		            text: HreRem.i18n('header.precio.descuento.publicado'),
		            renderer: Utils.rendererCurrency,
		            flex: 1
		        }*/
        ];
        
        
        me.dockedItems = [
        		{
				    xtype: 'toolbar',
				    dock: 'top',
				    items: [
				        {cls:'tbar-grid-button', text: 'Exportar', itemId:'exportar', handler: 'onClickExportar'},
						{cls:'tbar-grid-button', text: 'Generar propuesta de precios', itemId:'generarPropuesta', handler: 'onClickGenerarPropuesta'}
				    ]
				},
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
        
    }


});

