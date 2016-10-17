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
						xtype:'fieldsettable',
						collapsible: false,
						bind: {
					    	hidden: '{!esOfertaVenta}',
					    	disabled: '{!esOfertaVenta}'
			            },
						defaultType: 'displayfieldbase',				
						title: HreRem.i18n('title.financiacion'),
						items : [
							{ 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.solicita.financiacion'),
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.solicitaFinanciacion}'
				            	},
					            displayField: 'descripcion',
		    					valueField: 'codigo',
		    					listeners: {
			                		change:  'onHaCambiadoSolicitaFinanciacion'
			            		}
					        },
					        {
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
								reference: 'fechaInicioFinanciacion',
					        	fieldLabel: HreRem.i18n('fieldlabel.inicio.expediente'),
					        	bind: '{condiciones.fechaInicioExpediente}',
					        	maxValue: null
					        },
					        {
					        	xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.inicio.financiacion'),
					        	bind: '{condiciones.fechaInicioFinanciacion}',
					        	maxValue: null,
					        	listeners: {
					        		change: 'onHaCambiadoFechaInicioFinanciacion'
					        	}
					        },
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.entidad.financiera'),
					        	bind: '{condiciones.entidadFinanciacion}',
					        	reference: 'entidadFinanciacion',
		    					disabled: true
					        },
					        { 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.estado.expediente'),
					        	bind: {
				            		store: '{comboEstadosFinanciacion}',
				            		value: '{condiciones.estadosFinanciacion}'
				            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
					        },
					        {
					        	xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
								reference: 'fechaFinFinanciacion',
					        	fieldLabel: HreRem.i18n('fieldlabel.fin.financiacion'),
					        	bind: '{condiciones.fechaFinFinanciacion}',
					        	maxValue: null,
					        	listeners: {
					        		change: 'onHaCambiadoFechaFinFinanciacion'
					        	}
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
								            		value: '{condiciones.tipoCalculo}',
								            		disabled: '{!esSolicitadaReserva}'
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
		    									valueField: 'codigo'
									        },	
									        { 
												xtype: 'numberfieldbase',
												reference: 'tipoAplicable',
										 		symbol: HreRem.i18n("symbol.porcentaje"),
												fieldLabel: HreRem.i18n('fieldlabel.tipo.aplicable'),
												reference: 'tipoAplicable',
				                				bind: '{condiciones.tipoAplicable}'
							                },
									        {		                
							                	xtype: 'checkboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.renuncia.exencion'),
							                	readOnly: false,
							                	disabled: true,
							                	bind: {
					        						disabled:'{!esOfertaVenta}',
					        						value: '{condiciones.renunciaExencion}'
			            						}
		                					},
									        
									        {		                
							                	xtype: 'checkboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.reserva.con.impuesto'),
							                	readOnly: false,
							                	disabled: true,
							                	bind:	{
							                		value: '{condiciones.reservaConImpuesto}',
							                		disabled:'{!esOfertaVenta}'
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
								            		store: '{comboPorCuenta}'
								            		,value: '{condiciones.plusvaliaPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'plusvaliaPorCuentaDe',
					    						disabled: true
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
								            		store: '{comboPorCuenta}',
								            		value: '{condiciones.notariaPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'notariaPorCuentaDe',
					    						disabled: true
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
								            		store: '{comboPorCuenta}',
								            		value: '{condiciones.gastosCompraventaOtrosPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'compraventaOtrosPorCuentaDe',
					    						disabled: true
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
											            		store: '{comboPorCuenta}'
											            		,value: '{condiciones.ibiPorCuentaDe}'
											            	},
											            	displayField: 'descripcion',
								    						valueField: 'codigo',
								    						reference: 'ibiPorCuentaDe',
								    						disabled: true
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
											            		store: '{comboPorCuenta}',
											            		value: '{condiciones.comunidadPorCuentaDe}'
											            	},
											            	displayField: 'descripcion',
								    						valueField: 'codigo',
								    						reference: 'comunidadPorCuentaDe',
								    						disabled: true
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
											            		store: '{comboPorCuenta}',
											            		value: '{condiciones.suministrosPorCuentaDe}'
											            	},
											            	displayField: 'descripcion',
								    						valueField: 'codigo',
								    						reference: 'suministrosPorCuentaDe',
								    						disabled: true
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
								            		store: '{comboPorCuenta}',
								            		value: '{condiciones.impuestosPorCuentaDe}',
								            		disabled: '{!esImpuestoMayorQueCero}'
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
								            		store: '{comboPorCuenta}',
								            		value: '{condiciones.comunidadesPorCuentaDe}',
								            		disabled: '{!esComunidadesMayorQueCero}'
					    							
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
								            		store: '{comboPorCuenta}',
								            		value: '{condiciones.cargasPendientesOtrosPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo',
					    						reference: 'cargasPendientesOtrosPorCuentaDe',
					    						disabled: true
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
				bind: {
					hidden: '{!esOfertaVenta}',
					disabled: '{!esOfertaVenta}'
			    },
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
							    readOnly: true,
							    bind:		'{condiciones.sujetoTramiteTanteo}'		                
		                	},
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.estado.tramite'),
			                	bind: {
					        		value: '{condiciones.estadoTramite}',
					        		disabled: '{!onEstaSujetoTanteo}'
			                	}
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
			            		}
					        },
					        { 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.procede.descalificacion'),
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.procedeDescalificacion}'
				            	},
				            	allowBlank: false,
				            	listeners: {
				            		change: 'onHaCambiadoProcedeDescalificacion'
				            	}
					        },
					        { 
								xtype: 'comboboxfieldbase',
							    fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
								bind: {
									store: '{comboPorCuenta}',
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
									store: '{comboPorCuenta}',
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