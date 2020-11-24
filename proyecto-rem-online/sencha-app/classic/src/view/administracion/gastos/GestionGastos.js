Ext.define('HreRem.view.administracion.gastos.GestionGastos', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'gestiongastos',
    scrollable: 'y',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    listeners: {
    	refrescar: function(){  
    		var me = this;
    		me.funcionRecargar();	    	
    	}
	},
    requires	: ['HreRem.view.administracion.gastos.GestionGastosList', 'HreRem.view.administracion.gastos.GestionGastosSearch'],
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.gastos.gestion.gastos"));
        
        var items = [
        
	        {
	        	xtype:'gestiongastossearch',
	        	reference: 'gestiongastossearchref',
	        	scrollable: 'y'
	        },       			
	        {
	        	xtype: 'gestiongastoslist',
	        	reference: 'gestiongastoslistref'
			}
        
        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		
		var gestionGastosList = me.down("gestiongastoslist");
		gestionGastosList.deselectAll();
  		gestionGastosList.getStore().loadPage(1);
  		
    }


});