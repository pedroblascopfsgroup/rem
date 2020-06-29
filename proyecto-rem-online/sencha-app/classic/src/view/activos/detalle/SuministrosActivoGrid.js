Ext.define('HreRem.view.activos.detalle.SuministrosActivoGrid', {
	extend:'HreRem.view.common.GridBaseEditableRow',
	xtype:'suministrosactivogrid',
	reference: 'suministrosactivogridref',
	topBar:true,
	removeButton: true,
	editOnSelect:true,
	disabledDeletedBtn:false,
	editable: true,
	bind: {
		store: '{storeSuministrosActivo}'
	},
	
	listeners: {
		beforeEdit: 'validarEdicionSuministrosActivo'
	},
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
			{
				text:HreRem.i18n('fieldlabel.suministros.tipoSuministro'),
				dataIndex: 'tipoSuministro',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDTipoSuministro}'
					},
					displayField: 'descripcion'//,
					//valueField: 'codigo'
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
					displayField: 'descripcion'//,
					//valueField: 'codigo'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.companiaSuministradora'),
				dataIndex: 'companiaSuministradora',
				flex:0.5,
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDCompaniaSuministradora}'
					},
					displayField: 'descripcion'//,
					//valueField: 'codigo'
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
					displayField: 'descripcion'//,
					//valueField: 'codigo'
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
					displayField: 'descripcion'//,
					//valueField: 'codigo'
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
					displayField: 'descripcion'//,
					//valueField: 'codigo'
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
					displayField: 'descripcion'//,
					//valueField: 'codigo'
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
					displayField: 'descripcion'//,
					//valueField: 'codigo'
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