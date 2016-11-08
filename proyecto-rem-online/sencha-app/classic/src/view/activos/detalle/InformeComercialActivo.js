Ext.define('HreRem.view.activos.detalle.InformeComercialActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'informecomercialactivo',
    reference: 'informecomercialactivoref',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    saveMultiple: true,
    refreshAfterSave: true,
    records: ['informeComercial','activoInforme'], 
    recordsClass: ['HreRem.model.ActivoInformeComercial','HreRem.model.Activo'],    
    requires: ['HreRem.model.Activo', 'HreRem.view.common.FieldSetTable', 'HreRem.model.ActivoInformeComercial', 'HreRem.model.Distribuciones',
    'HreRem.view.activos.detalle.InfoLocalComercial', 'HreRem.view.activos.detalle.InfoPlazaAparcamiento', 'HreRem.view.activos.detalle.InfoVivienda',
    'HreRem.view.activos.detalle.HistoricoEstadosInformeComercial', 'HreRem.model.InformeComercial', 'HreRem.view.activos.detalle.HistoricoMediadorGrid',
    'HreRem.view.activos.detalle.PropuestaActivosVinculadosList', 'HreRem.view.activos.detalle.InfoIndustrialYSuelo'],
    
    listeners: {
    	boxready: function() {
    		var me = this;
	    	me.lookupController().cargarTabData(me);
    	}
    },
    
    initComponent: function () {

        var me = this;
        
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
				        		hidden: '{informeComercial.nombreMediador}'
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
				        		hidden: '{informeComercial.nombreMediador}'
				        	}
						},
					// Fila 1
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.codigo'),
							bind: '{informeComercial.codigoMediador}',
							readOnly: true
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.nombre'),
							bind: '{informeComercial.nombreMediador}',
							readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.telefono'),
							bind: '{informeComercial.telefonoMediador}',
							readOnly: true
						},
					// Fila 2
						{
							fieldLabel: HreRem.i18n('fieldlabel.email'),
							bind: '{informeComercial.emailMediador}',
							readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.frecepcion.llaves'),
							bind: '{informeComercial.fechaRecepcionLlaves}',
							readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fultima.visita'),
							bind: '{informeComercial.fechaUltimaVisita}',
							colspan: 2,
							readOnly: true
						},
					// Fila 3
						{
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.autorizado.web'),
							bind: '{informeComercial.autorizacionWeb}',
							readOnly: true
						},
						{
							xtype: 'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fautorizacion.hasta'),
							bind: '{informeComercial.fechaAutorizacionHasta}',
							readOnly: true,
							colspan: 2
						},
					// Fila 4
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('title.grid.historico.mediador.info.comercial'),
							defaultType: 'textfieldbase',
							colspan: 3,
							items :
								[
									{xtype: "historicomediadorgrid", reference: "historicomediadorgrid", colspan: 3}
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
						            		value: '{informeComercial.tipoActivoCodigo}'
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
						            		value: '{informeComercial.subtipoActivoCodigo}',
						            		disabled: '{!informeComercial.tipoActivoCodigo}'
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
						            		value: '{informeComercial.tipoViaCodigo}'			            		
						            	}
									},
									{ 
										fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
										reference: 'nombreViaMediadorInforme',
					                	bind:		'{informeComercial.nombreVia}'
					                },
					                { 
					                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
					                	reference: 'numeroMediadorInforme',
					                	bind:		'{informeComercial.numeroVia}'
					                },
					            // Fila 2
					                {
										fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
										reference: 'escaleraMediadorInforme',
						                bind:		'{informeComercial.escalera}'
									},
			 						{ 
					                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
					                	reference: 'plantaMediadorInforme',
					                	bind:		'{informeComercial.planta}'
					                },
									{ 
					                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
					                	reference: 'puertaMediadorInforme',
					                	bind:		'{informeComercial.puerta}'
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
						            	    value: '{informeComercial.provinciaCodigo}'
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
						            		value: '{informeComercial.municipioCodigo}',
						            		disabled: '{!informeComercial.provinciaCodigo}'
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
									        value: '{informeComercial.inferiorMunicipioCodigo}',
									        disabled: '{!informeComercial.municipioCodigo}'
									    }
									},
								// Fila 4
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
										reference: 'codPostalMediadorInforme',
										bind:		'{informeComercial.codigoPostal}',
										vtype: 'codigoPostal',
										maskRe: /^\d*$/, 
					                	maxLength: 5	                	
									},
									{
										xtype: 'comboboxfieldbase',
							        	fieldLabel: HreRem.i18n('fieldlabel.ubicacion'),
							        	bind: {
						            		store: '{comboTipoUbicacion}',
						            		value: '{informeComercial.ubicacionActivoCodigo}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.distrito'),
										reference: 'fieldlabelDistrito',
										bind: '{informeComercial.distrito}'
					                },
					            // Fila 5
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.zona'),
										bind:		'{informeComercial.zona}'
					                },
					                { 
										fieldLabel: HreRem.i18n('fieldlabel.latitud'),
										reference: 'latitudmediador',
										readOnly	: true,
										bind:		'{informeComercial.latitud}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.longitud'),
										reference: 'longitudmediador',
										readOnly	: true,
										bind:		'{informeComercial.longitud}'
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
										bind:		'{informeComercial.valorEstimadoVenta}',
										editable: true,
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										xtype: 'textareafieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.justificacion.venta'),
										bind:		'{informeComercial.justificacionVenta}',
										margin: '0 0 26 0',
										rowspan: 2,
										width: 600,
										maxWidth: 600
					                },
					                {
					                	xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.venta.fecha'),
										bind: '{informeComercial.fechaEstimacionVenta}',
							            margin: '0 0 26 0',
							            width: 280
					                },
					                // Alquiler
									{
										xtype: 'currencyfieldbase', 
										fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.alquiler'),
										width:		280,
										bind:		'{informeComercial.valorEstimadoRenta}',
										editable: true,
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										xtype: 'textareafieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.justificacion.renta'),
										bind:		'{informeComercial.justificacionRenta}',
										rowspan: 2,
										width: 600,
										maxWidth: 600
					                },
					                {
					                	xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.valor.estimado.venta.fecha'),
										bind: '{informeComercial.fechaEstimacionRenta}',
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
						{ // Primer cuadro.
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsible: false,
							border: false,
							height: 230,
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
										fieldLabel: HreRem.i18n('fieldlabel.estado.conservacion'),
										bind: {
											store: '{comboEstadoConservacion}',
											value: '{informeComercial.estadoConservacionCodigo}'
										},
										displayField: 'descripcion',
										valueField: 'codigo'
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
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
							        },
									{
										fieldLabel: HreRem.i18n('fieldlabel.anyo.construccion'),
										bind: {
											value: '{informeComercial.anyoConstruccion}',
											hidden: '{informeComercial.isSuelo}'
										},
										listeners: {
											change: 'onAnyoChange'
										},
										maskRe: /^\d*$/,
										vtype: 'anyo'
									},
									{
								 		fieldLabel: HreRem.i18n('fieldlabel.anyo.rehabilitacion'),
								 		bind: {
					                		value: '{informeComercial.anyoRehabilitacion}',
						    				hidden: '{informeComercial.isSuelo}'
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
											value: '{informeComercial.numPlantas}'
										}
									},
									{
										xtype : 'comboboxfieldbase',
									    fieldLabel : HreRem.i18n('fieldlabel.ascensor'),
									    bind : {
									      store : '{comboSiNoRem}',
									      value : '{informeComercial.ascensor}'
									    }
									},
									{
										xtype: 'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.numero.ascensores'),
										maxLength:	2,
										bind: {
											value: '{informeComercial.numAscensores}'
										}
									}
								]
						},
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.descripcion.comercial'),
					 		height: 	230,
					 		maxLength:	500,
			            	bind:		'{informeComercial.descripcionComercial}',
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
										bind: '{informeComercial.reformaFachada}'
									},
									{
										xtype: 'checkboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.escalera'),
										bind: '{informeComercial.reformaEscalera}'
									},
									{
										xtype: 'checkboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.portal'),
										bind: '{informeComercial.reformaPortal}'
									},
									{
										xtype: 'checkboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.ascensor'),
										bind: '{informeComercial.reformaAscensor}'
									},
									{
										xtype: 'checkboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.cubierta'),
										bind: '{informeComercial.reformaCubierta}'
									},
									{
										xtype: 'checkboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.otras.zonas'),
										bind: '{informeComercial.reformaOtrasZonasComunes}'
									},
									{
										xtype: 'textareafieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.otros'),
										bind: '{informeComercial.reformaOtroDescEdificio}',
										colspan: 2,
										maxLength: 250,
										labelAlign: 'top'
									}
								]
						},
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.entorno.comunicaciones'),
							height: 	285,
							maxLength:	500,
			            	bind:		'{informeComercial.entornoComunicaciones}',
					 		labelAlign: 'top'
						},
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.entorno.infraestructuras'),
							height: 	285,
							maxLength:	500,
			            	bind:		'{informeComercial.entornoInfraestructuras}',
					 		labelAlign: 'top'
						},
						{
							xtype: "propuestaActivosVinculadosList", reference: "propuestaActivosVinculadosList"
						},
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.descripcion.edificio'),
							height: 	230,
							maxLength:	500,
			            	bind:		'{informeComercial.ediDescripcion}',
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
									      value : '{informeComercial.inscritaComunidad}'
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
										bind : '{informeComercial.cuotaOrientativaComunidad}'
									},
									{
										xtype: 'numberfieldbase',
										maxLength: 17,
										decimalPrecision: 2,
										renderer: Ext.util.Format.numberRenderer('0,000.00'),
										fieldLabel : HreRem.i18n('fieldlabel.derrama.orientativa'),
										bind : '{informeComercial.derramaOrientativaComunidad}'
									},
									{
										fieldLabel : HreRem.i18n('fieldlabel.nombre.presidente'),							
										bind : '{informeComercial.nomPresidenteComunidad}'
									},
									{
										fieldLabel : HreRem.i18n('fieldlabel.telefono'),
										vtype: 'telefono',
										bind : '{informeComercial.telPresidenteComunidad}',
										colspan: 2
									},
									{
										fieldLabel : HreRem.i18n('fieldlabel.nombre.administrador'),
										bind : '{informeComercial.nomAdministradorComunidad}'
									}, 
									{
										fieldLabel : HreRem.i18n('fieldlabel.telefono'),
										vtype: 'telefono',
										bind : '{informeComercial.telAdministradorComunidad}',
										colspan: 2
									}
							]
						},
				]
            },

// Añadir sección por tipo de activo
			{
				xtype: 'infovivienda',
				bind: {
					hidden: '{!informeComercial.isViviendaMediador}'
				}
			},
			{
				xtype:'infoplazaaparcamiento',
				title: HreRem.i18n('title.plaza.aparcamiento'),
				bind: {
					hidden: '{!informeComercial.isPlazaAparcamientoMediador}'
				}
			},
			{
				xtype:'infolocalcomercial',
				title: HreRem.i18n('title.local.comercial'),
				bind: {
					hidden: '{!informeComercial.isLocalComercialMediador}'
				}
			},
			{
				xtype: 'infoindustrialysuelo',
				title: HreRem.i18n('title.industrial'),
				bind: {
					hidden: '{!informeComercial.isIndustrialMediador}'
				}
			},
			{
				xtype: 'infoindustrialysuelo',
				title: HreRem.i18n('title.suelo'),
				bind: {
					hidden: '{!informeComercial.isSueloMediador}'
				}
			}
		];
        
    	me.setTitle(HreRem.i18n('title.informe.comercial.activo'));
   	 	me.callParent();
    }, 
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
    	me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
		});
    },
    
    actualizarCoordenadas: function(latitud, longitud) {
    	var me = this;

    	me.up('activosdetallemain').lookupReference('latitudmediador').setValue(latitud);
    	me.up('activosdetallemain').lookupReference('longitudmediador').setValue(longitud);
    }
});