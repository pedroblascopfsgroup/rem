Ext.define('HreRem.view.expedientes.OfertaExpediente', {
    extend: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'ofertaexpediente',
    reference	: 'ofertaexpedienteref',
    layout		: 'fit',
    requires: ['HreRem.view.expedientes.DatosBasicosOferta'],    
    
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
    	
    	me.items = [
			
			{
				xtype: 'datosbasicosoferta'
			}
			
    	];
    	
    	

    	me.setTitle(HreRem.i18n('title.oferta'));
    	//me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    } 
    
});