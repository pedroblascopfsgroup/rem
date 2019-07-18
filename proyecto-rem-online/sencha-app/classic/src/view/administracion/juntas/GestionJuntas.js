Ext.define('HreRem.view.administracion.juntas.GestionJuntas', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'gestionjuntas',    
    requires: ['HreRem.view.administracion.juntas.GestionJuntasSearch', 'HreRem.view.administracion.juntas.GestionJuntasList'],
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
    
    initComponent: function () {        
        var me = this;        
        me.setTitle(HreRem.i18n("title.gestion.juntas"));
        var items = [
        			{
        				xtype: 'container',
        				flex:1,
        				scrollable: 'y',
        				layout: {
        					type: 'vbox',
        					align: 'stretch'
        				},
        				items: [
		        			{	
		        				xtype: 'gestionjuntassearch',
		        				collapsible: true,
		        				reference: 'juntasSearch'
		        			},
		        			{	
		        				xtype: 'gestionjuntaslist',
								reference: 'gestionList',
								flex: 1
		        			}
		        		]
        			}
        ];			
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    },        
    
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		
		/*
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
  		*/
		var gestionJuntasList = me.down("gestionjuntaslist");
		gestionJuntasList.deselectAll();
  		gestionJuntasList.getStore().loadPage(1);
    } 

});