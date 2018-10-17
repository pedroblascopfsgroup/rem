Ext.define('HreRem.view.activos.detalle.InformeComercialActivo', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'informecomercialactivo',
    reference	: 'informecomercialactivoref',
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    saveMultiple: true,
    refreshAfterSave: true,
    records		: ['infoComercial','activoInforme'], 
    recordsClass: ['HreRem.model.ActivoInformeComercial','HreRem.model.Activo'],    
    requires	: ['HreRem.model.Activo', 'HreRem.view.common.FieldSetTable', 'HreRem.model.ActivoInformeComercial', 'HreRem.model.Distribuciones',
    'HreRem.view.activos.detalle.InfoLocalComercial', 'HreRem.view.activos.detalle.InfoPlazaAparcamiento', 'HreRem.view.activos.detalle.InfoVivienda',
    'HreRem.view.activos.detalle.HistoricoEstadosInformeComercial', 'HreRem.model.InformeComercial', 'HreRem.view.activos.detalle.HistoricoMediadorGrid',
    'HreRem.view.activos.detalle.PropuestaActivosVinculadosList', 'HreRem.view.activos.detalle.InfoIndustrialYSuelo','HreRem.view.activos.detalle.InfoEdificioCompleto',
    'HreRem.view.activos.detalle.InfoVarios','HreRem.view.activos.detalle.DistribucionPlantasActivoList'],
    
    listeners: {
    	boxready: function() { // Anyadir seccion por tipo de activo.
    		var me = this;
			
    		this.cargarDatosSegunTipoActivoDelMediador(me,me.lookupViewModel().get('activo.tipoActivoMediadorCodigo'));

	    	me.lookupController().cargarTabData(me);
    	}
    },

    initComponent: function () {
        var me = this;
        
		var editaPosibleInforme = !(($AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYASUPPUBL'])));
		
		var isCarteraLiberbank = me.lookupViewModel().get('activo.isCarteraLiberbank');
		
		var tienePosibleInformeMediador = me.lookupViewModel().get('activo.tienePosibleInformeMediador');
		
        me.setTitle(HreRem.i18n('title.informe.comercial.activo'));

        me.items = [
// Mediador
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.mediador'),
				defaultType: 'textfieldbase',
				items :
					[
					// Fila 0
						{
							// Label vacia para desplazar la línea por cuestión de estética.
							xtype: 'label',
							bind: {
				        		hidden: '{infoComercial.nombreMediador}'
				        	}
						},
						{
				        	xtype: 'label',
				        	cls:'x-form-item',
				        	text: HreRem.i18n('fieldlabel.mediador.notFound'),
				        	style: 'font-size: small;text-align: center;font-weight: bold;color: #DF7401;',
				        	colspan: 2,
				        	readOnly: true,
				        	reference: 'mediadorNotFoundLabel',
				        	bind: {
				        		hidden: '{infoComercial.nombreMediador}'
				        	}
						},
					// Fila 1
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.codigo'),
							bind: '{infoComercial.codigoMediador}',
							readOnly: true
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.nombre'),
							bind: '{infoComercial.nombreMediador}',
							readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.telefono'),
							bind: '{infoComercial.telefonoMediador}',
							readOnly: true
						},
					// Fila 2
						{
							fieldLabel: HreRem.i18n('fieldlabel.email'),
							bind: '{infoComercial.emailMediador}',
							readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.frecepcion.llaves'),
							bind: '{infoComercial.fechaRecepcionLlaves}',
							readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fultima.visita'),
							bind: '{infoComercial.fechaUltimaVisita}',
							colspan: 2,
							readOnly: true
						},
					// Fila 3
						{
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.autorizado.web'),
							bind: '{infoComercial.autorizacionWeb}',
							readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fautorizacion.hasta'),
							bind: '{infoComercial.fechaAutorizacionHasta}',
							readOnly: true,
							colspan: 2
						},
					// Fila 4
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.codigo.proveedor'),
							readOnly: true,
							bind: {
				        		disabled: '{!infoComercial.tieneProveedorTecnico}',
				        		value: '{infoComercial.codigoProveedor}'
				        	}					
							
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.nombre.proveedor'),
							readOnly: true,
							colspan: 2,
							bind: {
				        		disabled: '{!infoComercial.tieneProveedorTecnico}',
				        		value: '{infoComercial.nombreProveedor}'
				        	}
						},
					// Fila 5
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('title.grid.historico.mediador.info.comercial'),
							defaultType: 'textfieldbase',
							colspan: 3,
							items :
								[
									{
										xtype: "historicomediadorgrid", 
										secFunToEdit: 'EDITAR_GRID_PUBLICACION_HISTORICO_MEDIADORES',
										reference: "historicomediadorgrid", 
										colspan: 3
									}
								]
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
						{xtype: "historicoestadosinformecomercial", reference: "historicoestadosinformecomercial"}
					]
			},

// Datos Básicos
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.datos.basicos'),
				defaultType: 'textfieldbase',
				items :
					[
			         // Datos admisión
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title:HreRem.i18n('title.datos.admision'),
							colspan: 3,
							items :	[
								// Fila 0
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
							        },
									{ 
										xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
							        	reference: 'subtipoActivoComboAdmisionInforme',
							        	bind: {
						            		store: '{comboSubtipoActivoAdmisionIC}',
						            		value: '{activoInforme.subtipoActivoCodigo}',
						            		disabled: '{!activoInforme.tipoActivoCodigo}'
						            	},
						            	colspan: 2
							        },
								// Fila 1
									{							
										xtype: 'comboboxfieldbase',
										fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
										reference: 'tipoViaAdmisionInforme',
							        	bind: {
						            		store: '{comboTipoVia}',
						            		value: '{activoInforme.tipoViaCodigo}'			            		
						            	}
									},
									{ 
										fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
										reference: 'nombreViaAdmisionInforme',
					                	bind:		'{activoInforme.nombreVia}'
					                },
					                { 
					                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
					                	reference: 'numeroAdmisionInforme',
					                	bind:		'{activoInforme.numeroDomicilio}'
					                },
					            // Fila 2
					                {
										fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
										reference: 'escaleraAdmisionInforme',
						                bind:		'{activoInforme.escalera}'
									},
			 						{ 
					                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
					                	reference: 'plantaAdmisionInforme',
					                	bind:		'{activoInforme.piso}'
					                },
									{ 
					                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
					                	reference: 'puertaAdmisionInforme',
					                	bind:		'{activoInforme.puerta}'
					                },
					            // Fila 3
									{
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.provincia'),
										reference: 'provinciaComboAdmisionInforme',
										chainedStore: 'comboMunicipioAdmisionIC',
										chainedReference: 'municipioComboAdmisionInforme',
						            	bind: {
						            		store: '{comboProvincia}',
						            	    value: '{activoInforme.provinciaCodigo}'
						            	},
			    						listeners: {
											select: 'onChangeChainedCombo'
			    						}
									},
					                {
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
										chainedStore: 'comboInferiorMunicipioAdmisionIC',
										chainedReference: 'poblacionalAdmisionInforme',
										reference: 'municipioComboAdmisionInforme',													
						            	bind: {
						            		store: '{comboMunicipioAdmisionIC}',
						            		value: '{activoInforme.municipioCodigo}',
						            		disabled: '{!activoInforme.provinciaCodigo}'
						            	},
			    						listeners: {
											select: 'onChangeChainedCombo'
			    						}
									},
									{
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.unidad.poblacional'),
										reference: 'poblacionalAdmisionInforme',													
									    bind: {
									    	store: '{comboInferiorMunicipioAdmisionIC}',
									        value: '{activoInforme.inferiorMunicipioCodigo}',
									        disabled: '{!activoInforme.municipioCodigo}'
									    }
									},
								// Fila 4
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
										reference: 'codPostalAdmisionInforme',
										bind:		'{activoInforme.codPostal}',
										vtype: 'codigoPostal',
										maskRe: /^\d*$/, 
					                	maxLength: 5
									},
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.latitud'),
										reference: 'latitudAdmisionInforme',
										readOnly	: true,
										bind:		'{activoInforme.latitud}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.longitud'),
										reference: 'longitudAdmisionInforme',
										readOnly	: true,
										bind:		'{activoInforme.longitud}'
					                },
					            // Fila 5
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
					                	handler: 'onClickCopiarDatosDelMediador'
					                }
							]               
			          	},
						// Informe Mediador
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('title.informe.mediador'),
							defaultType: 'textfieldbase',
							hidden: !isCarteraLiberbank,
							colspan: 3,
							items :
								[
									{ 
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.posible.informe'),
										reference: 'comboPosibleInforme',
										readOnly: editaPosibleInforme,
							        	bind: {
						            		store: '{comboSiNoRem}',
						            		value: '{infoComercial.posibleInforme}'
						            	},
			    						listeners: {
						                	select: function(){
						                		var posible = this.getValue();
						                		if (posible == "0"){
						                			Ext.getCmp('noPosibleInformeTextArea').show();
						                		} else {
						                			Ext.getCmp('noPosibleInformeTextArea').hidden = false;
						                			Ext.getCmp('noPosibleInformeTextArea').hide();
						                		}
						                	}
						            	}
							        },
									{
										xtype: 'textareafieldbase',
										reference: 'noPosibleInformeTextArea',
										fieldLabel: HreRem.i18n('fieldlabel.motivo.no.posible.informe'),
										hidden: tienePosibleInformeMediador,
										bind:		'{infoComercial.motivoNoPosibleInforme}',
										readOnly: editaPosibleInforme,
										margin: '0 0 26 0',
										rowspan: 2,
										width: 600,
										maxWidth: 600
					                }
							]
						},
			         // Datos Mediador
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('title.datos.mediador'),
							defaultType: 'textfieldbase',
							colspan: 3,
							items :
								[
								// Fila 0
									{ 
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
										reference: 'tipoActivoMediadorInforme',
							        	chainedStore: 'comboSubtipoActivo',
										chainedReference: 'subtipoActivoComboMediadorInforme',
							        	bind: {
						            		store: '{comboTipoActivo}',
						            		value: '{infoComercial.tipoActivoCodigo}'
						            	},
			    						listeners: {
						                	select: 'onChangeChainedCombo'
						            	}
							        },
									{ 
										xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
							        	reference: 'subtipoActivoComboMediadorInforme',
							        	bind: {
						            		store: '{comboSubtipoActivoMediadorIC}',
						            		value: '{infoComercial.subtipoActivoCodigo}',
						            		disabled: '{!infoComercial.tipoActivoCodigo}'
						            	},
						            	colspan: 2
							        },
								// Fila 1
									{							
										xtype: 'comboboxfieldbase',
										fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
										reference: 'tipoViaMediadorInforme',
							        	bind: {
						            		store: '{comboTipoVia}',
						            		value: '{infoComercial.tipoViaCodigo}'			            		
						            	}
									},
									{ 
										fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
										reference: 'nombreViaMediadorInforme',
					                	bind:		'{infoComercial.nombreVia}'
					                },
					                { 
					                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
					                	reference: 'numeroMediadorInforme',
					                	bind:		'{infoComercial.numeroVia}'
					                },
					            // Fila 2
					                {
										fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
										reference: 'escaleraMediadorInforme',
						                bind:		'{infoComercial.escalera}'
									},
			 						{ 
					                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
					                	reference: 'plantaMediadorInforme',
					                	bind:		'{infoComercial.planta}'
					                },
									{ 
					                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
					                	reference: 'puertaMediadorInforme',
					                	bind:		'{infoComercial.puerta}'
					                },
					            // Fila 3
					                {
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.provincia'),
										reference: 'provinciaComboMediadorInforme',
										chainedStore: 'comboMunicipioMediadorIC',
										chainedReference: 'municipioComboMediadorInforme',
						            	bind: {
						            		store: '{comboProvincia}',
						            	    value: '{infoComercial.provinciaCodigo}'
						            	},
			    						listeners: {
											select: 'onChangeChainedCombo'
			    						}
									},
					                {
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
										reference: 'municipioComboMediadorInforme',
										chainedStore: 'comboInferiorMunicipioMediadorIC',
										chainedReference: 'poblacionalMediadorInforme',
						            	bind: {
						            		store: '{comboMunicipioMediadorIC}',
						            		value: '{infoComercial.municipioCodigo}',
						            		disabled: '{!infoComercial.provinciaCodigo}'
						            	},
						            	listeners: {
						            		select: 'onChangeChainedCombo',
						            		change: 'checkDistrito'
						                }
									},
									{
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.unidad.poblacional'),
										reference: 'poblacionalMediadorInforme',													
									    bind: {
									    	store: '{comboInferiorMunicipioMediadorIC}',
									        value: '{infoComercial.inferiorMunicipioCodigo}',
									        disabled: '{!infoComercial.municipioCodigo}'
									    }
									},
								// Fila 4
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
										reference: 'codPostalMediadorInforme',
										bind:		'{infoComercial.codigoPostal}',
										vtype: 'codigoPostal',
										maskRe: /^\d*$/, 
					                	maxLength: 5	                	
									},
									{
										xtype: 'comboboxfieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.ubicacion'),
							        	bind: {
						            		store: '{comboTipoUbicacion}',
						            		value: '{infoComercial.ubicacionActivoCodigo}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.distrito'),
										reference: 'fieldlabelDistrito',
										bind: '{infoComercial.distrito}'
					                },
					            // Fila 5
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.zona'),
										bind:		'{infoComercial.zona}'
					                },
					                { 
										fieldLabel: HreRem.i18n('fieldlabel.latitud'),
										reference: 'latitudmediador',
										readOnly	: true,
										bind:		'{infoComercial.latitud}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.longitud'),
										reference: 'longitudmediador',
										readOnly	: true,
										bind:		'{infoComercial.longitud}'
					                },
					            // Fila 6
					                {
										// Label vacía para generar un espacio por cuestión de estética.
										xtype: 'label',
										colspan: 2
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
					                }
							]
						},

					// Valores Económicos
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
								 	// Venta
									{
										xtype: 'currencyfieldbase', 
										fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.venta'),
										width:		280,
										bind:		'{infoComercial.valorEstimadoVenta}',
										editable: true,
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										xtype: 'textareafieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.justificacion.venta'),
										bind:		'{infoComercial.justificacionVenta}',
										margin: '0 0 26 0',
										rowspan: 2,
										width: 600,
										maxWidth: 600
					                },
					                {
					                	xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.venta.fecha'),
										bind: '{infoComercial.fechaEstimacionVenta}',
							            margin: '0 0 26 0',
							            width: 280
					                },
					                // Alquiler
									{
										xtype: 'currencyfieldbase', 
										fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.alquiler'),
										width:		280,
										bind:		'{infoComercial.valorEstimadoRenta}',
										editable: true,
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										xtype: 'textareafieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.justificacion.renta'),
										bind:		'{infoComercial.justificacionRenta}',
										rowspan: 2,
										width: 600,
										maxWidth: 600
					                },
					                {
					                	xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.venta.fecha'),
										bind: '{infoComercial.fechaEstimacionRenta}',
							            width: 280
					                }
							]
						}
				]
			},
// Información General
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.informacion.general'),
				defaultType: 'textfieldbase',
				items :
					[
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsible: false,
							colspan: 3,
							border: false,
							layout: {
				                type: 'hbox'
				            },
							items :[
								{ // Primer cuadro.
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',
									collapsible: false,
									border: false,
									layout: {
										type: 'table',
										columns: 1
									},
									padding: '0 0 0 0',
									items :
										[
											{ 
												xtype: 'comboboxfieldbase',
												editable: false,
												fieldLabel: HreRem.i18n('fieldlabel.estado.conservacion.activo'),
												bind: {
													store: '{comboEstadoConservacion}',
													value: '{infoComercial.estadoConservacionCodigo}'
												},
												displayField: 'descripcion',
												valueField: 'codigo'
											},
											{ 
									        	xtype: 'comboboxfieldbase',
									        	editable: false,
									        	fieldLabel: HreRem.i18n('fieldlabel.estado.construccion.activo'),
									        	bind: {
								            		store: '{comboEstadoConstruccion}',
								            		value: '{infoComercial.estadoConstruccionCodigo}',
								    				hidden: '{infoComercial.isSuelo}'
								            	},
								            	displayField: 'descripcion',
					    						valueField: 'codigo'
									        },
											{
												fieldLabel: HreRem.i18n('fieldlabel.anyo.construccion.activo'),
												bind: {
													value: '{infoComercial.anyoConstruccion}',
													hidden: '{infoComercial.isSuelo}'
												},
												listeners: {
													change: 'onAnyoChange'
												},
												maskRe: /^\d*$/,
												vtype: 'anyo'
											},
											{
										 		fieldLabel: HreRem.i18n('fieldlabel.anyo.rehabilitacion.activo'),
										 		bind: {
							                		value: '{infoComercial.anyoRehabilitacion}',
								    				hidden: '{infoComercial.isSuelo}'
							                	},
							                	listeners: {
													change: 'onAnyoChange'
												},
												maskRe: /^\d*$/,
												vtype: 'anyo'
											},
											{ 
												xtype: 'comboboxfieldbase',
												editable: false,
												fieldLabel: HreRem.i18n('fieldlabel.estado.conservacion.edificio'),
												bind: {
													store: '{comboEstadoConservacion}',
													value: '{infoComercial.estadoConservacionEdificioCodigo}'
												}
											},
											{
										 		fieldLabel: HreRem.i18n('fieldlabel.anyo.rehabilitacion.edificio'),
										 		bind: {
							                		value: '{infoComercial.anyoRehabilitacionEdificio}',
								    				hidden: '{infoComercial.isSuelo}'
							                	},
							                	listeners: {
													change: 'onAnyoChange'
												},
												maskRe: /^\d*$/,
												vtype: 'anyo'
											},
											{
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.numero.plantas'),
												maxLength:	3,
												bind: {
													value: '{infoComercial.numPlantas}'
												}
											},
											{
												xtype : 'comboboxfieldbase',
											    fieldLabel : HreRem.i18n('fieldlabel.ascensor'),
											    bind : {
											      store : '{comboSiNoRem}',
											      value : '{infoComercial.ascensor}'
											    }
											},
											{
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.numero.ascensores'),
												maxLength:	2,
												bind: {
													value: '{infoComercial.numAscensores}'
												}
											}
										]
								},
								{
						        	xtype: 		'textareafieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.descripcion.comercial'),
							 		height: 	230,
							 		maxLength:	500,
					            	bind:		'{infoComercial.descripcionComercial}',
							 		labelAlign: 'top'
								},
								{ // Checkboxes reformas necesarias.
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',
									title:HreRem.i18n('title.reformas.necesarias'),
									collapsible: false,
									height: 230,
									border: true,
									layout: {
										type: 'table',
										columns: 2
									},
									padding: '0 0 0 15',
									items :
										[
											{
												xtype: 'checkboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.fachada'),
												bind: '{infoComercial.reformaFachada}'
											},
											{
												xtype: 'checkboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.escalera'),
												bind: '{infoComercial.reformaEscalera}'
											},
											{
												xtype: 'checkboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.portal'),
												bind: '{infoComercial.reformaPortal}'
											},
											{
												xtype: 'checkboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.ascensor'),
												bind: '{infoComercial.reformaAscensor}'
											},
											{
												xtype: 'checkboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.cubierta'),
												bind: '{infoComercial.reformaCubierta}'
											},
											{
												xtype: 'checkboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.otras.zonas'),
												bind: '{infoComercial.reformaOtrasZonasComunes}'
											},
											{
												xtype: 'textareafieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.otros'),
												bind: '{infoComercial.reformaOtroDescEdificio}',
												colspan: 2,
												maxLength: 250,
												labelAlign: 'top'
											}
										]
								}
							]
						},
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.entorno.comunicaciones'),
							height: 	285,
							maxLength:	500,
			            	bind:		'{infoComercial.entornoComunicaciones}',
					 		labelAlign: 'top'
						},
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.entorno.infraestructuras'),
							height: 	285,
							maxLength:	500,
			            	bind:		'{infoComercial.entornoInfraestructuras}',
					 		labelAlign: 'top'
						},
						{
							xtype: "propuestaActivosVinculadosList", reference: "propuestaActivosVinculadosList"
						},
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.descripcion.edificio'),
							height: 	230,
							maxLength:	3000,
			            	bind:		'{infoComercial.ediDescripcion}',
					 		labelAlign: 'top'
						},

					// Datos de la Comunidad
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('title.datos.comunidad'),
							defaultType: 'textfieldbase',
							colspan: 2,
							collapsible: false,
							height: 	230,
							items :	[
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.comunidad.propietarios.constituida'),
									    bind : {
									      store : '{comboSiNoRem}',
									      value : '{infoComercial.inscritaComunidad}'
									    }
										// TODO: Revisar si el cambio de este combo afecta a otros datos de comunidad y rehabilitarlo si es el caso.
//									    ,
//										listeners: {
//									    	change: 'onComunidadNoConstituida'
//										}
									},
									{
										xtype: 'numberfieldbase',
										maxLength: 9,
										decimalPrecision: 2,
										renderer: Ext.util.Format.numberRenderer('0,000.00'),
										fieldLabel : HreRem.i18n('fieldlabel.cuota.orientativa'),
										bind : '{infoComercial.cuotaOrientativaComunidad}'
									},
									{
										xtype: 'numberfieldbase',
										maxLength: 17,
										decimalPrecision: 2,
										renderer: Ext.util.Format.numberRenderer('0,000.00'),
										fieldLabel : HreRem.i18n('fieldlabel.derrama.orientativa'),
										bind : '{infoComercial.derramaOrientativaComunidad}'
									},
									{
										fieldLabel : HreRem.i18n('fieldlabel.nombre.presidente'),							
										bind : '{infoComercial.nomPresidenteComunidad}'
									},
									{
										fieldLabel : HreRem.i18n('fieldlabel.telefono'),
										vtype: 'telefono',
										bind : '{infoComercial.telPresidenteComunidad}',
										colspan: 2
									},
									{
										fieldLabel : HreRem.i18n('fieldlabel.nombre.administrador'),
										bind : '{infoComercial.nomAdministradorComunidad}'
									}, 
									{
										fieldLabel : HreRem.i18n('fieldlabel.telefono'),
										vtype: 'telefono',
										bind : '{infoComercial.telAdministradorComunidad}',
										colspan: 2
									}
							]
						}
				]
            }
		];

   	 	me.callParent();
   	 	
    }, 

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		
		var codigoTipoActivoMediador = me.lookupController().lookupReference('tipoActivoMediadorInforme').getValue();
		//Necesario en caso de que cambien el tipo de activo en Mediador.
		var nuevoContainer = me.borrarContainerTipoActivoMediador(me, codigoTipoActivoMediador);
		
		me.lookupController().cargarTabData(me);

		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
		});
		
		if(nuevoContainer)
			me.cargarDatosSegunTipoActivoDelMediador(me, codigoTipoActivoMediador);
    },

    actualizarCoordenadas: function(latitud, longitud) {
    	var me = this;

    	me.up('activosdetallemain').lookupReference('latitudmediador').setValue(latitud);
    	me.up('activosdetallemain').lookupReference('longitudmediador').setValue(longitud);
    },
    
    cargarDatosSegunTipoActivoDelMediador: function(me, codigoTipoActivoMediador) {
    	
    	if(codigoTipoActivoMediador == CONST.TIPOS_ACTIVO['SUELO']) {
	     	me.add({    
				xtype:'infoindustrialysuelo',
				title: HreRem.i18n('title.suelo')
        	});
		}
    	if(codigoTipoActivoMediador == CONST.TIPOS_ACTIVO['VIVIENDA']) {
	     	me.add({    
				xtype:'infovivienda'
        	});
		}
		if(codigoTipoActivoMediador == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']) {
	     	me.add({                    
				xtype:'infolocalcomercial'
	        });
		}
		if(codigoTipoActivoMediador == CONST.TIPOS_ACTIVO['INDUSTRIAL']) {
	     	me.add({    
				xtype:'infoindustrialysuelo',
				title: HreRem.i18n('title.industrial')
        	});
		}
    	if(codigoTipoActivoMediador == CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO']) {
		     me.add({    
	        	xtype: 'infoedificiocompleto'
	        });	 
    	}
    	if(codigoTipoActivoMediador == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']) {
	     	me.add({    
	     		xtype:'infoindustrialysuelo',
				title: HreRem.i18n('title.suelo')
        	});
		}
    	if(codigoTipoActivoMediador == CONST.TIPOS_ACTIVO['OTROS']) {
	     	me.add({    
				xtype:'infovarios'
        	});
		}
    	
    },
    
    borrarContainerTipoActivoMediador: function(me, codigoTipoActivoMediador) {
    	for(var i=0 ; i < me.items.items.length ; i++) {
    		var xtipo = me.items.getAt(i).getXType();
    		
    		if((xtipo == 'infovivienda' && codigoTipoActivoMediador != CONST.TIPOS_ACTIVO['VIVIENDA'])
    			|| (xtipo == 'infolocalcomercial'  && codigoTipoActivoMediador != CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'])
    			|| (xtipo == 'infoedificiocompleto'  && codigoTipoActivoMediador != CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO'])
    			|| (xtipo == 'infoindustrialysuelo'  && (codigoTipoActivoMediador != CONST.TIPOS_ACTIVO['SUELO'] && codigoTipoActivoMediador != CONST.TIPOS_ACTIVO['INDUSTRIAL'] && codigoTipoActivoMediador != CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']) )
    			|| (xtipo == 'infovarios' && codigoTipoActivoMediador != CONST.TIPOS_ACTIVO['OTROS']))
    		{
    			me.remove(me.items.getAt(i));
    			return true;
    		}
    	}
    	
    	return false;
    }
});