Ext.define('HreRem.view.activos.detalle.InformacionAdministrativaActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'informacionadministrativaactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'informacionadministrativaactivo',
    scrollable	: 'y',
    listeners: {
    	boxready: function() {
    		var me = this;
    		me.lookupController().cargarTabData(me);
    		me.evaluarEdicion();
    	}
    },

	recordName: "infoAdministrativa",
	
	recordClass: "HreRem.model.ActivoInformacionAdministrativa",
	
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.Catastro', 'HreRem.model.DocumentacionAdministrativa'],

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.informacion.administrativa'));
        var items= [
        
         {
         		xtype:'fieldsettable',
         		
         		width:'100%',
				title: HreRem.i18n('title.informacion.relacionada.vpo'),		//VPO
				layout: {
						 
						 type: 'table',
				         columns: 1
				        },
				        hidden: true,
				bind: 
					{
			        	hidden: '{!infoAdministrativa.vpo}',
			        	disabled: '{!infoAdministrativa.vpo}'
			        },
				defaultType: 'textfieldbase',

				items :
					[
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
			            						value: '{infoAdministrativa.tipoVpoCodigo}'
			            					  }
									},
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.descalificada'),			// Descalificada
		                				bind: {
			            						store: '{comboSiNoRem}',
			            						value: '{infoAdministrativa.descalificado}'
			            					  }
					                },
					                { 
					                	xtype: 'datefieldbase',
					                	fieldLabel: HreRem.i18n('fieldlabel.fecha.calificacion'), // Fecha de calificaci�n
					                	bind: '{infoAdministrativa.fechaCalificacion}'
					                },
					                { 
					                	xtype: 'textfieldbase',
					                	maskRe: /[A-Za-z0-9]/,
								 		fieldLabel: HreRem.i18n('fieldlabel.expediente.calificacion'), // N� expediente calificaci�n
								 		bind: '{infoAdministrativa.numExpediente}'
									},
					                { 
					                	xtype: 'datefieldbase',     
								 		fieldLabel: HreRem.i18n('fieldlabel.vigencia'), // Vigencia
								 		bind: '{infoAdministrativa.vigencia}',
								 		maxValue : null
									},//
									
					                { 
					                	xtype: 'datefieldbase',     
								 		fieldLabel: HreRem.i18n('fieldlabel.fechaSoliCertificado'), // fechaSoliCertificado (NUEVO CAMPO)
								 		bind: {
								 				readOnly : '{!esSupervisionGestorias}',
								 				value: '{infoAdministrativa.fechaSoliCertificado}'
								 			},
								 		maxValue : null
									},
					                { 
					                	xtype: 'datefieldbase',     
								 		fieldLabel: HreRem.i18n('fieldlabel.fechaComAdquisicion'), // fechaComAdquisicion (NUEVO CAMPO)
								 		bind: {
								 				readOnly : '{!esSupervisionGestorias}',
								 				value:'{infoAdministrativa.fechaComAdquisicion}'
								 			},								 		
								 		maxValue : null
									},
					                { 
					                	xtype: 'datefieldbase',     
								 		fieldLabel: HreRem.i18n('fieldlabel.fechaComRegDemandantes'), // fechaComRegDemandantes (NUEVO CAMPO)
								 		bind: { 
								 				readOnly : '{!esSupervisionGestorias}',
							 					value:'{infoAdministrativa.fechaComRegDemandantes}'
								 			},
								 		maxValue : null
									}//
		
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
			            						value: '{infoAdministrativa.comunicarAdquisicion}'
			            					  }
							        },							        
							        { 
							        	xtype: 'comboboxfieldbase',							        	
							        	fieldLabel:  HreRem.i18n('fieldlabel.necesario.inscribir.registro.especial.vpo'),  // �Necesario inscribir en registro especial VPO? (NUEVO CAMPO)
							        	bind: {
			            						store: '{comboSiNoRem}',
			            						value: '{infoAdministrativa.necesarioInscribirVpo}'
			            					  }
							        }		              
									
								]
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
			            									value: '{infoAdministrativa.obligatorioAutAdmVenta}'
			            								  }
												},
												{ 
													xtype: 'currencyfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.precio.maximo.venta.vpo'), 			// Precio m�ximo de venta
					                				bind: '{infoAdministrativa.maxPrecioVenta}'
								                },
								                
								                //
								                { 
								                	xtype: 'comboboxfieldbase',
								                	fieldLabel: HreRem.i18n('fieldlabel.actualizaPrecioMax'), // Actualizacion precio maximo (NUEVO CAMPO)
								                	bind: {
								                			readOnly : '{!esSupervisionGestorias}',
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.actualizaPrecioMaxId}'
			            								  }
								                },
								                { 
								                	xtype: 'datefieldbase',     
											 		fieldLabel: HreRem.i18n('fieldlabel.fechaVencimiento'), // fechaVencimiento (NUEVO CAMPO)
											 		bind: {
											 				readOnly : '{!esSupervisionGestorias}',
											 				value:'{infoAdministrativa.fechaVencimiento}'
											 			},
											 		maxValue : null
												},
												
								                //
								                { 
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.devolucion.ayudas'), 			// Devoluci�n de ayudas
					                				bind: {
															store: '{comboSiNoRem}',
															value: '{infoAdministrativa.obligatorioSolDevAyuda}'
														  }
								                },
								                { 
								                	xtype: 'comboboxfieldbase',
								                	fieldLabel: HreRem.i18n('fieldlabel.libertad.cesion'), // Libertad de cesi�n (NUEVO CAMPO)
								                	bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.libertadCesion}'
			            								  }
								                },
								                { 
								                	xtype: 'comboboxfieldbase',
											 		fieldLabel: HreRem.i18n('fieldlabel.renuncia.tanteo.retracto'), // Renuncia a tanteo y retracto (NUEVO CAMPO)
											 		bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.renunciaTanteoRetrac}'
			            								  }
												},
								                { 
								                	xtype: 'comboboxfieldbase',
								                	fieldLabel: HreRem.i18n('fieldlabel.visado.contrato.privado'), // Visado del contrato privado (NUEVO CAMPO)
								                	bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.visaContratoPriv}'
			            								  }
								                },
								                { 
								                	xtype: 'comboboxfieldbase',
											 		fieldLabel: HreRem.i18n('fieldlabel.vender.persona.juridica'), // Permite vender a persona jur�dica (NUEVO CAMPO)
											 		bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.venderPersonaJuridica}'
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
			            									value: '{infoAdministrativa.minusvalia}'
			            								  }
										        },							        
										        { 
										        	xtype: 'comboboxfieldbase',							        	
										        	fieldLabel:  HreRem.i18n('fieldlabel.inscripcion.registro.demandante.vpo'),				// Inscripci�n en registro demandante VPO (NUEVO CAMPO)
										        	bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.inscripcionRegistroDemVpo}'
			            								  }
										        },
										        {
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.ingresos.inferiores.nivel'), // Ingresos inferiores a un nivel (NUEVO CAMPO)
									            	bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.ingresosInfNivel}'
			            								  }
												},							        
										        { 
										        	xtype: 'comboboxfieldbase',							        	
										        	fieldLabel:  HreRem.i18n('fieldlabel.residencia.comunidad.autonoma'),				// Residencia en comunidad aut�noma (NUEVO CAMPO)
										        	bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.residenciaComAutonoma}'
			            								  }
										        },
										        {
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.no.titular.otra.vivienda'), // No ser titular de otra vivienda (NUEVO CAMPO)
													bind: {
			            									store: '{comboSiNoRem}',
			            									value: '{infoAdministrativa.noTitularOtraVivienda}'
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
				title:HreRem.i18n('title.catastro'),
			    xtype: 'gridBaseEditableRow',
			    idPrincipal: 'activo.id',
			    topBar: true,
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeCatastro}'
				},
				features: [{
		            id: 'summary',
		            ftype: 'summary',
		            hideGroupedHeader: true,
		            enableGroupingMenu: false,
		            dock: 'bottom'
				}],

				secFunToEdit: 'EDITAR_INFO_ADMINISTRATIVA_ACTIVO',
				
				secButtons: {
					secFunPermToEnable : 'EDITAR_INFO_ADMINISTRATIVA_ACTIVO'
				},

				columns: [
				    {   
						text: HreRem.i18n('fieldlabel.referencia.catastral'),
			        	dataIndex: 'refCatastral',
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
	                    				refCatastralRef.validateValue(refCatastralRef.getValue());
	                    				//VALIDATE en vez de clearInvalid para pasar el allowBlank a efectivo sin que se deje de tener en cuenta el enforceMaxLength
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
			                    			field.clearInvalid();
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
		                    				refCatastralRef.validateValue(refCatastralRef.getValue());
		                    				//VALIDATE en vez de clearInvalid para pasar el allowBlank a efectivo sin que se deje de tener en cuenta el enforceMaxLength
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
			        },
			        {   text: HreRem.i18n('fieldlabel.fecha.alta.catastro'),
			        	dataIndex: 'fechaAltaCatastro',
			        	formatter: 'date("d/m/Y")',
			        	/*format: 'M d, Y',
			        	format: 'Y',*/
			        	editor: {
		                    xtype: 'datefield'
		                },
		                flex: 1 
			        },
			        {   text: HreRem.i18n('fieldlabel.fecha.baja.catastro'),
			        	dataIndex: 'fechaBajaCatastro',
			        	formatter: 'date("d/m/Y")',
			        	/*format: 'M d, Y',
			        	format: 'Y',*/
			        	editor: {
		                    xtype: 'datefield'
		                },
		                flex: 1 
			        },
			        {   
			        	text: HreRem.i18n('fieldlabel.observaciones'),
			        	dataIndex: 'observaciones',
			        	editor: {
			        		xtype:'textarea',
			        		maxLength : 400
			        	},
			        	flex: 1
			        },
			        {
			        	text: HreRem.i18n('fieldlabel.resultadoSiNO'),
			        	dataIndex: 'resultadoSiNO', 
			        	renderer: function(value, metaData, record, rowIndex, colIndex, gridStore, view) {
				            var foundedRecord = this.up('activosdetallemain').getViewModel().getStore('comboSiNoRem').findRecord('codigo', value);
				            var descripcion;
				        	if(!Ext.isEmpty(foundedRecord)) {
				        		descripcion = foundedRecord.getData().descripcion;
				        	}
				            return descripcion;
				        },
			        	editor: {
			        		xtype:'combobox',
			        		   labelWidth: '25%',
					            width: '15%',
				        	
			        		bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{infoAdministrativa.resultadoSiNO}'
			            	},
			            	displayField: 'descripcion',
							valueField: 'codigo',
			            	allowBlank: false
			        	},
			        	
			        	
			        	flex: 1
			        
			        	       
			        },
			        {   
			        	text: HreRem.i18n('fieldlabel.fechaSoliciud901'),
			        	dataIndex: 'fechaSolicitud901',
			        	formatter: 'date("d/m/Y")',
			        	
			        	editor: {
			        		xtype:'datefield'
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
			},
			
           {
        	   xtype:'fieldset',
			   title: HreRem.i18n('title.expropiacion.forzosa'),
        	   layout: {
	                type: 'vbox'
	            },
	            items: [
				        { 
						    xtype: 'comboboxfieldbase',
				            fieldLabel: HreRem.i18n('fieldlabel.sujeto.a.expediente'),
				            labelWidth: '25%',
				            width: '15%',
				        	bind: {
				        		readOnly : '{esUA}',
				        		store: '{comboSiNoRem}',
				        		value: '{infoAdministrativa.sujetoAExpediente}'
				        	},
				        	listeners: {
								change: 'onChangeSujetoAExpediente'
				        	},
				        	allowBlank: false
					    },
						{
						    xtype:'fieldsettable',
							reference: 'expropiacionForzosa',
							title: 'Datos del expediente de expropiaci&oacute;n forzosa',
							defaultType: 'textfieldbase',
							width: '100%',
							items :
								[
								    {
								    	xtype: 'textfieldbase',
								    	fieldLabel: 'Organismo expropiante',
							        	bind: {
							        		readOnly : '{esUA}',
							        		value: '{infoAdministrativa.organismoExpropiante}'
							        	}		
								    	
								    },
								    {
								    	xtype: 'textfieldbase',
								    	fieldLabel: 'Ref. expdte. admvo.',
							        	bind: {
							        		readOnly : '{esUA}',
							        		value: '{infoAdministrativa.refExpedienteAdmin}'
							        	}		
								    },
								    {
								    	xtype: 'textareafieldbase',
								    	fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
							        	bind: {
							        		readOnly : '{esUA}',
							        		value: '{infoAdministrativa.observacionesExpropiacion}'
							        	},		
								    	rowspan: 2
								    },
								    {
								    	xtype: 'datefieldbase',
								    	fieldLabel: 'Fecha inicio expdte.',
								    	formatter: 'date("d/m/Y")',
							        	bind: {
							        		readOnly : '{esUA}',
							        		value: '{infoAdministrativa.fechaInicioExpediente}'
							        	}			
								    },
								    {
								    	xtype: 'textfieldbase',
								    	fieldLabel: 'Ref. expdte. interno',
							        	bind: {
							        		readOnly : '{esUA}',
							        		value: '{infoAdministrativa.refExpedienteInterno}'
							        	}	
								    		
								    }
							    ]
						 }
	            ]
           },
           {
           	
				title: HreRem.i18n('title.documentacion.administrativa'),
				xtype: 'gridBase',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeDocumentacionAdministrativa}'
				},
				
				columns: [
				
				    {   text: 'Documento', 
			        	dataIndex: 'descripcionTipoDocumentoActivo',
			        	width: '25%'
			        },
			        {   text: 'Nº Documento', 
			        	dataIndex: 'numDocumento',
			        	width: '15%' 
			        },	
					{
			            text: 'Fecha solicitud',
			            formatter: 'date("d/m/Y")',
			            dataIndex: 'fechaSolicitud',
			            width: '10%' 
			        },
			        {   text: 'Fecha emisión',
			        	formatter: 'date("d/m/Y")',
			        	dataIndex: 'fechaEmision',
			        	width: '10%'  
			        },
			        {   text: 'Fecha caducidad', 
			        	formatter: 'date("d/m/Y")',
			        	dataIndex: 'fechaCaducidad',
			        	width: '10%' 
			        },
			        {   text: 'Fecha etiqueta',
			        	formatter: 'date("d/m/Y")',
			        	dataIndex: 'fechaEtiqueta',
			        	width: '10%' 
			        },
			        {   text: 'Calificación', 
			        	dataIndex: 'tipoCalificacionDescripcion',
			        	width: '19%'
			        },
			        {   text: 'Dataid_Documento', 
			        	dataIndex: 'dataIdDocumento',
			        	width: '19%'
			        	
			        },
			        {   text: 'Letra consumo', 
			        	dataIndex: 'tipoLetraConsumoDescripcion',
			        	width: '10%'
			        },
			        {   text: 'Consumo', 
			        	dataIndex: 'consumo',
			        	width: '19%'
			        },
			        {   text: 'Emisión', 
			        	dataIndex: 'emision',
			        	width: '19%'
			        },
			        {   text: 'Registro', 
			        	dataIndex: 'registro',
			        	width: '19%'
			        }
			        
			       	        
			    ],
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeDocumentacionAdministrativa}'
			            }
			        }
			    ]
			    
			}

     ];
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    onAddClick: function(){
    	
    	// Create a model instance
        var rec = new HreRem.model.Catastro({
            /*common: '',
            light: 'Mostly Shady',
            price: 0,
            availDate: Ext.Date.clearTime(new Date()),
            indoor: false*/
        });

        this.down('gridBase').getStore().insert(0, rec);
        /*this.cellEditing.startEditByPosition({
            row: 0,
            column: 0
        });*/
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
   },
   
 //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar y las acciones editables por fila
   evaluarEdicion: function() {    	
		var me = this;
		
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false" || me.lookupController().getViewModel().get('activo').get('unidadAlquilable')
				|| me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			me.down('[xtype=gridBaseEditableRow]').setTopBar(false);
			me.down('[xtype=gridBaseEditableRow]').rowEditing.clearListeners();
		}
   }

});
