Ext.define('HreRem.view.activos.ActivosSearch', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'activossearch',
    isSearchFormActivos : true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,
    layout: {
        type: 'accordion',
        titleCollapse: false,
        animate: true,
        vertical: true
        //multi: true
    },
    
    initComponent: function() {
    	
    	var me = this;   	
    	me.setTitle(HreRem.i18n('title.filtro.activos'));
    	me.items = [
    
    		{
    			xtype: 'panel',
    			layout: 'column',
    			cls: 'panel-busqueda-directa',
    			title: HreRem.i18n('title.busqueda.directa'),
    			collapsible: true,
    			collapsed: false,
			    defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfieldbase',
			        style: 'width: 25%'
			    },
			    items: [   
			    	{
			    	defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
			    	items:[
				        { 
				        	fieldLabel: HreRem.i18n('fieldlabel.numero.activo.haya'),
				        	name: 'numActivo',
				        	listeners : {
				        		change: 'onChangeNumActivo'
				        	} 
				        },
				        {
							xtype: 'comboboxfieldbasedd',
							name: 'carteraCodigo',  
			              	fieldLabel :  HreRem.i18n('fieldlabel.entidad.propietaria'),
			              	reference: 'comboCarteraSearch',
							bind: {
								store: '{comboCartera}'
							},
							listeners : {
			        			change: 'onChangeCartera'
			        		},
			            	publishes: 'value'
							
						},
						{ 
				        	xtype: 'comboboxfieldbasedd',
				        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
				        	name: 'subcarteraCodigo',
				        	reference: 'comboSubcarteraRef',
				        	bind: {
			            		store: '{comboSubcartera}',
			            		disabled: '{!comboCarteraSearch.selection}',
			                    filters: {
			                        property: 'carteraCodigo',
			                        value: '{comboCarteraSearch.value}'
								}
			                },
							listeners : {
				        			change: 'onChangeSubcartera',
									select: 'onChangeChainedCombo'
				        		},
			            	publishes: 'value',
							chainedStore: 'comboTipoSegmento',
							chainedReference: 'tipoSegmentoRef',
							forceSelection: true
						}				      
				    ]},
				    {
				   	defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
				    items:[
				        { 
				        	xtype: 'comboboxfieldbasedd',
				        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
				        	name: 'tipoActivoCodigo',
				        	reference: 'comboFiltroTipoActivoSearch',
				        	bind: {
			            		store: '{comboFiltroTipoActivo}'
			            	},
				        	publishes: 'value',
				        	chainedStore: 'comboFiltroSubtipoActivo',
				        	chainedReference: 'comboFiltroSubtipoActivoSearch',
				        	listeners: {
								select: 'onChangeChainedCombo'
							}
				        },
				        { 
				        	xtype: 'comboboxfieldbasedd',
				        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo'),
				        	name: 'subtipoActivoCodigo',
				        	reference: 'comboFiltroSubtipoActivoSearch',
				        	bind: {
			            		store: '{comboFiltroSubtipoActivo}',
			            		disabled: '{!comboFiltroTipoActivoSearch.value}'
			            	}
				        },
				        {
							xtype : 'comboboxfieldbase',
							editable: false,
							fieldLabel: HreRem.i18n('fieldlabel.activosearch.sello.calidad'),
							name: 'selloCalidad',
							bind: {
								store : '{comboSiNoRem}'
							}
						}
				    ]},
				    {
			    	defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
			    	items:[
					        { 
					        	fieldLabel: HreRem.i18n('fieldlabel.municipio'),
					        	name: 'localidadDescripcion'

					        },
					        { 
					        	xtype: 'comboboxfieldbasedd',
						    	addUxReadOnlyEditFieldPlugin: false,
					        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
					        	name: 'provinciaCodigo',
					        	bind: {
				            		store: '{comboFiltroProvincias}'
				            	}
					        },
					        {
					        	fieldLabel: HreRem.i18n('fieldlabel.activosearch.codigo.promocion'),
					        	name: 'codPromoPrinex'
					        }
					    ]},
				    {	
				    defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
				    items:[
				        { 
				        	fieldLabel: HreRem.i18n('fieldlabel.finca.registral'),
				        	name: 'numFinca'
				        },
				        { 
				        	fieldLabel: HreRem.i18n('fieldlabel.referencia.catastral'),
				        	name: 'refCatastral'
				        },
				    	{ 
				    		xtype: 'currencyfieldbase',
				    		fieldLabel: HreRem.i18n('fieldlabel.numero.de.agrupacion'),
				    		name: 'numAgrupacion'
				    	}
				    ]}
			    ]
    		},
    		{
    			xtype: 'panel',
    			collapsed: true,
    			layout: 'column',
    			reference: 'busquedaAvanzadaActivosbusquedaAvanzadaActivos',
    			title: HreRem.i18n('title.busqueda.avanzada'),
    			cls: 'panel-busqueda-avanzada',
    			items: [
    				{
    				columnWidth: 1,
    				items:[    			

						{    			                
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.identificacion'),
							collapsible: true,
							defaultType: 'textfieldbase',
		    				defaults: {
					    		addUxReadOnlyEditFieldPlugin: false
					    	},							
							items :
								 [
									 { 
							        	fieldLabel: HreRem.i18n('fieldlabel.numero.activo.sareb'),
										labelWidth:	150,
							        	name: 'numActivoSareb'
							         },
									 {
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.prinex'),
										labelWidth:	150,
						            	name: 'numActivoPrinex'
									 },
									 {
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.uvem'),
						                name: 'numActivoUvem'
									},
									{
							        	fieldLabel: HreRem.i18n('fieldlabel.numero.activo.divarian'),
							        	labelWidth:	150,
							        	name: 'numActivoDivarian'
							        },
									{
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.recovery'),
										labelWidth:	150,
						                name: 'numActivoRecovery'
									},
									{
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
							        	labelWidth:	150,
							        	name: 'estadoActivoCodigo',
							        	bind: {
						            		store: '{comboEstadoActivo}'
						            	}
							        },
									{
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel:  HreRem.i18n('fieldlabel.uso.dominante'),
							        	labelWidth:	150,
							        	name: 'tipoUsoDestinoCodigo',
							        	bind: {
						            		store: '{comboTiposUsoDestino}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel:  HreRem.i18n('fieldlabel.clase.activo'),
							        	labelWidth:	150,
							        	name: 'claseActivoBancarioCodigo',
							        	bind: {
						            		store: '{comboClaseActivoBancario}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel:  HreRem.i18n('fieldlabel.bancario.subclase'),
							        	labelWidth:	150,
							        	name: 'subClaseActivoBancarioCodigo',
							        	bind: {
						            		store: '{comboSubtipoClaseActivoBancario}'
						            	}
							        },
							        {
							        	fieldLabel:  HreRem.i18n('fieldlabel.bancario.numactivoBBVA'),
							        	labelWidth:	150,
							        	name: 'numActivoBbva'
							        }
							        
							        

								]
			                
			            	}
		            	]
		            },
		            
		            {
    					columnWidth: 1,
    					items:[    			

						{    			                
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.direccion'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfieldbase',
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
							items :
								[
									{ 
							        	xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.tipo.via'),
						            	name: 'tipoViaCodigo',
							        	bind: {
						            		store: '{comboTipoVia}'
						            	}
							        },
									{
										fieldLabel: HreRem.i18n('fieldlabel.nombre.via'),
						                name: 'nombreVia'
						                
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
						                name: 'codPostal'
									},
									{ 
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							        	name: 'provinciaAvanzadaCodigo',
							        	bind: {
						            		store: '{comboFiltroProvincias}'
						            	}
							        },
									{
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						            	name: 'localidadAvanzadaDescripcion'
									},
									{
							        	xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.pais'),
							        	name: 'paisCodigo',
							        	bind: {
						            		store: '{comboCountries}'
						            	}
						        	}
								]
			            }
		            	]
		            },
    				
    				{
    				columnWidth: 1,
    				items:[    			

						{    
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.informacion.registral'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfieldbase',
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
							items :
								[
								{
									fieldLabel: HreRem.i18n('fieldlabel.poblacion.registro'),
									labelWidth:	150,
					            	name: 'localidadRegistroDescripcion'
								 },
								{
									fieldLabel: HreRem.i18n('fieldlabel.numero.registro'),
					            	name: 'numRegistro'
								 }, {
									fieldLabel: HreRem.i18n('fieldlabel.finca.registral'),
					                name: 'numFincaAvanzada'
								},
								{
									fieldLabel: HreRem.i18n('fieldlabel.idufir'),
					                name: 'idufir'
								},
						        {
						        	xtype: 'comboboxfieldbasedd',
						        	fieldLabel: HreRem.i18n('fieldlabel.origen.del.activo'),
						        	name: 'tipoTituloActivoCodigo',
						        	bind: {
						            	store: '{comboTipoTitulo}'
						            }
						        },
						        {
						        	xtype: 'comboboxfieldbasedd',
						        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.titulo'),
						        	name: 'subtipoTituloActivoCodigo',
						        	bind: {
						            	store: '{comboSubtiposTitulo}'
						            }
						        },
						        { 
						        	xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.division.horizontal.integrado'),
					            	name: 'divHorizontal',
						        	bind: {
					            		store: '{comboSiNoRem}'
					            	}
						        },
						        { 
						        	xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.inscrito'),
					            	name: 'fechaInscripcionReg',
						        	bind: {
					            		store: '{comboSiNoRem}'
					            	}
						        }
							]

			            }
		            ]},
					{
    				columnWidth: 1,
    				items:[
						{
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('fieldlabel.propietario'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfieldbase',
							defaults: {
								addUxReadOnlyEditFieldPlugin: false
							},
							items :
								[
									{ 
										xtype: 'comboboxfieldbasedd',
										addUxReadOnlyEditFieldPlugin: false,
										fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
										name: 'carteraAvanzadaCodigo',
										reference: 'carteraAvanzadaRef',
										bind: {
											store: '{comboEntidadPropietaria}'
										},
										publishes: 'value'
									},
									{
										xtype: 'comboboxfieldbasedd',
										addUxReadOnlyEditFieldPlugin: false,
										fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
										name: 'subcarteraAvanzadaCodigo',
										reference: 'subcarteraAvanzadaRef',
										bind: {
											store: '{comboSubcartera}',
											disabled: '{!carteraAvanzadaRef.selection}',
											filters: {
						                        property: 'carteraCodigo',
						                        value: '{carteraAvanzadaRef.value}'
						                    }
										},
										listeners : {
				        					change: 'onChangeSubcartera'
				        				} 
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.nombre.propietario'),
									    name: 'nombrePropietario'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.nif.propietario'),
										name: 'docPropietario'
									}
								]
						}
					]},
					{
					columnWidth: 1,
					items:[    			

						{    
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.situacion.posesoria'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfield',
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
							items :
								[
									{ 
							        	xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.ocupado'),
						            	name: 'ocupado',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
							        },
							        { 
							        	xtype: 'comboboxfieldbasedd',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.con.titulo'),
						            	name: 'conTituloCodigo',
						            	reference: 'conTitulo',
							        	bind: {
						            		store: '{comboDDTipoTituloActivo}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbase',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.con.posesion.inicial'),
						            	name: 'fechaPosesion',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbase',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.tapiado'),
						            	name: 'tapiado',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbase',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.puerta.antiocupa'),
						            	name: 'antiocupa',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbasedd',
							        	editable: false,
										fieldLabel: HreRem.i18n('fieldlabel.titulo.posesorio'),
						            	name: 'tituloPosesorioCodigo',
							        	bind: {
						            		store: '{comboTipoTituloPosesorio}'
						            	}
							        }
								]
			            }
		            ]},
					{
    				columnWidth: 1,
    				items:[    			

						{
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('header.gestor'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfieldbase',
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
							items :
								[
									{
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel: 'Tipo de gestor:',
							        	bind: {
						            		store: '{comboTipoGestorOfertas}'
						            		//value: $AU.userTipoGestor(),
						            	    //readOnly: $AU.userTipoGestor()=="GIAFORM"
						            	},
										reference: 'tipoGestor',
										name: 'tipoGestorCodigo',
			        					chainedStore: 'comboUsuarios',
										chainedReference: 'usuarioGestor',
						            	displayField: 'descripcion',
			    						valueField: 'codigo',
			    						emptyText: 'Introduzca un gestor',
										listeners: {
											select: 'onChangeChainedCombo'
										}
									},
									{
							        	xtype: 'comboboxfieldbasedd',
							        	fieldLabel: HreRem.i18n('header.gestor')+"\\"+HreRem.i18n('header.gestoria'),
							        	reference: 'usuarioGestor',
							        	name: 'usuarioGestor',
										queryMode: 'local',
							        	bind: {
						            		store: '{comboUsuarios}',
						            		disabled: '{!tipoGestor.selection}'
						            		//value: $AU.getUser().userId,
						            		//readOnly: $AU.userTipoGestor()=="GIAFORM"
						            	},
						            	displayField: 'apellidoNombre',
			    						valueField: 'id',
			    						emptyText: 'Introduzca un usuario',
										filtradoEspecial2: true
								    },
							    	{ 
							    		xtype: 'comboboxfieldbasedd',
							    		fieldLabel: HreRem.i18n('fieldlabel.api.primario'),
							    		name: 'apiPrimarioId',
							    		valueField : 'id',
										displayField : 'nombre',
							    		emptyText: 'Introduzca nombre mediador',
							    		bind: {
							    			store: '{comboApiPrimario}'
							    		},
										filtradoEspecial2: true
							    	}
								]
			            }
		            ]},
		            {
    				columnWidth: 1,
    				items:[    			

						{    
							xtype:'fieldsettable',
							cls	 :  'fieldsetCabecera',
							title: HreRem.i18n('title.varios'),
							collapsible: true,
							collapsed: true,
							defaultType: 'textfieldbase',
							defaults: {
			    				addUxReadOnlyEditFieldPlugin: false
			    			},
							items :
								[
									{ 
							        	xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.estado.comercial'),
						            	name: 'situacionComercialCodigo',
							        	bind: {
						            		store: '{comboSituacionComercial}'
						            	}
							        },
							        { 
							        	xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
						            	name: 'tipoComercializacionCodigo',
							        	bind: {
						            		store: '{comboTiposComercializacionActivo}'
						            	}
							        },
							        { 
							        	xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.perimetro.gestion'),
						            	name: 'gestion',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('header.rating'),
						            	name: 'flagRatingCodigo',
							        	bind: {
						            		store: '{comboRatingActivo}'
						            	}
							        },
							        { 
							        	xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.con.cargas'),
						            	name: 'conCargas',
							        	bind: {
						            		store: '{comboSiNoRem}'
						            	}
							        },
							    	{ 
							    		xtype: 'comboboxfieldbasedd',
							    		fieldLabel: HreRem.i18n('fieldlabel.estado.comunicacion.gencat'),
							    		name: 'estadoComunicacionGencatCodigo',
							    		bind: {
							    			store: '{comboEstadoComunicacionGencat}'
							    		}
							    	},
							    	{ 
							    		xtype: 'comboboxfieldbasedd',
							    		fieldLabel: HreRem.i18n('fieldlabel.direccion.comercial'),
							    		name: 'direccionComercialCodigo',
							    		bind: {
							    			store: '{comboDireccionComercial}'
							    		}
							    	},
							    	{ 
							    		xtype: 'comboboxfieldbasedd',
							    		fieldLabel: HreRem.i18n('fieldlabel.tipo.segmento'),
							    		name: 'tipoSegmentoCodigo',
							    		reference: 'tipoSegmentoRef',							    		
										bind: {
							    			store: '{comboTipoSegmento}',
											hidden: '{!comboSubcarteraRef.selection}'
							    		}
							    	},
							    	{ 
							    		xtype: 'comboboxfieldbase',
							    		fieldLabel: HreRem.i18n('fieldlabel.perimetro.apple.macc.perimetro'),
							    		name: 'perimetroMacc',
							    		reference: 'perimetroMaccRef',
							    		hidden: true,
							    		bind: {
							    			store: '{comboSiNoRem}'
							    		}
							    	},
                                    {
                                        xtype: 'comboboxfieldbasedd',
                                        fieldLabel: HreRem.i18n('fieldlabel.tipo.equipo.gestion'),
                                        name: 'equipoGestion',
                                        reference: 'equipoGestionRef',
                                        bind: {
                                            store: '{comboEquipoGestion}'
                                        }
                                    },
							        {
							        	fieldLabel: HreRem.i18n('fieldlabel.activobbva.codPromocionBbva'),
							        	name: 'codPromocionBbva'
							        }
								]
			            }
		            ]}
		            
    			]
    		}
	    ];
		
		me.callParent();
		
	}
});