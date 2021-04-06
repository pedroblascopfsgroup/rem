Ext.define('HreRem.view.activos.detalle.SuministrosActivoGrid', {
	extend:'HreRem.view.common.GridBaseEditableRow',
	xtype:'suministrosactivogrid',
	reference: 'suministrosactivogridref',
	controller: 'activodetalle',
	topBar: true,
	editable: true,
	bind: {
		store: '{storeSuministrosActivo}',
		editando: '{editingRows}'
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
				dataIndex: 'tipoSuministroDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					reference: 'comboDDTipoSuministroRef',
					bind: {
						store: '{comboDDTipoSuministro}',
						value: '{suministrosactivogridref.selection.tipoSuministro}',
						rawValue: '{suministrosactivogridref.selection.tipoSuministroDescripcion}'
					},
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.subtipoSuministro'),
				dataIndex: 'subtipoSuministroDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					bind: {
						store: '{comboDDSubtipoSuministro}',
						value: '{suministrosactivogridref.selection.subtipoSuministro}',
						rawValue: '{suministrosactivogridref.selection.subtipoSuministroDescripcion}'
					},
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.companiaSuministradora'),
				dataIndex: 'companiaSuministroDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					bind: {
						store: '{comboDDCompaniaSuministradora}',
						value: '{suministrosactivogridref.selection.companiaSuministro}',
						rawValue: '{suministrosactivogridref.selection.companiaSuministroDescripcion}'
					},
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.domiciliado'),
				dataIndex: 'domiciliadoDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					bind: {
						store: '{comboDDDomiciliado}',
						value: '{suministrosactivogridref.selection.domiciliado}',
						rawValue: '{suministrosactivogridref.selection.domiciliadoDescripcion}'
					},
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.numContrato'),
				dataIndex: 'numContrato',
				flex:0.5,
				editor: {
					xtype: 'textfield',
					allowBlank: true
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.numCups'),
				dataIndex: 'numCups',
				flex:0.5,
				editor: {
					xtype: 'textfield',
					allowBlank: true
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.periodicidad'),
				dataIndex: 'periodicidadDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					bind: {
						store: '{comboDDPeriodicidad}',
						value: '{suministrosactivogridref.selection.periodicidad}',
						rawValue: '{suministrosactivogridref.selection.periodicidadDescripcion}'
					},
					allowBlank: true
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
					allowBlank: false
				}
			},
			{
				text:HreRem.i18n('fieldlabel.suministros.motivoAltaSuministro'),
				dataIndex: 'motivoAltaDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					bind: {
						store: '{comboDDMotivoAltaSuministro}',
						value: '{suministrosactivogridref.selection.motivoAlta}',
						rawValue: '{suministrosactivogridref.selection.motivoAltaDescripcion}'
					},
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
				dataIndex: 'motivoBajaDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					bind: {
						store: '{comboDDMotivoBajaSuministro}',
						value: '{suministrosactivogridref.selection.motivoBaja}',
						rawValue: '{suministrosactivogridref.selection.motivoBajaDescripcion}'
					}
				}
			},
			{
				name: 'suministroValidado',
				reference: 'suministroValidado',
				text:HreRem.i18n('fieldlabel.suministros.validado'),
				dataIndex: 'validadoDescripcion',
				flex:0.5,
				editor: {
					xtype: 'comboboxfieldbasedd',
					addUxReadOnlyEditFieldPlugin: false,
					bind: {
						store: '{comboDDValidado}',
						disabled: '{!editarCheckValidado}',
						value: '{suministrosactivogridref.selection.validado}',
						rawValue: '{suministrosactivogridref.selection.validadoDescripcion}'
					},
					allowBlank: true
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