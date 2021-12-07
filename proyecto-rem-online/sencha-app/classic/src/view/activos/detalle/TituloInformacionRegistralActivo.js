Ext.define('HreRem.view.activos.detalle.TituloInformacionRegistralActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'tituloinformacionregistralactivo',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: false,
    reference: 'tituloinformacionregistralactivo',
    scrollable	: 'y',
    recargar: false,
    viewModel: {
        type: 'activodetalle'
    },
    listeners: {
			boxready:'cargarTabData'
	},
	
	recordName: "datosRegistrales",
	
	recordClass: "HreRem.model.ActivoDatosRegistrales",

    requires: ['HreRem.model.ActivoDatosRegistrales', 'HreRem.view.common.FieldSetTable', 'HreRem.view.common.TextFieldBase', 'HreRem.view.common.ComboBoxFieldBase', 'HreRem.view.common.ComboBoxFieldBaseDD', 'HreRem.model.ActivoPropietario',
    	'HreRem.view.activos.detalle.CalificacionNegativaGrid', 'HreRem.view.activos.detalle.HistoricoTramitacionTituloGrid','HreRem.model.ActivoDeudorAcreditador'],

    initComponent: function () {
        var me = this;   
        me.setTitle(HreRem.i18n('title.titulo.informacion.registral'));
        me.getViewModel().data.nClicks=0;      
        var items= [

			{    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.datos.inscripcion'),				
				items :
					[
		                {
							fieldLabel: HreRem.i18n('fieldlabel.nombre.registro'),
		                	bind: {
		                		value: '{datosRegistrales.nombreRegistro}',
		                		hidden: '{!isCarteraBankia}',
                                readOnly: true
		                	},
		                	maskRe: /^\d*$/
		                },
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('fieldlabel.provincia.registro'),
							reference: 'provinciaRegistro',
							chainedStore: 'comboMunicipioRegistro',
							chainedReference: 'poblacionRegistro',
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{datosRegistrales.provinciaRegistro}',
			            	    readOnly: '{datosRegistrales.unidadAlquilable}',
								rawValue: '{datosRegistrales.provinciaRegistroDescripcion}',
								hidden: '{isCarteraBankia}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
			            	},
			            	allowBlank: false
						},
						{ 
		                	fieldLabel: HreRem.i18n('fieldlabel.finca'),
		                	bind: {
		                		value: '{datosRegistrales.numFinca}',
		                		readOnly: '{isCarteraBankiayUnidadAlquilable}'
		                	}
		                },	
		                { 
				        	xtype: 'comboboxfieldbase',				        	
				        	fieldLabel: HreRem.i18n('fieldlabel.cambiado.registro'),
				        	labelWidth:	200,
				        	bind: {
			            		store: '{comboSiNoRem}',
			            	    value: '{datosRegistrales.hanCambiado}',
			            	    readOnly: '{datosRegistrales.unidadAlquilable}'
			            	}, 
    						listeners: {
			                	change:  'onHanCambiadoSelect'
			            	}
				        },
		                { //Campo duplicado para que se vea bien al quitar los campos Caixa
					 		fieldLabel: HreRem.i18n('fieldlabel.libro'),
					 		bind: {
					 			value: '{datosRegistrales.libro}',
					 			readOnly: '{isCarteraBankiayUnidadAlquilable}',
                                hidden: '{!isCarteraBankia}'
					 		}
						},
						{
							xtype: 'comboboxfieldbasedd',
							fieldLabel: HreRem.i18n('fieldlabel.poblacion.registro'),
							//selectFirst: true,
			            	reference:	'poblacionRegistro',
			            	bind: {
			            		store: '{comboMunicipioRegistro}',
			            		value: '{datosRegistrales.poblacionRegistro}',
			            		disabled: '{!datosRegistrales.provinciaRegistro}',
			            		readOnly: '{datosRegistrales.unidadAlquilable}',
								rawValue: '{datosRegistrales.poblacionRegistroDescripcion}',
		                		hidden: '{isCarteraBankia}'
			            	}
                      },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.idufir'),
		                	reference: 'idufir',
		                	bind: {
		                		value: '{datosRegistrales.idufir}',
		                		readOnly: '{datosRegistrales.unidadAlquilable}'
		                	},
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
										xtype: 'comboboxfieldbasedd',
										disabled: true,
										fieldLabel: HreRem.i18n('fieldlabel.poblacion.anterior'),
										labelWidth:	200,
										reference: 'poblacionAnterior',
						            	bind: {
						            		store: '{comboMunicipioAnterior}',
						            		value: '{datosRegistrales.localidadAnteriorCodigo}',
						            		readOnly: '{datosRegistrales.unidadAlquilable}',
											rawValue: '{datosRegistrales.localidadAnteriorDescripcion}'
						            	}
									},
				
					                { 
					                	disabled: true,
					                	fieldLabel: HreRem.i18n('fieldlabel.numero.anterior'),
										reference: 'numRegistroAnterior',
										labelWidth:	200,
					                	maskRe: /^\d*$/,
					                	bind: {
					                		value: '{datosRegistrales.numAnterior}',
					                		readOnly: '{datosRegistrales.unidadAlquilable}'
					                	}
					                },
					                { 
					                	disabled: true,
					                	fieldLabel: HreRem.i18n('fieldlabel.finca.anterior'),
										labelWidth:	200,
					                	reference: 'numFincaAnterior',
					                	bind: {
					                		value: '{datosRegistrales.numFincaAnterior}',
					                		readOnly: '{datosRegistrales.unidadAlquilable}'
					                	}
					                }

								]
				        },
						{ //Campo duplicado para que se vea bien al quitar los campos Caixa
							fieldLabel: HreRem.i18n('fieldlabel.folio'),
							colspan: 2,
							bind: {
								value: '{datosRegistrales.folio}',
								readOnly: '{isCarteraBankiayUnidadAlquilable}',
                                hidden: '{!isCarteraBankia}'
							}
		                },
		                { 
							fieldLabel: HreRem.i18n('fieldlabel.numero.registro'),
		                	bind: {
		                		value: '{datosRegistrales.numRegistro}',
		                		readOnly: '{isCarteraBankiayUnidadAlquilable}',
		                		hidden: '{isCarteraBankia}'
		                	},
		                	maskRe: /^\d*$/
		                },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.num.departamento'),
		                	bind: {
		                		value:'{datosRegistrales.numDepartamento}',
		                		readOnly: '{datosRegistrales.unidadAlquilable}'
		                	},
		                	maskRe: /^\d*$/
		                },
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.tomo'),
		                	bind: {
		                		value: '{datosRegistrales.tomo}',
		                		readOnly: '{isCarteraBankiayUnidadAlquilable}'
		                	}
                        },
		                { 
                        	xtype: 'comboboxfieldbase',	
		                	fieldLabel: HreRem.i18n('fieldlabel.tiene.anejos.registrales'),	        	
				        	reference: 'comboTieneAnejosRegistralesRef',
		                	bind: {
		                		store: '{comboSiNoRem}',
		                		value: '{datosRegistrales.tieneAnejosRegistralesInt}',
		                		readOnly: '{!esSuperUsuario}',
			            		hidden: '{!isCarteraSareb}'
		                	},
			            	displayField: 'descripcion',
							valueField: 'codigo'
                        },
		                { 
					 		fieldLabel: HreRem.i18n('fieldlabel.libro'),
					 		colspan: 2,
					 		bind: {
					 			value: '{datosRegistrales.libro}',
					 			readOnly: '{datosRegistrales.unidadAlquilable}',
                                hidden: '{isCarteraBankia}'
					 		}
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.folio'),
							colspan: 2,
							bind: {
								value: '{datosRegistrales.folio}',
								readOnly: '{datosRegistrales.unidadAlquilable}',
                                hidden: '{isCarteraBankia}'
							}
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
				        	height: 260,
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
										reference: 'superficieParcelaUtil',
								 		symbol: HreRem.i18n("symbol.m2"),
										fieldLabel: HreRem.i18n('fieldlabel.superficie.parcela.util'),
		                				bind: {
		                					value: '{datosRegistrales.superficieParcelaUtil}',
		                					hidden: '{!isCarteraBankia}'
		                					}
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
									},
									{ 
								 		xtype: 'numberfieldbase',
								 		reference: 'superficieBajoRasanteRef',
								 		symbol: HreRem.i18n("symbol.m2"),
								 		fieldLabel: HreRem.i18n('fieldlabel.superficie.bajo.rasante'),								 		
								 		bind: '{datosRegistrales.superficieBajoRasante}'
									},
									{ 
								 		xtype: 'numberfieldbase',
								 		reference: 'superficieSobreRasanteRef',
								 		symbol: HreRem.i18n("symbol.m2"),
								 		fieldLabel: HreRem.i18n('fieldlabel.superficie.sobre.rasante'),								 		
								 		bind: '{datosRegistrales.superficieSobreRasante}'
									}
		
								]
				        },
				        
				        {
				        	xtype:'fieldset',
				        	height: 260,
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
						            		value: '{datosRegistrales.divHorizontal}',
						            		readOnly: '{datosRegistrales.unidadAlquilable}'
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
						            		value: '{datosRegistrales.divHorInscrito}',
						            		readOnly: '{datosRegistrales.unidadAlquilable}'
						            	},
			    						listeners: {
						                	change: 'onEstadoDivHorizontalSelect'
						            	}
							        },
							        {
										xtype: 'comboboxfieldbasedd',
										fieldLabel: HreRem.i18n('fieldlabel.estado.si.no.inscrita'),
										reference: 'estadoDivHorizontalNoInscrita',
						            	bind: {
						            		store: '{comboEstadoDivHorizontal}',
						            		value: '{datosRegistrales.estadoDivHorizontalCodigo}',
						            		readOnly: '{datosRegistrales.unidadAlquilable}',
											rawValue: '{datosRegistrales.estadoDivHorizontalDescripcion}'
						            	}
									}				              
									
								]
				        },				        
				        {
				        	xtype:'fieldset',
				        	title: HreRem.i18n('fieldlabel.obra.nueva'),
				        	height: 260,
				        	margin: '0 0 10 0',
				        	layout: {
						        type: 'table',
				        		columns: 1
				        	},
							defaultType: 'textfieldbase',
							items :[									
								{
									xtype: 'comboboxfieldbasedd',
									fieldLabel: HreRem.i18n('fieldlabel.estado'),
					                bind: {
					                    store: '{comboEstadoObraNueva}',
					                    value: '{datosRegistrales.estadoObraNuevaCodigo}',
					                    readOnly: '{datosRegistrales.unidadAlquilable}',
										rawValue: '{datosRegistrales.estadoObraNuevaDescripcion}'
					                }
								},
				                {
									xtype:'datefieldbase',
									formatter: 'date("d/m/Y")',
							        fieldLabel: HreRem.i18n('fieldlabel.fecha.cfo'),
							        bind: {
							        	value: '{datosRegistrales.fechaCfo}',
							        	readOnly: '{datosRegistrales.unidadAlquilable}'
							        }
								}
							]
				        }
					]
			},
			{
				xtype:'fieldsettable',
				title: HreRem.i18n('title.titulo'),
			    collapsible: true,
			    collapsed: false,

				listeners: {
					afterrender: 'ocultarCamposIdOrigen'
				},
				items :
					[{ xtype: 'fieldsettable',
					colspan: 3,
					collapsible: false,
					border: false,
					items: [{
						xtype: 'comboboxfieldbasedd',
						fieldLabel: HreRem.i18n('fieldlabel.origen.activo'),
						reference: 'comboTipoTituloRef',
						forceSelection: true,
						allowBlank: false,
		            	bind: {
		            		store: '{storeTituloOrigenActivo}',
		            		value: '{datosRegistrales.tipoTituloCodigo}',
//		            		readOnly: '{datosRegistrales.unidadAlquilable}',
		            		readOnly: '{isCarteraBankiayUnidadAlquilable}',
							rawValue: '{datosRegistrales.tipoTituloDescripcion}'
		            	},
		            	listeners: {
							change: 'onChangeTipoTitulo'
		            	}
					},
					{
						xtype: 'comboboxfieldbasedd',
						fieldLabel: HreRem.i18n('fieldlabel.subtipo.titulo'),
						forceSelection: true,
		            	bind: {
		            		store: '{comboSubtipoTitulo}',
		            		value: '{datosRegistrales.subtipoTituloCodigo}',
//		            		readOnly: '{datosRegistrales.unidadAlquilable}',
		            		readOnly: '{isCarteraBankiayUnidadAlquilable}',
							rawValue: '{datosRegistrales.subtipoTituloDescripcion}'
		            	},
		            	listeners:{
		            		change:'gestoresEstadoNotarialAndIDHayaNotNull'
		            	}
					},
				 	{ 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.vpo'),
			        	bind: {
		            		store: '{comboSiNoRem}',
							value: '{datosRegistrales.vpo}',
							readOnly: '{datosRegistrales.unidadAlquilable}'
		            	},
		            	allowBlank: true
			        },
			        //ESTE ES EL COMBO QUE APARECE PARA LOS ACTIVOS DE DIVARIAN
			        {
			        	xtype: 'comboboxfieldbasedd',
						fieldLabel: HreRem.i18n('fieldlabel.origen.anterior.activo'),
						reference: 'comboOrigenAnteriorActivoRef',				
		            	bind: {
		            		
		            		store: '{storeOrigenAnteriorActivo}',
		            		hidden: '{!mostrarCamposDivarian}',
		            		value: '{datosRegistrales.origenAnteriorActivoCodigo}',
							rawValue: '{datosRegistrales.origenAnteriorActivoDescripcion}'
		            	}
	            	},
	            	//ESTE ES EL COMBO QUE APARECE PARA LOS ACTIVOS DE BBVA
			        {
			        	xtype: 'comboboxfieldbasedd',
						fieldLabel: HreRem.i18n('fieldlabel.origen.anterior.activo'),
						reference: 'comboOrigenAnteriorActivoBBVARef',				
		            	bind: {
		            		store: '{storeTituloOrigenActivo}',
		            		hidden: '{!isCarteraBbva}',
		            		value: '{datosRegistrales.origenAnteriorActivoBbvaCodigo}',
							rawValue: '{datosRegistrales.origenAnteriorActivoBbvaDescripcion}'
		            	}
	            	},
					{
						xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						reference:'fechaTituloAnteriorRef',
				        fieldLabel: HreRem.i18n('fieldlabel.fecha.titulo.anterior'),
				        bind: {				        	
				        	hidden: '{!mostrarCamposDivarianandBbva}',
				        	value: '{datosRegistrales.fechaTituloAnterior}'
				        }
				       
					},
					{
			        	xtype: 'comboboxfieldbasedd',
			        	fieldLabel: HreRem.i18n('fieldlabel.sociedad.pago'),
			        	reference:'sociedadPagoAnteriorRef',
			        	
			        	bind: {			        		
			        		store: '{comboSociedadAnteriorBBVA}',
			        		hidden: '{!isCarteraBbva}',
			        		readOnly:'{!isCarteraBbva}',
			        		value:'{datosRegistrales.sociedadPagoAnterior}',
							rawValue:'{datosRegistrales.sociedadPagoAnteriorDescripcion}'
			        	}
			        },
			      //ESTOS COMBOS APARECEN PARA LOS ACTIVOS DE CAIXA
					{
			        	xtype: 'comboboxfieldbasedd',
			        	fieldLabel: HreRem.i18n('fieldlabel.sociedad.origen'),
			        	reference:'sociedadOrigenRef',
			        	
			        	bind: {			        		
			        		store: '{comboSociedadOrigenCaixa}',
			        		hidden: '{!isCarteraBankia}',
			        		readOnly: true,
			        		value:'{datosRegistrales.sociedadOrigenCodigo}',
							rawValue:'{datosRegistrales.sociedadOrigenDescripcion}'
			        	}
			        },
					{
			        	xtype: 'comboboxfieldbasedd',
			        	fieldLabel: HreRem.i18n('fieldlabel.banco.origen'),
			        	reference:'sociedadOrigenRef',
			        	
			        	bind: {			        		
			        		store: '{comboBancoOrigenCaixa}',
			        		hidden: '{!isCarteraBankia}',
			        		readOnly: true,
			        		value:'{datosRegistrales.bancoOrigenCodigo}',
							rawValue:'{datosRegistrales.bancoOrigenDescripcion}'
			        	}
			        }
				]},
			        {
						title: 'Listado de Propietarios',
						itemId: 'listadoPropietarios',
					    xtype: 'gridBaseEditableRow',
					    topBar : true,
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storePropietario}',
							topBar: '{!datosRegistrales.unidadAlquilable}'
						},
						listeners: {
							rowdblclick: 'onListadoPropietariosDobleClick'
						},		
						colspan: 3,
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
					        },
					        {   text: HreRem.i18n('fieldlabel.anyo.concesion'), 
					        	dataIndex: 'anyoConcesion',
					        	flex:1 
					        },
					        {   text: HreRem.i18n('fiedlabel.fecha.fin.concesion'), 
					        	dataIndex: 'fechaFinConcesion',
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
							var propietario = me.up().down('grid').getSelection();
							var activo = me.lookupController().getViewModel().get('activo');
							if (propietario[0].get('tipoPropietario') == "Principal"){
								me.fireEvent("errorToast",'No se puede eliminar el propietario principal' );
							}else {
								var params={};
								params["idActivo"]=activo.get('id');
								params["idPropietario"]= propietario[0].get('id');		
								Ext.Ajax.request({
								     url: url,
								     params:params,
								     success: function (a, operation, context) {
								    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								    	me.up().down('grid').getStore().load();
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
					//Se añade el grid de deudores
			        {
						title: HreRem.i18n('fieldlabel.listado.deudores'),
						itemId: 'listadoDeudores',	
					    xtype: 'gridBaseEditableRow',	
					    idPrincipal:'idActivo',
					    topBar : true,
					    editOnSelect: '{isGestorAdmisionAndSuper}',
					    reference: 'listadoDeudoresRef',
						cls	: 'panel-base shadow-panel',					
						bind: {
							store: '{storeDeudores}',
							topBar: '{isGestorAdmisionAndSuper}'						
						},
						listeners:{
							afterrender:function(){
								var me = this;								
								var idAct= me.lookupController().getViewModel().data.activo.id;
								me.lookupController().getViewModel().data.idActivo = idAct;
								var entidadPropietaria = me.lookupController().getViewModel().data.activo.data.entidadPropietariaCodigo;
								if (entidadPropietaria == CONST.CARTERA['BBVA']) {
									me.setVisible(true);
								}else{
									me.setVisible(false);
								}
							}
						},
						colspan: 3,						
			              features: [{			              	
					            id: 'summary',
					            ftype: 'summary',
					            hideGroupedHeader: true,
					            enableGroupingMenu: false,					           
					            dock: 'bottom'						       
					           
						    }],
						columns: [
						    {   text: HreRem.i18n('header.listado.deudores.fecha.alta'),						    
						    	dataIndex:'fechaAlta',						    	
								formatter: 'date("d/m/Y")',								
					        	flex:1 
					        },
					        {   text:  HreRem.i18n('fieldlabel.listado.deudores.gestor.alta'), 
					        	dataIndex: 'gestorAlta',
					        	flex:1 
					        },
					        {   text: HreRem.i18n('fieldlabel.listado.deudores.tipo.doc'), 
					        	dataIndex: 'tipoDocIdentificativoDesc',					        	
					        	reference:	'tipoDocDeudor',
					        	editor: {		                   					                  		 	 
				        			xtype: 'combobox',
									addUxReadOnlyEditFieldPlugin: false,
					        		   labelWidth: '65%',
							            width: '40%',
					            		allowBlank: false,					        	
					        		bind: {
					            		store: '{comboTipoDocumento}',				            		
					            		value: '{tipoDocIdentificativoDesc}',
					            		readOnly: '{!isGestorAdmisionAndSuper}'
					            	},
					            	displayField: 'descripcion',
									valueField: 'codigo',
									listeners:{
				                		change:'onChangeDebeComprobarNIF'
				                	}
			                	},
					        	flex:1 
					        },	
					        {   text: HreRem.i18n('fieldlabel.listado.deudores.doc.identificativo'), 
					        	dataIndex: 'docIdentificativo',					       
					        	reference:	'tipoNumeroDocumentoDeudor',
					        	editor: {										 
										  cls: 'grid-no-seleccionable-field-editor',
										  allowBlank:false,
										  listeners:{
									        	change: 'comprobarNIF'
									        		}
										  },
					        	flex:1 
					        },	
					        {   text: HreRem.i18n('fieldlabel.listado.deudores.nombre.razon.social'), 
					        	dataIndex: 'nombre',				        
					        	reference:	'razonSocialDeudor',
					        	editor: {										 
										  cls: 'grid-no-seleccionable-field-editor',
										  allowBlank: false,
										  listeners:{
									        	change: 'comprobarNIF'
									        		}
										  },
										 
					        	flex:2
					        },
					        {   text: HreRem.i18n('fieldlabel.listado.deudores.apellido.1'), 
					        	dataIndex: 'apellido1',
					        	reference:	'apellido1Deudor',
					        	editor: {										 
										  cls: 'grid-no-seleccionable-field-editor'
					        	},
					        	flex:2
					        },
					        {   text: HreRem.i18n('fieldlabel.listado.deudores.apellido.2'), 
					        	dataIndex: 'apellido2',
					        	reference:	'apellido2Deudor',
					        	editor: {										 
										  cls: 'grid-no-seleccionable-field-editor'										  
										  },
					        	flex:2 
					        }         	        
					    ]
		 	    				    						 	
					},
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						colspan: 3,
						reference:'judicial',
						bind:{
							hidden: '{!datosRegistrales.isJudicial}',
							disabled: '{!datosRegistrales.isJudicial}'
						},
						title: HreRem.i18n('title.adjudicacion.judicial'),
						items :
						
						[						
							{
								xtype: 'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.entidad.ejecutante.hipoteca'),
				            	bind: {
				            		store: '{comboEntidadesEjecutantes}',
				            		value: '{datosRegistrales.entidadEjecutanteCodigo}',
				            		readOnly: '{datosRegistrales.unidadAlquilable}',
									rawValue: '{datosRegistrales.entidadEjecutanteDescripcion}'
				            	}

							},

			                {
								xtype: 'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.estado.adjudicacion'),
				            	bind: {
				            		store: '{comboEstadoAdjudicacion}',
				            		value: '{datosRegistrales.estadoAdjudicacionCodigo}',
				            		readOnly: '{datosRegistrales.unidadAlquilable}',
									rawValue: '{datosRegistrales.estadoAdjudicacionDescripcion}'
				            	}
                                 
							},
			                { 
			                	xtype: 'datefieldbase',
			                	reference: 'fechaAutoAdjudicacion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.auto.adjudicacion'),
								bind: {
									value: '{datosRegistrales.fechaAdjudicacion}',
									readOnly: '{datosRegistrales.unidadAlquilable}',
									readOnly: '{isCarteraBankia}'
								}
                                 
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaFirmezaAutoAdjudicacion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.firmeza.auto.adjudicacion'),			                	
								bind: {
									value: '{datosRegistrales.fechaDecretoFirme}',
									readOnly: '{datosRegistrales.unidadAlquilable}',
									readOnly: '{isCarteraBankia}'
								}
                                 
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaSenyalamientoPosesion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.senyalamiento.posesion'),			                	
								bind: {
									value: '{datosRegistrales.fechaSenalamientoPosesion}',
									readOnly: '{datosRegistrales.unidadAlquilable}'
								}
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaRealizacionPosesion',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.realizacion.posesion'),
								bind: {
									value: '{datosRegistrales.fechaRealizacionPosesion}',
									readOnly: '{isCarteraBankiaeIsReadOnlyFechaRealizacionPosesion}',
									disabled: '{isCarteraLiberbank}'
								}
			                },
			                {
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.lanzamiento.necesario'),								
				            	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{datosRegistrales.lanzamientoNecesario}',
				            		readOnly: '{datosRegistrales.unidadAlquilable}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
							},
							{
			                	xtype: 'datefieldbase',
			                	reference: 'fechaSenyalamientoLanzamiento',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.senyalamiento.lanzamiento'),			                	
								bind: {
									value: '{datosRegistrales.fechaSenalamientoLanzamiento}',
									readOnly: '{isCarteraBankiayUnidadAlquilable}'
								}
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaLanzamientoEfectuado',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.lanzamiento.efectuado'),			                	
								bind: {
									value: '{datosRegistrales.fechaRealizacionLanzamiento}',
									readOnly: '{isCarteraBankiayUnidadAlquilable}'
								}
			                },
			                {
			                	xtype: 'datefieldbase',
			                	reference: 'fechaSolicitudMoratoria',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.solicitud.moratoria'),			                	
								bind: {
									value: '{datosRegistrales.fechaSolicitudMoratoria}',
									readOnly: '{datosRegistrales.unidadAlquilable}'
								}
			                },
			                {
								xtype: 'comboboxfieldbasedd',
								fieldLabel: HreRem.i18n('fieldlabel.resolucion.moratoria'),
				            	bind: {
				            		store: '{comboFavorableDesfavorable}',
				            		value: '{datosRegistrales.resolucionMoratoriaCodigo}',
				            		readOnly: '{datosRegistrales.unidadAlquilable}',
									rawValue: '{datosRegistrales.resolucionMoratoriaDescripcion}'
				            	}
							},
							{
			                	xtype: 'datefieldbase',
			                	reference: 'fechaResolucionMoratoria',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.resolucion.moratoria'),			                	
								bind: {
									value: '{datosRegistrales.fechaResolucionMoratoria}',
									readOnly: '{isCarteraBankiayUnidadAlquilable}'
								},
								maxValue:null
								
			                },
							{ 
								xtype: 'currencyfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.importe.adjudicacion'),
								bind: {
									value: '{datosRegistrales.importeAdjudicacion}',
									readOnly: '{datosRegistrales.unidadAlquilable}'
								}
			                },
			                {
								xtype: 'comboboxfieldbasedd',
								name: 'comboJuzgado',
								reference: 'comboJuzgado',
			                	fieldLabel: HreRem.i18n('fieldlabel.tipo.juzgado'),
								emptyText: 'Seleccione Población juzgado',
								selectFirst: true,
				            	bind: {
				            		store: '{comboTiposJuzgadoPlaza}',
				            		value: '{datosRegistrales.tipoJuzgadoCodigo}',
				            		readOnly: '{datosRegistrales.unidadAlquilable}',
									rawValue: '{datosRegistrales.tipoJuzgadoDescripcion}',
									disabled: '{!datosRegistrales.tipoPlazaCodigo}'
				            	}
							},
			                {
								xtype: 'comboboxfieldbasedd',
								name: 'comboPlaza',
								reference: 'comboPlaza',
			                	fieldLabel: HreRem.i18n('fieldlabel.poblacion.juzgado'),
				            	bind: {
				            		store: '{comboTiposPlaza}',
				            		value: '{datosRegistrales.tipoPlazaCodigo}',
				            		readOnly: '{datosRegistrales.unidadAlquilable}',
									rawValue: '{datosRegistrales.tipoPlazaDescripcion}'
				            	},
								chainedStore: 'comboTiposJuzgadoPlaza',
								chainedReference: 'comboJuzgado',
				            	listeners: {
				            		select: 'onChangeChainedCombo'
				            	}
							},
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.numero.autos'),
			                	bind: {
			                		value: '{datosRegistrales.numAuto}',
			                		readOnly: '{isCarteraBankiayUnidadAlquilable}'
//			                		readOnly: '{datosRegistrales.unidadAlquilable}'
			                	}
			                },
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.procurador'),
			                	bind: {
			                		value: '{datosRegistrales.procurador}',
			                		readOnly: '{datosRegistrales.unidadAlquilable}'
			                	}
			                },
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.letrado'),
						 		bind: {
						 			value: '{datosRegistrales.letrado}',
						 			readOnly: '{datosRegistrales.unidadAlquilable}'
						 		}
							},
			                { 
			                	fieldLabel: HreRem.i18n('fieldlabel.id.asunto.recovery'),
			                	bind: {
			                		value: '{datosRegistrales.idAsunto}',
			                		readOnly: '{datosRegistrales.unidadAlquilable}'
			                	}
			                	
			                },
							{
								fieldLabel : HreRem
										.i18n('fieldlabel.id.proceso.origen'),
								bind : {
									value : '{datosRegistrales.idProcesoOrigen}',
									readOnly : '{esUA}'
								}

							},
			                {
			                	xtype: 'numberfieldbase',
			                	maxLength: 4,
			                	fieldLabel: HreRem.i18n('fieldlabel.expedientes.con.defectos.testimonio'),
			                	bind: {
			                		value: '{datosRegistrales.defectosTestimonio}',
			                		readOnly: '{datosRegistrales.unidadAlquilable}'
			                	}
			                }
						]

            		},
            		{
						xtype:'fieldsettable',
						reference:'noJudicial',
						colspan: 3,
						bind:{
							hidden: '{!datosRegistrales.isNotJudicial}',
							disabled: '{!datosRegistrales.isNotJudicial}'
						},
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.adjudicacion.no.judicial'),
						items : [
							{
					        	xtype: 'comboboxfieldbase',					        	
						 		fieldLabel: HreRem.i18n('fieldlabel.gestion.hre'),
						 		hidden: true,
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{datosRegistrales.gestionHre}',
				            		readOnly: '{datosRegistrales.unidadAlquilable}'
				            	},
				            	allowBlank: false
					        },
			                {
								xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.titulo'),
						 		reference: 'fechaTitulo',
						 		bind: {
						 			value: '{datosRegistrales.fechaTitulo}',
//						 			readOnly: '{datosRegistrales.unidadAlquilable}'
						 			readOnly: '{isCarteraBankiayUnidadAlquilable}'
						 		}
							},
							{
								xtype:'datefieldbase',
								reference: 'fechaFirmezaTitulo',
								fieldLabel: HreRem.i18n('fieldlabel.fecha.firmeza.titulo'),
						 		bind: {
						 			value: '{datosRegistrales.fechaFirmaTitulo}',
						 			readOnly: '{datosRegistrales.unidadAlquilable}'
						 		}
							},
			                { 
								xtype:'currencyfieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.valor.adquisicion'),
						 		bind: {
						 			value: '{datosRegistrales.valorAdquisicion}',
						 			readOnly: '{isCarteraBankiayUnidadAlquilable}'
//						 			readOnly: '{datosRegistrales.unidadAlquilable}'
						 		}
							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.notario.juzgado.organo.administrativo'),
						 		bind: {
						 			value: '{datosRegistrales.tramitadorTitulo}',
						 			readOnly: '{datosRegistrales.unidadAlquilable}'
						 		}

							},
			                { 
						 		fieldLabel: HreRem.i18n('fieldlabel.protocolo.autos.numero.expediente'),
						 		bind: {
						 			value: '{datosRegistrales.numReferencia}',
						 			readOnly: '{datosRegistrales.unidadAlquilable}'
						 		}
							},
                            {
                                xtype: 'numberfieldbase',
                                maxLength: 4,
                                fieldLabel: HreRem.i18n('fieldlabel.expedientes.con.defectos.testimonio'),
                                bind: {
                                	value: '{datosRegistrales.defectosTestimonio}',
                                	readOnly: '{datosRegistrales.unidadAlquilable}'
                                }
                            },
                            { 
                            	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.adjudicacion.no.judicial.fecha.posesion'),
						 		bind: {
						 			value: '{datosRegistrales.fechaPosesion}',
						 			readOnly: '{isGestorActivosAndSuper}',
						 			hidden: '{!isSubcarteraCerberus}'
						 		}

							},
                            {
                                fieldLabel: HreRem.i18n('fieldlabel.id.asunto.recovery'),
                                bind: {
                                    value: '{datosRegistrales.idAsuntoRecAlaska}',
                                    readOnly: 'true'
                                }
                            },
							{
								fieldLabel : HreRem
										.i18n('fieldlabel.id.proceso.origen'),
								bind : {
									value : '{datosRegistrales.idProcesoOrigen}',
									readOnly : '{esUA}'
								}

							}
						]

        			},
        			{
						xtype:'fieldsettable',
						reference:'pdv',
						colspan: 3,
						bind:{
							hidden: '{!datosRegistrales.isPdv}',
							disabled: '{!datosRegistrales.isPdv}'
						},
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
   		fechaTitulo = me.down("[reference=fechaTitulo]"),
   		fechaFirmezaTitulo = me.down("[reference=fechaFirmezaTitulo]"),
   		fieldsetNoJudicial = me.down("[reference=noJudicial]"),
   		fieldsetJudicial = me.down("[reference=judicial]"),
   		fechaFirmezaAutoAdjudicacion = me.down("[reference=fechaFirmezaAutoAdjudicacion]"),
   		fechaTomaPosesion = me.down("[reference=fechaTomaPosesionJudicial]"),
   		fechaAutoAdjudicacion = me.down("[reference=fechaAutoAdjudicacion]");

   		motivoCalNegativa = me.down("[reference=itemselMotivo]");
   		superficieParcelaUtil = me.down("[reference=superficieParcelaUtil]");

   		if(provinciaRegistro.isVisible() && provinciaRegistro.getValue() != codigoProvinciaDomicilio) {
   			error = HreRem.i18n("txt.validacion.provincia.diferente.registro");
   			errores.push(error);
   			provinciaRegistro.markInvalid(error); 
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
		me.getViewModel().data.nClicks=0;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
		});
   }
});
