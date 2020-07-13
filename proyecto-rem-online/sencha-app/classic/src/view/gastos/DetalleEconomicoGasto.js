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
    requires: ['HreRem.model.DetalleEconomicoGasto','HreRem.view.administracion.gastos.GastoRefacturadoGridExistentes','HreRem.model.AdjuntoGasto', 'HreRem.model.GastoRefacturableGridExistenteStore'],
    
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
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.porcentaje"),
											        		reference: 'tipoImpositivoIRPF',     	
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
																}
										        			}
														},
														{ 
															xtype: 'currencyfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
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
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.retencion'),
															readOnly: true,
															hidden: true,
											                bind: '{detalleeconomico.irpfCuota}'
														}
													
													]
											},
									/*		{
												xtype: 'tbspacer',
												colspan: 2
											},	*/										
											{   
												xtype:'fieldset',
												border: false,
												colspan: 3,
				        						defaultType: 'currencyfieldbase',
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
															reference: 'importeTotal',
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.importe.total'),
														    bind: '{calcularImporteTotalGasto}',
														    listeners: {
														    	change: 'onChangeImporteTotal'													    		
														    	
														    }
														},
														{
															reference: 'detalleEconomicoImporteTotal',
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
																								maxLength: 4,
																								bind: {
																						        	value: '{detalleeconomico.iban4}',
																						        	allowBlank: '{!seleccionadoAbonar}'
																			            		}
																							},
																							{
																								xtype: 'textfieldbase',
																								reference: 'iban5',
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