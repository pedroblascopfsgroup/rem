Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasAutomatica', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'generacionpropuestasautomatica',
    reference	: 'generacionPropuestasAutomatica',
    scrollable: 'y',
    bind: {
        store: '{numActivosByTipoPrecio}'
    },
	listeners: {
		cellclick : 'cellClickPropuestaPrecioInclusionAutomatica'
	},

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.inclusion.automatica"));  
        
        me.columns= [
                     
                {
                	dataIndex: 'entidadPropietariaCodigo',
		            text: HreRem.i18n('header.precios.automatica.activos.cartera.codigo'),
		            flex: 1,
		            hidden: true
                },
		        {	        	
		        	dataIndex: 'entidadPropietariaDescripcion',
		            text: HreRem.i18n('header.cartera'),
		            flex: 2	        	
		        },
		        {	        	
		            dataIndex: 'numActivosPreciar',
		            text: HreRem.i18n('header.precios.automatica.activos.preciar'),
		            flex: 1		        	
		        },
		        {	        	
		            dataIndex: 'numActivosRepreciar',
		            text: HreRem.i18n('header.precios.automatica.activos.repreciar'),
		            flex: 1		        	
		        },
		        {	        	
		        	dataIndex: 'numActivosDescuento',
		            text: HreRem.i18n('header.precios.automatica.activos.descuento'),
		            flex: 1,
		            hidden: true
		        }
        ];
        
        me.callParent(); 

        
    }


});

