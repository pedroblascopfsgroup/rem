Ext.define('HreRem.view.activos.detalle.SaneamientoActivoDetalle', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'saneamientoactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    refreshAfterSave: true,
    disableValidation: true,
    reference: 'saneamientoactivoref',
    scrollable	: 'y',
    launch: null,
    listeners: {
			boxready:'cargarTabData'
	},

	recordName: "saneamiento",
	
	recordClass: "HreRem.model.ActivoSaneamiento",
	
	requires : ['HreRem.model.ActivoCargasTab', 'HreRem.view.common.FieldSetTable','HreRem.model.Catastro', 'HreRem.model.DocumentacionAdministrativa'
		,'HreRem.model.ActivoInformacionAdministrativa', 'HreRem.view.activos.detalle.ObservacionesActivo'],
	
    initComponent: function () {
        var me = this;
        
        me.setTitle(HreRem.i18n('title.admision.saneamiento'));

        var items= [

			{    
				xtype:'fieldsettable',
				title:HreRem.i18n('title.admision.inscripcion'),
				defaultType: 'textfieldbase',
				layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 1,
			        tdAttrs: {width: '100%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				items :
					[
						{
				        	xtype:'fieldsettable',

				        	defaultType: 'textfieldbase',
							items: [
						        {
									xtype: 'textfieldbase',
									reference: 'gestoriaAsignada',
									fieldLabel: HreRem.i18n('fieldlabel.admision.saneamiento.gestoriaAsig'),
									readOnly: true,
									bind: {
										value:'{saneamiento.gestoriaAsignada}'
									}
						        },
						        {
						        	xtype:'datefieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.admision.saneamiento.fechaAsignacion'),	        	
						        	readOnly: true,
						        	bind: {
										value:'{saneamiento.fechaAsignacion}'
									}
						        }
						    
							]
						},
				//copiar Tramitacion titulo de la pestaña Título e información registral
						{
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title: HreRem.i18n('title.tramitacion.titulo'),
							items :
								[
									{ 
							        	xtype: 'comboboxfieldbase',				        	
								 		fieldLabel: HreRem.i18n('fieldlabel.situacion.titulo'),
								 		readOnly: true,
							        	bind: {
						            		store: '{comboEstadoTitulo}',
						            		value: '{saneamiento.estadoTitulo}'

						            	},

						            	reference: 'estadoTitulo'
			                        },
							        {
										xtype:'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.fecha.entrega.titulo.gestoria'),
								 		bind: {
								 			value: '{saneamiento.fechaEntregaGestoria}',
								 			readOnly: '{saneamiento.unidadAlquilable}'
								 		}
			                       },
									{
										xtype:'datefieldbase',
								 		fieldLabel: HreRem.i18n('fieldlabel.fecha.presentacion.hacienda'),
								 		bind: {
								 			value: '{saneamiento.fechaPresHacienda}',
								 			readOnly: '{saneamiento.unidadAlquilable}'
								 		}

									},
									{
										xtype:'datefieldbase',
								 		fieldLabel: HreRem.i18n('fieldlabel.fecha.presentacion.registro'),
								 		bind: {
								 			value: '{saneamiento.fechaPres1Registro}',
								 			readOnly: '{saneamiento.unidadAlquilable}',
								 			hidden: true
								 		}
									},
									{
										xtype:'datefieldbase',
								 		fieldLabel: HreRem.i18n('fieldlabel.fecha.envio.auto.adicion'),
								 		bind: {
								 			value: '{saneamiento.fechaEnvioAuto}',
								 			readOnly: '{saneamiento.unidadAlquilable}',
								 			hidden: true
								 		}
									},
									{
										xtype:'datefieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.fecha.segunda.presentacion.registro'),
								 		bind: {
								 			value: '{saneamiento.fechaPres2Registro}',
								 			readOnly: '{saneamiento.unidadAlquilable}',
								 			hidden: true
								 		}
									},
									{
										xtype:'datefieldbase',
					                	fieldLabel: HreRem.i18n('fieldlabel.fecha.inscripcion.registro'),
					                	readOnly: true,
								 		bind: {
								 			value: '{saneamiento.fechaInscripcionReg}'
								 		},
								 		listeners: {
								 			change: function () {
									 			me = this;
									 			var combo = me.lookupController('activodetalle').lookupReference('comboCalificacionNegativaRef');
									 			
									 			if (combo != null && combo != '')
									 				combo.setValue('03');
									 			
									 		}
								 		}
								 		
									},
									{
										xtype:'datefieldbase',
					                	fieldLabel: HreRem.i18n('fieldlabel.fecha.retirada.definitiva.registro'),
								 		bind: {
								 			value: '{saneamiento.fechaRetiradaReg}',
								 			readOnly: '{saneamiento.unidadAlquilable}'
								 		}
									},
									{
										xtype:'datefieldbase',
					                	fieldLabel: HreRem.i18n('fieldlabel.fecha.nota.simple'),

								 		bind: {
								 			value: '{saneamiento.fechaNotaSimple}',
								 			readOnly: '{saneamiento.unidadAlquilable}'
								 		}
									},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										colspan: 3,
										reference:'historicotramitaciontitulo',
										hidden: false, 
										title: HreRem.i18n("title.historico.presentacion.registros"),
										items :
										[
											{
												xtype: "historicotramitaciontitulogrid", 
												reference: "historicotramitaciontituloref", 
												colspan: 3
											}
										]
					           		},
									{
										xtype:'fieldsettable',
										defaultType: 'textfieldbase',
										colspan: 3,
										reference:'calificacionNegativa',
										hidden: false, 
										title: HreRem.i18n("title.calificacion.negativa"),
										bind:{
											disabled:'{!saneamiento.noEstaInscrito}'
										},
										items :
										[
											{
												xtype: "calificacionnegativagrid", 
												reference: "calificacionnegativagrid", 
												colspan: 3,
												bind:{
													disabled:'{!datosRegistrales.puedeEditarCalificacionNegativa}'
												}
											}
										]
					           		}

								]
						}		
					]
                
            }, //Empieza bloque cargas
            {
				xtype:'fieldsettable',
				title:HreRem.i18n('title.cargas'),
//				bind: {hidden:'{!esOcupacionIlegal}'},
				defaultType: 'textfieldbase',
				layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 1,
			        tdAttrs: {width: '100%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				items : [
					{
			              xtype : 'fieldset',
			              collapsed : false,
			              layout : {
			                type : 'table',
			                // The total column count must be specified here
			                columns : 2,
			                trAttrs : {
			                  height : '30px',
			                  width : '100%'
			                },
			                tdAttrs : {
			                  width : '50%'
			                },
			                tableAttrs : {
			                  style : {
			                    width : '100%'
			                  }
			                }
			              },
			              items : [{
			                    xtype : 'comboboxfieldbase',
			                    fieldLabel : HreRem.i18n('fieldlabel.con.cargas'),
			                    name : 'estadoActivoCodigo',
			                    bind : {
			                      store : '{comboSiNoRem}',
			                      value : '{saneamiento.conCargas}',
			                      readOnly: true,
			                      editable: false
			                    },
			                    editable: false,
			                    readOnly : true
			                  },
			                  {
			                      xtype : 'textfieldbase',
			                      fieldLabel : HreRem.i18n('fieldlabel.cargas.estado.cargas'),
			                      name : 'estadoCargas',
			                      bind : { 
			                        value : '{saneamiento.estadoCargas}'
			                      },
			                      editable: false,
			                      readOnly : true
			                    },{
			                    xtype : 'datefieldbase',
			                    fieldLabel : HreRem.i18n('fieldlabel.fecha.revision.cargas'),
			                    editable: false,
			                    bind : {
			                    	value: '{saneamiento.fechaRevisionCarga}',
			                    	readOnly: '{saneamiento.unidadAlquilable}'
			                    }
			                  }

			              ]
			            },{
			                xtype : 'gridBase',
			                title : HreRem.i18n('title.listado.cargas'),
			                reference : 'listadoCargasActivo',
			                topBar : true,
			                cls : 'panel-base shadow-panel',
			                bind : {
			                  store : '{storeCargas}',
			                  topBar: '{!saneamiento.unidadAlquilable}'
			                },
			                selModel : {
			                  type : 'checkboxmodel'
			                },
			                columns : [{
			                      text : HreRem.i18n('header.origen.dato'),
			                      dataIndex : 'origenDatoDescripcion',
			                      flex : 1
			                    },{
			                      text : HreRem.i18n('header.tipo.carga'),
			                      dataIndex : 'tipoCargaDescripcion',
			                      flex : 1
			                    }, {
			                      text : HreRem.i18n('header.subtipo.carga'),
			                      flex : 1,
			                      dataIndex : 'subtipoCargaDescripcion'
			                    }, {
			                      text : HreRem.i18n('header.estado.carga'),
			                      flex : 1,
			                      dataIndex : 'estadoDescripcion'
			                    }, {
			                        text : HreRem.i18n('header.subestado.carga'),
			                        flex : 1,
			                        dataIndex : 'subestadoDescripcion'
			                    }, {
			                      text : 'Estado carga econ&oacute;mica',
			                      flex : 1,
			                      dataIndex : 'estadoEconomicaDescripcion',
			                      hidden:true,
			                      disabled:true
			                    }, {
			                      text : HreRem.i18n('header.titular'),
			                      flex : 1,
			                      dataIndex : 'titular'
			                    }, {
			                      text : 'Importe registral',
			                      dataIndex : 'importeRegistral',
			                      renderer : function(value) {
			                        return Ext.util.Format.currency(value);
			                      },
			                      flex : 1
			                    }, {
			                      text : 'Importe econ&oacute;mico',
			                      dataIndex : 'importeEconomico',
			                      renderer : function(value) {
			                        return Ext.util.Format.currency(value);
			                      },
			                      flex : 1
			                    }, {   
			                  	text : HreRem.i18n('fieldlabel.con.cargas.propias'),
			  		        	dataIndex: 'cargasPropias',
			  		        	renderer : function(value) {
			  		        		if(value == "1"){
			  		        			return "Si";
			  		        		}else if(value == "0"){
			  		        			return "No";
			  		        		}else {
			  		        			return "";
			  		        		}
			  	                },
			  		        	flex: 1
			  				  }

			                ],
			                dockedItems : [{
			                      xtype : 'pagingtoolbar',
			                      dock : 'bottom',
			                      displayInfo : true,
			                      bind : {
			                        store : '{storeCargas}'
			                      }
			                    }],
			                listeners : [{
			                      afterrender : 'onRenderCargasList'
			                    }, {
			                      rowdblclick : 'onCargasListDobleClick'
			                    }]
			              }
					]
            },
            //Proteccion oficial
            {
				xtype:'fieldsettable',
				title:HreRem.i18n('title.admision.protectoficial'),
//				bind: {hidden:'{!esOcupacionIlegal}'},
				defaultType: 'textfieldbase',
				layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 1,
			        tdAttrs: {width: '100%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				items : [
					{
						xtype:'container',
						layout: {
							type : 'hbox'
					},
					items :
					[				
						{
				        	xtype:'fieldset',
				        	height: 160,
				        	margin: '0 10 10 0',
				        	layout: {
						        type: 'table',
				        		columns: 3
				        	},
							defaultType: 'textfieldbase',
							title: HreRem.i18n("title.datos.proteccion"), // Datos de la proteccion
							items :
								[
									{ 
								 		xtype: 'comboboxfieldbase',
								 		fieldLabel: HreRem.i18n('fieldlabel.regimen.proteccion'),	//R�gimen protecci�n 							 		
								 		bind: {
			            						store: '{comboTipoVpo}',
			            						value: '{saneamiento.tipoVpoCodigo}'
			            					  }
									},
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.descalificada'),			// Descalificada
		                				bind: {
			            						store: '{comboSiNoRem}',
			            						value: '{saneamiento.descalificado}'
			            					  }
					                },
					                { 
					                	xtype: 'datefieldbase',
					                	fieldLabel: HreRem.i18n('fieldlabel.fecha.calificacion'), // Fecha de calificaci�n
					                	bind: '{saneamiento.fechaCalificacion}'
					                },
					                { 
					                	xtype: 'textfieldbase',
					                	maskRe: /[A-Za-z0-9]/,
								 		fieldLabel: HreRem.i18n('fieldlabel.expediente.calificacion'), // N� expediente calificaci�n
								 		bind: '{saneamiento.numExpediente}'
									},
					                { 
					                	xtype: 'datefieldbase',     
								 		fieldLabel: HreRem.i18n('fieldlabel.vigencia'), // Vigencia (NUEVO CAMPO)
								 		bind: '{saneamiento.vigencia}',
								 		maxValue : null
									}
		
								]
				        },
				        
				        {
				        	xtype:'fieldset',
				        	height: 160,
				        	margin: '0 10 10 0',

							defaultType: 'textfieldbase',
							title: HreRem.i18n("title.requisitos.fase.adquisicion"), // Requisitos fase de adquisicion
							items :
								[								
									 { 
							        	xtype: 'comboboxfieldbase',							        	
							        	fieldLabel:  HreRem.i18n('fieldlabel.precisa.comunicar.adquisicion'), // Precisa comunicar adquisici�n (NUEVO CAMPO)
							        	bind: {
			            						store: '{comboSiNoRem}',
			            						value: '{saneamiento.comunicarAdquisicion}'
			            					  }
							        },							        
							        { 
							        	xtype: 'comboboxfieldbase',							        	
							        	fieldLabel:  HreRem.i18n('fieldlabel.necesario.inscribir.registro.especial.vpo'),  // �Necesario inscribir en registro especial VPO? (NUEVO CAMPO)
							        	bind: {
			            						store: '{comboSiNoRem}',
			            						value: '{saneamiento.necesarioInscribirVpo}'
			            					  }
							        }		              
									
								]
				        }
				        
				     ]
					},
					{
			        	xtype:'fieldset',
			        	height: 160,
			        	margin: '0 10 10 0',

						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.requisitos.fase.adquisicion"), // Requisitos fase de adquisicion
						items :
							[								
								 { 
						        	xtype: 'comboboxfieldbase',							        	
						        	fieldLabel:  HreRem.i18n('fieldlabel.precisa.comunicar.adquisicion'), // Precisa comunicar adquisici�n (NUEVO CAMPO)
						        	bind: {
		            						store: '{comboSiNoRem}',
		            						value: '{saneamiento.comunicarAdquisicion}'
		            					  }
						        },							        
						        { 
						        	xtype: 'comboboxfieldbase',							        	
						        	fieldLabel:  HreRem.i18n('fieldlabel.necesario.inscribir.registro.especial.vpo'),  // �Necesario inscribir en registro especial VPO? (NUEVO CAMPO)
						        	bind: {
		            						store: '{comboSiNoRem}',
		            						value: '{saneamiento.necesarioInscribirVpo}'
		            					  }
						        }		              
								
							]
			        },
			        {
					xtype:'container',
					layout: {
			         			columns: 1
			        		},
					items : [
					
			        
			        {
			        	xtype:'fieldsettable',
			        	height: 300,
			        	margin: '0 10 10 0',
						layout: {
					 			type: 'table',
			         			columns: 3
			        			},
			        	
						defaultType: 'textfieldbase',
						title: HreRem.i18n("title.requisitos.fase.venta"), // Requisitos para la fase de venta
						items :
							[
								
								{
						        	xtype:'fieldset',
						        	height: 260,
						        	colspan: 1,
						        	margin: '0 0 10 0',
									layout: {
					 						type: 'table',
			         						columns: 3
			        						},
									defaultType: 'textfieldbase',
									title: HreRem.i18n("title.limitaciones.vendedor"), // Limitaciones del vendedor
									
									items :
										[
											{ 
										 		xtype: 'comboboxfieldbase',
										 		fieldLabel: HreRem.i18n('fieldlabel.necesaria.autorizacion.venta'),		// Necesitar�a autorizaci�n						 		
										 		bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.obligatorioAutAdmVenta}'
		            								  }
											},
											{ 
												xtype: 'currencyfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.precio.maximo.venta.vpo'), 			// Precio m�ximo de venta
				                				bind: '{saneamiento.maxPrecioVenta}'
							                },
							                { 
												xtype: 'comboboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.devolucion.ayudas'), 			// Devoluci�n de ayudas
				                				bind: {
														store: '{comboSiNoRem}',
														value: '{saneamiento.obligatorioSolDevAyuda}'
													  }
							                },
							                { 
							                	xtype: 'comboboxfieldbase',
							                	fieldLabel: HreRem.i18n('fieldlabel.libertad.cesion'), // Libertad de cesi�n (NUEVO CAMPO)
							                	bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.libertadCesion}'
		            								  }
							                },
							                { 
							                	xtype: 'comboboxfieldbase',
										 		fieldLabel: HreRem.i18n('fieldlabel.renuncia.tanteo.retracto'), // Renuncia a tanteo y retracto (NUEVO CAMPO)
										 		bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.renunciaTanteoRetrac}'
		            								  }
											},
							                { 
							                	xtype: 'comboboxfieldbase',
							                	fieldLabel: HreRem.i18n('fieldlabel.visado.contrato.privado'), // Visado del contrato privado (NUEVO CAMPO)
							                	bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.visaContratoPriv}'
		            								  }
							                },
							                { 
							                	xtype: 'comboboxfieldbase',
										 		fieldLabel: HreRem.i18n('fieldlabel.vender.persona.juridica'), // Permite vender a persona jur�dica (NUEVO CAMPO)
										 		bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.venderPersonaJuridica}'
		            								  }
											}
				
										]
						        },
						        
						        {
						        	xtype:'fieldset',
						        	height: 260,
						        	margin: '0 10 10 10',

									defaultType: 'textfieldbase',
									title: HreRem.i18n("title.limitaciones.comprador"), // Limitaciones del comprador
									items :
										[								
											 { 
									        	xtype: 'comboboxfieldbase',							        	
									        	fieldLabel:  HreRem.i18n('fieldlabel.minusvalia'),	// Minusval�a (NUEVO CAMPO)
									        	bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.minusvalia}'
		            								  }
									        },							        
									        { 
									        	xtype: 'comboboxfieldbase',							        	
									        	fieldLabel:  HreRem.i18n('fieldlabel.inscripcion.registro.demandante.vpo'),				// Inscripci�n en registro demandante VPO (NUEVO CAMPO)
									        	bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.inscripcionRegistroDemVpo}'
		            								  }
									        },
									        {
												xtype: 'comboboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.ingresos.inferiores.nivel'), // Ingresos inferiores a un nivel (NUEVO CAMPO)
								            	bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.ingresosInfNivel}'
		            								  }
											},							        
									        { 
									        	xtype: 'comboboxfieldbase',							        	
									        	fieldLabel:  HreRem.i18n('fieldlabel.residencia.comunidad.autonoma'),				// Residencia en comunidad aut�noma (NUEVO CAMPO)
									        	bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.residenciaComAutonoma}'
		            								  }
									        },
									        {
												xtype: 'comboboxfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.no.titular.otra.vivienda'), // No ser titular de otra vivienda (NUEVO CAMPO)
												bind: {
		            									store: '{comboSiNoRem}',
		            									value: '{saneamiento.noTitularOtraVivienda}'
		            								  }
											}				              
											
										]
						        	}

						        ]

			        		}
			        	]
			        }
				]
            },
            {       	  
				xtype:'fieldsettable',
				title:HreRem.i18n('title.admision.agenda'),
				defaultType: 'textfieldbase',
				border: false,
				items :[
					{
						xtype: "saneamientoagendagrid", 
						reference: "saneamientoagendagridref"
					}
				]
            },
    		{
				xtype: 'fieldsettable',
				items : [{
					xtype: 'observacionesactivo',
					launch: CONST.OBSERVACIONES_TAB_LAUNCH['SANEAMIENTO']
				}]
			}
     ];
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    getErrorsExtendedFormBase: function() {
   		var me = this,
   		errores = [],
   		error,
   		fechaTomaPosesion = me.down('[reference=fechaTomaPosesion]'),
   		fechaRevisionEstadoPosesorio = me.down('[reference=fechaRevisionEstadoPosesorio]'),
   		fechaSolDesahucio = me.down('[reference=fechaSolDesahucio]'),
   		fechaLanzamiento = me.down('[reference=fechaLanzamiento]'),
   		fechaLanzamientoEfectivo = me.down('[reference=fechaLanzamientoEfectivo]');

   		if(!Ext.isEmpty(fechaTomaPosesion.getValue()) && fechaTomaPosesion.getValue() > fechaRevisionEstadoPosesorio.getValue()) {
		    error = HreRem.i18n("txt.validacion.fechaTomaPosesion.mayor.fechaRevisionEstadoPosesorio");
   			errores.push(error);
   			fechaTomaPosesion.markInvalid(error);   			
   		}  		

   		if(!Ext.isEmpty(fechaLanzamiento.getValue()) && fechaLanzamiento.getValue() < fechaSolDesahucio.getValue()) {
		    error = HreRem.i18n("txt.validacion.fechaLanzamiento.menor.fechaSolDesahucio");
   			errores.push(error);
   			fechaLanzamiento.markInvalid(error);   			
   		}

   		if(!Ext.isEmpty(fechaLanzamientoEfectivo.getValue()) && fechaLanzamientoEfectivo.getValue() < fechaLanzamiento.getValue()) {
		    error = HreRem.i18n("txt.validacion.fechaLanzamientoEfectivo.menor.fechaLanzamiento");
   			errores.push(error);
   			fechaLanzamientoEfectivo.markInvalid(error);   			
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
   }


});