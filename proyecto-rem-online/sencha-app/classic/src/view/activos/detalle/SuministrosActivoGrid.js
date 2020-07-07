Ext.define('HreRem.view.activos.detalle.SuministrosActivoGrid', {
	extend:'HreRem.view.common.GridBaseEditableRow',
	xtype:'suministrosactivogrid',
	reference: 'suministrosactivogridref',
	controller: 'activodetalle',
	topBar: true,
	editable: true,
	bind: {
		store: '{storeSuministrosActivo}'
	},
	listeners: {
		boxready: function() {
			var me = this;
			me.evaluarEdicion();
		}
	},
	idProperty: 'idSuministro',
	
	initComponent: function () {
		var me = this;
		
		me.columns = [
			{
				dataIndex: 'idSuministro',
				hidden: true
			},
			{
				dataIndex: 'idActivo',
				hidden: true
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.tipoSuministro'),
				dataIndex: 'tipoSuministro',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDTipoSuministro').findRecord('id', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDTipoSuministro}'
					},
					displayField: 'descripcion',
					valueField: 'id',
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.subtipoSuministro'),
				dataIndex: 'subtipoSuministro',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDSubtipoSuministro').findRecord('id', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDSubtipoSuministro}'
					},
					displayField: 'descripcion',
					valueField: 'id',
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.companiaSuministradora'),
				dataIndex: 'companiaSuministro',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDCompaniaSuministradora').findRecord('id', value);
					var nombre;
					if(!Ext.isEmpty(foundedRecord)) {
						nombre = foundedRecord.getData().nombre;
					};
					return nombre;
				},
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDCompaniaSuministradora}'
					},
					displayField: 'nombre',
					valueField: 'id',
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.domiciliado'),
				dataIndex: 'domiciliado',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDDomiciliado').findRecord('id', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDDomiciliado}'
					},
					displayField: 'descripcion',
					valueField: 'id',
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.numContrato'),
				dataIndex: 'numContrato',
				flex:0.5,
				editor: {
					xtype: 'textfield',
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.numCups'),
				dataIndex: 'numCups',
				flex:0.5,
				editor: {
					xtype: 'textfield',
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.periodicidad'),
				dataIndex: 'periodicidad',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDPeriodicidad').findRecord('id', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDPeriodicidad}'
					},
					displayField: 'descripcion',
					valueField: 'id',
					allowBlank: false
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
					maxValue: new Date(),
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.motivoAltaSuministro'),
				dataIndex: 'motivoAlta',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDMotivoAltaSuministro').findRecord('id', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDMotivoAltaSuministro}'
					},
					displayField: 'descripcion',
					valueField: 'id',
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.fechaBajaSuministro'),
				dataIndex: 'fechaBaja',
				flex:0.5,
				formatter: 'date("d/m/Y")',
				editor: {
					xtype: 'datefield',
					reference: 'fechaBaja'
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.motivoBajaSuministro'),
				dataIndex: 'motivoBaja',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDMotivoBajaSuministro').findRecord('id', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
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
				reference: 'suministroValidado',
				text:HreRem.i18n('fieldlabel.suministros.validado'),
				dataIndex: 'validado',
				flex:0.5,
				renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
					var foundedRecord = this.up('suministrosactivo').lookupController().getStore('comboDDValidado').findRecord('id', value);
					var descripcion;
					if(!Ext.isEmpty(foundedRecord)) {
						descripcion = foundedRecord.getData().descripcion;
					};
					return descripcion;
				},
				editor: {
					xtype: 'combobox',
					bind: {
						store: '{comboDDValidado}'
					},
					displayField: 'descripcion',
					valueField: 'id',
					handler: me.editarCheckValidado
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
	},
	
	evaluarEdicion: function() {
		var me = this;
		
		if( !($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTORIAS_ADMINISTRACION']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMINISTRACION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMINISTRACION'])) ) {
			me.setTopBar(false);
			me.setEditOnSelect(false);
		}
	},
	
	editarCheckValidado: function(){
		//Desactivamos la columna de validado en función del usuario:
		me.lookupReference('suministrovalidado').setDisabled( !($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMINISTRACION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMINISTRACION'])) );
	},
	
	onAddClick : function(btn){
		var me = this;
		var idActivo = me.lookupController().getViewModel().getData().activo.id;
		me.getStore().sorters.clear();
		me.editPosition = 0;
		me.getStore().insert(me.editPosition, new HreRem.model.SuministrosActivoModel({idActivo: idActivo}));
		me.rowEditing.isNew = true;
		me.rowEditing.startEdit(me.editPosition, 0);
		me.disableAddButton(true);
		me.disablePagingToolBar(true);
	},
	
	onDeleteClick : function() {
		var me = this;
		var grid = me;
		//Validado = 1 (Sí), Validado = 2 (No)
		var validado = me.getSelection()[0].getData().validado;
		var idSuministro = me.getSelection()[0].getData().idSuministro;
		if(validado != '1' && validado != undefined){
			Ext.Msg.show({
				title : HreRem.i18n('title.mensaje.confirmacion'),
				msg : HreRem.i18n('msg.desea.eliminar'),
				buttons : Ext.MessageBox.YESNO,
				fn : function(buttonId) {
					if (buttonId == 'yes') {
						grid.mask(HreRem.i18n("msg.mask.loading"));
						var url = $AC.getRemoteUrl('activo/deleteSuministroActivo');
						Ext.Ajax.request({
							url : url,
							method : 'POST',
							params: {
								idSuministro: idSuministro
							},
							success : function(response, opts) {
								grid.getStore().load();
								me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								grid.unmask();
							},
							failure : function(record, operation) {
								me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
								grid.unmask();
							},
							callback : function(record, operation) {
								grid.unmask();
							}
						});
					}
				}
			});
		}else{
			me.fireEvent("errorToast", "No se puede eliminar un registro validado");
		}
	}
});