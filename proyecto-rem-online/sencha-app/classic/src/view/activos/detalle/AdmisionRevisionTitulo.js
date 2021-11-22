Ext.define('HreRem.view.activos.detalle.AdmisionRevisionTitulo', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'admisionrevisiontitulo',
	cls : 'panel-base shadow-panel',
	reference : 'admisionrevisiontitulo',
	controller : 'admisionrevisiontitulo',
	refreshAfterSave : true,
	viewModel : {
		type : 'admisionRevisionTitulo'
	},
	scrollable : 'y',
	recordName: 'admisionRevisionTitulo',
	recordClass:'HreRem.model.AdmisionRevisionTitulo',
	requires : ['HreRem.model.AdmisionRevisionTitulo', 'HreRem.view.activos.detalle.ObservacionesActivo'],
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
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tituloPropiedad'),
				bind : {
					store : '{storeTituloOrigenActivo}',
					value : '{admisionRevisionTitulo.tipoTituloCodigo}',
					rawValue: '{admisionRevisionTitulo.tipoTituloDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.subtipoTitulo'),
				bind : {
					store : '{comboSubtipoTitulo}',
					value : '{admisionRevisionTitulo.subtipoTituloCodigo}',
					rawValue : '{admisionRevisionTitulo.subtipoTituloDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.ratificacion'),
				bind : {
					store : '{comboSiNoNoAplica}',
					value : '{admisionRevisionTitulo.ratificacion}'
				}
			},
			{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tituloPropiedadEntrada'),
				readOnly: true,
				bind : {
					value : '{admisionRevisionTitulo.tipoTituloActivoRef}'
				}				
			},
			{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.subtipoTituloEntrada'),
				readOnly: true,
				bind : { 
					value : '{admisionRevisionTitulo.subtipoTituloActivoRef}'				
				}
			},
			{
				xtype : 'comboboxfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.instanciaLibertadArrendaticia'),
				bind : {
					store : '{comboSiNoNoAplica}',
					value : '{admisionRevisionTitulo.instLibArrendataria}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionInicialInscripcion'),
				bind : {
					store : '{comboSituacionInicialInscripcion}',
					value : '{admisionRevisionTitulo.situacionInicialInscripcion}',
					rawValue : '{admisionRevisionTitulo.situacionInicialInscripcionDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionPosesoriaInicial'),
				bind : {
					store : '{comboSituacionPosesoriaInicial}',
					value : '{admisionRevisionTitulo.posesoriaInicial}',
					rawValue : '{admisionRevisionTitulo.posesoriaInicialDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionInicialCargas'),
				bind : {
					store : '{comboSituacionInicialCargas}',
					value : '{admisionRevisionTitulo.situacionInicialCargas}',
					rawValue : '{admisionRevisionTitulo.situacionInicialCargasDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.situacionConstructivaRegistral'),
				bind : {
					store : '{comboSituacionConstructivaRegistral}',
					value : '{admisionRevisionTitulo.situacionConstructivaRegistral}',
					rawValue : '{admisionRevisionTitulo.situacionConstructivaRegistralDescripcion}'
				}
			},{
				xtype : 'numberfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.porcentajePropiedad'),
				bind : {
					value : '{admisionRevisionTitulo.porcentajePropiedad}'
				},
				minValue: 0,
		        maxValue: 100,
		        listeners: {
		            change: function(field, value) {
		            	if(Ext.isNumeric(value)){
		            		if(value >100){
		            			me.form.markInvalid();
		            			field.setValue(100);
		            		}else{
		            			field.setValue(value);
		            		}
		            	}else{
		            		me.form.markInvalid();
		            	}
		            }
		        }
			}, {
				xtype : 'comboboxfieldbasedd', 
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoDeTitularidad'),
				bind : {
					store : '{comboTipoTitularidad}',
					value : '{admisionRevisionTitulo.tipoTitularidad}',
					rawValue : '{admisionRevisionTitulo.tipoTitularidadDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.proteccionOficial'),
				bind : {
					store : '{comboProteccionOficial}',
					value : '{admisionRevisionTitulo.proteccionOficial}',
					rawValue : '{admisionRevisionTitulo.proteccionOficialDescripcion}'
				}
			}, {
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.observaciones'),
				bind : {
					value : '{admisionRevisionTitulo.observaciones}'
				}
			}
			]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.concursoAcreedores'),
			items : [{
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.autorizacionTransmision'),
				bind : {
					store : '{comboAutorizacionTransmision}',
					value : '{admisionRevisionTitulo.estadoAutorizaTransmision}',
					rawValue : '{admisionRevisionTitulo.estadoAutorizaTransmisionDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.anotacionConcurso'),
				bind : {
					store : '{comboAnotacionConcurso}',
					value : '{admisionRevisionTitulo.anotacionConcurso}',
					rawValue : '{admisionRevisionTitulo.anotacionConcursoDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionCa'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionCa}',
					rawValue : '{admisionRevisionTitulo.estadoGestionCaDescripcion}'
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
					},
					minValue: 0,
			        maxValue: 100,
			        listeners: {
			            change: function(field, value) {
			            	if(Ext.isNumeric(value)){
			            		if(value >100){
			            			me.form.markInvalid();
			            			field.setValue(100);
			            		}else{
			            			field.setValue(value);
			            		}
			            		
			            	}else{
			            		me.form.markInvalid();
			            	}
			            }
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
					},
					minValue: 0,
			        maxValue: 100,
			        listeners: {
			            change: function(field, value) {
			            	if(Ext.isNumeric(value)){
			            		if(value >100){
			            			me.form.markInvalid();
			            			field.setValue(100);
			            		}else{
			            			field.setValue(value);
			            		}
			            	}else{
			            		me.form.markInvalid();
			            	}
			            }
			        }
				}, {
					xtype : 'comboboxfieldbasedd',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.certificadoFinObra'),
					bind : {
						store: '{comboLicenciaPrimeraOcupacion}',
						value : '{admisionRevisionTitulo.estadoCertificadoFinObra}',
						rawValue : '{admisionRevisionTitulo.estadoCertificadoFinObraDescripcion}'
					}
				}, {
					xtype : 'comboboxfieldbasedd',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.actaFinObraObraNuevaTerminada'),
					bind : {
						store: '{comboLicenciaPrimeraOcupacion}',
						value : '{admisionRevisionTitulo.estadoAfoActaFinObra}',
						rawValue : '{admisionRevisionTitulo.estadoAfoActaFinObraDescripcion}'
					}
				}, {
					xtype : 'comboboxfieldbasedd',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.licenciaPrimeraOcupacion'),
					bind : {
						store : '{comboLicenciaPrimeraOcupacion}',
						value : '{admisionRevisionTitulo.licenciaPrimeraOcupacion}',
						rawValue : '{admisionRevisionTitulo.licenciaPrimeraOcupacionDescripcion}'
					}
				}, {
					xtype : 'comboboxfieldbasedd',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.boletines'),
					bind : {
						store : '{comboBoletines}',
						value : '{admisionRevisionTitulo.boletines}',
						rawValue : '{admisionRevisionTitulo.boletinesDescripcion}'
					}
				}, {
					xtype : 'comboboxfieldbasedd',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.seguroDecenal'),
					bind : {
						store : '{comboSeguroDecenal}',
						value : '{admisionRevisionTitulo.seguroDecenal}',
						rawValue : '{admisionRevisionTitulo.seguroDecenalDescripcion}'
					}
				}, {
					xtype : 'comboboxfieldbasedd',
					fieldLabel : HreRem
							.i18n('fieldlabel.admision.revisionTitulo.cedulaHabitabilidad'),
					bind : {
						store : '{comboCedulaHabitabilidad}',
						value : '{admisionRevisionTitulo.cedulaHabitabilidad}',
						rawValue : '{admisionRevisionTitulo.cedulaHabitabilidadDescripcion}'
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
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoArrendamiento'),
				bind : {
					store : '{comboTipoArrendamiento}',
					value : '{admisionRevisionTitulo.tipoArrendamiento}',
					rawValue : '{admisionRevisionTitulo.tipoArrendamientoDescripcion}'
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
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoExpediente'),
				bind : {
					store : '{comboTipoExpediente}',
					value : '{admisionRevisionTitulo.tipoExpediente}',
					rawValue : '{admisionRevisionTitulo.tipoExpedienteDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionEa'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionEa}',
					rawValue : '{admisionRevisionTitulo.estadoGestionEaDescripcion}'
				}
			}]

		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem
					.i18n('title.admision.revisionTitulo.contingenciaRegistral'),
			items : [{
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoIncidenciaRegistral'),
				bind : {
					store : '{comboTipoIncidenciaRegistral}',
					value : '{admisionRevisionTitulo.tipoIncidenciaRegistral}',
					rawValue : '{admisionRevisionTitulo.tipoIncidenciaRegistralDescripcion}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionCr'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionCr}',
					rawValue : '{admisionRevisionTitulo.estadoGestionCrDescripcion}'
				}
			}]
		}, {
			xtype : 'fieldsettable',
			defaultType : 'textfieldbase',
			title : HreRem.i18n('title.admision.revisionTitulo.ocupacionLegal'),
			items : [{
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoOcupacion'),
				bind : {
					store : '{comboTipoOcupacionLegal}',
					value : '{admisionRevisionTitulo.tipoOcupacionLegal}',
					rawValue : '{admisionRevisionTitulo.tipoOcupacionLegalDescripcion}'
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
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionIl'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionIl}',
					rawValue : '{admisionRevisionTitulo.estadoGestionIlDescripcion}'
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
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.tipoIncidenciaOtros'),
				bind : {
					value : '{admisionRevisionTitulo.tipoIncidenciaOtros}'
				}
			}, {
				xtype : 'comboboxfieldbasedd',
				fieldLabel : HreRem
						.i18n('fieldlabel.admision.revisionTitulo.estadoGestionOtros'),
				bind : {
					store : '{comboEstadoGestion}',
					value : '{admisionRevisionTitulo.estadoGestionOt}',
					rawValue : '{admisionRevisionTitulo.estadoGestionOtDescripcion}'
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
		me.lookupController().cargarTabData(me);
		me.lookupController().cargarTabData(me.up('activosdetalle').down('datosbasicosactivo'));
		Ext.Array.each(me.query('grid'), function(grid) {
			grid.getStore().load();
		});
	}
});