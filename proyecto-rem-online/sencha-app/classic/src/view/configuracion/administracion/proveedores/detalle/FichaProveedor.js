Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.FichaProveedor', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fichaproveedor',
    reference: 'fichaProveedorRef',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    recordName: "proveedor",
	recordClass: "HreRem.model.FichaProveedorModel",
    requires: ['HreRem.model.FichaProveedorModel', 'HreRem.view.common.ItemSelectorBase',
               'HreRem.view.configuracion.administracion.proveedores.detalle.DireccionesDelegacionesList',
               'HreRem.view.configuracion.administracion.proveedores.detalle.PersonasContactoList',
               'HreRem.view.configuracion.administracion.proveedores.detalle.ActivosIntegradosList'],
    initComponent: function () {
        var me = this;
        
        me.setTitle(HreRem.i18n('title.datos'));
        
        me.items= [
					{
						xtype:'container',
						layout: {
							type : 'hbox',
						    pack : 'center'
						},
						items :
							[
					         // Fila 0
			        			{
			        				xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fecha.ultima.actualizacion'),
									bind: '{proveedor.fechaUltimaActualizacion}',
									colspan: 2,
									readOnly: true
					            }
							]
					},
// Datos Generales
		            {
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						title: HreRem.i18n('title.datos.generales'),
						collapsible: true,
						items :
							[
								{
									xtype:'fieldsettable',
									border:false,
									collapsible:false,
									colspan:3,
									items:[
										// Fila 0  
						                { 
						                	xtype: 'textfieldbase',
						                	fieldLabel: HreRem.i18n('fieldlabel.proveedores.codigo'),
						                	bind: '{proveedor.codigo}',
						                	readOnly: true
						                },					                
						                { 
						                	xtype: 'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.nombre'),
											bind: '{proveedor.nombreProveedor}',
											maxLength: 250
						                },
						                {
								        	xtype: 'datefieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.fecha.alta'),
											bind: '{proveedor.fechaAltaProveedor}'
										},
									// Fila 1
										{ 
						                	xtype: 'textfieldbase',
						                	fieldLabel: HreRem.i18n('fieldlabel.proveedores.codigoProveedorUvem'),
						                	bind: '{proveedor.codProveedorUvem}'
						                },
						                {
											 xtype : 'comboboxfieldbase',
											 fieldLabel: HreRem.i18n('fieldlabel.tipo'),
											 allowBlank: false,
											 reference: 'cbTipoProveedor',
											 chainedStore: 'comboSubtipoProveedor',
											 chainedReference: 'cbSubtipoProveedor',
										     bind : {
										       store : '{comboTipoProveedor}',
										       value : '{proveedor.tipoProveedorCodigo}'
										     },
										     listeners: {
							                   select: 'onChangeChainedCombo',
							                   change: 'onTipoProveedorChange'
							            	 }
										},
								        { 
						                	xtype: 'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.proveedores.nombrecomercial'),
											bind: '{proveedor.nombreComercialProveedor}',
											maxLength: 250
						                },
						                {
								        	xtype: 'datefieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.fecha.baja'),
											bind: '{proveedor.fechaBajaProveedor}'
										},
									// Fila 2
										{ 
											xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.subtipo'),
								        	allowBlank: false,
								        	reference: 'cbSubtipoProveedor',
								        	valueField: 'codigo',
								        	bind: {
							            		store: '{comboSubtipoProveedor}',
							            		value: '{proveedor.subtipoProveedorCodigo}',
							            		disabled: '{!proveedor.tipoProveedorCodigo}'
							            	}
								        },
								        {
								        	xtype : 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
								        	reference: 'cbTipoDocumento',
								        	bind : {
											      store : '{comboTipoDocumento}',
											      value : '{proveedor.tipoDocumentoCodigo}'
											}
								        },
								        { 
						                	xtype: 'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.proveedores.nif'),
											bind: '{proveedor.nifProveedor}',
											maxLength: 20
						                },
						             // Fila 3
						                	{
											xtype : 'comboboxfieldbase',
										    fieldLabel : HreRem.i18n('fieldlabel.proveedor.localizada'),
										    reference: 'cbLocalizada',
										    bind : {
										      store : '{comboSiNoRem}',
										      disabled: '{!proveedor.isEntidad}',
										      value : '{proveedor.localizadaProveedorCodigo}'
										    }
										},
										{ 
											xtype: 'textfieldbase',
											vtype: 'email',
											fieldLabel: HreRem.i18n('fieldlabel.proveedor.email'),
											bind: '{proveedor.email}',
											maxLength: 50
						                },
								        { 
											xtype: 'textareafieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.observaciones'),						        	
								        	bind: '{proveedor.observacionesProveedor}',
											maxLength: 200,
								        	rowspan: 2,
								        	height: 80
								        },
								     // Fila 4
								        { 
											xtype: 'comboboxfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
								        	reference: 'cbEstadoProveedor',
								        	bind: {
											      store: '{comboEstadoProveedor}',
											      value: '{proveedor.estadoProveedorCodigo}'
								        	}
								        },
								        {
											xtype : 'comboboxfieldbase',
										    fieldLabel : HreRem.i18n('fieldlabel.proveedores.tipopersona'),
										    reference: 'cbTipoPersona',
										    bind : {
										      store : '{comboTipoPersona}',
										      disabled: '{!proveedor.isProveedor}',
										      value : '{proveedor.tipoPersonaProveedorCodigo}'
										    }
										},
										 // Fila 5
								        {
											xtype: 'textfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.url.web'),						        	
								        	bind: '{proveedor.webUrlProveedor}',
											maxLength: 50
								        },
								        {
											xtype: 'checkboxfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.autorizado.web'),
											bind: '{proveedor.autorizacionWeb}',
											readOnly: false
										},
							        
							            {// Siempre oculto por el momento.
							            	xtype: 'comboboxfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.operativa'),
								        	reference: 'cbOperativaProveedor',
								        	bind: {
											      store: '{comboOperativa}',
											      value: '{proveedor.operativaCodigo}'
								        	},
								        	hidden: true
							            },
							            {
					        				xtype: 'datefieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.proveedor.fecha.constitucion'),
											reference: 'dateConstitucionProveedor',
											
											//colspan: 2,
											bind: {
												disabled: '{!proveedor.isEntidad}',
												value: '{proveedor.fechaConstitucionProveedor}'
											}
							            },
							             // Fila 6
								        {
											xtype: 'textfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.numero.ursus.bankia'),	
								        	reference: 'numUrsusRef',
								        	bind: '{proveedor.codProveedorUvem}',
								        	maskRe: /^\d*$/, 
								        	listeners:{
								        		render: function(){
								        			var me = this;
								        			var codigoCartera = me.up('proveedoresdetallemain').getViewModel().get('proveedor.carteraCodigo');
								        			if(Ext.isDefined(codigoCartera) && codigoCartera != null && codigoCartera.includes(CONST.CARTERA["BANKIA"])){						        				
								        				me.allowBlank = false;
								        				me.setReadOnly(false);
								        				
								        			}else{						        				
								        				me.allowBlank = true;
								        				me.setReadOnly(true);
								        			}						        			
								        		}
								        	},
								        	hidden: true
							            
								        },
										{
											xtype: 'textfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.proveedorapi.codigo'),						        	
								        	bind: {
								        		value:'{proveedor.codigoApiProveedor}',
								        		hidden: '{!esTipoOficina}'
								        	}
											
								        },						        
										{ 
											xtype: 'comboboxsearchfieldbase',
											fieldLabel:  HreRem.i18n('fieldlabel.proveedores.mediador'),						
											reference: 'cbmediadorProveedor',											
										    bind : {
										      store : '{comboMediador}',								      
										      value : '{proveedor.idMediadorRelacionado}',
										      hidden: '{!esTipoOficina}'
										    },								    
										    displayField: 'nombre',								    
					    					valueField: 'codigoProveedorRem',
					    					emptyText: 'Introduzca nombre mediador',					    					
					    					autoLoadOnValue: false,
					    					loadOnBind: false,
					    					forceSelection: false,
					    					addUxReadOnlyEditFieldPlugin: true
										},
										
										{
							            	xtype: 'comboboxfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.origen.peticion.homologacion'),
								        	reference: 'origenPeticionHomologacion',
								        	bind: {
											      store: '{comboOrigenPeticion}',
											      value: '{proveedor.origenPeticionHomologacionCodigo}',
										          hidden: '{!proveedor.isMediador}'
								        	}
								        	 
							            },
										{
											xtype: 'textfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.proveedor.peticionario'),					        	
								        	bind: { value:  '{proveedor.peticionario}',
								        			hidden: '{!proveedor.isMediador}'
								        	}
											
								        },
								        {
							            	xtype: 'comboboxfieldbase',
								        	fieldLabel: HreRem.i18n('fieldlabel.proveedor.linea.negocio'),
								        	reference: 'lineaNegocio',
								        	bind: {
											      store: '{comboLineaDeNegocio}',
											      value: '{proveedor.lineaNegocioCodigo}',
										          hidden: '{!proveedor.isMediador}'
								        	}
								        	 
							            },
							            {
							            	xtype: 'comboboxfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.clientes.no.residentes'),
								        	reference: 'clitntesNoResidentes',
								        	bind: {
											      store: '{comboSinSino}',
											      value: '{proveedor.gestionClientesNoResidentesCodigo}',
										          hidden: '{!proveedor.isMediador}'
								        	}
								        	 
							            },
							            {
											xtype: 'numberfieldbase',
								        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.numero.comerciales'),				        	
								        	bind: { value: '{proveedor.numeroComerciales}',
								        			hidden: '{!proveedor.isMediador}'
								        	}
											
								        },
								        { 
											xtype: 'datefieldbase',
											fieldLabel:  HreRem.i18n('fieldlabel.proveedor.fecha.ultimo.contrato.vigente'),
											reference: 'fechaUltimoContratoVigente',
											bind: { value: '{proveedor.fechaUltimoContratoVigente}',
													hidden: '{!proveedor.isMediador}'
											}
										},
							            {
											xtype: 'textfieldbase',
								        	fieldLabel:   HreRem.i18n('fieldlabel.proveedor.motivo.baja'),					        	
								        	bind: { value:'{proveedor.motivoBaja}',
								        			hidden: '{!proveedor.isMediador}'
								        	}
											
								        }
							            
										
									]
								},				             				        
					         // Fila 7 (Ámbito)
					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.proveedor.ambito'),
									collapsible: true,
									width: "100%", 
									bind: {
										disabled: '{!proveedor.isProveedor}'
									},
									colspan: 4,
									layout: {
			                            type: 'table',
			                            columns: 4,
			                            tdAttrs: {
			                                width: '25%',
			                                style: 'vertical-align: top'
			                            },
			                            tableAttrs: {
			                                style: {
			                                    width: '100%'
			                                    }
			                            }
			                        },
									items :
										[
											{
											    xtype: 'itemselectorbase',
											    reference: 'itemselTerritorial',
											    fieldLabel: HreRem.i18n('fieldlabel.proveedor.territorial'),
											    store: me.up('proveedoresdetallemain').getViewModel().getStore('comboFiltroProvincias'),
											    bind: {
											    	value: '{proveedor.territorialCodigo}'
											    }
											},
											{
									            xtype: 'itemselectorbase',
									            reference: 'itemselCartera',
									            fieldLabel: HreRem.i18n('fieldlabel.cartera'),
									            store: {
									            	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'entidadesPropietarias'}
													},
													autoLoad: true
									            },
									            bind: {
									            	value: '{proveedor.carteraCodigo}'
									            },
									            listeners:{
									            	change: function(){
									            		var me = this;									            		
									            		var campoUrsus = me.lookupController('proveedordetalle').lookupReference('numUrsusRef');
									            		if(me.getValue().includes(CONST.CARTERA["BANKIA"])){									            			
									            			campoUrsus.allowBlank = false;
									            			campoUrsus.setReadOnly(false);
									            			if(me.up('proveedoresdetallemain').getViewModel().get("editing")){
									            				campoUrsus.fireEvent('edit');
									            			}else{
									            				campoUrsus.fireEvent('cancel');
									            			}
									            		}else{									            			
									            			campoUrsus.allowBlank = true;
									            			campoUrsus.setReadOnly(true);
									            			campoUrsus.fireEvent('cancel');
									            		}
									            	}
									            }
									        },
									       {
											    xtype: 'itemselectorbase',
											    reference: 'itemselEspecialidad',
											    fieldLabel: HreRem.i18n('fieldlabel.proveedor.especialidad'),
											    store: {
									            	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'especialidad'}
													},
													autoLoad: true
									            },									   
											    bind: {
											    	value: '{proveedor.especialidadCodigo}',
											    	hidden: '{!proveedor.isMediador}'
											    }
											   
											},
											{
											    xtype: 'itemselectorbase',
											    reference: 'itemselIdiomas',
											    fieldLabel: HreRem.i18n('fieldlabel.proveedor.idiomas'),
											    store: {
									            	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'idioma'}
													},
													autoLoad: true
									            },
											    bind: {
											    	value: '{proveedor.idiomaCodigo}',
											    	hidden: '{!proveedor.isMediador}'
											    }
											}
										]
					            },
					         // Fila 8 (Mediador)
					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.mediador'),
									collapsible: true,
									bind: {
										disabled: '{!proveedor.isMediador}'
									},
									colspan: 3,
									items :
										[
										// Fila 0
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedor.custodio'),
											    reference: 'cbProveedorCustodio',
											    bind : {
											      store : '{comboSiNoRem}',
											      value : '{proveedor.custodioCodigo}'
											    }
											},
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedor.tipos.activos.cartera'),
											    reference: 'cbProveedorTipoActivos',
											    bind : {
											      store : '{comboTipoActivosCartera}',
											      value : '{proveedor.tipoActivosCarteraCodigo}'
											    }
											},
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedores.calificacion'),
											    reference: 'cbProveedorCalificacion',
											    bind : {
											      store : '{comboCalificacionProveedor}',
											      value : '{proveedor.calificacionCodigo}'
											    }
											},
										// Fila 1
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedores.homologado'),
											    reference: 'cbProveedorHomologado',
											    bind : {
											      store : '{comboSiNoRem}',
											      value : '{proveedor.homologadoCodigo}'
											    }
											},
											{
												// Label vacía para generar un espacio por cuestión de estética.
												xtype: 'label',
												colspan: 1
										    },
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedor.incluido.top'),
											    reference: 'cbProveedorTop',
											    bind : {
											      store : '{comboSiNoRem}',
											      value : '{proveedor.incluidoTopCodigo}'
											    }
											}
										]
					            }
							]
		           },
// Datos Económicos
		           {
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						title: HreRem.i18n('title.datos.economicos'),
						collapsible: true,
						items :
							[
							 	{
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.datos.bancarios'),
									collapsible: false,
									colspan: 1,
									margin: '-10 12 0 0',
									layout: {
										type : 'table',
										columns: 1
									},
									items :
										[
											{ 
												xtype: 'textfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.proveedor.iban'),						        	
												bind: '{proveedor.numCuentaIBAN}',
												maxLength: 50
											},
											{ 
												xtype: 'textfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.proveedor.titular.cuenta'),						        	
												bind: '{proveedor.titularCuenta}',
												maxLength: 200
											}
										]
					            },
					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.retencion.pago'),
									collapsible: false,
									colspan: 2,
									layout: {
										type : 'table',
										columns: 2
									},
									items :
										[
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedor.retener.pago'),
											    reference: 'cbProveedorRetencionPago',
											    bind : {
											      store : '{comboSiNoRem}',
											      value : '{proveedor.retencionPagoCodigo}'
											    },
											    listeners: {
			    	    							change: function(combo, value) {
			    	    								var me = this;
		    	    									var form = combo.up('form');
		    	    									var motivoRetencionCombo = form.down('field[name=cbProveedorMotivoRetencion]');
		    	    									var fechaRetencion = form.down('field[name=fechaRetencion]');
			    	    								if(value=="0"){			    	    									
			    	    									motivoRetencionCombo.setDisabled(true);
			    	    									fechaRetencion.setDisabled(true);
			    	    								}else{
			    	    									motivoRetencionCombo.setDisabled(false);
			    	    									fechaRetencion.setDisabled(false);
			    	    								}
			    	    							}
			    	    						}											
											},
											{ 
												xtype: 'datefieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.proveedor.retener.pago.fecha'),
												name: 'fechaRetencion',
												bind: '{proveedor.fechaRetencion}'
											},
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedor.retener.pago.motivo'),
											    reference: 'cbProveedorMotivoRetencion',
											    name: 'cbProveedorMotivoRetencion',
											    colspan: 2,
											    bind : {
											      store : '{comboMotivoRetencionPago}',
											      value : '{proveedor.motivoRetencionCodigo}'
											    }
											}
										]
					            },
					            {
									xtype : 'comboboxfieldbase',
								    fieldLabel : HreRem.i18n('fieldlabel.proveedor.criterio.caja.iva'),
								    reference: 'cbProveedorCriterioCajaIVA',
								    bind : {
								      store : '{comboSiNoRem}',
								      value : '{proveedor.criterioCajaIVA}'
								    }
								},
								{ 
									xtype: 'datefieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.proveedor.ejercicio.opcion.fecha'),						        	
									bind: {
										disabled: '{!proveedor.criterioCajaIVA}',
										value: '{proveedor.fechaEjercicioOpcion}'
									}
								}
							]
		            },
// Activos Integrados
		            {
		            	 xtype:'fieldsettable',
							defaultType: 'textfieldbase',						
							title: HreRem.i18n('title.activos.integrados'),
							collapsible: true,
							/*bind: {
								disabled: '{!proveedor.isEntidadOrAdministracionOrMediador}'
							},*/
							colspan: 3,
							items :
								[
								 {xtype: 'activosintegradoslist'}
								]
		            },
// Control PBC
		            {
		            	 xtype:'fieldsettable',
							defaultType: 'textfieldbase',						
							title: HreRem.i18n('title.control.pbc'),
							collapsible: true,
							bind: {
								disabled: '{!proveedor.isProveedor}'
							},
							items :
								[
								 {
									 xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.fecha.proceso'),
										bind: '{proveedor.fechaProceso}'
								 },
								 {
										// Label vacía para generar un espacio por cuestión de estética.
										xtype: 'label',
										colspan: 1
								    },
								 {
									 xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.proveedor.resultado'),
									    reference: 'cbProveedorResultado',
									    bind : {
									      store : '{comboResultadoProcesoBlanqueo}',
									      value : '{proveedor.resultadoBlanqueoCodigo}'
									    }
								 }
								]
		            }
        ];
        
    	me.callParent();
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});