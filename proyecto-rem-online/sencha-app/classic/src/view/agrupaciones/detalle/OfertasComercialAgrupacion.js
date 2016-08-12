Ext.define('HreRem.view.agrupacion.detalle.OfertasComercialAgrupacion', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'ofertascomercialagrupacion',
    requires	: ['HreRem.view.agrupacion.detalle.OfertasComercialAgrupacionList'],
    scrollable	: 'y',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.activos.listado.ofertas"));
        
        var items = [      			
        			{	
        				xtype: 'ofertascomercialagrupacionlist',
        				reference: 'ofertascomercialagrupacionlistref'        				
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