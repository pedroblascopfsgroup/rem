Ext.define('HreRem.view.activos.detalle.OfertasComercialActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'ofertascomercialactivo',
    requires	: ['HreRem.view.activos.detalle.OfertasComercialActivoList'],
    scrollable	: 'y',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {        
        var me = this;
        me.setTitle(HreRem.i18n("title.activos.listado.ofertas"));

        me.items = [
				{	
					xtype: 'ofertascomercialactivolist',
					reference: 'ofertascomercialactivolistref'        				
				}
        ];

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