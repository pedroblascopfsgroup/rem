Ext.define('HreRem.view.activos.detalle.PropuestasPreciosActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'propuestaspreciosactivo',
    requires	: ['HreRem.view.activos.detalle.PropuestasActivoSearch', 'HreRem.view.activos.detalle.PropuestasActivoList'],
    scrollable	: 'y',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.propuestas.precios"));
        
        var items = [
        			
        			{	
        				xtype: 'propuestasactivosearch',
        				reference: 'propuestasActivoSearch',
        				title: HreRem.i18n("title.filtro.propuestas"),
        				collapsible: true,
        				collapsed: true
        			},
        			{	
        				xtype: 'propuestasactivolist',
        				reference: 'propuestasActivoList'        				
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