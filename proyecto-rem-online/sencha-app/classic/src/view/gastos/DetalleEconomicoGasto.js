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
												height: 250,
				        						margin: '10 10 10 0',
				        						defaultType: 'numberfieldbase',
				        						defaults: {
				        							style: 'text-align: right',
											        fieldStyle:'text-align:right;',
											        labelStyle: 'text-align:left;',
											        symbol: HreRem.i18n("symbol.euro")
				        						},
												items :
													[
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.principal.sujeto'),
											                bind: '{detalleeconomico.importePrincipalSujeto}',
											                reference: 'importePrincipalSujeto',
											                allowBlank: false,
											                listeners: {
											                	change: 'onCambiaImportePrincipalSujeto'
											                }
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.principal.no.sujeto'),
															reference: 'importePrincipalNoSujeto',
											                bind: '{detalleeconomico.importePrincipalNoSujeto}',
											                allowBlank: false,
											                listeners: {
											                	change: 'onCambiaImportePrincipalNoSujeto'
											                }
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.recargo'),
											                bind: '{detalleeconomico.importeRecargo}'
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.interes.demora'),
											                bind: '{detalleeconomico.importeInteresDemora}'
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.costas'),
											                bind: '{detalleeconomico.importeCostas}'
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.otros.incrementos'),
											                bind: '{detalleeconomico.importeOtrosIncrementos}'
														},
														{ 
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
										                	bind: {
//								        						disabled:'{!esOfertaVenta}',
								        						value: '{detalleeconomico.impuestoIndirectoExento}'
						            						}
					                					},
					                					{		                
										                	xtype: 'checkboxfieldbase',
										                	fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.renuncia.exencion'),
										                	bind: {
//								        						disabled:'{!esOfertaVenta}',
								        						value: '{detalleeconomico.renunciaExencionImpuestoIndirecto}'
						            						}
					                					},
					                					{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.porcentaje"),
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.tipo.impositivo'),
											                bind: '{detalleeconomico.impuestoIndirectoTipoImpositivo}',
											                allowBlank: false
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.cuota'),
											                bind: '{calcularImpuestoIndirecto}',
											                readOnly: true,
											                listeners:{
											                	change: function(field, value) {
											                		field.next().setValue(value);
											                	}
											                }
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.cuota'),
											                bind: '{detalleeconomico.impuestoIndirectoCuota}',
											                hidden: true,
											                readOnly: true
														},
														{
															xtype: 'checkboxfieldbase',
															bind: '{detalleeconomico.optaCriterioCaja}',
															fieldLabel: HreRem.i18n('fieldlabel.proveedor.criterio.caja.iva'),								
															readOnly: true
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
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.tipo.impositivo.irpf'),
											                bind: '{detalleeconomico.irpfTipoImpositivo}',
											                allowBlank: false
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.retencion'),
															readOnly: true,
											                bind: '{calcularImpuestoDirecto}',
											                listeners:{
											                	change: function(field, value) {
											                		field.next().setValue(value);
											                	}
											                }
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.retencion'),
															readOnly: true,
															hidden: true,
											                bind: '{detalleeconomico.irpfCuota}'
														}
													
													]
											},
											{
												xtype: 'tbspacer',
												colspan: 2
											},											
											{   
												xtype:'fieldset',
												border: false,
				        						defaultType: 'numberfieldbase',
				        						defaults: {
				        							style: 'text-align: right',
											        fieldStyle:'text-align:right;',
											        labelStyle: 'text-align:left;',
											        symbol: HreRem.i18n("symbol.euro")
				        						},
												items :
													[
														
														{
															cls: 'txt-importe-total',
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.total'),
														    bind: '{calcularImporteTotalGasto}',
														    listeners: {
														    	change: function(field, value) {
														    		field.next().setValue(value);
														    	}
														    }
														},
														{
															cls: 'txt-importe-total',
															hidden: true,
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.total'),
														    bind: '{detalleeconomico.importeTotal}'
														}
													]
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
												reference: 'comboRepercutibleInquilino',
								        		bind: {
							            			store: '{comboSiNoRem}',
							            			value: '{detalleeconomico.repercutibleInquilino}'
							            		}
									        },
									        {   
												xtype:'fieldset',
												border: false,
				        						margin: '0 10 10 0',
												items: [
									        
													        { 
																xtype: 'numberfieldbase',
																reference: 'detalleEconomicoImportePagado',
																symbol: HreRem.i18n("symbol.euro"),
																margin: '10 0 10 0',
																cls: 'txt-importe-total',
																style: 'text-align: right',
															    fieldStyle:'text-align:right;',
															    labelStyle: 'text-align:left;',
																fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.pagado'),
																readOnly: true,
																hidden: true,
															    bind: '{detalleeconomico.importeTotal}'
															},
													        { 
																xtype: 'numberfieldbase',
																symbol: HreRem.i18n("symbol.euro"),
																reference: 'detalleEconomicoImportePagadoEmpty',
																margin: '10 0 10 0',
																cls: 'txt-importe-total',
																style: 'text-align: right',
															    fieldStyle:'text-align:right;',
															    labelStyle: 'text-align:left;',
																fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.pagado'),
																readOnly: true,
																hidden: true,
																value: 0
															}
												]
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
												xtype:'fieldset',
												border: false,
				        						margin: '0 10 10 0',
												items: [
															{
													        	xtype:'datefieldbase',
																formatter: 'date("d/m/Y")',
																reference: 'fechaPago',
														       	fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.fecha.pago'),
														       	bind: '{detalleeconomico.fechaPago}',
														       	listeners: {
														       		afterbind: 'onHaCambiadoFechaPago'
														       	},
														       	maxValue: null
														    }
												]
											},
											{
												xtype: 'tbspacer',
												colspan: 2
											},
											{   
												xtype:'fieldset',
												border: false,
				        						margin: '0 10 10 0',
												items: [
															{ 
																xtype: 'comboboxfieldbase',
															    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.responsable.pagado.por'),
																bind: {
																	store: '{comboPagadoPor}',
																    value: '{detalleeconomico.tipoPagadorCodigo}'
																}
															}
												]
											},
											{		                
											    xtype: 'checkboxfieldbase',
											    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.reembolsar.pago'),
											    labelWidth: 200,
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
											                		},
											                		
											                		{
															        	xtype:'datefieldbase',
																		formatter: 'date("d/m/Y")',
																       	fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.fecha.conexion'),
																       	bind: '{detalleeconomico.fechaConexion}',
																       	maxValue: null
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