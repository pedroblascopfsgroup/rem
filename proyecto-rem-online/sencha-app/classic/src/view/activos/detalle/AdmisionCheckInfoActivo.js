Ext.define('HreRem.view.activos.detalle.AdmisionCheckInfoActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'admisioncheckinfoactivo',   
    cls	: 'panel-base shadow-panel',
    scrollable	: 'y',
    saveMultiple: true,
    disableValidation: true,
    records: ['activoAdmision','datosRegistralesAdmision'], 
    recordsClass: ['HreRem.model.Activo', 'HreRem.model.ActivoDatosRegistrales'],    
    requires: ['HreRem.model.Activo', 'HreRem.model.ActivoDatosRegistrales'],
    
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    		me.evaluarEdicion();
    	}
    },

    
    initComponent: function () {

        var me = this;
        
        me.items = [
		{
			xtype:'fieldsettable',
			defaultType: 'textfieldbase',
			
			title: HreRem.i18n('title.admision.calidad'),
			items :
				[
		            {
						xtype:'checkboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.admision.revision.calidad'),
						bind:		'{activoAdmision.selloCalidad}',
						reference: 'chkbxRevisionDeptoCalidad',
						secFunPermToEdit: 'EDITAR_SELLO_CALIDAD',
						listeners: {
							change: 'onChkbxRevisionDeptoCalidadChange'
						}
					},
					{
						xtype: 'displayfieldbase',
		            	fieldLabel:  HreRem.i18n('fieldlabel.admision.gestor.calidad'),
		            	reference: 'nomGestorCalidad',
		            	bind:		'{activoAdmision.nombreGestorSelloCalidad}'
		            },  
					{ 
						xtype: 'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel:  HreRem.i18n('fieldlabel.admision.fecha.revision'),
						reference: 'fechaRevisionCalidad',
						bind:		'{activoAdmision.fechaRevisionSelloCalidad}',
						readOnly: true
					}
				]        	
		}, 
        {
			xtype:'fieldsettable',
			defaultType: 'textfieldbase',
			
			title: HreRem.i18n('title.identificacion'),
			items :
				[
	                {
	                	xtype: 'displayfieldbase',
	                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.haya'),
	                	bind:		'{activoAdmision.numActivo}'
	                },
					{ 
						xtype: 'displayfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.id.bien.recovery'),
						bind:		'{activoAdmision.idRecovery}'
					},
					{ 
	                	xtype: 'textareafieldbase',
	                	labelWidth: 200,
	                	rowspan: 4,
	                	height: 160,
	                	labelAlign: 'top',
	                	fieldLabel: HreRem.i18n('fieldlabel.breve.descripcion.activo'),
	                	bind:		'{activoAdmision.descripcion}'
	                },
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.id.activo.prinex'),
						bind:		'{activoAdmision.idProp}'
					},
					{ 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
						reference: 'tipoActivoAdmision',
			        	chainedStore: 'comboSubtipoActivo',
						chainedReference: 'subtipoActivoComboAdmision',
			        	bind: {
		            		store: '{comboTipoActivo}',
		            		value: '{activoAdmision.tipoActivoCodigo}'
		            	},
						listeners: {
		                	select: 'onChangeChainedCombo'
		            	}
			        },
					{
						xtype: 'displayfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.id.activo.sareb'),
		                bind:		'{activoAdmision.idSareb}'
					},
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
			        	reference: 'subtipoActivoComboAdmision',
			        	bind: {
		            		store: '{comboSubtipoActivo}',
		            		value: '{activoAdmision.subtipoActivoCodigo}',
		            		disabled: '{!activoAdmision.tipoActivoCodigo}'
		            	}
			        },
					{
						xtype: 'displayfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.id.activo.uvem'),
	                	bind:		'{activoAdmision.numActivoUvem}'
	                },
					{ 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
			        	name: 'estadoActivoCodigo',
			        	bind: {
		            		store: '{comboEstadoActivo}',
		            		value: '{activoAdmision.estadoActivoCodigo}'
		            	}			
			        },	
	                { 
	                	xtype: 'displayfieldbase',
	                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.rem'),
	                	bind:		'{activoAdmision.numActivoRem}'
	                },
	                {
	                	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.uso.dominante'),
			        	name: 'tipoUsoDestinoCodigo',
	                	bind: {
		            		store: '{comboTipoUsoDestino}',
		            		value: '{activoAdmision.tipoUsoDestinoCodigo}'
		            	}
	                }			
				]        	
        },             
        {      
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.direccion'),
				items :	[
						// fila 1
						{							
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
				        	bind: {
			            		store: '{comboTipoVia}',
			            		value: '{activoAdmision.tipoViaCodigo}'			            		
			            	}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							reference: 'provinciaComboAdmision',
							chainedStore: 'comboMunicipio',
							chainedReference: 'municipioComboAdmision',
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{activoAdmision.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						}
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.latitud'),
							readOnly: true,
							bind:		'{activoAdmision.latitud}'
		                },						
						// fila 2	
						
						{ 
							fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
		                	bind:		'{activoAdmision.nombreVia}'
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio'),
							reference: 'municipioComboAdmision',
							chainedStore: 'comboInferiorMunicipio',
							chainedReference: 'inferiorMunicipioComboAdmision',
			            	bind: {
			            		store: '{comboMunicipioAdmision}',
			            		value: '{activoAdmision.municipioCodigo}',
			            		disabled: '{!activoAdmision.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						}
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.longitud'),
							readOnly: true,
							bind:		'{activoAdmision.longitud}'
		                }, 
		                // fila 3               
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
		                	width: 		250,
		                	bind:		'{activoAdmision.numeroDomicilio}'
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.unidad.poblacional'),
							reference: 'inferiorMunicipioComboAdmision',
			            	bind: {
			            		store: '{comboInferiorMunicipioAdmision}',
			            		value: '{activoAdmision.inferiorMunicipioCodigo}',
			            		disabled: '{!activoAdmision.municipioCodigo}'
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
		                	reference: 'botonVerificarDireccionAdmision',
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
							width: 		250,
			                bind:		'{activoAdmision.escalera}'
						},
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.comunidad.autonoma'),
				        	forceSelection: true,
				        	readOnly: true,
				        	bind: {		
				        		store: '{storeComunidadesAutonomas}',
			            		value: '{activoAdmision.provinciaCodigo}'
			            	},
							valueField: 'id'							
								
					     },				
						 // fila 5
 						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
		                	bind:		'{activoAdmision.piso}'
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.pais'),
			            	bind: {
			            		store: '{comboPais}',
			            		value: '{activoAdmision.paisCodigo}'
			            	},
		                	colspan: 2
						},
						// fila 6
						 { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
		                	bind:		'{activoAdmision.puerta}'
		                },
		                {
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
							bind:		'{activoAdmision.codPostal}',
		                	vtype: 'codigoPostal',
							maskRe: /^\d*$/, 
		                	maxLength: 5,
		                	colspan: 2
						}
				]    
    	 },    	       
    	 {     
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.datos.inscripcion'),
				items :
					[				
									
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia.registro'),
							reference: 'provinciaRegistroAdmision',
							chainedStore: 'comboMunicipioRegistro',
							chainedReference: 'poblacionRegistroAdmision',
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{datosRegistralesAdmision.provinciaRegistro}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
			            	}
						},						
						{ 
		                	fieldLabel: HreRem.i18n('fieldlabel.finca'),
		                	width: 		300,
		                	bind: '{datosRegistralesAdmision.numFinca}'
		                },	
		                { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.cambiado.registro'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            	    value: '{datosRegistralesAdmision.hanCambiado}'
			            	}
				        }, 
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.poblacion.registro'),
							selectFirst: true,
			            	reference:	'poblacionRegistroAdmision',
			            	bind: {
			            		store: '{comboMunicipioRegistroAdmision}',
			            		value: '{datosRegistralesAdmision.poblacionRegistro}',
			            		disabled: '{!datosRegistralesAdmision.provinciaRegistro}'
			            	}
		                	
						},
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.idufir'),
		                	bind: '{datosRegistralesAdmision.idufir}',
		                	maskRe: /^\d*$/, 
		                	vtype: 'idufir',
		                	maxLength: 14
		                },	
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.num.departamento'),
		                	bind: '{datosRegistralesAdmision.numDepartamento}',
		                	maskRe: /^\d*$/
		                },
		               
		                { 
							fieldLabel: HreRem.i18n('fieldlabel.numero.registro'),
		                	bind:		'{datosRegistralesAdmision.numRegistro}',
		                	maskRe: /^\d*$/
		                },

		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.tomo'),
		                	bind: '{datosRegistralesAdmision.tomo}'
		                },
		                { 
					 		fieldLabel: HreRem.i18n('fieldlabel.libro'),
					 		colspan: 2,
					 		bind: '{datosRegistralesAdmision.libro}'
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.folio'),
							colspan: 2,
							bind: '{datosRegistralesAdmision.folio}'
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
								 		reference: 'superficieConstruidaAdmision',
								 		symbol: HreRem.i18n("symbol.m2"),
								 		fieldLabel: HreRem.i18n('fieldlabel.construida'),							 		
								 		bind: '{datosRegistralesAdmision.superficieConstruida}'
									},
									{ 
										xtype: 'numberfieldbase',
										reference: 'superficieUtilAdmision',
								 		symbol: HreRem.i18n("symbol.m2"),
										fieldLabel: HreRem.i18n('fieldlabel.util'),
		                				bind: '{datosRegistralesAdmision.superficieUtil}'
					                },
					                { 
					                	xtype: 'numberfieldbase',
								 		reference: 'superficieElementosComunesAdmision',
								 		symbol: HreRem.i18n("symbol.m2"),
					                	fieldLabel: HreRem.i18n('fieldlabel.repercusion.elementos.comunes'),
					                	bind: '{datosRegistralesAdmision.superficieElementosComunes}'
					                },
					                { 
					                	xtype: 'numberfieldbase',
								 		symbol: HreRem.i18n("symbol.m2"),
								 		fieldLabel: HreRem.i18n('fieldlabel.parcela.no.ocupada.edificacion'),
								 		bind: '{datosRegistralesAdmision.superficieParcela}'
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
							        	reference: 'combodivisionhorizontaladmision',
							        	bind: {
						            		store: '{comboSiNoRem}',
						            		value: '{datosRegistralesAdmision.divHorizontal}'
						            	},

			    						listeners: {
						                	change: 'onDivisionHorizontalAdmisionSelect'
						            	}
							        },							        
							        { 
							        	xtype: 'comboboxfieldbase',
							        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
							        	reference: 'estadoDivHorizontalAdmision',
							        	bind: {
						            		store: '{comboInscritaNoInscrita}',
						            		value: '{datosRegistralesAdmision.divHorInscrito}'
						            	},
			    						listeners: {
						                	change: 'onEstadoDivHorizontalAdmisionSelect'
						            	}
							        },
							        {
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.estado.si.no.inscrita'),
										reference: 'estadoDivHorizontalNoInscritaAdmision',
						            	bind: {
						            		store: '{comboEstadoDivHorizontal}',
						            		value: '{datosRegistralesAdmision.estadoDivHorizontalCodigo}'
						            	},
						            	displayField: 'descripcion',
			    						valueField: 'codigo'
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
						            		value: '{datosRegistralesAdmision.estadoObraNuevaCodigo}'
						            	}
									},
					                { 
										xtype:'datefieldbase',
										formatter: 'date("d/m/Y")',
								 		fieldLabel: HreRem.i18n('fieldlabel.fecha.cfo'),
								 		bind: '{datosRegistralesAdmision.fechaCfo}'	            	
									}
							]
				        }
					]
                
    		},   		
           	{    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.titulo'),
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
						reference: 'comboTipoTituloAdmisionRef',
						forceSelection: true,
						labelWidth: 200,
						listeners: {
							change: 'onChangeTipoTituloAdmision'
		            	},
		            	bind: {
		            		store: '{comboTipoTitulo}',
		            		value: '{datosRegistralesAdmision.tipoTituloCodigo}'
		            	}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.subtipo.titulo'),
						forceSelection: true,
						colspan: 2,
		            	bind: {
		            		store: '{comboSubtipoTituloAdmision}',
		            		value: '{datosRegistralesAdmision.subtipoTituloCodigo}'
		            	}
					},
				 	{ 
			        	xtype: 'comboboxfieldbase',
			        	colspan: 2,
			        	fieldLabel: HreRem.i18n('fieldlabel.vpo'),
			        	bind: {
		            		store: '{comboSiNoRem}',
							value: '{datosRegistralesAdmision.vpo}'	            		
		            	}
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
						reference:'judicialAdmision',
						hidden: false,
						title: HreRem.i18n('title.adjudicacion.judicial'),
						items :
						
						[						
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.entidad.ejecutante.hipoteca'),
				            	bind: {
				            		store: '{comboEntidadesEjecutantes}',
				            		value: '{datosRegistralesAdmision.entidadEjecutanteCodigo}'
				            	}
							},

			                {
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.estado.adjudicacion'),
				            	bind: {
				            		store: '{comboEstadoAdjudicacion}',
				            		value: '{datosRegistralesAdmision.estadoAdjudicacionCodigo}'
				            	}
							},
			                { 
			                	xtype: 'datefieldbase',
			                	reference: 'fechaAutoAdjudicacionAdmision',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.auto.adjudicacion'),
								bind: '{datosRegistralesAdmision.fechaAdjudicacion}'
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaFirmezaAutoAdjudicacionAdmision',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.firmeza.auto.adjudicacion'),
								bind: '{datosRegistralesAdmision.fechaDecretoFirme}'
			                },
			                { 
			                	xtype: 'datefieldbase',
			                	reference: 'fechaTomaPosesionJudicialAdmision',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.toma.posesion'),
								bind: '{datosRegistralesAdmision.fechaSenalamientoPosesion}'
							},
							{ 
								xtype: 'currencyfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.importe.adjudicacion'),
								bind: '{datosRegistralesAdmision.importeAdjudicacion}'
			                },
			                {
								xtype: 'comboboxfieldbase',
								reference: 'comboJuzgadoAdmision',
								name: 'comboJuzgadoAdmision',
			                	fieldLabel: HreRem.i18n('fieldlabel.tipo.juzgado'),
								emptyText: 'Seleccione Población juzgado',
								selectFirst: true,
				            	bind: {
				            		store: '{comboTiposJuzgadoPlazaAdmision}',
				            		value: '{datosRegistralesAdmision.tipoJuzgadoCodigo}'
				            	},
				            	allowBlank: false
							},
			                {
								xtype: 'comboboxfieldbase',
								name: 'comboPlazaAdmision',
								reference: 'comboPlazaAdmision',
			                	fieldLabel: HreRem.i18n('fieldlabel.poblacion.juzgado'),
				            	bind: {
				            		store: '{comboTiposPlaza}',
				            		value: '{datosRegistralesAdmision.tipoPlazaCodigo}'
				            	},
								chainedStore: 'comboTiposJuzgadoPlazaAdmision',
								chainedReference: 'comboJuzgadoAdmision',
				            	listeners: {
				            		select: 'onChangeChainedCombo'
				            	},
				            	allowBlank: false
							},
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.numero.autos'),
			                	bind: '{datosRegistralesAdmision.numAuto}'
			                },
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.procurador'),
			                	bind: '{datosRegistralesAdmision.procurador}'
			                },
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.letrado'),
						 		bind: '{datosRegistralesAdmision.letrado}'
							},
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.id.asunto.recovery'),
			                	bind: '{datosRegistralesAdmision.idAsunto}'
			                }					
						
						]
                
            		},
            		
            		{    
                
						xtype:'fieldsettable',
						reference:'noJudicialAdmision',
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
				            		value: '{datosRegistralesAdmision.gestionHre}'
				            	}
					        },
			                {
								xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.titulo'),
						 		reference: 'fechaTituloAdmision',
						 		bind: '{datosRegistralesAdmision.fechaTitulo}'
				            	
							},
							{
								xtype:'datefieldbase',
								reference: 'fechaFirmezaTituloAdmision',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.firmeza.titulo'),
						 		bind: '{datosRegistralesAdmision.fechaFirmaTitulo}'			            	
							},
			                { 
								xtype:'currencyfieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion'),
						 		bind: '{datosRegistralesAdmision.valorAdquisicion}'

							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.notario.juzgado.organo.administrativo'),
						 		bind: '{datosRegistralesAdmision.tramitadorTitulo}'

							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.protocolo.autos.numero.expediente'),
						 		bind: '{datosRegistralesAdmision.numReferencia}'

							}
						
						
						]
            
        			},       			
        			
        			{    
                
						xtype:'fieldsettable',
						reference:'pdvAdmision',
						colspan: 4,
						hidden: false,
						defaultType: 'textfieldbase',
						title: 'PDV',
						items :

						[

							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.sociedad.acreedora'),
						 		bind: '{datosRegistralesAdmision.acreedorNombre}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.codigo.sociedad.acreedora'),
						 		bind: '{datosRegistralesAdmision.acreedorId}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.nif.sociedad.acreedor'),
						 		bind: '{datosRegistralesAdmision.acreedorNif}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.domicilio.sociedad.acreedor'),
						 		bind: '{datosRegistralesAdmision.acreedorDir}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.importe.deuda'),
						 		bind: '{datosRegistralesAdmision.importeDeuda}'

							},
							{ 
						 		fieldLabel: HreRem.i18n('fieldlabel.numero.expediente.riesgo.sociedad.acreedora'),
						 		bind: '{datosRegistralesAdmision.acreedorNumExp}'

							}
	
						
						]
            
        			}
           	
			   ]
            },
                		{    
                
				xtype:'fieldset',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.informacion.administrativa'),
				items :
					[
    				{
						title:HreRem.i18n('title.catastro'),
					    xtype: 'gridBaseEditableRow',
					    idPrincipal: 'activoAdmision.id',
					    topBar: true,
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeCatastro}'
						},
						
						secFunToEdit: 'EDITAR_CHECKING_INFO_ADMISION',
						
						secButtons: {
							secFunPermToEnable : 'EDITAR_CHECKING_INFO_ADMISION'
						},
						
						listener: function (tabPanel) { 
				    		tabPanel.evaluarEdicion();
						},
						
						columns: [
							    {   
									text: HreRem.i18n('fieldlabel.referencia.catastral'),
						        	dataIndex: 'refCatastral',
						        	editor: {
						        		xtype:'textfield', 
						        		minLength : 20, 
						        		maxLength : 20, 
						        		enforceMaxLength: true,
						        		allowBlank: false,
						        		msgTarget: 'side',
						        		listeners : {
						                    change : function (field, newValue, oldValue, eOpts) {
						                    	    var grid = field.up('grid');
						                    		var parcelaValue = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=parcela]').value;
						                    		var poligonoValue = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=poligono]').value;
						                    		if (newValue)
						                    		{
						                    			var parcelaRef = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=parcela]');
						                    			var poligonoRef = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=poligono]');
						                    			parcelaRef.allowBlank = true;
						                    			parcelaRef.clearInvalid();
						                    			poligonoRef.allowBlank = true;
						                    			poligonoRef.clearInvalid();
						                    			field.clearInvalid();
						                    		}
						                    		else
						                    		{
							                    		if (poligonoValue && parcelaValue)
							                    		{
							                    			field.allowBlank = true;
							                    			field.clearInvalid();
							                    		}
							                    		else
							                    			field.allowBlank = false;
						                    		}
						                        }
						                    }
						                },
						        	flex: 2
						        },
						        {
									text: HreRem.i18n('fieldlabel.poligono'),
						        	dataIndex: 'poligono',
						        	editor: {
						        		xtype:'textfield',
						        		listeners : {
						                    change : function (field, newValue, oldValue, eOpts) {
					                    	    var grid = field.up('grid');
					                    		var parcelaValue = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=parcela]').value;
					                    		var refCatastralValue = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=refCatastral]').value;
					                    		if (refCatastralValue)
					                    		{
					                    			field.allowBlank = true;
					                    			field.clearInvalid();
					                    		}
					                    		else
					                    		{
					                    			field.allowBlank = false;
					                    		}
					                    		
				                    			if (newValue && parcelaValue)
				                    			{
				                    				//Poner el refCatastral allowBlank a true porque ahora que tenemos parcela y pol�gono es opcional
				                    				var refCatastralRef = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=refCatastral]');
				                    				refCatastralRef.allowBlank = true;
				                    				refCatastralRef.clearInvalid();
				                    			}

					                        }
						        		},
						        	    flex: 1
						            }
						        },	
								{
						            text: HreRem.i18n('fieldlabel.parcela'),
						            dataIndex: 'parcela',
						        	editor: {
						        		xtype:'textfield',
						        		listeners : {
						                    change : function (field, newValue, oldValue, eOpts) {
						                    	    var grid = field.up('grid');
						                    		var poligonoValue = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=poligono]').value;
						                    		var refCatastralValue = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=refCatastral]').value;
						                    		if (refCatastralValue)
						                    		{
						                    			field.allowBlank = true;
						                    		}
						                    		else
						                    		{
						                    			field.allowBlank = false;
						                    		}
						                    		
					                    			if (newValue && poligonoValue)
					                    			{
					                    				//Poner el refCatastral allowBlank a true porque ahora que tenemos parcela y pol�gono es opcional
					                    				var refCatastralRef = grid.getPlugin("rowEditingPlugin").editor.down('textfield[dataIndex=refCatastral]');
					                    				refCatastralRef.allowBlank = true;
					                    				refCatastralRef.clearInvalid();
					                    			}
					                        }
						                    }
						            },
						        	flex: 1
						        },
						        {   
						        	text: HreRem.i18n('fieldlabel.titular.catastral'),
						        	dataIndex: 'titularCatastral',
						        	editor: {xtype:'textfield'},
						        	flex: 1
						        },
						        
						        {   text: HreRem.i18n('fieldlabel.superficie.construida'),
						        	dataIndex: 'superficieConstruida',
						        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
						        	editor: {
						        		xtype:'numberfield', 
						        		hideTrigger: true,
						        		keyNavEnable: false,
						        		mouseWheelEnable: false},
						        	flex: 1,
						        	summaryType: 'sum',
						            summaryRenderer: function(value, summaryData, dataIndex) {
						            	return "<span>"+Ext.util.Format.number(value, '0,000.00')+"</span>"
						            }
						        },
						        {   text: HreRem.i18n('fieldlabel.superficie.util'),
						        	dataIndex: 'superficieUtil',
						        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
						        	editor: {
						        		xtype:'numberfield', 
						        		hideTrigger: true,
						        		keyNavEnable: false,
						        		mouseWheelEnable: false},
						        	flex: 1,
						        	summaryType: 'sum',
						            summaryRenderer: function(value, summaryData, dataIndex) {
						            	return "<span>"+Ext.util.Format.number(value, '0,000.00')+"</span>"
						            }
						        },
						        {   text: HreRem.i18n('fieldlabel.superficie.repercusion.elementos.comunes'), 
						        	dataIndex: 'superficieReperComun',
						        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
						        	editor: {
						        		xtype:'numberfield', 
						        		hideTrigger: true,
						        		keyNavEnable: false,
						        		mouseWheelEnable: false},
						        	flex: 1,
						        	summaryType: 'sum',
						            summaryRenderer: function(value, summaryData, dataIndex) {
						            	return "<span>"+Ext.util.Format.number(value, '0,000.00')+"</span>"
						            }
						        },
						        {   text: HreRem.i18n('fieldlabel.superficie.parcela'), 
						        	dataIndex: 'superficieParcela',
						        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
						        	editor: {
						        		xtype:'numberfield', 
						        		hideTrigger: true,
						        		keyNavEnable: false,
						        		mouseWheelEnable: false},
						        	flex: 1,
						        	summaryType: 'sum',
						            summaryRenderer: function(value, summaryData, dataIndex) {
						            	return "<span>"+Ext.util.Format.number(value, '0,000.00')+"</span>"
						            }
						        },
						        {   text: HreRem.i18n('fieldlabel.superficie.suelo'),
						        	dataIndex: 'superficieSuelo',
						        	renderer: Ext.util.Format.numberRenderer('0,000.00'),
						        	editor: {
						        		xtype:'numberfield', 
						        		hideTrigger: true,
						        		keyNavEnable: false,
						        		mouseWheelEnable: false},
						        	flex: 1,
						        	summaryType: 'sum',
						            summaryRenderer: function(value, summaryData, dataIndex) {
						            	return "<span>"+Ext.util.Format.number(value, '0,000.00')+"</span>"
						            }
						        },
						        {   text: HreRem.i18n('fieldlabel.valor.catastral.construccion'),
						        	dataIndex: 'valorCatastralConst',
						        	renderer: function(value) {
						        		return Ext.util.Format.currency(value);
						        	},
						        	editor: {
						        		xtype:'numberfield', 
						        		hideTrigger: true,
						        		keyNavEnable: false,
						        		mouseWheelEnable: false},
						        	flex: 1
						        },
						        {   text: HreRem.i18n('fieldlabel.valor.catastral.suelo'),
						        	dataIndex: 'valorCatastralSuelo',
						        	renderer: function(value) {
						        		return Ext.util.Format.currency(value);
						        	},
						        	editor: {
						        		xtype:'numberfield', 
						        		hideTrigger: true,
						        		keyNavEnable: false,
						        		mouseWheelEnable: false},
						        	flex: 1
						        },

						        {   text: HreRem.i18n('fieldlabel.fecha.revision.valor.catastral'),
						        	dataIndex: 'fechaRevValorCatastral',
						        	formatter: 'date("d/m/Y")',
						        	/*format: 'M d, Y',
						        	format: 'Y',*/
						        	editor: {
					                    xtype: 'datefield'
					                },
					                flex: 1 
						        }     
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeCatastro}'
					            }
					        }
					    ]
					}
				]
			
			}
        
        
        ];
        
        
        
   	 	me.callParent();    	
    	
    },
    
    getErrorsExtendedFormBase: function() {
   		
   		var me = this,
   		errores = [],
   		error,   		
   		provinciaRegistro = me.down("[reference=provinciaRegistroAdmision]"),
   		codigoProvinciaDomicilio = me.viewWithModel.getViewModel().get('activoAdmision.provinciaCodigo'),
   		superficieUtil = me.down("[reference=superficieUtilAdmision]"),
   		superficieConstruida = me.down("[reference=superficieConstruidaAdmision]"),
   		superficieElementosComunes = me.down("[reference=superficieElementosComunesAdmision]"),
   		fechaTitulo = me.down("[reference=fechaTituloAdmision]"),
   		fechaFirmezaTitulo = me.down("[reference=fechaFirmezaTituloAdmision]"),
   		fieldsetNoJudicial = me.down("[reference=noJudicialAdmision]"),
   		fieldsetJudicial = me.down("[reference=judicialAdmision]"),
   		fechaFirmezaAutoAdjudicacion = me.down("[reference=fechaFirmezaAutoAdjudicacionAdmision]"),
   		fechaTomaPosesion = me.down("[reference=fechaTomaPosesionJudicialAdmision]"),
   		fechaAutoAdjudicacion = me.down("[reference=fechaAutoAdjudicacionAdmision]");
   		
   		
   		
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
   			
   			if(fechaTomaPosesion.getValue() < fechaAutoAdjudicacion.getValue()){
   				error = HreRem.i18n("txt.validacion.fechaTomaPosesion.menor.fechaAutoAdjudicacion");
	   			errores.push(error);
	   			fechaTomaPosesion.markInvalid(error);
   				
   			}
   			
   			
   		}
   		
   		me.addExternalErrors(errores);
   		
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
    	
    	me.getBindRecords()[0].set("longitud", longitud);
    	me.getBindRecords()[0].set("latitud", latitud);
    	
    },
    
    //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar y las acciones editables por fila
    evaluarEdicion: function() {    	
		var me = this;
		
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false" || me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			me.down('[xtype=gridBaseEditableRow]').setTopBar(false);
			me.down('[xtype=gridBaseEditableRow]').rowEditing.clearListeners();
		}
    }
});