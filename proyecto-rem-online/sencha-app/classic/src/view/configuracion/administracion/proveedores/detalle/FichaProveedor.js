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
					                   select: 'onChangeChainedCombo'
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
				                	xtype: 'textfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.proveedores.nif'),
									bind: '{proveedor.nifProveedor}',
									maxLength: 20
				                },
				                {
									xtype : 'comboboxfieldbase',
								    fieldLabel : HreRem.i18n('fieldlabel.proveedor.localizada'),
								    reference: 'cbLocalizada',
								    bind : {
								      store : '{comboSiNoRem}',
								      disabled: '{!proveedor.isEntidad}',
								      value : '{proveedor.localizadaProveedorCodigoCalculated}'
								    }
								},
							// Fila 3
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
								      value : '{proveedor.tipoPersonaProveedorCodigoCalculated}'
								    }
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
									xtype: 'textfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.url.web'),						        	
						        	bind: '{proveedor.webUrlProveedor}',
									maxLength: 50
						        },
						        {
			        				xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.proveedor.fecha.constitucion'),
									bind: {
										disabled: '{!proveedor.isEntidad}',
										value: '{proveedor.fechaConstitucionProveedorCalculated}'
									}
					            },
					         // Fila 5
					            {// Siempre oculto por el momento.
					            	xtype: 'comboboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.proveedores.operativa'),
						        	reference: 'cbOperativaProveedor',
						        	bind: {
									      store: '{comboOperativa}',
									      value: '{proveedor.operativaCodigo}'
						        	},
						        	colspan: 3,
						        	hidden: true
					            },
					         // Fila 6 (Ámbito)
					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.proveedor.ambito'),
									collapsible: true,
									bind: {
										disabled: '{!proveedor.isProveedor}'
									},
									colspan: 3,
									items :
										[
											{
											    xtype: 'itemselectorbase',
											    reference: 'itemselTerritorial',
											    fieldLabel: HreRem.i18n('fieldlabel.proveedor.territorial'),
											    store: {
											    	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'provincias'}
													},
													autoLoad: true
											    },
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
									            }
									        },
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedores.subcartera'),
											    reference: 'cbProveedorSubcartera',
											    disabled: true,
											    bind : {
											      store : '{comboSubcartera}',
											      value : '{proveedor.subcarteraCodigo}'
											    }
											}
										]
					            },
					         // Fila 7 (Mediador)
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
											    }
											},
											{ 
												xtype: 'datefieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.proveedor.retener.pago.fecha'),						        	
												bind: '{proveedor.fechaRetencion}'
											},
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedor.retener.pago.motivo'),
											    reference: 'cbProveedorMotivoRetencion',
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
// Datos de Contacto
		            {
		            	xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						title: HreRem.i18n('title.datos.contacto'),
						collapsible: true,
						items :
							[
							// Fila 0 (Direcciones y Delegaciones)
							 {
								 xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.direcciones.delegaciones'),
									collapsible: true,
									colspan: 3,
									items :
										[
										 {xtype: 'direccionesdelegacioneslist'}
										]
							 },
							// Fila 1 (Personas de Contacto)
							 {
								 xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.personas.contacto'),
									collapsible: true,
									colspan: 3,
									items :
										[
										 {xtype: 'personascontactolist'}
										]
							 }
							]
		            },
// Activos Integrados
		            {
		            	 xtype:'fieldsettable',
							defaultType: 'textfieldbase',						
							title: HreRem.i18n('title.activos.integrados'),
							collapsible: true,
							bind: {
								disabled: '{!proveedor.isEntidadOrAdministracionOrMediador}'
							},
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