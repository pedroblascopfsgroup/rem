Ext.define('HreRem.view.administracion.gastos.GestionSolicitudesProvisionesFondosBankia', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'gestionsolicitudesprovisionesfondosbankia',
//    requires	: [''],
	layout		: 'fit',
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.gastos.gestion.solicitudes.provisiones.fondos.bankia"));
        
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