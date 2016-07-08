Ext.define('HreRem.view.activos.detalle.InformeComercialActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'informecomercialactivo',
    reference: 'informecomercialactivoref',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    saveMultiple: true,
    records: ['activoInforme','informeComercial'], 
    recordsClass: ['HreRem.model.Activo','HreRem.model.ActivoInformeComercial'],    
    requires: ['HreRem.model.Activo', 'HreRem.view.common.FieldSetTable', 'HreRem.model.ActivoInformeComercial', 'HreRem.model.Distribuciones',
    'HreRem.view.activos.detalle.InfoLocalComercial', 'HreRem.view.activos.detalle.InfoPlazaAparcamiento', 'HreRem.view.activos.detalle.InfoVivienda'
    ],
    
    listeners: {
    	
    	boxready: function() {
    		var me = this,
    		model = me.lookupController().getViewModel();
		    
    		if(model.get("activo.isLocalComercial")) {
		     	me.add({                    
					xtype:'infolocalcomercial',
					title: HreRem.i18n('title.local.comercial')
		        });
    		}
    		if(model.get("activo.isPlazaAparcamiento")) {
		     	me.add({    
					xtype:'infoplazaaparcamiento',
					title: HreRem.i18n('title.plaza.aparcamiento')
	        	});
    		}
	    	if(model.get("activo.isVivienda")) {
			     me.add({    
		        	xtype: 'infovivienda'
		        });	 
	    	}

	    	me.lookupController().cargarTabData(me);
    	}

    },
    
    initComponent: function () {

        var me = this;
        
        me.items = [
// Mediador ---
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.mediador'),
				defaultType: 'textfieldbase',
				items :
					[
					// Fila 1
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.nombre'),
							bind: '{informeComercial.nombreMediador}'
							//, readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.telefono'),
							bind: '{informeComercial.telefonoMediador}'
							//, readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.email'),
							bind: '{informeComercial.emailMediador}'
							//, readOnly: true
						},
					// Fila 2
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.frecepcion.llaves'),
							bind: '{informeComercial.fechaRecepcionLlaves}'
							//, readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fultima.visita'),
							bind: '{informeComercial.fechaUltimaVisita}',
							colspan: 2
							//, readOnly: true
						},
					// Fila 3
						{
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.autorizado.web'),
							bind: '{informeComercial.autorizacionWeb}'
							//, readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fautorizacion.hasta'),
							bind: '{informeComercial.fechaAutorizacionHasta}'
							//, readOnly: true
						}

				]
			},

// Estado del informe comercial			
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('fieldlabel.estado.informe.comercial'),
				defaultType: 'textfieldbase',
				items :
					[
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.emision'),
							bind: '{informeComercial.fechaEmisionInforme}'
							//, readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.aceptacion'),
							bind: '{informeComercial.fechaAceptacion}'
							//, readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.rechazo'),
							bind: '{informeComercial.fechaRechazo}'
							//, readOnly: true
						}
				]
			},
			
// Datos Básicos ---
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.datos.basicos'),
				defaultType: 'textfieldbase',
				items :
					[
					
						{    
			  
							xtype:'fieldsettable',
							title:HreRem.i18n('title.validacion.conflictos'),
							defaultType: 'textfieldbase',
							items :
								[

						            {    
						                
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										title:HreRem.i18n('title.datos.admision'),
										colspan: 3,
										items :
											[
												// fila 0
												{ 
										        	xtype: 'comboboxfieldbase',
										        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
													reference: 'tipoActivoAdmisionInforme',
										        	chainedStore: 'comboSubtipoActivo',
													chainedReference: 'subtipoActivoComboAdmisionInforme',
										        	bind: {
									            		store: '{comboTipoActivo}',
									            		value: '{activoInforme.tipoActivoCodigo}'
									            	},
						    						listeners: {
									                	select: 'onChangeChainedCombo'
									            	}
									            	//,allowBlank: false
										        },
												{ 
													xtype: 'comboboxfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
										        	reference: 'subtipoActivoComboAdmisionInforme',
										        	bind: {
									            		store: '{comboSubtipoActivo}',
									            		value: '{activoInforme.subtipoActivoCodigo}',
									            		disabled: '{!activoInforme.tipoActivoCodigo}'
									            	}
									            	, colspan: 2
						    						//,allowBlank: false
										        },			       
// TODO: Confirmar que hay que quitarlo (estado Activo)
//												{ 
//										        	xtype: 'comboboxfieldbase',
//										        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
//										        	name: 'estadoActivoCodigo',
//										        	bind: {
//									            		store: '{comboEstadoActivo}',
//									            		value: '{activoInforme.estadoActivoCodigo}'
//									            	}			
//										        },
												// fila 1
												{							
													xtype: 'comboboxfieldbase',
													fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
										        	bind: {
									            		store: '{comboTipoVia}',
									            		value: '{activoInforme.tipoViaCodigo}'			            		
									            	}
						    						//,allowBlank: false
												},
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
								                	bind:		'{activoInforme.nombreVia}'
								                	//,allowBlank: false
								                },
								                { 
								                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
								                	bind:		'{activoInforme.numeroDomicilio}'
								                },
								                // fila 2
								                {
													fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
									                bind:		'{activoInforme.escalera}'
												},
						 						{ 
								                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
								                	bind:		'{activoInforme.piso}'
								                },
												{ 
								                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
								                	bind:		'{activoInforme.puerta}'
								                },
								                // fila 4
								                {
													fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
													bind:		'{activoInforme.codPostal}',
													vtype: 'codigoPostal',
													maskRe: /^\d*$/, 
								                	maxLength: 5
													//,allowBlank: false		                	
												},
								                {
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.municipio'),
													reference: 'municipioComboAdmisionInforme',
													selectFirst: true,
									            	bind: {
									            		store: '{comboMunicipio}',
									            		value: '{activoInforme.municipioCodigo}',
									            		disabled: '{!activoInforme.provinciaCodigo}'
									            	}
						    						//,allowBlank: false
												},
												{
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.provincia'),
													reference: 'provinciaComboAdmisionInforme',
													chainedStore: 'comboMunicipio',
													chainedReference: 'municipioComboAdmisionInforme',
									            	bind: {
									            		store: '{comboProvincia}',
									            	    value: '{activoInforme.provinciaCodigo}'
									            	},
						    						listeners: {
														select: 'onChangeChainedCombo'
						    						}
						    						//,allowBlank: false
												},
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.latitud'),
													readOnly	: true,
													bind:		'{activoInforme.latitud}'
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.longitud'),
													readOnly	: true,
													bind:		'{activoInforme.longitud}'
								                },
												{
								                	xtype: 'button',
								                	reference: 'botonVerificarCoordenadasInforme',
								                	disabled: true,
								                	bind:{
								                		disabled: '{!editing}'
								                	},
								                	text: HreRem.i18n('btn.verificar.coordenadas'),
								                	handler: 'onClickVerificarDireccion'
								                },
												{
								                	xtype: 'button',
								                	reference: 'botonCopiarDatosMediador',
								                	disabled: true,
								                	bind:{
								                		disabled: '{!editing}'
								                	},
								                	text: HreRem.i18n('btn.copiar.datos.mediador'),
								                	colspan: 3,
								                	style: "float: right; important!",
								                	handler: 'onClickCopiarDireccionMediador'
								                }

										]               
						          	},
									{    
						  
										xtype:'fieldsettable',
										title:HreRem.i18n('title.datos.mediador'),
										defaultType: 'textfieldbase',
										colspan: 3,
										items :
											[
												// fila 0
												{ 
										        	xtype: 'comboboxfieldbase',
										        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
													reference: 'tipoActivoMediadorInforme',
										        	chainedStore: 'comboSubtipoActivo',
													chainedReference: 'subtipoActivoComboMediadorInforme',
										        	bind: {
									            		store: '{comboTipoActivo}',
									            		value: '{informeComercial.tipoActivoCodigo}'
									            	},
						    						listeners: {
									                	select: 'onChangeChainedCombo'
									            	}
									            	//,allowBlank: false
										        },
												{ 
													xtype: 'comboboxfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
										        	reference: 'subtipoActivoComboMediadorInforme',
										        	bind: {
									            		store: '{comboSubtipoActivo}',
									            		value: '{informeComercial.subtipoActivoCodigo}',
									            		disabled: '{!informeComercial.tipoActivoCodigo}'
									            	}
						    						//,allowBlank: false
										        },			       
												{ 
										        	xtype: 'comboboxfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
										        	name: 'estadoActivoCodigo',
										        	bind: {
									            		store: '{comboEstadoActivo}',
									            		value: '{informeComercial.estadoActivoCodigo}'
									            	}			
										        },
												// fila 1
												{							
													xtype: 'comboboxfieldbase',
													fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
										        	bind: {
									            		store: '{comboTipoVia}',
									            		value: '{informeComercial.tipoViaCodigo}'			            		
									            	}
						    						//,allowBlank: false
												},
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
								                	bind:		'{informeComercial.nombreVia}'
								                	//,allowBlank: false
								                },
								                { 
								                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
								                	bind:		'{informeComercial.numeroDomicilio}'
								                },
								                // fila 2
								                {
													fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
									                bind:		'{informeComercial.escalera}'
												},
						 						{ 
								                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
								                	bind:		'{informeComercial.piso}'
								                },
												{ 
								                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
								                	bind:		'{informeComercial.puerta}'
								                },
								                // fila 3
								                {
													fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
													bind:		'{informeComercial.codPostal}',
													vtype: 'codigoPostal',
													maskRe: /^\d*$/, 
								                	maxLength: 5
													//,allowBlank: false		                	
												},
								                {
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.municipio'),
													reference: 'municipioComboMediadorInforme',
													selectFirst: true,
									            	bind: {
									            		store: '{comboMunicipio}',
									            		value: '{informeComercial.municipioCodigo}',
									            		disabled: '{!informeComercial.provinciaCodigo}'
									            	},
						    						listeners: {
														select: 'onChangeChainedCombo'
						    						}
						    						//,allowBlank: false
												},
												{
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.provincia'),
													reference: 'provinciaComboMediadorInforme',
													chainedStore: 'comboMunicipio',
													chainedReference: 'municipioComboMediadorInforme',
									            	bind: {
									            		store: '{comboProvincia}',
									            	    value: '{informeComercial.provinciaCodigo}'
									            	},
						    						listeners: {
														select: 'onChangeChainedCombo'
						    						}
						    						//,allowBlank: false
												},
												// fila 4
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.latitud'),
													readOnly	: true,
													bind:		'{informeComercial.latitud}'
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.longitud'),
													readOnly	: true,
													bind:		'{informeComercial.longitud}'
								                }
										]
									},
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.ubicacion'),
										//readOnly: true,
										bind:		'{informeComercial.ubicacion}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.distrito'),
										//readOnly: true,
										bind:		'{informeComercial.distrito}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.zona'),
										//readOnly: true,
										bind:		'{informeComercial.zona}'
					                }

							]
						}
				]
			},

// Información General ---
			{    
  
				xtype:'fieldsettable',
				title:HreRem.i18n('title.informacion.general'),
				defaultType: 'textfieldbase',
				items :
					[
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.ubicacion'),
				        	bind: {
			            		store: '{comboTipoUbicacion}',
			            		value: '{informeComercial.ubicacionActivoCodigo}'
			            	},
			            	//readOnly: true,
			            	displayField: 'descripcion',
    						valueField: 'codigo'							
				        },
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.descripcion.comercial'),
					 		height: 	200,
					 		maxWidth:   550,
					 		rowspan:	5,
			            	bind:		'{informeComercial.descripcionComercial}',
							//readOnly: true,
					 		labelAlign: 'top'
						},
						{ 
							xtype: 		'textareafieldbase',
					 		fieldLabel: HreRem.i18n('fieldlabel.propuesta.activos.vinculados'),
					 		height: 	200,
					 		width: '100%',
					 		rowspan:	5,
			            	bind:		'{informeComercial.activosVinculados}',
							//readOnly: true,
					 		labelAlign: 'top'
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	editable: false,
				        	fieldLabel: HreRem.i18n('fieldlabel.estado.construccion'),
				        	bind: {
			            		store: '{comboEstadoConstruccion}',
			            		value: '{informeComercial.estadoConstruccionCodigo}',
			    				hidden: '{informeComercial.isSuelo}'
			            	},
			            	//readOnly: true,
			            	displayField: 'descripcion',
    						valueField: 'codigo'
				        },
		                { 
				        	xtype: 'comboboxfieldbase',
				        	editable: false,
				        	fieldLabel: HreRem.i18n('fieldlabel.estado.conservacion'),
				        	bind: {
			            		store: '{comboEstadoConservacion}',
			            		value: '{informeComercial.estadoConservacionCodigo}'
			            	},
			            	//readOnly: true,
			            	displayField: 'descripcion',
    						valueField: 'codigo'
				        },
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.anyo.construccion'),
		                	bind: {
		                		value: '{informeComercial.anyoConstruccion}',
			    				hidden: '{informeComercial.isSuelo}'
		                	},
		                	//readOnly: true,
		                	vtype: 'anyo',
							maskRe: /^\d*$/
							
		                },
		                { 
					 		fieldLabel: HreRem.i18n('fieldlabel.anyo.rehabilitacion'),
					 		bind: {
		                		value: '{informeComercial.anyoRehabilitacion}',
			    				hidden: '{informeComercial.isSuelo}'
		                	},
		                	//readOnly: true,
		                	vtype: 'anyo',
							maskRe: /^\d*$/							
						}
		                
					]
            },
            
			{    
  
				xtype:'fieldsettable',
				title:HreRem.i18n('title.valores.economicos'),
				defaultType: 'textfieldbase',
				layout: {
				    type: 'table',
					columns: 2
				},
				items :
					[
						{
							xtype: 'currencyfieldbase', 
							fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.venta'),
							width:		250,
							bind:		'{informeComercial.valorEstimadoVenta}',
							editable: true,
							renderer: function(value) {
   				        		return Ext.util.Format.currency(value);
   				        	}
							//,secRolesPermToEdit: ['']
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.justificacion.venta'),
							//readOnly: true,
							bind:		'{informeComercial.justificacionVenta}'
		                },
						{
							xtype: 'currencyfieldbase', 
							fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.alquiler'),
							width:		250,
							bind:		'{informeComercial.valorEstimadoRenta}',
							editable: true,
							renderer: function(value) {
   				        		return Ext.util.Format.currency(value);
   				        	}
							//,secRolesPermToEdit: ['']
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.justificacion.renta'),
							//readOnly: true,
							bind:		'{informeComercial.justificacionRenta}'
		                }
				]
			},
			
			{    
  
				xtype:'fieldsettable',
				title:HreRem.i18n('title.datos.comunidad'),
				defaultType: 'textfieldbase',
				items :
					[
						{
							xtype : 'comboboxfieldbase',
						    //allowBlank: false,
						    fieldLabel : HreRem.i18n('fieldlabel.comunidad.propietarios.constituida'),
						    bind : {
						      store : '{comboSiNoRem}',
						      value : '{informeComercial.inscritaComunidad}'
						    }
// TODO: Revisar si el cambio de este combo afecta a otros datos de comunidad
//						    ,
//							listeners: {
//						    	change: 'onComunidadNoConstituida'
//							}
						},
						{
							fieldLabel : HreRem.i18n('fieldlabel.cuota.orientativa'),
							bind : '{informeComercial.cuotaOrientativa}'
						},
						{
							fieldLabel : HreRem.i18n('fieldlabel.derrama.orientativa'),
							bind : '{informeComercial.derramaOrientativa}'
						},
						{
							fieldLabel : HreRem.i18n('fieldlabel.nombre.presidente'),							
							bind : '{informeComercial.nomPresidenteComunidad}',
							colspan: 2
						},
						{
							fieldLabel : HreRem.i18n('fieldlabel.telefono'),
							vtype: 'telefono',
							bind : '{informeComercial.telPresidenteComunidad}'
						},
						{
							fieldLabel : HreRem.i18n('fieldlabel.nombre.administrador'),
							bind : '{informeComercial.nomAdministradorComunidad}',
							colspan: 2
						}, 
						{
							fieldLabel : HreRem.i18n('fieldlabel.telefono'),
							vtype: 'telefono',
							bind : '{informeComercial.telAdministradorComunidad}'
						}
				]
			}

		];
        
        
    	me.setTitle(HreRem.i18n('title.informe.comercial.activo'));
   	 	me.callParent();    	
    	
    }, 
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
    	me.lookupController().cargarTabData(me);

//		Ext.Array.each(me.query('grid'), function(grid) {
//  			grid.getStore().load();
//  		});
    },
    actualizarCoordenadas: function(latitud, longitud) {
    	var me = this;
    	
    	me.getBindRecord().set("longitud", longitud);
    	me.getBindRecord().set("latitud", latitud);
    	
    }
});