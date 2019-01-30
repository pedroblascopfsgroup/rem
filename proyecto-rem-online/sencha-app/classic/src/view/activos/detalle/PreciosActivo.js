Ext.define('HreRem.view.activos.detalle.PreciosActivo', {
    extend	: 'Ext.panel.Panel',
    xtype	: 'preciosactivo',
    layout	: 'fit',
    requires: ['HreRem.view.activos.detalle.PreciosActivoTabPanel'],

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.precios'));

    	var items = [
    		{
    			xtype: 'preciosactivotabpanel'
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