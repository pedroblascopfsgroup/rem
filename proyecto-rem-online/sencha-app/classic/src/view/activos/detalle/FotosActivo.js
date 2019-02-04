Ext.define('HreRem.view.activos.detalle.FotosActivo', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'fotosactivo',  
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    flex		: 1,
    layout		:{
		type  : 'vbox',
		align : 'stretch'
	},
    reference	: 'fotosactivo',
    requires	: ['HreRem.view.activos.detalle.FotosActivoTabPanel'],
    defaults	: {
        xtype		: 'container',
        sytle		: 'padding-left: 15px !important',
        defaultType	: 'displayfield'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.fotos'));


        var items = [
        	{
        		xtype: 'fotosactivotabpanel'
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