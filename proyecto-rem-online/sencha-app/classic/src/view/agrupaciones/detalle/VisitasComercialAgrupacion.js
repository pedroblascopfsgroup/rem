Ext.define('HreRem.view.agrupacion.detalle.VisitasComercialAgrupacion', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'visitascomercialagrupacion',
    requires	: ['HreRem.view.agrupacion.detalle.VisitasComercialAgrupacionList'],
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
        				xtype: 'visitascomercialagrupacionlist',
        				reference: 'visitascomercialagrupacionlistref'        				
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