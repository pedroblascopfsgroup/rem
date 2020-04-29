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
							xtype: 'comboboxfieldbase',
							name: 'carteraCodigo',
			              	fieldLabel :  HreRem.i18n('fieldlabel.entidad.propietaria'),
			              	reference: 'comboCarteraSearch',
							bind: {
								store: '{comboCartera}'
							},
			            	publishes: 'value'					
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
				        	name: 'subcarteraCodigo',
				        	bind: {
			            		store: '{comboSubcartera}',
			            		disabled: '{!comboCarteraSearch.selection}',
			                    filters: {
			                        property: 'carteraCodigo',
			                        value: '{comboCarteraSearch.value}'
			                    },
							listeners : {
				        			change: 'onChangeSubcartera'
				        		} 
			            	}
		    						
						}				      
				    ]},
				    {
				   	defaults: {
			    		addUxReadOnlyEditFieldPlugin: false
			    	},
				    items:[
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
				        	name: 'tipoActivoCodigo',
				        	reference: 'comboFiltroTipoActivoSearch',
				        	bind: {
			            		store: '{comboFiltroTipoActivo}'
			            	},
				        	matchFieldWidth: false,
				        	publishes: 'value',
				        	chainedStore: 'comboFiltroSubtipoActivo',
				        	chainedReference: 'comboFiltroSubtipoActivoSearch',
				        	listeners: {
								select: 'onChangeChainedCombo'
							}
				        },
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.activo'),
				        	name: 'subtipoActivoCodigo',
				        	reference: 'comboFiltroSubtipoActivoSearch',
				        	bind: {
			            		store: '{comboFiltroSubtipoActivo}',
			            		disabled: '{!comboFiltroTipoActivoSearch.value}'
			            	},
				        	matchFieldWidth: false
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
					        	xtype: 'comboboxfieldbase',
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
    			reference: 'busquedaAvanzadaActivos',
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
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
							        	labelWidth:	150,
							        	name: 'estadoActivoCodigo',
							        	bind: {
						            		store: '{comboEstadoActivo}'
						            	}
							        },
									{
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.uso.dominante'),
							        	labelWidth:	150,
							        	name: 'tipoUsoDestinoCodigo',
							        	bind: {
						            		store: '{comboTiposUsoDestino}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.clase.activo'),
							        	labelWidth:	150,
							        	name: 'claseActivoBancarioCodigo',
							        	bind: {
						            		store: '{comboClaseActivoBancario}'
						            	}
							        },
							        {
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.bancario.subclase'),
							        	labelWidth:	150,
							        	name: 'subClaseActivoBancarioCodigo',
							        	bind: {
						            		store: '{comboSubtipoClaseActivoBancario}'
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
							        	xtype: 'comboboxfieldbase',
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
							        	xtype: 'comboboxfieldbase',
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
							        	xtype: 'comboboxfieldbase',
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
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.origen.del.activo'),
						        	name: 'tipoTituloActivoCodigo',
						        	bind: {
						            	store: '{comboTipoTitulo}'
						            },
		    						matchFieldWidth: false
						        },
						        {
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.subtipo.titulo'),
						        	name: 'subtipoTituloActivoCodigo',
						        	bind: {
						            	store: '{comboSubtiposTitulo}'
						            },
		    						matchFieldWidth: false
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
										xtype: 'comboboxfieldbase',
										addUxReadOnlyEditFieldPlugin: false,
										fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
										name: 'carteraAvanzadaCodigo',
										bind: {
											store: '{comboEntidadPropietaria}'
										}
									},
									{
										xtype: 'comboboxfieldbase',
										addUxReadOnlyEditFieldPlugin: false,
										fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
										name: 'subcarteraAvanzadaCodigo',
										bind: {
											store: '{comboSubcartera}'
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
							        	xtype: 'comboboxfieldbase',
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
							        	xtype: 'comboboxfieldbase',
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
							        	xtype: 'comboboxfieldbase',
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
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel: HreRem.i18n('header.gestor')+"\\"+HreRem.i18n('header.gestoria'),
							        	reference: 'usuarioGestor',
							        	name: 'usuarioGestor',
							        	bind: {
						            		store: '{comboUsuarios}',
						            		disabled: '{!tipoGestor.selection}'
						            		//value: $AU.getUser().userId,
						            		//readOnly: $AU.userTipoGestor()=="GIAFORM"
						            			
						            	},
						            	displayField: 'apellidoNombre',
			    						valueField: 'id',
										filtradoEspecial: true,
			    						emptyText: 'Introduzca un usuario'
								    },
							    	{ 
							    		xtype: 'comboboxfieldbase',
							    		fieldLabel: HreRem.i18n('fieldlabel.api.primario'),
							    		name: 'apiPrimarioId',
							    		valueField : 'id',
										displayField : 'nombre',
										filtradoEspecial: true,
							    		emptyText: 'Introduzca nombre mediador',
							    		bind: {
							    			store: '{comboApiPrimario}'
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
							        	xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.estado.comercial'),
						            	name: 'situacionComercialCodigo',
							        	bind: {
						            		store: '{comboSituacionComercial}'
						            	}
							        },
							        { 
							        	xtype: 'comboboxfieldbase',
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
							        	xtype: 'comboboxfieldbase',
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
							    		xtype: 'comboboxfieldbase',
							    		fieldLabel: HreRem.i18n('fieldlabel.estado.comunicacion.gencat'),
							    		name: 'estadoComunicacionGencatCodigo',
							    		bind: {
							    			store: '{comboEstadoComunicacionGencat}'
							    		}
							    	},
							    	{ 
							    		xtype: 'comboboxfieldbase',
							    		fieldLabel: HreRem.i18n('fieldlabel.direccion.comercial'),
							    		name: 'direccionComercialCodigo',
							    		bind: {
							    			store: '{comboDireccionComercial}'
							    		}
							    	},
							    	{ 
							    		xtype: 'comboboxfieldbase',
							    		fieldLabel: HreRem.i18n('fieldlabel.tipo.segmento'),
							    		name: 'tipoSegmentoCodigo',
							    		reference: 'tipoSegmentoRef',
							    		hidden: true,
							    		bind: {
							    			store: '{comboTipoSegmento}'
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