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
		                	bind: '{datosRegistrales.numFinca}',
		                	allowBlank: false
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
			            	},
    						allowBlank: false
		                	
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
		                	allowBlank: false,
		                	maskRe: /^\d*$/
		                },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.num.departamento'),
		                	//rowspan: 5,
		                	bind: '{datosRegistrales.numDepartamento}',
		                	maskRe: /^\d*$/
		                },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.tomo'),
		                	colspan: 2,
		                	bind: '{datosRegistrales.tomo}',
		                	allowBlank: false
		                },
		                { 
					 		fieldLabel: HreRem.i18n('fieldlabel.libro'),
					 		colspan: 2,
					 		bind: '{datosRegistrales.libro}',
					 		allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.folio'),
							colspan: 2,
							bind: '{datosRegistrales.folio}',
							allowBlank: false
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
					    xtype		: 'gridBase',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storePropietario}'
						},
						listeners: {
							rowdblclick: 'onListadoPropietariosDobleClick'
						},		
						colspan: 4,
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
					        	flex:1
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
					        }	               	        
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storePropietario}'
					            }
					        }
					    ]
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
				            	},
								allowBlank: false
							},
			                { 
			                	xtype: 'datefieldbase',
			                	reference: 'fechaAutoAdjudicacion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.auto.adjudicacion'),
								bind: '{datosRegistrales.fechaAdjudicacion}',
								allowBlank: false
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaFirmezaAutoAdjudicacion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.firmeza.auto.adjudicacion'),			                	
								bind: '{datosRegistrales.fechaDecretoFirme}'
			                },
			                { 
			                	xtype: 'datefieldbase',
			                	reference: 'fechaTomaPosesionJudicial',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.toma.posesion'),
								bind: '{datosRegistrales.fechaSenalamientoPosesion}'
							},
							{ 
								xtype: 'currencyfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.importe.adjudicacion'),
								bind: '{datosRegistrales.importeAdjudicacion}'/*,
								allowBlank: false*/
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
				            	},
				            	allowBlank: false
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
				            	},
				            	allowBlank: false
							},
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.numero.autos'),
			                	bind: '{datosRegistrales.numAuto}',
			                	allowBlank: false
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
						items :

						[
							{
					        	xtype: 'comboboxfieldbase',					        	
						 		fieldLabel: HreRem.i18n('fieldlabel.gestion.hre'),
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
						 		bind: '{datosRegistrales.fechaTitulo}',
						 		allowBlank: false
				            	
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
						 		bind: '{datosRegistrales.valorAdquisicion}',
						 		allowBlank: false

							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.notario.juzgado.organo.administrativo'),
						 		bind: '{datosRegistrales.tramitadorTitulo}'

							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.protocolo.autos.numero.expediente'),
						 		bind: '{datosRegistrales.numReferencia}',
						 		allowBlank: false

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
						items :

						[

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
			            	}
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
   		
   		
   		
   		if(provinciaRegistro.getValue() != codigoProvinciaDomicilio) {
   			error = HreRem.i18n("txt.validacion.provincia.diferente.registro");
   			errores.push(error);
   			provinciaRegistro.markInvalid(error); 
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
   			
   			/* Se elimina esta validaci�n a petici�n del cliente en HREOS-359
   			 * 
   			if(fechaTomaPosesion.getValue() < fechaAutoAdjudicacion.getValue()){
   				error = HreRem.i18n("txt.validacion.fechaTomaPosesion.menor.fechaAutoAdjudicacion");
	   			errores.push(error);
	   			fechaTomaPosesion.markInvalid(error);
   				
   			}*/
   			
   			
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