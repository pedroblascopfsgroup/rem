Ext.define('HreRem.view.expedientes.FormalizacionExpediente', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'formalizacionexpediente',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	disableValidation : true,
	reference : 'formalizacionExpediente',
	scrollable : 'y',
	saveMultiple : true,
	records : ['resolucion', 'financiacion'],
	recordsClass : ['HreRem.model.ExpedienteFormalizacionResolucion',
			'HreRem.model.ExpedienteFinanciacion'],
	requires : ['HreRem.model.ExpedienteFormalizacionResolucion',
			'HreRem.model.ExpedienteFinanciacion',
			'HreRem.view.expedientes.BloqueosFormalizacionList',
			'HreRem.model.BloqueosFormalizacionModel',
			'HreRem.view.expedientes.Desbloquear'],
	listeners : {
		boxready : 'cargarTabData'
	},

	initComponent : function() {
		var me = this;
		me.setTitle(HreRem.i18n('title.formalizacion'));

		var coloredRender = function(value, meta, record) {
			var borrado = record.get('fechaFinPosicionamiento');
			if (value) {
				if (borrado) {
					return '<span style="color: #DF0101;">' + value + '</span>';
				} else {
					return value;
				}
			} else {
				return '-';
			}
		};

		var dateColoredRender = function(value, meta, record) {
			var valor = dateRenderer(value);
			return coloredRender(valor, meta, record);
		};

		var hourColoredRender = function(value, meta, record) {
			var valor = hourRenderer(value);
			return coloredRender(valor, meta, record);
		};

		var dateRenderer = function(value, rec) {
			if (!Ext.isEmpty(value)) {
				var newDate = new Date(value);
				var formattedDate = Ext.Date.format(newDate, 'd/m/Y');
				return formattedDate;
			} else {
				return value;
			}
		}

		var hourRenderer = function(value, rec) {
			if (!Ext.isEmpty(value)) {
				var newDate = new Date(value);
				var formattedDate = Ext.Date.format(newDate, 'H:i');
				return formattedDate;
			} else {
				return value;
			}
		}

		var items = [
				// Apartado Financiación.
				{
			xtype : 'fieldsettable',
			collapsible : false,
			bind : {
				hidden : '{!esOfertaVenta}',
				disabled : '{!esOfertaVenta}'
			},
			defaultType : 'displayfieldbase',
			title : HreRem.i18n('title.financiacion'),
			items : [{
						xtype : 'comboboxfieldbase',
						fieldLabel : HreRem
								.i18n('fieldlabel.solicita.financiacion'),
						bind : {
							store : '{comboSiNoRem}',
							value : '{financiacion.solicitaFinanciacion}'
						},
						displayField : 'descripcion',
						valueField : 'codigo',
						listeners : {
							change : 'onHaCambiadoSolicitaFinanciacion'
						}
					},
					{
						xtype : 'textfieldbase',
						fieldLabel : HreRem
								.i18n('fieldlabel.entidad.financiera'),
						bind : '{financiacion.entidadFinanciacion}',
						reference : 'entidadFinanciacion',
						disabled : true
					},
					{
						xtype : 'datefieldbase',
						formatter : 'date("d/m/Y")',
						reference : 'fechaInicioExpediente',
						fieldLabel : HreRem
								.i18n('fieldlabel.inicio.expediente'),
						bind : '{financiacion.fechaInicioExpediente}',
						maxValue : null
					},
					// Subapartado de Bankia.
					{
						xtype : 'fieldsettable',
						collapsible : false,
						bind : {
							hidden : '{!expediente.esBankia}'
						},
						defaultType : 'displayfieldbase',
						title : HreRem
								.i18n('title.formalizacion.financiacion.bankia'),
						colspan : 3,
						//rowspan : 3,
						items : [
								// Subapartado consulta.
								{
							xtype : 'fieldsettable',
							defaultType : 'textfieldbase',
							collapsible : false,
							title : HreRem
									.i18n('title.formalizacion.financiacion.consulta'),
							colspan : 2,
							rowspan : 4,
							margin : '0 15 0 0',
							items : [{
								xtype : 'textfieldbase',
								reference : 'numExpedienteRiesgo',
								fieldLabel : HreRem
										.i18n('fieldlabel.num.expediente'),
								bind : {
									value:'{financiacion.numExpedienteRiesgo}',
									hidden : '{!expediente.esBankia}'
								},
								maxLength : 250,
								colspan : 3
							},

							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem
										.i18n('fieldlabel.tipo.financiacion'),
								reference : 'comboTipoFinanciacion',
								bind : {
									store : '{comboTiposFinanciacion}',
									value : '{financiacion.tiposFinanciacionCodigoBankia}',
									hidden : '{!expediente.esBankia}'
								},
								colspan : 3
							}, {
								xtype : 'button',
								reference : 'botonConsultaFormalizacionBankia',
								disabled : true,
								bind : {
									disabled : '{!editing}',
									hidden : '{!expediente.esBankia}'
								},
								text : 'Consultar',
								handler : 'onClickConsultaFormalizacionBankia',
								margin : '0 0 15 110'
							}]
						},
								// Campos derecha.
								{
									xtype : 'comboboxfieldbase',
									fieldLabel : HreRem
											.i18n('fieldlabel.estado.expediente'),
									bind : {
										store : '{comboEstadosFinanciacion}',
										value : '{financiacion.estadosFinanciacionBankia}',
										hidden : '{!expediente.esBankia}'
									}
									// hidden: true
								}, {
									xtype : 'currencyfieldbase',
									fieldLabel : HreRem
											.i18n('fieldlabel.capital.concedido'),
									reference : 'cncyCapitalConcedido',
									readOnly : true,
									bind : {
										value: '{financiacion.capitalConcedido}',
										hidden : '{!expediente.esBankia}'
									}
								}, {
									xtype : 'datefieldbase',
									formatter : 'date("d/m/Y")',
									reference : 'fechaInicioFinanciacionBankia',
									fieldLabel : HreRem
											.i18n('fieldlabel.inicio.financiacion'),
									bind : {
										value:'{financiacion.fechaInicioFinanciacion}',
										hidden : '{!expediente.esBankia}'
									},
									maxValue : null,
									listeners : {
										change : 'onHaCambiadoFechaInicioFinanciacionBankia'
									}
									// hidden: true
								}, {
									xtype : 'datefieldbase',
									formatter : 'date("d/m/Y")',
									reference : 'fechaFinFinanciacionBankia',
									fieldLabel : HreRem.i18n('fieldlabel.fin.financiacion'),
									bind : {
										value: '{financiacion.fechaFinFinanciacion}',
										hidden : '{!expediente.esBankia}'
									},
									maxValue : null,
									listeners : {
										change : 'onHaCambiadoFechaFinFinanciacionBankia'
									}
									// hidden: true
								}]
					}, {
						xtype : 'textfieldbase',
						fieldLabel : HreRem.i18n('fieldlabel.num.expediente'),
						bind : {
							value : '{financiacion.numExpedienteRiesgo}',
							hidden : '{expediente.esBankia}'
						},
						maxLength : 250
						// colspan: 3,

				}	, {
						xtype : 'comboboxfieldbase',
						fieldLabel : HreRem
								.i18n('fieldlabel.tipo.financiacion'),
						bind : {
							store : '{comboTiposFinanciacion}',
							value : '{financiacion.tiposFinanciacionCodigo}',
							hidden : '{expediente.esBankia}'
						}
						// colspan: 3,

					},

					 {
						xtype : 'datefieldbase',
						formatter : 'date("d/m/Y")',
						reference : 'fechaInicioFinanciacion',
						fieldLabel : HreRem
								.i18n('fieldlabel.inicio.financiacion'),
						bind : {
							value : '{financiacion.fechaInicioFinanciacion}',
							hidden : '{expediente.esBankia}'
						},
						maxValue : null,
						listeners : {
							change : 'onHaCambiadoFechaInicioFinanciacion'
						}
						// hidden: true
					}, {
						xtype : 'datefieldbase',
						formatter : 'date("d/m/Y")',
						reference : 'fechaFinFinanciacion',
						fieldLabel : HreRem.i18n('fieldlabel.fin.financiacion'),
						bind : {
							value : '{financiacion.fechaFinFinanciacion}',
							hidden : '{expediente.esBankia}'
						},
						maxValue : null,
						listeners : {
							change : 'onHaCambiadoFechaFinFinanciacion'
						}
						// hidden: true
					}, 

					{
						xtype : 'comboboxfieldbase',
						fieldLabel : HreRem.i18n('fieldlabel.estado.expediente'),
						bind : {
							store : '{comboEstadosFinanciacion}',
							value : '{financiacion.estadosFinanciacion}',
							hidden : '{expediente.esBankia}'
						}
					}, {
						xtype : 'currencyfieldbase',
						fieldLabel : HreRem
								.i18n('fieldlabel.capital.concedido'),
						readOnly : true,
						bind : {
							value : '{financiacion.capitalConcedido}',
							hidden : '{expediente.esBankia}'
						}
					}

			]
		},
				// Apartado Posicionamiento y Firma.
				{
					xtype : 'fieldset',
					collapsible : true,
					defaultType : 'displayfieldbase',
					cls : 'panel-base shadow-panel',
					title : HreRem.i18n('title.posicionamiento.firma'),
					items : [{
						xtype : 'gridBaseEditableRow',
						title : HreRem.i18n('title.posicionamiento'),
						reference : 'listadoposicionamiento',
						idPrincipal : 'expediente.id',
						topBar : true,
						bind : {
							store : '{storePosicionamientos}',
							topBar : '{!esExpedienteBloqueado}'
						},
						listeners : {
							rowdblclick : 'comprobarCamposFechas',
							beforeedit : 'comprobarCamposFechas',
							rowclick : 'onRowClickPosicionamiento'
						},
						columns : [{
									text : HreRem
											.i18n('fieldlabel.fecha.aviso'),
									dataIndex : 'fechaAviso',
									// formatter: 'date("d/m/Y")',
									flex : 1,
									editor : {
										xtype : 'datefield',
										reference : 'fechaAvisoRef',
										listeners : {
											change : 'changeFecha'
										}
									},
									hidden : true,
									renderer : dateColoredRender
								}, {
									text : HreRem.i18n('fieldlabel.hora.aviso'),
									dataIndex : 'horaAviso',
									// formatter: 'date("H:i")',
									flex : 0.5,
									editor : {
										xtype : 'timefieldbase',
										addUxReadOnlyEditFieldPlugin : false,
										labelWidth : 150,
										format : 'H:i',
										increment : 15,
										reference : 'horaAvisoRef',
										disabled : true,
										allowBlank : true,
										listeners : {
											change : 'changeHora'
										}
									},
									hidden : true,
									renderer : hourColoredRender
								}, {
									text : HreRem.i18n('fieldlabel.fecha.alta'),
									dataIndex : 'fechaAlta',
									// formatter: 'date("d/m/Y")',
									flex : 1,
									renderer : dateColoredRender
								}, {
									text : HreRem
											.i18n('fieldlabel.fecha.posicionamiento'),
									dataIndex : 'fechaPosicionamiento',
									// formatter: 'date("d/m/Y")',
									flex : 1,
									editor : {
										xtype : 'datefield',
										reference : 'fechaPosicionamientoRef',
										allowBlank : false,
										listeners : {
											change : 'changeFecha'
										},
										validator : function(value) {
											return this
													.up('expedientedetallemain')
													.getController()
													.validarFechaPosicionamiento(value);
										}
									},
									renderer : dateColoredRender
								}, {
									text : HreRem
											.i18n('fieldlabel.hora.posicionamiento'),
									dataIndex : 'horaPosicionamiento',
									// formatter: 'date("H:i")',
									flex : 0.5,
									editor : {
										xtype : 'timefieldbase',
										addUxReadOnlyEditFieldPlugin : false,
										labelWidth : 150,
										format : 'H:i',
										increment : 15,
										reference : 'horaPosicionamientoRef',
										disabled : true,
										allowBlank : true,
										listeners : {
											change : 'changeHora'
										}
									},
									renderer : hourColoredRender
								}, {
									text : HreRem.i18n('fieldlabel.notaria'),
									dataIndex : 'idProveedorNotario',
									flex : 1,
									renderer : function(value, meta, record) {
										var me = this;
										if (Ext.isEmpty(value)
												&& meta.record
														.get('fechaFinPosicionamiento')) {
											return '<span style="color: #DF0101;">-</span>';
										} else if (Ext.isEmpty(value)
												&& !meta.record
														.get('fechaFinPosicionamiento')) {
											return '-';
										} else {
											var comboEditor = me.columns
													&& me
															.down('gridcolumn[dataIndex=idProveedorNotario]').getEditor
													? me
															.down('gridcolumn[dataIndex=idProveedorNotario]')
															.getEditor()
													: me.getEditor ? me
															.getEditor() : null;
											if (!Ext.isEmpty(comboEditor)) {
												var store = comboEditor
														.getStore(), record = store
														.findRecord("id", value);
												if (!Ext.isEmpty(record)) {
													if (meta.record
															.get('fechaFinPosicionamiento')) {
														return '<span style="color: #DF0101;">'
																+ record
																		.get("descripcion")
																+ '</span>';
													} else {
														return record
																.get("descripcion");
													}
												} else {
													comboEditor.setValue(value);
												}
											}
										}

									},
									editor : {
										xtype : 'comboboxfieldbase',
										addUxReadOnlyEditFieldPlugin : false,
										store : Ext.create('Ext.data.Store', {
											model : 'HreRem.model.ComboBase',
											proxy : {
												type : 'uxproxy',
												remoteUrl : 'generic/getComboNotarios'
											},
											autoLoad : true
										}),
										displayField : 'descripcion',
										valueField : 'id'
									}
								}, {
									text : HreRem
											.i18n('fieldlabel.motivo.aplazamiento'),
									dataIndex : 'motivoAplazamiento',
									flex : 1,
									editor : {
										xtype : 'textarea',
										allowBlank : false
									},
									renderer : coloredRender
								}, {
									dataIndex : 'fechaHoraPosicionamiento',
									formatter : 'date("d/m/Y H:i")',
									hidden : true,
									resizble : false,
									width : 0,
									editor : {
										xtype : 'timefieldbase',
										hidden : true,
										format : 'd/m/Y H:i',
										reference : 'fechaHoraPosicionamientoRef'
									}
								}, {
									dataIndex : 'fechaHoraAviso',
									formatter : 'date("d/m/Y H:i")',
									hidden : true,
									resizble : false,
									width : 0,
									editor : {
										xtype : 'timefieldbase',
										hidden : true,
										format : 'd/m/Y H:i',
										reference : 'fechaHoraAvisoRef'
									}
								}],

						dockedItems : [{
									xtype : 'pagingtoolbar',
									dock : 'bottom',
									displayInfo : true,
									bind : {
										store : '{storePosicionamientos}'
									}
								}],

						saveSuccessFn : function() {
							var me = this;
							me
									.up('form')
									.down('gridBase[reference=listadoNotarios]')
									.getStore().load();
						},

						deleteSuccessFn : function() {
							var me = this;
							me
									.up('form')
									.down('gridBase[reference=listadoNotarios]')
									.getStore().load();
						},
						onDeleteClick : function(btn) {
							var me = this, seleccionados = btn.up('grid')
									.getSelection(), gridStore = btn.up('grid')
									.getStore();

							if (Ext.isArray(seleccionados)
									&& seleccionados.length != 0) {

								if (!Ext.isEmpty(me.selection
										.get('motivoAplazamiento'))) {
									Ext.Msg.show({
										title : HreRem
												.i18n("title.ventana.eliminar.posicionamiento"),
										message : HreRem
												.i18n("text.ventana.eliminar.posicionamiento"),
										buttons : Ext.Msg.YESNO,
										icon : Ext.Msg.QUESTION,
										fn : function(btn) {
											if (btn === 'yes') {

												me.selection.erase({
													params : {
														id : me.selection.data.id
													},
													success : function(a,
															operation, c) {
														me
																.fireEvent(
																		"infoToast",
																		HreRem
																				.i18n("msg.operacion.ok"));
														me.deleteSuccessFn();
														me.getStore().reload();
													},

													failure : function(a,
															operation) {
														var data = {};
														try {
															data = Ext
																	.decode(operation._response.responseText);
														} catch (e) {
														};
														if (!Ext
																.isEmpty(data.msg)) {
															me
																	.fireEvent(
																			"errorToast",
																			data.msg);
														} else {
															me
																	.fireEvent(
																			"errorToast",
																			HreRem
																					.i18n("msg.operacion.ko"));
														}
														me.deleteSuccessFn()
													}
												});

											}
										}
									});
								} else {
									me
											.fireEvent(
													"errorToast",
													HreRem
															.i18n("msg.operacion.eliminar.posicionamiento.motivo"));
								}
							}
						}
					}, {
						xtype : 'gridBase',
						reference : 'listadoNotarios',
						minHeight : 150,
						title : HreRem.i18n('title.notario'),
						cls : 'panel-base shadow-panel',
						bind : {
							store : '{storeNotarios}'
						},

						columns : [{
									text : HreRem.i18n('fieldlabel.nombre'),
									dataIndex : 'nombreProveedor',
									flex : 1
								}, {
									text : HreRem.i18n('header.direccion'),
									dataIndex : 'direccion',
									flex : 1
								}, {
									text : HreRem.i18n('header.provincia'),
									dataIndex : 'provincia',
									hidden : true,
									flex : 1
								}, {
									text : HreRem.i18n('header.municipio'),
									dataIndex : 'localidad',
									hidden : true,
									flex : 1
								}, {
									text : HreRem
											.i18n('fieldlabel.codigo.postal'),
									dataIndex : 'codigoPostal',
									hidden : true,
									flex : 1
								}, {
									text : HreRem
											.i18n('fieldlabel.personaContacto'),
									dataIndex : 'personaContacto',
									flex : 1
								}, {
									text : HreRem.i18n('fieldlabel.cargo'),
									dataIndex : 'cargo',
									flex : 1
								}, {
									text : HreRem.i18n('fieldlabel.telefono'),
									dataIndex : 'telefono1',
									flex : 1
								}, {
									text : HreRem.i18n('fieldlabel.telefono'),
									dataIndex : 'telefono2',
									hidden : true,
									flex : 1
								}, {
									text : HreRem.i18n('fieldlabel.fax'),
									dataIndex : 'fax',
									hidden : true,
									flex : 1
								}, {
									text : HreRem.i18n('fieldlabel.email'),
									dataIndex : 'email',
									flex : 1
								}]
					},
							// GRID COMPARECIENTES EN NOMBRE DEL VENDEDOR
							// {
							// xtype : 'gridBaseEditableRow',
							// title:
							// HreRem.i18n('title.comparecientes.nombre.vendedor'),
							// reference: 'listadocomparecientesnombrevendedor',
							// cls : 'panel-base shadow-panel',
							// topBar: true,
							// requires:
							// ['HreRem.view.expedientes.buscarCompareciente'],
							// bind: {
							// store: '{storeComparecientes}'
							// },
							//						
							// columns: [
							// { text:
							// HreRem.i18n('fieldlabel.tipo.comparecencia'),
							// dataIndex: 'tipoCompareciente',
							// flex: 1
							// },
							// { text: HreRem.i18n('fieldlabel.nombre'),
							// dataIndex: 'nombre',
							// flex: 1
							// },
							// {
							// text: HreRem.i18n('header.direccion'),
							// dataIndex: 'direccion',
							// flex: 1
							// },
							// {
							// text: HreRem.i18n('fieldlabel.telefono'),
							// dataIndex: 'telefono',
							// flex: 1
							// },
							// {
							// text: HreRem.i18n('fieldlabel.email'),
							// dataIndex: 'email',
							// flex: 1
							// }
							// ],
							// onAddClick: function (btn) {
							// var me = this;
							// Ext.create('HreRem.view.expedientes.BuscarCompareciente',{}).show();
							//							
							// }
							// },

							{
								xtype : 'button',
								reference : 'btnGenerarHojaDatos',
								bind : {
									disabled : '{!resolucion.generacionHojaDatos}'
								},
								text : HreRem.i18n('btn.generar.hoja.datos'),
								handler : 'onClickGenerarHojaExcel',
								margin : '10 10 10 10'
							}, {
								xtype : 'button',
								reference : 'btnDesBloquearExpediente',
								text : HreRem.i18n('title.bloquear.exp'),
								handler : 'onClickBloquearExpediente',
								margin : '10 10 10 10',
								bind : {
									disabled : '{expediente.bloqueado}'
								}
							}, {
								xtype : 'button',
								reference : 'btnBloquearExpediente',
								text : HreRem.i18n('title.desbloquear.exp'),
								handler : 'onClickDesbloquearExpediente',
								margin : '10 10 10 10',
								bind : {
									disabled : '{!expediente.bloqueado}'
								}
							}]
				},
				// Apartado Subsanaciones.
				{
					xtype : 'fieldset',
					collapsible : true,
					defaultType : 'displayfieldbase',
					title : HreRem.i18n('title.venta'),
					layout : {
						type : 'hbox',
						align : 'stretch'
					},
					items : [{
						xtype : 'container',
						layout : {
							type : 'vbox'
						},
						defaultType : 'textfieldbase',
						width : '50%',
						items : [{
							xtype : 'datefieldbase',
							formatter : 'date("d/m/Y")',
							fieldLabel : HreRem
									.i18n('fieldlabel.formalizacion.fecha.venta'),
							bind : '{resolucion.fechaVenta}'

						}, {
							xtype : 'button',
							reference : 'btnGenerarFacturaVenta',
							text : HreRem.i18n('btn.generar.factura.venta'),
							handler : 'onClickGenerarFacturaPdf',
							margin : '10 10 10 10',
							bind : {
								visible : '{expediente.isCarteraBankia}'
							}
						}]
					}, {
						xtype : 'container',
						layout : {
							type : 'vbox'
						},
						defaultType : 'textfieldbase',
						width : '50%',
						items : [{
							xtype : 'textfieldbase',
							fieldLabel : HreRem
									.i18n('fieldlabel.formalizacion.numero.protocolo'),
							bind : '{resolucion.numProtocolo}'
						}]
					}]
				}, {
					xtype : 'fieldset',
					collapsible : true,
					hidden : true,
					defaultType : 'displayfieldbase',
					title : HreRem.i18n('title.subsanaciones'),
					items : [{
						xtype : 'gridBase',
						reference : 'listadosubsanaciones',
						cls : 'panel-base shadow-panel',
						bind : {
							store : '{storeSubsanaciones}'
						},

						columns : [{
									text : HreRem.i18n('header.fecha.peticion'),
									dataIndex : 'fechaPeticion',
									formatter : 'date("d/m/Y")',
									flex : 1
								}, {
									text : HreRem
											.i18n('fieldlabel.peticionario'),
									dataIndex : 'peticionario',
									flex : 1
								}, {
									text : HreRem
											.i18n('fieldlabel.motivo.subsanaciones'),
									dataIndex : 'motivo',
									flex : 1
								}, {
									text : HreRem.i18n('fieldlabel.estado'),
									dataIndex : 'estado',
									flex : 1
								}, {
									text : HreRem
											.i18n('fieldlabel.tramite.subsanaciones'),
									dataIndex : 'tramiteSubsanacion',
									flex : 1,
									data : 'NO DEFINIDO'
								}, {
									text : HreRem
											.i18n('fieldlabel.gastos.subsanacion'),
									dataIndex : 'gastosSubsanacion',
									flex : 1
								}, {
									text : HreRem
											.i18n('fieldlabel.gastos.inscripcion'),
									dataIndex : 'gastosInscripcion',
									flex : 1
								}],

						dockedItems : [{
									xtype : 'pagingtoolbar',
									dock : 'bottom',
									displayInfo : true,
									bind : {
										store : '{storeSubsanaciones}'
									}
								}]
					}]
				},
				// Apartado Resolución.
				{
					xtype : 'fieldsettable',
					defaultType : 'displayfieldbase',
					hidden : true,
					title : HreRem.i18n('title.resolucion'),
					// recordName: "resolucion",
					// recordClass:
					// "HreRem.model.ExpedienteFormalizacionResolucion",
					layout : {
						type : 'hbox',
						align : 'stretch'
					},
					items : [{
						xtype : 'container',
						layout : {
							type : 'vbox'
						},
						defaultType : 'textfieldbase',
						width : '33%',
						items : [{
							xtype : 'displayfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.peticionario'),
							bind : '{resolucion.peticionario}'
						}, {
							xtype : 'displayfieldbase',
							fieldLabel : HreRem
									.i18n('fieldlabel.motivo.resolucion'),
							bind : '{resolucion.motivoResolucion}'
						}, {
							xtype : 'displayfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.gastos.cargo'),
							bind : '{resolucion.gastosCargo}'
						}

						]
					}, {
						xtype : 'container',
						layout : {
							type : 'vbox'
						},
						defaultType : 'textfieldbase',
						width : '33%',
						items : [{
									xtype : 'displayfieldbase',
									fieldLabel : HreRem
											.i18n('fieldlabel.forma.pago'),
									bind : '{resolucion.formaPago}'
								}, {
									xtype : 'displayfieldbase',
									formatter : 'date("d/m/Y")',
									fieldLabel : HreRem
											.i18n('fieldlabel.fecha.peticion'),
									bind : '{resolucion.fechaPeticion}'
								}, {
									xtype : 'displayfieldbase',
									formatter : 'date("d/m/Y")',
									fieldLabel : HreRem
											.i18n('fieldlabel.fecha.resolucion'),
									bind : '{resolucion.fechaResolucion}'
								}]
					}, {
						xtype : 'container',
						layout : {
							type : 'vbox'
						},
						defaultType : 'textfieldbase',
						width : '33%',
						items : [{
									xtype : 'displayfieldbase',
									fieldLabel : HreRem.i18n('header.importe'),
									symbol : HreRem.i18n("symbol.euro"),
									bind : '{resolucion.importe}'
								}, {
									xtype : 'displayfieldbase',
									formatter : 'date("d/m/Y")',
									fieldLabel : HreRem
											.i18n('fieldlabel.fecha.pago'),
									bind : '{resolucion.fechaPago}'
								}]

					}]
				}];

		me.addPlugin({
					ptype : 'lazyitems',
					items : items
				});
		me.callParent();
	},

	funcionRecargar : function() {
		var me = this;
		me.recargar = false;
		me.lookupController().cargarTabData(me);
	},

	funcionReloadExp : function() {
		var me = this;
		me.recargar = false;
		me.lookupController().refrescarExpediente(true);
	}
});