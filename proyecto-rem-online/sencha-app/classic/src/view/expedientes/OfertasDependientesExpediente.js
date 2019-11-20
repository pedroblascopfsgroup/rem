Ext.define('HreRem.view.expedientes.OfertasDependientesExpediente', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'ofertasdependientesexpediente',
    requires	: ['HreRem.view.expedientes.OfertasDependientesExpedienteList'],
    scrollable	: 'y',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
    	var me = this;
        me.setTitle(HreRem.i18n("title.expediente.ofertas.dependientes"));

        me.items = [      			
    			{	
    				xtype: 'ofertasdependientesexpedientelist',
    				reference: 'ofertasdependientesexpedientelistref'        				
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