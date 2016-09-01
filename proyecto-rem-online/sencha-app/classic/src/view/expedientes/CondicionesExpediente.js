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
						defaultType: 'displayfieldbase',				
						title: HreRem.i18n('title.financiacion'),
						items : [
							{ 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.solicita.financiacion'),
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.comboSolicitaFinanciacion}'
				            	},
					            displayField: 'descripcion',
		    					valueField: 'codigo',
		    					allowBlank: false
					        },
					        {
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.inicio.expediente'),
					        	bind: '{condiciones.inicioExpediente}'					        						        	
					        },
					        {
					        	xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.inicio.financiacion'),
					        	bind: '{condiciones.inicioFinanciacion}'				        						        	
					        },
					        { 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.entidad.financiera'),
					        	bind: {
				            		store: '{comboEntidadesFinancieras}',
				            		value: '{condiciones.comboEntidadFinancieraCodigo}'
				            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
					        },
					        { 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.estado.expediente'),
					        	bind: {
				            		store: '{comboEstadosFinanciacion}',
				            		value: '{condiciones.comboEstadosFinanciacion}'
				            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
					        },
					        {
					        	xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.fin.financiacion'),
					        	bind: '{condiciones.FinFinanciacion}'				        						        	
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
						        	height: 90,
						        	margin: '0 10 10 0',
						        	layout: {
								        type: 'table',
						        		columns: 2
						        	},
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.reserva"),
									items :
										[
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.calculo.reserva'),
									        	bind: {
								            		store: '{comboTipoCalculo}',
								            		value: '{condiciones.comboTipoCalculoCodigo}'
								            	},
					            				displayField: 'descripcion',
		    									valueField: 'codigo',
		    									allowBlank: false
									        },
											{ 
												xtype: 'numberfieldbase',
												reference: 'porcentajeReserva',
										 		symbol: HreRem.i18n("symbol.porcentaje"),
												fieldLabel: HreRem.i18n('fieldlabel.portencaje.reserva'),
				                				bind: '{condiciones.porcentajeReserva}'
							                },
							                { 
							                	xtype: 'numberfieldbase',
							                	reference: 'plazoParaFirmar',
										 		symbol: HreRem.i18n("symbol.dias"),
							                	fieldLabel: HreRem.i18n('fieldlabel.plazo.firmar'),
							                	bind: '{condiciones.plazoFirmar}'
							                },
							                { 
							                	xtype: 'numberfieldbase',
										 		symbol: HreRem.i18n("symbol.euro"),
										 		fieldLabel: HreRem.i18n('fieldlabel.importe.reserva'),
										 		bind: '{condiciones.importeReserva}'
											}
				
										]
								},
						        
						        {
						        	xtype:'fieldset',
						        	height: 90,
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
								            		value: '{condiciones.comboTipoImpuesto}'
								            	},
					            				displayField: 'descripcion',
		    									valueField: 'codigo',
		    									allowBlank: false
									        },	
									        { 
												xtype: 'numberfieldbase',
												reference: 'tipoAplicable',
										 		symbol: HreRem.i18n("symbol.porcentaje"),
												fieldLabel: HreRem.i18n('fieldlabel.tipo.aplicable'),
				                				bind: '{condiciones.tipoAplicable}'
							                },
									        {		                
							                	xtype: 'checkboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.renuncia.exencion'),
							                	readOnly: false,
							                	bind:		'{condiciones.renunciaExencion}'		                
		                					},
									        
									        {		                
							                	xtype: 'checkboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.reserva.con.impuesto'),
							                	readOnly: false,
							                	bind:		'{reserva.conImpuesto}'		                
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
				                				bind: '{condiciones.Plusvalia}'
							                },
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}'
								            		,value: '{condiciones.comboPlusvaliaPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
									        },
											
							                { 
												xtype: 'numberfieldbase',
												reference: 'gastosCompraventaNotaria',
										 		symbol: HreRem.i18n("symbol.euro"),
												fieldLabel: HreRem.i18n('fieldlabel.notaria'),
				                				bind: '{condiciones.notaria}'
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.comboNotariaPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
									        },
									        { 
												xtype: 'numberfieldbase',
												reference: 'gastosCompraventaOtros',
										 		symbol: HreRem.i18n("symbol.euro"),
												fieldLabel: HreRem.i18n('fieldlabel.otros'),
				                				bind: '{condiciones.gastosCompraventaOtros}'
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.comboOtrosPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
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
									defaultType: 'textfieldbase',
									title: HreRem.i18n("fieldlabel.cargas.Pendientes"),
									items :
										[								
											 {
									        	xtype:'datefieldbase',
												formatter: 'date("d/m/Y")',
									        	fieldLabel: HreRem.i18n('fieldlabel.fecha.ultima.actualizacion'),
									        	bind: '{condiciones.fechaUltimaActualizacion}',
									        	readOnly: true
									        },
									        {
									        					        						        	
									        },
											{ 
												xtype: 'numberfieldbase',
												reference: 'cargasPendientesImpuestos',
										 		symbol: HreRem.i18n('symbol.euro'),
												fieldLabel: HreRem.i18n('fieldlabel.impuestos'),
				                				bind: '{condiciones.impuestos}',
				                				readOnly: true
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.impuestosPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
									        },
											
							                { 
												xtype: 'numberfieldbase',
												reference: 'cargasPendientesComunidades',
										 		symbol: HreRem.i18n('symbol.euro'),
												fieldLabel: HreRem.i18n('fieldlabel.comunidades'),
				                				bind: '{condiciones.comunidades}',
				                				readOnly: true
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.comunidadesPorCuentaDe}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
									        },
									        { 
												xtype: 'numberfieldbase',
												reference: 'cargasPendientesOtros',
										 		symbol: HreRem.i18n('symbol.euro'),
												fieldLabel: HreRem.i18n('fieldlabel.otros'),
				                				bind: '{condiciones.cargasPendientesOtros}'
							                },	
											{ 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
									        	bind: {
								            		store: '{comboTiposPorCuenta}',
								            		value: '{condiciones.cargasPendientesOtrosPorCuentaDe}'
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
				xtype:'fieldset',
				collapsible: true,
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.juridicas'),
				items : [
				
					{   
						xtype:'fieldsettable',
						collapsible: false,
						defaultType: 'displayfieldbase',				
						title: HreRem.i18n('title.situacion.activo'),
						items : [
							{
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
								readOnly: true,
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
								
			                	fieldLabel:  HreRem.i18n('fieldlabel.estado.tramite'),
					        	bind: '{condiciones.estadoTramite}'
					        },
					        { 
								
			                	fieldLabel:  HreRem.i18n('fieldlabel.ocupado'),
					        	bind: '{condiciones.ocupado}'
					        },
					        { 
								
			                	fieldLabel:  HreRem.i18n('fieldlabel.con.titulo'),
					        	bind: '{condiciones.conTitulo}'
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
					            		value: '{condiciones.comboSituacionTitulo}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
						        },						        
								{ 
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.con.posesion.inicial'),
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{condiciones.comboConPosesionInicial}'			            		
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
					            		value: '{condiciones.comboSituacionPosesoria}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo'
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
					            		value: '{condiciones.comboEviccion}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
		    						allowBlank: false
						        },
						        { 
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.vicios.ocultos'),
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{condiciones.comboViciosOcultos}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
		    						allowBlank: false
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
				title: HreRem.i18n('title.condicionantes.administrativos'),
				items : [
				
							{ 
								
			                	fieldLabel:  HreRem.i18n('fieldlabel.vpo'),
					        	bind: '{condiciones.vpo}',
					        	readOnly: true
					        },
					        { 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.procede.descalificacion'),
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.comboProcedeDescalificacion}'
				            	},
				            	allowBlank: false
					        },
					        { 
								xtype: 'comboboxfieldbase',
							    fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
								bind: {
									store: '{comboTiposPorCuenta}',
								    value: '{condiciones.ProcedeDescalificacionTiposPorCuentaDe}'
								}
					        },	
					        { 
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.licencia'),
					        	bind: {
//				            		store: '{}',
//				            		value: '{}'
				            	}
					        },
					        
					        {
					        					        						        	
					        },
					        { 
								xtype: 'comboboxfieldbase',
							    fieldLabel:  HreRem.i18n('fieldlabel.por.cuenta.de'),
								bind: {
									store: '{comboTiposPorCuenta}',
								    value: '{condiciones.LicenciaTiposPorCuentaDe}'
								}
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