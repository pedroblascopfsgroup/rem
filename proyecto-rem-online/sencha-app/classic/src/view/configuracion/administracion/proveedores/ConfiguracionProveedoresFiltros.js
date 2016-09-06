Ext.define('HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedoresFiltros', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'configuracionproveedoresfiltros',
    reference	: 'configuracionProveedoresFiltros',
    scrollable: 'y',
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.configuracion.proveedores"));  
        
        me.columns= [ 
//                {
//                	dataIndex: 'entidadPropietariaCodigo',
//		            text: HreRem.i18n('header.precios.automatica.activos.cartera.codigo'),
//		            flex: 1,
//		            hidden: true
//                },'HreRem.view.common.GridBase',
//		        {	        	
//		        	dataIndex: 'entidadPropietariaDescripcion',
//		            text: HreRem.i18n('header.cartera'),
//		            flex: 2	        	
//		        },
//		        {	        	
//		            dataIndex: 'numActivosPreciar',
//		            text: HreRem.i18n('header.precios.automatica.activos.preciar'),
//		            flex: 1,
//		            align: 'center'
//		        },
//		        {	        	
//		            dataIndex: 'numActivosRepreciar',
//		            text: HreRem.i18n('header.precios.automatica.activos.repreciar'),
//		            flex: 1,
//		            align: 'center'		        	
//		        },
//		        {	        	
//		        	dataIndex: 'numActivosDescuento',
//		            text: HreRem.i18n('header.precios.automatica.activos.descuento'),
//		            flex: 1,
//		            align: 'center',
//		            hidden: true
//		        }
        ];
        
        me.callParent(); 

        
    }


});

