Ext.define('HreRem.view.expedientes.ProblemasVentaClienteUrsus', {
	extend		: 'HreRem.view.common.GridBase',
	xtype		: 'problemasVentaClienteUrsus',
	reference	: 'problemasVentaClienteUrsusRef',
	addButton	: false,
	removeButton: false,
	pageSize	: '10',
	collapsible	: true,
	collapsed 	: true,
	topBar		: false,
	
	initComponent: function() {
		var me = this;
		me.title = HreRem.i18n('title.grid.expediente.comercial.problemas.venta');
		me.columns = [
			{
				text : HreRem.i18n('fieldlabel.expediente.comercial.problemas.venta.Tipo'),
				dataIndex : 'tipoMensaje'
			},
			{
				text : HreRem.i18n('fieldlabel.expediente.comercial.problemas.venta.Motivo'),
				dataIndex: 'liavi1'
			}
		];

		me.callParent();
	}
	
});