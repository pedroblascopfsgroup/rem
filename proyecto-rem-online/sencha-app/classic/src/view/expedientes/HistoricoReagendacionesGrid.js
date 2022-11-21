Ext.define('HreRem.view.expedientes.HistoricoReagendacionesGrid', {
	extend: 'HreRem.view.common.GridBase',
	xtype: 'historicoReagendacionesGrid',
	requires: ['HreRem.model.HistoricoReagendacionesGridModel'],
	reference: 'historicoReagendacionesGridRef',
	recordName: "historicoReagendacionesGrid",
	recordClass: "HreRem.model.HistoricoReagendacionesGridModel",
	bind: {
		store: '{storeHistoricoReagendaciones}'
	},

	initComponent: function () {
		var me = this;
		me.columns = [
			{
				dataIndex: 'id',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.id'),
				flex: 1
			},
			{
				dataIndex: 'fechaReagendacionIngreso',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.fechaReagendacion'),
				editor: {
					xtype: 'datefield'
				},
				formatter: 'date("d/m/Y")',
				flex: 1
			},
			{
				dataIndex: 'fechaAgendacionIngreso',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.fechaAgendacion'),
				editor: {
					xtype: 'datefield'
				},
				formatter: 'date("d/m/Y")',
				flex: 1
			},
			{
				dataIndex: 'importe',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.importe'),
				editor: {
					xtype: 'numberfield'
				},
				flex: 1
			},
			{
				dataIndex: 'ibanDevolucion',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.ibanDevolucion'),
				flex: 1
			},
			{
				dataIndex: 'fechaIngreso',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.fechaIngreso'),
				editor: {
					xtype: 'datefield'
				},
				formatter: 'date("d/m/Y")',
				flex: 1
			},
			{
				dataIndex: 'numeroOferta',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.numOferta'),
				flex: 1
			},
			{
				dataIndex: 'cuentaVirtual',
				text: HreRem.i18n('fiedlabel.historico.Reagendaciones.cuentaVirtual'),
				flex: 1
			}
		];


		me.dockedItems = [
			{
				xtype: 'pagingtoolbar',
				dock: 'bottom',
				itemId: 'activosPaginationToolbar',
				inputItemWidth: 60,
				displayInfo: true,
				bind: {
					store: '{storeHistoricoReagendaciones}'
				}
			}
		];

		me.saveSuccessFn = function () {
			var me = this;
			me.getView().refresh()
			return true;
		};

		me.callParent();

	}
});
