Ext.define('HreRem.view.activos.detalle.TituloInformacionRegistralActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'tituloinformacionregistralactivo',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'tituloinformacionregistralactivo',
    scrollable	: 'y',
    recargar: false,
    
    listeners: {
			boxready:'cargarTabData'
	},

	recordName: "datosRegistrales",
	
	recordClass: "HreRem.model.ActivoDatosRegistrales",

    requires: ['HreRem.model.ActivoDatosRegistrales', 'HreRem.view.common.FieldSetTable', 'HreRem.view.common.TextFieldBase', 'HreRem.view.common.ComboBoxFieldBase', 'HreRem.model.ActivoPropietario'],

    initComponent: function () {
    	    	
        var me = this;   
        me.setTitle(HreRem.i18n('title.titulo.informacion.registral'));
        var items= [

			{    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.datos.inscripcion'),
				items :
					[
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia.registro'),
							reference: 'provinciaRegistro',
							chainedStore: 'comboMunicipioRegistro',
							chainedReference: 'poblacionRegistro',
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{datosRegistrales.provinciaRegistro}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
			            	},
			            	allowBlank: false
						},
						{ 
		                	fieldLabel: HreRem.i18n('fieldlabel.finca'),
		                	bind: '{datosRegistrales.numFinca}'
		                },	
		                { 
				        	xtype: 'comboboxfieldbase',				        	
				        	fieldLabel: HreRem.i18n('fieldlabel.cambiado.registro'),
				        	labelWidth:	200,
				        	bind: {
			            		store: '{comboSiNoRem}',
			            	    value: '{datosRegistrales.hanCambiado}'
			            	},
    						listeners: {
			                	change:  'onHanCambiadoSelect'
			            	}
				        }, 
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.poblacion.registro'),
							selectFirst: true,
			            	reference:	'poblacionRegistro',
			            	bind: {
			            		store: '{comboMunicipioRegistro}',
			            		value: '{datosRegistrales.poblacionRegistro}',
			            		disabled: '{!datosRegistrales.provinciaRegistro}'
			            	}
                      },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.idufir'),
		                	reference: 'idufir',
		                	bind: '{datosRegistrales.idufir}',
		                	maskRe: /^\d*$/, 
		                	vtype: 'idufir',
		                	maxLength: 14
                        },		                
		                {
				        	xtype:'fieldset',
				        	layout: {
						        type: 'table',
				        		trAttrs: {height: '45px', width: '100%'},
				        		columns: 1,
				        		tableAttrs: {
						            style: { width: '90%' }
						        }
				        	},
							defaultType: 'textfieldbase',
							rowspan: 5,
							title: 'Datos de la inscripción anterior',
							items :
								[
									{
										xtype: 'comboboxfieldbase',
										disabled: true,
										fieldLabel: HreRem.i18n('fieldlabel.poblacion.anterior'),
										labelWidth:	200,
										reference: 'poblacionAnterior',
						            	bind: {
						            		store: '{comboMunicipio}',
						            		value: '{localidadAnteriorCodigo}'
						            	}
									},
				
					                { 
					                	disabled: true,
					                	fieldLabel: HreRem.i18n('fieldlabel.numero.anterior'),
										reference: 'numRegistroAnterior',
										labelWidth:	200,
					                	maskRe: /^\d*$/,
					                	bind: '{datosRegistrales.numAnterior}'
					                },
					                { 
					                	disabled: true,
					                	fieldLabel: HreRem.i18n('fieldlabel.finca.anterior'),
										labelWidth:	200,
					                	reference: 'numFincaAnterior',
					                	bind: '{datosRegistrales.numFincaAnterior}'
					                }

								]
				        },
		                { 
							fieldLabel: HreRem.i18n('fieldlabel.numero.registro'),
		                	bind:		'{datosRegistrales.numRegistro}',
		                	maskRe: /^\d*$/
		                },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.num.departamento'),
		                	bind: '{datosRegistrales.numDepartamento}',
		                	maskRe: /^\d*$/
		                },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.tomo'),
		                	colspan: 2,
		                	bind: '{datosRegistrales.tomo}'
                        },
		                { 
					 		fieldLabel: HreRem.i18n('fieldlabel.libro'),
					 		colspan: 2,
					 		bind: '{datosRegistrales.libro}'
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.folio'),
							colspan: 2,
							bind: '{datosRegistrales.folio}'
		                }
					]
			},
			{
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.informacion.registral'),
				items :
					[
					
						{
				        	xtype:'fieldset',
				        	height: 200,
				        	margin: '0 10 10 0',
				        	layout: {
						        type: 'table',
				        		columns: 1
				        	},
							defaultType: 'textfieldbase',
							title: HreRem.i18n("title.superficies"),
							items :
								[
									{ 
								 		xtype: 'numberfieldbase',
								 		reference: 'superficieConstruida',
								 		symbol: HreRem.i18n("symbol.m2"),
								 		fieldLabel: HreRem.i18n('fieldlabel.construida'),								 		
								 		bind: '{datosRegistrales.superficieConstruida}'
									},
									{ 
										xtype: 'numberfieldbase',
										reference: 'superficieUtil',
								 		symbol: HreRem.i18n("symbol.m2"),
										fieldLabel: HreRem.i18n('fieldlabel.util'),
		                				bind: '{datosRegistrales.superficieUtil}'
					                },
					                { 
					                	xtype: 'numberfieldbase',
					                	reference: 'superficieElementosComunes',
								 		symbol: HreRem.i18n("symbol.m2"),
					                	fieldLabel: HreRem.i18n('fieldlabel.repercusion.elementos.comunes'),
					                	bind: '{datosRegistrales.superficieElementosComunes}'
					                },
					                { 
					                	xtype: 'numberfieldbase',
								 		symbol: HreRem.i18n("symbol.m2"),
								 		fieldLabel: HreRem.i18n('fieldlabel.parcela.no.ocupada.edificacion'),
								 		bind: '{datosRegistrales.superficieParcela}'
									}
		
								]
				        },
				        
				        {
				        	xtype:'fieldset',
				        	height: 200,
				        	margin: '0 10 10 0',
				        	layout: {
						        type: 'table',
				        		columns: 1
				        	},
							defaultType: 'textfieldbase',
							title: HreRem.i18n("title.division.horizontal"),
							items :
								[								
									 { 
							        	xtype: 'comboboxfieldbase',							        	
							        	fieldLabel:  HreRem.i18n('fieldlabel.activo.integrado'),
							        	reference: 'combodivisionhorizontalref',
							        	bind: {
						            		store: '{comboSiNoRem}',
						            		value: '{datosRegistrales.divHorizontal}'
						            	},
			    						listeners: {
						                	change: 'onDivisionHorizontalSelect'
						            	}
							        },							        
							        { 
							        	xtype: 'comboboxfieldbase',							        	
							        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
							        	reference: 'estadoDivHorizontal',
							        	bind: {
						            		store: '{comboInscritaNoInscrita}',
						            		value: '{datosRegistrales.divHorInscrito}'
						            	},
			    						listeners: {
						                	change: 'onEstadoDivHorizontalSelect'
						            	}
							        },
							        {
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.estado.si.no.inscrita'),
										reference: 'estadoDivHorizontalNoInscrita',
						            	bind: {
						            		store: '{comboEstadoDivHorizontal}',
						            		value: '{datosRegistrales.estadoDivHorizontalCodigo}'
						            	}
									}				              
									
								]
				        },				        
				        {
				        	xtype:'fieldset',
				        	title: HreRem.i18n('fieldlabel.obra.nueva'),
				        	height: 200,
				        	margin: '0 0 10 0',
				        	layout: {
						        type: 'table',
				        		columns: 1
				        	},
							defaultType: 'textfieldbase',
							items :[									
								{
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.estado'),
					                bind: {
					                    store: '{comboEstadoObraNueva}',
					                    value: '{datosRegistrales.estadoObraNuevaCodigo}'
					                }
								},
				                {
									xtype:'datefieldbase',
									formatter: 'date("d/m/Y")',
							        fieldLabel: HreRem.i18n('fieldlabel.fecha.cfo'),
							        bind: '{datosRegistrales.fechaCfo}'
								}
							]
				        }
					]
			},
			{
				xtype:'fieldset',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.titulo'),
			    collapsible: true,
			    collapsed: false,
				layout: {
			        type: 'table',
			        columns: 4,
			        tdAttrs: {width: '25%'}
				},
				items :
					[
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.origen.activo'),
						reference: 'comboTipoTituloRef',
						forceSelection: true,
						allowBlank: false,
						labelWidth: 200,
		            	bind: {
		            		store: '{comboTipoTitulo}',
		            		value: '{datosRegistrales.tipoTituloCodigo}'
		            	},
		            	listeners: {
							change: 'onChangeTipoTitulo'
		            	}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.subtipo.titulo'),
						forceSelection: true,
		            	bind: {
		            		store: '{comboSubtipoTitulo}',
		            		value: '{datosRegistrales.subtipoTituloCodigo}'
		            	}
					},
				 	{ 
			        	xtype: 'comboboxfieldbase',			        	
			        	colspan: 2,
			        	fieldLabel: HreRem.i18n('fieldlabel.vpo'),
			        	bind: {
		            		store: '{comboSiNoRem}',
							value: '{datosRegistrales.vpo}'	            		
		            	},
		            	allowBlank: true
			        },
			        {
						title: 'Listado de Propietarios',
						itemId: 'listadoPropietarios',
					    xtype: 'gridBaseEditableRow',
					    topBar : true,
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storePropietario}'
						},
						listeners: {
							rowdblclick: 'onListadoPropietariosDobleClick'
						},		
						colspan: 4,
						selModel : {
			                type : 'checkboxmodel'
			              },
			              features: [{
					            id: 'summary',
					            ftype: 'summary',
					            hideGroupedHeader: true,
					            enableGroupingMenu: false,
					            dock: 'bottom'
						    }],
						columns: [
						    {   text: 'Nombre o raz&oacute;n social', 
					        	dataIndex: 'nombreCompleto',
					        	flex:2 
					        },
					        {   text: 'Tipo Doc.', 
					        	dataIndex: 'tipoDocIdentificativoDesc',
					        	flex:1 
					        },	
					        {   text: 'Doc. Identificativo', 
					        	dataIndex: 'docIdentificativo',
					        	flex:1 
					        },	
					        {   text: HreRem.i18n('fieldlabel.porcentaje.propiedad'), 
					        	dataIndex: 'porcPropiedad',
					        	flex:1,
					        	 summaryType: 'sum',
						            summaryRenderer: function(value, summaryData, dataIndex) {
						            	var suma = 0;
						            	var store = this.up('grid').store;

						            	for(var i=0; i< store.data.length; i++){
						            		if(store.data.items[i].data.porcPropiedad != null){
						            			suma += parseFloat(store.data.items[i].data.porcPropiedad);
						            		}
						            	}
						            	suma = Ext.util.Format.number(suma, '0.00');
						            	
						            	var msg = HreRem.i18n("fieldlabel.porcentaje.propiedad") + " " + suma + "%";
						            	var style = "" 
						            	if(suma != Ext.util.Format.number(100.00,'0.00')) {
						            		msg = HreRem.i18n("fieldlabel.porcentaje.propietarios.total.error");		
						            		style = "style= 'color: red'" 
						            	}	
						            	
						            	return "<span "+style+ ">"+msg+"</span>"
						            	
						            }
					        },
					        {   text: HreRem.i18n('fieldlabel.grado.propiedad'), 
					        	dataIndex: 'tipoGradoPropiedadDescripcion',
					        	flex:2
					        },
					        {   text: 'Representante', 
					        	dataIndex: 'nombreContacto',
					        	flex:2
					        },
					        {   text: 'Tel&eacute;fono', 
					        	dataIndex: 'telefono',
					        	flex:1 
					        },
					        {   text: 'E-mail', 
					        	dataIndex: 'email',
					        	flex:1 
					        },
					        {   text: 'Tipo propietario', 
					        	dataIndex: 'tipoPropietario',
					        	flex:1 
					        }	               	        
					    ],

					    onAddClick: function (btn) {
					 		var me = this;
					 		var activo = me.lookupController().getViewModel().get('activo'),
					 		idActivo= activo.get('id'),
					 		numActivo= activo.get('numActivo');
					 		
					 		var ventana = Ext.create("HreRem.view.activos.detalle.AnyadirPropietario", {activo: activo});
					 		me.up('activosdetallemain').add(ventana);
							ventana.show();
					 	    				    	
					 	},
					 	onDeleteClick: function (btn) {					 		
					 		var me = this;	
							var url =  $AC.getRemoteUrl('activo/deleteActivoPropietarioTab');
							var propietario = me.up('tabpanel').down('grid').getSelection();
							var activo = me.lookupController().getViewModel().get('activo');
							if (propietario[0].get('tipoPropietario') == "Principal"){
								Ext.toast({
									 html: 'No se puede eliminar el propietario principal',
									 width: 400,
									 height: 100,
									 align: 't'									     
								  });
								
							}else {
								var params={};
								params["idActivo"]=activo.get('id');
								params["idPropietario"]= propietario[0].get('id');		
								Ext.Ajax.request({
								     url: url,
								     params:params,
								     success: function (a, operation, context) {
								    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								    	me.up('tabpanel').down('grid').getStore().load();
						           },
						           failure: function (a, operation, context) {
						           	  Ext.toast({
										 html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
										 width: 360,
										 height: 100,
										 align: 't'									     
									  });
						           }
							    });			
							}					 	    				    	
					 	}
					},
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						colspan: 4,
						reference:'judicial',
						hidden: false,
						title: HreRem.i18n('title.adjudicacion.judicial'),
						items :
						
						[						
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.entidad.ejecutante.hipoteca'),								
				            	bind: {
				            		store: '{comboEntidadesEjecutantes}',
				            		value: '{datosRegistrales.entidadEjecutanteCodigo}'
				            	}

							},

			                {
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.estado.adjudicacion'),								
				            	bind: {
				            		store: '{comboEstadoAdjudicacion}',
				            		value: '{datosRegistrales.estadoAdjudicacionCodigo}'
				            	}
                                 
							},
			                { 
			                	xtype: 'datefieldbase',
			                	reference: 'fechaAutoAdjudicacion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.auto.adjudicacion'),
								bind: '{datosRegistrales.fechaAdjudicacion}'
                                 
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaFirmezaAutoAdjudicacion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.firmeza.auto.adjudicacion'),			                	
								bind: '{datosRegistrales.fechaDecretoFirme}'
                                 
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaSenyalamientoPosesion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.senyalamiento.posesion'),			                	
								bind: '{datosRegistrales.fechaSenalamientoPosesion}'
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaRealizacionPosesion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.realizacion.posesion'),			                	
								bind: '{datosRegistrales.fechaRealizacionPosesion}',
								bind: {
									value: '{datosRegistrales.fechaRealizacionPosesion}',
									readOnly: '{isReadOnlyFechaRealizacionPosesion}',
									disabled: '{isCarteraLiberbank}'
								}
			                },
			                {
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.lanzamiento.necesario'),								
				            	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{datosRegistrales.lanzamientoNecesario}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
							},
							{
			                	xtype: 'datefieldbase',
			                	reference: 'fechaSenyalamientoLanzamiento',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.senyalamiento.lanzamiento'),			                	
								bind: '{datosRegistrales.fechaSenalamientoLanzamiento}'
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaLanzamientoEfectuado',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.lanzamiento.efectuado'),			                	
								bind: '{datosRegistrales.fechaRealizacionLanzamiento}'
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaSolicitudMoratoria',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.solicitud.moratoria'),			                	
								bind: '{datosRegistrales.fechaSolicitudMoratoria}'
			                },
			                {
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.resolucion.moratoria'),								
				            	bind: {
				            		store: '{comboFavorableDesfavorable}',
				            		value: '{datosRegistrales.resolucionMoratoriaCodigo}'
				            	}
							},
							{
			                	xtype: 'datefieldbase',
			                	reference: 'fechaResolucionMoratoria',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.resolucion.moratoria'),			                	
								bind: '{datosRegistrales.fechaResolucionMoratoria}'
			                },
			                
							{ 
								xtype: 'currencyfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.importe.adjudicacion'),
								bind: '{datosRegistrales.importeAdjudicacion}'
			                },
			                {
								xtype: 'comboboxfieldbase',
								name: 'comboJuzgado',
								reference: 'comboJuzgado',
			                	fieldLabel: HreRem.i18n('fieldlabel.tipo.juzgado'),
								emptyText: 'Seleccione Población juzgado',
								selectFirst: true,
				            	bind: {
				            		store: '{comboTiposJuzgadoPlaza}',
				            		value: '{datosRegistrales.tipoJuzgadoCodigo}'
				            	}
							},
			                {
								xtype: 'comboboxfieldbase',
								name: 'comboPlaza',
								reference: 'comboPlaza',
			                	fieldLabel: HreRem.i18n('fieldlabel.poblacion.juzgado'),
				            	bind: {
				            		store: '{comboTiposPlaza}',
				            		value: '{datosRegistrales.tipoPlazaCodigo}'
				            	},
								chainedStore: 'comboTiposJuzgadoPlaza',
								chainedReference: 'comboJuzgado',
				            	listeners: {
				            		select: 'onChangeChainedCombo'
				            	}
							},
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.numero.autos'),
			                	bind: '{datosRegistrales.numAuto}'
			                },
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.procurador'),
			                	bind: '{datosRegistrales.procurador}'
			                },
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.letrado'),
						 		bind: '{datosRegistrales.letrado}'
							},
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.id.asunto.recovery'),
			                	bind: '{datosRegistrales.idAsunto}'
			                },
			                {
			                	xtype: 'numberfieldbase',
			                	maxLength: 4,
			                	fieldLabel: HreRem.i18n('fieldlabel.expedientes.con.defectos.testimonio'),
			                	bind: '{datosRegistrales.defectosTestimonio}'
			                }
						]

            		},
            		{
						xtype:'fieldsettable',
						reference:'noJudicial',
						colspan: 4,
		            	hidden: false,
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.adjudicacion.no.judicial'),
						items : [
							{
					        	xtype: 'comboboxfieldbase',					        	
						 		fieldLabel: HreRem.i18n('fieldlabel.gestion.hre'),
						 		hidden: true,
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{datosRegistrales.gestionHre}'
				            	},
				            	allowBlank: false
					        },
			                {
								xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.titulo'),
						 		reference: 'fechaTitulo',
						 		bind: '{datosRegistrales.fechaTitulo}'
							},
							{
								xtype:'datefieldbase',
								reference: 'fechaFirmezaTitulo',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.firmeza.titulo'),
						 		bind: '{datosRegistrales.fechaFirmaTitulo}'
							},
			                { 
								xtype:'currencyfieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion'),
						 		bind: '{datosRegistrales.valorAdquisicion}'
							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.notario.juzgado.organo.administrativo'),
						 		bind: '{datosRegistrales.tramitadorTitulo}'

							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.protocolo.autos.numero.expediente'),
						 		bind: '{datosRegistrales.numReferencia}'
							},
                            {
                                xtype: 'numberfieldbase',
                                maxLength: 4,
                                fieldLabel: HreRem.i18n('fieldlabel.expedientes.con.defectos.testimonio'),
                                bind: '{datosRegistrales.defectosTestimonio}'
                            }
						]

        			},
        			{
						xtype:'fieldsettable',
						reference:'pdv',
						colspan: 4,
						hidden: false,
						defaultType: 'textfieldbase',
						title: 'PDV',
						items : [
							{
						 		fieldLabel: HreRem.i18n('fieldlabel.sociedad.acreedora'),
						 		bind: '{datosRegistrales.acreedorNombre}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.codigo.sociedad.acreedora'),
						 		bind: '{datosRegistrales.acreedorId}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.nif.sociedad.acreedor'),
						 		bind: '{datosRegistrales.acreedorNif}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.domicilio.sociedad.acreedor'),
						 		bind: '{datosRegistrales.acreedorDir}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.importe.deuda'),
						 		bind: '{datosRegistrales.importeDeuda}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.numero.expediente.riesgo.sociedad.acreedora'),
						 		bind: '{datosRegistrales.acreedorNumExp}'

							}
						]
        			}
				]

            },
			{
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.tramitacion.titulo'),
				items :
					[
						{ 
				        	xtype: 'comboboxfieldbase',				        	
					 		fieldLabel: HreRem.i18n('fieldlabel.situacion.titulo'),
				        	bind: {
			            		store: '{comboEstadoTitulo}',
			            		value: '{datosRegistrales.estadoTitulo}'

			            	},

			            	reference: 'estadoTitulo'
                        },
				        {
							xtype:'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.entrega.titulo.gestoria'),
					 		bind: '{datosRegistrales.fechaEntregaGestoria}'
                       },
						{
							xtype:'datefieldbase',
					 		fieldLabel: HreRem.i18n('fieldlabel.fecha.presentacion.hacienda'),
					 		bind: '{datosRegistrales.fechaPresHacienda}'

						},
						{
							xtype:'datefieldbase',
					 		fieldLabel: HreRem.i18n('fieldlabel.fecha.presentacion.registro'),
					 		bind: '{datosRegistrales.fechaPres1Registro}'
						},
						{
							xtype:'datefieldbase',
					 		fieldLabel: HreRem.i18n('fieldlabel.fecha.envio.auto.adicion'),
					 		bind: '{datosRegistrales.fechaEnvioAuto}'
						},
						{
							xtype:'datefieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.segunda.presentacion.registro'),
					 		bind: '{datosRegistrales.fechaPres2Registro}'
						},
						{
							xtype:'datefieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.fecha.inscripcion.registro'),
					 		bind: '{datosRegistrales.fechaInscripcionReg}'
						},
						{
							xtype:'datefieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.fecha.retirada.definitiva.registro'),
					 		bind: '{datosRegistrales.fechaRetiradaReg}'
						},
						{
							xtype:'datefieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.fecha.nota.simple'),

					 		bind: '{datosRegistrales.fechaNotaSimple}'
						},
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							colspan: 4,
							reference:'judicial',
							hidden: false,
							title: HreRem.i18n("title.calificacion.negativa"),
							items :
							[
								{
						        	xtype: 'comboboxfieldbase',
							 		fieldLabel: HreRem.i18n('fieldlabel.calificacion.negativa'),
						        	name: 'comboCalificacionNegativa',
						        	bind: {
					            		store: '{comboCalificacionNegativa}',
					            		value: '{datosRegistrales.calificacionNegativa}'
					            	},
						        	listeners : {
						        		change: 'onChangeCalificacionNegativa'
						        	}
						        },
						        {
									xtype:'itemselectorbase',
									reference: 'itemselMotivo',
									fieldLabel: HreRem.i18n('fieldlabel.calificacion.motivo'),
            						store: {
            							model: 'HreRem.model.ComboBase',
										proxy: {
										type: 'uxproxy',
										remoteUrl: 'generic/getDiccionario',
										extraParams: {diccionario: 'motivosCalificacionNegativa'}
										},
										autoLoad: true
									},
            						bind: {
					            		value: '{datosRegistrales.motivoCalificacionNegativa}'
					            	},
									            listeners:{
									            	change: function(){
									            		var me = this;
									            		var campoDesc = me.lookupController('activodetalle').lookupReference('descMotivo');
									            		if(me.getValue().includes(CONST.MOTIVOS_CAL_NEGATIVA["OTROS"])){
									            			campoDesc.allowBlank = false;
									            			campoDesc.setReadOnly(false);
									            			if(me.up('activosdetallemain').getViewModel().get("editing")){
									            				campoDesc.fireEvent('edit');
									            			}else{
									            				campoDesc.fireEvent('cancel');
									            			}
									            		}else{
									            			campoDesc.allowBlank = true;
									            			campoDesc.setReadOnly(true);
									            			campoDesc.fireEvent('cancel');
									            		}
									            	}
									            }
								},
								{
									reference: 'descMotivo',
									allowBlank: true,
							 		fieldLabel: HreRem.i18n('fieldlabel.calificacion.descripcion'),
							 		bind: '{datosRegistrales.descripcionCalificacionNegativa}'

								}
							]
		           		}


					]
			}
		];

		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();

	},

	getErrorsExtendedFormBase: function() {

   		var me = this,
   		errores = [],
   		error,   		
   		provinciaRegistro = me.down("[reference=provinciaRegistro]"),
   		codigoProvinciaDomicilio = me.viewWithModel.getViewModel().get('activo.provinciaCodigo'),
   		idufir = me.down("[reference=idufir]"),
   		superficieUtil = me.down("[reference=superficieUtil]"),
   		superficieConstruida = me.down("[reference=superficieConstruida]"),
   		superficieElementosComunes = me.down("[reference=superficieElementosComunes]"),
   		fechaTitulo = me.down("[reference=fechaTitulo]"),
   		fechaFirmezaTitulo = me.down("[reference=fechaFirmezaTitulo]"),
   		fieldsetNoJudicial = me.down("[reference=noJudicial]"),
   		fieldsetJudicial = me.down("[reference=judicial]"),
   		fechaFirmezaAutoAdjudicacion = me.down("[reference=fechaFirmezaAutoAdjudicacion]"),
   		fechaTomaPosesion = me.down("[reference=fechaTomaPosesionJudicial]"),
   		fechaAutoAdjudicacion = me.down("[reference=fechaAutoAdjudicacion]");

   		motivoCalNegativa = me.down("[reference=itemselMotivo]");

   		if(provinciaRegistro.getValue() != codigoProvinciaDomicilio) {
   			error = HreRem.i18n("txt.validacion.provincia.diferente.registro");
   			errores.push(error);
   			provinciaRegistro.markInvalid(error); 
   		}


   		if(motivoCalNegativa.getValue().length == 0) {
   			error = HreRem.i18n("txt.validacion.motivo.obligatorio");
   			errores.push(error);
   			motivoCalNegativa.markInvalid(error);
   		}


   		if(superficieUtil.getValue() > superficieConstruida.getValue()) {
   			error = HreRem.i18n("txt.validacion.suputil.mayor.supconstruida");
   			errores.push(error);
   			superficieUtil.markInvalid(error); 		

   		} else if (superficieConstruida.getValue() > superficieElementosComunes.getValue() || superficieUtil.getValue() > superficieElementosComunes.getValue()) {
   			error = HreRem.i18n("txt.validacion.superficies.mayor.suplementoscomunes");
   			errores.push(error);
   			superficieElementosComunes.markInvalid(error);
   		}

   		if(fieldsetNoJudicial.isVisible()){
	   		if(!Ext.isEmpty(fechaFirmezaTitulo.getValue()) && fechaFirmezaTitulo.getValue() < fechaTitulo.getValue()) {
	   			error = HreRem.i18n("txt.validacion.fechafirmezatitulo.menor.fechatitulo");
	   			errores.push(error);
	   			fechaFirmezaTitulo.markInvalid(error);
	   		}
   		}

   		if(fieldsetJudicial.isVisible()){
   			if(!Ext.isEmpty(fechaFirmezaAutoAdjudicacion.getValue()) &&  fechaAutoAdjudicacion.getValue() > fechaFirmezaAutoAdjudicacion.getValue()) {
   				error = HreRem.i18n("txt.validacion.fechaAutoAdjudicacion.mayor.fechaFirmezaAutoAdjudicacion");
	   			errores.push(error);
	   			fechaFirmezaAutoAdjudicacion.markInvalid(error);

   			}
   		}

   		me.addExternalErrors(errores);
   },

   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		me.down('grid').getStore().load();
   }
});