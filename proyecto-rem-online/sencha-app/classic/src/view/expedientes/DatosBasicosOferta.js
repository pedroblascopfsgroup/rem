Ext.define('HreRem.view.expedientes.DatosBasicosOferta', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosoferta',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosoferta',
    scrollable	: 'y',
refreshAfterSave: true,
recordName: "datosbasicosoferta",

recordClass: "HreRem.model.DatosBasicosOferta",
    
    requires: ['HreRem.model.DatosBasicosOferta','HreRem.view.activos.detalle.ActivoDetalleModel',
    'HreRem.model.OfertasAgrupadasModel', 'HreRem.view.expedientes.OfertasAgrupadasTabPanel','HreRem.view.expedientes.SancionesGrid', 'HreRem.view.activos.detalle.TestigosOfertaGrid'],
    
    listeners: {
		boxready:'cargarTabData',
		beforeedit: 'numVisitaIsEditable',
		afterrender: 'doCalculateTitleByComite'
	},
    
    initComponent: function () {

        var me = this;

		/*var storeNecesitaFinanciacion = Ext.create('Ext.data.Store', {
		data : [
		{"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		{"codigo":"0", "descripcion":"No"}
		]
		});*/

		me.setTitle(HreRem.i18n('title.datos.basicos'));
		var items = [

		{
			xtype : 'fieldsettable',
			defaultType : 'displayfieldbase',
			layout: {
		        type: 'table',
		        columns: 3,
		        tdAttrs: {
		        	width: '33%',
		        	style: 'vertical-align: top'
		        },
		        tableAttrs: {
		            style: {
		                width: '100%'
						}
		        }
			},
			
			title : HreRem.i18n('title.detalle.oferta'),
			items : [
					
					{
					xtype : 'fieldsettable',
					defaultType : 'displayfieldbase',
					collapsible: false,
					border: false,
					colspan: 3,
					layout: {
				        type: 'table',
				        columns: 3,
				        tdAttrs: {
				        	width: '33%',
				        	style: 'vertical-align: top'
				        },
				        tableAttrs: {
				            style: {
				                width: '100%'
								}
				        }
					},

					items : [
						{
							fieldLabel : HreRem.i18n('fieldlabel.num.oferta'),
							bind : '{datosbasicosoferta.numOferta}'
	
						}, {
							xtype : 'comboboxfieldbase',
							readOnly : true,
							bind : {
								store : '{comboTipoOferta}',
								value : '{datosbasicosoferta.tipoOfertaCodigo}'
							},
							fieldLabel : HreRem.i18n('fieldlabel.tipo')
						}, {
							xtype : 'datefieldbase',
							formatter : 'date("d/m/Y")',
							fieldLabel : HreRem.i18n('fieldlabel.fecha.alta'),
							bind : '{datosbasicosoferta.fechaAlta}'
						},
							{
							fieldLabel : HreRem.i18n('fieldlabel.numero.oferta.caixa'),
							bind : {
								value: '{datosbasicosoferta.numOfertaCaixa}',
								hidden: '{!esBankia}'
							},
							readOnly: true
	
						}, {
							xtype : 'comboboxfieldbase',
							bind : {
								store : '{comboEstadoOferta}',
								value : '{datosbasicosoferta.estadoCodigo}'
							},
							readOnly : !$AU.userIsRol("HAYASUPER"),
							fieldLabel : HreRem.i18n('fieldlabel.estado')
						}, 	
						{
							xtype : 'textfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.prescriptor'),
							bind : {
								value : '{datosbasicosoferta.prescriptor}'
							},
							readOnly : true
						},
						{
							xtype : 'textfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.canal.prescripcion'),
							bind : '{datosbasicosoferta.canalPrescripcionDescripcion}',
							readOnly : true
						}, {
							xtype : 'currencyfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.importe.inicial.oferta'),
							bind : '{datosbasicosoferta.importeOferta}'
						}, {
							xtype : 'currencyfieldbase',
							fieldLabel : HreRem
									.i18n('fieldlabel.importe.contraoferta'),
							bind : {
								value : '{datosbasicosoferta.importeContraOferta}',
								readOnly : '{esPerfilPMyCEs}'
							}
						}, {
							xtype : 'textfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.venta.cartera'),
							bind : {
								value : '{datosbasicosoferta.ventaCartera}',
								readOnly : 'true',
								hidden : '{esAlquilerOAlquilerNoComercial}'
							}
						},
						{
						xtype : 'datefieldbase',
						formatter : 'date("d/m/Y")',
						colspan: '{getcolSpanforSarebOrDefault}',
						fieldLabel : HreRem.i18n('fieldlabel.fecha.oferta.pendiente'),
						readOnly : true,
						bind : '{datosbasicosoferta.fechaOfertaPendiente}'
						},
						{
                            xtype : 'textfieldbase',
                            fieldLabel : HreRem.i18n('filedlabel.numero.vai.havai'),
                            bind : {
                                value : '{datosbasicosoferta.numeroVaiHavaiSareb}',
                                hidden : '{!esCarteraSareb}'
                            }
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.detalle.oferta.alquiler.clasificacion'),
							reference: 'comboClasificacionRef',
							bind:{
								store:'{storeClasificacion}',
								value:'{datosbasicosoferta.clasificacionCodigo}',
								hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.clase.contrato'),
							reference: 'comboClaseContratoRef',
							bind:{
								store:'{storeClaseContrato}',
								value:'{datosbasicosoferta.claseContratoCodigo}',
								hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
							}
						},
						{
							xtype : 'comboboxfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.empleado.familiar.caixa'),
							reference: 'empleadoCaixaRef',
							bind : {
								store : '{comboEmpleadoCaixa}',
								value : '{datosbasicosoferta.isEmpleadoCaixa}',
								hidden: '{!esBankia}',
								readOnly: true
							}
						},
						{
							xtype : 'comboboxfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.canal.distribucion.bc'),
							reference: 'canalDistribucionBcRef',
							bind : {
								store : '{comboCanalDistribucionBc}',
								value : '{datosbasicosoferta.canalDistribucionBc}',
								hidden: '{!esBankia}',
								readOnly: true
							}
						},
						{
							xtype : 'comboboxfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.detalle.oferta.alquiler.documentacion.completa'),
							reference: 'checkDocumentacionCompletaRef',
							bind : {
								store : '{comboSiNoBoolean}',
								value : '{datosbasicosoferta.checkListDocumentalCompleto}',
								hidden: '{!esAlquilerNoComercial}' 
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipologia.venta'),
							name: 'tipologiaVentaCod',
							reference: 'tipologiaVentaCodRef', 
							allowBlank: true,
							bind: {
								store: '{comboTipologiaVentaBcOfr}',
								value: '{datosbasicosoferta.tipologiaVentaCod}',
								hidden: '{!esBankiaVenta}'
							},
							displayField: 'descripcion',
							valueField: 'codigo'
						},
					{
						bind : {hidden : '{!esTipoAlquiler}'}
					}
						]},
					{
						xtype : 'fieldsettable',
						defaultType : 'displayfieldbase',
						title : 'Bulk Advisory Note',
						collapsible: false,
						bind: {
							hidden: '{!esCarteraAppleOrRemainingOrJaguar}'
						},
						colspan: 3,
						layout: {
					        type: 'table',
					        columns: 3,
					        tdAttrs: {
					        	width: '33%',
					        	style: 'vertical-align: top'
					        },
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
						},
						items : [ 
								{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.exclusion.bulk'),
								bind : {
									store: '{comboSiNoExclusionBulk}',
									value : '{datosbasicosoferta.exclusionBulk}',
									readOnly : '{!requisitosEdicionExclusionBulk}',
									hidden : '{!esCarteraAppleOrRemainingOrJaguar}'
								}
							},
								{
								xtype : 'textfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.id.advisory.note'),
								bind : {
									value : '{datosbasicosoferta.idAdvisoryNote}',
									readOnly : '{!requisitosEdicionIdAdvisoryNote}',
									hidden : '{!esCarteraAppleOrRemainingOrJaguar}'
								}
							},	{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.tipo.alquiler'),
								bind : {
									store : '{comboTipoAlquiler}',
									value : '{datosbasicosoferta.tipoAlquilerCodigo}',
									hidden : '{!esTipoAlquiler}'
								}
							}, {
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.tipo.inquilino'),
								bind : {
									store : '{comboTiposInquilino}',
									value : '{datosbasicosoferta.tipoInquilinoCodigo}',
									hidden : '{!esTipoAlquiler}'
								}
							}, {
								xtype : 'textfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.num.contrato.prinex'),
								bind : {
									value : '{datosbasicosoferta.numContratoPrinex}',
									hidden : '{!esTipoAlquiler}'
								}
							}, {
								xtype : 'textfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.ref.circuito.cliente'),
								bind : {
									value : '{datosbasicosoferta.refCircuitoCliente}',
									hidden : '{!esTipoAlquiler}'
								}
							},			
							{
								xtype: 'comboboxfieldbase',
								readOnly: !$AU.userIsRol("HAYASUPER"),
								fieldLabel:  HreRem.i18n('fieldlabel.gestor.comercial.prescriptor'),
								reference: 'comboGestorComercialPrescriptor',
								bind:{
									store:'{storeComboGestorPrescriptor}',
									value:'{datosbasicosoferta.idGestorComercialPrescriptor}',
									hidden: '{!mostrarPrescriptorCajamar}'
								}
							},{
								xtype : 'datefieldbase',
								formatter : 'date("d/m/Y")',
								reference: 'fechaResolucionCES',
								bind : {
									value : '{datosbasicosoferta.fechaResolucionCES}',
									hidden : '{!esSubcarteraRemainingOAppleOArrow}'
								},						
								readOnly : true
							}, {
								xtype : 'currencyfieldbase',
								reference: 'importeContraOfertaCES',
								bind : {
									value : '{datosbasicosoferta.importeContraofertaCES}',
									hidden : '{!esSubcarteraRemainingOAppleOArrow}'
								},						
								readOnly : true
							}, {
								xtype : 'datefieldbase',
								reference: 'fechaResupuestaCES',
								bind : {
									value : '{datosbasicosoferta.fechaRespuestaCES}',
									hidden : '{!esSubcarteraRemainingOAppleOArrow}'
								},					
								readOnly : true
							}, 
							{
								xtype : 'currencyfieldbase',
								reference:'importeContraofertaOfertanteCES',
								bind : {
									value : '{datosbasicosoferta.importeContraofertaOfertanteCES}',
									hidden : '{!esSubcarteraRemainingOAppleOArrow}'
								},						
								readOnly : true
							}, {
								xtype : "container",
								layout : "hbox",
								colspan : 3,
								items : [{
									xtype : 'button',
									reference: 'btnSacarBulk',																
									text : 'Excluir del Bulk',
									handler : 'sacarBulk',
									bind : {
										hidden : '{!requisitosVisibleBotonExcluirBulk}'
									},
									margin : '10 10 10 0'
								}]
		
							}
						]},
					{
						xtype : 'fieldsettable',
						defaultType : 'displayfieldbase',
						collapsible: false,
						border: false,
						colspan: 3,
						layout: {
					        type: 'table',
					        columns: 3,
					        tdAttrs: {
					        	width: '33%',
					        	style: 'vertical-align: top'
					        },
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
						},
						bind : {
							hidden : '{!datosbasicosoferta.isCarteraLbkVenta}' 
						},
						items : [{
							xtype : 'numberfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.numOferPrincipal'),
							name : 'numOferPrincipal',
							//readOnly : true,
							bind : {
								value : '{datosbasicosoferta.numOferPrincipal}'
							}

						}, {
							xtype : 'textfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.importe.total'),
							name: 'importeTotal',
							readOnly : true,
							bind : {
								value : '{datosbasicosoferta.importeTotal}'
							}

						},
		                {
			                xtype:'numberfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.nuevoNumOferPrincipal'),
							name: 		'nuevoNumOferPrincipal', 
		 					bind: 		{ 
								value: '{datosbasicosoferta.nuevoNumOferPrincipal}'	
							}
		                	
		                }]
					},
					{
						xtype : 'fieldsettable',
						defaultType : 'displayfieldbase',
						collapsible: false,
						border: false,
						colspan: 3,
						layout: {
					        type: 'table',
					        columns: 3,
					        tdAttrs: {
					        	width: '33%',
					        	style: 'vertical-align: top'
					        },
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
						},
						bind : {
							hidden : '{esAlquilerOAlquilerNoComercial}' 
						},
						items : [
							{
								xtype : 'checkboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.venta.cartera.cfv'),
								bind : {
									value : '{datosbasicosoferta.ventaCarteraCfv}',
									readOnly : '{readOnlyDatosCfv}'
								}
							},{
								xtype : 'checkboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.oferta.especial'),
								bind : {
									value : '{datosbasicosoferta.ofertaEspecial}',
									readOnly : true
								}
							}, {
								xtype : 'checkboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.venta.sobre.plano'),
								bind : {
									value : '{datosbasicosoferta.ventaSobrePlano}',
									readOnly : '{readOnlyDatosCfv}'
								}
							}, {
								xtype : 'comboboxfieldbasedd',
								fieldLabel : HreRem.i18n('fieldlabel.riesgo.operacion'),
								bind : {
									store : '{comboRiesgoOperacion}',
								    value : '{datosbasicosoferta.riesgoOperacionCodigo}',
								    rawValue : '{datosbasicosoferta.riesgoOperacionDescripcion}',
									readOnly : '{readOnlyDatosCfv}'
								}
							},
							{
								xtype : 'comboboxfieldbasedd',
								fieldLabel : HreRem.i18n('fieldlabel.riesgo.operacion.bc'),
								bind : {
									store : '{comboRiesgoOperacion}',
								    value : '{datosbasicosoferta.riesgoOperacionBcCodigo}',
								    rawValue : '{datosbasicosoferta.riesgoOperacionBcDescripcion}',
								    hidden: '{!esBankia}',
									readOnly : '{readOnlyDatosCfv}'
								}
							}
						]
					},
					{
					xtype : 'container',
					layout: 'hbox',
					colspan : 3,								
					items : [
					{
						xtype : 'fieldsettable',
						collapsible: false,
						border: false,
						width: '33%',
						margin: '0 10 10 0',
						layout: {
					        type: 'table',
					        columns: 1,
					        tdAttrs: {
					        	width: '100%'
					        },
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
						},
						items : [
					{
						xtype : 'fieldsettable',
						colspan: 1,
						collapsible: false,
						bind : { title : '{expediente.tituloCarteraLiberbankVenta}',
							hidden: '{expediente.esBankia}'
						},
						layout: {
					        type: 'table',
					        columns: 1,
					        tdAttrs: {
					        	width: '100%'
					        },
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
						},
						items : [
							{
									xtype: 'comboboxfieldbase',
									fieldLabel:  HreRem.i18n('fieldlabel.claseOferta'),
									itemId: 'comboClaseOferta',
									reference: 'claseOferta',
									name: 'claseOferta',
									bind: {
										readOnly: '{datosbasicosoferta.estadoAprobadoLbk}',
										store: '{comboClaseOferta}',
										value: '{datosbasicosoferta.claseOfertaCodigo}', 
										hidden: '{!datosbasicosoferta.isCarteraLbkVenta}'
									},
									displayField: 'descripcion',
									valueField: 'codigo',
									listeners: {
		    							change: 'changeOfrPrincipalOrDep'
				    				}
							}, {
							xtype : 'comboboxfieldbase',
							reference : 'comboComiteSeleccionado',
							readOnly : false,
							bind : {
								store : '{comboComites}',
								value : '{datosbasicosoferta.comiteSancionadorCodigo}',
								readOnly : '{comiteSancionadorNoEditable}',
								hidden : '{esOfertaAlquiler}',
								fieldLabel : '{expediente.comiteComboboxLabel}'

							},
							listeners: {
								change: 'onComiteChange'
							},
							// TODO Sobreescribimos la función porque está dando problemas la carga del store. A veces llega null.
							setStore : function(store) {
								if (!Ext.isEmpty(store)) {
									this.bindStore(store);
								}
							}
						}, {
							xtype : 'comboboxfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.comite.propuesto'),
							reference : 'comboComitePropuesto',
							readOnly : true,
							bind : {
								store : '{comboComitesPropuestos}',
								value : '{datosbasicosoferta.comitePropuestoCodigo}',
								hidden : '{!esCarteraLiberbankVenta}'
							},
							// TODO Sobreescribimos la función porque está dando problemas la carga del store. A veces llega null.
							setStore : function(store) {
								if (!Ext.isEmpty(store)) {
									this.bindStore(store);
								}
							}
						}, {
							xtype : 'comboboxfieldbase',
							fieldLabel : HreRem.i18n('fieldlabel.comite.alquiler'),
							reference : 'comboComiteSeleccionadoAlquiler',
							readOnly : false,
							bind : {
								store : '{comboComitesAlquiler}',
								value : '{datosbasicosoferta.comiteSancionadorCodigoAlquiler}',
								readOnly : '{comiteSancionadorNoEditable}',
								hidden : '{!esOfertaAlquiler}'

							},
							// TODO Sobreescribimos la función porque está dando problemas la carga del store. A veces llega null.
							setStore : function(store) {
								if (!Ext.isEmpty(store)) {
									this.bindStore(store);
								}
							}
						},{
								xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.comite.propuesto'),
								reference : 'comboComitePropuesto',
								readOnly : true,
								bind : {
									store : '{comboComitesPropuestos}',
									value : '{datosbasicosoferta.comitePropuestoCodigo}',
									disabled : '{!esCarteraBankia}',
									hidden : '{!esCarteraBankia}'
								},
								// TODO Sobreescribimos la función porque está dando problemas la carga del store. A veces llega null.
								setStore : function(store) {
									if (!Ext.isEmpty(store)) {
										this.bindStore(store);
									}
								}
							}, {
								xtype : 'container',
								bind : {
									hidden : '{!esCarteraBankia}'
								},
								layout : 'hbox',
								colspan: 1,
								items : [
								 {
									xtype : 'button',
									text : HreRem.i18n('btn.consultar.comite'),
									handler : 'consultarComiteSancionador',
									disabled : true,
									bind : {
										disabled : '{!editing}'
									},
									margin : '10 10 10 0'
								}]
	
							}

						]

					},
					{
						xtype : 'fieldsettable',	
						colspan: 1,	
						collapsible: false,
						title : HreRem.i18n('title.visita'),
						layout: {
					        type: 'table',
					        columns: 1,
					        tdAttrs: {
					        	width: '100%'
					        },
					        tableAttrs: {
					            style: {
					                width: '100%'
									}
					        }
						},
						//margin: '0 10 10 0',
						items : [{
							xtype : 'comboboxfieldbase',
							reference : 'comboEstadosVisita',
							fieldLabel : HreRem.i18n('fieldlabel.estado'),
							bind : {
								store : '{comboEstadosVisitaOferta}',
								value : '{datosbasicosoferta.estadoVisitaOfertaCodigo}'
							},
							listeners : {
								change : 'numVisitaIsEditable'
							}
						}, {
							xtype : 'container',
							layout : 'hbox',
							colspan: 1,
							items : [{
								xtype : 'button',
								text : HreRem.i18n('fieldlabel.asignar.visita'),
								margin : '0 10 0 0',
								hidden : true

							}, {
								xtype : 'numberfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.numero.visita'),
								reference : 'numVistaFromOfertaRef',
								bind : {
									value : '{datosbasicosoferta.numVisita}'
								},
								margin : '0 0 12 0'

							}]
						},
							{
								xtype : 'numberfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.numero.contacto'),
								reference : 'numContactoFromOfertaRef',
								bind : {
									value : '{datosbasicosoferta.numeroContacto}',
									hidden: '{!esBankia}'
								}/*,
								margin : '0 0 12 0'*/

							}]

					}]
					},  {
						xtype : 'fieldsettable',
						title : HreRem.i18n('title.comerical.oferta'),
						width: '66%',
						layout: {
					        type: 'table',
					        columns: 2,
					        tdAttrs: {
					        	width: '50%'
					        },
					        tableAttrs: {
					            style: {
					            	width: '100%'
								}
					        }
						},
						
						items : [
						{
							xtype : "fieldsettable",
							collapsible: false,
							border: false,
							layout: {
						        type: 'table',
						        columns: 2
						    },
						    bind : {
								hidden: '{esAlquilerOAlquilerNoComercial}'
							},
							items : [
								{
									xtype : "textfieldbase",
									fieldLabel : HreRem.i18n('fieldlabel.comerical.oferta.detalle.cajamar.ofertaExpress'),
									bind : {
										value : '{datosbasicosoferta.ofertaExpress}',
										hidden : '{esTipoAlquiler}'
									},
									readOnly : true
								}, {
									xtype: "textfieldbase",
									fieldLabel: HreRem.i18n('fieldlabel.detalle.oferta.singular'),
									bind: {
										value: '{datosbasicosoferta.ofertaSingular}'
									},
				    				readOnly: true
				    			}, {
									xtype : 'comboboxfieldbase',
									bind : {
										store : '{comboDDSNS}',
										value : '{datosbasicosoferta.necesitaFinanciacion}'
									},
									fieldLabel : HreRem.i18n('fieldlabel.comerical.oferta.detalle.cajamar.necesitaFinanciacion')
								}, 						
								{
									xtype : "textareafieldbase",
									fieldLabel : HreRem.i18n('fieldlabel.comerical.oferta.detalle.cajamar.observaciones'),
									labelAlign: 'top',
									grow: true,
									anchor: '100%',
									bind : {
										value : '{datosbasicosoferta.observaciones}'
									},
									width: '100%',
									rowspan: 4
								},
				    			{
									xtype : "comboboxfieldbase",
									fieldLabel : HreRem.i18n('fieldlabel.oferta.subasta'),
									bind : {
										store : '{comboSiNoBoolean}',
										value : '{datosbasicosoferta.checkSubasta}',
										hidden: '{!esBankia}'
									}
								}
							]
						},
						{
							xtype : "fieldsettable",
							collapsible: false,
							border: false,
							layout: {
						        type: 'table',
						        columns: 1
						    },
							bind : {
								hidden: '{!esBankiaAlquilerOAlquilerNoComercial}'
							},
							items : [
								{
									xtype : "comboboxfieldbase",
									fieldLabel : HreRem.i18n('fieldlabel.detalle.oferta.opcionCompra'),
									colspan: 2,
									name : 'opcionCompra',
									bind : {
										store : '{comboSiNoBoolean}',
										value : '{datosbasicosoferta.opcionACompra}'
									},
									listeners: {
		    							change: 'changeOpcionCompra'
				    				}
								}, {
									xtype: "numberfieldbase",
									fieldLabel: HreRem.i18n('fieldlabel.detalle.oferta.valor.opcionCompra'),
									name : 'valorOpcionCompra',
									bind: {
										value: '{datosbasicosoferta.valorCompra}'
									}
				    			},
				    			{
				    				xtype : 'datefieldbase',
									formatter : 'date("d/m/Y")',
									fieldLabel: HreRem.i18n('fieldlabel.detalle.oferta.fecha.vencimiento.opcionCompra'),
									name : 'fechaOpcionCompra',
									maxValue: null,
									minValue: $AC.getCurrentDate(),
									bind: {
										value: '{datosbasicosoferta.fechaVencimientoOpcionCompra}'
									}
				    			}
							]
						}

						]
					}]},
					{
						xtype : 'ofertasagrupadastabpanel',
						colspan : 3
					}, {
						xtype : "container",
						layout : "hbox",
						colspan : 3,
						items : [{
							xtype : 'button',
							reference : 'btnSendPropuesta',
							bind : {/*hidden: '{!datosbasicosoferta.permiteProponer}'*/},
							rowspan : 2,
							text : HreRem.i18n('btn.propuesta.oferta'),
							handler : 'onClickGeneraOfertarHojaExcel',
							margin : '10 10 10 10'
						},
						{
                        	xtype : 'button',
                        	reference : 'btnSendInterlocutores',
                        	bind : {
                        	        hidden: '{!mostrarBotonLanzarPBC}'
                        	       },
                        	rowspan : 2,
                        	text : HreRem.i18n('btn.enviar.bc'),
                        	handler : 'lanzarDatosPbc',
                        	margin : '10 10 10 10'
                        },
						//TODO: Pruebas del excel
						/*{
							xtype : 'button',
							reference : 'btnGenerarFichaComercial', 
							rowspan : 2,
							text : 'superboton',
							handler : 'onClickGeneraFichaComercialHojaExcel',
							margin : '10 10 10 10'
						},*/
						{
							xtype : 'button',
							reference : 'btnSendAprobacion',
							bind : {
								hidden : '{!esTipoAlquiler}',
								disabled : '{!esOfertaTramitada}'
							},
							text : HreRem.i18n('btn.enviar.mail.aprobacion'),
							handler : 'onClickEnviarMailAprobacion',
							margin : '10 10 10 10'
						}, {
							xtype : 'button',
							reference : 'btnExportarActivosLibertyBankVenta',
							bind : {
								hidden : '{!expediente.esCarteraLiberbankVenta}'
							},
							text : HreRem
									.i18n('title.activo.administracion.exportar.listado.activos'),
							handler : 'onClickGenerarListadoDeActivos',
							margin : '10 10 10 10'

						}, {
							xtype : 'button',
							reference : 'btngenerarfichacomercial',
							bind : {
								hidden : '{esTipoAlquiler}',
								disabled : '{!habilitarBotonGenerarFicha}'
							},
							text : HreRem.i18n('btn.generar.ficha.comercial'),
							handler : 'onClickGenerarFichaComercial',
							margin : '10 10 10 10'
						}]

					}]
		},
		{
			xtype : 'fieldset',
			title : HreRem.i18n('fieldlabel.sanciones'),
			colspan : 3,
			bind:{
				hidden: '{!esBankia}'
			},
			items : [{
				xtype:'sancionesBkGrid'
			}]
			
		},
{
			xtype:'fieldsettable',
			title:HreRem.i18n('title.testigos'),
			defaultType: 'textfieldbase',
			items :
				[
					{xtype: "testigosofertagrid", reference: "testigosofertagrid"}
				]
		},
		{

			xtype : 'fieldset',
			title : HreRem.i18n('title.textos'),
			items : [{
						xtype : 'gridBaseEditableRow',
						idPrincipal : 'expediente.id',
						topBar : false,
						reference : 'listadoTextosOferta',
						cls : 'panel-base shadow-panel',
						secFunToEdit : 'EDITAR_GRID_TEXTOS_OFERTA_EXPEDIENTE',
						bind : {
							store : '{storeTextosOferta}'
						},
						listeners: {
							beforeedit: function(editor, context) {
					            var estado = context.record.get("campoCodigo");
					            var allowEdit = estado == '05' || estado == '06' || estado == '08' || estado == '09' || estado == '15';

					            return !allowEdit;
							},
							rowdblclick: function(grid, record){
								var cod = context.record.get("campoCodigo");
								var allowCopy = cod == '08' || cod == '09';
								if (allowCopy){
									var elem = document.createElement('textarea');
								    elem.value = record.get("texto");
								    document.body.appendChild(elem);
								    elem.select();
								    document.execCommand('copy');
								    document.body.removeChild(elem);
									me.fireEvent("infoToast", "Texto copiado correctamente");
								}
							}
						},
						columns : [{
									text : HreRem.i18n('header.campo'),
									dataIndex : 'campoDescripcion',
									flex : 1
								}, {
									text : HreRem.i18n('header.texto'),
									dataIndex : 'texto',
									flex : 4,
									editor : {
										xtype : 'textarea'
									}
								},	{
									text : HreRem.i18n('header.fecha'),
									dataIndex : 'fecha',
									flex : 1
								}]
					}]
		}

		];

		me.addPlugin({
					ptype : 'lazyitems',
					items : items
				});

		me.callParent(); 
    },

    funcionRecargar: function() {
    var me = this;
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
					grid.getStore().load();
  		});	

    }
});
