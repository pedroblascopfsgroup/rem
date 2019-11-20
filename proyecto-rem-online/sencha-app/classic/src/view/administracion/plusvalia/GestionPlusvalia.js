Ext.define('HreRem.view.administracion.plusvalia.GestionPlusvalia', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'gestionplusvalia',
    scrollable: 'y',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    controller	: 'administracion',
    viewModel	: {
        type: 'administracion'
    },
    listeners: {
    	refrescar: function(){  
    		var me = this;
    		me.funcionRecargar();	    	
    	}
	},
    requires	: ['HreRem.view.administracion.plusvalia.GestionPlusvaliaList', 'HreRem.view.administracion.plusvalia.GestionPlusvaliaSearch',
    				'HreRem.view.administracion.AdministracionModel','HreRem.view.administracion.AdministracionController'],
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.plusvalia.gestion.plusvalia"));
        
        var items = [
        
	        {
	        	xtype:'gestionplusvaliasearch',
	        	reference: 'gestionplusvaliasearchref',
	        	scrollable: 'y'
	        },       			
	        {
	        	xtype: 'gestionplusvalialist',
	        	reference: 'gestionplusvalialistref'
			}
        
        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		
		var gestionPlusvaliaList = me.down("gestionplusvalialist");
		gestionPlusvaliaList.deselectAll();
  		gestionPlusvaliaList.getStore().loadPage(1);
  		
    }


});