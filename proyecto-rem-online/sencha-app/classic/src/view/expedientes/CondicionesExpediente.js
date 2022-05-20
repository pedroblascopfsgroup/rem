Ext.define('HreRem.view.expedientes.CondicionesExpediente', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'condicionesexpediente',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	disableValidation : false,
	reference : 'condicionesExpediente',
	scrollable : 'y',
	recordName : "condiciones",
	recordClass : "HreRem.model.CondicionesExpediente",
	requires : [ 'HreRem.model.CondicionesExpediente','HreRem.view.common.GridBaseEditableRow'],
	refreshAfterSave: true, 
	listeners : {
		boxready : 'cargarTabData',
		afterrender: 'evaluarLabelCaixa'
	},
	initComponent : function() {
		var me = this;
		me.setTitle(HreRem.i18n('title.condiciones'));
		var isBK = me.lookupController().getViewModel().get('expediente.esBankia');
		var isAlquiler = me.lookupController().getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
		var isAlquilerNoComercial = me.lookupController().getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER_NO_COMERCIAL"];
		var tamanyo1 = 100;
		
		if(isBK && (isAlquiler || isAlquilerNoComercial)){
			 tamanyo1 = 130;
		}	

		var items = [
			{
				xtype : 'fieldset',
				collapsible : true,
				defaultType : 'displayfieldbase',
				title : HreRem.i18n('title.economicas'),
				reference: 'tituloVentaRef',
				bind : {
					hidden : '{!esOfertaVenta}'
				},
				items : [
					{
						xtype : 'button',
						text : HreRem.i18n('btn.enviar.condicionantes'),
						handler : 'enviarCondicionantesEconomicosUvem',
						margin : '10 40 5 10',
						bind : {
							hidden : '{!esCarteraBankia}'
						}
					},
					{
						xtype : 'fieldsettable',
						collapsible : false,
						border : false,
						defaultType : 'displayfieldbase',
						items : [
							{
								xtype : 'fieldset',
								height : 140,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 2
						        	},
						        	bind: {
								    	disabled: '{!esOfertaVenta}'
						            },
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.reserva"),
									items :
										[
										
											{ 
									        	xtype: 'comboboxfieldbase',
									        	fieldLabel: HreRem.i18n('fieldlabel.reserva.necesaria'),
									        	reference: 'tieneReserva',
									        	bind: {
								            		store: '{comboSiNoRem}',
								            		value: '{condiciones.solicitaReserva}',
								            		readOnly: '{esCarteraGaleonOZeus}'
								            	},
								            	listeners: {
								            		change: 'onHaCambiadoSolicitaReserva'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
									        },
									        {	
												/*
												 * Esto es un campo en blanco para que, en caso de que el activo
												 * no sea cartera Agora, los campos de Reserva queden correctamente
												 * alineados
												 */ 
									        	bind: {
									        		hidden: '{esCarteraAppleOAgora}',
									        		readOnly: '{!esCarteraAppleOAgora}'
												}
											},
									        {
												xtype : 'numberfieldbase',
												reference : 'depositoReserva',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.deposito.reserva'),
												bind : {
													value: '{condiciones.depositoReserva}',
													hidden: '{!esCarteraAppleOAgora}'
												},
												maxValue : 3000,
												minValue : 0
											},
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.calculo.reserva'),
							                	reference: 'tipoCalculo',
									        	bind: {
								            		store: '{comboTipoCalculo}',
								            		value: '{condiciones.tipoCalculo}',
													disabled: '{esCarteraGaleonOZeus}'
								            	},
					            				displayField: 'descripcion',
		    									valueField: 'codigo',
		    									listeners: {
			                						change:  'onHaCambiadoTipoCalculo'
			            						}
									        },
											{ 
												xtype: 'numberfieldbase',
												reference: 'porcentajeReserva',
										 		symbol: HreRem.i18n("symbol.porcentaje"),
												fieldLabel: HreRem.i18n('fieldlabel.portencaje.reserva'),
				                				bind: {
				                					value: '{condiciones.porcentajeReserva}',
				                					readOnly: '{esCarteraGaleonOZeus}'
				                				},
				                				reference: 'porcentajeReserva',
				                				listeners: {
							                		change:  'onHaCambiadoPorcentajeReserva'
							            		},
				                				disabled: true
							                },
							                { 
							                	xtype: 'numberfieldbase',
							                	reference: 'plazoParaFirmar',
										 		symbol: HreRem.i18n("symbol.dias"),
							                	fieldLabel: HreRem.i18n('fieldlabel.plazo.firmar'),
							                	bind: {
							                		value: '{condiciones.plazoFirmaReserva}'
							                	},
							                	reference: 'plazoFirmaReserva',
							                	disabled: true
							                },
							                { 
							                	xtype : 'currencyfieldbase',
										 		fieldLabel: HreRem.i18n('fieldlabel.importe.reserva'),
										 		bind: {
										 			value: '{condiciones.importeReserva}'
										 		},
										 		reference: 'importeReserva',
										 		disabled: true
											}
							                
				
										]
								},
							{
								xtype : 'fieldset',
								height : 140,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 2
								},
								defaultType : 'textfieldbase',
								title : HreRem.i18n("fieldlabel.fiscales"),
								items : [
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.tipo.impuesto'),
										reference: 'comboTipoImpuestoFiscalidad', 
										bind : {
											store : '{comboTipoImpuesto}',
											value : '{condiciones.tipoImpuestoCodigo}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										listeners : {
											change : 'onCambioTipoImpuesto'
										}
									},
									{
										xtype : 'numberfieldbase',
										reference : 'tipoAplicable',
										symbol : HreRem.i18n("symbol.porcentaje"),
										fieldLabel : HreRem.i18n('fieldlabel.tipo.aplicable'),
										bind : {
											value : '{condiciones.tipoAplicable}'
										}
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'chckboxOperacionExenta',
										fieldLabel : HreRem.i18n('fieldlabel.operacion.exenta'),
										bind : {
											value : '{condiciones.operacionExenta}',
											readOnly : '{!esOfertaVenta}',
											hidden: isBK
										},
										listeners : {
											change : 'onCambioOperacionExenta'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.grupo.impuesto'),
										reference : 'grupoImpuestoRef',

										bind : {
											store : '{comboGrupoImpuesto}',
											value : '{condiciones.tipoGrupoImpuestoCod}',
											hidden: !isBK
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										listeners : {
											change : 'onCambioGrupoImpuesto'
										}
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'chkboxInversionSujetoPasivo',
										fieldLabel : HreRem.i18n('fieldlabel.inversion.sujeto.pasivo'),
										bind : {
											value : '{condiciones.inversionDeSujetoPasivo}',
											readOnly : '{!esOfertaVenta}',
											hidden: isBK
										},
										listeners : {
											change : 'onCambioInversionSujetoPasivo'
										}
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'chkboxRenunciaExencion',
										fieldLabel : HreRem.i18n('fieldlabel.renuncia.exencion'),
										bind : {
											value : '{condiciones.renunciaExencion}',
											readOnly : '{!esOfertaVenta}'
										},
										listeners : {
											change : 'onCambioRenunciaExencion'
										}
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'chkboxReservaConImpuesto',
										fieldLabel : HreRem.i18n('fieldlabel.reserva.con.impuesto'),
										bind : {
											value : '{condiciones.reservaConImpuesto}',
											readOnly : '{!esOfertaVenta}',
											hidden: isBK
										}
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'chkboxTributosPropiedad',
										fieldLabel : HreRem.i18n('fieldlabel.tributos.sobre.propiedad'),
										bind : {
											value : '{condiciones.tributosSobrePropiedad}',
											readOnly : '{!esOfertaVenta}'
										}
									},
									{
									   xtype: 'checkboxfieldbase',
									   fieldLabel: HreRem.i18n('fieldlabel.necesidadIf'),
									   reference: 'necesidadIfExpedienteRef',
									   bind : {
								     		value: '{condiciones.necesidadIf}'
									   },
									   hidden: true
									}
								]
							}
						]
					},
					{
						xtype : 'fieldsettable',
						collapsible : false,
						border : false,
						defaultType : 'displayfieldbase',
						items : [
							{
								xtype : 'fieldset',
								bind : {
									hidden : '{!esOfertaVenta}'
								},
								height : 145,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 2
								},
								defaultType : 'textfieldbase',
								title : HreRem.i18n("fieldlabel.gastos.compraventa"),
								items : [
									{
										xtype : 'numberfieldbase',
										reference : 'gastosCompraventaPlusvalia',
										symbol : HreRem.i18n("symbol.euro"),
										fieldLabel : HreRem.i18n('fieldlabel.plusvalia'),
										bind : '{condiciones.gastosPlusvalia}',
										listeners : {
											change : 'onHaCambiadoPlusvalia'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
										bind : {
											store : '{comboTiposPorCuenta}',
											value : '{condiciones.plusvaliaPorCuentaDe}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										reference : 'plusvaliaPorCuentaDe'
									},
									{
										xtype : 'numberfieldbase',
										reference : 'gastosCompraventaNotaria',
										symbol : HreRem.i18n("symbol.euro"),
										fieldLabel : HreRem.i18n('fieldlabel.notaria'),
										bind : '{condiciones.gastosNotaria}',
										listeners : {
											change : 'onHaCambiadoNotaria'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
										bind : {
											store : '{comboTiposPorCuenta}',
											value : '{condiciones.notariaPorCuentaDe}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										reference : 'notariaPorCuentaDe'
									},
									{
										xtype : 'numberfieldbase',
										reference : 'gastosCompraventaOtros',
										symbol : HreRem.i18n("symbol.euro"),
										fieldLabel : HreRem.i18n('fieldlabel.otros'),
										bind : '{condiciones.gastosOtros}',
										listeners : {
											change : 'onHaCambiadoCompraVentaOtros'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
										bind : {
											store : '{comboTiposPorCuenta}',
											value : '{condiciones.gastosCompraventaOtrosPorCuentaDe}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										reference : 'compraventaOtrosPorCuentaDe'
									}
								]
							},
							{
								xtype : 'fieldsettable',
								bind : {
									hidden : '{esOfertaVenta}'
								},
								collapsible : false,
								border : false,
								defaultType : 'displayfieldbase',
								items : [
									{
										xtype : 'fieldset',
										height : 145,
										margin : '0 10 10 0',
										layout : {
											type : 'table',
											columns : 2
										},
										defaultType : 'textfieldbase',
										title : HreRem.i18n("fieldlabel.gastos.alquiler"),
										items : [
											{
												xtype : 'numberfieldbase',
												reference : 'gastosAlquilerIbi',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.ibi'),
												bind : '{condiciones.gastosIbi}',
												listeners : {
													change : 'onHaCambiadoIbi'
												}
											},
											{
												xtype : 'comboboxfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
												bind : {
													store : '{comboTiposPorCuenta}',
													value : '{condiciones.ibiPorCuentaDe}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												reference : 'ibiPorCuentaDe'
											},
											{
												xtype : 'numberfieldbase',
												reference : 'gastosAlquilerComunidad',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.comunidad'),
												bind : '{condiciones.gastosComunidad}',
												listeners : {
													change : 'onHaCambiadoComunidad'
												}
											},
											{
												xtype : 'comboboxfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
												bind : {
													store : '{comboTiposPorCuenta}',
													value : '{condiciones.comunidadPorCuentaDe}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												reference : 'comunidadPorCuentaDe'
											},
											{
												xtype : 'numberfieldbase',
												reference : 'gastosAlquilerSuministros',
												symbol : HreRem.i18n("symbol.euro"),
												fieldLabel : HreRem.i18n('fieldlabel.suministros'),
												bind : '{condiciones.gastosSuministros}',
												listeners : {
													change : 'onHaCambiadoAlquilerSuministros'
												}
											},
											{
												xtype : 'comboboxfieldbase',
												fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
												bind : {
													store : '{comboTiposPorCuenta}',
													value : '{condiciones.suministrosPorCuentaDe}'
												},
												displayField : 'descripcion',
												valueField : 'codigo',
												reference : 'suministrosPorCuentaDe'
											}
										]
									}
								]
							},
							{
								xtype : 'fieldset',
								height : 145,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 2
								},
								defaultType : 'displayfieldbase',
								bind : {
									disabled : '{!esOfertaVenta}'
								},
								title : HreRem.i18n("fieldlabel.cargas.Pendientes"),
								items : [
									{
										xtype : 'datefieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.fecha.ultima.actualizacion'),
										bind : '{condiciones.fechaUltimaActualizacion}',
										readOnly : true
									},
									{
										// Esto es un espacio en blanco en el panel 
										// ocupando el lugar de un item.
									},
									{
										xtype : 'displayfieldbase',
										reference : 'cargasPendientesImpuestos',
										symbol : HreRem.i18n('symbol.euro'),
										fieldLabel : HreRem
												.i18n('fieldlabel.impuestos'),
										bind : '{condiciones.impuestos}'
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
										bind : {
											store : '{comboTiposPorCuenta}',
											value : '{condiciones.impuestosPorCuentaDe}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										reference : 'impuestosPorCuentaDe',
										allowBlank : '{!esImpuestoMayorQueCero}'
									},
									{
										xtype : 'displayfieldbase',
										reference : 'cargasPendientesComunidades',
										symbol : HreRem.i18n('symbol.euro'),
										fieldLabel : HreRem
												.i18n('fieldlabel.comunidades'),
										bind : '{condiciones.comunidades}'
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
										bind : {
											store : '{comboTiposPorCuenta}',
											value : '{condiciones.comunidadesPorCuentaDe}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										allowBlank : '{!esComunidadesMayorQueCero}',
										reference : 'comunidadesPorCuentaDe'

									},
									{
										xtype : 'numberfieldbase',
										reference : 'cargasPendientesOtros',
										symbol : HreRem.i18n('symbol.euro'),
										fieldLabel : HreRem
												.i18n('fieldlabel.otros'),
										bind : '{condiciones.cargasOtros}',
										listeners : {
											change : 'onHaCambiadoCargasPendientesOtros'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.por.cuenta.de'),
										bind : {
											store : '{comboTiposPorCuenta}',
											value : '{condiciones.cargasPendientesOtrosPorCuentaDe}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										reference : 'cargasPendientesOtrosPorCuentaDe'
									}
								]
							}
						]
					}
				]
			},
			{
				xtype:'fieldsettable',
				colspan: 3,
				title: HreRem.i18n("title.expediente.condiciones.activos.alquilados"),
				items :[
					{
						xtype: "activosAlquiladosGrid", 
						reference: "activosAlquiladosGrid",
						colspan: 3
					}
				]
       		},
			{

				xtype : 'fieldset',
				collapsible : true,
				defaultType : 'displayfieldbase',
				title : HreRem.i18n('title.economicas'),
				reference: 'tituloAlquilerRef',
				bind : {
					hidden : '{esOfertaVenta}'
				},
				layout : {
					type : 'table',
					columns : 2
				},
				items : [
					{
						xtype : 'fieldset',
						collapsible : false,
						layout : {
							type : 'table',
							columns : 2
						},
						bind:{
							hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
						},
						margin: '0 0 0 10',
						colspan: 2,
						border : false,
						defaultType : 'displayfieldbase',
						items : [
							{
								xtype : 'checkboxfieldbase',
								reference : 'renunciaTanteoRetracto',
								fieldLabel : HreRem.i18n('fieldlabel.renuncia.tanteo.retracto'),
								bind : {
									value : '{condiciones.renunciaTanteo}'
								}
							},
							{
								xtype : 'checkboxfieldbase',
								reference : 'chekboxReservaConImpuesto',
								fieldLabel : HreRem.i18n('fieldlabel.derecho.cesion.subarriendo'),
								bind : {
									value : '{condiciones.derechoCesionSubarriendo}'
								},
								readOnly : false
							}
						]
					},
					{
						xtype : 'fieldset',
						collapsible : false,
						layout : {
							type : 'table',
							columns : 1
						},
						margin : '0 0 10 10',
						colspan: 1,
						border : false,
						defaultType : 'displayfieldbase',
						items : [

							{
								xtype : 'fieldset',
								height : tamanyo1,
								layout : {
									type : 'table',
									columns : 2
								},
								defaultType : 'textfieldbase',
								title : HreRem.i18n("fieldlabel.fianza"),
								items : [
									{
										xtype : 'numberfieldbase',
										reference : 'mesesDeposito',
										fieldLabel : HreRem.i18n('fieldlabel.meses'),
										bind : '{condiciones.mesesFianza}',
										readOnly : false
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'chekboxReservaConImpuesto',
										fieldLabel : HreRem.i18n('fieldlabel.fianza.actualizable'),
										bind : {
											value : '{condiciones.fianzaActualizable}'
										},
										readOnly : false
									},
									{
										xtype : 'numberfieldbase',
										reference : 'importeDeposito',
										fieldLabel : HreRem.i18n('fieldlabel.importe'),
										symbol : HreRem.i18n('symbol.euro'),
										bind : '{condiciones.importeFianza}',
										readOnly : false
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'fianzaExoneradaRef',
										fieldLabel : HreRem.i18n('fieldlabel.fianza.exonerada'),
										bind : {
											value : '{condiciones.fianzaExonerada}',
											hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
										}
									},
									{
										xtype : 'datefieldbase',
										reference : 'fechaIngresoFianzaArrendatarioRef',
										fieldLabel : HreRem.i18n('fieldlabel.fecha.ingreso'),
										bind : {
											value : '{condiciones.fechaIngresoFianzaArrendatario}',
											hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
										}
									}
								]
							} 
						]
					},
					{
						xtype : 'fieldset',
						collapsible : false,
						border : false,
						layout : {
							type : 'table',
							columns : 1
						},
						bind:{
							hidden: '{esBankiaAlquilerOAlquilerNoComercial}'
						},
						defaultType : 'displayfieldbase',
						items : [
						 	{
								xtype : 'fieldset',
								height : 130,
								layout : {
									type : 'table',
									columns : 2
								},
								title : HreRem.i18n("fieldlabel.fiador.solidario"),
								items : [
									{
										xtype : 'textfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.avalista'),
										bind : {
											value : '{condiciones.avalista}'
										}
									},
									{
										xtype : 'textfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.documento'),
										maxLength : 9,
										bind : {
											value : '{condiciones.documentoFiador}'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.entidad.bancaria'),
										bind : {
											store : '{comboEntidadesAvalistas}',
											value : '{condiciones.codigoEntidad}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										reference : 'entidadBancariaFiador'
									},
									{
										// Esto es un espacio en blanco en el panel 
										// ocupando el lugar de un item.
									},
									{
										xtype : 'numberfieldbase',
										reference : 'numeroDeposito',
										fieldLabel : HreRem.i18n('fieldlabel.numero.aval'),
										bind : '{condiciones.numeroAval}',
										readOnly : false
									},
									{
										xtype : 'numberfieldbase',
										reference : 'importeDeposito',
										fieldLabel : HreRem.i18n('fieldlabel.importe.aval'),
										bind : '{condiciones.importeAval}',
										symbol : HreRem.i18n('symbol.euro'),
										readOnly : false
									}
								]
							} 
						]
					},
					
					{
						xtype : 'fieldset',
						height : 130,
						layout : {
							type : 'table',
							columns : 2
						},
						colspan: 1,
						bind:{
							hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
						},
						margin : '0 0 20 10',
						defaultType : 'textfieldbase',
						title : HreRem.i18n("fieldlabel.duracion"),
						items : [
							{
								xtype : 'numberfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.meses.duracion'),
								bind : {
									value : '{condiciones.mesesDuracion}'
								}
							},
							{
								xtype : 'numberfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.anyos.obligado.cump'),
								bind : {
									value : '{condiciones.obligadoCumplimiento}'
								}
							},
							{
								xtype : 'datefieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.fecha.preaviso.vencimiento.cnt'),
								maxValue: null,
								bind : {
									value : '{condiciones.fechaPreavisoVencimientoCnt}'
								}
							}
						]
					},
					{
						xtype : 'fieldset',
						height : 130,
						layout : {
							type : 'table',
							columns : 2
						},
						defaultType : 'textfieldbase',
						bind:{
							hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
						},
						margin : '0 0 20 10',
						title : HreRem.i18n("fieldlabel.fiscalidad"),
						items : [
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.tipo.impuesto'),
								bind : {
									store : '{comboTipoImpuesto}',
									value : '{condiciones.tipoImpuestoCodigoAlq}'
								},
								displayField : 'descripcion',
								valueField : 'codigo',
								listeners : {
									change : 'onCambioTipoImpuesto2'
								}
							},
							{
								xtype : 'numberfieldbase',
								reference : 'tipoAplicableBk',
								symbol : HreRem.i18n("symbol.porcentaje"),
								fieldLabel : HreRem.i18n('fieldlabel.tipo.aplicable'),
								bind : {
									value : '{condiciones.tipoAplicable}'
								}
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.grupo.impuesto'),
								reference : 'grupoImpuestoRef2',

								bind : {
									store : '{comboGrupoImpuesto}',
									value : '{condiciones.tipoGrupoImpuestoCodAlq}'
								},
								displayField : 'descripcion',
								valueField : 'codigo',
								listeners : {
									change : 'onCambioGrupoImpuesto'
								}
							}
						]
					},
					{
						xtype : 'fieldset',
						layout : {
							type : 'table',
							columns : 4
						},
						colspan: 4,
						margin : '0 0 20 10',
						height : 130,
						defaultType : 'textfieldbase',
						title : HreRem.i18n("fieldlabel.no.comercial"),
						bind:{
							hidden : '{!esBankiaAlquilerOAlquilerNoComercial}'
						},
						items : [
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.vulnerabilidad'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.vulnerabilidadDetectada}'
								},
								readOnly: true,
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.regimen.fianza.ccaa'),
								bind : {
									store : '{storeRegimenFianzaCCAA}',
									value : '{condiciones.regimenFianzaCCAACodigo}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.ofr.nuevas.condiciones'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.ofrNuevasCondiciones}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.fianza.contratos.subrogados'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.fianzaContratosSubrogados}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.cnt.suscrito.post.adj'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.cntSuscritoPosteridadAdj}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.ant.deudor.iloc'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.antiguoDeudorLocalizable}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.certificaciones'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.certificaciones}'
								},
								readOnly: true,
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.adecuaciones'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.adecuaciones}'
								},
								readOnly: true,
								displayField : 'descripcion',
								valueField : 'codigo'
							}
						]
					}
				]
			},
			{
				xtype : 'fieldset',
				layout : {
					type : 'table',
					columns : 2
				},
				defaultType : 'textfieldbase',
				title : HreRem.i18n("fieldlabel.renta.contrato"),
				bind:{
					hidden : '{!esBankiaAlquilerOAlquilerNoComercial}'
				},
				items : [
					{
						xtype : 'fieldset',
						height : 80,
						margin : '10 10 20 10',
						layout : {
							type : 'table',
							columns : 2
						},
						items : [
							{
								xtype : 'checkboxfieldbase',
								reference : 'carenciasBk',
								margin : '5 0 0 0',
								fieldLabel : HreRem.i18n('fieldlabel.carencia'),
								colspan: 2,
								bind : {
									value : '{condiciones.carencia}'
								},
								listeners : {
									change : 'onChangeCarencia'
								}
							},
							{
								xtype : 'numberfieldbase',
								reference : 'mesesCarenciaBk',
								name : 'mesesCarencia',
								margin : '5 0 0 0',
								fieldLabel : HreRem.i18n('fieldlabel.meses'),
								bind : {
									value : '{condiciones.mesesCarencia}',
									disabled : '{!condiciones.siCarencia}'
								}
							},
							{
								xtype : 'numberfieldbase',
								reference : 'importeCarenciaBk',
								name : 'importeCarencia',
								margin : '5 0 0 0',
								fieldLabel : HreRem.i18n('fieldlabel.importe'),
								symbol : HreRem
										.i18n('symbol.euro'),
								bind : {
									value : '{condiciones.importeCarencia}',
									disabled : '{!condiciones.siCarencia}'
								}
							} 
						]
					},
					{
						xtype : 'fieldset',
						height : 80,
						margin : '10 10 20 10',
						layout : {
							type : 'table',
							columns : 2
						},
						items : [
							{
								xtype : 'checkboxfieldbase',
								reference : 'bonificacionBk',
								margin : '5 0 0 0',
								fieldLabel : HreRem.i18n('fieldlabel.bonificacion'),
								colspan: 2,
								bind : {
									value : '{condiciones.bonificacion}'
								},
								listeners : {
									change : 'onChangeBonificacion'
								}
							},
							{
								xtype : 'numberfieldbase',
								reference : 'mesesBonificacionBk',
								name : 'mesesBonificacion',
								margin : '5 0 0 0',
								fieldLabel : HreRem.i18n('fieldlabel.duracion.meses'),
								bind : {
									value : '{condiciones.mesesBonificacion}',
									disabled : true
								}
							},
							{
								xtype : 'numberfieldbase',
								reference : 'importeBonificacionBk',
								name : 'importeBonificacion',
								margin : '5 0 0 0',
								fieldLabel : HreRem.i18n('fieldlabel.importe'),
								symbol : HreRem.i18n('symbol.euro'),
								bind : {
									value : '{condiciones.importeBonificacion}',
									disabled : '{!condiciones.bonificacion}'
								}
							} 
						]
					},
					{
						xtype : 'fieldset',
						height : 350,
						margin : '0 10 20 10',
						layout : {
							type : 'table',
							columns : 2
						},
						reference:'fieldsetActualizacionRenta',
						title : HreRem.i18n("fieldlabel.actualizacion.renta"),
						colspan: 2,
						items : [
							{
								xtype : 'fieldset',
								margin : '0 10 0 0',
								layout : {
									type : 'table',
									columns : 2
								},
								border: false,
								height : 320,
								items : [
									{
										xtype : 'comboboxfieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.metodo.actualizacion'),
										reference:'comboMetodoActualizacionRentaRef', 
										colspan: 2,
										bind : {
											store : '{storeMetodoActualizacionRenta}',
											value : '{condiciones.metodoActualizacionRentaCod}'
										},
										displayField : 'descripcion',
										valueField : 'codigo',
										listeners : {
											change : 'onChangeMetodoActualizacion'
										}
									},
									{
										xtype : 'datefieldbase',
										reference : 'fechaActualizacionRenta',
										fieldLabel : HreRem.i18n('header.fecha'),
										disabled: true,
										maxValue: null,
										minValue: $AC.getCurrentDate(),
										bind:{
											value:'{condiciones.fechaActualizacion}'
										}
									},
									{
										xtype : 'numberfieldbase',
										reference : 'periodicidadBk',
										name : 'periodicidadBk',
										margin : '5 0 0 0',
										fieldLabel : HreRem.i18n('fieldlabel.periodicidad.meses'),
										disabled: true,
										bind : {
											value : '{condiciones.periodicidadMeses}'
										}
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'checkboxIPC',
										fieldLabel : HreRem.i18n('fieldlabel.ipc'),
										disabled: true,
										bind : {
											value : '{condiciones.checkIPC}'
										}
									},		
									{
										xtype : 'checkboxfieldbase',
										reference : 'checkIGC',
										fieldLabel : HreRem.i18n('fieldlabel.igc'),
										disabled: true,
										bind : {
											value : '{condiciones.checkIGC}'
										}
									}
								]
							},
							{
								xtype : 'fieldset',
								layout : {
									type : 'table',
									columns : 1
								},
								border: false,
								height : 320,
								items : [
									{
										xtype:'actualizacionRentaGrid',
										reference: 'actualizacionRentaGridRef',
										disabled: true,
										width: 700
									}
								]
							}
						]
					},
					{
						xtype : 'fieldset',
						height : 70,
						margin : '0 10 20 10',
						layout : {
							type : 'table',
							columns : 3
						},
						title : HreRem.i18n("fieldlabel.adelantos"),
						colspan: 2,
						items : [
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.rentas.a.cuenta'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.rentasCuenta}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.entregas.a.cuenta'),
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{condiciones.entregasCuenta}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'numberfieldbase',
								reference : 'importeEntregasACuentaBk',
								name : 'importeEntregasACuentaBk',
								margin : '5 0 0 0',
								fieldLabel : HreRem.i18n('fieldlabel.importe.a.cuenta'),
								symbol : HreRem.i18n('symbol.euro'),
								bind : {
									value : '{condiciones.importeEntregasCuenta}'
								}
							} 
						]
					}
				]
			},
			{
				xtype : 'fieldset',
				layout : {
					type : 'table',
					columns : 3
				},
				bind: {
					hidden : '{!esBankiaAlquilerOAlquilerNoComercial}'
				},
			
				defaultType : 'textfieldbase',
				title : HreRem.i18n("fieldlabel.gastos.repercutidos"),
				items : [
					{
						xtype:'gastosRepercutidosGrid',
						reference:'gastosRepercutidosGridRef',
						width: 700
					}
				]
			},
			{
				xtype : 'fieldset',
				collapsible : true,
				defaultType : 'displayfieldbase',
				title : HreRem.i18n('fieldlabel.fiscales'),
				bind : {
					hidden : '{!esAlquilerNoBk}'
				},
				items : [
					{
						xtype : 'fieldsettable',
						collapsible : false,
						border : false,
						items : [
							{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.tipo.impuesto'),
								bind : {
									store : '{comboTiposImpuesto}',
									value : '{condiciones.tipoImpuestoCodigo}'
								},
								displayField : 'descripcion',
								valueField : 'codigo'
							},
							{
								xtype : 'numberfieldbase',
								reference : 'tipoAplicable2',
								symbol : HreRem.i18n("symbol.porcentaje"),
								fieldLabel : HreRem.i18n('fieldlabel.tipo.aplicable'),
								bind : {
									value : '{condiciones.tipoAplicable}'
								}
							},
							{
								xtype : 'checkboxfieldbase',
								reference : 'renunciaTanteoRetracto',
								fieldLabel : HreRem.i18n('fieldlabel.renuncia.tanteo.retracto'),
								bind : {
									value : '{condiciones.renunciaTanteo}'
								}
							}
						]
					},
					{
						xtype : 'fieldsettable',
						collapsible : false,
						border : false,
						items : [
							{
								xtype : 'fieldset',
								height : 100,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 1
								},
								items : [
									{
										xtype : 'checkboxfieldbase',
										reference : 'carencias',
										fieldLabel : HreRem.i18n('fieldlabel.carencia'),
										bind : {
											value : '{condiciones.carencia}'
										},
										listeners : {
											change : 'onChangeCarencia'
										}
									},
									{
										xtype : 'numberfieldbase',
										reference : 'mesesCarencia',
										name : 'mesesCarencia',
										fieldLabel : HreRem.i18n('fieldlabel.meses'),
										bind : {
											value : '{condiciones.mesesCarencia}',
											disabled : '{!condiciones.siCarencia}'
										}
									},
									{
										xtype : 'numberfieldbase',
										reference : 'importeCarencia',
										name : 'importeCarencia',
										fieldLabel : HreRem.i18n('fieldlabel.importe'),
										symbol : HreRem
												.i18n('symbol.euro'),
										bind : {
											value : '{condiciones.importeCarencia}',
											disabled : '{!condiciones.siCarencia}'
										}
									} 
								]
							},
							{
								xtype : 'fieldset',
								height : 100,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 1
								},
								items : [
									{
										xtype : 'checkboxfieldbase',
										reference : 'bonificacion',
										fieldLabel : HreRem.i18n('fieldlabel.bonificacion'),
										bind : {
											value : '{condiciones.bonificacion}'
										},
										listeners : {
											change : 'onChangeBonificacion'
										}
									},
									{
										xtype : 'numberfieldbase',
										reference : 'mesesBonificacion',
										name : 'mesesBonificacion',
										fieldLabel : HreRem.i18n('fieldlabel.duracion.meses'),
										bind : {
											value : '{condiciones.mesesBonificacion}'
										}
									},
									{
										xtype : 'numberfieldbase',
										reference : 'importeBonificacion',
										name : 'importeBonificacion',
										fieldLabel : HreRem.i18n('fieldlabel.importe'),
										symbol : HreRem.i18n('symbol.euro'),
										bind : {
											value : '{condiciones.importeBonificacion}'
										}
									} 
								]
							},
							{
								xtype : 'fieldset',
								height : 100,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 1
								},
								defaultType : 'textfieldbase',
								items : [
									{
										xtype : 'checkboxfieldbase',
										reference : 'gastosRepercutibles',
										fieldLabel : HreRem.i18n('fieldlabel.gastos.repercutibles'),
										bind : {
											value : '{condiciones.gastosRepercutibles}'
										},
										listeners : {
											change : 'onChangeRepercutibles'
										}
									},
									{
										xtype : 'textareafieldbase',
										fieldLabel : HreRem.i18n('fieldlabel.comentarios'),
										reference : 'textareafieldcondicioncomentariosgastos',
										bind : {
											value : '{condiciones.repercutiblesComments}',
											disabled : '{!condiciones.esRepercutible}'
										},
										maxWidth : 500,
										maxLength : 200
									} 
								]
							}
						]
					},
					{
						xtype : 'fieldsettable',
						collapsible : false,
						border : false,
						items : [
							{
								xtype : 'fieldset',
								height : 100,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 1
								},
								defaultType : 'textfieldbase',
								items : [
									{
										xtype : 'checkboxfieldbase',
										reference : 'chekboxPorcentual',
										fieldLabel : HreRem.i18n('fieldlabel.porcentual'),
										bind : {
											value : '{condiciones.checkPorcentual}'
										},
										listeners : {
											change : 'onCambioCheckPorcentual'
										}
									},
									{
										xtype : 'checkboxfieldbase',
										reference : 'checkboxIPC',
										fieldLabel : HreRem.i18n('fieldlabel.ipc'),
										bind : {
											value : '{condiciones.checkIPC}'
										}
									},
									{
										xtype : 'numberfieldbase',
										reference : 'escaladoRentaPorcentaje',
										symbol : HreRem.i18n('symbol.porcentaje'),
										fieldLabel : HreRem.i18n('fieldlabel.porcentaje'),
										bind : {
											value : '{condiciones.porcentaje}'
										}
									} 
								]
							},
							{
								xtype : 'fieldset',
								height : 100,
								margin : '0 10 10 0',
								layout : {
									type : 'table',
									columns : 1
								},
								defaultType : 'textfieldbase',
								items : [
									{
										xtype : 'checkboxfieldbase',
										reference : 'chekboxRevisionMercado',
										fieldLabel : HreRem.i18n('fieldlabel.revision.mercado'),
										bind : {
											value : '{condiciones.checkRevisionMercado}'
										},
										listeners : {
											change : 'onCambioCheckRevMercado'
										}
									},
									{
										xtype : 'datefieldbase',
										reference : 'revisionMercadoFecha',
										fieldLabel : HreRem.i18n('fieldlabel.fecha'),
										bind : '{condiciones.revisionMercadoFecha}'
									},
									{
										xtype : 'numberfieldbase',
										reference : 'escaladoRentasMeses',
										symbol : HreRem.i18n('symbol.meses'),
										fieldLabel : HreRem.i18n('fieldlabel.cada'),
										bind : '{condiciones.revisionMercadoMeses}'
									} 
								]
							} 
						]
					},
					{
						xtype : 'fieldsettable',
						collapsible : false,
						border : false,
						items : [
							{
								xtype : 'fieldset',
								margin : '0 10 10 0',
								defaultType : 'textfieldbase',
								items : [
									{
										xtype : 'checkboxfieldbase',
										reference : 'checkboxEscaladoFijo',
										fieldLabel : HreRem.i18n('fieldlabel.fijo'),
										bind : {
											value : '{condiciones.checkFijo}'
										},
										listeners : {
											change : 'onCambioCheckEscaladoFijo'
										}
									},
									{
										xtype:'fieldsettable',
										title:HreRem.i18n('title.administracion.activo.tipo.impuesto'),
										defaultType: 'textfieldbase',
										items :
											[
												{xtype: "historicoCondicones", reference: "historicoCondicones"}
											]
									}  
								]

							} 
						]
					}
				]
			},
			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',
				bind: {
					hidden: '{!esOfertaVenta}',
					disabled: '{!esOfertaVenta}'
				},
				title: HreRem.i18n('title.condicionantes.administrativos'),
				items : [
				
							{ 
								xtype:'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.vpo'),
								reference: 'comboVpo',
								bind: {
			            			store: '{comboSiNoRem}',
			            			value: '{condiciones.vpo}'
			            		},
		    					listeners: {
		    						edit:  'cargaValorVpo'
			            		}
					        },
					        { 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.procede.descalificacion'),
			                	reference: 'procedeDescalificacionRef',
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.procedeDescalificacion}'
				            	},
				            	listeners: {
				            		change: 'onHaCambiadoProcedeDescalificacion'
				            	},
		    					disabled: true
					        },
					        { 
								xtype: 'comboboxfieldbase',
							    fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
								bind: {
									store: '{comboTiposPorCuenta}',
								    value: '{condiciones.procedeDescalificacionPorCuentaDe}'
								},
								reference: 'procedeDescalificacionPorCuentaDe',
								disabled: true
					        },	
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.licencia'),
					        	bind: {
				            		value: '{condiciones.licencia}'
				            	},
				            	listeners: {
				            		change: 'onHaCambiadoLicencia'
				            	}
					        },
					        
					        {
					        					        						        	
					        },
					        { 
								xtype: 'comboboxfieldbase',
							    fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
								bind: {
									store: '{comboTiposPorCuenta}',
								    value: '{condiciones.licenciaPorCuentaDe}'
								},
								reference: 'licenciaPorCuentaDe',
								disabled: true
					        }
				
				
		        ]
			}
		];
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
		me.down('[reference=actualizacionRentaGridRef]').getStore().load();
		me.down('[reference=gastosRepercutidosGridRef]').getStore().load();

	}
});