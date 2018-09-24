Ext.define('HreRem.view.activos.tramites.LanzarTareaAdministrativa', {
	extend : 'HreRem.view.common.TareaBase',
	xtype : 'lanzarTareaAdministrativa',
	
	requires: ['HreRem.view.activos.tramites.LanzarTareaAdministrativaModel'],
	
	viewModel : {
		type : 'lanzartareaadministrativa'
	},
	
	idTramite: null,
	
	idExpediente: null,

	listeners : {

		resize : function(window, width, height, eOpts) {
			var X = window.getX();
			var newY = Ext.Element.getViewportHeight() / 2 - height / 2;

			// La primera vez que se redimensiona no existe eOpts y no hace
			// falta volver a posicionar
			if (!Ext.isEmpty(eOpts)) {
				window.setPosition(X, newY);
			}

		}
	},
	initComponent : function() {
		var me = this;

		me.getViewModel().set('idExpediente', me.idExpediente);
		
		me.setTitle(HreRem.i18n('title.lanzar.tarea.administrativa'));
		
		me.btn_guardar_txt = HreRem.i18n("btn.saltar.a.tarea");

		me.items = [{

			xtype : 'form',
			reference : 'formSaltoTarea',
			scrollable : 'y',
			layout : 'anchor',
			items : [
				
				{
                    xtype: 'label',
                    cls: 'info-tarea',
                    bind: {
                        html: '{errorValidacionGuardado}'
                    },
                    tipo: 'info',
                    style: 'color:red'
                },
				{
					xtype : 'fieldset',
					collapsible : true,
					defaultType : 'textfieldbase',
					title : HreRem.i18n('fieldset.salto.tarea.instrucciones'),
					anchor : '100%',
					layout : 'vbox',
					defaults : {
						margin : '0 10 10 0'
					},
					items : [{
							xtype : 'label',
							cls : 'info-salto-tarea',
							html : HreRem
									.i18n('label.salto.tarea.instrucciones'),
							tipo : 'info'
						}, {
							xtype : 'comboboxfieldbase',
							fieldLabel : HreRem
									.i18n('combolabel.salto.tarea.tarea.destino'),
							addUxReadOnlyEditFieldPlugin : false,
							name : 'codigoTareaDestino',
							bind : {
								store : '{comboTareaDestinoSalto}'
							},
							allowBlank : false,
							listeners : {

								select : function(combo, record) {

									var items, codigo = record.data.codigo;
									combo.up("form").down("#camposFormSaltoTarea").removeAll();
									items = eval("me.getCampos_tarea" + codigo + "(me)");
									combo.up("form").down("#camposFormSaltoTarea").add(items);
								}
							}
						}]
			}, {
				xtype : 'container',
				reference : "camposFormSaltoTarea",
				itemId : "camposFormSaltoTarea"
			}]
		}];

		me.callParent();

	},

	// -----------------------------------------------------------------------------------
	// DEFINICION OFERTA
	// -----------------------------------------------------------------------------------

	getCampos_definicionOferta_conflictoIntereses : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.definicion.oferta.conflicto.de.intereses'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'conflictoIntereses',
			emptyText : HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind : {
				store : '{comboSiNoRem}'
			},
			allowBlank : false
		};

		return items;

	},

	getCampos_definicionOferta_riesgoReputacional : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.definicion.oferta.riego.reputacional'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'riesgoReputacional',
			emptyText : HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind : {
				store : '{comboSiNoRem}'
			},
			allowBlank : false
		};

		return items;

	},

	getCampos_definicionOferta_comiteSancionador : function() {
		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.definicion.oferta.comite.sancionador'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'comiteSancionador',
			bind : {
				store : '{comboComites}'
			},
			allowBlank : false
		};

		return items;

	},

	getCampos_definicionOferta_fechaEnvioSancion : function() {

		var items = {
			xtype : 'datefieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('datefield.salto.tarea.definicion.oferta.fecha.envio.sancion'),
			name : 'fechaEnvioSancion',
			allowBlank : false
		};

		return items;

	},

	getCampos_definicionOferta : function(me) {

		var items = {
			xtype : 'fieldset',
			title : HreRem.i18n('fieldset.salto.tarea.definicion.oferta'),
			
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 2,
				tableAttrs : {
					style : {
						width : '100%'
					}
				},
				tdAttrs : {
					style : {
						width : '50%'
					}
				}
			},
			items : [me.getCampos_definicionOferta_conflictoIntereses(),
					me.getCampos_definicionOferta_riesgoReputacional(),
					me.getCampos_definicionOferta_comiteSancionador(),
					me.getCampos_definicionOferta_fechaEnvioSancion()]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// FIRMA PROPIETARIO
	// -----------------------------------------------------------------------------------

	getCampos_firmaPropietario_firmaEscritura : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem.i18n('combolabel.salto.tarea.firma.propietario.firma.escritura'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'firmaEscritura',
			emptyText : HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind : {
				store : '{comboSiNoRem}'
			}
		};

		return items;

	},

	getCampos_firmaPropietario_fechaFirma : function() {

		var items = {
			xtype : 'datefieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem.i18n('datefield.salto.tarea.firma.propietario.fecha.firma'),
			name : 'fechaFirmaPropietario'
		};

		return items;

	},

	getCampos_firmaPropietario_notario : function() {

		var items = {
			xtype : 'textfieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('textfield.salto.tarea.firma.propietario.notario'),
			name : 'notario'
		};

		return items;

	},

	getCampos_firmaPropietario_numProtocolo : function() {

		var items = {
			xtype : 'numberfieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('numberfield.salto.tarea.firma.propietario.num.protocolo'),
			name : 'numProtocolo'
		};

		return items;

	},

	getCampos_firmaPropietario_precioEscrituracion : function() {

		var items = {
			xtype : 'numberfieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('numberfield.salto.tarea.firma.propietario.precio.escrituracion'),
			name : 'precioEscrituracion'
		};

		return items;

	},

	getCampos_firmaPropietario_motivoAnulacion : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.firma.propietario.motivo.anulacion'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'motivoAnulacion',
			bind : {
				store : '{comboMotivoAnulacionExpediente}'
			},
			allowBlank : false
		};

		return items;

	},

	getCampos_firmaPropietario : function(me) {

		var items = {
			xtype : 'fieldset',
			title : HreRem.i18n('fieldset.salto.tarea.firma.propietario'),
			
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 2,
				tableAttrs : {
					style : {
						width : '100%'
					}
				},
				tdAttrs : {
					style : {
						width : '50%'
					}
				}
			},
			items : [me.getCampos_firmaPropietario_firmaEscritura(),
					me.getCampos_firmaPropietario_fechaFirma(),
					me.getCampos_firmaPropietario_notario(),
					me.getCampos_firmaPropietario_numProtocolo(),
					me.getCampos_firmaPropietario_precioEscrituracion(),
					me.getCampos_firmaPropietario_motivoAnulacion()]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// RESOLUCION COMITE
	// -----------------------------------------------------------------------------------

	getCampos_resolucionComite_fechaRespuesta : function() {

		var items = {
			xtype : 'datefieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('datefield.salto.tarea.resolucion.comite.fecha.respuesta'),
			name : 'fechaRespuestaComite',
			allowBlank: false
		};

		return items;

	},

	getCampos_resolucionComite_resolucion : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.resolucion.comite.resolucion'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'resolucion',
			bind : {
				store : '{comboResolucionComite}'
			},
			allowBlank : false,
			listeners: {
				select: function(combo, record) {
				 	var codigo = record.get("codigo");
					combo.up("form").down("field[name=importeContraoferta]").setAllowBlank(CONST.TIPO_RESOLUCION_COMITE['CONTRAOFERTA'] != codigo);
				}
			}
		};

		return items;

	},

	getCampos_resolucionComite_importeContraoferta : function() {

		var items = {
			xtype : 'numberfieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('numberfield.salto.tarea.resolucion.comite.importe.contraoferta'),
			name : 'importeContraoferta'
		};

		return items;

	},

	getCampos_resolucionComite : function(me) {

		var items = {
			xtype : 'fieldset',
			title : HreRem.i18n('fieldset.salto.tarea.resolucion.comite'),
			
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 2,
				tableAttrs : {
					style : {
						width : '100%'
					}
				},
				tdAttrs : {
					style : {
						width : '50%'
					}
				}
			},
			items : [me.getCampos_resolucionComite_fechaRespuesta(),
					me.getCampos_resolucionComite_resolucion(),
					me.getCampos_resolucionComite_importeContraoferta()]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// RESPUESTA OFERTANTE
	// -----------------------------------------------------------------------------------

	getCampos_respuestaOfertante_aceptaContraoferta : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.respuesta.ofertante.acepta.contraoferta'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'aceptaContraoferta',
			emptyText : HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind : {
				store : '{comboSiNoRem}'
			},
			allowBlank : false
		};

		return items;

	},

	getCampos_respuestaOfertante_fechaRespuesta : function() {

		var items = {
			xtype : 'datefieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('datefield.salto.tarea.respuesta.ofertante.fecha.respuesta'),
			name : 'fechaRespuestaOfertante'
		};

		return items;

	},

	getCampos_respuestaOfertante_importeOfertante : function() {

		var items = {
			xtype : 'numberfieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('numberfield.salto.tarea.respuesta.ofertante.importe.ofertante'),
			name : 'importeOfertante'
		};

		return items;

	},

	getCampos_respuestaOfertante : function(me) {

		var items = {
			xtype : 'fieldset',
			title : HreRem.i18n('fieldset.salto.tarea.respuesta.ofertante'),
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 2,
				tableAttrs : {
					style : {
						width : '100%'
					}
				},
				tdAttrs : {
					style : {
						width : '50%'
					}
				}
			},
			items : [me.getCampos_respuestaOfertante_aceptaContraoferta(),
					me.getCampos_respuestaOfertante_fechaRespuesta(),
					me.getCampos_respuestaOfertante_importeOfertante()]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// INSTRUCCIONES RESERVA
	// -----------------------------------------------------------------------------------

	getCampos_instruccionesReserva_tipoArras : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.instrucciones.reserva.tipo.arras'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'tipoArras',
			bind : {
				store : '{comboTipoArras}'
			}/*,
			allowBlank : false*/
		};

		return items;

	},

	getCampos_instruccionesReserva_fechaEnvioReserva : function() {

		var items = {
			xtype : 'datefieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('datefield.salto.tarea.instrucciones.reserva.fecha.envio'),
			name : 'fechaEnvioReserva'/*,
			allowBlank: false*/
		};

		return items;

	},

	getCampos_instruccionesReserva : function(me) {

		var items = {
			xtype : 'fieldset',
			title : HreRem.i18n('fieldset.salto.tarea.instrucciones.reserva'),
			
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 2,
				tableAttrs : {
					style : {
						width : '100%'
					}
				},
				tdAttrs : {
					style : {
						width : '50%'
					}
				}
			},
			items : [me.getCampos_instruccionesReserva_tipoArras(),
					me.getCampos_instruccionesReserva_fechaEnvioReserva()]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// OBTENCION CONTRATO RESERVA
	// -----------------------------------------------------------------------------------

	getCampos_obtencionContratoReserva_fechaFirma : function() {

		var items = {
			xtype : 'datefieldbase',
			addUxReadOnlyEditFieldPlugin : false,
			fieldLabel : HreRem
					.i18n('datefield.salto.tarea.obtencion.contrato.reserva.fecha.firma'),
			name : 'fechaFirmaReserva'
		};

		return items;

	},

	getCampos_obtencionContratoReserva : function(me) {

		var items = {
			xtype : 'fieldset',
			title : HreRem.i18n('fieldset.salto.tarea.obtencion.contrato.reserva'),
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 1,
				tableAttrs : {
					style : {
						width : '50%'
					}
				},
				tdAttrs : {
					style : {
						width : '100%'
					}
				}
			},
			items : [me.getCampos_obtencionContratoReserva_fechaFirma()]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// RESULTADO PBC
	// -----------------------------------------------------------------------------------

	getCampos_resultadoPBC_pbcAprobado : function() {

		var items = {
			xtype : 'comboboxfieldbase',
			fieldLabel : HreRem
					.i18n('combolabel.salto.tarea.resultado.pbc.aprobado'),
			addUxReadOnlyEditFieldPlugin : false,
			name : 'pbc_aprobado',
			emptyText : HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
			bind : {
				store : '{comboSiNoRem}'
			},
			allowBlank : false
		};

		return items;

	},

	getCampos_resultadoPBC : function(me) {

		var items = {
			xtype : 'fieldset',
			title : HreRem.i18n('fieldset.salto.tarea.resultado.pbc'),
			
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 1,
				tableAttrs : {
					style : {
						width : '50%'
					}
				},
				tdAttrs : {
					style : {
						width : '100%'
					}
				}
			},
			items : [me.getCampos_resultadoPBC_pbcAprobado()]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// RESERVA
	// -----------------------------------------------------------------------------------


	getCampos_Reserva : function(me, value) {

		readOnly = value || false;
		value = value || "";
		var items = {
			xtype : 'fieldset',
			padding : 10,
			anchor : '100%',
			layout : {
				type : 'table',
				columns : 1,
				tableAttrs : {
					style : {
						width : '50%'
					}
				},
				tdAttrs : {
					style : {
						width : '100%'
					}
				}
			},
			items : [ 
				{
					xtype : 'comboboxfieldbase',
					fieldLabel : HreRem.i18n("fieldlabel.solicita.reserva"),
					addUxReadOnlyEditFieldPlugin : false,
					name : 'solicitaReserva',
					emptyText : HreRem.i18n('combolabel.salto.tarea.sino.emptytext'),
					bind : {
						store : '{comboSiNoRem}'
					},
					value: value,
					readOnly : readOnly,
					listeners : {
						//Dependiendo del valor de solicitaReserva, los campos dependientes de la reserva se podrán dejar en blanco o no
						select : function(combo, record) {
							var codigo = record.data.codigo;
							combo.up("form").down("field[name=fechaFirmaReserva]").setAllowBlank(codigo != 1)
							combo.up("form").down("field[name=tipoArras]").setAllowBlank(codigo != 1)
							combo.up("form").down("field[name=fechaEnvioReserva]").setAllowBlank(codigo != 1)
						}
					}
				}
			]
		};

		return items;

	},

	// -----------------------------------------------------------------------------------
	// TAREAS A SALTAR
	// -----------------------------------------------------------------------------------

	// FIRMA PROPIETARIO
	getCampos_tareaT013_FirmaPropietario : function(me) {

		var items = me.getCampos_definicionOferta(me);

		return items;

	},

	// CIERRE ECONOMICO
	getCampos_tareaT013_CierreEconomico : function(me) {

		var items = me.getCampos_definicionOferta(me);

		return items;

	},

	// RESOLUCION_COMITE
	getCampos_tareaT013_ResolucionComite : function(me) {

		var items = me.getCampos_definicionOferta(me);

		return items;

	},

	// RESPUESTA OFERTANTE
	getCampos_tareaT013_RespuestaOfertante : function(me) {

		var items = [me.getCampos_definicionOferta(me),
				me.getCampos_resolucionComite(me)]

		return items;

	},

	// INSTRUCCIONES RESERVA
	getCampos_tareaT013_InstruccionesReserva : function(me) {

		var items = [me.getCampos_definicionOferta(me),
				me.getCampos_Reserva(me, 1)]

		return items;

	},

	// OBTENCION CONTRATO RESERVA
	getCampos_tareaT013_ObtencionContratoReserva : function(me) {

		var items = [me.getCampos_definicionOferta(me),
				me.getCampos_instruccionesReserva(me), me.getCampos_Reserva(me, 1)]

		return items;

	},

	// RESULTADO PBC
	getCampos_tareaT013_ResultadoPBC : function(me) {

		var items = [me.getCampos_definicionOferta(me),
				me.getCampos_instruccionesReserva(me),
				me.getCampos_obtencionContratoReserva(me),
				me.getCampos_Reserva(me)]

		return items;

	},

	// POSICIONAMIENTO Y FIRMAS
	getCampos_tareaT013_PosicionamientoYFirma : function(me) {

		var items = [me.getCampos_definicionOferta(me),
				me.getCampos_resultadoPBC(me),
				me.getCampos_instruccionesReserva(me),
				me.getCampos_obtencionContratoReserva(me),
				me.getCampos_Reserva(me)]

		return items;

	},

	// RATIFICACION COMITE
	getCampos_tareaT013_RatificacionComite : function(me) {

		var items = [me.getCampos_definicionOferta(me),
				me.getCampos_resolucionComite(me),
				me.getCampos_respuestaOfertante(me)]

		return items;

	},

	// DEFINICION OFERTA
	getCampos_tareaT013_DefinicionOferta : function(me) {

		var items = [/*
			me.getCampos_definicionOferta(me)
			,me.getCampos_firmaPropietario(me)
			,me.getCampos_resolucionComite(me)
			,me.getCampos_respuestaOfertante(me)
			,me.getCampos_instruccionesReserva(me)
			,me.getCampos_obtencionContratoReserva(me)
			,me.getCampos_resultadoPBC(me)
			,me.getCampos_Reserva(me)*/
		
		]

		return items;

	},
	
	evaluar: function() {
        var me = this;

        var parametros = me.down("form").getValues(false,false,false,true);        
        parametros.idTramite=me.idTramite;

        var url = $AC.getRemoteUrl('agenda/lanzarTareaAdministrativa');
        Ext.Ajax.request({
            url: url,
            params: parametros,
            success: function(response, opts) {

                var json = Ext.decode(response.responseText);
                
                if(!json.success) {
                	
                	Ext.Msg.alert(HreRem.i18n('msg.error'), HreRem.i18n("msg.operacion.ko"));

                } else if (json.errorValidacionGuardado) {
                    me.getViewModel().set("errorValidacionGuardado", json.errorValidacionGuardado);
                    me.unmask();
                } else {
                    me.unmask();
                    me.fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['TRAMITE'], me.idTramite);
                    me.fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['EXPEDIENTE'], me.idExpediente);
                    me.destroy();
                }

            }
        });

    }


});