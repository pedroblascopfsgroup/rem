Ext.define('HreRem.view.agrupacion.detalle.ComercialAgrupacionTabs', {
    extend: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'comercialagrupaciontabs',
    reference	: 'comercialagrupaciontabsref',
    layout		: 'fit',
    requires: ['HreRem.view.agrupacion.detalle.VisitasComercialAgrupacion','HreRem.view.agrupacion.detalle.OfertasComercialAgrupacion'],    

	listeners: {
		boxready: function (tabPanel) {   		
    		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}			
		}
    	
        
    },
    
    initComponent: function () {
    	
    	var me = this;
    	
    	var items = [
			{
				xtype: 'ofertascomercialagrupacion'
			},
			{
				xtype: 'visitascomercialagrupacion'
			}
    	];
    	
    	
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    } 
});