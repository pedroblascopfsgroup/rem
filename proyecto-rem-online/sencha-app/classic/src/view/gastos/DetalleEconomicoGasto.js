Ext.define('HreRem.view.gastos.DetalleEconomicoGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'detalleeconomicogasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'detalleeconomicogastoref',
    scrollable	: 'y',
	recordName: "detalleeconomico",
	
	recordClass: "HreRem.model.DetalleEconomicoGasto",
    
    requires: ['HreRem.model.DetalleEconomicoGasto'],
    
    listeners: {
		boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.gasto.detalle.economico'));
        var items= [
       
	    						{   
									xtype:'fieldsettable',
//									bind: {
//					        			disabled: '{conEmisor}'
//			            			},
									title: HreRem.i18n('title.gasto.detalle.economico'),
									items :
										[
											{   
												xtype:'fieldset',
												border: false,
												defaultType: 'textfieldbase',
												height: 250,
				        						margin: '10 10 10 0',
												items :
													[
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.principal.sujeto'),
											                bind: '{detalleeconomico.importePrincipalSujeto}',
											                reference: 'importePrincipalSujeto',
											                allowBlank: false,
											                listeners: {
											                	change: 'onCambiaImportePrincipalSujeto'
											                }
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.principal.no.sujeto'),
															reference: 'importePrincipalNoSujeto',
											                bind: '{detalleeconomico.importePrincipalNoSujeto}',
											                allowBlank: false,
											                listeners: {
											                	change: 'onCambiaImportePrincipalNoSujeto'
											                }
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.recargo'),
											                bind: '{detalleeconomico.importeRecargo}'
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.interes.demora'),
											                bind: '{detalleeconomico.importeInteresDemora}'
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.costas'),
											                bind: '{detalleeconomico.importeCostas}'
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.otros.incrementos'),
											                bind: '{detalleeconomico.importeOtrosIncrementos}'
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.provisiones.suplidos'),
											                bind: '{detalleeconomico.importeProvisionesSuplidos}'
														}
													
													]
											},
											{   
												xtype:'fieldset',
												defaultType: 'textfieldbase',
												height: 250,
				        						margin: '0 10 10 0',
												title: HreRem.i18n('title.gasto.detalle.economico.impuesto.indirecto'),
												items :
													[
														{ 
															xtype: 'comboboxfieldbase',
											               	fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.tipo.impuesto.indirecto'),
													      	bind: {
												           		store: '{comboTipoImpuesto}',
												           		value: '{detalleeconomico.impuestoIndirectoTipoCodigo}'
												         	},
												         	allowBlank: false
													    },
													    {		                
										                	xtype: 'checkboxfieldbase',
										                	fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.operacion.exenta'),
										                	readOnly: false,
										                	bind: {
//								        						disabled:'{!esOfertaVenta}',
								        						value: '{detalleeconomico.impuestoIndirectoExento}'
						            						}
					                					},
					                					{		                
										                	xtype: 'checkboxfieldbase',
										                	fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.renuncia.exencion'),
										                	readOnly: false,
										                	bind: {
//								        						disabled:'{!esOfertaVenta}',
								        						value: '{detalleeconomico.renunciaExencionImpuestoIndirecto}'
						            						}
					                					},
					                					{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.porcentaje"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.tipo.impositivo'),
											                bind: '{detalleeconomico.impuestoIndirectoTipoImpositivo}',
											                allowBlank: false
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.cuota'),
											                bind: '{detalleeconomico.impuestoIndirectoCuota}',
											                editable: false
														}
													
													]
											},
											{   
												xtype:'fieldset',
												defaultType: 'textfieldbase',
												height: 250,
				        						margin: '0 10 10 0',
												title: HreRem.i18n('title.gasto.detalle.economico.impuesto.directo.retencion'),
												items :
													[
//														{
//															xtype: 'textfieldbase',
//															fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.tipo.impuesto.directo'),
//											                bind:		'{detalleeconomico.tipoImpuestoDirecto}'
//														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.porcentaje"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.tipo.impositivo'),
											                bind: '{detalleeconomico.irpfTipoImpositivo}',
											                allowBlank: false
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.retencion'),
											                bind: '{detalleeconomico.irpfCuota}'
														}
													
													]
											},
											{
												xtype: 'numberfieldbase',
												style: {
													backgroundColor: '#E5F6FE'
												},
												symbol: HreRem.i18n("symbol.euro"),
												fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.total'),
											    bind: '{detalleeconomico.importeTotal}',
											    editable: false
											}
											
										
										
										
											
										]
					           },
           
					           {   
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',				
									title: HreRem.i18n('title.gasto.detalle.economico.pago'),
									items :
										[
											{
									        	xtype:'datefieldbase',
												formatter: 'date("d/m/Y")',
												reference: 'fechaTopePago',
										       	fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.fecha.tope.pago'),
										       	bind: '{detalleeconomico.fechaTopePago}',
										       	maxValue: null,
										       	listeners: {
										       		change: 'onHaCambiadoFechaTopePago'
										       	},
										       	allowBlank: false
										    },
										    { 
												xtype:'comboboxfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.repercutible.inquilino'),
												readOnly:true,
												reference: 'comboRepercutibleInquilino',
								        		bind: {
							            			store: '{comboSiNoRem}',
							            			value: '{detalleeconomico.repercutibleInquilino}'
							            		}
									        },
									        { 
												xtype: 'numberfieldbase',
												symbol: HreRem.i18n("symbol.euro"),
												style: {
													backgroundColor: '#E5F6FE'
												},
												fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.pagado'),
											    bind: '{detalleeconomico.importePagado}'
											},
											{ 
												xtype: 'comboboxfieldbase',
											    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.responsable.pago.fuera.plazo'),
											    reference: 'destinatariosPago',
												bind: {
													store: '{comboDestinatarioPago}',
												    value: '{detalleeconomico.destinatariosPagoCodigo}'
												},
												allowBlank: true,
												colspan: 2
											},
											{
									        	xtype:'datefieldbase',
												formatter: 'date("d/m/Y")',
												reference: 'fechaPago',
										       	fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.fecha.pago'),
										       	bind: '{detalleeconomico.fechaPago}',
										       	listeners: {
										       		change: 'onHaCambiadoFechaPago'
										       	},
										       	maxValue: null
										    },
										    {
										    	xtype: 'box'
											},
											{
												xtype: 'box'
											},
											{ 
												xtype: 'comboboxfieldbase',
											    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.responsable.pagado.por'),
												bind: {
													store: '{comboPagadoPor}',
												    value: '{detalleeconomico.tipoPagadorCodigo}'
												}
											},
											{		                
											    xtype: 'checkboxfieldbase',
											    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.reembolsar.pago'),
											    bind: {
										        	value: '{detalleeconomico.reembolsoTercero}'
							            		},
							            		listeners: {
							            			change: 'haCambiadoReembolsarPagoTercero'
							            		},
							            		reference: 'reembolsarPagoRef',
							            		colspan: 3
					                		},
											
											{   
												xtype:'fieldsettable',
												reference: 'fieldSetSuplido',
												colspan: 3,
												defaultType: 'textfieldbase',				
												title: HreRem.i18n('title.gasto.detalle.economico.suplido'),
												items :
													[
														{   
															xtype:'fieldset',
															defaultType: 'textfieldbase',
															bind: {
																disabled: '{!esReembolsoPago}'
															},
															reference: 'fieldGestoria',
															margin: '10 0 0 0',
															height: 175,
															items :
																[
																	{		                
																	    xtype: 'checkboxfieldbase',
																	    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.incluir.pago.provision'),
																	    bind: {
																        	value: '{detalleeconomico.incluirPagoProvision}'
													            		},
													            		listeners: {
													            			change: 'haCambiadoPagadoProvision'
													            		},
													            		reference: 'incluirPagoProvisionRef'
											                		}
											                	]
														},
														{   
															xtype:'fieldset',
															defaultType: 'textfieldbase',
															reference: 'fieldAbonar',
															bind: {
																disabled: '{!esReembolsoPago}'
															},
															margin: '10 0 0 0',
															height: 175,
															width: 450,
															items :
																[
																	{		                
																	    xtype: 'checkboxfieldbase',
																	    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.abonar.cuenta'),
																	    bind: {
																        	value: '{detalleeconomico.abonoCuenta}'
													            		},
													            		listeners: {
													            			change: 'haCambiadoAbonoCuenta'
													            		},
													            		reference: 'abonoCuentaRef',
													            		colspan: 3
											                		},
											                		{				                	
																		xtype      : 'fieldcontainer',
																		fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.iban'),
																		name : 	'iban',
																		reference: 'ibanRef',
																		bind: {disabled: '{!seleccionadoAbonar}'},
																		defaults: {
																			flex: 1
																		},
																		colspan: 3,
																		layout: 'hbox',
																		items: [
																			{		                
																			    xtype: 'textfieldbase',
																			    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.iban'),
																			    reference: 'iban',
																			    bind: {
																		        	value: '{detalleeconomico.iban}'
															            		},
															            		hidden: true
													                		},
																			{
																				xtype: 'textfieldbase',
																				reference: 'iban1',
																				style: {
																					backgroundColor: '#E5F6FE'
																				},
																				width: 55,
																				maxLength: 4,
																				minLengthText: 'Debe tener 4 digitos',
																				bind: {
																		        	value: '{detalleeconomico.iban1}'
															            		},
															            		listeners: {
															            			change: 'haCambiadoIban'
															            		}
																			},
																			{
																				xtype: 'textfieldbase',
																				reference: 'iban2',
																				style: {
																					backgroundColor: '#E5F6FE'
																				},
																				width: 55,
																				maxLength: 4,
																				bind: {
																		        	value: '{detalleeconomico.iban2}'
															            		},
															            		listeners: {
															            			change: 'haCambiadoIban'
															            		}
																			},
																			{
																				xtype: 'textfieldbase',
																				reference: 'iban3',
																				style: {
																					backgroundColor: '#E5F6FE'
																				},
																				width: 55,
																				maxLength: 4,
																				bind: {
																		        	value: '{detalleeconomico.iban3}'
															            		},
															            		listeners: {
															            			change: 'haCambiadoIban'
															            		}
															           
																			},
																			{
																				xtype: 'textfieldbase',
																				reference: 'iban4',
																				style: {
																					backgroundColor: '#E5F6FE'
																				},
																				width: 55,
																				maxLength: 4,
																				bind: {
																		        	value: '{detalleeconomico.iban4}'
															            		}
																			},
																			{
																				xtype: 'textfieldbase',
																				reference: 'iban5',
																				style: {
																					backgroundColor: '#E5F6FE'
																				},
																				width: 55,
																				maxLength: 4,
																				bind: {
																		        	value: '{detalleeconomico.iban5}'
															            		},
															            		listeners: {
															            			change: 'haCambiadoIban'
															            		}
																			},
																			{
																				xtype: 'textfieldbase',
																				reference: 'iban6',
																				style: {
																					backgroundColor: '#E5F6FE'
																				},
																				width: 55,
																				maxLength: 4,
																				bind: {
																		        	value: '{detalleeconomico.iban6}'
															            		},
															            		listeners: {
															            			change: 'haCambiadoIban'
															            		}
																			}
																		]
																	},
											                		{		                
																	    xtype: 'textfieldbase',
																	    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.titular.cuenta'),
																	    bind: {
																        	value: '{detalleeconomico.titularCuenta}',
																        	disabled: '{!seleccionadoAbonar}'
													            		},
													            		reference: 'titularCuentaRef',
													            		colspan: 3
											                		},
											                		{		                
																	    xtype: 'textfieldbase',
																	    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.nif.titular.cuenta'),
																	    bind: {
																        	value: '{detalleeconomico.nifTitularCuenta}',
																        	disabled: '{!seleccionadoAbonar}'
													            		},
													            		reference: 'nifTitularCuentaRef',
													            		colspan: 3
											                		}
											                	]
														},
														{   
															xtype:'fieldset',
															defaultType: 'textfieldbase',
															reference: 'fieldBankia',
															bind: {
																disabled: '{!esReembolsoPago}'
															},
															margin: '10 0 0 0',
															height: 175,
															
															items :
																[
																	{		                
																	    xtype: 'checkboxfieldbase',
																	    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.pagado.bankia'),
																	    bind: {
																        	value: '{detalleeconomico.pagadoConexionBankia}'
													            		},
													            		listeners: {
													            			change: 'haCambiadoPagadoBankia'
													            			
													            		},
													            		reference: 'pagadoConexionBankiaRef',
													            		colspan: 3
											                		},
											                		{ 
																		xtype: 'textfieldbase',
																	    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.oficina'),
																		bind: {
																		    value: '{detalleeconomico.oficina}',
																		    disabled: '{!seleccionadoPagadoBankia}'
																		},
																		reference: 'oficinaRef'
																		
																	},
											                		{		                
																	    xtype: 'textfieldbase',
																	    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.numero.conexion'),
																	    bind: {
																        	value: '{detalleeconomico.numeroConexion}',
																        	disabled: '{!seleccionadoPagadoBankia}'
													            		},
													            		reference: 'numeroConexionRef'
											                		}
											                	]
														}
								                		
								                		
													
													]
											}
										]
								}
						
			

			
           
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);
    	
    }
});