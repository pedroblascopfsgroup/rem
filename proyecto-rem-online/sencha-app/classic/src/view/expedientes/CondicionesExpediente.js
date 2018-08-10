Ext.define('HreRem.view.expedientes.CondicionesExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'condicionesexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'condicionesExpediente',
    scrollable	: 'y',

	recordName: "condiciones",
	
	recordClass: "HreRem.model.CondicionesExpediente",
    
    requires: ['HreRem.model.CondicionesExpediente'],
    
    listeners: {
			boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.condiciones'));
        var items= [

			{   
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.economicas'),
				bind: {
			    	hidden: '{!esOfertaVenta}'
	            },
				items : [
					{
						xtype: 'button',
						text: HreRem.i18n('btn.enviar.condicionantes'),
						handler: 'enviarCondicionantesEconomicosUvem',
						margin: '10 40 5 10',
						bind:{
							hidden: '{!esCarteraBankia}'
						}
					},
					{
						xtype:'fieldsettable',
						collapsible: false,
						
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
					
								{
						        	xtype:'fieldset',
						        	height: 140,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
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
									        	bind: {
								            		store: '{comboSiNoRem}',
								            		value: '{condiciones.solicitaReserva}'			            		
								            	},
								            	listeners: {
								            		change: 'onHaCambiadoSolicitaReserva'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						colspan: 2
									        },
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.calculo.reserva'),
							                	reference: 'tipoCalculo',
									        	bind: {
								            		store: '{comboTipoCalculo}',
								            		value: '{condiciones.tipoCalculo}'
								            	},
					            				displayField: 'descripcion',
		    									valueField: 'codigo',
		    									listeners: {
			                						change:  'onHaCambiadoTipoCalculo'
			            						},
			            						editable: true
									        },
											{ 
												xtype: 'numberfieldbase',
												reference: 'porcentajeReserva',
										 		symbol: HreRem.i18n("symbol.porcentaje"),
												fieldLabel: HreRem.i18n('fieldlabel.portencaje.reserva'),
				                				bind: {
				                					value: '{condiciones.porcentajeReserva}'
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
							                	xtype: 'numberfieldbase',
										 		symbol: HreRem.i18n("symbol.euro"),
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
						        	xtype:'fieldset',
						        	height: 140,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.fiscales"),
									items :
										[
											 {
									        	xtype: 'comboboxfieldbase',							        	
									        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.impuesto'),
									        	bind: {
								            		store: '{comboTiposImpuesto}',
								            		value: '{condiciones.tipoImpuestoCodigo}'
								            	},
					            				displayField: 'descripcion',
		    									valueField: 'codigo',
				                				listeners: {
				                					change: 'onCambioTipoImpuesto'
				                				}
									        },	
									        {
												xtype: 'numberfieldbase',
												reference: 'tipoAplicable',
										 		symbol: HreRem.i18n("symbol.porcentaje"),
												fieldLabel: HreRem.i18n('fieldlabel.tipo.aplicable'),
				                				bind: {
				                					value: '{condiciones.tipoAplicable}'
				                				}
							                },
							                {
							                	xtype: 'checkboxfieldbase',
							                	reference: 'chckboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.operacion.exenta'),
							                	bind: {
					        						value: '{condiciones.operacionExenta}',
							                		readOnly:'{!esOfertaVenta}'
			            						},
			            						listeners: {
				                					change: 'onCambioOperacionExenta'
				                				}
		                					},
									        {
							                	xtype: 'checkboxfieldbase',
							                	reference: 'chkboxInversionSujetoPasivo',
							                	fieldLabel:  HreRem.i18n('fieldlabel.inversion.sujeto.pasivo'),
							                	bind: {
					        						value: '{condiciones.inversionDeSujetoPasivo}',
							                		readOnly:'{!esOfertaVenta}'
			            						},
			            						listeners: {
				                					change: 'onCambioInversionSujetoPasivo'
				                				}
		                					},
		                					{		                
							                	xtype: 'checkboxfieldbase',
							                	reference: 'chkboxRenunciaExencion',
							                	fieldLabel:  HreRem.i18n('fieldlabel.renuncia.exencion'),
							                	bind: {
					        						value: '{condiciones.renunciaExencion}',
							                		readOnly:'{!esOfertaVenta}'
			            						},
			            						listeners: {
				                					change: 'onCambioRenunciaExencion'
				                				}
		                					},
									        {
							                	xtype: 'checkboxfieldbase',
							                	reference: 'chkboxReservaConImpuesto',
							                	fieldLabel:  HreRem.i18n('fieldlabel.reserva.con.impuesto'),
							                	bind: {
							                		value: '{condiciones.reservaConImpuesto}',
							                		readOnly:'{!esOfertaVenta}'
							                	}
		                					}
										]
						        	}
						        ]
					},
					{
						xtype:'fieldsettable',
						collapsible: false,
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
					
								{
						        	xtype:'fieldset',
						        	bind: {
					        			hidden: '{!esOfertaVenta}'
			                		},
						        	height: 145,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.gastos.compraventa"),
									items :
										[
											{ 
												xtype: 'numberfieldbase',
												reference: 'gastosCompraventaPlusvalia',
										 		symbol: HreRem.i18n("symbol.euro"),
												fieldLabel: HreRem.i18n('fieldlabel.plusvalia'),
				                				bind: '{condiciones.gastosPlusvalia}',
				                				listeners: {
				                					change: 'onHaCambiadoPlusvalia'
				                				}
							                },
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}'
								            		,value: '{condiciones.plusvaliaPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'plusvaliaPorCuentaDe'
					    						//,disabled: true
									        },
											
							                { 
												xtype: 'numberfieldbase',
												reference: 'gastosCompraventaNotaria',
										 		symbol: HreRem.i18n("symbol.euro"),
												fieldLabel: HreRem.i18n('fieldlabel.notaria'),
				                				bind: '{condiciones.gastosNotaria}',
				                				listeners: {
				                					change: 'onHaCambiadoNotaria'
				                				}
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.notariaPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'notariaPorCuentaDe'
					    						//,disabled: true
									        },
									        { 
												xtype: 'numberfieldbase',
												reference: 'gastosCompraventaOtros',
										 		symbol: HreRem.i18n("symbol.euro"),
												fieldLabel: HreRem.i18n('fieldlabel.otros'),
				                				bind: '{condiciones.gastosOtros}',
				                				listeners: {
				                					change: 'onHaCambiadoCompraVentaOtros'
				                				}
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.gastosCompraventaOtrosPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'compraventaOtrosPorCuentaDe'
					    						//,disabled: true
									        }
				
										]
								},
								
								{
									xtype:'fieldsettable',
									bind: {
					        			hidden: '{esOfertaVenta}'
			                		},
									collapsible: false,
									border: false,
										defaultType: 'displayfieldbase',				
										items : [
								
											{
									        	xtype:'fieldset',
									        	height: 145,
									        	margin: '0 10 10 0',
									        	layout: {
											        type: 'table',
									        		columns: 2
									        	},
												defaultType: 'textfieldbase',
												title: HreRem.i18n("fieldlabel.gastos.alquiler"),
												items :
													[
														{ 
															xtype: 'numberfieldbase',
															reference: 'gastosAlquilerIbi',
													 		symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.ibi'),
							                				bind: '{condiciones.gastosIbi}',
							                				listeners: {
							                					change: 'onHaCambiadoIbi'
							                				}
										                },
														{ 
															xtype: 'comboboxfieldbase',
										                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
												        	bind: {
											            		store: '{comboTiposPorCuenta}'
											            		,value: '{condiciones.ibiPorCuentaDe}'
											            	},
											            	displayField: 'descripcion',
								    						valueField: 'codigo',
								    						reference: 'ibiPorCuentaDe'
								    						//,disabled: true
												        },
														
										                { 
															xtype: 'numberfieldbase',
															reference: 'gastosAlquilerComunidad',
													 		symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.comunidad'),
							                				bind: '{condiciones.gastosComunidad}',
							                				listeners: {
							                					change: 'onHaCambiadoComunidad'
							                				}
										                },	
														{ 
															xtype: 'comboboxfieldbase',
										                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
												        	bind: {
											            		store: '{comboTiposPorCuenta}',
											            		value: '{condiciones.comunidadPorCuentaDe}'
											            	},
											            	displayField: 'descripcion',
								    						valueField: 'codigo',
								    						reference: 'comunidadPorCuentaDe'
								    						//,disabled: true
												        },
												        { 
															xtype: 'numberfieldbase',
															reference: 'gastosAlquilerSuministros',
													 		symbol: HreRem.i18n("symbol.euro"),
															fieldLabel: HreRem.i18n('fieldlabel.suministros'),
							                				bind: '{condiciones.gastosSuministros}',
							                				listeners: {
							                					change: 'onHaCambiadoAlquilerSuministros'
							                				}
										                },	
														{ 
															xtype: 'comboboxfieldbase',
										                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
												        	bind: {
											            		store: '{comboTiposPorCuenta}',
											            		value: '{condiciones.suministrosPorCuentaDe}'
											            	},
											            	displayField: 'descripcion',
								    						valueField: 'codigo',
								    						reference: 'suministrosPorCuentaDe'
								    						//,disabled: true
												        }
							
													]
											}
										]
								},
						        
						        {
						        	xtype:'fieldset',
						        	height: 145,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'displayfieldbase',
									bind: {
					        			disabled: '{!esOfertaVenta}'
			            			},
									title: HreRem.i18n("fieldlabel.cargas.Pendientes"),
									items :
										[								
											 {	
											 	xtype:'datefieldbase',
											 	fieldLabel:  HreRem.i18n('fieldlabel.fecha.ultima.actualizacion'),
					        					bind: '{condiciones.fechaUltimaActualizacion}',
					        					readOnly: true
									        },
									        {
									        					        						        	
									        },
											{ 
												xtype: 'displayfieldbase',
												reference: 'cargasPendientesImpuestos',
										 		symbol: HreRem.i18n('symbol.euro'),
												fieldLabel: HreRem.i18n('fieldlabel.impuestos'),
				                				bind: '{condiciones.impuestos}'
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.impuestosPorCuentaDe}'
								            		//,disabled: '{!esImpuestoMayorQueCero}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'impuestosPorCuentaDe',
					    						allowBlank: '{!esImpuestoMayorQueCero}'
									        },
											
							                { 
												xtype: 'displayfieldbase',
												reference: 'cargasPendientesComunidades',
										 		symbol: HreRem.i18n('symbol.euro'),
												fieldLabel: HreRem.i18n('fieldlabel.comunidades'),
				                				bind: '{condiciones.comunidades}'
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.comunidadesPorCuentaDe}'
								            		//,disabled: '{!esComunidadesMayorQueCero}'
					    							
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						allowBlank: '{!esComunidadesMayorQueCero}',
					    						reference: 'comunidadesPorCuentaDe'
					    						
									        },
									        { 
												xtype: 'numberfieldbase',
												reference: 'cargasPendientesOtros',
										 		symbol: HreRem.i18n('symbol.euro'),
												fieldLabel: HreRem.i18n('fieldlabel.otros'),
				                				bind: '{condiciones.cargasOtros}',
				                				listeners: {
				                					change: 'onHaCambiadoCargasPendientesOtros'
				                				}
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.cargasPendientesOtrosPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'cargasPendientesOtrosPorCuentaDe'
					    						//,disabled: true
									        }
									        
									        
											
										]
						        	}
						        ]
					}
					
		        ]
			},{
		
	//##############################################################################################################			
	//##################################### PESTAÑA A DESARROLLAR ################################################## 			
	//##############################################################################################################			   
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.economicas'),
				bind: {
			    	hidden: '{esOfertaVenta}'
	            },
				items : [
					{
						xtype:'fieldsettable',
						collapsible: false,
						
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
					
								{
						        	xtype:'fieldset',
						        	height: 140,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.fianza"),
									items :
										[
											{ 
												xtype: 'numberfieldbase',
												reference: 'mesesDeposito',
										 		fieldLabel: HreRem.i18n('fieldlabel.meses'),
										 		bind: '{condiciones.mesesFianza}',
				                				readOnly: true
							                },
							                {
							                	xtype: 'checkboxfieldbase',
							                	reference: 'chekboxReservaConImpuesto',
							                	fieldLabel:  HreRem.i18n('fieldlabel.fianza.actualizable'),
							                	bind: {
							                		value: '{condiciones.fianzaActualizable}'										             
							                	},
							                	readOnly: true
		                					},
		                					{ 
												xtype: 'numberfieldbase',
												reference: 'importeDeposito',
										 		fieldLabel: HreRem.i18n('fieldlabel.importe'),
										 		symbol: HreRem.i18n('symbol.euro'),				
				                				bind: '{condiciones.importeFianza}',
				                				readOnly: true
				                				
							                }
				
										]
								},
						        
						        {
						        	xtype:'fieldset',
						        	height: 140,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.fiscales"),
									items :
										[
											 	{
										        	xtype: 'comboboxfieldbase',							        	
										        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.impuesto'),
										        	bind: {
									            		store: '{comboTiposImpuesto}',
									            		value: '{condiciones.tipoImpuestoCodigo}'
									            	},
						            				displayField: 'descripcion',
			    									valueField: 'codigo'
										        },	
										        {
													xtype: 'numberfieldbase',
													reference: 'tipoAplicable',
											 		symbol: HreRem.i18n("symbol.porcentaje"),
													fieldLabel: HreRem.i18n('fieldlabel.tipo.aplicable'),
					                				bind: {
					                					value: '{condiciones.tipoAplicable}'
					                				}
								                },
								                {
								                	xtype: 'checkboxfieldbase',
								                	reference: 'renunciaTanteoRetracto',
								                	fieldLabel:  HreRem.i18n('fieldlabel.renuncia.tanteo.retracto'),
								                	bind: {
						        						value: '{condiciones.renunciaTanteo}'
				            						},
				            						
			                					},
										        {
			                						xtype: 'numberfieldbase',
								                	reference: 'carencias',
								                	fieldLabel:  HreRem.i18n('fieldlabel.carencia'),
								                	bind: {
						        						value: '{condiciones.carencia}'
				            						},
			                					},
			                					{		                
			                						xtype: 'numberfieldbase',
								                	reference: 'bonificacion',
								                	fieldLabel:  HreRem.i18n('fieldlabel.bonificacion'),
								                	bind: {
						        						value: '{condiciones.bonificacion}'							             
				            						},
				            						
			                					},
										        {
			                						xtype: 'numberfieldbase',
								                	reference: 'gastosRepercutibles',
								                	fieldLabel:  HreRem.i18n('fieldlabel.gastos.repercutibles'),
								                	bind: {
								                		value: '{condiciones.gastosRepercutibles}'
								                	}
			                					}
											]
						        	}
						        ]
					},
					{
						xtype:'fieldsettable',
						collapsible: false,
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
													
								{
									xtype:'fieldset',
									height: 140,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.deposito"),				
									items : [
										
											{	
							                	xtype: 'textfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.meses'),
							                	bind: {
													value: '{condiciones.mesesDeposito}'
												},
												readOnly: true
							                },
											{
							                	xtype: 'checkboxfieldbase',
							                	reference: 'chekboxReservaConImpuesto',
							                	fieldLabel:  HreRem.i18n('fieldlabel.deposito.actualizable'),
							                	bind: {
							                		value: '{condiciones.depositoActualizable}'										             
							                	},
							                	readOnly: true
		                					},
		                					{ 
												xtype: 'numberfieldbase',
												reference: 'importeDeposito',
										 		fieldLabel: HreRem.i18n('fieldlabel.importe'),
				                				bind: '{condiciones.importeDeposito}',
				                				symbol: HreRem.i18n('symbol.euro'),	
				                				readOnly: true
				                				
							                }
											
										]
								},
						        
						        {
						        	xtype:'fieldset',
						        	height: 140,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'displayfieldbase',
									title: HreRem.i18n("fieldlabel.fiador.solidario"),
									items :
										[								
											 
											{	
							                	xtype: 'textfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.avalista'),
							                	bind: {
													value: '{condiciones.avalista}'
												},
												readOnly: true
							                },
							                { 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.entidad.bancaria'),
									        	bind: {
								            		store: '{comboEntidadesAvalistas}',
								            		value: '{condiciones.codigoEntidad}'								      				    							
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'entidadBancariaFiador'
					    						
									        },
									        {	
							                	xtype: 'textfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.documento'),
							                	bind: {
													value: '{condiciones.documentoFiador}'
												},
												readOnly: true
							                },
											{ 
												xtype: 'numberfieldbase',
												reference: 'importeDeposito',
										 		fieldLabel: HreRem.i18n('fieldlabel.importe.aval'),
				                				bind: '{condiciones.importeAval}',
				                				symbol: HreRem.i18n('symbol.euro'),	
				                				readOnly: false
				                				
							                } 	
										]
						        	}
						        ]
					}
					
		        ]
			
			},
			
			{
				
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.escalado.rentas'),
				bind: {
						  hidden: '{esOfertaVenta}'
				      },
				items : [
					
					{
						
						

						xtype:'fieldsettable',
						collapsible: false,
						
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
					
								{
						        	xtype:'fieldset',
						        	height: 100,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 1
						        	},
									defaultType: 'textfieldbase',
									items :
										[
											{
						        	           	xtype: 'checkboxfieldbase',
							                	reference: 'checkboxEscaladoFijo',
							                	fieldLabel:  HreRem.i18n('fieldlabel.fijo'),
							                	bind: {
							                		value: '{condiciones.reservaConImpuesto4}'										             
							                	}
		                					},
		                					{	
											 	xtype:'datefieldbase',
											 	fieldLabel:  HreRem.i18n('fieldlabel.fecha'),
					        					bind: '{condiciones.fechaUltimaActualizacion5}',
					        					readOnly: true
									        },
									        {	
											 	xtype:'datefieldbase',
											 	fieldLabel:  HreRem.i18n('fieldlabel.incremento.renta'),
					        					bind: '{condiciones.fechaUltimaActualizacion2}',
					        					readOnly: true
									        }
				
										]
								},
						        
						        {
						        	xtype:'fieldset',
						        	height: 100,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 1
						        	},
									defaultType: 'textfieldbase',
									items :
										[
											
											{
						        	           	xtype: 'checkboxfieldbase',
							                	reference: 'chekboxPorcentual',
							                	fieldLabel:  HreRem.i18n('fieldlabel.porcentual'),
							                	bind: {
							                		value: '{condiciones.reservaConImpuesto3}',										   
							                	},
							                	listeners: {
					                					change: 'onCambioCheckPorcentual'
					                				}
		                					},
		                					
		                					{
						        	           	xtype: 'checkboxfieldbase',
							                	reference: 'checkboxIPC',
							                	fieldLabel:  HreRem.i18n('fieldlabel.ipc'),
							                	bind: {
							                		value: '{condiciones.reservaConImpuesto1}'										             
							                	}
		                					},
		                					{ 
												xtype: 'displayfieldbase',
												reference: 'escaladoRentaPorcentaje',
										 		symbol: HreRem.i18n('symbol.porcentaje'),
												fieldLabel: HreRem.i18n('fieldlabel.porcentaje'),
				                				bind: '{condiciones.impuestos}'
							                }
											
										]
						        	},
						        	{
							        	xtype:'fieldset',
							        	height: 100,
							        	margin: '0 10 10 0',
							        	layout: {
									        type: 'table',
							        		columns: 1
							        	},
										defaultType: 'textfieldbase',
										items :
											[
												{
							        	           	xtype: 'checkboxfieldbase',
								                	reference: 'chekboxRevisionMercado',
								                	fieldLabel:  HreRem.i18n('fieldlabel.revision.mercado'),
								                	bind: {
								                		value: '{}'										             
								                	},
								                	listeners: {
					                					change: 'onCambioCheckRevMercado'
					                				}
			                					},
			                					{	
												 	xtype:'datefieldbase',
												 	reference: 'revisionMercadoFecha',
												 	fieldLabel:  HreRem.i18n('fieldlabel.fecha'),
						        					bind: '{}',
						        					readOnly: true
										        },												        								                
								                { 
													xtype: 'displayfieldbase',
													reference: 'escaladoRentasMeses',
											 		symbol: HreRem.i18n('symbol.meses'),
											 		labelSeparator: "",
													fieldLabel: HreRem.i18n('fieldlabel.cada'),
					                				bind: ' meses'
								                }
										        
										        
													
											]					        		
						        		}	
						        	
						        	]
	
								}
								
								
					        ]
						
						}
			
			
// #############################################################################################################################	
// #############################################################################################################################	
			
			
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