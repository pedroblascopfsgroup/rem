Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.FichaProveedor', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fichaproveedor',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    recordName: "proveedor",
	recordClass: "HreRem.model.FichaProveedorModel",
    requires: ['HreRem.model.FichaProveedorModel'],

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
						collapsible: false,
						items :
							[
				             // Fila 0  
				                { 
				                	xtype: 'textfieldbase',
				                	fieldLabel: HreRem.i18n('fieldlabel.proveedor.id'),
				                	bind: '{proveedor.id}',
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
								      value : '{proveedor.localizadaProveedorCodigo}'
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
								      value : '{proveedor.tipoPersonaProveedorCodigo}'
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
									bind: '{proveedor.fechaConstitucionProveedor}'
					            },
					         // Fila 5 (Ámbito)
					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.proveedor.ambito'),
									collapsible: false,
									disabled: true,
									colspan: 3,
									items :
										[
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedor.territorial'),
											    reference: 'cbProveedorTerritorial',
											    multiSelect: true,
											    bind : {
											      store : '{comboTerritorial}',
											      value : '{proveedor.territorialCodigo}'
											    }
											},
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.cartera'),
											    reference: 'cbProveedorCartera',
											    multiSelect: true/*,
											    bind : {
											      store : '{comboCartera}',
											      value : '{proveedor.carteraCodigo}'
											    },
											    listeners: {
											    	afterRender: 'loadMultiCartera'
											    }*/
											},
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.proveedores.subcartera'),
											    reference: 'cbProveedorSubcartera',
											    bind : {
											      store : '{comboSubcartera}',
											      value : '{proveedor.subcarteraCodigo}'
											    }
											}
										]
					            },
					         // Fila 6 (Mediador)
					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.mediador'),
									collapsible: false,
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
												// Label vacía para generar un espacio por cuestión de estética.
												xtype: 'label',
												colspan: 2
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
						collapsible: false,
						items :
							[
							 	{
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.datos.bancarios'),
									collapsible: false,
									colspan: 1,
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
					            }
							]
		            },
// Datos de Contacto
		            {
		            	xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						title: HreRem.i18n('title.datos.contacto'),
						collapsible: false,
						layout: {
							type : 'table',
							columns: 1
						},
						items :
							[
							 // Fila 0 (Direcciones y Delegaciones)
							 {
								 xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.direcciones.delegaciones'),
									collapsible: false,
									disabled: true,
									layout: {
										type : 'table',
										columns: 1
									},
									items :
										[
										 //{xtype: direccionesdelegacioneslist}
										]
							 },
							// Fila 1 (Personas de Contacto)
							 {
								 xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.personas.contacto'),
									collapsible: false,
									disabled: true,
									layout: {
										type : 'table',
										columns: 1
									},
									items :
										[
										 //{xtype: personascontactolist}
										]
							 }
							]
		            },
// Activos Integrados
		            {
		            	 xtype:'fieldsettable',
							defaultType: 'textfieldbase',						
							title: HreRem.i18n('title.activos.integrados'),
							collapsible: false,
							disabled: true,
							layout: {
								type : 'table',
								columns: 1
							},
							items :
								[
								 //{xtype: activosintegradoslist}
								]
		            },
// Control PBC
		            {
		            	 xtype:'fieldsettable',
							defaultType: 'textfieldbase',						
							title: HreRem.i18n('title.control.pbc'),
							collapsible: false,
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
		//me.lookupController().cargarTabData(me);
    }
});