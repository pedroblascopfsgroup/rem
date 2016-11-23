Ext.define('HreRem.view.trabajos.detalle.FotosTrabajoTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'fotostrabajotabpanel',
    flex 		: 3,
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'tabpanelfotostrabajo',
    layout		: 'fit',
    requires	: ['HreRem.view.trabajos.detalle.FotosTrabajoProveedor','HreRem.view.trabajos.detalle.FotosTrabajoSolicitante', 'HreRem.view.common.adjuntos.AdjuntarFotoTrabajo'],

    listeners	: {
    	boxready: function (tabPanel) {   		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
    	}
    },

    initComponent: function () {
    	var me = this;

        me.items = [];
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotostrabajosolicitante'})}, ['TAB_FOTOS_SOLICITANTE_TRABAJO']);
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotostrabajoproveedor'})}, ['TAB_FOTOS_PROVEEDOR_TRABAJO']);

        me.callParent(); 
    }
});