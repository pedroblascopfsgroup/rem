Ext.define('HreRem.view.agrupacion.detalle.ComercialAgrupacion', {
    extend: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'comercialagrupacion',
    reference	: 'comercialagrupacionref',
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
    
	layout: 'fit',
    
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
    	
    	

    	me.setTitle(HreRem.i18n('title.comercial'));
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    } 
    
});