Ext.define('HreRem.view.activos.detalle.SituacionPosesoriaActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'situacionposesoriaactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'situacionposesoriaactivoref',
    scrollable	: 'y',
    listeners: {
			boxready:'cargarTabData'
	},

	recordName: "situacionPosesoria",
	
	recordClass: "HreRem.model.ActivoSituacionPosesoria",
	
    requires: ['HreRem.model.ActivoSituacionPosesoria', 'HreRem.model.OcupantesLegales', 'HreRem.view.activos.detalle.LlavesList', 'HreRem.view.activos.detalle.MovimientosLlaveList'],
	
    initComponent: function () {
    	
        var me = this;
        var storeConTituloPosesionNo = Ext.create('Ext.data.Store', {
					data : [{
						"codigo" : "01",
						"descripcion" : eval(String.fromCharCode(34, 83, 237,
								34))
					}, {
						"codigo" : "0",
						"descripcion" : "No, con indicios"
					}]
				});
        me.setTitle(HreRem.i18n('title.situacion.posesoria.llaves'));
        var items= [

			{    
                
				xtype:'fieldsettable',
				title:HreRem.i18n('title.situacion.posesoria'),
				defaultType: 'textfieldbase',
				items :
					[
						

					
						{ 	// Este campo es necesario para corregir lo que parece un BUG. 
							// TODO Investigar porqu� al quitar este campo, el valor del siguiente campo se manda siempre al guardar, aunque no se haya modificado.
			            	hidden: true
						},
				        {
							xtype: 'comboboxfieldbase',
							reference: 'conPosesion',
							fieldLabel: HreRem.i18n('fieldlabel.con.posesion'),
							readOnly: true,
				        	bind: {				        		
				        		store: '{comboSiNoRem}',
			            		value: '{situacionPosesoria.indicaPosesion}'
			            	},
			            	listeners: {
			            		change: function(combo, value) {
			            			var me = this;
			            			if(value=='0') {
			            				me.up('formBase').down('[reference=comboSituacionPosesoriaConTitulo]').setStore(storeConTituloPosesionNo);
			            			}
			            			
			            		}
			            	}
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
					            	width: 150,
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
						        	xtype:'datefieldbase',
						        	reference: 'datefieldTapiado',
						        	fieldLabel: 'Fecha tapiado',
						        	bind: {
						        		value: '{situacionPosesoria.fechaAccesoTapiado}'
						        	},
					            	labelWidth: 80,
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
					            	width: 150,
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
						        }
							]
						},
						{ 
							xtype:'datefieldbase',
							reference: 'fechaTomaPosesion',
							allowBlank: false,
							fieldLabel: HreRem.i18n('fieldlabel.fecha.obtencion.posesion'),
		                	bind:	{
		                		value: '{situacionPosesoria.fechaTomaPosesion}',
		                		readOnly: '{esSituacionJudicial}'
		                	}
		                },
		                {
							xtype: 'checkboxfieldbase',
							fieldLabel: HreRem.i18n('filedlabel.tiene.ok.tecnico'),
							bind: {
								value: '{situacionPosesoria.tieneOkTecnico}',
								readOnly: '{!activo.aplicaGestion}'
							}
						},
		                { 

				        	xtype: 'comboboxfieldbase',
				        	allowBlank: false,
							fieldLabel: HreRem.i18n('fieldlabel.ocupado'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{situacionPosesoria.ocupado}'
			            	},
			            	listeners: {
			            		change: function(combo, value) {
			            			var me = this;
			            			if(value=='0') {
			            				me.up('formBase').down('[reference=comboSituacionPosesoriaConTitulo]').setValue(null);
			            				me.up('formBase').down('[reference=comboSituacionPosesoriaConTitulo]').setDisabled(true);
			            			} else {
			            				me.up('formBase').down('[reference=comboSituacionPosesoriaConTitulo]').setDisabled(false);
			            			}
			            			
			            		}
			            	}
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
				        	xtype: 'comboboxfieldbase',
				        	reference: 'comboSituacionPosesoriaConTitulo',
							fieldLabel: HreRem.i18n('fieldlabel.con.titulo'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{situacionPosesoria.conTitulo}'
			            	}
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
				        }
					]
                
            }, 
            
            {    
                
				xtype:'fieldsettable',
				title:HreRem.i18n('title.ocupante.legal'),
				bind: {
					hidden:'{!esOcupacionLegal}',
					disabled: '{!esOcupacionLegal}'
				},
				defaultType: 'textfieldbase',
				items :
					[
						{ 
				        	xtype: 'comboboxfieldbase',
				        	allowBlank: false,
							fieldLabel: HreRem.i18n('fieldlabel.titulo.posesorio'),
				        	bind: {
			            		store: '{comboTipoPosesorio}',
			            		value: '{situacionPosesoria.tipoTituloPosesorioCodigo}'
			            	}
				        },
						{ 
							xtype:'datefieldbase',
							reference: 'datefieldFechaTitulo',
							maxValue: null,
							fieldLabel: HreRem.i18n('fieldlabel.fecha.titulo.posesorio'),
							bind: '{situacionPosesoria.fechaTitulo}'
		                },
		                { 
		                	xtype:'datefieldbase',
		                	reference: 'datefieldFechaVencTitulo',
		                	allowBlank: false,
							maxValue: null,
		                	fieldLabel: HreRem.i18n('fieldlabel.fecha.vencimiento.titulo.posesorio'),
		                	bind:		'{situacionPosesoria.fechaVencTitulo}'
		                },
		                { 
		                	xtype:'currencyfieldbase',
		                	allowBlank: false,
		                	fieldLabel: HreRem.i18n('fieldlabel.renta.mensual'),
		                	colspan:	3,
		                	bind:		'{situacionPosesoria.rentaMensual}'
		                },
		                {
		                	xtype: 'gridBaseEditableRow',
		                	title: 'Lista de ocupantes legales',
		    			    topBar: true,
		    			    idPrincipal: 'activo.id',
		    				cls	: 'panel-base shadow-panel',
		    				colspan: 3,
		    				layout:'fit',
		    				minHeight: 240,
		    				bind: {
		    					store: '{storeOcupantesLegales}'
		    				},

		    				columns: [
		    				    {   text: 'Nombre',
		    			        	dataIndex: 'nombreOcupante',
		    			        	editor: {xtype:'textfield', allowBlank: false},
		    			        	flex: 1
		    			        },
		    			        {   text: 'NIF',
		    			        	dataIndex: 'nifOcupante',
		    			        	editor: {xtype:'textfield', allowBlank: false},
		    			        	flex: 1
		    			        },	
		    			        {   text: 'Tel&eacute;fono',
		    			        	dataIndex: 'telefonoOcupante',
		    			        	editor: {xtype:'textfield'},
		    			        	flex: 1
		    			        },	
		    			        {   text: 'Email',
		    			        	dataIndex: 'emailOcupante',
		    			        	editor: {xtype:'textfield'},
		    			        	flex: 1
		    			        },	
		    					{
		    			            text: 'Observaciones',
		    			            dataIndex: 'observacionesOcupante',
		    			            editor: {xtype:'textfield'},
		    			            flex: 1
		    			        }		    			       	        
		    			    ],
		    			    dockedItems : [
		    			        {
		    			            xtype: 'pagingtoolbar',
		    			            dock: 'bottom',
		    			            displayInfo: true,
		    			            bind: {
		    			                store: '{storeOcupantesLegales}'
		    			            }
		    			        }
		    			    ]
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
				title:'Llaves',
				defaultType: 'textfieldbase',
				items :
					[
						{ 
							xtype:'comboboxfieldbase',
							allowBlank: false,
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
							allowBlank: false,
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
							reference: 'fechaRecepcionLlave',
							fieldLabel: 'Fecha recepci&oacute;n llaves',
		                	bind:		'{situacionPosesoria.fechaRecepcionLlave}'
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
   		fechaLanzamientoEfectivo = me.down('[reference=fechaLanzamientoEfectivo]'),
   		datefieldFechaTitulo = me.down('[reference=datefieldFechaTitulo]'),
   		datefieldFechaVencTitulo = me.down('[reference=datefieldFechaVencTitulo]');

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

   		//La fecha de t�tulo posesorio debe ser anterior a la fecha de vencimiento
   		if(!Ext.isEmpty(datefieldFechaTitulo.getValue()) && datefieldFechaTitulo.getValue() >= datefieldFechaVencTitulo.getValue()) {
		    error = HreRem.i18n("txt.validacion.datefieldFechaTitulo.mayor.datefieldFechaVencTitulo");
   			errores.push(error);
   			datefieldFechaTitulo.markInvalid(error);   			
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