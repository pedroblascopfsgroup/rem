Ext.define('HreRem.view.activos.detalle.SuministrosActivo', {
	extend: 'HreRem.view.common.FormBase',
	xtype: 'suministrosactivo',
	cls	: 'panel-base shadow-panel',
	collapsed: false,
	disableValidation: true,
	reference: 'suministrosactivoref',
	scrollable	: 'y',
	layout: 'fit',
	recordName: 'suministros',
	recordClass: 'HreRem.model.SuministrosActivoModel',
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.SuministrosActivoModel', 'HreRem.view.activos.detalle.SuministrosActivoGrid'],

	initComponent: function () {

		var me = this;
		me.setTitle(HreRem.i18n('title.suministros.activo'));
		var items= [{
			xtype: 'suministrosactivogrid',
			reference: 'suministrosactivogridref'
		}];
	
		me.addPlugin({ptype: 'lazyitems', items: items });
		me.callParent();
	},
	
	funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
	}
	
});