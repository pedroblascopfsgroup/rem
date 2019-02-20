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
    
    requires: ['HreRem.model.DetalleEconomicoGasto'],
    
    listeners: {
		boxready:'cargarTabData',
		
		activate: function(me, eOpts) {
			var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
			var autorizado = me.lookupController().getViewModel().get('gasto').get('autorizado');
	    	var rechazado = me.lookupController().getViewModel().get('gasto').get('rechazado');
	    	var agrupado = me.lookupController().getViewModel().get('gasto').get('esGastoAgrupado');
	    	var gestoria = me.lookupController().getViewModel().get('gasto').get('nombreGestoria')!=null;
			if(this.lookupController().botonesEdicionGasto(estadoGasto,autorizado,rechazado,agrupado, gestoria, this)){
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(true);
			}
			else{
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').setVisible(false);
			}
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
												xtype:'fieldset',
												border: false,
												height: 250,
				        						margin: '10 0 10 0',
				        						defaultType: 'currencyfieldbase',
				        						defaults: {
				        							style: 'text-align: right',
											        fieldStyle:'text-align:right;',
											        labelStyle: 'text-align:left;',
											        symbol: HreRem.i18n("symbol.euro"),
											        listeners:{
								        				edit: function(){
								        					Ext.global.console.log(me.up('gastodetallemain').getViewModel().get('gasto').get('asignadoATrabajos'));
								        					if(!me.up('gastodetallemain').getViewModel().get('gasto').get('asignadoATrabajos'))
									        					if(this.getValue()==0)
									        						this.setValue('');
								        					if(me.up('gastodetallemain').getViewModel().get('gasto').get('asignadoATrabajos') || me.editableSoloPago())
								        						this.setReadOnly(true);
								        					else
								        						this.setReadOnly(false);
								        				},
								        				
														update: function(){
															if(Ext.isEmpty(this.getValue()))
																this.setValue(0);
														},																		        						
						        						afterrender: function(){							        					
								        					if(me.up('gastodetallemain').getViewModel().get('gasto').get('asignadoATrabajos'))
								        						this.setReadOnly(true);
								        					else
								        						this.setReadOnly(false);
								        				}
								        			}
				        						},
				        						listeners:{
				        							edit: function(){
							        					if(this.getValue()==0)
							        						this.setValue('');								        					
							        				},							        				
													update: function(){
														if(Ext.isEmpty(this.getValue()))
															this.setValue(0);
													}
				        						},
												items :
													[
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.principal.sujeto'),
											                bind: '{detalleeconomico.importePrincipalSujeto}',
											                reference: 'importePrincipalSujeto',
											                allowBlank: false,
											                readOnly: me.editableSoloPago(),
											                listeners:{
											                	edit: function(){
											                		if(this.getValue()==0)
											                			this.setValue('');
											                		if(me.up('gastodetallemain').getViewModel().get('gasto').get('asignadoATrabajos') || me.editableSoloPago())
										        						this.setReadOnly(true);
										        					else
										        						this.setReadOnly(false);
										        				},											                
										        				change: function(){	
										        					var field=me.up('gastodetallemain').lookupReference('tipoImpositivo');
										        					if(this.getValue()!='' && this.getValue()>0){
										        						
										        						if(field.getValue()!='' && field.getValue()>0){
											        						field.validate();
										        						}
										        						else {
										        							field.clearInvalid();
										        						}
										        						me.up('gastodetallemain').lookupReference('impuestoindirecto').setDisabled(false);
											                			me.up('gastodetallemain').lookupReference('impuestodirecto').setDisabled(false);
											        				}
										        					else{
										        						field.clearInvalid();
										        						me.up('gastodetallemain').lookupReference('cbOperacionExenta').setValue(0);
										        						//me.up('gastodetallemain').lookupReference('impuestoindirecto').setDisabled(true);
										        						me.up('gastodetallemain').lookupReference('impuestodirecto').setDisabled(true);
										        						//field.setValue(0);
										        						me.up('gastodetallemain').lookupReference('tipoImpositivoIRPF').setValue('');
										        					}
										        				},																		        						
								        						afterrender: function(){							        					
										        					if(me.up('gastodetallemain').getViewModel().get('gasto').get('asignadoATrabajos'))
										        						this.setReadOnly(true);
										        					else
										        						this.setReadOnly(false);
										        				},							        				
																update: function(){
																	if(Ext.isEmpty(this.getValue()))
																		this.setValue(0);
																	
																}
											                }
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.principal.no.sujeto'),
															reference: 'importePrincipalNoSujeto',
											                bind: '{detalleeconomico.importePrincipalNoSujeto}'											                
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
												border: false,
												height: 250,
				        						margin: '10 0 10 0',
				        						defaultType: 'currencyfieldbase',
				        						reference:'fieldGastos',
				        						defaults: {
				        							style: 'text-align: right',
											        fieldStyle:'text-align:right;',
											        labelStyle: 'text-align:left;'
				        						},
												items :
													[
														{ 	xtype:'checkboxfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.prorrata'),
															reference:'rfProrrata',
											                bind:'{detalleeconomico.prorrata}',
											                readOnly:true
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.exencion.lbk'),
											                bind: '{detalleeconomico.exencionlbk}',
											                readOnly:true,
											                symbol: HreRem.i18n("symbol.euro")
														},
														{ 
															fieldLabel:HreRem.i18n('fieldlabel.total.importe.promocion'),
											                bind: '{detalleeconomico.totalImportePromocion}',
											                readOnly:true,
											                symbol: HreRem.i18n("symbol.euro")
														},
														{ 
															fieldLabel:HreRem.i18n('fieldlabel.importe.total'),
											                bind: '{detalleeconomico.importeTotalPrinex}',
											                readOnly:true,
											                symbol: HreRem.i18n("symbol.euro")
														}
													],
													listeners:{
														beforerender:'isLiberbankAndGastosPrinex'
													}
											},
											{   
												xtype:'fieldset',
												defaultType: 'textfieldbase',
												height: 250,
				        						margin: '0 10 10 0',
				        						reference: 'impuestoindirecto',
												title: HreRem.i18n('title.gasto.detalle.economico.impuesto.indirecto'),

												listeners:{												
													afterrender: function(){														
									         			if(!Ext.isEmpty(me.up('gastodetallemain').getViewModel().get('gasto').get('nombreGestoria'))){
									         				this.setHidden(true);
									         				this.setDisabled(true);
									         			}
									         			else{
									         				this.setHidden(false);
									         				this.setDisabled(false);
									         			}
													}
												},
												items :
													[
														{ 
															xtype: 'comboboxfieldbase',
											               	fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.tipo.impuesto.indirecto'),
													      	reference: 'cbTipoImpuesto',
													      	allowBlank: false,
													      	readOnly: me.editableSoloPago(),
											               	bind: {
												           		store: '{comboTipoImpuesto}',
												           		value: '{detalleeconomico.impuestoIndirectoTipoCodigo}'
												         	},
												         	listeners:{
												         		edit: function(){
												         			this.validate();
												         		}
												         	}
													    },
													    {		                
										                	xtype: 'checkboxfieldbase',
										                	reference: 'cbOperacionExenta',
										                	fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.operacion.exenta'),
										                	readOnly: me.editableSoloPago(),
										                	bind: {
								        						value: '{detalleeconomico.impuestoIndirectoExento}'							        						
						            						},
						            						listeners:{
						            							afterbind: 'onChangeOperacionExenta',
						            							change: function(field,newValue,oldValue){
						            								me.lookupController().onChangeOperacionExenta(field,newValue);
						            							}
						            						}
					                					},
					                					{		                
										                	xtype: 'checkboxfieldbase',
										                	fieldLabel:  HreRem.i18n('fieldlabel.detalle.economico.renuncia.exencion'),
										                	readOnly: me.editableSoloPago(),
										                	reference: 'cbRenunciaExencion',
										                	bind: {
								        						value: '{detalleeconomico.renunciaExencionImpuestoIndirecto}'
						            						},
						            						listeners:{
						            							afterbind: 'onChangeRenunciaExencion',
						            							change: function(field,newValue,oldValue){
						            								me.lookupController().onChangeRenunciaExencion(field,newValue);
						            							}
						            							
						            						}
					                					},
					                					{ 
															xtype: 'numberfieldbase',
															symbol: HreRem.i18n("symbol.porcentaje"),
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.tipo.impositivo'),
															readOnly: me.editableSoloPago(),
															reference: 'tipoImpositivo',
											                bind: {
											                	value: '{detalleeconomico.impuestoIndirectoTipoImpositivo}'
											                },
											                validator: function(v) {
											                	var principal=me.up('gastodetallemain').lookupReference('importePrincipalSujeto');											                	
											                	if (Ext.isEmpty(this.getValue())){
											                		this.clearInvalid();
									                            	return "";
											                	}else
											                		this.clearInvalid();
											                	if(principal.getValue()!='' && principal.getValue()>0){
									                            	if(this.getValue() <= 0)
										                            	return "La cuota debe ser mayor que 0";
									                            	else
												                		this.clearInvalid();									                            	
									                            }else
											                		this.clearInvalid();
									                            return true;
									                        },
											                listeners:{
										        				change: function(){	
										        					var principal=me.up('gastodetallemain').lookupReference('importePrincipalSujeto');
										        					if(this.getValue()=='' || this.getValue()==0){
										        						if(principal.getValue()!='' && principal.getValue()>0)
											        						this.markInvalid();
										        						else
										        							this.clearInvalid();
											        				}
										        					this.validate();
										        				}
										        			}
														},
														{ 
															xtype: 'currencyfieldbase',
															symbol: HreRem.i18n("symbol.euro"),
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
															fieldLabel: HreRem.i18n('fieldlabel.detalle.economico.cuota'),
															readOnly: me.editableSoloPago(),
															reference: 'cbCuota',
											                bind: {
											                	value: '{calcularImpuestoIndirecto}'
											                },
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
															style: 'text-align: right',
											        		fieldStyle:'text-align:right;',
											        		labelStyle: 'text-align:left;',
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
																					    xtype: 'textfieldbase',
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
								}
           
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);
		//me.lookupController().refrescarGasto(true);    	
    }
});