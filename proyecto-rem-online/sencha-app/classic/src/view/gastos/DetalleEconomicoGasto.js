Ext.define('HreRem.view.gastos.DetalleEconomicoGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'detalleeconomicogasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: false,
    reference: 'detalleeconomicogastoref',
    scrollable	: 'y',
	recordName: "detalleeconomico",
	recordClass: "HreRem.model.DetalleEconomicoGasto",
    refreshAfterSave: true,
    requires: ['HreRem.model.DetalleEconomicoGasto','HreRem.view.administracion.gastos.GastoRefacturadoGridExistentes',
    	'HreRem.model.AdjuntoGasto', 'HreRem.model.GastoRefacturableGridExistenteStore','HreRem.model.LineaDetalleGastoGridModel'],
    
    listeners: {
		boxready:'cargarTabData',
		
		activate: function(me, eOpts) {
			var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
			var autorizado = me.lookupController().getViewModel().get('gasto').get('autorizado');
	    	var rechazado = me.lookupController().getViewModel().get('gasto').get('rechazado');
	    	var agrupado = me.lookupController().getViewModel().get('gasto').get('esGastoAgrupado');
	    	var gestoria = me.lookupController().getViewModel().get('gasto').get('nombreGestoria')!=null;
			if(!$AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK']) && this.lookupController().botonesEdicionGasto(estadoGasto,autorizado,rechazado,agrupado, gestoria, this)){
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(true);
			}
			else{
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(false);
			}
		},
		beforeShow: function (e){
			//var me = this;
			//me.lookupController().visibilidadComponentesDetalleEconomico();
		}
	},
	
	editableSoloPago: function(){
		var me= this;
		var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
		if(CONST.ESTADOS_GASTO['AUTORIZADO']==estadoGasto || CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO']==estadoGasto || CONST.ESTADOS_GASTO['CONTABILIZADO']==estadoGasto){
			return true;
		}
		return false;
	},
	
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.gasto.detalle.economico'));
        var items= [
       
	    						{   
									xtype:'fieldsettable',
									title: HreRem.i18n('title.gasto.detalle.economico'),
									items :
										[
											{   
												xtype:'fieldsettable',
												defaultType: 'textfieldbase',
												colspan: 3,
				        						reference: 'impuestodirecto',
												title: HreRem.i18n('title.gasto.detalle.economico.impuesto.directo.retencion'),
												listeners:{												
													afterrender: function(){														
									         			if(!Ext.isEmpty(me.up('gastodetallemain').getViewModel().get('gasto').get('nombreGestoria')))
									         				this.setHidden(true);
									         			else
									         				this.setHidden(false);
													}
												},
												items :
													[
														{ 
															xtype: 'currencyfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															reference:'baseIRPFImpD',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.irpf.base'),
															readOnly: false,
											                bind: '{detalleeconomico.baseImpI}',
											                listeners: {
											                	edit: function(){
										        					if(this.getValue()==0)
										        						this.setValue('');
										        				},
																update: function(){
																	if(Ext.isEmpty(this.getValue()))
																		this.setValue(0);
																},
														    	change: 'onChangeCuotaImpuestoDirecto'													    		
														    	
														    }
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.porcentaje"),
											        		reference: 'tipoImpositivoIRPFImpD',     	
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.tipo.impositivo.irpf'),
															readOnly: me.editableSoloPago(),
											                bind: '{detalleeconomico.irpfTipoImpositivo}',
											                listeners:{
										        				edit: function(){
										        					if(this.getValue()==0)
										        						this.setValue('');
										        				},
																update: function(){
																	if(Ext.isEmpty(this.getValue()))
																		this.setValue(0);
																},
														    	change: 'onChangeCuotaImpuestoDirecto'													    		
										        			}
														},
														{ 
															xtype: 'currencyfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															reference:'cuotaIRPFImpD',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.irpf.cuota'),
											                bind: '{detalleeconomico.irpfCuota}',
											                readOnly: true
														},
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.irpf.clave'),
											                bind: {
											                	value:'{detalleeconomico.clave}',
											                	hidden:'{!esLiberbank}'
											                }
														},
														{ 
															xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.irpf.subclave'),
															 bind: {
											                	value:'{detalleeconomico.subclave}',
											                	hidden:'{!esLiberbank}'
											                }
														}
													
													]
											},
											
											{   
												xtype:'fieldsettable',
												defaultType: 'textfieldbase',
												colspan: 3,
				        						reference: 'retencionGarantia',
												title: HreRem.i18n('title.gasto.detalle.economico.retencion.garantia'),
												listeners:{												
													afterrender: function(){
									         			if(!Ext.isEmpty(me.up('gastodetallemain').getViewModel().get('gasto'))&&
									         			  CONST.CARTERA['BANKIA'] == me.up('gastodetallemain').getViewModel().get('gasto').get('cartera')){
									         				this.setHidden(true);
									         			}else{
									         				this.setHidden(false);
									         			}
													}
												},
												items :
													[	
														{		
															//
														    xtype: 'checkboxfieldbase',
														    reference: 'retencionGarantiaAplica',
														    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.retencion.garantia.aplica'),
														    bind: {
													        	value: '{detalleeconomico.retencionGarantiaAplica}'
													        },
												       		listeners: {
												       			change: 'onChangeRetencionGarantiaAplica'
												       		}
										           		},
										           		{		
										           			xtype:'comboboxfieldbase',
															fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.tipo.retencion'),
															reference: 'comboTipoRetencionRef',
											        		bind: {
										            			store: '{comboTipoRetencion}',
										            			value: '{detalleeconomico.tipoRetencionCodigo}',
										            			allowBlank: '{!detalleeconomico.retencionGarantiaAplica}',
										            			disabled:'{!detalleeconomico.retencionGarantiaAplica}'

															}, 
															allowBlank: true,
															listeners:{
																select: 'onChangeCuotaRetencionGarantia'	
															}
										           		},
														{ 
															xtype: 'currencyfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															reference:'baseIRPFRetG',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.retencion.base'),
											                bind: {
											                	   value: '{detalleeconomico.baseRetG}',
											                	   disabled: '{!detalleeconomico.retencionGarantiaAplica}'
											                },
											                listeners: {
										                		edit: function(){
										        					if(this.getValue()==0)
										        						this.setValue('');
										        				},
																update: function(){
																	if(Ext.isEmpty(this.getValue()))
																		this.setValue(0);
																},
															    change: 'onChangeCuotaRetencionGarantia'	
														    }	
														},
														{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.porcentaje"),
											        		reference: 'irpfTipoImpositivoRetG',     	
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.tipo.impositivo'),
											                bind: {
											                	value :'{detalleeconomico.irpfTipoImpositivoRetG}',
											                	disabled: '{!detalleeconomico.retencionGarantiaAplica}'
											                },
										                	listeners: {
										                		edit: function(){
										        					if(this.getValue()==0)
										        						this.setValue('');
										        				},
																update: function(){
																	if(Ext.isEmpty(this.getValue()))
																		this.setValue(0);
																},
																change: 'onChangeCuotaRetencionGarantia'	
														    														    		
														    	
														    }
											            
														},
														{ 
															xtype: 'currencyfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															reference:'cuotaIRPFRetG',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.cuota'),
											                bind: {value:'{detalleeconomico.irpfCuotaRetG}',
											                	   disabled: '{!detalleeconomico.retencionGarantiaAplica}'},
											                readOnly: true
														}
													]
											},
											{
												xtype:'fieldsettable',
												defaultType: 'textfieldbase',
												colspan: 3,
				        						reference: 'pagoUrgente',
												title: HreRem.i18n('title.gasto.detalle.economico.pago.urgente'),
												listeners: {
													afterrender: 'onVisualizaPagoUrgente'
												},
												items :
													[
														{
														    xtype: 'checkboxfieldbase',
														    reference: 'pagoUrgenteCheck',
														    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.pago.urgente'),
														    bind: {
													        	value: '{detalleeconomico.pagoUrgente}'
													        }
										           		}
													]
											},
									/*		{
												xtype: 'tbspacer',
												colspan: 2
											},	*/										
											{   
												xtype:'fieldsettable',
												border: false,
												colspan: 3,
												collapsible: false,
				        						defaultType: 'currencyfieldbase',
				        						defaults: {
											        labelStyle: 'text-align:left;',
											        symbol: HreRem.i18n("symbol.euro")
				        						},
												items :
													[
														
														{
															xtype: 'currencyfieldbase',
															cls: 'txt-importe-total',
															reference: 'importeTotalGastoDetalle',
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.total'),
														    bind: '{detalleeconomico.importeTotal}'
														   
														},
														{
															xtype: 'currencyfieldbase',
															reference: 'detalleEconomicoImporteTotal',
															cls: 'txt-importe-total',
															hidden: true,
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.total'),
														    bind: '{detalleeconomico.importeTotal}'
														},
														{
															xtype: 'currencyfieldbase',
															reference: 'detalleEconomicoImporteBruto',
															cls: 'txt-importe-total',
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.bruto'),
															bind: {
											                	value:'{detalleeconomico.importeBrutoLbk}',
											                	hidden:'{!esLiberbank}'
											                }
														}
													]
											}											
										]
										
					           },
					           {   
									xtype:'fieldsettable',
									title: HreRem.i18n('title.gasto.detalle.economico.lineas.detalle'),
									items :{
										xtype: 'lineaDetalleGastoGrid',
										reference: 'lineaDetalleGastoGrid'
									}
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
										       		change: 'onChangeFechaTopePago'
										       	}
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
				        						defaultType: 'numberfieldbase',
				        						defaults: {
				        							style: 'text-align: right',
											        fieldStyle:'text-align:right;',
											        labelStyle: 'text-align:left;',
											        symbol: HreRem.i18n("symbol.euro")
				        						},
												items: [
									        
													        { 
																xtype: 'currencyfieldbase',
																reference: 'detalleEconomicoImportePagado',													
																cls: 'txt-importe-total',															
																fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.pagado'),
																readOnly: true,
															    bind: '{detalleeconomico.importePagado}'
															}
												]
									        },
											{ 
												
												xtype: 'comboboxfieldbase',
											    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.responsable.pago.fuera.plazo'),
											    reference: 'destinatariosPago',
												bind: {
													store: '{comboDestinatarioPago}',
												    value: '{detalleeconomico.destinatariosPagoCodigo}',
												    allowBlank: '{!importeRecargoVacio}'

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
														       		afterbind: 'onChangeFechaPago'
														       	}														       	
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
																    value: '{detalleeconomico.tipoPagadorCodigo}',
																    disabled: '{!detalleeconomico.fechaPago}'
																}
															}
												]
											},
											
											{
					                			xtype: 'fieldset',	
					                			title: HreRem.i18n("title.supuestos.especiales"),	
					                			padding: 10,
					                			collapsible: false,
												colspan: 3,
											    layout: {
											        type: 'table',
											        columns: 2,
											        trAttrs: {width: '100%'},
											        tdAttrs: {width: '50%'},
											        tableAttrs: {
											            style: {
											                width: '100%'
															}
											        }
												},
												defaults: {
													margin: '0 10 10 0',																
													height: 150
												},
												items: [
												
															{   
																xtype:'fieldset',
																reference: 'fieldGestoria',
																items : [
																			{		                
																			    xtype: 'checkboxfieldbase',
																			    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.incluir.pago.provision'),
																			    bind: {
																		        	value: '{detalleeconomico.incluirPagoProvision}'
																	       		},
																	       		listeners: {
																	       			change: 'onChangePagadoProvision'
																	       		},
																	       		reference: 'incluirPagoProvisionRef'
															           		}
															    ]
															},
															{   
																xtype:'fieldset',
																reference: 'fieldAbonar',															
																items :	[
																			{		                
																			    xtype: 'checkboxfieldbase',
																			    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.abonar.cuenta'),
																			    name: 'abonoCuenta',
																			    bind: {
																		        	value: '{detalleeconomico.abonoCuenta}'
															            		},
															            		listeners: {
															            			change: 'onChangeAbonoCuenta'
															            		},
															            		reference: 'abonoCuentaRef',
															            		colspan: 3
													                		},
															                {				                	
																				xtype      : 'fieldcontainer',
																				fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.iban'),
																				labelWidth: 150,
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
																								name: 'iban1',
																								maxLength: 4,
																								minLengthText: 'Debe tener 4 digitos',
																								bind: {
																						        	value: '{detalleeconomico.iban1}',
																						        	allowBlank: '{!seleccionadoAbonar}'
																			            		},
																			            		listeners: {
																			            			change: 'onChangeIban'
																			            		}
																							},
																							{
																								xtype: 'textfieldbase',
																								reference: 'iban2',
																								name: 'iban2',
																								maxLength: 4,
																								bind: {
																						        	value: '{detalleeconomico.iban2}',
																						        	allowBlank: '{!seleccionadoAbonar}'
																			            		},
																			            		listeners: {
																			            			change: 'onChangeIban'
																			            		}
																							},
																							{
																								xtype: 'textfieldbase',
																								reference: 'iban3',
																								name: 'iban3',
																								maxLength: 4,
																								bind: {
																						        	value: '{detalleeconomico.iban3}',
																						        	allowBlank: '{!seleccionadoAbonar}'
																			            		},
																			            		listeners: {
																			            			change: 'onChangeIban'
																			            		}
																			           
																							},
																							{
																								xtype: 'textfieldbase',
																								reference: 'iban4',
																								name: 'iban4',
																								maxLength: 4,
																								bind: {
																						        	value: '{detalleeconomico.iban4}',
																						        	allowBlank: '{!seleccionadoAbonar}'
																			            		}
																							},
																							{
																								xtype: 'textfieldbase',
																								reference: 'iban5',
																								name: 'iban5',
																								maxLength: 4,
																								bind: {
																						        	value: '{detalleeconomico.iban5}',
																						        	allowBlank: '{!seleccionadoAbonar}'
																			            		},
																			            		listeners: {
																			            			change: 'onChangeIban'
																			            		}
																							},
																							{
																								xtype: 'textfieldbase',
																								reference: 'iban6',
																								name: 'iban6',
																								maxLength: 4,
																								bind: {
																						        	value: '{detalleeconomico.iban6}',
																						        	allowBlank: '{!seleccionadoAbonar}'
																			            		},
																			            		listeners: {
																			            			change: 'onChangeIban'
																			            		}
																							}
																					]
																			},
																			{		        
																				xtype: 'textfieldbase',
																				fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.titular.cuenta'),
																				name: 'titularCuenta',
																				bind: {
																				  	value: '{detalleeconomico.titularCuenta}',
																				  	disabled: '{!seleccionadoAbonar}',
																				  	allowBlank: '{!seleccionadoAbonar}'
																	            },
																	            reference: 'titularCuentaRef',
																	            colspan: 3
															                },
															                {		                
																			    xtype: 'textfieldbase',
																			    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.nif.titular.cuenta'),
																				maxLength: 10,
																				name: 'nifTitularCuenta',
																			    bind: {
																			       	value: '{detalleeconomico.nifTitularCuenta}',
																			       	disabled: '{!seleccionadoAbonar}',
																			       	allowBlank: '{!seleccionadoAbonar}'
																			       	
																	        	},
																	        	reference: 'nifTitularCuentaRef',
																	        	colspan: 3
															                }
																]
															},
															{   
																xtype:'fieldset',
																reference: 'fieldBankia',														
																items :
																		[
																			{		                
																					    xtype: 'checkboxfieldbase',
																					    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.pagado.bankia'),
																					    bind: {
																				        	value: '{detalleeconomico.pagadoConexionBankia}',
																				        	readOnly: '{!esCarteraBakia}'
																	            		},
																	            		listeners: {
																	            			change: 'onChangePagadoBankia'
																	            			
																	            		},
																	            		reference: 'pagadoConexionBankiaRef',
																	            		colspan: 3
															           		},
															           		{ 
																						xtype: 'textfieldbase',
																					    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.oficina'),
																						bind: {
																						    value: '{detalleeconomico.oficina}',
																						    disabled: '{!seleccionadoPagadoBankia}',
																						    allowBlank: '{!seleccionadoPagadoBankia}'
																						},
																						reference: 'oficinaRef'
																						
																			},
															           		{		                
																					    xtype: 'numberfieldbase',
																					    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.numero.conexion'),
																					    bind: {
																				        	value: '{detalleeconomico.numeroConexion}',
																				        	disabled: '{!seleccionadoPagadoBankia}',
																				        	allowBlank: '{!seleccionadoPagadoBankia}'
																	            		},
																	            		reference: 'numeroConexionRef'
															          		},
															          		{
																			        	xtype:'datefieldbase',
																						formatter: 'date("d/m/Y")',
																				       	fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.fecha.conexion'),
																				       	bind: {
																				       		value: '{detalleeconomico.fechaConexion}',
																				       		disabled: '{!seleccionadoPagadoBankia}',
																				       		allowBlank: '{!seleccionadoPagadoBankia}'
																				       	},
																				       	reference: 'fechaConexionRef',
																				       	maxValue: null
																			}
															    ]
															},
															{   
																xtype:'fieldset',
																reference: 'fieldAnticipo',														
																items :
																		[
																			{		                
																					    xtype: 'checkboxfieldbase',
																					    fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.anticipo'),
																					    bind: {
																				        	value: '{detalleeconomico.anticipo}',
																				        	readOnly: '{!esCarteraSareb}'
																	            		},
																	            		listeners: {
																	            			change: 'onChangeAnticipo'
																	            			
																	            		},
																	            		reference: 'anticipoRef'
															           		},
															          		{
																			        	xtype:'datefieldbase',
																			        	
																						formatter: 'date("d/m/Y")',
																				       	fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.fecha.anticipo'),
																				       	bind: {
																				       		value: '{detalleeconomico.fechaAnticipo}',
																				       		disabled: '{!seleccionadoAnticipo}',
																				       		allowBlank: '{!seleccionadoAnticipo}'
																				       	},
																				       	reference: 'fechaAnticipoRef',
																				       	maxValue: null
																			}
															    ]
															}

																
												] 
											}				

									]
								},
								{   
									xtype:'fieldsettable',
									title: HreRem.i18n('fieldlabel.gasto.refacturable'),
									items :
										[
											{
							                	xtype:'checkboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.refacturable'),
												reference: 'checkboxActivoRefacturable',
												colspan:4,
												name: 'gastoRefacturableB', 
												bind:{
													value:'{detalleeconomico.gastoRefacturableB}',
													readOnly: '{deshabilitarCheckGastoRefacturable}'
												},
												listeners:{						                
							        				change: function(){
							        					var me = this;
							        					if (me.getValue == true) {
							        						me.up('gastodetallemain').lookupReference('gastoRefacturadoGridExistente').setDisabled(true);
							        					} else {
							        						me.up('gastodetallemain').lookupReference('gastoRefacturadoGridExistente').setDisabled(false);
							        					}
							        				}
								                }
											},
											 {				
												xtype: 'gastoRefacturadoGridExistentes', 
												width: '500px',
												name: 'gastoRefac',
												colspan: 3,
												rowspan: 9,
												reference: 'gastoRefacturadoGridExistente',
												bind: {
													disabled: '{detalleeconomico.gastoRefacturableB}'
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
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
		//me.lookupController().refrescarGasto(true);    	
    }
});