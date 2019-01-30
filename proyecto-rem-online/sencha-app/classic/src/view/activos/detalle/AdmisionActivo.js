Ext.define('HreRem.view.activos.detalle.AdmisionActivo', {
    extend	: 'Ext.panel.Panel',
    xtype	: 'admisionactivo',
    layout	: 'fit',
    requires: ['HreRem.view.activos.detalle.AdmisionActivoTabPanel'],

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.admision'));

    	var items = [
			{
				xtype: 'admisionactivotabpanel'
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