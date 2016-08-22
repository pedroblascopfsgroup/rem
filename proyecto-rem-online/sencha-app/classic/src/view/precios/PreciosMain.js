Ext.define('HreRem.view.precios.PreciosMain', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'preciosmain',
    reference	: 'preciosMain',
    layout: 'fit',
    
    requires	: ['HreRem.view.precios.PreciosController','HreRem.view.precios.PreciosModel',
    'HreRem.view.precios.generacion.GeneracionPropuestasMain','HreRem.view.precios.historico.HistoricoPropuestasMain'],
    
    controller: 'precios',
    viewModel: {
        type: 'precios'
    },

    initComponent: function () {
        
        var me = this;
        
        me.items = [
		    {	
				xtype: 'generacionpropuestasmain', reference: 'generacionPropuestasMain'
			},
			{	
				xtype: 'historicopropuestasmain', reference	: 'historicoPropuestasMain'				
			}
        ];
        
        me.callParent(); 

        
    }

});

