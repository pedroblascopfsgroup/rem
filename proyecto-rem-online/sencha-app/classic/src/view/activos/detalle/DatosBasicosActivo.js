Ext.define('HreRem.view.activos.detalle.DatosBasicosActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: false,
    reference: 'datosbasicosactivo',
    scrollable	: 'y',
    refreshAfterSave : true,
	recordName: "activo",
	
	recordClass: "HreRem.model.Activo",
    
    requires: ['HreRem.model.Activo','HreRem.view.activos.detalle.HistoricoDestinoComercialActivo', 'HreRem.view.common.ComboBoxFieldBaseDD', 'HreRem.view.activos.detalle.CatastroGrid'],
    
    initComponent: function () {

        var me = this;
        var isCarteraBbva = me.lookupController().getViewModel().getData().activo.getData().isCarteraBbva;
        var usuariosValidos = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ADMISION']);
		me.setTitle(HreRem.i18n('title.datos.basicos'));
        var items= [{
        		xtype:'catastroGrid'
        	}, 	
			{
			xtype:'fieldsettable',
	        title: HreRem.i18n('title.identificacion'),
			items: [
				{    
				xtype:'container',
				layout:'hbox',
				colspan: 3,
				defaultType: 'container',
				items :
					[{ // Columna 1
							defaultType: 'textfieldbase',
							flex: 1,
							items:[
								{
				                	xtype: 'displayfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.haya'),
				                	bind:		'{activo.numActivo}'
	
				                },
				                {
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.id.activo.prinex'),
									bind:		'{activo.idProp}'
								},
								{
									xtype: 'displayfieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.id.activo.sareb'),
					                bind:		'{activo.idSareb}'
								},
								{
									xtype: 'displayfieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.id.activo.uvem'),
				                	bind:{
				                		value: '{activo.numActivoUvem}',
				                		hidden: '{!activo.isCarteraBankia}'
				                	}
				                },
								{
									xtype: 'displayfieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.numero.activo.caixa'),
				                	bind:{
				                		value: '{activo.numActivoCaixa}',
				                		hidden: '{!activo.isCarteraBankia}'
				                	}
				                },
				                {
				                	xtype: 'displayfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.rem'),
				                	bind:		'{activo.numActivoRem}'
				                },
				                {
									xtype: 'displayfieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.id.activo.divarian'),
									bind:		'{activo.numActivoDivarian}'
								},
				                {
									xtype: 'displayfieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.id.bien.recovery'),
									reference:'idRecovery',
									bind:		'{activo.idRecovery}'
								},							
								{
				                	xtype: 'displayfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.categoria.contable'),
						        	bind:{	value: '{activo.catContableDescripcion}',
						        			hidden: '{!activo.isCarteraLiberbank}'
						        		}
				                },
				                {
				                	xtype: 'displayfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.promocion.final'),
						        	bind:{	value: '{activo.codPromocionFinal}',
						        			hidden: '{!activo.isCarteraLiberbank}'
						        	}
				                },
				                {
				                	xtype: 'textfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.numero.activo.prinex'),
						        	name:'idPrinexHPM',
						        	bind:{	
						        		value: '{activo.idPrinexHPM}',
						        		readOnly : '{!esUA}',
						        		hidden: '{!esUA}'
						        	}
				                },
				                {
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.estado.adecuacion.sareb'),
				                	name: 'comboreoadecuacionsareb',
				                	reference: 'comboreoadecuacionsarebRef',
				                	bind: {	
					                	readOnly : '{!esSuperUsuarioAndNoUA}',
				                		store: '{comboEstadoAdecuacionSareb}',
										value: '{activo.estadoAdecuacionSarebCodigo}',
				                		hidden: '{!activo.isCarteraSareb}'
				                	}			                
				                },
						        {
				                	xtype: 'datefieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.fin.prevista.adecuacion'),
				                	name: 'fechaFinPrevistaAdecuacion',
				                	reference: 'fechaFinPrevistaAdecuacionRef',
				                	bind: {	
					                	readOnly : '{!esSuperUsuarioAndNoUA}',
										value: '{activo.fechaFinPrevistaAdecuacion}',
				                		hidden: '{!activo.isCarteraSareb}'
				                	}
				                },
				                {
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.reo.contabilizado.sap'),
				                	name: 'comboreocontabilizadosap',
				                	reference: 'comboreocontabilizadosapRef',
				                	bind: {	
					                	readOnly : '{!esSuperUsuarioAndNoUA}',
				                		store: '{comboSiNoBoolean}',
										value: '{activo.reoContabilizadoSap}',
				                		hidden: '{!activo.isCarteraSareb}'
				                	}
				                
				                },
								{
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.reo.preinmueble'),
				                	name: 'combopreinmueble',
				                	reference: 'combopreinmuebleRef',
				                	bind: {	
					                	readOnly : '{!esUnRolPreinmueble}',
				                		store: '{comboSiNoNSRem}',
				                		value: '{activo.enTramite}',
				                		hidden: '{!activo.isCarteraTitulizada}'
				                	}
				                
				                },
				                {
				                	xtype: 'displayfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.agrupacion.obra.nueva.bc'),
						        	bind:{	value: '{activo.unidadEconomicaCaixa}',
						        			hidden: '{activo.dentroAgrupacionObraNuevaBC}',
						        			readOnly: true
						        	}
				                }
				                
							]
						},
						{	// Columna 2
							defaultType: 'textfieldbase',
							flex: 1,
							items:[
								{
				                	fieldLabel: HreRem.i18n('fieldlabel.activosearch.codigo.promocion'),
									bind:{
										readOnly: '{!esEditableCodigoPromocion}',
										hidden: '{!activo.isVisibleCodPrinex}',
										value:'{activo.codigoPromocionPrinex}'
									}
								},
								{
						        	xtype: 'comboboxfieldbasedd',
						        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
									reference: 'tipoActivo',
						        	chainedStore: 'comboSubtipoActivo',
									chainedReference: 'subtipoActivoCombo',									
						        	bind: {
					            		store: '{comboTipoActivo}',
					            		value: '{activo.tipoActivoCodigo}',
										rawValue: '{activo.tipoActivoDescripcion}',
										readOnly: '{isCarteraBankia}'
					            	},
		    						listeners: {
					                	select: 'onChangeChainedCombo'
					            	},
					            	allowBlank: false
						        },
						        {
									xtype: 'comboboxfieldbasedd',
						        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
						        	reference: 'subtipoActivoCombo',
						        	bind: {
					            		store: '{comboSubtipoActivo}',
					            		value: '{activo.subtipoActivoCodigo}',
					            		disabled: '{!activo.tipoActivoCodigo}',
					            		readOnly: '{isCarteraBankia}',
										rawValue: '{activo.subtipoActivoDescripcion}'
					            	},
		    						allowBlank: false
						        },
						        {
									xtype: 'comboboxfieldbasedd',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.activo.bde'),
						        	reference: 'tipoActivoBde',
						        	bind: {
						        		readOnly : '{esUA}',
					            		store: '{comboTipoActivoBde}',
					            		value: '{activo.tipoActivoCodigoBde}',
					            		hidden: '{!activo.isCarteraLiberbank}',
										rawValue: '{activo.tipoActivoDescripcionBde}'
					            	}
						        },
								{
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.tipo.activo.oe'),
									reference: 'tipoActivoOE',
									chainedStore: 'comboSubtipoActivoOE',
									chainedReference: 'subtipoActivoComboOE',
						        	bind: {
					            		store: '{comboTipoActivoOE}',
					            		value: '{activo.tipoActivoCodigoOE}',
					            		hidden: '{!activo.isCarteraSareb}', 
					            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'
					            	},
		    						listeners: {
					                	select: 'onChangeChainedCombo'
					            	}
						        }, 
						        {
						        	xtype: 'comboboxfieldbase',
						        	xtype: 'comboboxfieldbasedd',
						        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo.bde'),
									reference: 'subtipoActivoComboBde',
						        	bind: {
						        		readOnly : '{esUA}',
					            		store: '{comboSubtipoActivoBde}',
					            		value: '{activo.subtipoActivoCodigoBde}',
					            		hidden: '{!activo.isCarteraLiberbank}',
										rawValue: '{activo.subtipoActivoDescripcionBde}'
					            	}
						        },
				                {
									xtype: 'comboboxfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo.oe'),
						        	reference: 'subtipoActivoComboOE',
						        	bind: {
					            		store: '{comboSubtipoActivoOE}',
					            		value: '{activo.subtipoActivoCodigoOE}',
					            		disabled: '{!activo.tipoActivoCodigoOE}',
					            		hidden: '{!activo.isCarteraSareb}', 
					            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'
					            	}
						        },
						        {
				                	xtype: 'comboboxfieldbasedd',
						        	fieldLabel:  HreRem.i18n('fieldlabel.uso.dominante'),
						        	name: 'tipoUsoDestinoCodigo',
				                	bind: {
				                		readOnly : '{esUAyIsCarteraBankia}',
					            		store: '{comboTipoUsoDestino}',
					            		value: '{activo.tipoUsoDestinoCodigo}',
										rawValue: '{activo.tipoUsoDestinoDescripcion}'
					            	}
				                },
				                {
				                	xtype: 'textfieldbase',
				                	fieldLabel: HreRem.i18n('fieldlabel.motivorechazoform.motivo'),
				                	name: 'motivoActivo',
				                	bind: {
				                		readOnly : '{esUA}',
				                		value: '{activo.motivoActivo}'
				                	},
				                	maxLength: 50
				                },
				                {
				                	xtype: 'textfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.porcentaje.participacion'),
						        	name: 'porcentajeParticipacion',
						        	bind:{	
						        		value: '{activo.porcentajeParticipacion}',
						        		readOnly : '{!esUA}',
						        		hidden: '{!esUA}'
						        	},
						        	handler: 'checkVerificarPorcentajeParticipacion',
				                	maxLength: 50
				                },
				                
								{
						        	xtype:'fieldset',
						        	height: '100%',
						        	border: false,
									layout: {
									        type: 'table',
									        // The total column count must be specified here
									        columns: 1,
									        trAttrs: {height: '30px', width: '100%'},
									        tdAttrs: {width: '100%'},
									        tableAttrs: {
									            style: {
									                width: '100%'
													}
									        }
									},
									padding: '0',
						        	defaultType: 'textfieldbase',
									rowspan: 1,
									items: [
										{ 	// Este campo es necesario para corregir lo que parece un BUG. 
											// TODO Investigar porqu� al quitar este campo, el valor del siguiente campo se manda siempre al guardar, aunque no se haya modificado.
							            	hidden: true
										},
								        {
								        	xtype: 'comboboxfieldbasedd',
								        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
								        	name: 'estadoActivoCodigo',
								        	reference: 'estadoActivoCodigoRef',
								        	bind: {
								        		disabled: '{!tieneGestionDnd}',
							            		store: '{comboEstadoActivo}',
							            		value: '{activo.estadoActivoCodigo}',
												rawValue: '{activo.estadoActivoDescripcion}'
								        	}
								        },
								        {
								        	xtype: 'comboboxfieldbasedd',
								        	fieldLabel:  HreRem.i18n('fieldlabel.gestion.dnd'),
								        	name: 'gestionDndCodigo',
								        	reference: 'gestionDndCodigoRef',
								        	bind: {
							            		store: '{comboGestionDnd}',
							            		value: '{activo.tieneGestionDndCodigo}',
												rawValue: '{activo.tieneGestionDndDescripcion}'
								        	},
								        	listeners: {
								        		change: 'onChangeComboGestionDnd'
								        	}
								        },
						                {
						                	xtype: 'textfieldbase',
						                	fieldLabel: HreRem.i18n('fieldlabel.ultima.modificacion'),
						                	name: 'ultimaModEstAct',
						                	readOnly: true,
						                	bind: {
						                		value: '{activo.diasCambioEstadoActivo}',
						                		hidden: '{!activo.isCarteraBankia}',
						                		readOnly: true
						                	}
						                },
					   				 	{
						                	xtype: 'comboboxfieldbasedd',
						                	fieldLabel:  HreRem.i18n('fieldlabel.estado.registral'),
						                	name: 'comboEstadoRegistral',
						                	reference: 'comboEstadoRegistralRef',
						                	bind: {
							                	store: '{comboEstadoRegistral}',
							                	value: '{activo.estadoRegistralCodigo}',
							                	readOnly: '{!activo.esEditableActivoEstadoRegistral}',
												rawValue: '{activo.estadoRegistralDescripcion}'
						                	}
						                },
							            {
						                	xtype: 'numberfieldbase',
											symbol: HreRem.i18n("symbol.porcentaje"),
						                	fieldLabel:  HreRem.i18n('fieldlabel.porcentaje.construccion'),
						                	name: 'porcentajeConstruccion',
						                	reference: 'porcentajeConstruccion',
						                	maskRe: /[0-9.]/,
						                	bind: {
						                		readOnly: '{isCarteraBankiayEditarPorcentajeConstruccion}',
						                		value: '{activo.porcentajeConstruccion}'
						                	},
						                	validator: function(v) {
				                            	if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
					                            	return false;
				                            	}
					                            return true;
					                        }
						                }

									]
								},
								//PARA DIVARIAN
						        {
						        	xtype: 'comboboxfieldbasedd',
						        	fieldLabel: HreRem.i18n('fieldlabel.sociedad.pago'),
						        	bind: { 
						        		value: '{activo.sociedadPagoAnterior}',
						        		store: '{comboSituacionPagoAnterior}',
						        		readOnly: '{!activo.isSubcarteraDivarian}',
						        		hidden: '{!activo.isSubcarteraDivarian}',
										rawValue: '{activo.sociedadPagoAnteriorDescripcion}'

						        	}
						        }								
							]
						},
						{ // Columna 3 
							defaultType: 'textfieldbase',
							flex: 1,
							items:[
								{
				                	xtype: 'textareafieldbase',
				                	labelWidth: 200,
				                	rowspan: 5,
				                	height: 130,
				                	labelAlign: 'top',
				                	fieldLabel: HreRem.i18n('fieldlabel.breve.descripcion.activo'),
				                	bind:{
				                		value: '{activo.descripcion}'
				                	}
				                }, 
				                {
				                	xtype: 'comboboxfieldbasedd',
				                	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo.DND'),
				                	name: 'comboEstadoFisicoActivoDND',
				                	reference: 'comboEstadoFisicoActivoDNDRef',
				                	bind: {			                		
				                		value: '{activo.estadoFisicoActivoDND}',
				                		store: '{comboEstadoActivoDND}',
				                		readOnly:true,
										rawValue: '{activo.estadoFisicoActivoDNDDescripcion}'
				                	}
				                },   
				                {
									xtype:'comboboxfieldbasedd',
									fieldLabel: HreRem.i18n('fieldlabel.activobbva.tipoTransmision'),
									bind: {
										readOnly : '{!isGestorAdmisionAndSuper}',
										store: '{comboTipoTransmision}',
										value: '{activo.tipoTransmisionCodigo}',
										rawValue: '{activo.tipoTransmisionDescripcion}'
									}
								},
							 	{
									xtype:'comboboxfieldbasedd',
									fieldLabel: HreRem.i18n('fieldlabel.tipo.procedencia.producto'),
									bind: {
										readOnly : true,
										hidden: '{!activo.isCarteraBankia}',
										store: '{comboTipoProcedenciaProducto}',
										value: '{activo.procedenciaProductoTransmisionCodigo}',
										rawValue: '{activo.procedenciaProductoDescripcion}'
									}
								},
								{
									xtype:'comboboxfieldbasedd',
									reference: 'tipoAltaRef',
									fieldLabel: HreRem.i18n('fieldlabel.activobbva.tipoAlta'),									
									bind: {
										readOnly : '{!isGestorAdmisionAndSuperComboTipoAltaBlo}',										
										store: '{comboBBVATipoAlta}',
										hidden: '{!activo.isCarteraBbva}',
										value: '{activo.tipoAltaCodigo}',
										rawValue: '{activo.tipoAltaDescripcion}'
									}/*,listeners:{
										beforerender:'isGestorAdmisionAndSuperComboTipoAlta'
									}*/
									
								},				                				                
				                {
				                	xtype: 'comboboxfieldbasedd',
				                	fieldLabel:  HreRem.i18n('fieldlabel.tipo.segmento'),
				                	name: 'combotipoSegmento',
				                	reference: 'comboTipoSegmentoRef',
				                	bind: {
				                		store: '{comboTipoSegmento}',
				                		value: '{activo.tipoSegmentoCodigo}',
				                		hidden: '{!mostrarCamposDivarianandBbva}',
				                		readOnly : '{!editarSegmentoDivarianandBbva}',
										rawValue: '{activo.tipoSegmentoDescripcion}'
				                	}
				                }
				               
				            ]
						}
					]},
	                {    
		                //BBVA
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.bbva'),
						border: true,
						colspan: 3,
						bind:{hidden: '{!activo.isCarteraBbva}'},
						items :
							[
							{
								xtype:'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.activobbva.numActivoBbva'),
								bind: {
									readOnly:true,
									value: '{activo.numActivoBbva}'
								}
							},
							{
								xtype:'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.activobbva.lineaFactura'),
								bind: {
									readOnly : '{esUaSinImportarEstado}',
									value: '{activo.lineaFactura}'
								}
							},
			                {
								xtype:'numberfieldbase',
								reference:'labelLinkIdOrigenHRE',
								fieldLabel: HreRem.i18n('fieldlabel.activobbva.idOrigenHre'),
								bind: {
									readOnly : '{!isGestorAdmisionAndSuper}',
									value: '{activo.idOrigenHre}'
								},
								cls: 'show-text-as-link',
								listeners: {
							        click: {								        	
							            element: 'el', 
							            fn:'onClickActivoHRE'									       
							        }
								}
							}, 
		                	{
								xtype:'textfieldbase',
								reference:'tfcodpromocionbbva',
								fieldLabel: HreRem.i18n('fieldlabel.activobbva.codPromocionBbva'),
								bind: {
									readOnly : '{!isGestorOSupervisorAdmisionAndSuper}',
									value: '{activo.codPromocionBbva}'
								}
							}
			 			                
					],
	                bind:{
	                	hidden: '{!activo.isCarteraBbva}'
	                	}
	                },
	                {    
		                //DATOS PRINEX
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.datos.prinex'),
						border: true,
						colspan: 3,
						bind:{hidden: '{!activo.isCarterasCajamarLiberbank}'},
						items :
							[
							{
			                	xtype: 'comboboxfieldbasedd',
			                	fieldLabel:  HreRem.i18n('fieldlabel.disponible.administrativo'),
			                	name: 'comboDisponibleAdministrativo',
			                	reference: 'comboDisponibleAdministrativoRef',
			                	bind: {
			                		store: '{comboDisponibleAdministrativo}',
			                		value: '{activo.disponibleAdministrativoCodigo}',
									rawValue: '{activo.disponibleAdministrativoDescripcion}'
			                	}
			                },
			                {
			                	xtype: 'comboboxfieldbasedd',
			                	fieldLabel:  HreRem.i18n('fieldlabel.disponible.tecnico'),
			                	name: 'comboDisponibleTecnico',
			                	reference: 'comboDisponibleTecnicoRef',
			                	bind: {
			                		store: '{comboDisponibleTecnico}',
			                		value: '{activo.disponibleTecnicoCodigo}',
									rawValue: '{activo.disponibleTecnicoDescripcion}'
			                	}
			                },
			                {
			                	xtype: 'comboboxfieldbasedd',
			                	fieldLabel:  HreRem.i18n('fieldlabel.motivo.tecnico'),
			                	name: 'comboMotivoTecnico',
			                	reference: 'comboMotivoTecnicoRef',
			                	bind: {
			                		store: '{comboMotivoTecnico}',
			                		value: '{activo.motivoTecnicoCodigo}',
									rawValue: '{activo.motivoTecnicoDescripcion}'
			                	}
			                }
			 			                
					],
	                bind:{
	                	hidden: '{!activo.isCarterasCajamarLiberbank}'
	                	}
	                }
				]
            },
            {    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.direccion'),
				items :
					[
						// fila 1
						{							
							xtype: 'comboboxfieldbasedd',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
				        	bind: {
			            		store: '{comboTipoVia}',
			            		value: '{activo.tipoViaCodigo}',
								rawValue: '{activo.tipoViaDescripcion}'
			            	},
    						allowBlank: false
						},
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							reference: 'provinciaCombo',
							chainedStore: 'comboMunicipioDatosBasicos',
							chainedReference: 'municipioCombo',
			            	bind: {
			            		readOnly : '{esUA}',
			            		store: '{comboProvincia}',
			            	    value: '{activo.provinciaCodigo}',
								rawValue: '{activo.provinciaDescripcion}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo',
								change: 'onChangeProvincia'

    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.latitud'),
							bind: {
								value: '{activo.latitud}',
			            		readOnly:'{!activo.isCarteraBankia}'	
							}
		                },		
						{							
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo.via.oe'),
				        	bind: {
			            		store: '{comboTipoVia}',
			            		value: '{activo.tipoViaCodigoOE}',
			            		hidden: '{!activo.isCarteraSareb}', 
			            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'			            		
			            	}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia.oe'),
							reference: 'provinciaCombo',
							chainedStore: 'comboMunicipioOE',
							chainedReference: 'municipioComboOE',
			            	bind: {
			            		readOnly : '{!esSuperUsuarioCalidadDatoAndNoUA}',
			            		store: '{comboProvinciaOE}',
			            	    value: '{activo.provinciaCodigoOE}',
			            		hidden: '{!activo.isCarteraSareb}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo',
								change: 'onChangeProvincia'

    						}
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.latitud.oe'),
							readOnly	: true,
							bind: {	
									value:'{activo.latitudOE}',
				            		hidden: '{!activo.isCarteraSareb}'
								}
		                },
						// fila 2	
						
						{ 
							fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
		                	bind:{
		                		value: '{activo.nombreVia}'
		                	},
		                	allowBlank: false
		                },
		                {
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('fieldlabel.municipio'),
							reference: 'municipioCombo',
							chainedStore: 'comboInferiorMunicipio',
							chainedReference: 'inferiorMunicipioCombo',
			            	bind: {
			            		readOnly : '{esUA}',
			            		store: '{comboMunicipioDatosBasicos}',
			            		value: '{activo.municipioCodigo}',
			            		disabled: '{!activo.provinciaDescripcion}',
								rawValue: '{activo.municipioDescripcion}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.longitud'),
							bind: {
								value: '{activo.longitud}',
			            		readOnly:'{!activo.isCarteraBankia}'	
							}
		                }, 
						{ 
							fieldLabel:  HreRem.i18n('fieldlabel.nombre.via.oe'),
		                	bind:{
		                		value: '{activo.nombreViaOE}',
			            		hidden: '{!activo.isCarteraSareb}', 
			            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'
		                	}
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio.oe'),
							reference: 'municipioComboOE',
							chainedStore: 'comboInferiorMunicipioOE',
							chainedReference: 'inferiorMunicipioComboOE',
			            	bind: {
			            		readOnly : '{!esSuperUsuarioCalidadDatoAndNoUA}',
			            		store: '{comboMunicipioOE}',
			            		value: '{activo.municipioCodigoOE}',
			            		disabled: '{!activo.provinciaCodigoOE}',
			            		hidden: '{!activo.isCarteraSareb}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						}
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.longitud.oe'),
							readOnly: true,
							bind:{ 
								value: '{activo.longitudOE}',
			            		hidden: '{!activo.isCarteraSareb}'
							}
		                }, 
		                // fila 3               
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
		                	colspan: 3,
		                	bind:{
		                		value: '{activo.numeroDomicilio}'
		                	}
		                },
		                { 
							fieldLabel: HreRem.i18n('fieldlabel.calle.dos'),
							xtype: 'textfieldbase',
							//colspan: 3,							
							bind:{
								hidden: '{!activo.isCarteraBankia}',
								value:'{activo.direccionDos}'
							}
		                },
		                { 
							fieldLabel: HreRem.i18n('fieldlabel.activo.bloque'),
							xtype: 'textfieldbase',
							//colspan: 3,
							maxLength: 10,
							bind:{
								hidden: '{!activo.isCarteraBankia}',
								value:'{activo.bloque}'
							}
		                },
		                {
							xtype: 'comboboxfieldbasedd',
							fieldLabel:  HreRem.i18n('fieldlabel.unidad.poblacional'),
							reference: 'inferiorMunicipioCombo',
			            	bind: {
			            		readOnly : '{esUA}',
			            		store: '{comboInferiorMunicipio}',
			            		value: '{activo.inferiorMunicipioCodigo}',
			            		disabled: '{!activo.municipioDescripcion}',
								rawValue: '{activo.inferiorMunicipioDescripcion}'
			            	},
			            	tpl: Ext.create('Ext.XTemplate',
			            		    '<tpl for=".">',
			            		        '<div class="x-boundlist-item">{descripcion}</div>',
			            		    '</tpl>'
			            	),
			            	displayTpl: new Ext.XTemplate(
			            	        '<tpl for=".">' +
			            	        '{[typeof values === "string" ? values : values["descripcion"]]}' +
			            	        '</tpl>'
			            	)
						},
		          
		                // fila 4
		                {
							fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
			                bind:{
			                	value: '{activo.escalera}',
			                	hidden: '{activo.isCarteraBankia}'
			                }
						},
						{
							xtype: 'comboboxfieldbasedd',
							reference: 'escaleraEdificioRef',
							fieldLabel: HreRem.i18n('fieldlabel.escalera'),
							name: 'escaleraEdificioCodigo',
			            	bind: {
			            		store: '{comboEscalera}',
			            		hidden: '{!activo.isCarteraBankia}',
			            		value: '{activo.escaleraEdificioCodigo}',
								rawValue: '{activo.escaleraEdificioDescripcion}'
			            	}
						},
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.numero.oe'),
		                	colspan: 2,
		                	bind:{
		                		value: '{activo.numeroDomicilioOE}',
			            		hidden: '{!activo.isCarteraSareb}', 
			            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'
		                	}
		                },
		                {
							fieldLabel:  HreRem.i18n('fieldlabel.escalera.oe'),
			                bind:{
			                	value: '{activo.escaleraOE}',
			            		hidden: '{!activo.isCarteraSareb}', 
			            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'
			                }
						},
				        { 
				        	xtype: 'comboboxfieldbasedd',
				        	fieldLabel:  HreRem.i18n('fieldlabel.comunidad.autonoma'),
				        	forceSelection: true,
				        	readOnly: true,
				        	bind: {		
				        		store: '{storeComunidadesAutonomas}',
			            		value: '{activo.provinciaCodigo}',
								rawValue: '{activo.provinciaDescripcion}'
			            	},
							valueField: 'id',
							allowBlank: false
								
					     },
				        {
			                	xtype: 'button',
			                	reference: 'botonVerificarDireccion',
			                	disabled: true,
			                	bind:{
			                		disabled: '{editableTipoActivo}'
			                	},
			                	rowspan: 2,
			                	text: HreRem.i18n('btn.verificar.direccion'),
			                	handler: 'onClickVerificarDireccion'
			                	
			             },
						 // fila 5
 						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
		                	bind:{
		                		value: '{activo.piso}',
		                		hidden: '{activo.isCarteraBankia}'
		                	}
		                },
						{
							xtype: 'comboboxfieldbasedd',
							reference: 'plantaEdificioRef',
							fieldLabel: HreRem.i18n('fieldlabel.planta'),
							name: 'plantaEdificioCodigo',
			            	bind: {
			            		store: '{comboPlanta}',
			            		hidden: '{!activo.isCarteraBankia}',
			            		value: '{activo.plantaEdificioCodigo}',
								rawValue: '{activo.plantaEdificioDescripcion}'
			            	}
						},	               
		                {
							xtype: 'comboboxfieldbasedd',
							reference: 'pais',
							fieldLabel: HreRem.i18n('fieldlabel.pais'),
			            	bind: {
			            		readOnly : '{esUA}',
			            		store: '{comboCountries}',
			            		value: '{activo.paisCodigo}',
								rawValue: '{activo.paisDescripcion}'
			            	},
    						colspan: 2,
    						allowBlank: false
		                	
						},
 						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.planta.oe'),
		                	bind:{
		                		value: '{activo.pisoOE}',
			            		hidden: '{!activo.isCarteraSareb}', 
			            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'
		                	}
		                },	
						// fila 6
						 { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
		                	bind:{
		                		value: '{activo.puerta}'
		                	}
		                },
		                {
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
							bind:{
								value: '{activo.codPostal}',
								readOnly : '{esUA}'
							},
							colspan: 3,
							vtype: 'codigoPostal',
							maskRe: /^\d*$/, 
		                	maxLength: 5,
							allowBlank: false,
							listeners:{
								change: 'onChangeCodPostal'
							}
						},
		                {
							xtype:'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('fieldlabel.distrito.caixa'),
							reference: 'distritoCaixaRef',
							bind: {
								//readOnly : '{!isGestorAdmisionAndSuper}',
								bind:{hidden: '{!activo.isCarteraBankia}'},
								store: '{comboDistritoCodPostal}',
								value: '{activo.tipoDistritoCodigoPostalCod}',
								rawValue: '{activo.tipoDistritoCodigoPostalDesc}'
							}	                	
						},
						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.puerta.oe'),
		                	bind:{
		                		value: '{activo.puertaOE}',
			            		hidden: '{!activo.isCarteraSareb}', 
			            		readOnly:'{!esSuperUsuarioCalidadDatoAndNoUA}'
		                	}
		                },
		                {
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal.oe'),
							bind:{
								value: '{activo.codPostalOE}',
								readOnly : '{!esSuperUsuarioCalidadDatoAndNoUA}',
			            		hidden: '{!activo.isCarteraSareb}'
							},
							colspan: 2,
							vtype: 'codigoPostal',
							maskRe: /^\d*$/, 
		                	maxLength: 5		                	        	
						}
					]               
          	},
          	// Perimetros  BBVA-----------------------------------------------
          	{    
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.perimetros'),
				hidden:!$AU.userIsRol(CONST.PERFILES['CARTERA_BBVA']),
				bind: {
					hidden: '{esUsuarioTasadora}'
				},
				items :[					
					{
						xtype: 'datefieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.perimetro.fecha.alta.activo'),
						colspan: 2,
						bind:		'{activo.fechaAltaActivoRem}',
						readOnly	: true
					}
				]
 			},
          	// Perimetros -----------------------------------------------
            {    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.perimetros'),
				hidden: $AU.userIsRol(CONST.PERFILES['CARTERA_BBVA']) || $AU.userIsRol(CONST.PERFILES['USUARIOS_BC']) || $AU.userIsRol(CONST.PERFILES["TASADORA"]),
				items :
					[
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.perimetro.incluido'),
						bind : '{activo.incluidoEnPerimetro}', 
						valueToRaw: function(value) { return Utils.rendererBooleanToSiNo(value); },
						readOnly	: true
					},
					{
						xtype: 'datefieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.perimetro.fecha.alta.activo'),
						colspan: 2,
						bind:		'{activo.fechaAltaActivoRem}',
						readOnly	: true
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.perimetro.ofertas.vivas'),
						colspan: 1,
						bind:{
								value:'{activo.ofertasVivas}'		
						},
						readOnly	: true,
						listeners: {
						   'render': function(panel) {
						       if($AU.userIsRol(CONST.PERFILES['CARTERA_BBVA'])){
						    	  this.colspan = 3;
						       }
						    }
						}
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.perimetro.trabajos.vivos'),
						colspan: 2,
						bind: {
							value: '{activo.trabajosVivos}',
							hidden: $AU.userIsRol(CONST.PERFILES['CARTERA_BBVA'])
						},
						readOnly	: true
					},
					
		            {    
		                
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.perimetros.condiciones'),
						border: true,
						colapsible: false,
						colspan: 3,
						items :
							[
							//Fila cabecera
							{
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.modulos.in.ex'),
								readOnly	: true
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.fecha.in.ex'),
								readOnly	: true
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.motivo.in.ex'),
								readOnly	: true
							},
							
							//Fila Admision (Siempre oculto por el momento)
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.admision'),
								bind:		'{activo.aplicaTramiteAdmision}',
								reference: 'chkbxPerimetroAdmision',
								listeners: {
									change: 'onChkbxPerimetroChange'
								},
								hidden: true
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaTramiteAdmision}',
								reference: 'datefieldPerimetroAdmision',
								readOnly: true,
								hidden: true
							},
							{
								xtype: 'textfieldbase',
								bind:		'{activo.motivoAplicaTramiteAdmision}',
								hidden: true
							},
							//Fila Admision
							{
								xtype: 'checkboxfieldbase',
								reference: 'perimetroAdmision',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.admision'),
								bind : {
									value : '{activo.perimetroAdmision}'
								},
								listeners: {
									change: 'onChkbxPerimetroChange'
								}
							},
							{
								xtype: 'datefieldbase',
								bind: '{activo.fechaPerimetroAdmision}',
								reference: 'datefieldPerimetroAdmision',
								readOnly: true
							},
							{
								xtype: 'textfieldbase',
								reference: 'textFieldPerimetroAdmision',
								bind:{
									value: '{activo.motivoPerimetroAdmision}',
									readOnly: '{activo.isCarteraBankia}'
								}
							},
							
							//Fila gestion
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.gestion'),
								bind:{
									value: '{activo.aplicaGestion}'
								},
								reference: 'chkbxPerimetroGestion',
								listeners: {
									change: 'onChkbxPerimetroChange'
								}
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaGestion}',
								reference: 'datefieldPerimetroGestion',
								readOnly: true
							},
							{
								xtype: 'textfieldbase',
								reference: 'textFieldPerimetroGestion',
								bind:{
									value: '{activo.motivoAplicaGestion}',
									readOnly: '{activo.isCarteraBankia}'
								}		
							},
							
							//Fila mediador  (Siempre oculto por el momento)
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.mediador'),
								bind:		'{activo.aplicaAsignarMediador}',
								reference: 'chkbxPerimetroMediador',
								listeners: {
									change: 'onChkbxPerimetroChange'
								},
								hidden: true
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaAsignarMediador}',
								reference: 'datefieldPerimetroMediador',
								readOnly: true,
								hidden: true
							},
							{
								xtype: 'textfieldbase',
								bind:		'{activo.motivoAplicaAsignarMediador}',
								hidden: true
							},
							
							//Fila publicacion
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.publicacion'),
								reference: 'chkbxPerimetroPublicar',
								bind: {
									readOnly: '{esSuperUsuarioCaixa}', //TODO
									value: '{activo.aplicaPublicar}'
								},
								listeners: {
									change: 'onChkbxPerimetroChange'
								}
							},
							{
								xtype: 'datefieldbase',
								bind: '{activo.fechaAplicaPublicar}',
								reference: 'datefieldPerimetroPublicar',
								readOnly: true
							},
							{
								xtype: 'textfieldbase',
								reference: 'textFieldPerimetroPublicar',
								bind: {
									value: '{activo.motivoAplicaPublicar}',
									readOnly: '{activo.isCarteraBankia}'
								}
							},

							//Fila comercializar
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.comercial'),
								reference: 'chkbxPerimetroComercializar',
								bind: {
									readOnly: '{esSuperUsuarioCaixa}', //TODO
									value: '{activo.aplicaComercializar}'
								},
								listeners: {
									change: 'onChkbxPerimetroChange'
								}
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaComercializar}',
								reference: 'datefieldPerimetroComercializar',
								readOnly: true
							},
							{
								xtype: 'comboboxfieldbasedd',
								reference: 'comboMotivoPerimetroComer',
								bind: {
									store: '{comboMotivoAplicaComercializarActivo}',
									value: '{activo.motivoAplicaComercializarCodigo}',
									visible: '{activo.aplicaComercializar}',
									readOnly: '{activo.isCarteraBankia}',
									rawValue: '{activo.motivoAplicaComercializarDescripcion}'
								}
							},
							{
								xtype: 'textfieldbase',
								reference: 'textFieldPerimetroComer',
								visible: false,
								maxLength: '256',
								bind: {
									value: '{activo.motivoNoAplicaComercializar}',
									visible: '{!activo.aplicaComercializar}',
									readOnly: '{activo.isCarteraBankia}'
								}
							},

							//Fila formalizar
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.formalizar'),
								reference: 'chkbxPerimetroFormalizar',
								bind: {
									value: '{activo.aplicaFormalizar}',
									readOnly: '{esSuperUsuarioCaixa}'
									//readOnly: '{activo.checkFormalizarReadOnly}'
								},
								listeners: {
									change: 'onChkbxPerimetroChange'
								}
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaFormalizar}',
								reference: 'datefieldPerimetroFormalizar',
								readOnly: true
							},
							{
								xtype: 'textfieldbase',
								reference: 'textFieldPerimetroFormalizar',
								bind: {
									value: '{activo.motivoAplicaFormalizar}',
									readOnly: '{activo.isCarteraBankia}'
								}
							},
							//Fila Condiciones de inclusión en perímetro Haya						
							
							//Fila gestión comercial
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.gestion.comercial'),
								reference: 'checkGestionComercial',
								bind: {
									value: '{activo.checkGestorComercial}',
									readOnly: '{esEditableExcluirValidaciones}'
								}
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaGestionComercial}',
								reference: 'datefieldFechaGestionComercial',
								readOnly: '{esEditableExcluirValidaciones}'
							},
							
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.excluir.validaciones'),
								reference: 'checkExclusionGestionComercial',
								bind: {
									value: '{activo.excluirValidacionesBool}', 
									readOnly: '{esEditableExcluirValidaciones}'
								},
								listeners: {
									change: 'onChkbxExclValPerimetroChange'
								}
							},
							{
								xtype: 'textfieldbase',
								readOnly : true,
								colspan: 2
							},
							
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetros.motivoDeExcluido'),
								reference: 'comboMotivoGestionComercial',
								bind: {
									store: '{comboMotivoGestionComercialActivo}',
									value: '{activo.motivoGestionComercialCodigo}',
									readOnly: '{esEditableExcluirValidaciones}',
									allowBlank:'{!activo.excluirValidacionesBool}',
									disabled:'{!activo.excluirValidacionesBool}'
								}
							},

							
							//Bloque Comercialización
							{    
								xtype:'fieldsettable',
								defaultType: 'textfieldbase',
								title: HreRem.i18n('title.perimetros.comercializacion'),
								reference: 'bloquecomercializable',
								bind:{visible: '{activo.aplicaComercializar}'},
								border: true,
								colapsible: false,
								colspan: 3,
								items :
									[
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.tipo.comercializacion'),
										bind: {
											readOnly: '{esUA}',
											store: '{comboTipoComercializarActivo}',
											value: '{activo.tipoComercializarCodigo}',
											rawValue: '{activo.tipoComercializarDescripcion}'
										}
									},
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
										bind: {
//											readOnly : '{!activo.esEditableDestinoComercial}',
											readOnly : '{esEditableDestinoComercialOresBankia}',
											disabled: '{activo.isPANoDadaDeBaja}',
											store: '{comboTipoDestinoComercialCreaFiltered}',
											value: '{activo.tipoComercializacionCodigo}',
											rawValue: '{activo.tipoComercializacionDescripcion}'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.bloqueo.tipo.comercializacion'),
										labelWidth: 200,
										bind: {
											readOnly: '{esUA}',
											store : '{comboSiNoBoolean}',
											value: '{activo.bloqueoTipoComercializacionAutomatico}'
										}
									},
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.tipo.alquiler'),
										readOnly: true,
										bind: {
											store: '{comboTipoAlquiler}',
											disabled: '{!activo.isDestinoComercialAlquiler}',
											value: '{activo.tipoAlquilerCodigo}',
											rawValue: '{activo.tipoAlquilerDescripcion}'
										}
									},
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.equipo.gestion'),
										bind: {
											readOnly: '{!esSuperUsuario}',
											store: '{comboEquipoGestion}',
											value: '{activo.tipoEquipoGestionCodigo}',
											rawValue: '{activo.tipoEquipoGestionDescripcion}'
										}
									}
									]
							},
						
							//Bloque Comercialización
							{    
								xtype:'fieldsettable',
								defaultType: 'textfieldbase',
								title: HreRem.i18n('title.perimetros.comercializacion'),
								reference: 'bloquenocomercializable',
								bind:{visible: '{!activo.aplicaComercializar}'},
								border: true,
								colapsible: false,
								colspan: 3,
								items :
									[
									//Disponibilidad Comercial
									{
										xtype: 'textfieldbase',
										fieldLabel: HreRem.i18n('title.publicaciones.estadoDisponibilidadComercial'),
										bind : {
											value: '{activo.situacionComercialDescripcion}'
										}, 
										readOnly	: true
									},
									{
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.equipo.gestion'),
										readOnly: true,
										bind: {
											store: '{comboEquipoGestion}',
											value: '{activo.tipoEquipoGestionCodigo}',
											rawValue: '{activo.tipoEquipoGestionDescripcion}'
										}
									}
									]
							},
							// Bloque administración
							{    
								xtype:'fieldsettable',
								defaultType: 'textfieldbase',
								title: HreRem.i18n('title.perimetros.administracion'),
								reference: 'bloqueadministracion',
								bind:{hidden: '{!activo.isCarteraBankia}'},
								border: true,
								colapsible: true,
								colspan: 3,
								items :
									[
										{
											xtype:'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.perimetros.administracion.num.inmovilizado.bankia'),
											maxLength: 9,
											maskRe: /[0-9]/,
											readOnly: true,
											bind: {
												hidden: '{!activo.isCarteraBankia}',
												value: '{activo.numInmovilizadoBankia}'
											}
										}
									]
							}
							
						]
					}, //Fin condiciones
					//Datos bancarios
		            {    
		                
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.bancario'),
						border: true,
						colapsible: false,
						colspan: 3,
						items :
							[
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.clase'),
								reference: 'claseActivoBancarioCombo',
					        	chainedStore: 'comboSubtipoClaseActivoBancario',
								chainedReference: 'subtipoClaseActivoBancarioCombo',
								bind: {
									readOnly : '{esUA}',
									store: '{comboClaseActivoBancario}',
									value: '{activo.claseActivoCodigo}',
									rawValue: '{activo.claseActivoDescripcion}'
								},
	    						listeners: {
				                	select: 'onChangeChainedCombo'
				            	},
								allowBlank: false
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.expediente.num'),
								bind:{
									readOnly : '{esUA}',
									value: '{activo.numExpRiesgo}' 
								}
							},
							{
								xtype:'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.producto.tipo'),
								bind:{
									value: '{activo.productoDescripcion}',
									readOnly : '{esUA}'
								}
                            },
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.subtipo'),
								reference: 'subtipoClaseActivoBancarioCombo',
								bind: {
									readOnly : '{esUA}',
									store: '{comboSubtipoClaseActivoBancario}',
									value: '{activo.subtipoClaseActivoCodigo}',
									disabled: '{!activo.claseActivoCodigo}',
									rawValue: '{activo.subtipoClaseActivoDescripcion}'
								}
							},
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.expediente.estado'),
								bind: {
									readOnly : '{esUA}',
									store: '{comboEstadoExpRiesgoBancario}',
									value: '{activo.estadoExpRiesgoCodigo}',
									rawValue: '{activo.estadoExpRiesgoDescripcion}'
								}
							},
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.incorriente.estado'),
								bind: {
									readOnly : '{esUA}',
									store: '{comboEstadoExpIncorrienteBancario}',
									value: '{activo.estadoExpIncorrienteCodigo}',
									rawValue: '{activo.estadoExpIncorrienteDescripcion}'
								}
							},
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.categoria.comercializacion'),
								bind: {
									//readOnly : '{esUA}',
									hidden: '{!activo.isCarteraBankia}',
									store: '{comboCategoriaComercializacion}',
									value: '{activo.categoriaComercializacionCod}',
									rawValue: '{activo.categoriaComercializacionDesc}'
								}
							},
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.entrada.activo.bankia.coenae'),
								bind: {
									readOnly : '{esUA}',
									store: '{comboEntradaActivoBankia}',
									hidden: '{!activo.isCarteraTitulizadayBankia}',
									value: '{activo.entradaActivoBankiaCodigo}',
									rawValue: '{activo.entradaActivoBankiaDescripcion}'
								}
							},
							{
								xtype:'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.activobbva.iucBbva'),
								bind: {
									readOnly : '{!isGestorAdmisionAndSuper}',
									hidden: '{!activo.isCarteraBbva}',
									value: '{activo.uicBbva}'
								}
							},
							{
								xtype:'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.activobbva.cexperBbva'),
								bind: {
									readOnly : '{!isGestorAdmisionAndSuper}',
									hidden: '{!activo.isCarteraBbva}',
									value: '{activo.cexperBbva}'
								}
							}
						]
						
					}, //Fin activo bancario
					//Activo EPA
		            {
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.epa'),
						border: true,
						colapsible: false,
						hidden: !isCarteraBbva,
						readOnly : usuariosValidos,
						colspan: 3,
						items :
							[
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.activo.epa'),
								reference: 'activoEpa',
								colspan: 4,
								bind: {
									readOnly : '{esUA}',
									store: '{comboSiNoBoolean}',
									value: '{activo.activoEpa}'
								},
	    						listeners: {
				                	change:  'onActivoEpa'
				            	}
							},
							{    
				                
								xtype:'fieldsettable',
								defaultType: 'textfieldbase',
								title: HreRem.i18n('title.mora'),
								border: true,
								colapsible: false,
								colspan: 3,
								items :
									[
									{
										xtype:'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.activobbva.empresa'),
										reference: 'activobbvaEmpresa',
										bind: {
											readOnly : '{esUA}',
											value: '{activo.empresa}'
										},
										listeners: {
						                	change:  'onActivoEpa'
						            	}
									},
									{
										xtype:'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.activobbva.oficina'),
										reference: 'activobbvaOficina',
										bind: {
											readOnly : '{esUA}',
											value: '{activo.oficina}'
										},
										listeners: {
						                	change:  'onActivoEpa'
						            	}
									},
									{
										xtype:'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.activobbva.contrapartida'),
										reference: 'activobbvaContrapartida',
										bind: {
											readOnly : '{esUA}',
											value: '{activo.contrapartida}'
										},
										listeners: {
						                	change:  'onActivoEpa'
						            	}
									},
									{
										xtype:'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.activobbva.folio'),
										reference: 'activobbvaFolio',
										bind: {
											readOnly : '{esUA}',
											value: '{activo.folio}'
										},
										listeners: {
						                	change:  'onActivoEpa'
						            	}
									},
									{
										xtype:'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.activobbva.cdpen'),
										reference: 'activobbvaCdpen',
										bind: {
											readOnly : '{esUA}',
											value: '{activo.cdpen}'
										},
										listeners: {
						                	change:  'onActivoEpa'
						            	}
									}
								]
						}]
					}, //Fin activo EPA
					
		            {//Per�metro e    
		                
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						bind:{
							title: '{mostrarTitlePerimetroDatosBasicos}',
							hidden: '{!activo.isAppleOrDivarian}'
						},						
						border: true,
						colapsible: false,
						colspan: 3,
						items :
							[
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.apple.servicer'),	
								reference: 'comboPerimetroAppleServicer',
								chainedStore: 'comboCesionSaneamiento',
								chainedReference: 'comboPerimetroAppleCesion',					        	
								bind: {
									readOnly : !$AU.userIsRol("HAYASUPER"),
									store: '{comboServicerActivo}',
									value: '{activo.servicerActivoCodigo}',
									hidden: '{!activo.isSubcarteraApple}',
									rawValue: '{activo.servicerActivoDescripcion}'
								},
								publishes: 'value',									
		    					listeners: {
									select: 'onChangeChainedCombo'
		    					}
	    													
							},
							{
								xtype:'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.apple.cesion'),
								reference: 'comboPerimetroAppleCesion',
								bind:{
									readOnly : !$AU.userIsRol("HAYASUPER"),
									store: '{comboCesionSaneamiento}',									
									value: '{activo.cesionSaneamientoCodigo}',
									hidden: '{!activo.isSubcarteraApple}',
									rawValue: '{activo.cesionSaneamientoDescripcion}'
								}
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.apple.macc.perimetro'),
								reference: 'comboPerimetroAppleMACC',
								bind:{
									readOnly : '{!esEditablePerimetroMacc}',
									store: '{comboSiNoDatosPerimetroApple}',
									value: '{activo.perimetroMacc}'	
								}
                            },
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.apple.cartera.perimetro'),
								reference: 'comboPerimetroAppleCartera',
								bind:{
									readOnly : !$AU.userIsRol("HAYASUPER"),
									store: '{comboSiNoDatosPerimetroApple}',
									value: '{activo.perimetroCartera}',
									hidden: '{!activo.isSubcarteraApple}'	
								}
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.apple.cartera.nombre'),
								reference: 'comboPerimetroAppleCarteraNombre',
								bind: {
									readOnly : !$AU.userIsRol("HAYASUPER"),									
									value: '{activo.nombreCarteraPerimetro}',
									hidden: '{!activo.isSubcarteraApple}'
								}
							}
						]
						
					} //Fin per�metro apple
				]
			}, //Fin perimetros
			{	// Histórico Destino Comercial ---------------------------------------------------------
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.historico.destino.comercial'),
				bind: {
					hidden: '{esUsuarioTasadora}'
				},
				items :
					[
					{
						xtype: 'historicodestinocomercialactivoform'
					}
					]
			} // Fin Histórico Destino Comercial
            
     ];
	me.addPlugin({ptype: 'lazyitems', items: items });
    me.callParent();    
    
   

    },
    afterLoad: function(){
    	var me = this;
    	me.lookupController().checkAdmision();
    	
    },
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
    },
    
    actualizarCoordenadas: function(latitud, longitud) {
    	var me = this;
    	
    	me.getBindRecord().set("longitud", longitud);
    	me.getBindRecord().set("latitud", latitud);
    	
    }
});