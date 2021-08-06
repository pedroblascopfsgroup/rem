Ext.define('HreRem.view.activos.detalle.SituacionPosesoriaActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'situacionposesoriaactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    refreshAfterSave: true,
    disableValidation: false,
    reference: 'situacionposesoriaactivoref',
    scrollable	: 'y',
    listeners: {
			boxready:'cargarTabData'
	},

	recordName: "situacionPosesoria",
	
	recordClass: "HreRem.model.ActivoSituacionPosesoria",
	
    requires: ['HreRem.model.ActivoSituacionPosesoria', 'HreRem.model.OcupantesLegales', 'HreRem.view.activos.detalle.LlavesList', 'HreRem.view.activos.detalle.MovimientosLlaveList', 
    	'HreRem.model.SituacionOcupacionalGridModel'],
	
    initComponent: function () {
        var me = this;
        
        me.setTitle(HreRem.i18n('title.situacion.posesoria.llaves'));

        var items= [
        	{
        		xtype: 'displayfieldbase',
            	fieldStyle: 'color:#ff0000; padding-top: 2px; text-align:right; padding-right: 50px',
            	width: '100%',
            	reference:'literalOcupacional',
            	value: HreRem.i18n('header.literal.situacion.ocupacional'),
            	style: 'text-align:center',
            	bind: {
	        		hidden: '{!situacionPosesoria.perteneceActivoREAM}'
	        	}
        	},
			{    
                
				xtype:'fieldsettable',
				title:HreRem.i18n('title.situacion.posesoria'),
				defaultType: 'textfieldbase',
				border: false,
				items :
					[
						
						{
				        	xtype:'fieldset',
				        	height: '80%',
				        	border: false,
							layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 2,
							        trAttrs: {height: '30px', width: '100%'},
							        tdAttrs: {width: '50%'},
							        tableAttrs: {
							            style: {
							                width: '100%'
											}
							        }
							},
				        	defaultType: 'textfieldbase',
							rowspan: 1,
							items: [								
						        {
									xtype: 'comboboxfieldbase',
									reference: 'conPosesion',
									fieldLabel: HreRem.i18n('fieldlabel.con.posesion'),
									readOnly: true,
						        	bind: {				        		
						        		store: '{comboSiNoRem}',
					            		value: '{situacionPosesoria.indicaPosesion}'
					            	}
						        },{
						        	xtype:'textfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.ultima.modificacion'),
						        	readOnly: true,
						        	bind: {
						        		value: '{situacionPosesoria.diasCambioPosesion}',
						        		hidden: '{!activo.isCarteraBankia}'
						        	}
						        }


							]
						},
				
						{ 
							xtype:'datefieldbase',
							reference: 'fechaRevisionEstadoPosesorio',
					 		fieldLabel: HreRem.i18n('fieldlabel.fecha.revision.estado.posesorio'),
			            	bind:		'{situacionPosesoria.fechaRevisionEstado}',
                            readOnly: true
						},
		        
						{
				        	xtype:'fieldset',
				        	height: '100%',
				        	//width: '90%',
							layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 2,
							        trAttrs: {height: '30px', width: '100%'},
							        tdAttrs: {width: '50%'},
							        tableAttrs: {
							            style: {
							                width: '80%'
											}
							        }
							},
				        	defaultType: 'textfieldbase',
							rowspan: 3,						
							title: 'Accesibilidad',
							items: [
						        {
						        	xtype: 'comboboxfieldbase',						        	
						        	fieldLabel: 'Tapiado',
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{situacionPosesoria.accesoTapiado}'
					            	},
					            	labelWidth: 80,
					            	width: 200,
					            	listeners: {
					            		change: function(combo, value) {
					            			var me = this;
					            			if(value=='1') {
					            				me.up('formBase').down('[reference=datefieldTapiado]').allowBlank = false;
					            				me.up('formBase').down('[reference=datefieldTapiado]').setDisabled(false);
					            				me.up('formBase').down('[reference=datefieldTapiado]').validate();
					            			} else {
					            				me.up('formBase').down('[reference=datefieldTapiado]').allowBlank = true;
					            				me.up('formBase').down('[reference=datefieldTapiado]').setValue("");
					            				me.up('formBase').down('[reference=datefieldTapiado]').setDisabled(true);
					            				me.up('formBase').down('[reference=datefieldTapiado]').validate();
					            			}
					            		}
					            	}
						        },
						        {
						        	xtype:'textfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.ultima.modificacion'),
						        	readOnly: true,
						        	bind: {
						        		value: '{situacionPosesoria.diasTapiado}',
						        		hidden: '{!activo.isCarteraBankia}'
						        	},
					            	labelWidth: 120,
					            	width: 60
						        },
						        {
						        	xtype:'datefieldbase',
						        	reference: 'datefieldTapiado',
						        	fieldLabel: 'Fecha tapiado',
						        	bind: {
						        		value: '{situacionPosesoria.fechaAccesoTapiado}'
						        	},
					            	labelWidth: 100,
					            	width: 200
						        },
						        {
						        	xtype: 'comboboxfieldbase',						        	
						        	fieldLabel: 'Puerta antiocupa',
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{situacionPosesoria.accesoAntiocupa}'
					            	},
					            	labelWidth: 80,
					            	width: 180,
					            	listeners: {
					            		change: function(combo, value) {
					            			var me = this;
					            			if(value=='1') {
					            				me.up('formBase').down('[reference=datefieldPuertaAntiocupa]').allowBlank = false;
					            				me.up('formBase').down('[reference=datefieldPuertaAntiocupa]').setDisabled(false);
					            				me.up('formBase').down('[reference=datefieldPuertaAntiocupa]').validate();
					            			} else {
					            				me.up('formBase').down('[reference=datefieldPuertaAntiocupa]').allowBlank = true;
					            				me.up('formBase').down('[reference=datefieldPuertaAntiocupa]').setValue("");
					            				me.up('formBase').down('[reference=datefieldPuertaAntiocupa]').setDisabled(true);
					            				me.up('formBase').down('[reference=datefieldPuertaAntiocupa]').validate();
					            			}
					            		}
					            	}
						        },
						        {
						        	xtype:'datefieldbase',
						        	reference: 'datefieldPuertaAntiocupa',
						        	fieldLabel: 'Fecha colocaci&oacute;n puerta antiocupa',
						        	bind: '{situacionPosesoria.fechaAccesoAntiocupa}',
					            	labelWidth: 80,
					            	width: 200
						        },
						        {
						        	xtype: 'comboboxfieldbase',						        	
						        	fieldLabel:  HreRem.i18n('fieldlabel.situacion.posesoria.accesibilidad.alarma'),
						        	bind: {
						        		readOnly: '{!isGestorSeguridad}',
					            		store: '{comboSiNoRem}',
					            		value: '{situacionPosesoria.tieneAlarma}'
					            	},
					            	labelWidth: 80,
					            	width: 180,
					            	listeners: {
					            		change: function(combo, value) {
					            			var me = this;
					            			var fechaInstalacion = me.up('formBase').down('[reference=datefielInstalaciondAlarma]').value;
					            			
					            			if(value=='1') {
					            				me.up('formBase').down('[reference=datefielInstalaciondAlarma]').allowBlank = false;
					            				me.up('formBase').down('[reference=datefielInstalaciondAlarma]').setDisabled(false);
					            				me.up('formBase').down('[reference=datefielInstalaciondAlarma]').validate();
					            								      				
					            				me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').allowBlank = true;
					            				me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').setValue("");
					            				me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').setDisabled(true);
					            				me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').validate();
					            				
					            			} else {
					            				if(fechaInstalacion != null || fechaInstalacion != undefined) {
					            					me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').allowBlank = false;
						            				me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').setDisabled(false);
						            				me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').validate();
						            				me.up('formBase').down('[reference=datefielDesinstalaciondAlarma]').setMinValue(me.up('formBase').down('[reference=datefielInstalaciondAlarma]').value);	
					            				}
					            				
					            				me.up('formBase').down('[reference=datefielInstalaciondAlarma]').allowBlank = true;
					            				me.up('formBase').down('[reference=datefielInstalaciondAlarma]').setDisabled(true);
					            				me.up('formBase').down('[reference=datefielInstalaciondAlarma]').validate();
					            			}
					            		}
					            	}
						        	},{
						        		xtype:'datefieldbase',
							        	reference: 'datefielInstalaciondAlarma',
							        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria.accesibilidad.fecha.instalacion.alarma'),
							        	disabled:true,
							        	bind: {
								        	value:'{situacionPosesoria.fechaInstalacionAlarma}',
								        	readOnly: '{!isGestorSeguridad}'
							        	},
						            	labelWidth: 80,
						            	width: 200
						        	},{
						        		colspan:2,
						        		xtype:'datefieldbase',
							        	reference: 'datefielDesinstalaciondAlarma',
							        	disabled:true,
							        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria.accesibilidad.fecha.desinstalacion.alarma'),							        
							        	bind:{
							        		value: '{situacionPosesoria.fechaDesinstalacionAlarma}',
							        		readOnly: '{!isGestorSeguridad}'
							        	},
						            	labelWidth: 80,
						            	width: 200
						        	},{
						        	
						        		xtype: 'comboboxfieldbase',						        	
						        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria.accesibilidad.vigilancia'),
					            	labelWidth: 80,
					            	width: 180,
						        	bind: {
						        		readOnly: '{!isGestorSeguridad}',
					            		store: '{comboSiNoRem}',
					            		value: '{situacionPosesoria.tieneVigilancia}'
					            		,listeners: {
					            		change: function(combo, value) {
					            			var me = this;
					            			var fechaInstalacion = me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').value;

					            			if(value=='1') {
					            				me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').allowBlank = false;
					            				me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').setDisabled(false);
					            				me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').validate();
					            				
					            				me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').allowBlank = true;
					            				me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').setValue("");
					            				me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').setDisabled(true);
					            				me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').validate();
					            				
					            			} else {
					            				if(fechaInstalacion != null || fechaInstalacion != undefined) {
					            					me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').allowBlank = false;
						            				me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').setDisabled(false);
						            				me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').validate();
						            				me.up('formBase').down('[reference=datefielDesinstalaciondVigilancia]').setMinValue(me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').value);						
					            				}
					            				
					            				me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').allowBlank = true;
					            				me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').setDisabled(true);
					            				me.up('formBase').down('[reference=datefielInstalaciondVigilancia]').validate();
					            			}
					            		}
					            	}
					            	}
						       		},{
						       			xtype:'datefieldbase',
							        	reference: 'datefielInstalaciondVigilancia',
							        	disabled:true,
							        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria.accesibilidad.fecha.instalacion.vigilancia'),						        	
							        	bind:{
							        		value:'{situacionPosesoria.fechaInstalacionVigilancia}',
							        		readOnly: '{!isGestorSeguridad}'
							        	},							  
						            	labelWidth: 80,
						            	width: 200
						        },{
						        	colspan:2,
						        	xtype:'datefieldbase',
							        	reference: 'datefielDesinstalaciondVigilancia',
							        	disabled:true,
							        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria.accesibilidad.fecha.desinstalacion.vigilancia'),
							        	bind: {
							        		value:'{situacionPosesoria.fechaDesinstalacionVigilancia}',
							        		readOnly: '{!isGestorSeguridad}'
							        	},							      
						            	labelWidth: 80,
						            	width: 200
						        }
							]
						},
						{
						        	xtype: 'comboboxfieldbase',
									reference: 'posesionNegociada',
									fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria.llaves.negociacion'),
						        	bind: {				        		
						        		store: '{comboSiNoPosesionNegociada}',
					            		value: '{situacionPosesoria.posesionNegociada}',
					            		readOnly: '{!tienePosesion}'
					            	},
					            	displayField: 'descripcion',
					            	valueField: 'codigo'
					            	
					            	
						},{ 
							xtype:'datefieldbase',
							reference: 'fechaTomaPosesion',
							allowBlank: true,
							fieldLabel: HreRem.i18n('fieldlabel.fecha.obtencion.posesion'),
		                	bind:	{
		                		value: '{situacionPosesoria.fechaTomaPosesion}',
		                		readOnly: '{esSituacionJudicial}'
		                	},
		                	style:'margin-left:10px'
		                },
		                {
				        	xtype: 'comboboxfieldbase',
				        	allowBlank: true,
				        	reference: 'comboOcupadoRef',
							fieldLabel: HreRem.i18n('fieldlabel.ocupado'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value : '{situacionPosesoria.ocupado}',
			            		readOnly: '{esTipoEstadoAlquilerAlquilado}'
			            	},
			            	listeners: {
			            		change: 'onChangeComboOcupado'
			            	},
			            	style:'margin-left:10px'
				        },				      
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.riesgo.ocupacion'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{situacionPosesoria.riesgoOcupacion}'
			            	},
			            	listeners: {
			            		afterbind: function(combo){
			            			var me=this;
			            			if(!me.up('activosdetallemain').getViewModel().get('activo.isCarteraBankia')){
			            				me.rowspan = 2;
			            			}
			            		}
			            	},
                            readOnly: true
				        },				        				        
						{
				        	xtype:'fieldset',
				        	height: '80%',
				        	border: false,
							layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 2,
							        trAttrs: {height: '30px', width: '100%'},
							        tdAttrs: {width: '50%'},
							        tableAttrs: {
							            style: {
							                width: '100%'
											}
							        }
							},
				        	defaultType: 'textfieldbase',
							rowspan: 1,
							items: [
						        {
							        xtype: 'comboboxfieldbasedd',
							        reference: 'comboSituacionPosesoriaConTitulo',
									fieldLabel: HreRem.i18n('fieldlabel.con.titulo'),
									
							        bind: {        
							        	store : '{comboDDTipoTituloActivoTPA}',
						            	value: '{situacionPosesoria.conTituloCodigo}',	
						            	readOnly: '{esTipoEstadoAlquilerAlquilado}',
										rawValue: '{situacionPosesoria.conTituloDescripcion}'
						            }
						        },
						        {
						        	xtype:'textfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.ultima.modificacion'),
						        	readOnly: true,
						        	bind: {
						        		value: '{situacionPosesoria.diasCambioTitulo}',
						        		hidden: '{!activo.isCarteraBankia}'
						        	}
						        }


							]
						},
				        {
							xtype: 'textfieldbase',
							reference: 'disponibilidadJuridicaRef',
							fieldLabel: HreRem.i18n('fieldlabel.disponibilidad.juridica.bankia'),
							readOnly: true,
				        	bind: {
				        		hidden: '{!activo.isCarteraBankia}',				   
			            		value: '{situacionPosesoria.situacionJuridica}'
			            	}
				        },
						{
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.necesidad.fuerza.publica'),
				        	colspan:4,
				        	readOnly: true,
				        	bind: {
			            		store: '{comboSiNoFuerzaPublica}', 
			            		value: '{situacionPosesoria.necesariaFuerzaPublica}',
			            		hidden: '{!activo.isCarteraBankia}'
				        	}
						},
						{
							xtype: 'checkboxfieldbase',
							reference: 'okTecnicoRef',
							fieldLabel: HreRem.i18n('filedlabel.tiene.ok.tecnico'),
							bind: {
								value: '{situacionPosesoria.tieneOkTecnico}',
								readOnly: '{!activo.aplicaGestion}'
							},
    						listeners: {
			                	change: 'editarComboEstadoTecnico'
			            	}
						},
						{
					        xtype: 'comboboxfieldbasedd',
					        reference: 'comboEstadoTecnicoRef',
							fieldLabel: HreRem.i18n('fieldlabel.estado.tecnico'),
					        bind: {        
					        	store : '{comboEstadoTecnico}',
					        	disabled: '{!situacionPosesoria.tieneOkTecnico}',
					        	hidden: '{!activo.isCarteraBankia}',
				            	value: '{situacionPosesoria.estadoTecnicoCodigo}',
								rawValue: '{situacionPosesoria.estadoTecnicoDescripcion}'
					        }
				        },
				        { 
							xtype:'datefieldbase', 
							reference: 'fechaEstadoTecnicoRef',
							allowBlank: true,
							fieldLabel: HreRem.i18n('fieldlabel.fecha.estado.tecnico'),
	                		readOnly: true,
		                	bind:{
		                		value: '{situacionPosesoria.fechaEstadoTecnico}',
		                		hidden: '{!activo.isCarteraBankia}'
		                	}
				        }
					]
                
            }, 
            
            {
				xtype:'fieldsettable',
				title:HreRem.i18n('title.ocupante.ilegal'),
				bind: {hidden:'{!esOcupacionIlegal}'},
				defaultType: 'textfieldbase',
				items : [
					{
						xtype:'datefieldbase',
						reference: 'fechaSolDesahucio',
				        fieldLabel: HreRem.i18n('fieldlabel.fecha.tratamiento.ocupacion'),
		                bind:		'{situacionPosesoria.fechaSolDesahucio}',
				        readOnly: true
					},
					{
						xtype:'datefieldbase',
						hidden: true,
						reference: 'fechaLanzamiento',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.senyalamiento.lanzamiento'),
	                    bind: '{situacionPosesoria.fechalanzamiento}',
                        readOnly: true
	                },
	                {
	                    xtype:'datefieldbase',
						reference: 'fechaLanzamientoEfectivo',
	                    fieldLabel: HreRem.i18n('fieldlabel.fecha.recuperacion.posesion'),
	                    bind:		'{situacionPosesoria.fechaLanzamientoEfectivo}',
	                    readOnly: true
	                }
				]
            },
            {

				xtype:'fieldsettable',
				title:HreRem.i18n('title.historico.ocupaciones.ilegales'),
				reference: 'fieldHistoricoOcupacionesIlegales',
				defaultType: 'textfieldbase',
				items :
					[
						{
		                	xtype: 'historicoocupacionesilegalesgrid',
		                	colspan: 3
    				    }
					
					]
                
			},
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.situacion.ocupacional'),
				reference: 'fieldSituacionOcupacionalGrid',
				defaultType: 'textfieldbase',
				items : [
	                {
	                    xtype:'situacionOcupacionalGrid',
						colspan: 3
	                }
				]
            },
            {
				xtype:'fieldsettable',
				title:'Llaves',
				defaultType: 'textfieldbase',
				items :
					[
						{ 
							xtype:'comboboxfieldbase',
							allowBlank: true,
							editable: false,
							fieldLabel: 'Llaves necesarias',
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{situacionPosesoria.necesarias}'
			            	},
			            	listeners: {
			            		change: function(combo, value) {
			            			var me = this;
			            			if(value=='0') {
			            				me.up('formBase').down('[reference=comboLlaveHre]').setValue("0");
			            				me.up('formBase').down('[reference=comboLlaveHre]').setDisabled(true);
			            			} else {
			            				me.up('formBase').down('[reference=comboLlaveHre]').setDisabled(false);
			            			}
			            		}
			            	}
						},
						{ 
							xtype:'comboboxfieldbase',
							allowBlank: true,
							editable: false,
							reference: 'comboLlaveHre',
							fieldLabel: 'Llaves en poder de HRE',
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{situacionPosesoria.llaveHre}'
			            	},
			            	listeners: {
			            		change: function(combo, value) {
			            			var me = this;
			            			if(value=='0') {
			            				me.up('formBase').down('[reference=fechaRecepcionLlave]').setValue("");
			            				me.up('formBase').down('[reference=fechaRecepcionLlave]').setDisabled(true);
			            				me.up('formBase').down('[reference=numJuegos]').setValue("0");
			            				me.up('formBase').down('[reference=numJuegos]').setDisabled(true);
			            			} else {
			            				me.up('formBase').down('[reference=fechaRecepcionLlave]').setDisabled(false);
			            				me.up('formBase').down('[reference=numJuegos]').setDisabled(false);
			            			}
			            		}
			            	}
						},
						{ 
							xtype:'datefieldbase',
							reference: 'fechaPrimerAnillado',
							fieldLabel: 'Fecha primer anillado',
		                	bind:		'{situacionPosesoria.fechaPrimerAnillado}'
		                },
						{ 
							xtype:'datefieldbase',
							reference: 'fechaRecepcionLlave',
							fieldLabel: 'Fecha recepci&oacute;n llaves',
		                	bind:		'{situacionPosesoria.fechaRecepcionLlave}',
		                	readOnly: true
		                },
		                {
		                	xtype: 'displayfieldbase',
		                	maskRe: /^\d*$/,
		                	minValue: 1,
		                	colspan: 3,
		                	reference: 'numJuegos',
		                	fieldLabel: 'N&uacute;mero de juegos',
		                	bind:		'{situacionPosesoria.numJuegos}'
		                },
		                {
		                	xtype: 'llaveslist',
		                	colspan: 3
		                },
		                {
		                	xtype: 'fieldsettable',
		    				title: HreRem.i18n('title.situacion.posesoria.movimientos.llave'),
		    				defaultType: 'textfieldbase',
		    				reference: 'fieldsetmovimientosllavelist',
		    				collapsed: false,
		    				colspan: 4,
		    				items : [
		    				    {
				                	xtype: 'movimientosllavelist',
				                	colspan: 3
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
   		fechaTomaPosesion = me.down('[reference=fechaTomaPosesion]'),
   		fechaRevisionEstadoPosesorio = me.down('[reference=fechaRevisionEstadoPosesorio]'),
   		fechaSolDesahucio = me.down('[reference=fechaSolDesahucio]'),
   		fechaLanzamiento = me.down('[reference=fechaLanzamiento]'),
   		fechaLanzamientoEfectivo = me.down('[reference=fechaLanzamientoEfectivo]');
   	//	conTitulo = me.down('[reference=comboSituacionPosesoriaConTitulo]');
   	//	ocupadoRef = me.down('[reference=comboOcupadoRef]');
//   	datefieldFechaTitulo = me.down('[reference=datefieldFechaTitulo]'),
//   	datefieldFechaVencTitulo = me.down('[reference=datefieldFechaVencTitulo]');

   		
   		
   		
   		if((!Ext.isEmpty(fechaTomaPosesion.getValue()) || !fechaTomaPosesion.getValue() == null)  && (!Ext.isEmpty(fechaRevisionEstadoPosesorio.getValue()) || !fechaRevisionEstadoPosesorio.getValue() == null)  && fechaTomaPosesion.getValue() > fechaRevisionEstadoPosesorio.getValue()) {
		    error = HreRem.i18n("txt.validacion.fechaTomaPosesion.mayor.fechaRevisionEstadoPosesorio");
   			errores.push(error);
   			fechaTomaPosesion.markInvalid(error);   			
   		}  		

   		if((!Ext.isEmpty(fechaLanzamiento.getValue()) || !fechaLanzamiento.getValue() == null)  && (!Ext.isEmpty(fechaSolDesahucio.getValue()) || !fechaSolDesahucio.getValue() == null) && fechaLanzamiento.getValue() < fechaSolDesahucio.getValue() ) {
		    error = HreRem.i18n("txt.validacion.fechaLanzamiento.menor.fechaSolDesahucio");
   			errores.push(error);
   			fechaLanzamiento.markInvalid(error);   			
   		}

   		if((!Ext.isEmpty(fechaLanzamientoEfectivo.getValue()) || !fechaLanzamientoEfectivo.getValue() == null)  && (!Ext.isEmpty(fechaLanzamiento.getValue()) || !fechaLanzamiento.getValue() == null) && fechaLanzamientoEfectivo.getValue() < fechaLanzamiento.getValue()) {
		    error = HreRem.i18n("txt.validacion.fechaLanzamientoEfectivo.menor.fechaLanzamiento");
   			errores.push(error);
   			fechaLanzamientoEfectivo.markInvalid(error);   			
   		}
   		
   		/*if((Ext.isEmpty(conTitulo.getValue()) || !conTitulo.getValue()== null)  && ocupadoRef.getValue() == 1) {
		    
   			error = HreRem.i18n("Error");
   			errores.push(error);
   			ocupadoRef.markInvalid(error);   			
   		} */
   		
   		
   		

//   		//La fecha de t�tulo posesorio debe ser anterior a la fecha de vencimiento
//   		if(!Ext.isEmpty(datefieldFechaTitulo.getValue()) && datefieldFechaTitulo.getValue() >= datefieldFechaVencTitulo.getValue()) {
//		    error = HreRem.i18n("txt.validacion.datefieldFechaTitulo.mayor.datefieldFechaVencTitulo");
//   			errores.push(error);
//   			datefieldFechaTitulo.markInvalid(error);   			
//   		}  	

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