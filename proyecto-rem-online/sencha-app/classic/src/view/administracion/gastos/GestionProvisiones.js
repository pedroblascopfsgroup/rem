Ext.define('HreRem.view.administracion.gastos.GestionProvisiones', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'gestionprovisiones',    
    requires: ['HreRem.view.administracion.gastos.ProvisionesSearch', 'HreRem.view.administracion.gastos.ProvisionesList',
    			'HreRem.view.administracion.gastos.ProvisionGastosList'],
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
		        				xtype: 'provisionessearch',
		        				collapsible: true,
		        				reference: 'provisionesSearch'
		        			},
		        			{	
		        				xtype: 'provisioneslist',
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
						xtype: 'provisiongastoslist',
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