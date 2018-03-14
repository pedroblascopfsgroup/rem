Ext.define('HreRem.view.activos.tramites.LanzarTareaAdministrativa', {
	extend : 'HreRem.view.common.WindowBase',
	xtype : 'lanzarTareaAdministrativa',
	reference : 'windowLanzarTareaAdministrativa',
	title : "Lanzar tarea administrativa",
	width : Ext.Element.getViewportWidth() / 1.3,
	viewModel: {
        type: 'lanzartareaadministrativa'
    },
	
	initComponent : function() {
		var me = this;

		me.buttons = [ {
			itemId : 'btnSaltoTarea',
			text : HreRem.i18n('btn.salto.tarea.saltar'),
			handler : 'saltoTarea'
		}, {
			itemId : 'btnCancelarSaltoTarea',
			text : HreRem.i18n('btn.salto.tarea.cerrar'),
			handler : 'cancelarSaltoTarea'
		} ];

		me.items = [{
			
			xtype : 'form',
			reference : 'formSaltoTarea',
			scrollable	: 'y',
			layout: 'anchor',
			items : 
			[
				{
					xtype : 'fieldset',
					collapsible : true,
					defaultType : 'textfield',
					title : HreRem.i18n('fieldset.salto.tarea.instrucciones'),
					anchor: '100%',
					layout: 'vbox',
					defaults: {
						margin: '0 10 10 0'
				    },
					items : [ 
						{
							xtype : 'label',
							cls : 'info-salto-tarea',
							html : HreRem.i18n('label.salto.tarea.instrucciones'),
							tipo : 'info'
						},
						{
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.tarea.destino'),
				        	addUxReadOnlyEditFieldPlugin: false,
							name: 'tarea_destino',
							valueField: 'tarea_destino',
							bind: {
				               	store: '{comboTareaDestinoSalto}'
				            },
				            allowBlank: false,
				            colspan: 2,
				            listeners: {
				            	
				            	select: function(combo,record, a,b,c) {
				            		
				            		var items;
				            		combo.up("form").down("#camposFormSaltoTarea").removeAll();
				            		switch(record.data.codigo) {
					            		case "01":  items = me.getCampos_all(me); break;
					            		case "02":  items = me.getCampos_tarea02(me); break;
					            		case "03":  items = me.getCampos_tarea03(me); break;
					            		case "04":  items = me.getCampos_tarea04(me); break;
					            		case "05":  items = me.getCampos_tarea05(me); break;
					            		case "06":  items = me.getCampos_tarea06(me); break;
					            		case "07":  items = me.getCampos_tarea07(me); break;
					            		case "08":  items = me.getCampos_tarea09(me); break;
					            		case "09":  items = me.getCampos_tarea08(me); break;
					            		case "10":  items = me.getCampos_tarea10(me); break;
						            	default: console.log("default");
				            		}
				            		combo.up("form").down("#camposFormSaltoTarea").add(items);
				            		//combo.up("form").down("#camposFormSaltoTarea").removeAll();
				            		//combo.up("form").down("camposFormSaltoTarea").add(eval('me.getCampos_tarea'+record.get("codigo")+'()'));
				            	}
				            }
						}
					]
				},
				{
					xtype: 'container',
					reference: "camposFormSaltoTarea",
					id: "camposFormSaltoTarea"
				}
			]
		}];

		me.callParent();

	},
	
	//-----------------------------------------------------------------------------------
	//DEFINICION OFERTA
	//-----------------------------------------------------------------------------------
	
	getCampos_definicionOferta_conflictoIntereses: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.definicion.oferta.conflicto.de.intereses'),
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'conflicto_intereses',
			valueField: 'conflicto_intereses',
			emptyText: HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind: {
               	store: '{comboSiNoRem}'
            },
            allowBlank: false
		};
		
		return items;
		
	},
	
	getCampos_definicionOferta_riesgoReputacional: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.definicion.oferta.riego.reputacional'),
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'riesgo_reputacional',
			valueField: 'riesgo_reputacional',
			emptyText: HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind: {
               	store: '{comboSiNoRem}'
            },
            allowBlank: false
		};
		
		return items;
		
	},
	
	getCampos_definicionOferta_comiteSancionador: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.definicion.oferta.comite.sancionador'),
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'comite_sancionador',
			valueField: 'comite_sancionador',
			bind: {
               	store: '{comboComiteSancion}'
            },
            allowBlank: false
		};
		
		return items;
		
	},
	
	getCampos_definicionOferta_fechaEnvioSancion: function() {
		
		var items = {
        	xtype: 'datefield',
        	fieldLabel: HreRem.i18n('datefield.salto.tarea.definicion.oferta.fecha.envio.sancion'),
			name: 'fecha_envio_sancion',
			valueField: 'fecha_envio_sancion'
		};
		
		return items;
		
	},
	
	getCampos_definicionOferta: function(me) {
		
		var items = {
				xtype : 'fieldset',
				title : HreRem.i18n('fieldset.salto.tarea.definicion.oferta'),
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_definicionOferta_conflictoIntereses(),
					me.getCampos_definicionOferta_riesgoReputacional(),
					me.getCampos_definicionOferta_comiteSancionador(),
					me.getCampos_definicionOferta_fechaEnvioSancion()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//FIRMA PROPIETARIO
	//-----------------------------------------------------------------------------------
	
	getCampos_firmaPropietario_firmaEscritura: function() {
		
		var items = {
	    	xtype: 'comboboxfieldbase',
	    	fieldLabel: HreRem.i18n('combolabel.salto.tarea.firma.propietario.firma.escritura'),
	    	addUxReadOnlyEditFieldPlugin: false,
			name: 'firma_escritura',
			valueField: 'firma_escritura',
			emptyText: HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind: {
	           	store: '{comboSiNoRem}'
	        },
	        allowBlank: false
		};
		
		return items;
		
	},
	
	getCampos_firmaPropietario_fechaFirma: function() {
		
		var items = {
	    	xtype: 'datefield',
	    	fieldLabel: HreRem.i18n('datefield.salto.tarea.firma.propietario.fecha.firma'),
			name: 'fecha_firma',
			valueField: 'fecha_firma'
		};
		
		return items;
		
	},
	
	getCampos_firmaPropietario_notario: function() {
		
		var items = {
	    	xtype: 'textfield',
	    	fieldLabel: HreRem.i18n('textfield.salto.tarea.firma.propietario.notario'),
			name: 'notario',
			valueField: 'notario'
		};
		
		return items;
		
	},
	
	getCampos_firmaPropietario_numProtocolo: function() {
		
		var items = {
	    	xtype: 'numberfield',
	    	fieldLabel: HreRem.i18n('numberfield.salto.tarea.firma.propietario.num.protocolo'),
			name: 'num_protocolo',
			valueField: 'num_protocolo'
		};
		
		return items;
		
	},
	
	getCampos_firmaPropietario_precioEscrituracion: function() {
		
		var items = {
	    	xtype: 'numberfield',
	    	fieldLabel: HreRem.i18n('numberfield.salto.tarea.firma.propietario.precio.escrituracion'),
			name: 'precio_escrituracion',
			valueField: 'precio_escrituracion'
		};
		
		return items;
		
	},
	
	getCampos_firmaPropietario_motivoAnulacion: function() {
		
		var items = {
	    	xtype: 'comboboxfieldbase',
	    	fieldLabel: HreRem.i18n('combolabel.salto.tarea.firma.propietario.motivo.anulacion'),
	    	addUxReadOnlyEditFieldPlugin: false,
			name: 'motivo_anulacion',
			valueField: 'motivo_anulacion',
			bind: {
	           	store: '{comboMotivoAnulacionExpediente}'
	        },
	        allowBlank: false
		};
		
		return items;
		
	},
	
	getCampos_firmaPropietario: function(me) {
		
		var items = {
				xtype : 'fieldset',
				title : HreRem.i18n('fieldset.salto.tarea.firma.propietario'),
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_firmaPropietario_firmaEscritura(),
					me.getCampos_firmaPropietario_fechaFirma(),
					me.getCampos_firmaPropietario_notario(),
					me.getCampos_firmaPropietario_numProtocolo(),
					me.getCampos_firmaPropietario_precioEscrituracion(),
					me.getCampos_firmaPropietario_motivoAnulacion()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//RESOLUCION COMITE
	//-----------------------------------------------------------------------------------
	
	getCampos_resolucionComite_fechaRespuesta: function() {
		
		var items = {
        	xtype: 'datefield',
        	fieldLabel: HreRem.i18n('datefield.salto.tarea.resolucion.comite.fecha.respuesta'),
			name: 'fecha_respuesta',
			valueField: 'fecha_respuesta'
		};
		
		return items;
		
	},
	
	getCampos_resolucionComite_resolucion: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.resolucion.comite.resolucion'),
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'resolucion',
			valueField: 'resolucion',
			emptyText: HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind: {
               	store: '{comboSiNoRem}'
            },
            allowBlank: false
		};
		
		return items;
		
	},
	
	getCampos_resolucionComite_importeContraoferta: function() {
		
		var items = {
        	xtype: 'numberfield',
        	fieldLabel: HreRem.i18n('numberfield.salto.tarea.resolucion.comite.importe.contraoferta'),
			name: 'importe_contraoferta',
			valueField: 'importe_contraoferta'
		};
		
		return items;
		
	},
	
	getCampos_resolucionComite: function(me) {
		
		var items = {
				xtype : 'fieldset',
				title : HreRem.i18n('fieldset.salto.tarea.resolucion.comite'),
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_resolucionComite_fechaRespuesta(),
					me.getCampos_resolucionComite_resolucion(),
					me.getCampos_resolucionComite_importeContraoferta()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//RESPUESTA OFERTANTE
	//-----------------------------------------------------------------------------------
	
	getCampos_respuestaOfertante_aceptaContraoferta: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.respuesta.ofertante.acepta.contraoferta'),
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'acepta_contraoferta',
			valueField: 'acepta_contraoferta',
			emptyText: HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind: {
               	store: '{comboSiNoRem}'
            },
            allowBlank: false,
            colspan: 2
		};
		
		return items;
		
	},
	
	getCampos_respuestaOfertante_fechaRespuesta: function() {
		
		var items = {
        	xtype: 'datefield',
        	fieldLabel: HreRem.i18n('datefield.salto.tarea.respuesta.ofertante.fecha.respuesta'),
			name: 'fecha_respuesta',
			valueField: 'fecha_respuesta'
		};
		
		return items;
		
	},
	
	getCampos_respuestaOfertante_importeOfertante: function() {
		
		var items = {
        	xtype: 'numberfield',
        	fieldLabel: HreRem.i18n('numberfield.salto.tarea.respuesta.ofertante.importe.ofertante'),
			name: 'importe_ofertante',
			valueField: 'importe_ofertante'
		};
		
		return items;
		
	},
	
	getCampos_respuestaOfertante: function(me) {
		
		var items = {
				xtype : 'fieldset',
				title : HreRem.i18n('fieldset.salto.tarea.respuesta.ofertante'),
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_respuestaOfertante_aceptaContraoferta(),
					me.getCampos_respuestaOfertante_fechaRespuesta(),
					me.getCampos_respuestaOfertante_importeOfertante()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//INSTRUCCIONES RESERVA
	//-----------------------------------------------------------------------------------
	
	getCampos_instruccionesReserva_tipoArras: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.instrucciones.reserva.tipo.arras'),
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'tipo_arras',
			valueField: 'tipo_arras',
			bind: {
               	store: '{comboTipoArras}'
            },
            allowBlank: false,
            colspan: 2
		};
		
		return items;
		
	},
	
	getCampos_instruccionesReserva_fechaEnvio: function() {
		
		var items = {
        	xtype: 'datefield',
        	fieldLabel: HreRem.i18n('datefield.salto.tarea.instrucciones.reserva.fecha.envio'),
			name: 'fecha_envio',
			valueField: 'fecha_envio'
		};
		
		return items;
		
	},
	
	getCampos_instruccionesReserva: function(me) {
		
		var items = {
				xtype : 'fieldset',
				title : HreRem.i18n('fieldset.salto.tarea.instrucciones.reserva'),
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_instruccionesReserva_tipoArras(),
					me.getCampos_instruccionesReserva_fechaEnvio()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//OBTENCION CONTRATO RESERVA
	//-----------------------------------------------------------------------------------
	
	getCampos_obtencionContratoReserva_fechaFirma: function() {
		
		var items = {
        	xtype: 'datefield',
        	fieldLabel: HreRem.i18n('datefield.salto.tarea.obtencion.contrato.reserva.fecha.firma'),
			name: 'fecha_firma',
			valueField: 'fecha_firma'
		};
		
		return items;
		
	},
	
	getCampos_obtencionContratoReserva: function(me) {
		
		var items = {
				xtype : 'fieldset',
				title : HreRem.i18n('fieldset.salto.tarea.obtencion.contrato.reserva'),
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_obtencionContratoReserva_fechaFirma()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//RESULTADO PBC
	//-----------------------------------------------------------------------------------
	
	getCampos_resultadoPBC_pbcAprobado: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: HreRem.i18n('combolabel.salto.tarea.resultado.pbc.aprobado'),
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'pbc_aprobado',
			valueField: 'pbc_aprobado',
			emptyText: HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind: {
               	store: '{comboSiNoRem}'
            },
            allowBlank: false,
            colspan: 2
		};
		
		return items;
		
	},
	
	getCampos_resultadoPBC: function(me) {
		
		var items = {
				xtype : 'fieldset',
				title : HreRem.i18n('fieldset.salto.tarea.resultado.pbc'),
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_resultadoPBC_pbcAprobado()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//RESERVA
	//-----------------------------------------------------------------------------------
	
	getCampos_Reserva_fechaFirma: function() {
		
		var items = {
        	xtype: 'comboboxfieldbase',
        	fieldLabel: 'Solicita reserva ',
        	addUxReadOnlyEditFieldPlugin: false,
			name: 'solicita_reserva',
			valueField: 'solicita_reserva',
			emptyText: HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind: {
               	store: '{comboSiNoRem}'
            },
            allowBlank: false,
            colspan: 2
		};
		
		return items;
		
	},
	
	getCampos_Reserva: function(me) {
		
		var items = {
				xtype : 'fieldset',
				reference: 'formNuevoGestor',
				anchor: '100%',
				layout: {
			        type: 'table',
			        columns: 2,
			        tableAttrs: {
			            style: {
			                width: '100%'
			            }
			        },
			        tdAttrs: {
			            style: {
			                width: '50%'
			            }
			        },
			    },
			    defaults: {
			    	labelWidth: '40%',
					style: 'min-width: 60%',
				},
				items : [			
					me.getCampos_Reserva_fechaFirma()
				]
	    };
			
		return 	items;
		
	},
	
	//-----------------------------------------------------------------------------------
	//TAREAS A SALTAR
	//-----------------------------------------------------------------------------------
	
	//FIRMA PROPIETARIO
	getCampos_tarea02: function(me) {
		
		var items = me.getCampos_definicionOferta(me);
			
		return 	items;
		
	},
	
	//CIERRE ECONOMICO
	getCampos_tarea03: function(me) {
		
		var items = me.getCampos_definicionOferta(me);
		
		return 	items;
		
	},
	
	//RESOLUCION_COMITE
	getCampos_tarea04: function(me) {
		
		var items = me.getCampos_definicionOferta(me);
		
		return 	items;
		
	},
	
	//RESPUESTA OFERTANTE
	getCampos_tarea05: function(me) {
		
		var items = [
			me.getCampos_definicionOferta(me),
			me.getCampos_resolucionComite(me)
		]
		
		return 	items;
		
	},
	
	//INSTRUCCIONES RESERVA
	getCampos_tarea06: function(me) {
		
		var items = [
			me.getCampos_definicionOferta(me),
			me.getCampos_Reserva(me)
		]
		
		return 	items;
		
	},
	
	//OBTENCION CONTRATO RESERVA
	getCampos_tarea07: function(me) {
		
		var items = [
			me.getCampos_definicionOferta(me),
			me.getCampos_instruccionesReserva(me),
			me.getCampos_Reserva(me)
		]
		
		return 	items;
		
	},
	
	//RESULTADO PBC
	getCampos_tarea08: function(me) {
		
		var items = [
			me.getCampos_definicionOferta(me),
			me.getCampos_instruccionesReserva(me),
			me.getCampos_obtencionContratoReserva(me),
			me.getCampos_Reserva(me)
		]
		
		return 	items;
		
	},
	
	//POSICIONAMIENTO Y FIRMAS
	getCampos_tarea09: function(me) {
		
		var items = [
			me.getCampos_definicionOferta(me),
			me.getCampos_resultadoPBC(me),
			me.getCampos_instruccionesReserva(me),
			me.getCampos_obtencionContratoReserva(me),
			me.getCampos_Reserva(me)
		]
		
		return 	items;
		
	},
	
	//RATIFICACION COMITE
	getCampos_tarea10: function(me) {
		
		var items = [
			me.getCampos_definicionOferta(me),
			me.getCampos_resolucionComite(me),
			me.getCampos_respuestaOfertante(me)
		]
		
		return 	items;
		
	},
	
	getCampos_all: function(me) {
		
		var items = [
			me.getCampos_definicionOferta(me),
			me.getCampos_firmaPropietario(me),
			me.getCampos_resolucionComite(me),
			me.getCampos_respuestaOfertante(me),
			me.getCampos_instruccionesReserva(me),
			me.getCampos_obtencionContratoReserva(me),
			me.getCampos_resultadoPBC(me),
			me.getCampos_Reserva(me)
		]
		
		return 	items;
		
	}
	
	
	
});