
Ext.define('HreRem.view.trabajos.detalle.FotosTrabajo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'fotostrabajo',  
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    flex		: 1,
    reference	: 'fotostrabajo',
    requires	: ['HreRem.view.trabajos.detalle.FotosTrabajoTabPanel'],
    layout		: {
		type : 'vbox',
		align: 'stretch'
	},

    defaults: {
        xtype: 'container',
        sytle: 'padding-left: 15px !important',
        defaultType: 'displayfield'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.fotos'));      

        var items= [
			{				
			    xtype: 'fotostrabajotabpanel'
			}
    	];

		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

     /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	var me = this;
    },

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabFotos(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});