Ext.define('HreRem.view.expedientes.ListaActivosOfertaAgrupadaExpediente', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'listaactivosofertaagrupadaexpediente',
    requires	: ['HreRem.view.expedientes.ListaActivosOfertaAgrupadaExpedienteList'],
    scrollable	: 'y',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
    	var me = this;
        me.setTitle(HreRem.i18n("title.expediente.lista.activos"));

        me.items = [      			
    			{	
    				xtype: 'listaactivosofertaagrupadaexpedientelist',
    				reference: 'listaactivosofertaagrupadaexpedientelistref'        				
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