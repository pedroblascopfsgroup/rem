Ext.define('HreRem.view.administracion.gastos.GestionGastos', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'gestiongastos',
//    requires	: [''],
	layout		: 'fit',
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.gastos.gestion.gastos"));
        
        var items = [
        			
        			
        
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