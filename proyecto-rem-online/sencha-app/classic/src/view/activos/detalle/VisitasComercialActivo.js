Ext.define('HreRem.view.activos.detalle.VisitasComercialActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'visitascomercialactivo',
    requires	: ['HreRem.view.activos.detalle.VisitasComercialActivoList'],
    scrollable	: 'y',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.activos.listado.visitas"));
        
        var items = [      			
        			{	
        				xtype: 'visitascomercialactivolist',
        				reference: 'visitascomercialactivolistref'        				
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