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
    recordsClass: ['HreRem.model.ActivoInformacionComercial','HreRem.model.Activo'],    
    requires	: ['HreRem.model.Activo', 'HreRem.view.common.FieldSetTable', 'HreRem.model.ActivoInformacionComercial', 'HreRem.model.Distribuciones',
    'HreRem.view.activos.detalle.InfoLocalComercial', 'HreRem.view.activos.detalle.InfoPlazaAparcamiento', 'HreRem.view.activos.detalle.InfoVivienda',
    'HreRem.view.activos.detalle.HistoricoEstadosInformeComercial', 'HreRem.model.InformeComercial', 'HreRem.view.activos.detalle.HistoricoMediadorGrid',
    'HreRem.view.activos.detalle.PropuestaActivosVinculadosList', 'HreRem.view.activos.detalle.InfoIndustrialYSuelo','HreRem.view.activos.detalle.InfoEdificioCompleto',
    'HreRem.view.activos.detalle.InfoVarios','HreRem.view.activos.detalle.DistribucionPlantasActivoList', 'HreRem.view.activos.detalle.TestigosOpcionalesGrid'],
    
    listeners: {
    	boxready: function() {
    		var me = this;
			
	    	me.lookupController().cargarTabData(me);
    	}
    },

    initComponent: function () {
        var me = this;
        
		var editaPosibleInforme = !(($AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_PRECIOS']) || $AU.userIsRol(CONST.PERFILES['HAYAGESTPREC']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPPUBL'])));
		
		var isCarteraLiberbank = me.lookupViewModel().get('activo.isCarteraLiberbank');
		
		var tienePosibleInformeMediador = me.lookupViewModel().get('activo.tienePosibleInformeMediador');
		
		var esUA = me.lookupViewModel().get('activo.unidadAlquilable');
		
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
							xtype:'fieldsettable',
							title: HreRem.i18n('titulo.grid.mediador.primario'),
							defaultType: 'textfieldbase',
							colspan: 3,
							items :
								[
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
						        	colspan: 3,
						        	readOnly: true,
						        	reference: 'mediadorNotFoundLabel',
						        	bind: {
						        		hidden: '{infoComercial.nombreMediador}'
						        	}
								},
								// Fila 1
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.codigo'),
									bind: '{infoComercial.codigoMediador}'
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.nombre'),
									bind: '{infoComercial.nombreMediador}'
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.telefono'),
									bind: '{infoComercial.telefonoMediador}'
								},
							// Fila 2
								{
									fieldLabel: HreRem.i18n('fieldlabel.email'),
									bind: '{infoComercial.emailMediador}'
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: 'Fecha envío llaves API',
									bind: '{infoComercial.envioLlavesApi}'
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.frecepcion.llaves'),
									bind: '{infoComercial.recepcionLlavesApi}'
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fultima.visita'),
									bind: '{infoComercial.fechaVisita}',
									readOnly: true
								},
							// Fila 3
								{
									xtype: 'checkboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.autorizado.web'),
									bind: '{infoComercial.autorizacionWeb}'
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fautorizacion.hasta'),
									bind: '{infoComercial.fechaAutorizacionHasta}',
									colspan: 2
								}
								]
						},
						{
							xtype:'fieldsettable',
							title: HreRem.i18n('titulo.grid.mediador.espejo'),
							defaultType: 'textfieldbase',
							colspan: 3,
							items :
								[
								{
								// Label vacia para desplazar la línea por cuestión de estética.
								xtype: 'label',
								bind: {
					        		hidden: '{infoComercial.nombreMediadorEspejo}'
					        		}
								},
								{
						        	xtype: 'label',
						        	cls:'x-form-item',
						        	text: HreRem.i18n('fieldlabel.mediador.notFound'),
						        	style: 'font-size: small;text-align: center;font-weight: bold;color: #DF7401;',
						        	colspan: 3,
						        	readOnly: true,
						        	reference: 'mediadorNotFoundLabel',
						        	bind: {
						        		hidden: '{infoComercial.nombreMediadorEspejo}'
						        	}
								},
								// Fila 1
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.codigo'),
									bind: '{infoComercial.codigoMediadorEspejo}'
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.nombre'),
									bind: '{infoComercial.nombreMediadorEspejo}'
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.telefono'),
									bind: '{infoComercial.telefonoMediadorEspejo}'
								},
							// Fila 2
								{
									fieldLabel: HreRem.i18n('fieldlabel.email'),
									bind: '{infoComercial.emailMediadorEspejo}'
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.frecepcion.llaves'),
									colspan: 2,
									bind: '{infoComercial.fechaRecepcionLlavesEspejo}'
								},
							// Fila 3
								{
									xtype: 'checkboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.autorizado.web'),
									bind: '{infoComercial.autorizacionWebEspejo}'
								}
								]
						},
						{
							xtype:'fieldsettable',
							title:HreRem.i18n('titulo.grid.proveedor.tecnico'),
							defaultType:'textfieldbase',
							colspan: 3,
							items:
								[	
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.codigo.proveedor'),
										bind: {
							        		disabled: '{!infoComercial.tieneProveedorTecnico}',
							        		value: '{infoComercial.codigoProveedor}'
							        	}					
										
									},
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.nombre.proveedor'),
										bind: {
							        		disabled: '{!infoComercial.tieneProveedorTecnico}',
							        		value: '{infoComercial.nombreProveedor}'
							        	},
						            	colspan: 2
									}
								]
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
										idPrincipal : 'activo.id',
										propagationButton: true,
										targetGrid	: 'mediadoractivo',
										bind: {
									        store: '{storeHistoricoMediador}'
									    },
										reference: "historicomediadorgrid", 
										colspan: 3
									}
								]
						}						
				]
			},
			
//Estado informe comercial
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
						            		value: '{activoInforme.tipoActivoCodigo}',
						            		rawValue: '{activoInforme.tipoActivoDescripcion}'
						            	},
			    						listeners: {
						                	select: 'onChangeChainedCombo'
						            	}
							        },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
							        	reference: 'subtipoActivoComboAdmisionInforme',
							        	bind: {
						            		store: '{comboSubtipoActivoAdmisionIC}',
						            		value: '{activoInforme.subtipoActivoCodigo}',
						            		disabled: '{!activoInforme.tipoActivoCodigo}',
						            		rawValue: '{activoInforme.subtipoActivoDescripcion}'
						            	},
						            	colspan: 2
							        },
								// Fila 1
									{							
										xtype: 'comboboxfieldbasedd',
										fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
										reference: 'tipoViaAdmisionInforme',
							        	bind: {
						            		store: '{comboTipoVia}',
						            		value: '{activoInforme.tipoViaCodigo}'	,
						            		rawValue: '{activoInforme.tipoViaDescripcion}'		            		
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
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.provincia'),
										reference: 'provinciaComboAdmisionInforme',
										chainedStore: 'comboMunicipioAdmisionIC',
										chainedReference: 'municipioComboAdmisionInforme',
										readOnly: esUA,
						            	bind: {
						            		store: '{comboProvincia}',
						            	    value: '{activoInforme.provinciaCodigo}',
						            	    rawValue: '{activoInforme.provinciaDescripcion}'
						            	},
			    						listeners: {
											select: 'onChangeChainedCombo'
			    						}
									},
					                {
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
										chainedStore: 'comboInferiorMunicipioAdmisionIC',
										chainedReference: 'poblacionalAdmisionInforme',
										reference: 'municipioComboAdmisionInforme',	
										readOnly: esUA,
						            	bind: {
						            		store: '{comboMunicipioAdmisionIC}',
						            		value: '{activoInforme.municipioCodigo}',
						            		disabled: '{!activoInforme.provinciaCodigo}',
						            		rawValue: '{activoInforme.municipioDescripcion}'
						            	},
			    						listeners: {
											select: 'onChangeChainedCombo'
			    						}
									},
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.unidad.poblacional'),
										reference: 'poblacionalAdmisionInforme',													
									    bind: {
									    	store: '{comboInferiorMunicipioAdmisionIC}',
									        value: '{activoInforme.inferiorMunicipioCodigo}',
									        disabled: '{!activoInforme.municipioCodigo}',
									        rawValue: '{activoInforme.inferiorMunicipioDescripcion}'
									    }
									},
								// Fila 4
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
										reference: 'codPostalAdmisionInforme',
										readOnly: esUA,
										bind:	'{activoInforme.codPostal}',
										vtype: 'codigoPostal',
										maskRe: /^\d*$/, 
					                	maxLength: 5
									},
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.latitud'),
										reference: 'latitudAdmisionInforme',
										bind:		'{activoInforme.latitud}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.longitud'),
										reference: 'longitudAdmisionInforme',
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
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
										reference: 'tipoActivoMediadorInforme',
							        	chainedStore: 'comboSubtipoActivo',
										chainedReference: 'subtipoActivoComboMediadorInforme',
							        	bind: {
						            		store: '{comboTipoActivo}',
						            		value: '{infoComercial.tipoActivoCodigo}',
						            		rawValue: '{infoComercial.tipoActivoDescripcion}'
						            	},
			    						listeners: {
						                	select: 'onChangeChainedCombo'
						            	}
							        },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
							        	reference: 'subtipoActivoComboMediadorInforme',
							        	bind: {
						            		store: '{comboSubtipoActivoMediadorIC}',
						            		value: '{infoComercial.subtipoActivoCodigo}',
						            		disabled: '{!infoComercial.tipoActivoCodigo}',
						            		rawValue: '{infoComercial.subtipoActivoDescripcion}'
						            	},
						            	colspan: 2
							        },
								// Fila 1
									{							
										xtype: 'comboboxfieldbasedd',
										fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
										reference: 'tipoViaMediadorInforme',
							        	bind: {
						            		store: '{comboTipoVia}',
						            		value: '{infoComercial.tipoViaCodigo}',
						            		rawValue: '{infoComercial.tipoViaDescripcion}'	            		
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
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.provincia'),
										reference: 'provinciaComboMediadorInforme',
										chainedStore: 'comboMunicipioMediadorIC',
										chainedReference: 'municipioComboMediadorInforme',
										readOnly: esUA,
						            	bind: {
						            		store: '{comboProvincia}',
						            	    value: '{infoComercial.provinciaCodigo}',
						            	    rawValue: '{infoComercial.provinciaDescripcion}'
						            	},
			    						listeners: {
											select: 'onChangeChainedCombo'
			    						}
									},
					                {
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
										reference: 'municipioComboMediadorInforme',
										chainedStore: 'comboInferiorMunicipioMediadorIC',
										chainedReference: 'poblacionalMediadorInforme',
										readOnly: esUA,
						            	bind: {
						            		store: '{comboMunicipioMediadorIC}',
						            		value: '{infoComercial.municipioCodigo}',
						            		disabled: '{!infoComercial.provinciaCodigo}',
						            		rawValue: '{infoComercial.municipioDescripcion}'
						            	},
						            	listeners: {
						            		select: 'onChangeChainedCombo',
						            		change: 'checkDistrito'
						                }
									},
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.unidad.poblacional'),
										reference: 'poblacionalMediadorInforme',													
									    bind: {
									    	store: '{comboInferiorMunicipioMediadorIC}',
									        value: '{infoComercial.inferiorMunicipioCodigo}',
									        disabled: '{!infoComercial.municipioCodigo}',
									        rawValue: '{infoComercial.inferiorMunicipioDescripcion}'
									    }
									},
								// Fila 4
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
										reference: 'codPostalMediadorInforme',
										readOnly: esUA,
										bind:		'{infoComercial.codigoPostal}',
										vtype: 'codigoPostal',
										maskRe: /^\d*$/, 
					                	maxLength: 5	                	
									},
									{
										xtype: 'comboboxfieldbasedd',
							        	fieldLabel: HreRem.i18n('fieldlabel.ubicacion'),
							        	bind: {
						            		store: '{comboTipoUbicacion}',
						            		value: '{infoComercial.ubicacionActivoCodigo}',
						            		rawValue: '{infoComercial.ubicacionActivoDescripcion}'
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
										bind:		'{infoComercial.latitud}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.longitud'),
										reference: 'longitudmediador',
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
					                		disabled: '{editableTipoActivo}'
					                	},
					                	text: HreRem.i18n('btn.verificar.coordenadas'),
					                	handler: 'onClickVerificarDireccion'
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
							title:HreRem.i18n('title.info.comercial.datos.activo'),
							colspan: 3,
							items :[
									/*{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboTipoComercializacionActivo}'
						            	},
										fieldLabel: 'Tipo venta'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboCarteraIM}'
						            	},
										fieldLabel: 'Cartera'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSubcarteraIM}'
						            	},
										fieldLabel: 'Subcartera'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}'
						            	},
										fieldLabel: 'Perímetro MACC'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSituacionComercial}'
						            	},
										fieldLabel: 'Estado comercial'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}'
						            	},
										fieldLabel: 'Publicado'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{storeFasesDePublicacion}'
						            	},
										fieldLabel: 'Fase publicación'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSubfasePublicacion}'
						            	},
										fieldLabel: 'Subfase publicación',
										colspan: 2
					                },
									{ 
										fieldLabel: 'Ref. Catastral'
					                },
									{ 
										fieldLabel: 'Finca registral'
					                },
									{ 
										fieldLabel: 'Porcentaje propiedad'
					                },
					                { 
										xtype: 'datefieldbase',
										fieldLabel: 'Fecha posesión'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}'
						            	},
										fieldLabel: 'Visitable'
					                },
									{ 
										xtype: 'datefieldbase',
										fieldLabel: 'Fecha visita al inmueble',
										colspan: 2,
										readOnly	: true
					                },
									{ 
										xtype: 'datefieldbase',
										fieldLabel: 'Envío llaves al API'
					                },
									{ 
										xtype: 'datefieldbase',
										fieldLabel: 'Recepción llaves',
										colspan: 2
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboCalificacionEnergetica}'
						            	},
										fieldLabel: 'Certificado E.Energética'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboEstadoFisico}'
						            	},
										fieldLabel: 'Estado físico'
					                },
									{ 
										fieldLabel: 'Superfície construida'
					                },
									{ 
										fieldLabel: 'Superfície registral',
										bind:		'{infoComercial.superficieRegistral}'
					                },
									{ 
										fieldLabel: 'Mediador asignado'
					                },
									{ 
										fieldLabel: 'Gestor publicaciones'
					                },
									{ 
										vtype: 'email',
										fieldLabel: 'Email gestor publicaciones',
										colspan: 2
					                },
									{ 
										fieldLabel: 'Gestor comercial'
					                },
									{ 
										vtype: 'email',
										fieldLabel: 'Email gestor comercial'
					                }	*/	
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboRegimenProteccion}',
						            		value: '{infoComercial.regimenInmuebleCod}',
						            		rawValue: '{infoComercial.regimenInmuebleDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.regimen.inmueble')
					                },
					    			{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.rehabilitadoCod}',
						            		rawValue: '{infoComercial.rehabilitadoDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.rehabilitado')
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboEstadoOcupacional}',
						            		value: '{infoComercial.estadoOcupacionalCod}',
						            		rawValue: '{infoComercial.estadoOcupacionalDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.ocupacional')
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.anyo.construccion'),
										maskRe: /^\d*$/,
										vtype: 'anyo',
										bind:		'{infoComercial.anyoConstruccion}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.anyo.rehabilitacion'),
										bind:		'{infoComercial.anyoRehabilitacion}',
										maskRe: /^\d*$/,
										vtype: 'anyo'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.ocupadoCod}',
						            		rawValue: '{infoComercial.ocupadoDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.ocupado'),
										colspan: 2,
										readOnly	: true
					                },
					        		{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboEstadoConservacionIM}',
						            		value: '{infoComercial.estadoConservacionCod}',
						            		rawValue: '{infoComercial.estadoConservacionDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.conservacion')
					                }
								]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title:HreRem.i18n('title.info.comercial.caracteristicas.activo'),
							colspan: 3,
							items :[
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.visitableCod}',
						            		rawValue: '{infoComercial.visitableDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.visitable.fecha.visita'),
										colspan: 4,
										readOnly	: true 
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.dormitorios'),
										bind:		'{infoComercial.dormitorios}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.plantas'),
										bind:		'{infoComercial.plantas}'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.ascensorCod}',
						            		rawValue: '{infoComercial.ascensorDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.ascensor')
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.salones'),
										bind:		'{infoComercial.salones}'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.terrazaCod}',
						            		rawValue: '{infoComercial.terrazaDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.terraza')
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.plazas.garaje'),
										bind:		'{infoComercial.plazasGaraje}'//,
										// colspan: 2
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.banyos'),
										bind:		'{infoComercial.banyos}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.sup.terraza'),
										bind:		'{infoComercial.superficieTerraza}'//,
										//colspan: 2
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.anejoGarajeCod}',
						            		rawValue: '{infoComercial.anejoGarajeDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.anejo.garaje')
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.aseos'),
										bind:		'{infoComercial.aseos}'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.patioCod}',
						            		rawValue: '{infoComercial.patioDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.patio')
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.anejoTrasteroCod}',
						            		rawValue: '{infoComercial.anejoTrasteroDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.anejo.trastero')
					                },		
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estancias'),
										bind:		'{infoComercial.estancias}'
					                },


									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.sup.patio'),
										bind:		'{infoComercial.superficiePatio}',
										colspan: 2
					                }
									/*{ 
										fieldLabel: 'Superficie útil'
					                },*/
								]
						}
				]
            },
// Otras características del activo //Estado de conservacion
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.info.comercial.otras.caracteristicas.ppales.activo'),
				defaultType: 'textfieldbase',
				items :
					[
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title: HreRem.i18n('title.info.comercial.calidades.ppales.activo'),
							colspan: 3,
							items :[
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.orientacion'),
										bind:		'{infoComercial.orientacion}'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboExteriorInterior}',
						            		value: '{infoComercial.extIntCod}',
						            		rawValue: '{infoComercial.extIntDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.ext.int'),
										colspan: 2
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboRatingCocina}',
						            		value: '{infoComercial.cocRatingCod}',
						            		rawValue: '{infoComercial.cocRatingDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.cocina')
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.cocAmuebladaCod}',
						            		rawValue: '{infoComercial.cocAmuebladaDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.cocina.amueblada')
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.armEmpotradosCod}',
						            		rawValue: '{infoComercial.armEmpotradosDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.armarios.empotrados')
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.calefaccion'),
										bind:		'{infoComercial.calefaccion}'
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboTipoCalefaccion}',
						            		value: '{infoComercial.tipoCalefaccionCod}',
						            		rawValue: '{infoComercial.tipoCalefaccionDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.tipo.calefaccion')
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboTipoClimatizacion}',
						            		value: '{infoComercial.aireAcondCod}',
						            		rawValue: '{infoComercial.aireAcondDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.aire.acondicionado')
					                }					
								]
						},
						{
							xtype:'fieldsettable',
							title: HreRem.i18n('title.info.comercial.estado.conservacion'),
							defaultType: 'textfieldbase',
							items :
								[
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										collapsible: false,
										border: false,
										bind: {
							        		hidden: '{!infoComercial.isVivienda}'
										},
										colspan: 3,
										items :[
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboEstadoConservacionEdificio}',
									            		value: '{infoComercial.estadoConservacionEdiCod}',
									            		rawValue: '{infoComercial.estadoConservacionEdiDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.cons.edificio')
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.num.plantas.edificio'),
													bind:		'{infoComercial.plantasEdificio}'
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboTipoPuerta}',
									            		value: '{infoComercial.puertaAccesoCod}',
									            		rawValue: '{infoComercial.puertaAccesoDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.puerta.acceso')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboEstadoMobiliario}',
									            		value: '{infoComercial.estadoPuertasIntCod}',
									            		rawValue: '{infoComercial.estadoPuertasIntDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.puertas')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboEstadoMobiliario}',
									            		value: '{infoComercial.estadoPersianasCod}',
									            		rawValue: '{infoComercial.estadoPersianasDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.persianas')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboEstadoMobiliario}',
									            		value: '{infoComercial.estadoVentanasCod}',
									            		rawValue: '{infoComercial.estadoVentanasDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.ventanas')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboEstadoMobiliario}',
									            		value: '{infoComercial.estadoPinturaCod}',
									            		rawValue: '{infoComercial.estadoPinturaDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.pintura')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboEstadoMobiliario}',
									            		value: '{infoComercial.estadoSoladosCod}',
									            		rawValue: '{infoComercial.estadoSoladosDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.solados')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboEstadoMobiliario}',
									            		value: '{infoComercial.estadoBanyosCod}',
									            		rawValue: '{infoComercial.estadoBanyosDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.estado.banyos')
								                }				
											]
									},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										collapsible: false,
										border: false,
										bind: {
							        		hidden: '{!infoComercial.isComercialOrGaraje}'
										},
										colspan: 3,
										items :[
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.licenciaAperturaCod}',
									            		rawValue: '{infoComercial.licenciaAperturaDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.licencia.apertura')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.salidaHumoCod}',
									            		rawValue: '{infoComercial.salidaHumoDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.salida.humos')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.aptoUsoCod}',
									            		rawValue: '{infoComercial.aptoUsoDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.apto.uso')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.accesibilidad'),
													bind: {
									            		store: '{comboActivoAccesibilidad}',
									            		value: '{infoComercial.accesibilidadCod}',
									            		rawValue: '{infoComercial.accesibilidadDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo'
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.fachada.principal'),
													bind:		'{infoComercial.metrosFachada}',
													colspan: 2
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.almacenCod}',
									            		rawValue: '{infoComercial.almacenDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.almacen')
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.sup.almacen'),
													bind:		'{infoComercial.metrosAlmacen}',
													colspan: 2
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.supVentaExpoCod}',
									            		rawValue: '{infoComercial.supVentaExpoDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.venta.expo')
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.sup.venta'),
													bind:		'{infoComercial.metrosSupVentaExpo}',
													colspan: 2
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.entreplantaCod}',
									            		rawValue: '{infoComercial.entreplantaDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.entreplanta')
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.alt.libre'),
													bind:		'{infoComercial.alturaLibre}'
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.edi.ejecutada'),
													bind:		'{infoComercial.porcEdiEjecutada}'
								                }					
											]
									},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										collapsible: false,
										border: false,
										bind: {
							        		hidden: '{!infoComercial.isSuelo}'
										},
										colspan: 3,
										items :[
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.edificabilidad.techo'),
													bind:		'{infoComercial.edificabilidadTecho}'
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.sup.suelo'),
													bind:		'{infoComercial.superficieSuelo}'
								                },
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.porc.urb.ejecutada'),
													bind:		'{infoComercial.porcUrbEjecutada}'
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboClasificacion}',
									            		value: '{infoComercial.clasificacionCod}',
									            		rawValue: '{infoComercial.clasificacionDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.clasificacion')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboUsoActivo}',
									            		value: '{infoComercial.usoCod}',
									            		rawValue: '{infoComercial.usoDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.uso')
								                }				
											]
									},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										collapsible: false,
										border: false,
										bind: {
							        		hidden: '{!infoComercial.isConstruccion}'
										},
										colspan: 3,
										items :[
												{ 
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.edi.ejecutada'),
													bind:		'{infoComercial.porcEdiEjecutada}'
								                }					
											]
									},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										title:HreRem.i18n('title.info.comercial.equipamientos'),
										colspan: 3,
										items :[
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboDisponibilidad}',
									            		value: '{infoComercial.jardinCod}',
									            		rawValue: '{infoComercial.jardinDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.jardin')//,
													//colspan: 2
								                },		{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboAdmision}',
									            		value: '{infoComercial.admiteMascotaCod}',
									            		rawValue: '{infoComercial.admiteMascotaDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.admite.mascota')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboDisponibilidad}',
									            		value: '{infoComercial.piscinaCod}',
									            		rawValue: '{infoComercial.piscinaDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.piscina')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.zonaVerdeCod}',
									            		rawValue: '{infoComercial.zonaVerdeDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.zonas.verdes')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.conserjeCod}',
									            		rawValue: '{infoComercial.conserjeDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.conserje')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.accesoMovReducidaCod}',
									            		rawValue: '{infoComercial.accesoMovReducidaDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.acc.mov.reducida')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboSinSino}',
									            		value: '{infoComercial.zonaDeportivaCod}',
									            		rawValue: '{infoComercial.zonaDeportivaDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.zonas.deportivas')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboDisponibilidad}',
									            		value: '{infoComercial.gimnasioCod}',
									            		rawValue: '{infoComercial.gimnasioDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.gimnasio')
								                }
											]
									},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										title:HreRem.i18n('title.info.comercial.com.servicios'),
										colspan: 3,
										items :[
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboComunicacionUbicacion}',
									            		value: '{infoComercial.ubicacionCod}',
									            		rawValue: '{infoComercial.ubicacionDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.ubicacion')
								                },
												{ 
													xtype: 'comboboxfieldbasedd',
										        	bind: {
									            		store: '{comboValoracionUbicacion}',
									            		value: '{infoComercial.valUbicacionCod}',
									            		rawValue: '{infoComercial.valUbicacionDesc}'
									            	},
									            	displayField: 'descripcion',
						    						valueField: 'codigo',
													fieldLabel: HreRem.i18n('fieldlabel.info.comercial.val.ubicacion')
								                }				
											]
									},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										title:HreRem.i18n('title.info.comercial.desc.comercial'),
										colspan: 3,
										items :[
												{ 
											 		xtype: 		'textareafieldbase',
													bind:		'{infoComercial.descripcionComercial}',
											 		maxWidth:	1600,
											 		height: 	120
											   }				
											]
									}
							]
			            },
            	]
			},
// Otra Información de interes
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.info.comercial.info.interes'),
				defaultType: 'textfieldbase',
				items :
					[
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsible: false,
							border: false,
							colspan: 3,
							items :[
									{ 
										xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.fecha.informe'),
										bind:		'{infoComercial.fechaRecepcionInforme}'
					                },
									{ 
										xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.fecha.modificacion.informe'),
										bind:		'{infoComercial.fechaModificadoInforme}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.modificacion.informe'),
										bind:		'{infoComercial.modificadoInforme}'
					                },
									{ 
										xtype: 'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.fecha.informe.completo'),
										bind:		'{infoComercial.fechaCompletadoInforme}'
					                },
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.info.comercial.informe.completo'),
										bind:		'{infoComercial.completadoInforme}'
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