Ext.define('HreRem.view.administracion.gastos.GestionProvisiones', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'gestionprovisiones',    
    requires: ['HreRem.view.administracion.gastos.GestionProvisionesSearch', 'HreRem.view.administracion.gastos.GestionProvisionesList',
    			'HreRem.view.administracion.gastos.GestionProvisionGastosList'],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    
    initComponent: function () {        
        var me = this;        
        me.setTitle(HreRem.i18n("title.gastos.gestion.solicitudes.provisiones"));
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
		        				xtype: 'gestionprovisionessearch',
		        				collapsible: true,
		        				reference: 'provisionesSearch'
		        			},
		        			{	
		        				xtype: 'gestionprovisioneslist',
								reference: 'provisionesList',
								flex: 1
		        			}
		        		]
        			},
        			{
				        xtype: 'splitter',
				        cls: 'x-splitter-base',
				        collapsible: true
				    },
        			{	
						xtype: 'gestionprovisiongastoslist',
						reference: 'provisionesGastosList',
						collapsed: true,
						scrollable: 'y',
						flex: 1
        			}
        ];			
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    },    
    
    
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
    } 

});