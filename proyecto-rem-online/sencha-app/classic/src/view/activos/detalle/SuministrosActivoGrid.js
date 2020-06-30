Ext.define('HreRem.view.activos.detalle.SuministrosActivoGrid', {
	extend:'HreRem.view.common.GridBaseEditableRow',
	xtype:'suministrosactivogrid',
	reference: 'suministrosactivogridref',
	topBar:'{validarEdicionSuministrosActivo}',
	removeButton: '{validarEdicionSuministrosActivo}',
	editOnSelect:'{validarEdicionSuministrosActivo}',
	disabledDeletedBtn:'{!validarEdicionSuministrosActivo}',
	editable: '{validarEdicionSuministrosActivo}',
	bind: {
		store: '{storeSuministrosActivo}'
	},
	
//	listeners: {
//		beforeEdit: 'validarEdicionSuministrosActivo'
//	},
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
//			{
//				dataIndex: 'idSuministro',
//				hidden: true//,
//				//valueField: 'idSuministro'
//			},
			{
				dataIndex: 'idActivo',
				hidden: true,
				valueField: '{activo.id}'
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.tipoSuministro'),
				dataIndex: 'tipoSuministro',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDTipoSuministro}'
					},
					displayField: 'descripcion',
					valueField: 'id'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.subtipoSuministro'),
				dataIndex: 'subtipoSuministro',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDSubtipoSuministro}'
					},
					displayField: 'descripcion',
					valueField: 'id'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.companiaSuministradora'),
				dataIndex: 'companiaSuministro',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDCompaniaSuministradora}'
					},
					displayField: 'nombre',
					valueField: 'id'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.domiciliado'),
				dataIndex: 'domiciliado',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDDomiciliado}'
					},
					displayField: 'descripcion',
					valueField: 'id'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.numContrato'),
				dataIndex: 'numContrato',
				flex:0.5,
				editor: {
					xtype: 'textfield'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.numCups'),
				dataIndex: 'numCups',
				flex:0.5,
				editor: {
					xtype: 'textfield'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.periodicidad'),
				dataIndex: 'periodicidad',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDPeriodicidad}'
					},
					displayField: 'descripcion',
					valueField: 'id'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.fechaAltaSuministro'),
				dataIndex: 'fechaAlta',
				flex:0.5,
				formatter: 'date("d/m/Y")',
				editor: {
					xtype: 'datefield',
					reference: 'fechaAlta',
					maxValue: new Date()
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.motivoAltaSuministro'),
				dataIndex: 'motivoAlta',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDMotivoAltaSuministro}'
					},
					displayField: 'descripcion',
					valueField: 'id'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.fechaBajaSuministro'),
				dataIndex: 'fechaBaja',
				flex:0.5,
				formatter: 'date("d/m/Y")',
				editor: {
					xtype: 'datefield',
					reference: 'fechaBaja',
					maxValue: new Date()
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.motivoBajaSuministro'),
				dataIndex: 'motivoBaja',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDMotivoBajaSuministro}'
					},
					displayField: 'descripcion',
					valueField: 'id'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.validado'),
				dataIndex: 'validado',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDValidado}'
					},
					displayField: 'descripcion',
					valueField: 'id'
				}
			}
			
		];
		
		me.dockedItems = [{
			xtype: 'pagingtoolbar',
			dock: 'bottom',
			itemId: 'activosPaginationToolbar',
			inputItemWidth: 60,
			displayInfo: true,
			bind: {
				store: '{storeSuministrosActivo}'
			}
		}];
		
		me.callParent();
	}
});