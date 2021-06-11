Ext.define('HreRem.view.activos.PreciosVigentesCaixaGrid', {
    extend: 'HreRem.view.common.GridBaseEditableRowSinEdicion',
    xtype: 'preciosvigentescaixagrid',
	bind: {
		store: '{storePreciosVigentesCaixa}'
	},
	requires: ['HreRem.model.PreciosVigentesCaixaGridModel'],
	recordName : "preciosvigentescaixa",
	reference: 'preciosvigentescaixagridref',

	initComponent: function() {

		var me = this;

		me.columns = [
			   {
					dataIndex: 'descripcionTipoPrecioCaixa',
//					cls: 'grid-no-seleccionable-primera-col',
//	        		tdCls: 'grid-no-seleccionable-td',
					flex: 1.5
			   },
			   {
					text: HreRem.i18n('header.importe'),
//					cls: 'grid-no-seleccionable-col',
//	        		tdCls: 'grid-no-seleccionable-td',
					dataIndex: 'importeCaixa',
					flex: 1
			   },
			   {
					text: HreRem.i18n('header.fecha.aprobacion'),
//					cls: 'grid-no-seleccionable-col',
//					tdCls: 'grid-no-seleccionable-td',
					dataIndex: 'fechaAprobacionCaixa',
					formatter: 'date("d/m/Y")',
					flex: 1
			   },
			   {
					text: HreRem.i18n('header.fecha.carga'),
//					cls: 'grid-no-seleccionable-col',
//	        		tdCls: 'grid-no-seleccionable-td',												
					dataIndex: 'fechaCargaCaixa',
					formatter: 'date("d/m/Y")',
					flex: 1
			   },
			   {
					text: HreRem.i18n('header.fecha.inicio'),
//					cls: 'grid-no-seleccionable-col',
//	        		tdCls: 'grid-no-seleccionable-td',												
					dataIndex: 'fechaInicioCaixa',
					formatter: 'date("d/m/Y")',
					flex: 1
			   },
			   {
					text: HreRem.i18n('header.fecha.fin'),
//					cls: 'grid-no-seleccionable-col',
//	        		tdCls: 'grid-no-seleccionable-td',												
					dataIndex: 'fechaFinCaixa',
					formatter: 'date("d/m/Y")',
					flex: 1
			   },
			   {
					text: HreRem.i18n('header.gestor'),
//					cls: 'grid-no-seleccionable-col',
//	        		tdCls: 'grid-no-seleccionable-td',
					dataIndex: 'gestorCaixa',
					flex: 1
			   },
			   {
					text: HreRem.i18n('header.observaciones'),
//					cls: 'grid-no-seleccionable-col',
//	        		tdCls: 'grid-no-seleccionable-td',												
					dataIndex: 'observacionesCaixa',
					flex: 1
			   }
		];

		me.dockedItems = [
			{
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'preciosVigentesCaixaToolbar',
	            inputItemWidth: 100,
	            displayInfo: true,
				bind: {
					store: '{storePreciosVigentesCaixa}'
				}
	
	        }	
		];

		me.callParent();

	}
});
