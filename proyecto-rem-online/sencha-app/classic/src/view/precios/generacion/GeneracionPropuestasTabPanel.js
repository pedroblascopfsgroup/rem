Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'generacionpropuestastabpanel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    
    requires	: ['HreRem.view.precios.generacion.GeneracionPropuestasManual', 'HreRem.view.precios.generacion.GeneracionPropuestasAutomatica'],

    initComponent: function () {
        
        var me = this;
        
        me.items = [
	        			{	
	        				xtype: 'generacionpropuestasautomatica'
	        			},
	        			{	
							xtype: 'generacionpropuestasmanual'
	        			}        
        
        ];

        me.callParent();
        



        
    }


});

