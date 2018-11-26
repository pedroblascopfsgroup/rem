Ext.define('HreRem.view.activos.detalle.PatrimonioActivo', {
    extend	: 'Ext.panel.Panel',
    xtype	: 'patrimonioactivo',
    reference: 'patrimonioActivoRef',
    layout	: 'fit',
    requires: ['HreRem.view.activos.detalle.PatrimonioActivoTabPanel'],

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.patrimonio.activo'));

    	var items = [
			{
				xtype: 'patrimonioactivotabpanel'
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





