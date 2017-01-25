Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'generacionpropuestastabpanel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    requires	: ['HreRem.view.precios.generacion.GeneracionPropuestasManual', 'HreRem.view.precios.generacion.GeneracionPropuestasAutomatica',
    				'HreRem.view.precios.generacion.GeneracionPropuestasConfiguracion'],
    listeners	: {
    	tabchange: 'onTabChangeGeneracionPropuestasTabPanel',
    	boxready : function (tabPanel) {   		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
    	}
    },

    initComponent: function () {
        var me = this;

        me.items = [];
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'generacionpropuestasautomatica'})}, ['TAB_INCLUSION_AUTOMATICA_PRECIOS']);
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'generacionpropuestasmanual'})}, ['TAB_SELECCION_MANUAL_PRECIOS']);
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'generacionpropuestasconfiguracion'})}, ['TAB_CONFIGURACION_PROPUESTA_PRECIO']);

        me.callParent();
    }
});

