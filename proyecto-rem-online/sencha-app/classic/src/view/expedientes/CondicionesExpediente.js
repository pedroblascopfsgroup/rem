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
								            		value: '{condiciones.solicitaReserva}',
								            		readOnly: '{esCarteraZeus}'
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
								            		value: '{condiciones.tipoCalculo}',
								            		readOnly: '{esCarteraZeus}'
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
				                					value: '{condiciones.porcentajeReserva}',
				                					readOnly: '{esCarteraZeus}'
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
							                	reference: 'chkboxOperacionExenta',
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
			},
			{   
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',
				/*bind: {
					hidden: '{!esOfertaVenta}',
					disabled: '{!esOfertaVenta}'
			    },*/
				hidden: 'true',
				title: HreRem.i18n('title.juridicas'),
				items : [
				
					{   
						xtype:'fieldsettable',
						collapsible: false,
						defaultType: 'displayfieldbase',				
						title: HreRem.i18n('title.situacion.activo'),
						items : [
							{
				        		xtype:'displayfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.fecha.toma.posesion'),
					        	bind: '{condiciones.fechaTomaPosesion}'
					        },
					        {
							    xtype: 'checkboxfieldbase',
							    fieldLabel:  HreRem.i18n('fieldlabel.sujeto.tramite.tanteo'),
							    readOnly:true, 
							    hidden: true,
							    bind: '{condiciones.sujetoTramiteTanteo}',
							    colspan: 2
		                	},
					        { 
								xtype:'comboboxfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.ocupado'),
								readOnly:true,
								reference: 'comboOcupado',
				        		bind: {
			            			store: '{comboSiNoRem}',
			            			value: '{condiciones.ocupado}'
			            		}
					        },
					        { 
								xtype:'comboboxfieldbase',
								readOnly:true,
								reference: 'comboConTitulo',
			                	fieldLabel:  HreRem.i18n('fieldlabel.con.titulo'),
					        	bind: {
			            			store: '{comboSiNoRem}',
			            			value: '{condiciones.conTitulo}'
			            		}
					        },
					        { 
								
			                	fieldLabel:  HreRem.i18n('fieldlabel.tipo.titulo'),
					        	bind: '{condiciones.tipoTitulo}'
					        }
					        
					        
					        
				        ]
					},
					{
						xtype:'fieldset',
				collapsible: false,
				width: '100%',
				layout: {
			        type: 'hbox',
			       	align: 'stretch'
			    },
				title:HreRem.i18n('title.requerimientos.comprador'),
				items :
					[	{
							xtype: 'container',
							layout: {type: 'vbox'},
							defaultType: 'textfieldbase',
							width: '50%',
							items: [
								{ 
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.situacion,titulo'),
						        	bind: {
					            		store: '{comboSituacionTitulo}',
					            		value: '{condiciones.estadoTituloCodigo}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
						        },						        
								{ 
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.con.posesion.inicial'),
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{condiciones.posesionInicial}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
						        },
				                { 
						        	xtype: 'comboboxfieldbase',
//						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria'),
						        	bind: {
					            		store: '{comboSituacionPosesoria}',
					            		value: '{condiciones.situacionPosesoriaCodigo}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
		    						editable: true
						        }
	            			]
		                
						},
		                
				        
				        
				        
		                { 
			        	    xtype:'fieldset',
			        	    margin: '0 15 10 5',	
			        	    width: '50%',
							defaultType: 'textfieldbase',
							title: HreRem.i18n('title.renuncia.saneamiento'),
							items :
							[
					 			 { 
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.eviccion'),
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{condiciones.renunciaSaneamientoEviccion}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
						        },
						        { 
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.vicios.ocultos'),
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{condiciones.renunciaSaneamientoVicios}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
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
								readOnly:true,
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
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);		
    }
});