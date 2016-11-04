Ext.define('HreRem.view.administracion.gastos.GestionGastos', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'gestiongastos',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    requires	: ['HreRem.view.administracion.gastos.GestionGastosList', 'HreRem.view.administracion.gastos.GestionGastosSearch'],
	scrollable: true,
	cls	: 'panel-base shadow-panel',
	scrollable	: 'y',
//	cls	: 'panel-base shadow-panel tabPanel-tercer-nivel',
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.gastos.gestion.gastos"));
        
        var items = [
        
	        {
	        	xtype:'gestiongastossearch',
	        	reference: 'gestiongastossearchref'
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
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
    } 


});