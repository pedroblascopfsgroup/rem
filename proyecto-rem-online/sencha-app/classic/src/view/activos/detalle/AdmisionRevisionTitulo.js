Ext.define('HreRem.view.activos.detalle.AdmisionRevisionTitulo', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'admisionrevisiontitulo',
	cls : 'panel-base shadow-panel',
	reference : 'admisionrevisiontitulo',
	disableValidation : true,
	saveMultiple : false,
	controller : 'admisionrevisiontitulo',
	viewModel : {
		type : 'admisionRevisionTitulo'
	},
	scrollable : 'y',
	recordName: 'admisionRevisionTitulo',
	recordClass:'HreRem.model.AdmisionRevisionTitulo',
	requires : ['HreRem.model.AdmisionRevisionTitulo'],
	listeners : {
		boxready : function() {
			var me = this;
			me.lookupController().cargarTabData(me);
		}
	},
	initComponent : function() {
		var me = this;
		me.items = [{
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem.i18n('title.admision.revisionTitulo.revision'),
			items : [{
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.revisado'),
				reference : 'comboRevisadoRevisionTitulo',
				bind : {
					store : '{comboSiNoDict}',
					value : '{admisionRevisionTitulo.revisado}'
				},
				listeners: {
					select: 'comboRevisadoOnSelect'
				}
			}, {
				xtype : 'datefieldbase',
				fieldLabel : HreRem.i18n('fieldlabel.admision.revisionTitulo.fechaRevisionTitulo'),
				reference: 'fechaRevisionTitulo',
				readOnly: true,
				bind : {
					value : '{admisionRevisionTitulo.fechaRevisionTitulo}'
				}
			}]

		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.informacionGeneralTitulo'),
			items : [{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tituloPropiedad')
			}, {
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.subtipoTitulo')
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.ratificacion'),
				bind : {
					store : '{comboSiNoNoAplica}',
					value : '{admisionRevisionTitulo.ratificacion}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.instanciaLibertadArrendaticia'),
				bind : {
					store : '{comboSiNoNoAplica}',
					value : '{admisionRevisionTitulo.instLibArrendatariaCodigo}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionInicialInscripcion'),
				bind : {
					store : '{comboSituacionInicialInscripcion}',
					value : '{admisionRevisionTitulo.situacionInicialInscripcion}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionPosesoriaInicial'),
				bind : {
					store : '{comboSituacionPosesoriaInicial}',
					value : '{admisionRevisionTitulo.situacionPosesoriaInicial}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionInicialCargas'),
				bind : {
					store : '{comboSituacionInicialCargas}',
					value : '{admisionRevisionTitulo.situacionInicialCargas}'
				}
			}, {
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionConstructivaRegistral')
			}, {
				xtype : 'numberfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.porcentajePropiedad'),
				bind : {
					value : '{admisionRevisionTitulo.porcentajePropiedad}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoDeTitularidad'),
				bind : {
					store : '{comboTipoTitularidad}',
					value : '{admisionRevisionTitulo.tipoTitularidad}'
				}
			}, {
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.proteccionOficial')
			}, {
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.observaciones'),
				bind : {
					value : '{admisionRevisionTitulo.observaciones}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.concursoAcreedores'),
			items : [{
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.autorizacionTransmision'),
				bind : {
					store : '{comboAutorizacionTransmision}',
					value : '{admisionRevisionTitulo.estadoAutorizaTransmision}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.anotacionConcurso'),
				bind : {
					store : '{comboAnotacionConcurso}',
					value : '{admisionRevisionTitulo.anotacionConcurso}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionCa'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionCa}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.situacionConstructivaInicial'),
			layout : {
				type : 'table',
				columns : 1,
				tdAttrs : {
					width : '100%'
				},
				tableAttrs : {
					style : {
						width : '100%'
					}
				}
			},
			items : [{
				xtype : 'fieldsettable',
				defaultType : 'textfieldbase',
				title : HreRem
						.i18n('title.admision.revisionTitulo.enConstruccionFisica'),
				items : [{
					xtype : 'comboboxfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.enConstruccionFisica'),
					bind : {
						store : '{comboSiNoDict}',
						value : '{admisionRevisionTitulo.consFisica}'
					}
				}, {
					xtype : 'numberfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.porcentajeConstruccionSegunTasacionFisica'),
					bind : {
						value : '{admisionRevisionTitulo.porcentajeConsTasacionCf}'
					}
				}]
			}, {
				xtype : 'fieldsettable',
				defaultType : 'textfieldbase',
				title : HreRem
						.i18n('title.admision.revisionTitulo.enConstruccionJuridica'),
				items : [{
					xtype : 'comboboxfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.enConstruccionJuridica'),
					bind : {
						store : '{comboSiNoDict}',
						value : '{admisionRevisionTitulo.consJuridica}'
					}
				}, {
					xtype : 'numberfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.porcentajeConstruccionSegunTasacionJuridica'),
					bind : {
						value : '{admisionRevisionTitulo.porcentajeConsTasacionCj}'
					}
				}, {
					xtype : 'textfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.certificadoFinObra'),
					bind : {
						value : '{admisionRevisionTitulo.estadoCertificadoFinObra}'
					}
				}, {
					xtype : 'textfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.actaFinObraObraNuevaTerminada'),
					bind : {
						value : '{admisionRevisionTitulo.estadoAfoActaFinObra}'
					}
				}, {
					xtype : 'comboboxfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.licenciaPrimeraOcupacion'),
					bind : {
						store : '{comboLicenciaPrimeraOcupacion}',
						value : '{admisionRevisionTitulo.licenciaPrimeraOcupacion}'
					}
				}, {
					xtype : 'comboboxfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.boletines'),
					bind : {
						store : '{comboBoletines}',
						value : '{admisionRevisionTitulo.boletines}'
					}
				}, {
					xtype : 'comboboxfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.seguroDecenal'),
					bind : {
						store : '{comboSeguroDecenal}',
						value : '{admisionRevisionTitulo.seguroDecenal}'
					}
				}, {
					xtype : 'comboboxfieldbase',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.cedulaHabitabilidad'),
					bind : {
						store : '{comboCedulaHabitabilidad}',
						value : '{admisionRevisionTitulo.cedulaHabitabilidad}'
					}
				}]
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.activosAlquiladosEntrada'),
			items : [{
				xtype : 'datefieldbase',
				fieldLabel : HreRem.i18n('fieldlabel.admision.revisionTitulo.fechaContrato'),
				bind : {
					value : '{admisionRevisionTitulo.fechaContratoAlquiler}'
				}
			},
			{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.legislacionAplicable'),
				bind : {
					value : '{admisionRevisionTitulo.legislacionAplicableAlquiler}'
				}
			}, {
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.duracionContrato'),
				bind : {
					value : '{admisionRevisionTitulo.duracionContratoAlquiler}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoArrendamiento'),
				bind : {
					store : '{comboTipoArrendamiento}',
					value : '{admisionRevisionTitulo.tipoArrendamiento}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.notificacionArrendatarios'),
				bind : {
					store : '{comboSiNoDict}',
					value : '{admisionRevisionTitulo.notificarArrendatarios}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.expedienteAdministrativo'),
			items : [{
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoExpediente'),
				bind : {
					store : '{comboTipoExpediente}',
					value : '{admisionRevisionTitulo.tipoExpediente}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionEa'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionEa}'
				}
			}]

		}, {
			xtype : 'comboboxfieldbase',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.contingenciaRegistral'),
			items : [{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoIncidenciaRegistral'),
				bind : {
					store : '{comboTipoIncidenciaRegistral}',
					value : '{admisionRevisionTitulo.tipoIncidenciaRegistral}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionCr'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionCr}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem.i18n('title.admision.revisionTitulo.ocupacionLegal'),
			items : [{
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoOcupacion'),
				bind : {
					store : '{comboTipoOcupacionLegal}',
					value : '{admisionRevisionTitulo.tipoOcupacionLegal}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem.i18n('title.admision.revisionTitulo.ilocalizadas'),
			items : [{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoIncidenciaIloc'),
				bind : {
					value : '{admisionRevisionTitulo.tipoIncidenciaIloc}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionIl'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionIl}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem.i18n('title.admision.revisionTitulo.deterioroGrave'),
			items : [{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.detalleDeterioro'),
				bind : {
					value : '{admisionRevisionTitulo.deterioroGrave}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem.i18n('title.admision.revisionTitulo.otros'),
			items : [{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoIncidenciaOtros'),
				bind : {
					value : '{admisionRevisionTitulo.tipoIncidenciaOtros}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionOtros'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionOt}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem.i18n('title.admision.revisionTitulo.agenda'),
			items : [{
						xtype : 'agendaRevisionTituloGrid'
					}]
		}];

		me.callParent();
	},

	funcionRecargar : function() {
		var me = this;
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
					grid.getStore().load();
				});
	}
});