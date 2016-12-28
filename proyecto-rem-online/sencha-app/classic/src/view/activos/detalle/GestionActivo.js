Ext.define('HreRem.view.activos.detalle.GestionActivo', {
    extend	: 'Ext.form.Panel',
    xtype	: 'gestionactivo',
    layout	: 'fit',
    requires: ['HreRem.view.activos.detalle.GestionActivoTabPanel'],

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.gestion.activo'));

    	var items = [
			{				
			    xtype: 'gestionactivotabpanel'
			}
    	];

		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.down('tabpanel').getActiveTab().funcionRecargar();
    }
});