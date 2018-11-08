Ext.define('HreRem.view.activos.detalle.DatosBasicosActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosactivo',
    scrollable	: 'y',

	recordName: "activo",
	
	recordClass: "HreRem.model.Activo",
    
    requires: ['HreRem.model.Activo'],

    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.datos.basicos'));
        var items= [

			{   
				xtype:'fieldsettable',
				layout:'hbox',
				defaultType: 'container',
		        title: HreRem.i18n('title.identificacion'),
				items :
					[{  // Columna 1
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
			                	bind:		'{activo.numActivoUvem}'
			                },
			                {
			                	xtype: 'displayfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.rem'),
			                	bind:		'{activo.numActivoRem}'
			                },
			                {
								xtype: 'displayfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.id.bien.recovery'),
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
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
								reference: 'tipoActivo',
					        	chainedStore: 'comboSubtipoActivo',
								chainedReference: 'subtipoActivoCombo',
					        	bind: {
				            		store: '{comboTipoActivo}',
				            		value: '{activo.tipoActivoCodigo}'
				            	},
	    						listeners: {
				                	select: 'onChangeChainedCombo'
				            	},
				            	allowBlank: false
					        },
					        {
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
					        	reference: 'subtipoActivoCombo',
					        	bind: {
				            		store: '{comboSubtipoActivo}',
				            		value: '{activo.subtipoActivoCodigo}',
				            		disabled: '{!activo.tipoActivoCodigo}'
				            	},
	    						allowBlank: false
					        },
					        {
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.activo.bde'),
					        	reference: 'tipoActivoBde',
					        	bind: {
				            		store: '{comboTipoActivoBde}',
				            		value: '{activo.tipoActivoCodigoBde}',
				            		hidden: '{!activo.isCarteraLiberbank}'
				            	}

					        },
					        {
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo.bde'),
								reference: 'subtipoActivoComboBde',
					        	bind: {
				            		store: '{comboSubtipoActivoBde}',
				            		value: '{activo.subtipoActivoCodigoBde}',
				            		hidden: '{!activo.isCarteraLiberbank}'
				            	}
					        },
					        {
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
					        	name: 'estadoActivoCodigo',
					        	bind: {
				            		store: '{comboEstadoActivo}',
				            		value: '{activo.estadoActivoCodigo}'
				            	}
					        },
					        {
			                	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.uso.dominante'),
					        	name: 'tipoUsoDestinoCodigo',
			                	bind: {
				            		store: '{comboTipoUsoDestino}',
				            		value: '{activo.tipoUsoDestinoCodigo}'
				            	}
			                }
						]
					},{ // Columna 3
						defaultType: 'textfieldbase',
						flex: 1,
						items:[
							{
			                	xtype: 'textareafieldbase',
			                	labelWidth: 200,
			                	rowspan: 5,
			                	height: 160,
			                	labelAlign: 'top',
			                	fieldLabel: HreRem.i18n('fieldlabel.breve.descripcion.activo'),
			                	bind:		'{activo.descripcion}'
			                }
						]
					}]
           },
           
            {    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.direccion'),
				items :
					[
						// fila 1
						{							
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
				        	bind: {
			            		store: '{comboTipoVia}',
			            		value: '{activo.tipoViaCodigo}'			            		
			            	},
    						allowBlank: false
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							reference: 'provinciaCombo',
							chainedStore: 'comboMunicipio',
							chainedReference: 'municipioCombo',
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{activo.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo',
								change: 'onChangeProvincia'

    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.latitud'),
							readOnly	: true,
							bind:		'{activo.latitud}'
		                },						
						// fila 2	
						
						{ 
							fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
		                	bind:		'{activo.nombreVia}',
		                	allowBlank: false
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio'),
							reference: 'municipioCombo',
							chainedStore: 'comboInferiorMunicipio',
							chainedReference: 'inferiorMunicipioCombo',
			            	bind: {
			            		store: '{comboMunicipio}',
			            		value: '{activo.municipioCodigo}',
			            		disabled: '{!activo.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.longitud'),
							readOnly: true,
							bind:		'{activo.longitud}'
		                }, 
		                // fila 3               
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
		                	bind:		'{activo.numeroDomicilio}'
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.unidad.poblacional'),
							reference: 'inferiorMunicipioCombo',
			            	bind: {
			            		store: '{comboInferiorMunicipio}',
			            		value: '{activo.inferiorMunicipioCodigo}',
			            		disabled: '{!activo.municipioCodigo}'
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
						{
		                	xtype: 'button',
		                	reference: 'botonVerificarDireccion',
		                	disabled: true,
		                	bind:{
		                		disabled: '{!editing}'
		                	},
		                	rowspan: 2,
		                	text: HreRem.i18n('btn.verificar.direccion'),
		                	handler: 'onClickVerificarDireccion'
		                	
		                },	
		                // fila 4
		                {
							fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
			                bind:		'{activo.escalera}'
						},
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.comunidad.autonoma'),
				        	forceSelection: true,
				        	readOnly: true,
				        	bind: {		
				        		store: '{storeComunidadesAutonomas}',
			            		value: '{activo.provinciaCodigo}'
			            	},
							valueField: 'id',
							allowBlank: false
								
					     },					
						 // fila 5
 						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
		                	bind:		'{activo.piso}'
		                },	               
		                {
							xtype: 'comboboxfieldbase',
							reference: 'pais',
							fieldLabel: HreRem.i18n('fieldlabel.pais'),
			            	bind: {
			            		store: '{comboCountries}',
			            		value: '{activo.paisCodigo}'
			            	},
    						colspan: 2,
    						allowBlank: false
		                	
						},
						// fila 6
						 { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
		                	bind:		'{activo.puerta}'
		                },
		                {
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
							bind:		'{activo.codPostal}',
							colspan: 2,
							vtype: 'codigoPostal',
							maskRe: /^\d*$/, 
		                	maxLength: 5,
							allowBlank: false		                	
						}
												 
		               
					]               
          	},
          	// Perimetros -----------------------------------------------
            {    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.perimetros'),
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

							//Fila gestion
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.gestion'),
								bind:		'{activo.aplicaGestion}',
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
								bind:		'{activo.motivoAplicaGestion}'
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
									readOnly: '{activo.isVendido}' || '{esReadonlyChkbxPublicar}',
									value: '{activo.aplicaPublicar}'
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
									value: '{activo.motivoAplicaPublicar}'
								}
							},

							//Fila comercializar
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.comercial'),
								reference: 'chkbxPerimetroComercializar',
								bind: {
									value: '{activo.aplicaComercializar}',
									readOnly: '{activo.isVendido}'
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
								xtype: 'comboboxfieldbase',
								reference: 'comboMotivoPerimetroComer',
								bind: {
									store: '{comboMotivoAplicaComercializarActivo}',
									value: '{activo.motivoAplicaComercializarCodigo}',
									visible: '{activo.aplicaComercializar}'
								}
							},
							{
								xtype: 'textfieldbase',
								reference: 'textFieldPerimetroComer',
								visible: false,
								maxLength: '256',
								bind: {
									value: '{activo.motivoNoAplicaComercializar}',
									visible: '{!activo.aplicaComercializar}'
								}
							},

							//Fila formalizar
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.formalizar'),
								reference: 'chkbxPerimetroFormalizar',
								bind: {
									value: '{activo.aplicaFormalizar}',
									readOnly: '{activo.isVendido}'
									
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
									value: '{activo.motivoAplicaFormalizar}'
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
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.tipo.comercializacion'),
										bind: {
											store: '{comboTipoComercializarActivo}',
											value: '{activo.tipoComercializarCodigo}'
										}
									},
									{
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
										bind: {
											store: '{comboTipoDestinoComercialCreaFiltered}',
											value: '{activo.tipoComercializacionCodigo}',
											readOnly: '{activoPerteneceAgrupacionRestringida}'
										}
									},
									{
										xtype : 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.bloqueo.tipo.comercializacion'),
										labelWidth: 200,
										bind: {
											store : '{comboSiNoBoolean}',
											value: '{activo.bloqueoTipoComercializacionAutomatico}'
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
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.clase'),
								reference: 'claseActivoBancarioCombo',
					        	chainedStore: 'comboSubtipoClaseActivoBancario',
								chainedReference: 'subtipoClaseActivoBancarioCombo',
								bind: {
									store: '{comboClaseActivoBancario}',
									value: '{activo.claseActivoCodigo}'
								},
	    						listeners: {
				                	select: 'onChangeChainedCombo'
				            	},
								allowBlank: false
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.expediente.num'),
								bind: '{activo.numExpRiesgo}',
								readOnly: true
							},
							{
								xtype:'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.producto.tipo'),
								bind: '{activo.productoDescripcion}',
                                readOnly: true
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.subtipo'),
								reference: 'subtipoClaseActivoBancarioCombo',
								bind: {
									store: '{comboSubtipoClaseActivoBancario}',
									value: '{activo.subtipoClaseActivoCodigo}',
									disabled: '{!activo.claseActivoCodigo}'
								}
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.expediente.estado'),
								bind: {
									store: '{comboEstadoExpRiesgoBancario}',
									value: '{activo.estadoExpRiesgoCodigo}'
								}
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.incorriente.estado'),
								bind: {
									store: '{comboEstadoExpIncorrienteBancario}',
									value: '{activo.estadoExpIncorrienteCodigo}'
								}
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.entrada.activo.bankia.coenae'),
								bind: {
									store: '{comboEntradaActivoBankia}',
									hidden: '{!activo.isCarteraBankia}',
									value: '{activo.entradaActivoBankiaCodigo}'
								}
							}
						]
						
					} //Fin activo bancario
				]
			} //Fin perimetros
            
     ];
	me.addPlugin({ptype: 'lazyitems', items: items });
    me.callParent();    	
    	
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