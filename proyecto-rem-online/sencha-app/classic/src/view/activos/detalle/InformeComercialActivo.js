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
        
		var editaPosibleInforme = !(($AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYASUPPUBL'])));
		
		var isCarteraLiberbank = me.lookupViewModel().get('activo.isCarteraLiberbank');
		
		var tienePosibleInformeMediador = me.lookupViewModel().get('activo.tienePosibleInformeMediador');
		
		var esUA = me.lookupViewModel().get('activo.unidadAlquilable');
		
		//var isVivienda = me.lookupViewModel().get('activo.tipoActivoMediadorCodigo') == CONST.TIPOS_ACTIVO['VIVIENDA'];
		
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
									fieldLabel: 'Fecha envío llaves API',
									bind: '{infoComercial.envioLlavesApi}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.frecepcion.llaves'),
									bind: '{infoComercial.recepcionLlavesApi}',
									readOnly: true
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
									bind: '{infoComercial.autorizacionWeb}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.fautorizacion.hasta'),
									bind: '{infoComercial.fechaAutorizacionHasta}',
									readOnly: true,
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
									bind: '{infoComercial.codigoMediadorEspejo}',
									readOnly: true
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.nombre'),
									bind: '{infoComercial.nombreMediadorEspejo}',
									readOnly: true
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.telefono'),
									bind: '{infoComercial.telefonoMediadorEspejo}',
									readOnly: true
								},
							// Fila 2
								{
									fieldLabel: HreRem.i18n('fieldlabel.email'),
									bind: '{infoComercial.emailMediadorEspejo}',
									readOnly: true
								},
								{
									xtype: 'datefieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.frecepcion.llaves'),
									colspan: 2,
									bind: '{infoComercial.fechaRecepcionLlavesEspejo}',
									readOnly: true
								},
							// Fila 3
								{
									xtype: 'checkboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.autorizado.web'),
									bind: '{infoComercial.autorizacionWebEspejo}',
									readOnly: true
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
										readOnly: true,
										bind: {
							        		disabled: '{!infoComercial.tieneProveedorTecnico}',
							        		value: '{infoComercial.codigoProveedor}'
							        	}					
										
									},
									{ 
										fieldLabel: HreRem.i18n('fieldlabel.nombre.proveedor'),
										readOnly: true,
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
					                		disabled: '{editableTipoActivo}'
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
							colspan: 3,
							items :
								[
								 	// Venta
									{
										fieldLabel: 'Valor estimado mínimo venta',
										width:		280,
										bind:		'{infoComercial.valorEstimadoMinVenta}',
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										fieldLabel:'Valor estimado máximo venta',
										width:		280,
										bind:		'{infoComercial.valorEstimadoMaxVenta}',
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										fieldLabel: 'Valor final de venta recomendado',
										width:		280,
										bind:		'{infoComercial.valorEstimadoVenta}',
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
					                // Alquiler
									{
										fieldLabel: 'Valor estimado mínimo renta',
										width:		280,
										bind:		'{infoComercial.valorEstimadoMinRenta}',
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										fieldLabel:'Valor estimado máximo renta',
										width:		280,
										bind:		'{infoComercial.valorEstimadoMaxRenta}',
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
									},
									{
										fieldLabel: 'Valor final de renta recomendado',
										width:		280,
										bind:		'{infoComercial.valorEstimadoVenta}',
										renderer: function(value) {
			   				        		return Ext.util.Format.currency(value);
			   				        	}
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
							title:'Datos del activo',
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
					                },*/
									{ 
										fieldLabel: 'Codigo agrupación ON',
										bind:		'{infoComercial.codAgrupacionON}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Lote',
										bind:		'{infoComercial.idLote}',
										readOnly	: true
					                },
									{ 
										bind:		'{infoComercial.activoPrincipal}',
										fieldLabel: 'Activo principal',
										readOnly	: true
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboRegimenProteccion}',
						            		value: '{infoComercial.regimenInmuebleCod}',
						            		rawValue: '{infoComercial.regimenInmuebleDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: 'Régimen del inmueble'
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
										fieldLabel: 'Estado ocupacional'
					                },
									/*{ 
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
					                },*/
									{ 
										fieldLabel: 'Año construcción',
										maskRe: /^\d*$/,
										vtype: 'anyo',
										bind:		'{infoComercial.anyoConstruccion}'
					                }/*,
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
								]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title:'Características del activo',
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
										fieldLabel: 'Visitable fecha de la visita',/// no visitable
										readOnly	: true 
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
										fieldLabel: 'Ocupado',//'Situación ocupación fecha de la visita',
										colspan: 2,
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Dormitorios',
										bind:		'{infoComercial.dormitorios}'
					                },
									{ 
										fieldLabel: 'Baños',
										bind:		'{infoComercial.banyos}'
					                },
									{ 
										fieldLabel: 'Aseos',
										bind:		'{infoComercial.aseos}'
					                },
									{ 
										fieldLabel: 'Salones',
										bind:		'{infoComercial.salones}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Estancias',
										bind:		'{infoComercial.estancias}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Plantas',
										bind:		'{infoComercial.plantas}',
										readOnly	: true
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
										fieldLabel: 'Ascensor'
					                },
									{ 
										fieldLabel: 'Plazas de garaje',
										bind:		'{infoComercial.plazasGaraje}',
										colspan: 2
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
										fieldLabel: 'Terraza'
					                },
									{ 
										fieldLabel: 'Superficie terraza principal',
										bind:		'{infoComercial.superficieTerraza}',
										colspan: 2,
										readOnly	: true
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
										fieldLabel: 'Patio'
					                },
									{ 
										fieldLabel: 'Superficie patio',
										bind:		'{infoComercial.superficiePatio}',
										colspan: 2,
										readOnly	: true
					                },
									/*{ 
										fieldLabel: 'Superficie útil'
					                },*/
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.rehabilitadoCod}',
						            		rawValue: '{infoComercial.rehabilitadoDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: 'Rehabilitado'
					                },
									{ 
										fieldLabel: 'Año rehabilitación',
										bind:		'{infoComercial.anyoRehabilitacion}',
										maskRe: /^\d*$/,
										vtype: 'anyo'
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
										fieldLabel: 'Estado conservación',
										readOnly	: true
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
										fieldLabel: 'Anejo garaje',
										readOnly	: true
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
										fieldLabel: 'Anejo trastero',
										readOnly	: true
					                }						
								]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title:'Características principales del activo',
							colspan: 3,
							items :[
									{ 
										fieldLabel: 'Orientación',
										bind:		'{infoComercial.orientacion}',
										readOnly	: true
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
										fieldLabel: 'Exterior/Interior',
										colspan: 2,
										readOnly	: true
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
										fieldLabel: 'Cocina rating',
										readOnly	: true
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
										fieldLabel: 'Cocina amueblada',
										readOnly	: true
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
										fieldLabel: 'Armarios empotrados',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Calefacción',
										bind:		'{infoComercial.calefaccion}',
										readOnly	: true
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
										fieldLabel: 'Tipo calefacción',
										readOnly	: true
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
										fieldLabel: 'Aire acondicionado',
										readOnly	: true
					                }					
								]
						}
				]
            },
// Otras características del activo
			{
				xtype:'fieldsettable',
				title:'Otras características del activo',
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
										fieldLabel: 'Estado conservación edificio',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Número de plantas edificio',
										bind:		'{infoComercial.plantasEdificio}',
										colspan: 2,
										readOnly	: true
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
										fieldLabel: 'Puerta de acceso',
										readOnly	: true
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
										fieldLabel: 'Estado puertas interiores',
										readOnly	: true
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
										fieldLabel: 'Estado persianas',
										readOnly	: true
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
										fieldLabel: 'Estado ventanas',
										readOnly	: true
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
										fieldLabel: 'Estado pintura',
										readOnly	: true
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
										fieldLabel: 'Estado solados',
										readOnly	: true
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
										fieldLabel: 'Estado baños',
										readOnly	: true
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboAdmision}',
						            		value: '{infoComercial.admiteMascotaCod}',
						            		rawValue: '{infoComercial.admiteMascotaDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: 'Admite mascota',
										readOnly	: true
					                }					
								]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsible: false,
							border: false,
							bind: {
				        		hidden: '{infoComercial.isVivienda}'
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
										fieldLabel: 'Licencia apertura'
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
										fieldLabel: 'Salida de humos',
										colspan: 2,
										readOnly	: true
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
										fieldLabel: 'Apto para uso',
										readOnly	: true
					                },
									/*{ 
										xtype: 'comboboxfieldbasedd',
										fieldLabel: 'Accesibilidad',
										bind: {
						            		store: '{falta combo}',
						            		value: '{infoComercial.accesibilidadCod}',
						            		rawValue: '{infoComercial.accesibilidadDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										colspan: 2,
										readOnly	: true
					                },*/
									{ 
										fieldLabel: 'Edificabilidad m2 techo',
										bind:		'{infoComercial.edificabilidadTecho}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Superficie suelo m2',
										bind:		'{infoComercial.superficieSuelo}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Porcentaje urbanización ejecutada',
										bind:		'{infoComercial.porcUrbEjecutada}',
										readOnly	: true
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
										fieldLabel: 'Clasificación',
										readOnly	: true
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
										fieldLabel: 'Uso',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Fachada principal: metros lineales',
										bind:		'{infoComercial.metrosFachada}',
										readOnly	: true
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
										fieldLabel: 'Almacen',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Almacen m2',
										bind:		'{infoComercial.metrosAlmacen}',
										colspan: 2,
										readOnly	: true
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
										fieldLabel: 'Superficie venta / exposición',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Superficie venta / exposición m2 construidos',
										bind:		'{infoComercial.metrosSupVentaExpo}',
										colspan: 2,
										readOnly	: true
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
										fieldLabel: 'Entreplanta',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Altura libre',
										bind:		'{infoComercial.alturaLibre}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Tanto % edificación ejecutada',
										bind:		'{infoComercial.porcEdiEjecutada}',
										readOnly	: true
					                }					
								]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title:'Equipamientos',
							colspan: 3,
							items :[
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboSinSino}',
						            		value: '{infoComercial.zonaVerdeCod}',
						            		rawValue: '{infoComercial.zonaVerdeDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: 'Zonas verdes',
										readOnly	: true
					                },
									{ 
										xtype: 'comboboxfieldbasedd',
							        	bind: {
						            		store: '{comboDisponibilidad}',
						            		value: '{infoComercial.jardinCod}',
						            		rawValue: '{infoComercial.jardinDesc}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
										fieldLabel: 'Jardín',
										colspan: 2,
										readOnly	: true
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
										fieldLabel: 'Zonas deportivas',
										readOnly	: true
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
										fieldLabel: 'Gimnasio',
										readOnly	: true
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
										fieldLabel: 'Piscina',
										readOnly	: true
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
										fieldLabel: 'Conserje',
										readOnly	: true
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
										fieldLabel: 'Accesible personas movilidad reducida',
										readOnly	: true
					                }					
								]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title:'Comunicaciones y servicios',
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
										fieldLabel: 'Ubicación',
										readOnly	: true
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
										fieldLabel: 'Valoración ubicación',
										readOnly	: true
					                }				
								]
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title:'Descripción comercial',
							colspan: 3,
							items :[
									{ 
								 		xtype: 		'textareafieldbase',
										bind:		'{infoComercial.descripcionComercial}',
								 		maxWidth:	1600,
								 		height: 	120,
										readOnly	: true
								   }				
								]
						}
				]
            },
// Otra Información de interes
			{
				xtype:'fieldsettable',
				title:'Otra información de interés',
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
										fieldLabel: 'Fecha recepción informe',
										bind:		'{infoComercial.fechaRecepcionInforme}',
										readOnly	: true
					                },
									{ 
										xtype: 'datefieldbase',
										fieldLabel: 'Última modificación informe',
										bind:		'{infoComercial.fechaModificadoInforme}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Última modificación informe por',
										bind:		'{infoComercial.modificadoInforme}',
										readOnly	: true
					                },
									{ 
										xtype: 'datefieldbase',
										fieldLabel: 'Primer envío informe completado',
										bind:		'{infoComercial.fechaCompletadoInforme}',
										readOnly	: true
					                },
									{ 
										fieldLabel: 'Primer envío informe completado por',
										bind:		'{infoComercial.completadoInforme}',
										readOnly	: true
					                }					
								]
						}
				]
            },
            
            //Testigos Opcionales
			{
				xtype:'fieldsettable',
				title:'Testigos de mercado',
				defaultType: 'textfieldbase',
				items :
					[
						{xtype: "testigosopcionalesgrid", reference: "testigosopcionalesgrid"}
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