Ext.define('HreRem.view.activos.detalle.ActivoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.activodetalle',

    requires: ['HreRem.view.activos.detalle.TituloInformacionRegistralActivo','HreRem.view.activos.detalle.AnyadirEntidadActivo' , 
    		'HreRem.view.activos.detalle.CargaDetalle','HreRem.view.activos.detalle.OpcionesPropagacionCambios', 
    		'HreRem.view.activos.detalle.VentanaEleccionTipoPublicacion','HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaDetalle', 
    		'HreRem.view.expedientes.ExpedienteDetalleController', 'HreRem.view.agrupaciones.detalle.DatosPublicacionAgrupacion', 
    		'HreRem.view.activos.detalle.InformeComercialActivo','HreRem.view.activos.detalle.AdministracionActivo',
    		'HreRem.model.ActivoTributos', 'HreRem.view.activos.detalle.AdjuntosPlusvalias','HreRem.view.activos.detalle.PlusvaliaActivo',
    		'HreRem.model.ComercialActivoModel', 'HreRem.view.activos.detalle.CrearEvolucionObservaciones', 'HreRem.view.activos.detalle.SuministrosActivo',
    		'HreRem.view.common.adjuntos.formularioTipoDocumento.WizardAdjuntarDocumentoModel','HreRem.view.common.WizardBase',
    		'HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard1','HreRem.view.common.adjuntos.formularioTipoDocumento.AdjuntarDocumentoWizard2',
    		'HreRem.view.trabajos.detalle.CrearPeticionTrabajo','HreRem.view.activos.detalle.SaneamientoActivoDetalle', 'HreRem.view.activos.detalle.TramitarOfertaActivoWindow',
			'HreRem.view.activos.detalle.OpcionesPropagacionCambiosDq'],

    control: {
         'documentosactivosimple gridBase': {
             abrirFormulario: 'abrirFormularioAdjuntarDocumentos',
             onClickRemove: 'borrarDocumentoAdjunto',
             download: 'downloadDocumentoAdjunto',
             afterupload: function(grid) {
             	grid.getStore().load();
             },
             afterdelete: function(grid) {
             	grid.getStore().load();
             }
         },

         'documentosactivopromocion gridBase': {
             abrirFormulario: 'abrirFormularioAdjuntarDocPromo',
             onClickRemove: 'borrarDocumentoAdjunto',
             download: 'downloadDocumentoAdjuntoPromocion',
             afterupload: function(grid) {
             	grid.getStore().load();
             }
         },

         'documentosactivoproyecto gridBase': {
             abrirFormulario: 'abrirFormularioAdjuntarDocProyecto',
             onClickRemove: 'borrarDocumentoAdjunto',
             download: 'downloadDocumentoAdjuntoProyecto',
             afterupload: function(grid) {
             	grid.getStore().load();
             },
             afterdelete: function(grid) {
              	grid.getStore().load();
              }
         },

		'documentosactivoofertacomercial textfieldbase' : {
			abrirFormulario : 'abrirFormularioAdjuntarDocumentoOferta',
			onClickRemove : 'borrarDocumentoAdjuntoOferta'
		},

		'documentostributosgrid gridBase' : {
			abrirFormulario : 'abrirVentanaAdjuntarDocTributo',
			download : 'descargarAdjuntoTributo',
			onClickRemove : 'eliminarAdjuntoTributo',
			afterupload : function(grid) {
				grid.getStore().load();
			}
		},

		'fotoswebactivo' : {
			updateOrdenFotos : 'updateOrdenFotosInterno'
		},
		
		'fotostecnicasactivo' : {
			updateOrdenFotos : 'updateOrdenFotosInterno'
		},

		'uxvalidargeolocalizacion' : {
			actualizarCoordenadas : 'actualizarCoordenadas'
		},

		'datoscomunidadactivo gridBase' : {
			abrirFormulario : 'abrirFormularioAnyadirEntidadActivo',
			afterupload : function(grid) {
				grid.getStore().load();
			},
			afterdelete : function(grid) {
				grid.getStore().load();
			}
		},

		'saneamientoactivo cargasactivogrid' : {
			abrirFormulario : 'abrirFormularioAnyadirCarga',
			onClickRemove : 'onClickRemoveCarga',
			onClickPropagation : 'onClickPropagation'
		},

		'datospublicacionactivo historicocondicioneslist' : {
			onClickPropagation : 'onClickPropagationHistoricoCondiciones'
		},

		'tituloinformacionregistralactivo calificacionnegativagrid' : {
			onClickPropagation : 'onClickPropagationCalificacionNegativa'
		},

		'informecomercialactivo historicomediadorgrid' : {
			onClickPropagation : 'onClickPropagationCalificacionNegativa'
		},

		'adjuntosplusvalias gridBase' : {
			abrirFormulario : 'abrirFormularioAdjuntarDocumentosPlusvalia',
			onClickRemove : 'borrarDocumentoAdjuntoPlusvalia',
			download : 'downloadDocumentoAdjuntoPlusvalia',
			afterupload : function(grid) {
				grid.getStore().load();
			},
			afterdelete : function(grid) {
				grid.getStore().load();
			}
		}
	},

	cargarTabData : function(form) {
		var me = this, model = null, models = null, nameModels = null, id = me
				.getViewModel().get("activo.id");
		form.mask(HreRem.i18n("msg.mask.loading"));
		if (!form.saveMultiple) {
			model = form.getModelInstance(), model.setId(id);
			if (Ext.isDefined(model.getProxy().getApi().read)) {
				// Si la API tiene metodo de lectura (read).
				model.load({
							success : function(record, b, c, d) {
								form.setBindRecord(record);
								form.unmask();
								if (Ext.isFunction(form.afterLoad)) {
									form.afterLoad();
								}
							},
							failure : function(operation) {
								form.up("tabpanel").unmask();
								me.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
							}
						});
			} else {
				// Si la API no contiene metodo de lectura (read).
				form.setBindRecord(model);
				form.unmask();
				if (Ext.isFunction(form.afterLoad)) {
					form.afterLoad();
				}
			}
		} else {
			models = form.getModelsInstance();
			me.cargarTabDataMultiple(form, 0, models, form.records);
		}
	},

	cargarTabDataMultiple : function(form, index, models, nameModels) {

		if ("tasacionBankia" != nameModels[index] && "tasacion" != nameModels[index]) {
			var me = this, id = me.getViewModel().get("activo.id");
		
			models[index].setId(id);

			if (Ext.isDefined(models[index].getProxy().getApi().read)) {
				// Si la API tiene metodo de lectura (read).
				models[index].load({
							success : function(record) {
								if (!Ext.isEmpty(me.getViewModel())) {
									me.getViewModel()
											.set(nameModels[index], record);
									index++;

									if (index < models.length) {
										me.cargarTabDataMultiple(form, index,
												models, nameModels);
									} else {
										form.unmask();
									}
								}
							},
							failure : function(a, operation) {
								form.unmask();
							}
						});
			} else {
				// Si la API no contiene metodo de lectura (read).
				me.getViewModel().set(nameModels[index], models[index]);
				index++;

				if (index < models.length) {
					me.cargarTabDataMultiple(form, index, models, nameModels);
				} else {
					form.unmask();
				}
			}
		} else {
			form.unmask();
		}
	},

	cargarTabDataPresupuestoGrafico : function(form) {
		var me = this, model = form.getModelInstance(), id = me.getViewModel()
				.get("activo.id");

		form.down('cartesian').store.proxy.setExtraParam('idActivo', form
						.lookupController().getViewModel().get("activo.id"));
		form.down('cartesian').store.load({

					callback : function(record) {
						form.setBindRecord(record[0]);
						form.up("tabpanel").unmask();
					}
				});

	},
	
	cargarTabDataCalidadDatoGrid: function (){
		var me = this;		

		var idActivo = me.getViewModel().get("activo.id");
		var faseDatosRegistrales = me.getView().down('[reference="calidaddatopublicacionactivoref"]').down('[reference="fasedatosregistrales"]');
		var faseDatosRegistro = me.getView().down('[reference="calidaddatopublicacionactivoref"]').down('[reference="fasedatosregistro"]');
		var faseCalidadDatDireccion = me.getView().down('[reference="calidaddatopublicacionactivoref"]').down('[reference="fasecalidaddatodireccion"]');
		var faseTresCalidadDato = me.getView().down('[reference="calidaddatopublicacionactivoref"]').down('[reference="fasetrescalidaddato"]');
		
		var cod01 = faseDatosRegistrales.codigoGrid;
		var cod02 = faseDatosRegistro.codigoGrid;
		var cod03 = faseTresCalidadDato.codigoGrid;
		var cod04 = faseCalidadDatDireccion.codigoGrid;
		
		var storefaseDatosRegistrales;
		var storefaseDatosRegistro;
		var storefaseTresCalidadDato;
		var storefaseCalidadDatDireccion;
		
		//DATOS REGISTRALES
		storefaseDatosRegistrales = Ext.create('Ext.data.Store',{
			model: 'HreRem.model.CalidadDatoFasesGridModel', 
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCalidadDelDatoFiltered', 
				extraParams: {id: idActivo} 
			},
			autoLoad: false,
			session: false		
			}			
		).load();
		
		storefaseDatosRegistrales.filterBy( 
			function (record, id) {
				return record.get('codigoGrid') == cod01;
			}
		);				
		faseDatosRegistrales.setStore(storefaseDatosRegistrales);
		faseDatosRegistrales.getStore().load();		
		//DATOS REGISTRO
		storefaseDatosRegistro = Ext.create('Ext.data.Store',{
			model: 'HreRem.model.CalidadDatoFasesGridModel', 
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCalidadDelDatoFiltered', 
				extraParams: {id: idActivo} 
			},
			autoLoad: false,
			session: false		
			}			
		).load();
		
		storefaseDatosRegistro.filterBy( 
			function (record, id) {
				return record.get('codigoGrid') == cod02;
			}
		);
		faseDatosRegistro.setStore(storefaseDatosRegistro);
		faseDatosRegistro.getStore().load();
		//DATOS FASE 3
		storefaseTresCalidadDato = Ext.create('Ext.data.Store',{
			model: 'HreRem.model.CalidadDatoFasesGridModel', 
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCalidadDelDatoFiltered', 
				extraParams: {id: idActivo} 
			},
			autoLoad: false,
			session: false		
			}			
		).load();
		storefaseTresCalidadDato.filterBy( 
			function (record, id) {
				return record.get('codigoGrid') == cod03;
			}
		);
		faseTresCalidadDato.setStore(storefaseTresCalidadDato);
		faseTresCalidadDato.getStore().load();
		//DATOS FASE 3 DIRECCION
		storefaseCalidadDatDireccion = Ext.create('Ext.data.Store',{
			model: 'HreRem.model.CalidadDatoFasesGridModel', 
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'activo/getCalidadDelDatoFiltered', 
				extraParams: {id: idActivo} 
			},
			autoLoad: false,
			session: false		
			}			
		).load();
		storefaseCalidadDatDireccion.filterBy( 
			function (record, id) {
				return record.get('codigoGrid') == cod04;
			}
		);
		faseCalidadDatDireccion.setStore(storefaseCalidadDatDireccion);
		faseCalidadDatDireccion.getStore().load();		
	},
	
	
	cargarTabDataCalidadDato: function (form) {
		var me = this,
		model = null,
		models = null,
		nameModels = null,
		id = me.getViewModel().get("activo.id");
		form.mask(HreRem.i18n("msg.mask.loading"));
		if(!form.saveMultiple) {
			model = form.getModelInstance(),
			model.setId(id);
			if(Ext.isDefined(model.getProxy().getApi().read)) {
				// Si la API tiene metodo de lectura (read).
				model.load({
				    success: function(record,b,c,d) {
				    	form.setBindRecord(record);			    	
				    	form.unmask();
				    	me.lookupReference('toolFieldFase0').setCollapsed(record.data.desplegable0Collapsed);
				    	me.lookupReference('toolFieldFase1').setCollapsed(record.data.desplegable1Collapsed);
				    	me.lookupReference('toolFieldFase2').setCollapsed(record.data.desplegable2Collapsed);
				    	if(Ext.isFunction(form.afterLoad)) {
				    		form.afterLoad();
				    	}
				    },
				    failure: function(operation) {		    	
				    	form.up("tabpanel").unmask();
				    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
				    }
				});
			} else {
				// Si la API no contiene metodo de lectura (read).
				form.setBindRecord(model);			    	
		    	form.unmask();
		    	if(Ext.isFunction(form.afterLoad)) {
		    		form.afterLoad();
		    	}
			}
		} else {
			models = form.getModelsInstance();
			me.cargarTabDataMultiple(form, 0, models, form.records);
		}
	},
	
	onListadoPropietariosDobleClick: function (grid, record) {
    	var me = this
    	
    	var activo = me.getViewModel().get('activo'),
 		idActivo= activo.get('id');
		var ventana = Ext.create("HreRem.view.activos.detalle.EditarPropietario", {	
			propietario: record, 
			activo: activo});
    	
		 grid.up('activosdetallemain').add(ventana);
		 ventana.show();
	},

	onListadoPropietariosDobleClick : function(grid, record) {
		var me = this

		var activo = me.getViewModel().get('activo'), idActivo = activo
				.get('id');
		var ventana = Ext.create(
				"HreRem.view.activos.detalle.EditarPropietario", {
					propietario : record,
					activo : activo
				});

		grid.up('activosdetallemain').add(ventana);
		ventana.show();
	},

	
	onTasacionListClick: function (grid, record) {
		var me = this,
		form = grid.up("form"),
		model = Ext.create('HreRem.model.ActivoTasacion'),
		idTasacion = record.get("id");
		
		var fieldset =  me.lookupReference('detalleTasacion');
		fieldset.mask(HreRem.i18n("msg.mask.loading"));

		model.setId(idTasacion);
		model.load({
					success : function(record) {
						me.getViewModel().set("tasacion", record);
						fieldset.unmask();
					}
				});
	},

	onSaveFormularioCompleto : function(btn, form, restringida) {
		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		// disableValidation: Atributo para indicar si el guardado del
		// formulario debe aplicar o no,
		// las validaciones.
		if (form.isFormValid() || form.disableValidation) {

			Ext.Array.each(form.query('component[isReadOnlyEdit]'), function(
							field, index) {
						field.fireEvent('update');
						field.fireEvent('save');
					});

			if (!Ext.isEmpty(btn)) {
				btn.hide();
				btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
				btn.up('tabbar').down('button[itemId=botoneditar]').show();

				if (Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
					me.getViewModel().set("editingFirstLevel", false);
				} else {
					me.getViewModel().set("editing", false);
				}
				me.getViewModel().notify();
			}

			// Obtener jsondata para guardar activo
			var tabData = me.createTabData(form);

			if (tabData.models != null) {
				if (tabData.models[0].name == "datosregistrales") {
					record = form.getBindRecord();
					var fechaInscripcionReg = record.get("fechaInscripcionReg");
					if ((typeof fechaInscripcionReg) == 'string') {
						var from = fechaInscripcionReg.split("/");
						fechaInscripcionReg = new Date(from[2], from[1] - 1,
								from[0])
					}
					if (fechaInscripcionReg != null) {
						// tabData.models[0].data.fechaInscripcionReg = new
						// Date(fechaInscripcionReg);
					}
				} else if (tabData.models[0].name == "informecomercial") {
					record = form.getBindRecord();
					if (record != null) {
						if (record.infoComercial != null) {
							tabData.models[0].data.valorEstimadoVenta = record.infoComercial.data.valorEstimadoVenta;
							tabData.models[0].data.valorEstimadoRenta = record.infoComercial.data.valorEstimadoRenta;
						}
					}
				} else if (tabData.models[0].name === "datosbasicos") {
					record = form.getBindRecord();
					if (record != null && record.data.cexperBbva != undefined) {
						tabData.models[0].data.cexperBbva = record.data.cexperBbva;
					}
					if (record != null && record.data.uicBbva != undefined) {
						tabData.models[0].data.uicBbva = record.data.uicBbva;
					}
				}
			}

			var idActivo;

			if (tabData.models[0].name == "datospublicacion"
					|| tabData.models[0].name == "activocargas"
					|| tabData.models[0].name == "activocondicionantesdisponibilidad"
					|| tabData.models[0].name == "activotrabajo"
					|| tabData.models[0].name == "activotrabajosubida"
					|| tabData.models[0].name == "activotramite"
					|| tabData.models[0].name == "fasepublicacionactivo") {
				idActivo = tabData.models[0].data.idActivo;
			} else {
				idActivo = tabData.models[0].data.id;
			}

			me.checkActivosToPropagate(idActivo, form, tabData, restringida);

		} else {
			me.getView().unmask();
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));

		}

	},

	onSaveFormularioCompletoDistribuciones : function(btn, form) {
		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		// disableValidation: Atributo para indicar si el guardado del
		// formulario debe aplicar o no,
		// las validaciones.
		if (form.isFormValid() || form.disableValidation) {

			Ext.Array.each(form.query('field[isReadOnlyEdit]'), function(field,
							index) {
						field.fireEvent('update');
						field.fireEvent('save');
					});

			// Obtener jsondata para guardar activo
			var numPlanta = me.lookupReference('comboNumeroPlantas').getValue();
			var tipoHabitaculoCodigo = me
					.lookupReference('comboTipoHabitaculo').getValue();
			var superficie = me.lookupReference('superficie').getValue();
			var cantidad = me.lookupReference('cantidad').getValue();
			var idActivo = me.getViewModel().get("activo.id");

			var jsonData = {
				idEntidad : idActivo,
				numPlanta : numPlanta,
				tipoHabitaculoCodigo : tipoHabitaculoCodigo,
				superficie : superficie,
				cantidad : cantidad
			};

			var activosPropagables = me.getViewModel()
					.get("activo.activosPropagables")
					|| [];
			var tabPropagableData = null;

			if (activosPropagables.length > 0) {

				tabPropagableData = me.createFormPropagableData(form, tabData);
				if (!Ext.isEmpty(tabPropagableData)) {
					// sacamos el activo actual del listado
					var activo = activosPropagables.splice(activosPropagables
									.findIndex(function(activo) {
												return activo.activoId == me
														.getViewModel()
														.get("activo.id")
											}), 1)[0];

					// Abrimos la ventana de selección de activos
					var ventanaOpcionesPropagacionCambios = Ext
							.create(
									"HreRem.view.activos.detalle.OpcionesPropagacionCambios",
									{
										form : form,
										activoActual : activo,
										activos : activosPropagables,
										tabData : tabData,
										propagableData : tabPropagableData
									}).show();
					me.getView().add(ventanaOpcionesPropagacionCambios);
					me.getView().unmask();
					return false;
				}
			}

			var successFn = function(response, eOpts) {
				var window = me.getView();
				if (Ext.decode(response.responseText).success == "false") {
					me
							.fireEvent(
									"errorToast",
									HreRem
											.i18n("msg.error.anyadir.distribucion.vivienda"));
				} else {
					me.refrescarActivo(true);
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				}
				window.close();
			}
			me.saveDistribucion(jsonData, successFn);

		} else {
			me.getView().unmask();
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));

		}

	},

	saveMultipleRecords : function(contador, records, form) {
		var me = this;

		if (records[contador] != null
				&& (Ext.isDefined(records[contador].getProxy().getApi().create) || Ext
						.isDefined(records[contador].getProxy().getApi().update))) {
			// Si la API tiene metodo de escritura (create or update).

			records[contador].save({
				success : function(a, operation, c) {
					contador++;

					if (contador < records.length) {
						me.saveMultipleRecords(contador, records, form);
					} else {
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
						me.getView().unmask();
						me.refrescarActivo(form.refreshAfterSave);
						me.getView().fireEvent("refreshComponentOnActivate",
								"container[reference=tabBuscadorActivos]");
					}
				},
				failure : function(a, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.getView().unmask();
				}
			});
		} else {
			// Si la API no contiene metodo de escritura (create or update).
			contador++;

			if (contador < records.length) {
				me.saveMultipleRecords(contador, records, form);
			} else {
				me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				me.getView().unmask();
				me.refrescarActivo(form.refreshAfterSave);
				me.getView().fireEvent("refreshComponentOnActivate",
						"container[reference=tabBuscadorActivos]");
			}
		}
	},

	onClickBotonFavoritos : function(btn) {

		var me = this, textoFavorito = "Activo "
				+ me.getViewModel().get("activo.numActivo");
		btn.updateFavorito(textoFavorito);

	},

	onNotificacionClick : function(btn) {
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		me.getView().fireEvent('crearnotificacion', {
					idActivo : idActivo
				});
	},

	onTramiteClick : function(btn) {

		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var url = $AC.getRemoteUrl('activo/crearTramite');

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		Ext.Ajax.request({
					url : url,
					params : {
						idActivo : idActivo
					},

					success : function(response, opts) {
						me.getViewModel().data.storeTramites.load();
						if (Ext.decode(response.responseText).errorCreacion)
							me
									.fireEvent(
											"errorToast",
											Ext.decode(response.responseText).errorCreacion);
						else
							me.fireEvent("infoToast", HreRem
											.i18n("msg.operacion.ok"));
					},
					failure : function(record, operation) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
					},
					callback : function(record, operation) {
						me.getView().unmask();
					}
				});
	},

	onTramiteAprobacionInformeComercialClick : function(btn) {

		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var url = $AC
				.getRemoteUrl('activo/crearTramiteAprobacionInformeComercial');

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		Ext.Ajax.request({
					url : url,
					params : {
						idActivo : idActivo
					},

					success : function(response, opts) {
						me.getViewModel().data.storeTramites.load();
						if (Ext.decode(response.responseText).errorCreacion)
							me
									.fireEvent(
											"errorToast",
											Ext.decode(response.responseText).errorCreacion);
						else
							me.fireEvent("infoToast", HreRem
											.i18n("msg.operacion.ok"));
					},
					failure : function(record, operation) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
					},
					callback : function(record, operation) {
						me.getView().unmask();
						me.onClickBotonRefrescar();
					}
				});
	},
	onClickEstadoAdmision : function(btn) {
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var codSubcartera = me.getViewModel().get("activo.subcarteraCodigo");
		var codCartera = me.getViewModel()
				.get("activo.entidadPropietariaCodigo");
		var codEstadoAdmision = me.getViewModel()
				.get("activo.estadoAdmisionCodigo");
		var codSubestadoAdmision = me.getViewModel()
				.get("activo.subestadoAdmisionCodigo");
		var estadoAdmisionDesc = me.getViewModel()
				.get("activo.estadoAdmisionDesc");
		var subestadoAdmisionDesc = me.getViewModel()
				.get("activo.subestadoAdmisionDesc");

		me.getView().fireEvent('openModalWindow',
				"HreRem.view.activos.detalle.CrearEstadoAdmision", {
					idActivo : idActivo,
					codCartera : codCartera,
					codEstadoAdmision : codEstadoAdmision,
					codSubestadoAdmision : codSubestadoAdmision,
					estadoAdmisionDesc : estadoAdmisionDesc,
					subestadoAdmisionDesc : subestadoAdmisionDesc
				});

	},

	setSubestadoAdmisionAllowBlank : function(btn) {

		var me = this;

		btn.lookupController().onChangeChainedCombo(btn);
		var comboSubestadoAdmision = me
				.lookupReference('subestadoAdmisionNuevo');
		var allowblank = btn.getValue() != "PSR";
		comboSubestadoAdmision.setAllowBlank(allowblank);
		comboSubestadoAdmision.setDisabled(allowblank);
	},

	onClickCrearEstadoAdmision : function(btn) {

		var me = this;

		var correcto = true;
    	var url =  $AC.getRemoteUrl('activo/crearEstadoAdmision');
    	var comboEstadoAdmision = me.lookupReference('estadoAdmisionNuevo');
    	var comboSubestadoAdmision = me.lookupReference('subestadoAdmisionNuevo');
    	var comboEstadoAdmisionActual = me.lookupReference('estadoAdmisionRef');
    	var comboSubEstadoAdmisionActual = me.lookupReference('subestadoAdmisionRef');
    	var observacionesTextLabel = me.lookupReference('observacionesEstadoAdmisionNuevo');
    	var idActivo = btn.up('crearestadoadmisionwindow').idActivo;
    	var form = btn.up('crearestadoadmisionwindow').lookupReference('formEstadoAdmision').getForm(); // btn.up('formBase')
    	
    	if(comboEstadoAdmision.getSelection() != null) {
	    	if(comboEstadoAdmision.getSelection().data != null)
		    	if (comboEstadoAdmisionActual.getValue() == comboEstadoAdmision.getSelection().data.descripcion) 
		    		if(comboSubestadoAdmision.getSelection().data != null)
			    		if(comboSubEstadoAdmisionActual.getValue() == comboSubestadoAdmision.getSelection().data.descripcion){
			    			me.fireEvent("errorToast", HreRem.i18n("msg.form.info.repetida"));
			    			correcto = false;
			    		} 
    		
    	} else {
    		correcto = false;
    		me.fireEvent("errorToast", HreRem.i18n("msg.form.info.repetida"));
    	}
	    	
    	if(correcto) {
    		if(form.isValid()){
		    		Ext.Ajax.request({
		    		
		    	     url: url,
		    	     params: {activoId: idActivo, 
		    	     		  codEstadoAdmision: comboEstadoAdmision.getValue(),
		    	     		  codSubestadoAdmision: comboSubestadoAdmision.getValue(),
		    	     		  observaciones: observacionesTextLabel.getValue()
		    	     		  },
		
		    	     success: function(response, opts) {
		    	     	
		    	     	me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], idActivo);
						//btn.up('crearestadoadmisionwindow').close();
		    	     	me.hideWindowCrearActivoAdmision(btn);
		    	     	//me.destroyWindowCrearActivoAdmision(btn);
		    	     },
		
		    	     failure: function (a, operation, context) {
		           	  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		           }
		           
		    	 });
    	 
    	}
    	}
    	
    	
    },


    destroyWindowCrearActivoAdmision: function (btn){
    	var me = this;
    	btn.up('window').destroy();
    },
    
    hideWindowCrearActivoAdmision: function(btn) {
    	var me = this;
    	btn.up('window').hide();   	
    },
    
    onClickCrearTrabajo: function (btn) {
		var me = this;
		
    	me.getView().mask(HreRem.i18n("msg.mask.loading"));	
    	
    	var idActivo = me.getViewModel().get("activo.id");
    	var codSubcartera = me.getViewModel().get("activo.subcarteraCodigo");
    	var codCartera = me.getViewModel().get("activo.entidadPropietariaCodigo");
    	var gestorActivo = $AU.getUser().userName;
    	
    	var ventana = Ext.create("HreRem.view.trabajos.detalle.CrearPeticionTrabajo", {
			idActivo: idActivo, 
			codCartera: codCartera, 
			codSubcartera: codSubcartera, 
			logadoGestorMantenimiento: true,
			idAgrupacion: null,
			idGestor: null, 
			gestorActivo: gestorActivo,
			trabajoDesdeActivo: true});
		btn.lookupViewModel().getView().add(ventana);
		ventana.show();
		me.getView().unmask();

    },

    
    onAnyadirPropietarioClick: function (btn) {    	
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
		me.getView().fireEvent('openModalWindow',"HreRem.view.activos.detalle.AnyadirPropietario");	
    },
        
    onEliminarPropietarioClick: function (btn) {
    	
    	var me = this;
    	var grid = btn.up('fieldsettable').down('#listadoPropietarios');
    
        Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			            var sm = grid.getSelectionModel();
			            sm.getSelection()[0].erase();
			            if (grid.getStore().getCount() > 0) {
			                sm.select(0);
			            }
			        }
			   }
		});
  	    	
    },


	destroyWindowCrearActivoAdmision : function(btn) {
		var me = this;
		btn.up('window').destroy();
	},

	hideWindowCrearActivoAdmision : function(btn) {
		var me = this;
		btn.up('window').hide();
	},

	onClickCrearTrabajo : function(btn) {
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var codSubcartera = me.getViewModel().get("activo.subcarteraCodigo");
		var codCartera = me.getViewModel()
				.get("activo.entidadPropietariaCodigo");
		me.getView().fireEvent('openModalWindow',
				"HreRem.view.trabajos.detalle.CrearTrabajo", {
					idActivo : idActivo,
					idAgrupacion : null,
					codCartera : codCartera,
					codSubcartera : codSubcartera,
					logadoGestorMantenimiento : true
				});
	},

	onAnyadirPropietarioClick : function(btn) {
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		me.getView().fireEvent('openModalWindow',
				"HreRem.view.activos.detalle.AnyadirPropietario");
	},

	onEliminarPropietarioClick : function(btn) {

		var me = this;
		var grid = btn.up('fieldsettable').down('#listadoPropietarios');

		Ext.Msg.show({
					title : HreRem.i18n('title.confirmar.eliminacion'),
					msg : HreRem.i18n('msg.desea.eliminar'),
					buttons : Ext.MessageBox.YESNO,
					fn : function(buttonId) {
						if (buttonId == 'yes') {
							var sm = grid.getSelectionModel();
							sm.getSelection()[0].erase();
							if (grid.getStore().getCount() > 0) {
								sm.select(0);
							}
						}
					}
				});

	},

	onChangeChainedCombo : function(combo) {
		var me = this, chainedCombo = me
				.lookupReference(combo.chainedReference);
		me.getViewModel().notify();
		if (!Ext.isEmpty(chainedCombo.store)
				&& !Ext.isEmpty(chainedCombo.getValue())) {

			chainedCombo.clearValue();
		}

		if (combo.chainedStore == 'storeSubfasesDePublicacionFiltered') {
			var storeSubfaseFiltered = me.getViewModel()
					.get("storeSubfasesDePublicacionFiltered");
			chainedCombo.bindStore(storeSubfaseFiltered);
			storeSubfaseFiltered.getProxy().setExtraParams({
						'codFase' : combo.getValue()
					});

		} else if (combo.chainedStore == 'comboSubestadoAdmisionNuevoFiltrado') {
			var storeSubestadoAdmisionFiltered = me.getViewModel().data.comboSubestadoAdmisionNuevoFiltrado;
			chainedCombo.bindStore(storeSubestadoAdmisionFiltered);
			storeSubestadoAdmisionFiltered.getProxy().setExtraParams({
						'codEstadoAdmisionNuevo' : combo.getValue()
					});
		}
		chainedCombo.getStore().removeAll();
		if(chainedCombo.getXType() != 'comboboxfieldbasedd'){
			chainedCombo.getStore().load({
				callback : function(records, operation, success) {
					if (!Ext.isEmpty(records) && records.length > 0) {
						if (chainedCombo.selectFirst == true) {
							chainedCombo.setSelection(1);
						};
						chainedCombo.setDisabled(false);
					} else {
						chainedCombo.setDisabled(true);
					}
				}
			});
		}
		if (me.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
			if (!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
    },

    onHanCambiadoSelect: function(combo, value) {
  
    	var me = this,
    	disabled = value == 0,
    	poblacionAnterior = me.lookupReference('poblacionAnterior'),
    	numRegistroAnterior = me.lookupReference('numRegistroAnterior'),
    	numFincaAnterior = me.lookupReference('numFincaAnterior');

    	poblacionAnterior.setDisabled(disabled);
    	numRegistroAnterior.setDisabled(disabled);
    	numFincaAnterior.setDisabled(disabled);
    	
    	poblacionAnterior.allowBlank = disabled;
    	numRegistroAnterior.allowBlank = disabled;
    	numFincaAnterior.allowBlank = disabled;
    	
    	if(disabled) {
    		poblacionAnterior.setValue("");
    		numRegistroAnterior.setValue("");
    		numFincaAnterior.setValue("");
    	}
    	
    	poblacionAnterior.validate();
    	numRegistroAnterior.validate();
    	numFincaAnterior.validate();

    },
    

    onDivisionHorizontalSelect: function(combo, value) {
    	
    	var me = this,
    	disabled = value == 0;
	    
	    me.lookupReference('estadoDivHorizontal').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontalNoInscrita').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontal').allowBlank =disabled;
    	me.lookupReference('estadoDivHorizontalNoInscrita').allowBlank=disabled;

    	if(disabled) {
    		me.lookupReference('estadoDivHorizontal').setValue("");
    		me.lookupReference('estadoDivHorizontalNoInscrita').setValue("");
    	}
    },
    
    onComboTramitacionTituloAdicional: function(combo, value){
    	
    	var me = this,
    	disabled = value == 0;
    	
    	var fieldsettableTituloAdicional =me.lookupReference('fieldsettableTituloAdicional');
    	var tipoTituloAdicional = me.lookupReference('tipoTituloAdicional');
    	var situacionTituloAdicional = me.lookupReference('situacionTituloAdicional');
    	var fechaInscripcionRegistroAdicional = me.lookupReference('fechaInscripcionRegistroAdicional');
    	var entregaTituloGestoriaAdicional = me.lookupReference('entregaTituloGestoriaAdicional');
    	var fechaRetiradaDefinitivaRegistroAdicional = me.lookupReference('fechaRetiradaDefinitivaRegistroAdicional');
    	var fechaPresentacionHaciendaAdicional = me.lookupReference('fechaPresentacionHaciendaAdicional');
    	var fieldlabelFechaNotaSimpleAdicional = me.lookupReference('fieldlabelFechaNotaSimpleAdicional');
    	
    	
    	fieldsettableTituloAdicional.setDisabled(disabled);
    	tipoTituloAdicional.setDisabled(disabled);
    	situacionTituloAdicional.setDisabled(disabled);
    	fechaInscripcionRegistroAdicional.setDisabled(disabled);
    	entregaTituloGestoriaAdicional.setDisabled(disabled);
    	fechaRetiradaDefinitivaRegistroAdicional.setDisabled(disabled);
    	fechaPresentacionHaciendaAdicional.setDisabled(disabled);
    	fieldlabelFechaNotaSimpleAdicional.setDisabled(disabled);
    	
    	    	
    	if(disabled){
    		fieldsettableTituloAdicional.hide();
    	}else{
    		fieldsettableTituloAdicional.show();
    	}
    	
    	
    },
    
    onComunidadNoConstituida: function(combo, value) {
    	var me = this,
    	disabled = value == 0 || Ext.isEmpty(value);
    	
    	me.lookupReference('nombreComunidadPropietarios').allowBlank =disabled;
    	me.lookupReference('nifComunidadPropietarios').allowBlank =disabled;
    	
    },
    
    onChangeBloqueo: function (field, newValue, oldValue) {
    	var me = this;
    	
    	if (newValue > 0) {
    		me.lookupReference('bloqueoPrecioFechaIni').setValue($AC.getCurrentDate());
    	} else {
    		me.lookupReference('bloqueoPrecioFechaIni').setValue("");
    		me.lookupReference('gestorBloqueoPrecio').setValue("");
    	}
    },
    
    onDivisionHorizontalAdmisionSelect: function(combo, value) {
    	
    	var me = this,
    	disabled = value == 0;
    	
    	me.lookupReference('estadoDivHorizontalAdmision').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontalAdmision').allowBlank =disabled;
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank=disabled;

    	if(disabled) {
    		me.lookupReference('estadoDivHorizontalAdmision').setValue("");
    		me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setValue("");
    	}
    },
    
    onEstadoDivHorizontalSelect: function(combo, value) {
    	
    	var me = this,
    	disabled = (value == 1 || Ext.isEmpty(value)) ;
    	
    	me.lookupReference('estadoDivHorizontalNoInscrita').allowBlank = disabled;
    	me.lookupReference('estadoDivHorizontalNoInscrita').setDisabled(disabled);
    	
    	if(disabled) {    		
    		me.lookupReference('estadoDivHorizontalNoInscrita').setValue("");
    		me.lookupReference('estadoDivHorizontalNoInscrita').allowBlank = true;
    	}
    	
    }, 
    
    onEstadoDivHorizontalAdmisionSelect: function(combo, value) {
    	
    	var me = this;
		disabled = (value == 1 || Ext.isEmpty(value)) ;
		
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank = disabled
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setDisabled(disabled);

    	if(disabled) {
			me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setValue("");
			me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank = true;    		
    	}
    	
    },  

	destroyWindowCrearActivoAdmision : function(btn) {
		var me = this;
		btn.up('window').destroy();
	},

	hideWindowCrearActivoAdmision : function(btn) {
		var me = this;
		btn.up('window').hide();
	},

	onClickCrearTrabajo: function (btn) {
		 var me = this;
		 	 	
	 	me.getView().mask(HreRem.i18n("msg.mask.loading"));	
	 	
	 	var idActivo = me.getViewModel().get("activo.id");
	 	var codSubcartera = me.getViewModel().get("activo.subcarteraCodigo");
	 	var codCartera = me.getViewModel().get("activo.entidadPropietariaCodigo");
	 	var gestorActivo = $AU.getUser().userName;
		var checkGestion = me.getViewModel().get("activo.aplicaGestion");
		
		if (checkGestion){
			var ventana = Ext.create("HreRem.view.trabajos.detalle.CrearPeticionTrabajo", {
			idActivo: idActivo, 
			codCartera: codCartera, 
			codSubcartera: codSubcartera, 
			logadoGestorMantenimiento: true,
			idAgrupacion: null,
			idGestor: null, 
			gestorActivo: gestorActivo,
			trabajoDesdeActivo: true});
		btn.lookupViewModel().getView().add(ventana);
		ventana.show();
		me.getView().unmask();
		
		}else{
			me.getView().unmask();
			me.fireEvent("errorToast",HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.mensaje"))
		}
	 },

	onAnyadirPropietarioClick : function(btn) {
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		me.getView().fireEvent('openModalWindow',
				"HreRem.view.activos.detalle.AnyadirPropietario");
	},
    
    onChangeProvincia: function(combo, value, oldValue, eOpts){
    	var me = this;
    	me.getViewModel().get('activo').set('asignaGestPorCambioDeProv', false);
    	if(value != oldValue){
    		var me = this;
    		me.getViewModel().get('activo').set('asignaGestPorCambioDeProv', true);
    	}
    	
    },
    
    cargaGestores : function(grid){
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
    	grid.getStore().getProxy().setExtraParams({'idActivo':idActivo});    
    	grid.getStore().load();
    },

	onChangeTipoGestor: function(cmb){
		var me = this;
		me.lookupReference('usuarioGestor').setDisabled(false);
		var idTipoGestor = cmb.getValue();
		me.lookupReference('usuarioGestor').clearValue();
		
		me.lookupReference('usuarioGestor').getStore().getProxy().setExtraParams({'idTipoGestor':idTipoGestor});    
		me.lookupReference('usuarioGestor').getStore().load();
	},

	

	onChangeTipoTitulo : function(btn, value, oValue, eOps) {
		var me = this;
		me.lookupReference('judicial').setVisible(value == '01');
		me.lookupReference('judicial').setDisabled(value != '01');
		me.lookupReference('noJudicial').setVisible(value == '02');
		me.lookupReference('noJudicial').setDisabled(value != '02');
		me.lookupReference('pdv').setVisible(value == '03');
		me.lookupReference('pdv').setDisabled(value != '03');
		if (value == '05' && oValue == null) {
			me.lookupReference('comboTipoTituloRef').readOnly = true;
			var tipoTitulo = me.getViewModel()
					.get('datosRegistrales.tipoTituloActivoMatriz');
			if (tipoTitulo === '01') {
				me.lookupReference('judicial').setVisible(true);
				me.lookupReference('judicial').setDisabled(false);
				me.lookupReference('noJudicial').setVisible(false);
				me.lookupReference('noJudicial').setDisabled(true);
			} else if (tipoTitulo === '02') {
				me.lookupReference('judicial').setVisible(false);
				me.lookupReference('judicial').setDisabled(true);
				me.lookupReference('noJudicial').setVisible(true);
				me.lookupReference('noJudicial').setDisabled(false);

			}
		}

	},

	onChangeTipoTituloAdmision : function(btn, value) {

		var me = this;

		me.lookupReference('judicialAdmision').setVisible(value == '01');
		me.lookupReference('judicialAdmision').setDisabled(value != '01');
		me.lookupReference('noJudicialAdmision').setVisible(value == '02');
		me.lookupReference('noJudicialAdmision').setDisabled(value != '02');
		me.lookupReference('pdvAdmision').setVisible(value == '03');
		me.lookupReference('pdvAdmision').setDisabled(value != '03');

	},

	onChangeSujetoAExpediente : function(btn, value) {

		var me = this;

		if (value == '0') {
			me.lookupReference('expropiacionForzosa').setVisible(false);
		} else {
			me.lookupReference('expropiacionForzosa').setVisible(true);
		}

	},

	onAgregarGestoresClick : function(btn) {

		var me = this;

		btn.setDisabled(true);

		var url = $AC.getRemoteUrl('activo/insertarGestorAdicional');
		var parametros = btn.up("combogestores").getValues();
		parametros.idActivo = me.getViewModel().get("activo.id");

		Ext.Ajax.request({

					url : url,
					params : parametros,

					success : function(response, opts) {

						btn.up("gestoresactivo")
								.down("[reference=listadoGestores]").getStore()
								.load();
						btn.up("gestoresactivo").down("form").reset();

						if (Ext.decode(response.responseText).success == "false") {
							me
									.fireEvent(
											"errorToast",
											HreRem
													.i18n(Ext
															.decode(response.responseText).errorCode));
							// me.fireEvent("errorToast",
							// HreRem.i18n("msg.operacion.ko"));
						}
					},
					failure : function(a, operation, context) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
					}
				});
	},

	onChkbxMuestraHistorico : function(chkbx, checked) {

		var me = this;

		var grid = chkbx.up('gestoresactivo').down("gestoreslist");
		var store = me.getViewModel().get("storeGestoresActivos");

		var prox = store.getProxy();
		var _idActivo = prox.getExtraParams().idActivo;
		var _incluirGestoresInactivos = checked;

		prox.setExtraParams({
					"idActivo" : _idActivo,
					"incluirGestoresInactivos" : _incluirGestoresInactivos
				});
		store.load();

	},

	onClickBotonEditar : function(btn) {
		var me = this;
		if (btn.up('tabpanel').getActiveTab().xtype === 'comercialactivo') {
			Ext.Array.each(btn.up('tabpanel').getActiveTab()
							.query(' > container > component[isReadOnlyEdit]'),
					function(field, index) {
						field.fireEvent('edit');
					});
		} else {
			Ext.Array.each(btn.up('tabpanel').getActiveTab()
							.query('component[isReadOnlyEdit]'), function(
							field, index) {
						field.fireEvent('edit');
					});
		}

		btn.up('tabpanel').getActiveTab().query('component[isReadOnlyEdit]')[0]
				.focus();
		if (Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
			me.getViewModel().set("editingFirstLevel", true);
		} else {
			me.getViewModel().set("editing", true);
		}
		me.getViewModel().notify();
		if ("admisionrevisiontitulo" === btn.up("tabpanel").getActiveTab().xtype) {
			// Solucion al bug para mostrar los botones la segunda vez que se
			// hace click en el boton editar
			var buttons = btn.up("tabbar").items.items;
			for (var i = 0; i < buttons.length; i++) {
				button = buttons[i];
				if ("botoncancelar" === button.itemId
						|| "botonguardar" === button.itemId) {
					button.show();
				}
			}
		}
		btn.hide();
	},

	onSaveFormularioCompletoTabComercial : function(btn, form) {
		var me = this;
		if (me.lookupReference('dtFechaVenta').value != null
				&& (me.getViewModel().get('comercial.situacionComercialCodigo') != CONST.SITUACION_COMERCIAL['VENDIDO'])) {
			Ext.Msg.show({
				title : HreRem
						.i18n('title.confirmar.modificar.venta.externa.activo'),
				msg : HreRem
						.i18n('msg.confirmar.modificar.venta.externa.activo'),
				buttons : Ext.MessageBox.YESNO,
				fn : function(buttonId) {
					if (buttonId == 'yes') {
						me.onSaveFormularioCompleto(btn, form, false);
					}
				}
			});
		} else {
			// Se ha de confirmar la modificaciÃ³n.
			Ext.Msg.show({
						title : HreRem
								.i18n('title.confirmar.modificar.venta.activo'),
						msg : HreRem
								.i18n('msg.confirmar.modificar.venta.activo'),
						buttons : Ext.MessageBox.YESNO,
						fn : function(buttonId) {
							if (buttonId == 'yes') {
								me.onSaveFormularioCompleto(btn, form, false);
							}
						}
					});
		}
	},

	onClickBotonGuardar : function(btn) {
		var me = this;
		var form = btn.up('tabpanel').getActiveTab();
		// Ejecución especial si la pestaña es 'Comercial'.
		if ("comercialactivo" == form.getXType()) {
			me.onSaveFormularioCompletoTabComercial(btn, form);
		} else if ("datospatrimonio" == form.getXType()) {
			me.onSaveFormularioCompletoTabPatrimonio(btn, form);
		} else if ('admisionrevisiontitulo' === form.getXType()) {
			me.onSaveFormularioCompletoTabAdmisionTitulo(btn, form);
		} else {
			me.onSaveFormularioCompleto(btn, form, false);
		}
	},

	onClickBotonCancelar : function(btn) {
		var me = this, activeTab = btn.up('tabpanel').getActiveTab();
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		if (Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
			me.getViewModel().set("editingFirstLevel", false);
		} else {
			me.getViewModel().set("editing", false);
		}
		me.getViewModel().notify();
		if (!activeTab.saveMultiple) {
			if (activeTab && activeTab.getBindRecord
					&& activeTab.getBindRecord()) {
				me.onClickBotonRefrescar();

			}
		} else {

			var records = activeTab.getBindRecords();

			for (i = 0; i < records.length; i++) {
				me.onClickBotonRefrescar();
			}

		}

		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();

		Ext.Array.each(activeTab.query('component[isReadOnlyEdit]'), function(
						field, index) {
					field.fireEvent('save');
					field.fireEvent('update');
				});
		me.getView().unmask();
	},

	onClickBotonCancelarPropietario : function(btn) {

		var window = btn.up('window');
		var padre = window.floatParent;
		var tab = padre.down('tituloinformacionregistralactivo');
		tab.funcionRecargar();

		btn.up('window').hide();
	},

	onClickBotonCancelarAgendaSaneamiento : function(btn) {

		var window = btn.up('window');
		var padre = window.floatParent;
		var tab = padre.down('admisionactivo');
		tab.funcionRecargar();

		btn.up('window').hide();
	},

	onClickBotonGuardarPropietario : function(btn) {
		var me = this;
		var url = $AC.getRemoteUrl('activo/updateActivoPropietarioTab');
		form = btn.up('window').down('formBase').getForm();
		formulario = btn.up('window').down('formBase');
		var window = btn.up('window');
		var padre = window.floatParent;
		var tab = padre.down('tituloinformacionregistralactivo');

		var propietario = me.getViewModel().get('propietario');
		var activo = me.getViewModel().get('activo');

		var params = {};
		params["idActivo"] = activo.get('id');
		params["idPropietario"] = propietario.get('id');
		params['porcPropiedad'] = form.findField("porcPropiedad").getValue();
		params['tipoGradoPropiedadCodigo'] = form
				.findField("tipoGradoPropiedad").getValue();
		params['tipoPersonaCodigo'] = form.findField("tipoPersona").getValue();
		params['nombre'] = form.findField("nombre").getValue();
		params['tipoDocIdentificativoCodigo'] = form.findField("tipoDoc")
				.getValue();
		params['docIdentificativo'] = form.findField("numDoc").getValue();
		params['direccion'] = form.findField("direccion").getValue();
		params['provinciaCodigo'] = form.findField("provincia").getValue();
		params['localidadCodigo'] = form.findField("localidad").getValue();
		params['codigoPostal'] = form.findField("codigoPostal").getValue();
		params['telefono'] = form.findField("telefono").getValue();
		params['email'] = form.findField("email").getValue();
		params['tipoPropietario'] = form.findField("tipoPropietario")
				.getValue();
		params['nombreContacto'] = propietario.get('nombreContacto');
		params['telefono1Contacto'] = propietario.get('telefono1Contacto');
		params['telefono2Contacto'] = propietario.get('telefono2Contacto');
		params['emailContacto'] = propietario.get('emailContacto');
		params['provinciaContactoCodigo'] = propietario
				.get('provinciaContactoCodigo');
		params['localidadContactoCodigo'] = propietario
				.get('localidadContactoCodigo');
		params['codigoPostalContacto'] = propietario
				.get('codigoPostalContacto');
		params['direccionContacto'] = propietario.get('direccionContacto');
		params['observaciones'] = propietario.get('observaciones');

		if (formulario.isFormValid()) {
			Ext.Ajax.request({
				url : url,
				params : params,
				success : function(a, operation, context) {
					btn.up('window').hide();
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					tab.funcionRecargar();
				},
				failure : function(a, operation, context) {
					Ext.toast({
								html : 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
								width : 360,
								height : 100,
								align : 't'
							});
				}
			});
		} else {
			me.fireEvent("errorToast",
					'Porfavor, revise los campos obligatorios');
		}
	},

	onClickBotonAnyadirPropietario : function(btn) {
		var me = this;
		var url = $AC.getRemoteUrl('activo/createActivoPropietarioTab');
		form = btn.up('window').down('formBase').getForm();
		formulario = btn.up('window').down('formBase');
		var window = btn.up('window');
		var padre = window.floatParent;
		var tab = padre.down('tituloinformacionregistralactivo');

		var activo = me.getViewModel().get('activo');
		var propietario = me.getViewModel().get('propietario');

		var params = {
			"idActivo" : activo.get('id')
		};
		params['porcPropiedad'] = form.findField("porcPropiedad").getValue();
		params['tipoGradoPropiedadCodigo'] = form
				.findField("tipoGradoPropiedad").getValue();
		params['tipoPersonaCodigo'] = form.findField("tipoPersona").getValue();
		params['nombre'] = form.findField("nombre").getValue();
		params['tipoDocIdentificativoCodigo'] = form.findField("tipoDoc")
				.getValue();
		params['docIdentificativo'] = form.findField("numDoc").getValue();
		params['direccion'] = form.findField("direccion").getValue();
		params['provinciaCodigo'] = form.findField("provincia").getValue();
		params['localidadCodigo'] = form.findField("localidad").getValue();
		params['codigoPostal'] = form.findField("codigoPostal").getValue();
		params['telefono'] = form.findField("telefono").getValue();
		params['email'] = form.findField("email").getValue();
		params['tipoPropietario'] = "Copropietario";

		porc = params.porcPropiedad;
		grado = params.tipoGradoPropiedadDescripcion;
		nombre = params.nombre;
		params['nombreContacto'] = propietario.nombreContacto;
		params['telefono1Contacto'] = propietario.telefonoContacto1;
		params['telefono2Contacto'] = propietario.telefonoContacto2;
		params['emailContacto'] = propietario.emailContacto;
		params['provinciaContactoCodigo'] = propietario.provinciaContactoCodigo;
		params['localidadContactoCodigo'] = propietario.localidadContactoCodigo;
		params['codigoPostalContacto'] = propietario.codigoPostalContacto;
		params['direccionContacto'] = propietario.direccionContacto;
		params['observaciones'] = propietario.observacionesContacto;

		if (formulario.isFormValid()) {
			Ext.Ajax.request({
				url : url,
				params : params,
				success : function(a, operation, context) {
					btn.up('window').hide();
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					tab.funcionRecargar();
				},
				failure : function(a, operation, context) {
					Ext.toast({
								html : 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
								width : 360,
								height : 100,
								align : 't'
							});
				}
			});
		} else {
			me.fireEvent("errorToast",
					'Porfavor, revise los campos obligatorios');
		}

	},

	onClickBotonAnyadirAgendaSaneamiento : function(btn) {

		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		var form = btn.up().up().down("form"), url = $AC
				.getRemoteUrl("activo/createSaneamientoAgenda"), idActivo = btn
				.up().up().idActivo, params = {
			idActivo : idActivo,
			tipologiaCod : form.items.items[0].getValue(),
			subtipologiacod : form.items.items[1].getValue(),
			observaciones : form.items.items[2].getValue()
		};

		if (form.isValid()) {
			form.submit({
				url : url,
				params : params,
				success : function(fp, o) {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().unmask();
					me.onClickBotonCancelarAgendaSaneamiento(btn);
				},
				failure : function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.unmask();
				}
			});
		} else {
			me.getView().unmask();
		}

	},

	onTramitesListDobleClick : function(grid, record) {
		var me = this;
		// HREOS-846 Si el activo esta fuera del perimetro Haya, no debe poder
		// abrir tramites desde
		// el activo
		if (me.getViewModel().get('activo').get('incluidoEnPerimetro') == "false") {
			me
					.fireEvent(
							"errorToast",
							HreRem
									.i18n("msg.operacion.activo.fuera.perimetro.abrir.tramite.ko"));
		} else {
			me.getView().fireEvent('abrirDetalleTramite', grid, record);
		}
	},

	onComboGestoresClick : function(btn) {
		var me = this;
		me.getView().fireEvent('onComboGestoresClick', btn);
	},

	onClickBotonCerrarPestanya : function(btn) {
		var me = this;
		me.getView().destroy();
	},

	onClickBotonCerrarTodas : function(btn) {
		var me = this;
		me.getView().up("tabpanel").fireEvent("cerrarTodas",
				me.getView().up("tabpanel"));

	},

	/**
	 * FunciÃ³n que refresca la pestaña activa, y marca el resto de
	 * componentes para referescar. Para que un componente sea marcado para
	 * refrescar, es necesario que implemente la funciÃ³n funciÃ³nRecargar
	 * con el cÃ³digo necesario para refrescar los datos.
	 */
	onClickBotonRefrescar : function(btn) {
		var me = this;
		me.refrescarActivo(true);

	},

	refrescarActivo : function(refrescarPestanyaActiva) {
		var me = this, refrescarPestanyaActiva = Ext
				.isEmpty(refrescarPestanyaActiva)
				? false
				: refrescarPestanyaActiva, activosdetallemain = me.getView().xtype == 'activosdetallemain'
				? me.getView()
				: me.getView().up('activosdetallemain'), activeTab = activosdetallemain
				.down("tabpanel").getActiveTab();
		// Marcamos todas los componentes para refrescar, de manera que se vayan
		// actualizando
		// conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'),
				function(component) {
					if (component.rendered) {
						component.recargar = true;
					}
				});

		// Actualizamos la pestaña actual si tiene funciÃ³n de recargar
		if (refrescarPestanyaActiva && activeTab.funcionRecargar) {
			activeTab.funcionRecargar();
		}

		me.getView().fireEvent("refrescarActivo", me.getView());

	},

	abrirFormularioAdjuntarDocumentos : function(grid,record) {

		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var viewPortWidth = Ext.Element.getViewportWidth();
	    var viewPortHeight = Ext.Element.getViewportHeight();
		var wizard = Ext.create('HreRem.view.common.WizardBase',
				{
					slides: [
						'adjuntardocumentowizard1',
						'adjuntardocumentowizard2'
					],
					title: 'Adjuntar Documento',
					padre : me,
					idEntidad: idActivo,
					entidad:'activo',
					modoEdicion: true,
					width: viewPortWidth > 1370 ? viewPortWidth / 2.5 : viewPortWidth / 3.5,
					height: viewPortHeight > 500 ? 350 : viewPortHeight - 100,
					x: viewPortWidth / 2 - ((viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth /1.5) / 2),
	    			y: viewPortHeight / 2 - ((viewPortHeight > 500 ? 500 : viewPortHeight - 100) / 2)
				}
			).show();

	},

	abrirFormularioAdjuntarDocumentoOferta : function(grid) {
		var me = this;
		var idEntidad = null, entidad = null, docCliente = null;

		if (grid.up('anyadirnuevaofertaactivoadjuntardocumento').up().xtype
				.indexOf('oferta') >= 0) {
			if (!Ext.isEmpty(grid.up('wizardaltaoferta').oferta.data.idActivo)) {
				idEntidad = grid.up('wizardaltaoferta').oferta.data.idActivo;
				entidad = 'activo';
			} else {
				idEntidad = grid.up('wizardaltaoferta').oferta.data.idAgrupacion;
				entidad = 'agrupacion';
			}
			docCliente = me.getViewModel().get("oferta.numDocumentoCliente");
		} else {
			idEntidad = grid.up('wizardaltacomprador')
					.down('datoscompradorwizard').getRecord().data.idExpedienteComercial;
			entidad = 'expediente';
			docCliente = grid.up('window').down("datoscompradorwizard")
					.getForm().getFieldValues().numDocumento;
		}
		grid.up('window').down("datoscompradorwizard").getForm()
				.getFieldValues().numDocumento;
		Ext.create(
				"HreRem.view.common.adjuntos.AdjuntarDocumentoOfertacomercial",
				{
					entidad : entidad,
					idEntidad : idEntidad,
					docCliente : docCliente,
					parent : grid
				}).show();
	},

	abrirFormularioAdjuntarDocPromo : function(grid) {

		var me = this, idActivo = me.getViewModel().get("activo.id");
		Ext.create(
				"HreRem.view.common.adjuntos.AdjuntarDocumentoActivoProyecto",
				{
					entidad : 'promocion',
					idEntidad : idActivo,
					parent : grid
				}).show();

	},

	abrirFormularioAdjuntarDocumentosPlusvalia : function(grid) {

		var me = this, idActivo = me.getViewModel().get("activo.id");
		if (me.getViewModel().get("plusvalia.idPlusvalia") != undefined) {
			Ext.create(
					"HreRem.view.common.adjuntos.AdjuntarDocumentoPlusvalia", {
						entidad : 'activo',
						idEntidad : idActivo,
						parent : grid
					}).show();
		} else {
			me.fireEvent("errorToast", HreRem
							.i18n("msg.operacion.ko.activo.sin.plusvalia"));
		}
	},

	abrirFormularioAdjuntarDocProyecto : function(grid) {

		var me = this, idActivo = me.getViewModel().get("activo.id");
		Ext.create(
				"HreRem.view.common.adjuntos.AdjuntarDocumentoActivoProyecto",
				{
					entidad : 'proyecto',
					idEntidad : idActivo,
					parent : grid,
					title : HreRem.i18n("title.adjuntar.documento.proyecto"),
					diccionario : "tiposDocumentoProyecto"
				}).show();

	},

	borrarDocumentoAdjunto : function(grid, record) {
		var me = this, idActivo = me.getViewModel().get("activo.id");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		record.erase({
					params : {
						idEntidad : idActivo
					},
					success : function(record, operation) {
						grid.fireEvent("afterdelete", grid);
						me.getView().unmask();
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
					},
					failure : function(record, operation) {
						grid.fireEvent("afterdelete", grid);
						me.getView().unmask();
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
					}

				});
	},

	borrarDocumentoAdjuntoOferta : function(grid, record) { // FIXME: cuando se
															// reubique dentro
															// de un slide en el
															// wizard eliminar
															// de aqui.
		var me = this, docCliente = null;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		if (grid.handler == "borrarDocumentoAdjuntoOferta") {
			var url = null;
			if (grid.up('anyadirnuevaofertaactivoadjuntardocumento').up().xtype
					.indexOf('oferta') >= 0) {
				url = $AC
						.getRemoteUrl('activooferta/eliminarDocumentoAdjuntoOferta');
				docCliente = me.getViewModel()
						.get("oferta.numDocumentoCliente");
			} else {
				url = $AC
						.getRemoteUrl('expedientecomercial/eliminarDocumentoAdjuntoComprador');
				docCliente = me.getViewModel().get("comprador.numDocumento");
			}
			Ext.Ajax.request({
				url : url,
				params : {
					docCliente : docCliente
				},
				success : function(a, operation, context) {
					var data = Ext.decode(a.responseText);
					if (data) {
						grid.up().down('textfieldbase').setValue('');
					}
					me.getView().unmask();
					grid.hide();
					Ext.toast({
								html : 'Operaci&oacute;n relizada con &eacute;xito',
								width : 360,
								height : 100,
								align : 't'
							});
					var ventanaWizard = grid
							.up('anyadirnuevaofertaactivoadjuntardocumento');
					ventanaWizard.down('button[itemId=btnFinalizar]').disable();
					// ventanaWizard.down('button[itemId=btnSubirDoc]').disable();
					ventanaWizard.down('button[itemId=btnGenerarDoc]').enable();
					ventanaWizard.getForm().findField('comunicacionTerceros')
							.enable();
					ventanaWizard.getForm().findField('cesionDatos').enable();
					ventanaWizard.getForm()
							.findField('transferenciasInternacionales')
							.enable();

				},
				failure : function(a, operation, context) {
					Ext.toast({
								html : 'NO HA SIDO POSIBLE REALIZAR LA OPERACION',
								width : 360,
								height : 100,
								align : 't'
							});
					me.unmask();
				}
			});
		}
	},

	borrarDocumentoAdjuntoPlusvalia : function(grid, record) {
		var me = this, idActivo = me.getViewModel().get("activo.id"), id = grid
				.getSelection()[0].data.id, url = $AC
				.getRemoteUrl('activo/deleteAdjuntoPlusvalia');
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		Ext.Ajax.request({
					url : url,
					params : {
						idEntidad : idActivo,
						id : id
					},
					success : function(record, operation) {
						grid.fireEvent("afterdelete", grid);
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
						me.getView().unmask();
					},
					failure : function(record, operation) {
						grid.fireEvent("afterdelete", grid);
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
						me.getView().unmask();
					}

				});
	},

	downloadDocumentoAdjunto : function(grid, record) {
		var me = this, config = {};

		config.url = $AC.getWebPath() + "activo/bajarAdjuntoActivo."
				+ $AC.getUrlPattern();
		config.params = {};
		config.params.id = record.get('id');
		config.params.idActivo = record.get("idActivo");
		config.params.nombreDocumento = record.get("nombre").replace(/,/g, "");
		me.fireEvent("downloadFile", config);
	},

	downloadDocumentoAdjuntoPromocion : function(grid, record) {

		var me = this, config = {};

		config.url = $AC.getWebPath()
				+ "promocion/bajarAdjuntoActivoPromocion."
				+ $AC.getUrlPattern();
		config.params = {};
		config.params.id = record.get('id');
		config.params.idActivo = record.get("idActivo");
		config.params.nombreDocumento = record.get("nombre").replace(/,/g, "");
		me.fireEvent("downloadFile", config);
	},

	downloadDocumentoAdjuntoPlusvalia : function(grid, record) {
		var me = this, config = {};

		config.url = $AC.getWebPath() + "activo/bajarAdjuntoPlusvalia."
				+ $AC.getUrlPattern();
		config.params = {};
		config.params.id = record.get('id');
		config.params.idActivo = me.getViewModel().get("activo.id");
		config.params.nombreDocumento = record.get("nombre").replace(/,/g, "");
		me.fireEvent("downloadFile", config);
	},

	downloadDocumentoAdjuntoProyecto : function(grid, record) {
		var me = this, config = {};

		config.url = $AC.getWebPath() + "proyecto/bajarAdjuntoActivoProyecto."
				+ $AC.getUrlPattern();
		config.params = {};
		config.params.id = record.get('id');
		config.params.idActivo = me.getViewModel().get("activo.id");
		config.params.nombreDocumento = record.get("nombre").replace(/,/g, "");
		me.fireEvent("downloadFile", config);
	},
	updateOrdenFotosInterno : function(data, record, store) {

		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		var url = $AC.getRemoteUrl('activo/updateFotosById');
		Ext.Ajax.request({
					url : url,
					params : {
						data : Ext.encode(store.getData().getIndices())
					},
					success : function(a, operation, context) {
						store.load();
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
						me.getView().unmask();

					},
					failure : function(a, operation, context) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
						me.getView().unmask();
					}
				});
	},

	onAddFotoClick : function(grid) {

		var me = this, idActivo = me.getViewModel().get("activo.id"),
		codigoSubtipoActivo = me.getViewModel().get("activo.subtipoActivoCodigo");

		Ext.create("HreRem.view.common.adjuntos.AdjuntarFoto", {
					idEntidad : idActivo,
					codigoSubtipoActivo: codigoSubtipoActivo,
					parent : grid
				}).show();

	},

	onReloadFotoClick : function(btn) {
		var me = this, idActivo = me.getViewModel().get("activo.id");
		var storeTemp = btn.up('form').down('dataview').getStore();
		var url = $AC.getRemoteUrl('activo/refreshCacheFotos');
		Ext.Ajax.request({
					url : url,
					params : {
						id : idActivo
					},
					success : function(a, operation, context) {
						storeTemp.load();
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
					},
					failure : function(a, operation, context) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
					}
				});
	},

	onDeleteFotoClick : function(btn) {

		var me = this;

		Ext.Msg.show({
			title : HreRem.i18n('title.confirmar.eliminacion'),
			msg : HreRem.i18n('msg.desea.eliminar'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {

					var nodos = btn.up('form').down('dataview')
							.getSelectedNodes();
					var storeTemp = btn.up('form').down('dataview').getStore();
					var idSeleccionados = [];
					for (var i = 0; i < nodos.length; i++) {

						idSeleccionados[i] = storeTemp.getAt(nodos[i]
								.getAttribute('data-recordindex')).getId();

					}

					var url = $AC.getRemoteUrl('activo/deleteFotosActivoById');
					Ext.Ajax.request({

								url : url,
								params : {
									id : idSeleccionados
								},

								success : function(a, operation, context) {

									storeTemp.load();

									var data = Ext.decode(a.responseText);
									if (data.success == "true") {
										me
												.fireEvent(
														"infoToast",
														HreRem
																.i18n("msg.operacion.ok"));
									} else {
										me.fireEvent("errorToast", data.error);
									}

								},

								failure : function(a, operation, context) {

									me.fireEvent("errorToast", HreRem
													.i18n("msg.operacion.ko"));
								}

							});

				}
			}
		});

	},

	onDownloadFotoClick : function(btn) {
		var me = this, config = {};

		var nodos = btn.up('form').down('dataview').getSelectedNodes();
		if (nodos.length != 0) {

			var storeTemp = btn.up('form').down('dataview').getStore();

			config.url = $AC.getWebPath() + "activo/getFotoActivoById."
					+ $AC.getUrlPattern();
			config.params = {};

			config.params.idFoto = storeTemp.getAt(nodos[0]
					.getAttribute('data-recordindex')).getId();

			me.fireEvent("downloadFile", config);
		}
	},

	// Se deja planteado para fase 2, pero para fase 1 se elimina el botÃ³n
	// imprimir.
	onPrintFotoClick : function(btn) {

		var me = this;

		var nodos = btn.up('form').down('dataview').getSelectedNodes();

		if (nodos) {

			node = nodos[0];
			cmp = me.findComponentByElement(node);

			html = cmp.container.dom.innerHTML;

			var win = window.open();
			win.document.write(html);
			win.print();
			win.close();
		}

	},

	// Se deja planteado para fase 2, pero para fase 1 se elimina el botÃ³n
	// imprimir.
	findComponentByElement : function(node) {
		var topmost = document.body, target = node, cmp;

		while (target && target.nodeType === 1 && target !== topmost) {
			cmp = Ext.getCmp(target.id);

			if (cmp) {
				return cmp;
			}

			target = target.parentNode;
		}

		return null;
	},

	cargarTabFotos : function(form) {

		var me = this;
		me.getViewModel().data.storeFotos.load();
		me.getViewModel().data.storeFotosTecnicas.load();

	},

	// Funcion para cuando hace click en una fila
	onHistoricoPeticionesActivoDobleClick : function(grid, record) {
		var me = this;
		me.abrirDetalleTrabajo(record);
	},

	abrirDetalleTrabajo : function(record) {
		var me = this;
		me.getView().fireEvent('abrirDetalleTrabajo', record);

	},

	onHistoricoPresupuestosActivoListDobleClick : function(grid, record) {
		grid.up('form').down('[reference=incrementosPresupuesto]').getStore()
				.getProxy().setExtraParams({
							'idPresupuesto' : record.id
						});
		grid.up('form').down('[reference=incrementosPresupuesto]').getStore()
				.load();
	},

	// FIXME: Funciones para el grÃ¡fico de presupuestos. Llevar a otro
	// controlador aparte.
	onAxisLabelRender : function(axis, label, layoutContext) {
		// Custom renderer overrides the native axis label renderer.
		// Since we don't want to do anything fancy with the value
		// ourselves except appending a '%' sign, but at the same time
		// don't want to loose the formatting done by the native renderer,
		// we let the native renderer process the value first.
		return layoutContext.renderer(label) + '%';
	},

	onSeriesTooltipRender : function(tooltip, record, item) {
		var fieldIndex = Ext.Array.indexOf(item.series.getYField(), item.field), browser = item.series
				.getTitle()[fieldIndex];

		var cantidad = 0;
		if (item.field == 'gastadoPorcentaje') {
			cantidad = record.get('gastado');
		} else if (item.field == 'dispuestoPorcentaje') {
			cantidad = record.get('dispuesto');
		} else if (item.field == 'disponiblePorcentaje') {
			cantidad = record.get('disponible');
		}

		tooltip.setHtml(browser + ': ' + record.get(item.field) + '%' + ' ( '
				+ Ext.util.Format.currency(cantidad) + ' )');
	},

	onColumnRender : function(v) {
		return v + '%';
	},

	onPreview : function() {
		var chart = this.lookupReference('chart');
		chart.preview();
	},

	onClickVerificarDireccion : function(btn) {
		var me = this, geoCodeAddr = null, latLng = {};

		latLng.latitud = me.getViewModel().get("informeComercial.latitud");
		latLng.longitud = me.getViewModel().get("informeComercial.longitud");
		geoCodeAddr = me.getViewModel().get("geoCodeAddr");

		Ext.create("HreRem.ux.window.geolocalizacion.ValidarGeoLocalizacion", {
					geoCodeAddr : geoCodeAddr,
					latLng : latLng,
					parent : btn.up("form")
				}).show();
	},

	// Este mÃ©todo comprueba si el municipio es 'Barcelona, Madrid, Valencia
	// o Alicante/Alacant'.
	checkDistrito : function(combobox) {
		var me = this;
		var view = me.getView();
		var distrito = combobox.getRawValue();

		// Comprobar distrito y mostrar u ocultar el textfield de distrito.
		if (Ext.isEmpty(distrito)) {
			view.lookupReference('fieldlabelDistrito').hide();
		} else if (distrito === 'Valencia') {
			view.lookupReference('fieldlabelDistrito').show();
		} else if (distrito === 'Barcelona') {
			view.lookupReference('fieldlabelDistrito').show();
		} else if (distrito === 'Madrid') {
			view.lookupReference('fieldlabelDistrito').show();
		} else if (distrito === 'Alicante/Alacant') {
			view.lookupReference('fieldlabelDistrito').show();
		} else {
			view.lookupReference('fieldlabelDistrito').hide();
		}
	},

	actualizarCoordenadas : function(parent, latitud, longitud) {
		var me = this;

		parent.actualizarCoordenadas(latitud, longitud);

	},

	onSearchPropuestasActivoClick : function(btn) {

		var me = this;
		this.lookupReference('propuestasActivoList').getStore().loadPage(1);

	},

	beforeLoadPropuestas : function(store, operation, opts) {

		var me = this, searchForm = this
				.lookupReference('propuestasActivoSearch');

		if (searchForm.isValid()) {

			store.getProxy().extraParams = me.getFormCriteria(searchForm);
			store.getProxy().extraParams.idActivo = me.getViewModel()
					.get("activo.id");

			return true;
		}
	},

	getFormCriteria : function(form) {

		var me = this, initialData = {};

		var criteria = Ext.apply(initialData, form ? form.getValues() : {});

		Ext.Object.each(criteria, function(key, val) {
					if (Ext.isEmpty(val)) {
						delete criteria[key];
					}
				});

		return criteria;
	},

	// Funcion que se ejecuta al hacer click en el botÃ³n limpiar
	onCleanFiltersClick : function(btn) {
		btn.up('form').getForm().reset();
	},

	// Esta funciÃ³n es llamada cuando cambia el estado de publicaciÃ³n del
	// activo.
	onChangeEstadoPublicacion : function(field) {
		var me = this;
		var view = me.getView();
		var codigo = me.getViewModel().getData().getEstadoPublicacionCodigo;

		switch (codigo) {
			case "01" : // Publicado.
				view.lookupReference('seccionPublicacionForzada').hide();
				view.lookupReference('seccionOcultacionForzada').show();
				view.lookupReference('seccionOcultacionPrecio').show();
				view.lookupReference('seccionDespublicacionForzada').show();
				break;
			case "02" : // PublicaciÃ³n forzada.
				view.lookupReference('seccionPublicacionForzada').show();
				view.lookupReference('seccionOcultacionForzada').hide();
				view.lookupReference('seccionOcultacionPrecio').show();
				view.lookupReference('seccionDespublicacionForzada').hide();
				break;
			case "03" : // Publicado oculto.
				view.lookupReference('seccionPublicacionForzada').hide();
				view.lookupReference('seccionOcultacionForzada').show();
				view.lookupReference('seccionOcultacionPrecio').show();
				view.lookupReference('seccionDespublicacionForzada').show();
				break;
			case "04" : // Publicado con precio oculto.
				view.lookupReference('seccionPublicacionForzada').hide();
				view.lookupReference('seccionOcultacionForzada').show();
				view.lookupReference('seccionOcultacionPrecio').show();
				view.lookupReference('seccionDespublicacionForzada').show();
				break;
			case "05" : // Despublicado.
				view.lookupReference('seccionPublicacionForzada').hide();
				view.lookupReference('seccionOcultacionForzada').hide();
				view.lookupReference('seccionOcultacionPrecio').hide();
				view.lookupReference('seccionDespublicacionForzada').show();
				break;
			case "06" : // No publicado.
				view.lookupReference('seccionPublicacionForzada').show();
				view.lookupReference('seccionOcultacionForzada').hide();
				view.lookupReference('seccionOcultacionPrecio').hide();
				view.lookupReference('seccionDespublicacionForzada').hide();
				break;
			case "07" : // Publicado forzado con precio oculto.
				view.lookupReference('seccionPublicacionForzada').show();
				view.lookupReference('seccionOcultacionForzada').hide();
				view.lookupReference('seccionOcultacionPrecio').show();
				view.lookupReference('seccionDespublicacionForzada').hide();
				break;
			default : // Por defecto se trata como No Publicado.
				view.lookupReference('seccionPublicacionForzada').show();
				view.lookupReference('seccionOcultacionForzada').hide();
				view.lookupReference('seccionOcultacionPrecio').hide();
				view.lookupReference('seccionDespublicacionForzada').hide();
				break;
		}
	},

	// Esta funciÃ³n es llamada cuando cambia el estado del combo 'otro' en
	// los
	// condicionantes de la publicaciÃ³n del activo. Muestra u oculta el
	// Ã¡rea de
	// texto que muestra el condicionante 'otro'.
	onChangeComboOtro : function(combo) {
		var me = this;
		var view = me.getView();

		if (combo.getValue() === '0') {
			view.lookupReference('fieldtextCondicionanteOtro').allowBlank = true;
			view.lookupReference('fieldtextCondicionanteOtro').setValue('');
			view.lookupReference('fieldtextCondicionanteOtro').hide();
		} else {
			view.lookupReference('fieldtextCondicionanteOtro').show();
			view.lookupReference('fieldtextCondicionanteOtro').allowBlank = false;
			view.lookupReference('fieldtextCondicionanteOtro').isValid();
		}
	},

	onClickAbrirExpedienteComercial : function(grid, rowIndex, colIndex) {
		var me = this, record = grid.getStore().getAt(rowIndex);
		me.getView().fireEvent('abrirDetalleExpediente', record);

	},

	onEnlaceTrabajoClick : function(grid, rowIndex, colIndex) {

		var me = this, record = grid.getStore().getAt(rowIndex);
		record.data.id = record.data.idTrabajo;
		me.getView().fireEvent('abrirDetalleTrabajo', record);

	},

	onEnlaceTramiteClick : function(grid, rowIndex, colIndex) {

		var me = this, record = grid.getStore().getAt(rowIndex);
		me.getView().fireEvent('abrirDetalleTramite', grid, record);
	},

	onClickBotonCancelarOferta : function(btn) {
		var me = this, window = btn.up('window');
		window.close();
	},

	onClickBotonCancelarWizard : function(btn) {
		var me = this, window = btn.up('window');
		var form1 = window.down('anyadirnuevaofertadocumento');
		var form2 = window.down('anyadirnuevaofertadetalle');
		var form3 = window.down('anyadirnuevaofertaactivoadjuntardocumento');

		if (!Ext.isEmpty(form2)) {
			var docCliente = form2.getForm().findField('numDocumentoCliente')
					.getValue();
		}

		Ext.Msg.show({
			title : HreRem.i18n('wizard.msg.show.title'),
			msg : HreRem.i18n('wizard.msh.show.text'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {
					var url = $AC
							.getRemoteUrl('activooferta/deleteTmpClienteByDocumento');
					Ext.Ajax.request({
								url : url,
								method : 'POST',
								params : {
									docCliente : docCliente
								},
								success : function(response, opts) {

									if (!Ext.isEmpty(form1)) {
										form1.reset();
									}
									if (!Ext.isEmpty(form2)) {
										form2.reset();
									}
									if (!Ext.isEmpty(form3)) {
										form3.reset();
									}
									window.hide();
								},
								failure : function(record, operation) {
									// me.fireEvent("errorToast",
									// HreRem.i18n("msg.operacion.ko"));
								}
							});

				}
			}
		});
	},

	onClickBotonGuardarOferta : function(btn) {
		var me = this, window = btn.up('window'), form = window
				.down('formBase'), model = null, data = window.oferta.data, ventanaDetalle = window
				.down('anyadirnuevaofertadetalle');

		bindRecord = ventanaDetalle.getBindRecord();

		if (Ext.isDefined(data.idActivo)) {
			model = Ext.create('HreRem.model.OfertaComercialActivo', {
				idActivo : data.idActivo,
				importeOferta : bindRecord.importeOferta,
				tipoOferta : bindRecord.tipoOferta,
				numDocumentoCliente : bindRecord.numDocumentoCliente,
				tipoDocumento : bindRecord.tipoDocumento,
				nombreCliente : bindRecord.nombreCliente,
				apellidosCliente : bindRecord.apellidosCliente,
				cesionDatos : bindRecord.cesionDatos,
				comunicacionTerceros : bindRecord.comunicacionTerceros,
				transferenciasInternacionales : bindRecord.transferenciasInternacionales,
				codigoPrescriptor : bindRecord.codigoPrescriptor,
				regimenMatrimonial : bindRecord.regimenMatrimonial,
				estadoCivil : bindRecord.estadoCivil,
				codigoSucursal : bindRecord.codigoSucursal,
				intencionFinanciar : bindRecord.intencionFinanciar,
				tipoPersona : bindRecord.tipoPersona,
				razonSocialCliente : bindRecord.razonSocialCliente,
				deDerechoTanteo : bindRecord.deDerechoTanteo,
				claseOferta : bindRecord.claseOferta,
				numOferPrincipal : bindRecord.numOferPrincipal
			});
		} else {
			model = Ext.create('HreRem.model.OfertaComercial', {
				idAgrupacion : data.idAgrupacion,
				importeOferta : bindRecord.importeOferta,
				tipoOferta : bindRecord.tipoOferta,
				numDocumentoCliente : bindRecord.numDocumentoCliente,
				tipoDocumento : bindRecord.tipoDocumento,
				nombreCliente : bindRecord.nombreCliente,
				apellidosCliente : bindRecord.apellidosCliente,
				cesionDatos : bindRecord.cesionDatos,
				comunicacionTerceros : bindRecord.comunicacionTerceros,
				transferenciasInternacionales : bindRecord.transferenciasInternacionales,
				codigoPrescriptor : bindRecord.codigoPrescriptor,
				regimenMatrimonial : bindRecord.regimenMatrimonial,
				estadoCivil : bindRecord.estadoCivil,
				codigoSucursal : bindRecord.codigoSucursal,
				intencionFinanciar : bindRecord.intencionFinanciar,
				tipoPersona : bindRecord.tipoPersona,
				razonSocialCliente : bindRecord.razonSocialCliente,
				deDerechoTanteo : bindRecord.deDerechoTanteo,
				claseOferta : bindRecord.claseOferta,
				numOferPrincipal : bindRecord.numOferPrincipal
			});
		}

		me.getViewModel().set('oferta', model);

		me.onSaveFormularioCompletoOferta(form, window);
	},
	
	onChkbxOfertasAnuladas: function(chkbox, checked){
    	var me = this;
    	var grid = chkbox.up('ofertascomercialactivo').down("ofertascomercialactivolist");
    	var _id = me.getViewModel().getData().activo.id;
    	var store = grid.getStore();
    	var prox = store.getProxy();
    	var _incluirOfertasAnuladas = checked;
    	
    	prox.setExtraParams({
    		"id": _id, 
    		"incluirOfertasAnuladas": _incluirOfertasAnuladas
    	});
    	store.load();
	},

	// Este mÃ©todo copia los valores de los campos de 'Datos Mediador' a los
	// campos de 'Datos
	// admisiÃ³n'.
	onClickCopiarDatosDelMediador : function(btn) {
		var me = this;
		var view = me.getView();

		view.lookupReference('tipoActivoAdmisionInforme').setValue(view
				.lookupReference('tipoActivoMediadorInforme').getValue());
		view.lookupReference('subtipoActivoComboAdmisionInforme').setValue(view
				.lookupReference('subtipoActivoComboMediadorInforme')
				.getValue());
		view.lookupReference('tipoViaAdmisionInforme').setValue(view
				.lookupReference('tipoViaMediadorInforme').getValue());
		view.lookupReference('nombreViaAdmisionInforme').setValue(view
				.lookupReference('nombreViaMediadorInforme').getValue());
		view.lookupReference('numeroAdmisionInforme').setValue(view
				.lookupReference('numeroMediadorInforme').getValue());
		view.lookupReference('escaleraAdmisionInforme').setValue(view
				.lookupReference('escaleraMediadorInforme').getValue());
		view.lookupReference('plantaAdmisionInforme').setValue(view
				.lookupReference('plantaMediadorInforme').getValue());
		view.lookupReference('puertaAdmisionInforme').setValue(view
				.lookupReference('puertaMediadorInforme').getValue());
		view.lookupReference('codPostalAdmisionInforme').setValue(view
				.lookupReference('codPostalMediadorInforme').getValue());
		view.lookupReference('municipioComboAdmisionInforme').setValue(view
				.lookupReference('municipioComboMediadorInforme').getValue());
		view.lookupReference('poblacionalAdmisionInforme').setValue(view
				.lookupReference('poblacionalMediadorInforme').getValue());
		view.lookupReference('provinciaComboAdmisionInforme').setValue(view
				.lookupReference('provinciaComboMediadorInforme').getValue());
		view.lookupReference('latitudAdmisionInforme').setValue(view
				.lookupReference('latitudmediador').getValue());
		view.lookupReference('longitudAdmisionInforme').setValue(view
				.lookupReference('longitudmediador').getValue());

	},

	onSaveFormularioCompletoOferta : function(form, window) {
		var me = this, record = form.getBindRecord(), ofertaForm = null, wizardAltaOferta = form
				.up('wizardaltaoferta');

		model = me.getViewModel().get('oferta');

		if (!Ext.isEmpty(wizardAltaOferta.down('anyadirnuevaofertadetalle'))) {
			ofertaForm = wizardAltaOferta.down('anyadirnuevaofertadetalle').form;
		}

		if (ofertaForm.isValid()) {

			window.mask(HreRem.i18n("msg.mask.espere"));

			model.save({
				success : function(record) {
					form.reset();
					ofertaForm.reset();
					window.unmask();
					if (Ext.isDefined(model.data.idActivo)) {
						window.parent.up('activosdetalle').lookupController()
								.refrescarActivo(true);
					} else {
						window.setController('agrupaciondetalle');
						window.getController().refrescarAgrupacion(true);
						// window.parent.up('agrupacionesdetalle').lookupController().refrescarAgrupacion(true);
					}
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					window.destroy();
				},
				failure : function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					window.unmask();
					// form.reset();
					// ofertaForm.reset();
				}

			});

		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	},

	onActivosVinculadosClick : function(tableView, indiceFila, indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
		var record = grid.store.getAt(indiceFila);

		grid.setSelection(record);

		me.getView().fireEvent('abrirDetalleActivo', record.get('idActivo'),
				"Activo " + record.get("numActivo"));
	},

	// Este mÃ©todo comprueba si el campo fechaHasta o UsuarioBaja tiene
	// datos, lo que supone que el
	// registro
	// ya se encuentra dado de baja y no se permite volver a dar de baja.
	onGridCondicionesEspecificasRowClick : function(grid, record, tr, rowIndex) {
		if (!Ext.isEmpty(record.getData().fechaHasta)
				|| !Ext.isEmpty(record.getData().usuarioBaja)) {
			grid.up().disableRemoveButton(true);
		}
	},

	// MÃ©todo para borrar/anular un precio vigente sin guardar en el
	// Historico
	onDeletePrecioVigenteClick : function(tableView, indiceFila, indiceColumna) {

		var me = this;
		var grid = tableView.up('grid');

		var idPrecioVigente = grid.store.getAt(indiceFila)
				.get('idPrecioVigente');

		if (idPrecioVigente != null) {
			grid.mask(HreRem.i18n("msg.mask.espere"));

			Ext.Msg.show({
				title : HreRem.i18n('title.confirmar.borrado.precio.vigente'),
				msg : HreRem.i18n('msg.confirmar.borrado.precio.vigente'),
				buttons : Ext.MessageBox.YESNO,
				fn : function(buttonId) {

					if (buttonId == 'yes') {

						var storeTemp = grid.getStore();

						var url = $AC
								.getRemoteUrl('activo/deletePrecioVigenteSinGuardadoHistorico');
						Ext.Ajax.request({

							url : url,
							params : {
								idPrecioVigente : idPrecioVigente
							},

							success : function(response, opts) {

								if (Ext.decode(response.responseText).success == "false") {
									me
											.fireEvent(
													"errorToast",
													HreRem
															.i18n("msg.error.borrar.precio.vigente"));
								} else {
									storeTemp.load();
									me.refrescarActivo(true);
									me.fireEvent("infoToast", HreRem
													.i18n("msg.operacion.ok"));
								}

							},

							failure : function(a, operation, context) {

								me.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
							}

						});
					}

				}
			});
			grid.unmask();
		} else {
			me.fireEvent("infoToast", HreRem
							.i18n("msg.info.seleccionar.precio"));
		}

	},

	// MÃ©todo que es llamado cuando se solicita la tasaciÃ³n del activo
	// desde Bankia.
	onClickSolicitarTasacionBankia : function(btn) {
		var me = this;
		var idActivo = me.getViewModel().get("activo.id");
		var url = $AC.getRemoteUrl('activo/solicitarTasacion');

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		Ext.Ajax.request({
					url : url,
					params : {
						idActivo : idActivo
					},

					success : function(response, opts) {
						var obj = Ext.decode(response.responseText);
						if (obj.success == 'true') {
							me.fireEvent("infoToast", HreRem
											.i18n("msg.operacion.ok"));
							btn.up('tasacionesactivo').funcionRecargar();
							me.getView().unmask();
						} else {
							Utils.defaultRequestFailure(response, opts);
						}

					},

					failure : function(response, opts) {
						Utils.defaultRequestFailure(response, opts);
					}
				});
	},

	onVisitasListDobleClick : function(grid, record, tr, rowIndex) {
		var me = this, record = grid.getStore().getAt(rowIndex);

		Ext.create('HreRem.view.comercial.visitas.VisitasComercialDetalle', {
					detallevisita : record
				}).show();

	},

	onClickBotonCerrarDetalleVisita : function(btn) {
		var me = this, window = btn.up('window');
		window.close();
	},

	onProveedoresListClick : function(gridView, record) {
		var me = this;
		idProveedor = record.get('idFalso').id;
		idActivo = record.get('idFalso').idActivo;
		gridView.up('form').down('[reference=listadogastosref]').getStore()
				.getProxy().setExtraParams({
							'idActivo' : idActivo,
							'idProveedor' : idProveedor
						});
		gridView.up('form').down('[reference=listadogastosref]').getStore()
				.load();

	},

	// Función que abre la pestaña de proveedor.
	abrirPestanyaProveedor : function(tableView, indiceFila, indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
		var record = grid.store.getAt(indiceFila);
		grid.setSelection(record);
		var idFalso = record.get('idFalso');
		var idFalsoProv;
		if (idFalso != null) {
			idFalsoProv = record.get('idFalso').id;
		}

		if (!Ext.isEmpty(record.get('idProveedor'))) {
			var idProveedor = record.get("idProveedor");
			record.data.id = idProveedor;
			var codigoProveedor = record.get('codigoProveedorRem');
			record.data.codigo = codigoProveedor;
			me.getView().fireEvent('abrirDetalleProveedor', record);
		} else if (!Ext.isEmpty(idFalsoProv)) {
			record.data.id = idFalsoProv;
			var codigoProveedor = record.get('codigoProveedorRem');
			record.data.codigo = codigoProveedor;
			me.getView().fireEvent('abrirDetalleProveedor', record);
		} else if (!Ext.isEmpty(record.get('id'))) {
			var codigoProveedor = record.get('codigoProveedorRem');
			record.data.codigo = codigoProveedor;
			me.getView().fireEvent('abrirDetalleProveedor', record);
		}
	},

	onClickAbrirGastoProveedor : function(grid, record) {
		var me = this;
		record.setId(record.data.idGasto);

		me.getView().fireEvent('abrirDetalleGasto', record);

	},

	onClickAbrirGastoProveedorIcono : function(tableView, indiceFila,
			indiceColumna) {
		var me = this;

		var grid = tableView.up('grid');
		var record = grid.store.getAt(indiceFila);
		grid.setSelection(record);
		if (!Ext.isEmpty(record.get('id'))) {
			// me.redirectTo('activos', true);
			record.setId(record.data.idGasto);
			me.getView().fireEvent('abrirDetalleGasto', record);
		}
	},

	// Este mÃ©todo obtiene los valores de las fechas fin e inicio de la fila
	// que se estÃ¡ editando
	// y comprueba las validaciones oportunas.
	validateFechas : function(datefield, value) {
		var me = this;
		var grid = me.lookupReference('gridPreciosVigentes');
		if (Ext.isEmpty(grid)) {
			return true;
		}
		var selected = grid.getSelectionModel().getSelection();
		// Obtener columnas automÃ¡ticamente por 'dataindex = fechaFin' y
		// 'dataindex = fechaInicio'.
		var fechaFinActualRow = grid.columns[Ext.Array.indexOf(Ext.Array.pluck(
						grid.columns, 'dataIndex'), 'fechaFin')];
		var fechaInicioActualRow = grid.columns[Ext.Array.indexOf(Ext.Array
						.pluck(grid.columns, 'dataIndex'), 'fechaInicio')];

		if (!Ext.isEmpty(selected)) {
			// Almacenar la fila selecciona para cuando estÃ© siendo editada.
			grid.codigoTipoPrecio = selected[0].getData().codigoTipoPrecio;
		}

		// Constantes.
		var tipoMinimoAutorizado = '04';
		var tipoAprobadoVentaWeb = '02';
		var tipoAprobadoRentaWeb = '03';
		var tipoDescuentoAprobado = '07';
		var tipoDescuentoPublicadoWeb = '13';

		// Recogemos los valores actuales del grid y los mismos almacenados en
		// el store segÃºn
		// casos.
		var fechaInicioMinimo = fechaInicioActualRow.getEditor().value;
		var fechaInicioExistenteMinimo = grid.getStore().findRecord(
				'codigoTipoPrecio', tipoMinimoAutorizado).getData().fechaInicio;
		var fechaFinMinimo = grid.getStore().findRecord('codigoTipoPrecio',
				tipoMinimoAutorizado).getData().fechaFin;
		var fechaFinAprobadoVentaWeb = fechaFinActualRow.getEditor().value;
		var fechaFinExistenteAprobadoVentaWeb = grid.getStore().findRecord(
				'codigoTipoPrecio', tipoAprobadoVentaWeb).getData().fechaFin;
		var fechaInicioAprobadoVentaWeb = fechaInicioActualRow.getEditor().value;
		var fechaInicioExistenteAprobadoVentaWeb = grid.getStore().findRecord(
				'codigoTipoPrecio', tipoAprobadoVentaWeb).getData().fechaInicio;
		var fechaInicioDescuentoAprobado = fechaInicioActualRow.getEditor().value;
		var fechaInicioExistenteDescuentoAprobado = grid.getStore().findRecord(
				'codigoTipoPrecio', tipoDescuentoAprobado).getData().fechaInicio;
		var fechaFinDescuentoAprobado = fechaFinActualRow.getEditor().value;
		var fechaFinExistenteDescuentoAprobado = grid.getStore().findRecord(
				'codigoTipoPrecio', tipoDescuentoAprobado).getData().fechaFin;
		var fechaInicioDescuentoPublicadoWeb = fechaInicioActualRow.getEditor().value;
		var fechaFinDescuentoPublicadoWeb = fechaFinActualRow.getEditor().value;
		var fechaInicioExistenteDescuentoPublicadoWeb = grid.getStore()
				.findRecord('codigoTipoPrecio', tipoDescuentoPublicadoWeb)
				.getData().fechaInicio;
		var fechaFinExistenteDescuentoPublicadoWeb = grid.getStore()
				.findRecord('codigoTipoPrecio', tipoDescuentoPublicadoWeb)
				.getData().fechaFin;

		var codTipoPrecio = grid.codTipoPrecio;

		switch (codTipoPrecio) {
			case tipoMinimoAutorizado :
				if (datefield.dataIndex === 'fechaInicio') {
					// La fecha de inicio
					if (Ext.isEmpty(fechaInicioMinimo)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					} else {
						if (fechaInicioMinimo > new Date()) {
							// Ha de ser menor o igual a hoy
							return HreRem
									.i18n('info.datefield.begin.date.today.msg.validacion');
						}
					}
				}
				return true;
			case tipoAprobadoVentaWeb : // La fecha de fin de aprobado
										// venta(web) debe ser menor o
				// igual a la fecha fin mÃ­nimo.
				if (datefield.dataIndex === 'fechaFin') {
					// La fecha de fin
					if (Ext.isEmpty(fechaFinMinimo)
							|| Ext.isEmpty(fechaFinAprobadoVentaWeb)) {
						// Si la fecha contra la que compara o la misma no
						// estÃ¡n definidas, se
						// valida positivo.
						return true;
					}
					if (fechaFinAprobadoVentaWeb > fechaFinMinimo) {
						// Ha de ser menor o igual a la fecha fin mÃ­nimo.
						return HreRem
								.i18n('info.fecha.fin.aprobadoVentaWeb.msg.validacion');
					}
				} else {
					// La fecha de inicio
					if (!Ext.isEmpty(fechaInicioExistenteMinimo)) {
						// Si la fecha inicio mÃ­nimo estÃ¡ definida
						if (!Ext.isEmpty(fechaInicioAprobadoVentaWeb)
								&& fechaInicioAprobadoVentaWeb < fechaInicioExistenteMinimo) {
							// Si la propia fecha estÃ¡ definida, ha de ser
							// mayor o igual que la
							// fecha inicio mÃ­nimo
							return HreRem
									.i18n('info.datefield.begin.date.pav.msg.validacion');
						}
					}
				}
				return true;
			case tipoDescuentoAprobado :
				if (datefield.dataIndex === 'fechaFin') {
					// La fecha de fin
					if (Ext.isEmpty(fechaFinDescuentoAprobado)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if (!Ext.isEmpty(fechaFinExistenteDescuentoPublicadoWeb)
							&& fechaFinExistenteDescuentoPublicadoWeb > fechaFinDescuentoAprobado) {
						// Ha de ser menor o igual que la fecha fin aprobado
						// venta web
						return HreRem
								.i18n('info.datefield.end.date.pdw2.msg.validacion');
					}
				} else {
					// La fecha de inicio
					if (Ext.isEmpty(fechaInicioDescuentoAprobado)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if (!Ext.isEmpty(fechaInicioExistenteDescuentoPublicadoWeb)
							&& fechaInicioExistenteDescuentoPublicadoWeb < fechaInicioDescuentoAprobado) {
						// Ha de ser mayor o igual que la fecha inicio aprobado
						// venta web
						return HreRem
								.i18n('info.datefield.begin.date.pdw2.msg.validacion');
					}
				}
				return true;
			case tipoDescuentoPublicadoWeb :
				if (datefield.dataIndex === 'fechaFin') {
					// La fecha de fin
					if (Ext.isEmpty(fechaFinDescuentoPublicadoWeb)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if (!Ext.isEmpty(fechaInicioExistenteDescuentoAprobado)
							&& fechaInicioDescuentoPublicadoWeb < fechaInicioExistenteDescuentoAprobado) {
						// Ha de ser mayor o igual que la fecha fin descuento
						// aprobado, si existe
						return HreRem
								.i18n('info.datefield.begin.date.pdw.msg.validacion');
					}
					if (!Ext.isEmpty(fechaFinExistenteDescuentoAprobado)
							&& fechaFinExistenteDescuentoAprobado < fechaFinDescuentoPublicadoWeb) {
						// Ha de ser mayor o igual que la fecha fin aprobado
						// venta web, si existe
						return HreRem
								.i18n('info.datefield.end.date.descuento.web');
					}
				} else {
					// La fecha de inicio
					if (Ext.isEmpty(fechaInicioDescuentoPublicadoWeb)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if (!Ext.isEmpty(fechaFinExistenteDescuentoAprobado)
							&& fechaInicioDescuentoPublicadoWeb < fechaInicioExistenteDescuentoAprobado) {
						// Ha de ser menor o igual que la fecha inicio descuento
						// aprobado, si existe
						return HreRem
								.i18n('info.datefield.begin.date.pdw.msg.validacion');
					}
					// if(!Ext.isEmpty(fechaFinExistenteAprobadoVentaWeb) &&
					// fechaInicioDescuentoPublicadoWeb >
					// fechaFinExistenteAprobadoVentaWeb) {
					// // Ha de ser menor o igual que la fecha inicio aprobado
					// venta web, si existe
					// return
					// HreRem.i18n('info.datefield.begin.date.pdw.msg.validacion.dos');
					// }
				}
				return true;
			default :
				return true;
		}
	},

	// Este mÃ©todo obtiene el valor del campo importe que se estÃ¡ editando
	// y comprueba las
	// validaciones oportunas.
	// comprueba las validaciones oportunas.
	validatePreciosVigentes : function(value) {
		var me = this;
		var grid = me.lookupReference('gridPreciosVigentes');
		if (Ext.isEmpty(grid)) {
			return true;
		}
		var selected = grid.getSelectionModel().getSelection();
		// Obtener columna automÃ¡ticamente por 'dataindex = importe'.
		var importeActualColumn = grid.columns[Ext.Array.indexOf(Ext.Array
						.pluck(grid.columns, 'dataIndex'), 'importe')];

		if (!Ext.isEmpty(selected)) {
			// Almacenar la fila selecciona para cuando estÃ© siendo editada.
			grid.codTipoPrecio = selected[0].getData().codigoTipoPrecio;
		}

		// Constantes.
		var tipoMinimoAutorizado = '04';
		var tipoAprobadoVentaWeb = '02';
		var tipoAprobadoRentaWeb = '03';
		var tipoDescuentoAprobado = '07';
		var tipoDescuentoPublicadoWeb = '13';

		// Recogemos los valores actuales del grid
		var importeMinimo = parseFloat(grid.getStore().findRecord(
				'codigoTipoPrecio', tipoMinimoAutorizado).getData().importe);
		var importeDescuentoAprobado = parseFloat(grid.getStore().findRecord(
				'codigoTipoPrecio', tipoDescuentoAprobado).getData().importe);
		var importeDecuentoPublicadoWeb = parseFloat(grid.getStore()
				.findRecord('codigoTipoPrecio', tipoDescuentoPublicadoWeb)
				.getData().importe);
		var importeAprobadoVentaWeb = parseFloat(grid.getStore().findRecord(
				'codigoTipoPrecio', tipoAprobadoVentaWeb).getData().importe);

		var codTipoPrecio = grid.codTipoPrecio;

		switch (codTipoPrecio) {
			case tipoMinimoAutorizado : // MÃ­nimo <= Aprobado venta web.

				var importeActualMinimo = importeActualColumn.getEditor().value;

				if (!Ext.isEmpty(importeActualMinimo)
						&& !Ext.isEmpty(importeAprobadoVentaWeb)
						&& (importeActualMinimo > importeAprobadoVentaWeb)) {
					return HreRem
							.i18n('info.precio.importe.minimo.msg.validacion');
				}
				return true;

			case tipoDescuentoAprobado : // Descuento aprobado <= Descuento
											// web <= Aprobado venta web

				var importeActualDescuentoAprobado = importeActualColumn
						.getEditor().value;

				if (!Ext.isEmpty(importeActualDescuentoAprobado)
						&& !Ext.isEmpty(importeDecuentoPublicadoWeb)
						&& (importeActualDescuentoAprobado > importeDecuentoPublicadoWeb)) {
					return HreRem
							.i18n('info.precio.importe.descuentoAprobado.msg.validacion');
				}
				//
				// if(!Ext.isEmpty(importeActualDescuentoAprobado) &&
				// !Ext.isEmpty(importeAprobadoVentaWeb) &&
				// (importeActualDescuentoAprobado > importeAprobadoVentaWeb)){
				// return
				// HreRem.i18n('info.precio.importe.descuentoAprobado.msg.validacion');
				// }

				return true;

			case tipoDescuentoPublicadoWeb : // Descuento aprobado <=
												// Descuento Web <= Aprobado
												// venta
				// web.

				var importeActualDescuentoWeb = importeActualColumn.getEditor().value;

				if (!Ext.isEmpty(importeActualDescuentoWeb)
						&& !Ext.isEmpty(importeDescuentoAprobado)
						&& (importeActualDescuentoWeb < importeDescuentoAprobado)) {
					return HreRem
							.i18n('info.precio.importe.descuentoPublicadoWeb.msg.validacion');
				}

				// if(!Ext.isEmpty(importeActualDescuentoWeb) &&
				// !Ext.isEmpty(importeAprobadoVentaWeb) &&
				// (importeActualDescuentoWeb > importeAprobadoVentaWeb)) {
				// return
				// HreRem.i18n('info.precio.importe.descuentoPublicadoWeb.msg.validacion');
				// }

				return true;

			case tipoAprobadoVentaWeb : // MÃ­nimo <= Aprobado venta web.

				var importeActualAprobadoVentaWeb = importeActualColumn
						.getEditor().value;

				if (!Ext.isEmpty(importeActualAprobadoVentaWeb)
						&& !Ext.isEmpty(importeMinimo)
						&& (importeActualAprobadoVentaWeb < importeMinimo)) {
					return HreRem
							.i18n('info.precio.importe.aprobadoVenta.msg.validacion');
				}

				// if(!Ext.isEmpty(importeActualAprobadoVentaWeb) &&
				// !Ext.isEmpty(importeDescuentoAprobado) &&
				// (importeActualAprobadoVentaWeb < importeDescuentoAprobado)) {
				// return
				// HreRem.i18n('info.precio.importe.aprobadoVenta.msg.validacion');
				// }

				// if(!Ext.isEmpty(importeActualAprobadoVentaWeb) &&
				// !Ext.isEmpty(importeDecuentoPublicadoWeb) &&
				// (importeActualAprobadoVentaWeb <
				// importeDecuentoPublicadoWeb)) {
				// return
				// HreRem.i18n('info.precio.importe.aprobadoVenta.msg.validacion');
				// }

				return true;

			default :
				return true;
		}
	},

	// Este mÃ©todo desmarca el checkbox de formalizar cuando el checkbox de
	// comercializar se
	// desmarca.
	onChkbxPerimetroChange : function(chkbx) {
		var me = this;
		var ref = chkbx.getReference();
		var val = me.checkOfertaTrabajoVivo(ref);
		// Si se quita comercializar, hay que quitar tambien los datos de
		// formalizacion en perimetro
		var chkbxPerimetroComercializar = me
				.lookupReference('chkbxPerimetroComercializar');
		var textFieldPerimetroComer = me
				.lookupReference('textFieldPerimetroComer');
		var comboMotivoPerimetroComer = me
				.lookupReference('comboMotivoPerimetroComer');
		var chkbxFormalizar = me.lookupReference('chkbxPerimetroFormalizar');
		var perimetroAdmision = me.lookupReference('perimetroAdmision');
		var chkbxPerimetroPublicar = me.lookupReference('chkbxPerimetroPublicar');
		var textFieldFormalizar = me
				.lookupReference('textFieldPerimetroFormalizar');
		var textFieldPerimetroGestion = me
				.lookupReference('textFieldPerimetroGestion');
		var textFieldPerimetroAdmision = me
				.lookupReference('textFieldPerimetroAdmision');
		var textFieldPerimetroPublicar = me
				.lookupReference('textFieldPerimetroPublicar');

		if (!val) {
			switch (ref) {
				case 'chkbxPerimetroComercializar' :
					if (!Ext.isEmpty(chkbxPerimetroComercializar.getValue())
							&& chkbxPerimetroComercializar.getValue()) {
						comboMotivoPerimetroComer.reset();
						textFieldPerimetroComer.reset();
					} else {
						textFieldPerimetroComer.reset();
						chkbxFormalizar.setValue(false);
						textFieldFormalizar.reset();
					}
					break;

				case 'chkbxPerimetroGestion' :
					textFieldPerimetroGestion.reset();
					break;

				case 'chkbxPerimetroFormalizar' :
					if (!chkbxFormalizar.getValue()
							&& chkbxPerimetroComercializar.getValue()) {
						chkbxFormalizar.setValue(true);
						me
								.fireEvent(
										"errorToast",
										HreRem
												.i18n("msg.error.perimetro.desmarcar.formalizar.con.comercializar.activado"));
					} else if (chkbxFormalizar.getValue()
							&& !chkbxPerimetroComercializar.getValue()) {
						chkbxFormalizar.setValue(false);
						me
								.fireEvent(
										"errorToast",
										HreRem
												.i18n("msg.error.perimetro.marcar.formalizar.con.comercializar.desactivado"));
					} else {
						textFieldFormalizar.reset();
					}
					break;
					
				case 'perimetroAdmision' :
					textFieldPerimetroAdmision.reset();
					break;
					
				case 'chkbxPerimetroPublicar' :
					textFieldPerimetroPublicar.reset();
					break;
					
				default :
					break;
			}
		} else {
			switch (ref) {
				case 'chkbxPerimetroFormalizar' :
					if (!chkbxFormalizar.getValue()
							&& chkbxPerimetroComercializar.getValue()) {
						chkbxFormalizar.setValue(true);
						me
								.fireEvent(
										"errorToast",
										HreRem
												.i18n("msg.error.perimetro.desmarcar.formalizar.con.comercializar.activado"));
					} else if (chkbxFormalizar.getValue()
							&& !chkbxPerimetroComercializar.getValue()) {
						chkbxFormalizar.setValue(false);
						me
								.fireEvent(
										"errorToast",
										HreRem
												.i18n("msg.error.perimetro.marcar.formalizar.con.comercializar.desactivado"));
					} else {
						textFieldFormalizar.reset();
					}
					break;
				default :
					break;
			}

		}
	},

	abrirFormularioAnyadirEntidadActivo : function(grid) {
		var me = this, record = Ext.create("HreRem.model.ActivoIntegrado"),
		idActivo = me.getViewModel().get("activo.id");
		record.set("idActivo", idActivo);
		Ext.create("HreRem.view.activos.detalle.AnyadirEntidadActivo", {
					parent : grid,
					idActivo : idActivo
				}).show();
	},

	onClickBotonCancelarEntidad : function(btn) {
		var me = this, window = btn.up('window');
		var form = window.down('formBase');
		form.reset();
		window.destroy();
	},

	buscarProveedor : function(field, e) {
		var me = this;
		var url = $AC
				.getRemoteUrl('gastosproveedor/searchProveedorCodigoByTipoEntidad');
		var codigoUnicoProveedor = field.getValue();
		var codigoTipoProveedor = CONST.TIPOS_PROVEEDOR['ENTIDAD'];
		var data;
		var nifEmisorField = field.up('formBase').down('[name=nifProveedor]');
		nombreProveedorField = field.up('formBase')
				.down('[name=nombreProveedor]'), subtipoProveedorField = field
				.up('formBase').down('[name=subtipoProveedorField]');

		if (!Ext.isEmpty(codigoUnicoProveedor)) {
			Ext.Ajax.request({

				url : url,
				params : {
					codigoUnicoProveedor : codigoUnicoProveedor,
					codigoTipoProveedor : codigoTipoProveedor
				},
				success : function(response, opts) {
					data = Ext.decode(response.responseText);
					if (!Utils.isEmptyJSON(data.data)) {
						var id = data.data.id;
						var nombreProveedor = data.data.nombreProveedor;
						var nifProveedor = data.data.nifProveedor;
						var subtipoProveedorDescripcion = data.data.subtipoProveedorDescripcion;

						if (!Ext.isEmpty(nifEmisorField)) {
							nifEmisorField.setValue(nifProveedor);
						}
						if (!Ext.isEmpty(nombreProveedorField)) {
							nombreProveedorField.setValue(nombreProveedor);
						}
						if (!Ext.isEmpty(subtipoProveedorField)) {
							subtipoProveedorField
									.setValue(subtipoProveedorDescripcion);
						}
					} else {
						if (!Ext.isEmpty(nombreProveedorField)) {
							nombreProveedorField.setValue('');
						}
						if (!Ext.isEmpty(nifEmisorField)) {
							nifEmisorField.setValue('');
						}
						if (!Ext.isEmpty(subtipoProveedorField)) {
							subtipoProveedorField.setValue('');
						}
						me
								.fireEvent(
										"errorToast",
										HreRem
												.i18n("msg.buscador.no.encuentra.proveedor.codigo"));
					}
				},
				failure : function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				},
				callback : function(options, success, response) {
				}
			});
		} else {
			nombreProveedorField.setValue('');
			nifEmisorField.setValue('');
			subtipoProveedorField.setValue('');
		}
	},

	onClickBotonGuardarEntidad : function(btn) {
		var me = this;
		var window = btn.up('window'), form = window.down('formBase');
		// var success = function (a, operation, c) {
		// me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		// me.getView().unmask();
		// me.refrescarGasto(btn.up('tabpanel').getActiveTab().refreshAfterSave);
		// };

		me.onSaveFormularioCompletoActivoIntegrado(null, form);
	},

	onSaveFormularioCompletoActivoIntegrado : function(btn, form) {
		var me = this;
		var window = form.up('window');
		// disableValidation: Atributo para indicar si el guardado del
		// formulario debe aplicar o no,
		// las validaciones.
		if (form.isFormValid() || form.disableValidation) {

			Ext.Array.each(form.query('field[isReadOnlyEdit]'), function(field,
							index) {
						field.fireEvent('update');
						field.fireEvent('save');
					});

			if (!Ext.isEmpty(btn)) {
				btn.hide();
				btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
				btn.up('tabbar').down('button[itemId=botoneditar]').show();

				if (Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
					me.getViewModel().set("editingFirstLevel", false);
				} else {
					me.getViewModel().set("editing", false);
				}
				me.getViewModel().notify();
			}

			if (!form.saveMultiple) {

				if (Ext
						.isDefined(form.getBindRecord().getProxy().getApi().create)) {
					form.getBindRecord().getProxy().extraParams.idActivo = form
							.down('field[name=idActivo]').getValue();
				}

				if (form.getBindRecord() != null
						&& (Ext.isDefined(form.getBindRecord().getProxy()
								.getApi().create) || Ext.isDefined(form
								.getBindRecord().getProxy().getApi().update))) {
					// Si la API tiene metodo de escritura (create or update).
					me.getView().mask(HreRem.i18n("msg.mask.loading"));

					form.getBindRecord().save({
						success : function(a, operation, c) {
							me.fireEvent("infoToast", HreRem
											.i18n("msg.operacion.ok"));
							me.getView().unmask();
							form.reset();
							window.parent.up('datoscomunidadactivo')
									.funcionRecargar();
							window.close();
						},

						failure : function(a, operation) {
							me.fireEvent("errorToast", HreRem
											.i18n("msg.operacion.ko"));
							me.getView().unmask();
						}
					});
				}
				// Guardamos mÃºltiples records
			} else {
				var records = form.getBindRecords();
				var contador = 0;
				me.saveMultipleRecords(contador, records, form);
			}
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}

	},

	onRetenerPagosChange : function(combo, a, b) {
		var me = this;
		var form = combo.up('formBase');
		var motivoRetencionField = form.down('[name=motivoRetencion]');
		var fechaInicioRetencionField = form.down('[name=fechaInicioRetencion]');

		if (!combo.getValue()) {
			motivoRetencionField.reset();
			fechaInicioRetencionField.reset();
			motivoRetencionField.setDisabled(true);
			fechaInicioRetencionField.setDisabled(true);
			me.getViewModel().set("activoIntegrado.pagosRetenidos", 0);
		} else {
			motivoRetencionField.setDisabled(false);
			fechaInicioRetencionField.setDisabled(false);
			me.getViewModel().set("activoIntegrado.pagosRetenidos", 1);
		}
	},

	onEntidadesListDobleClick : function(gridView, record) {
		var me = this;
		var idActivoIntegrado = record.get('id');
		var idActivo = me.getViewModel().get("activo.id");
		var storeGrid = gridView.store;
		Ext.create("HreRem.view.activos.detalle.AnyadirEntidadActivo", {
					parent : gridView,
					modoEdicion : true,
					storeGrid : storeGrid,
					idActivo : idActivo,
					idActivoIntegrado: idActivoIntegrado
				}).show();

	},

	cargarDatosActivoIntegrado : function(window) {
		var me = this, model = null, models = null, nameModels = null, id = window.idActivoIntegrado;

		if (!Ext.isEmpty(id)) {
			var form = window.down('formBase');
			form.mask(HreRem.i18n("msg.mask.loading"));
			if (!form.saveMultiple) {
				model = form.getModelInstance(), model.setId(id);
				if (Ext.isDefined(model.getProxy().getApi().read)) {
					// Si la API tiene metodo de lectura (read).
					model.load({
								success : function(record) {
									form.setBindRecord(record);
									form.unmask();
									if (Ext.isFunction(form.afterLoad)) {
										form.afterLoad();
									}
								},
								failure : function(record) {
									me.fireEvent("errorToast", HreRem
													.i18n("msg.operacion.ko"));
									me.getView().unmask();
								}
							});
				}
			}
		}

		var form = window.down('formBase');
		form.setBindRecord(Ext.create('HreRem.model.ActivoIntegrado'));
		window.down('field[name=idActivo]').setValue(window.idActivo);

		Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
				function(field, index) {
					field.fireEvent('edit');
					if (index == 0)
						field.focus();
				});
	},

	beforeLoadLlaves : function(store, operation, opts) {
		var me = this, idActivo = this.getViewModel().get('activo').id;
		me.lookupReference('movimientosllavelistref').disableAddButton(true);

		if (idActivo != null) {
			store.getProxy().extraParams = {
				idActivo : idActivo
			};

			return true;
		}
	},

	onLlavesListClick : function(grid, record) {
		var me = this;

		me.lookupReference('fieldsetmovimientosllavelist').expand();
		me.lookupReference('movimientosllavelistref').getStore().loadPage(1);

		if (!Ext.isEmpty(record.id))
			me.lookupReference('movimientosllavelistref')
					.disableAddButton(false);
	},

	beforeLoadMovimientosLlave : function(store, operation, opts) {

		var me = this;
		if (!Ext.isEmpty(me.getViewModel().get('llaveslistref').selection)) {
			var idLlave = me.getViewModel().get('llaveslistref').selection.id;

			if (idLlave != null && Ext.isNumber(parseInt(idLlave))) {
				store.getProxy().extraParams = {
					idLlave : idLlave
				};

				return true;
			}
		} else {
			store.getProxy().extraParams = {
				idActivo : this.getViewModel().get('activo').id
			};
			me.lookupReference('movimientosllavelistref')
					.disableAddButton(true);
			return true;
		}
	},

	onClickEditRowMovimientosLlaveList : function(editor, context, eOpts) {
		var me = this;

		if (context.rowIdx == 0) {
			var idLlave = me.getViewModel().get('llaveslistref').selection.id;
			context.record.data.idLlave = idLlave;
		}
	},

	// Llamar desde cualquier GridEditableRow, y asÃ­ se desactivaran las
	// ediciones.
	quitarEdicionEnGridEditablePorFueraPerimetro : function(grid, record) {
		var me = this;

		if (me.getViewModel().get('activo').get('incluidoEnPerimetro') == "false") {
			grid.setTopBar(false);
			grid.editOnSelect = false;
		}
	},

	// Este mÃ©todo filtra los anyos de construcciÃ³n y rehabilitaciÃ³n de
	// una vivienda
	// de modo que si el value es '0' lo quita. Es una medida de protecciÃ³n
	// al v-type
	// por que en la DB estÃ¡n establecidos a 0 todos los activos.
	onAnyoChange : function(field) {
		if (!Ext.isEmpty(field.getValue()) && field.getValue() === '0') {
			field.setValue('');
		}
	},

	valdacionesEdicionLlavesList : function(editor, grid) {
		var me = this, textMotivo = me.lookupReference('motivoIncompletoRef'), comboCompleto = me
				.lookupReference('cbColCompleto');

		if (editor.isNew) {
			comboCompleto.setValue();
			textMotivo.setValue();
		}

		var activar = comboCompleto.getValue() == "0"
				&& textMotivo.getValue() != null;
		me.activarDesactivarCampo(textMotivo, activar);

		var mostrarObligatoriedad = comboCompleto.getValue() == "0"
				&& (textMotivo.getValue() == null || textMotivo.getValue() == "");
		me.vaciarCampoMostrarRojoObligatoriedad(textMotivo,
				mostrarObligatoriedad, comboCompleto.getValue() == "1")

	},

	// Activa o desactiva el campo
	activarDesactivarCampo : function(campo, activar) {

		if (activar) {
			campo.setDisabled(false);
			campo.allowBlank = false;
		} else {
			campo.setValue();
			campo.setDisabled(true);
			campo.allowBlank = true;

		}
	},

	// Este mÃ©todo se usa para marcar en rojo el campo en primera instancia,
	// o vaciar su contenido
	vaciarCampoMostrarRojoObligatoriedad : function(campo,
			mostrarObligatoriedad, vaciarCampo) {
		if (mostrarObligatoriedad) {
			campo.setValue(' ');
			campo.setValue();
		} else if (vaciarCampo)
			campo.setValue();
	},

	// Este mÃ©todo es llamado cuando se pulsa el botÃ³n 'ver' del ID de
	// visita en el detalle de una
	// oferta
	// y abre un pop-up con informaciÃ³n sobre la visita.
	onClickMostrarVisita : function(btn) {
		var me = this;
		var model = me.getViewModel().get('detalleOfertaModel');

		if (Ext.isEmpty(model)) {
			return;
		}

		var numVisita = model.get('numVisitaRem');

		if (Ext.isEmpty(numVisita)) {
			return;
		}

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		Ext.Ajax.request({
			url : $AC.getRemoteUrl('visitas/getVisitaDetalleById'),
			params : {
				numVisitaRem : numVisita
			},

			success : function(response, opts) {
				var record = JSON.parse(response.responseText);
				if (record.success === 'true') {
					var ventana = Ext
							.create(
									'HreRem.view.comercial.visitas.VisitasComercialDetalle',
									{
										detallevisita : record
									});
					me.getView().add(ventana);
					ventana.show();
				} else {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
			},
			failure : function(record, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			},
			callback : function(record, operation) {
				me.getView().unmask();
			}
		});
	},

	// Este mÃ©todo es llamado cuando se selecciona una oferta del listado de
	// ofertas del activo.
	// Obtiene el ID de la oferta y carga sus detalles en la secciÃ³n 'Detalle
	// ofertas'.
	onOfertaListClick : function(grid, record) {
		var me = this, form = grid.up("form"), model = Ext
				.create('HreRem.model.DetalleOfertaModel'), idOferta = null;
		var activo = me.getViewModel().get('activo');
		idActivo = activo.get('id');

		if (!Ext.isEmpty(grid.selection)) {
			idOferta = record.get("idOferta");
		}

		var fieldset = me.lookupReference('detalleOfertaFieldsetref');
		fieldset.mask(HreRem.i18n("msg.mask.loading"));

		// Cargar grid 'ofertantes'.
		var storeOfertantes = me.getViewModel().getData().storeOfertantesOfertaDetalle;
		storeOfertantes.getProxy().getExtraParams().ofertaID = idOferta;
		storeOfertantes.load({
					success : function(record) {
						me.lookupReference('ofertanteslistdetalleofertaref')
								.refresh();
					}
				});

		// Cargar grid 'honorarios'.
		var storeHonorarios = me.getViewModel().getData().storeHonorariosOfertaDetalle;
		storeHonorarios.getProxy().getExtraParams().idOferta = idOferta;
		storeHonorarios.getProxy().getExtraParams().idActivo = idActivo;

		storeHonorarios.load({
					success : function(record) {
						me.lookupReference('honorarioslistdetalleofertaref')
								.refresh();
					}
				});

		// Cargar el modelo de los detalles de oferta.
		model.setId(idOferta);
		model.load({
					success : function(record) {
						me.getViewModel().set("detalleOfertaModel", record);
						fieldset.unmask();
					}
				});
	},

	// Este mÃ©todo abre el activo o agrupaciÃ³n asociado a la oferta en el
	// grid de ofertas del
	// activo.
	onClickAbrirActivoAgrupacion : function(tableView, indiceFila,
			indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
		var record = grid.store.getAt(indiceFila);
		grid.setSelection(record);
		if (Ext.isEmpty(record.get('idAgrupacion'))) {
			var idActivo = record.get("idActivo");
			me.redirectTo('activos', true);
			me.getView().fireEvent('abrirDetalleActivoOfertas', record);
		} else {
			var idAgrupacion = record.get("idAgrupacion");
			me.getView().fireEvent('abrirDetalleActivoOfertas', record);
		}

	},
	onClickBotonGuardarInfoFoto : function(btn) {
		var me = this;
		var tienePrincipal = false;
		form = btn.up('tabpanel').getActiveTab().getForm();
		if (form.isValid()){
			btn.up('tabpanel').mask();
			var fotosActuales = btn.up('tabpanel').getActiveTab().down('dataview')
					.getStore().data.items;
			for (i = 0; i < fotosActuales.length; i++) {
				if (form.getValues().id != fotosActuales[i].data.id
						&& form.getValues().principal) {
					console.log(i + " id" + fotosActuales[i].data.id)
					console.log(i + " es princpal ?"
							+ fotosActuales[i].data.principal)
					console.log(i + " interior exterior ? "
							+ fotosActuales[i].data.interiorExterior)
					if (fotosActuales[i].data.principal == 'true'
							&& form.getValues().interiorExterior.toString() == fotosActuales[i].data.interiorExterior) {
						tienePrincipal = true;
						break;
					}
				}
			}
			if (!tienePrincipal) {
				var url = $AC.getRemoteUrl('activo/updateFotosById');
				var tienePrincipal = false;
				var params = {
					"id" : form.findField("id").getValue()
				};
				if (form.findField("nombre") != null) {
					params['nombre'] = form.findField("nombre").getValue();
				}
				if (form.findField("principal") != null) {
					params['principal'] = form.findField("principal").getValue();
				}
				if (form.findField("interiorExterior") != null) {
					params['interiorExterior'] = form.findField("interiorExterior")
							.getValue();
				}
				if (form.findField("orden") != null) {
					params['orden'] = form.findField("orden").getValue();
				}
				if (form.findField("codigoDescripcionFoto") != null) {
					params['codigoDescripcionFoto'] = form.findField("codigoDescripcionFoto")
							.getValue();
				}
				if (form.findField("codigoTipoFoto") != null) {
					params['codigoTipoFoto'] = form.findField("codigoTipoFoto").getValue();
				}
				if (form.findField("fechaDocumento") != null) {
					params['fechaDocumento'] = form.findField("fechaDocumento")
							.getValue();
				}
	
				Ext.Ajax.request({
					url : url,
					params : params,
					success : function(a, operation, context) {
						btn.up('tabpanel').unmask();
						me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						me.onClickBotonRefrescar();
						btn.hide();
						btn.up('tabbar').down('button[itemId=botonguardar]').hide();
						btn.up('tabbar').down('button[itemId=botoneditar]').show();
						Ext.Array.each(btn.up('tabpanel').getActiveTab()
										.query('field[isReadOnlyEdit]'), function(
										field, index) {
									field.fireEvent('save');
									field.fireEvent('update');
								});
						if (Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
							me.getViewModel().set("editingFirstLevel", false);
						} else {
							me.getViewModel().set("editing", false);
						}
						me.getViewModel().notify();
					},
					failure : function(a, operation, context) {
						Ext.toast({
									html : 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
									width : 360,
									height : 100,
									align : 't'
								});
						btn.up('tabpanel').unmask();
					}
				});
			} else {
				me.fireEvent("errorToast", "Ya dispone de una foto principal");
				btn.up('tabpanel').unmask();
			}
		}
	},

	onClickMostrarPrescriptorVisita : function(btn) {
		var me = this;
		var record = btn.up('visitascomercialdetalle').getViewModel()
				.get('detallevisita');
		var codigoProveedor = record.codigoPrescriptorREM;
		var titulo = 'Proveedor ' + codigoProveedor;
		var idProveedor = record.idPrescriptorREM;

		me.getView().fireEvent('abrirDetalleProveedorDirectly', idProveedor,
				titulo);
	},

	onClickMostrarCustodioVisita : function(btn) {
		var me = this;
		var record = btn.up('visitascomercialdetalle').getViewModel()
				.get('detallevisita');
		var codigoProveedor = record.codigoCustodioREM;
		var titulo = 'Proveedor ' + codigoProveedor;
		var idProveedor = record.idCustodioREM;

		me.getView().fireEvent('abrirDetalleProveedorDirectly', idProveedor,
				titulo);
	},

	onRenderCargasList : function(grid) {
		var me = this,
		// isCarteraCajamar = me.getViewModel().get("activo.isCarteraCajamar"),
		items = grid.getDockedItems('toolbar[dock=top]');
		if (items.length > 0) {
			items[0].setVisible(true);
		}
	},

	onCargasListDobleClick : function(grid, record) {
		var me = this;
		var isCarteraSareb = me.getViewModel().get("activo.isCarteraSareb");
		var isCarteraBankia = me.getViewModel().get("activo.isCarteraBankia");
		if ((CONST.ORIGEN_DATO['REM'] === record.getData().origenDatoCodigo)
				|| ((CONST.ORIGEN_DATO['RECOVERY'] === record.getData().origenDatoCodigo) && isCarteraSareb)
				|| ((CONST.ORIGEN_DATO['PRISMA'] === record.getData().origenDatoCodigo) && isCarteraSareb)) {
			Ext.create("HreRem.view.activos.detalle.CargaDetalle", {
						carga : record,
						parent : grid.up("form"),
						modoEdicion : true
					}).show();
		} else if ((CONST.ORIGEN_DATO['RECOVERY'] === record.getData().origenDatoCodigo)
				&& isCarteraBankia) {
			Ext.create("HreRem.view.activos.detalle.CargaDetalle", {
						carga : record,
						parent : grid.up("form"),
						modoEdicion : false
					}).show();
		}

	},

	abrirFormularioAnyadirCarga : function(grid) {
		var me = this, record = Ext.create("HreRem.model.ActivoCargas");
		record.set("idActivo", me.getViewModel().get("activo.id"));
		Ext.create("HreRem.view.activos.detalle.CargaDetalle", {
					carga : record,
					parent : grid.up("form")
				}).show();
	},

	onClickRemoveCarga : function(grid, record) {

		var me = this, idCarga = record.get("idActivoCarga");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		record.erase({
					params : {
						idActivoCarga : idCarga
					},
					success : function(record, operation) {
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
						me.getView().unmask();
						grid.up().funcionRecargar();
					},
					failure : function(record, operation) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
						me.getView().unmask();
						grid.getStore().load();
					}

				});
	},

	onClickPropagation : function(btn) {

		var me = this, idActivo = me.getViewModel().get('activo').id, url = $AC
				.getRemoteUrl('activo/getActivosPropagables'), form = btn
				.up('form');

		form.mask(HreRem.i18n("msg.mask.espere"));

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params : {
				idActivo : idActivo
			},

			success : function(response, opts) {

				form.unmask();
				var activosPropagables = Ext.decode(response.responseText).data.activosPropagables;
				var tabPropagableData = null;
				if (me.getViewModel() != null) {
					if (me.getViewModel().get('activo') != null) {
						if (me.getViewModel().get('activo').data != null) {
							me.getViewModel().get('activo').data.activosPropagables = activosPropagables;
						}
					}
				}

				var activo = activosPropagables.splice(activosPropagables
								.findIndex(function(activo) {
											return activo.activoId == me
													.getViewModel()
													.get("activo.id");
										}), 1)[0];
				var grid = btn.up().up();
				// Abrimos la ventana de selección de activos

				var ventanaOpcionesPropagacionCambios = Ext
						.create(
								"HreRem.view.activos.detalle.OpcionesPropagacionCambios",
								{
									form : null,
									activoActual : activo,
									activos : activosPropagables,
									tabData : grid.getSelection()[0].data,
									propagableData : null,
									targetGrid : grid.targetGrid
								}).show();

				me.getView().add(ventanaOpcionesPropagacionCambios);
			},

			failure : function(record, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			}
		});
	},

	onClickPropagationCalificacionNegativa : function(grid) {
		var me = this, idActivo = me.getViewModel().get('activo').id, url = $AC
				.getRemoteUrl('activo/getActivosPropagables'), form = grid
				.up('form');

		form.mask(HreRem.i18n("msg.mask.espere"));

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params : {
				idActivo : idActivo
			},

			success : function(response, opts) {

				form.unmask();
				var activosPropagables = Ext.decode(response.responseText).data.activosPropagables;
				var tabPropagableData = null;
				if (me.getViewModel() != null) {
					if (me.getViewModel().get('activo') != null) {
						if (me.getViewModel().get('activo').data != null) {
							me.getViewModel().get('activo').data.activosPropagables = activosPropagables;
						}
					}
				}
				var activo = activosPropagables.splice(activosPropagables
								.findIndex(function(activo) {
											return activo.activoId == me
													.getViewModel()
													.get("activo.id");
										}), 1)[0];

				var algunActivoEstaInscrito = false;
				for (var i = 0; i < activosPropagables.length; i++) {
					if (CONST.DD_ETI_ESTADO_TITULO["INSCRITO"] == activosPropagables[i].estadoTitulo) {
						// activosPropagables.shift(activosPropagables[i]);
						activosPropagables.splice(i, 1);
						algunActivoEstaInscrito = true;
					}
				}

				// Abrimos la ventana de selección de activos
				var ventanaOpcionesPropagacionCambios = Ext
						.create(
								"HreRem.view.activos.detalle.OpcionesPropagacionCambios",
								{
									form : null,
									activoActual : activo,
									activos : activosPropagables,
									tabData : grid.getSelection(),
									propagableData : null,
									targetGrid : grid.targetGrid
								}).show();

				me.getView().add(ventanaOpcionesPropagacionCambios);

				// En caso de que algun activo este incrito, se le alertara al
				// usuario.
				if (algunActivoEstaInscrito) {
					me
							.fireEvent(
									"warnToast",
									"No se podr&aacute; propagar a todos los activos debido a que alguno est&aacute; inscrito");
				}

			},
			failure : function(record, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			}
		});
	},

	onClickPropagationHistoricoCondiciones : function(grid) {
		var me = this, idActivo = me.getViewModel().get('activo').id, url = $AC
				.getRemoteUrl('activo/getActivosPropagables'), form = grid
				.up('form');

		form.mask(HreRem.i18n("msg.mask.espere"));

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params : {
				idActivo : idActivo
			},

			success : function(response, opts) {

				form.unmask();
				var activosPropagables = Ext.decode(response.responseText).data.activosPropagables;
				var tabPropagableData = null;
				if (me.getViewModel() != null) {
					if (me.getViewModel().get('activo') != null) {
						if (me.getViewModel().get('activo').data != null) {
							me.getViewModel().get('activo').data.activosPropagables = activosPropagables;
						}
					}
				}
				var activo = activosPropagables.splice(activosPropagables
								.findIndex(function(activo) {
											return activo.activoId == me
													.getViewModel()
													.get("activo.id");
										}), 1)[0];

				// Abrimos la ventana de selección de activos
				var ventanaOpcionesPropagacionCambios = Ext
						.create(
								"HreRem.view.activos.detalle.OpcionesPropagacionCambios",
								{
									form : null,
									activoActual : activo,
									activos : activosPropagables,
									tabData : grid.getSelection(),
									propagableData : null,
									targetGrid : grid.targetGrid
								}).show();

				me.getView().add(ventanaOpcionesPropagacionCambios);

			},
			failure : function(record, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			}
		});
	},
	
	onVisitasListDobleClick: function(grid,record,tr,rowIndex) {        	       
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	
    	Ext.create('HreRem.view.comercial.visitas.VisitasComercialDetalle',{detallevisita: record}).show();
    	
        	
    },
    
   	onClickBotonCerrarDetalleVisita: function(btn) {
		var me = this,
		window = btn.up('window');
    	window.close();
	},
	
	onProveedoresListClick: function(gridView, record){
		var me=this;
		
		if($AU.userIsRol(CONST.PERFILES['CARTERA_BBVA'])){
			return;
		}
		idProveedor= record.get('idFalso').id;
		idActivo= record.get('idFalso').idActivo;
		
		
		gridView.up('form').down('[reference=listadogastosref]').getStore().getProxy().setExtraParams({'idActivo': idActivo,'idProveedor': idProveedor});
		gridView.up('form').down('[reference=listadogastosref]').getStore().load();
		
		
	},
	
	// Función que abre la pestaña de proveedor.
   abrirPestanyaProveedor: function(tableView, indiceFila, indiceColumna){
   		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
		var recordProveedor = Ext.create("HreRem.model.Proveedor");
	    grid.setSelection(record);
	    var idFalso = record.get('idFalso');
	    var idFalsoProv;
	    if(idFalso != null){
	    	idFalsoProv = record.get('idFalso').id;
	    }
	    
	    if(!Ext.isEmpty(record.get('idProveedor'))){
	    	var idProveedor = record.get("idProveedor");
	    	recordProveedor.set('id', idProveedor);
	    	var codigoProveedor = record.get('codigoProveedorRem');
			recordProveedor.set('codigo', codigoProveedor);
	    	me.getView().fireEvent('abrirDetalleProveedor', recordProveedor);
	    }else if(!Ext.isEmpty(idFalsoProv)){
			recordProveedor.set('id', idFalsoProv);
	    	var codigoProveedor = record.get('codigoProveedorRem');
	    	recordProveedor.set('codigo', codigoProveedor);
	    	me.getView().fireEvent('abrirDetalleProveedor', recordProveedor);
	    }
	    else if(!Ext.isEmpty(record.get('id'))){
	    	var codigoProveedor = record.get('codigoProveedorRem');
	    	recordProveedor.set('codigo', codigoProveedor);
	    	me.getView().fireEvent('abrirDetalleProveedor', recordProveedor);
	    }
   },
   
   	onClickAbrirGastoProveedor: function(grid, record){
		var me = this;
		record.setId(record.data.idGasto);
		
    	me.getView().fireEvent('abrirDetalleGasto', record);
		
	},
	
	onClickAbrirGastoProveedorIcono: function(tableView, indiceFila, indiceColumna){
		var me = this;
		
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    if(!Ext.isEmpty(record.get('id'))){
// me.redirectTo('activos', true);
	    	record.setId(record.data.idGasto);
	    	me.getView().fireEvent('abrirDetalleGasto', record);
	    }
	},

	onClickBotonCancelarCarga : function(btn) {
		var me = this;
		var window = btn.up('window');

		window.parent.funcionRecargar();
		window.destroy();

	},

	onClickBotonGuardarCarga : function(btn) {

		var me = this, form = me.lookupReference("formDetalleCarga"), window = form
				.up('window'), record = form.getBindRecord();

		if (form.isFormValid()) {

			form.mask(HreRem.i18n("msg.mask.espere"));

			record.save({
						success : function(record, operation) {
							me.fireEvent("infoToast", HreRem
											.i18n("msg.operacion.ok"));
							form.unmask();
							window.parent.funcionRecargar();
							window.destroy();
						},
						failure : function(record, operation) {
							var response = Ext
									.decode(operation.getResponse().responseText);
							if (response.success === "false"
									&& Ext.isDefined(response.msg)) {
								me
										.fireEvent(
												"errorToast",
												Ext
														.decode(operation
																.getResponse().responseText).msg);
							} else {
								me.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
							}
							form.unmask();
						}

					});
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}

	},
	buscarPrescriptor : function(field, e) {

		var me = this;
		var url = $AC.getRemoteUrl('proveedores/searchProveedorCodigo');
		var codPrescriptor = field.getValue();
		var data;
		var re = new RegExp("^((04$))|^((18$))|^((28$))|^((29$))|^((31$))|^((37$))|^((30$))|^((35$))|^((23$))|^((38$)).*$");

		Ext.Ajax.request({

			url : url,
			params : {
				codigoUnicoProveedor : codPrescriptor
			},

			success : function(response, opts) {
				data = Ext.decode(response.responseText);
				var buscadorPrescriptor = field.up('formBase')
						.down('[name=buscadorPrescriptores]'), nombrePrescriptorField = field
						.up('formBase').down('[name=nombrePrescriptor]');

				if (!Utils.isEmptyJSON(data.data)) {
					var id = data.data.id;
					var tipoProveedorCodigo = data.data.tipoProveedor.codigo;

					var nombrePrescriptor = data.data.nombre;

					if (re.test(tipoProveedorCodigo)) {
						if (!Ext.isEmpty(buscadorPrescriptor)) {
							buscadorPrescriptor.setValue(codPrescriptor);
						}
						if (!Ext.isEmpty(nombrePrescriptorField)) {
							nombrePrescriptorField.setValue(nombrePrescriptor);

						}
					} else {
						nombrePrescriptorField.setValue('');
						me
								.fireEvent("errorToast",
										"El cÃ³digo del Proveedor introducido no es un Prescriptor");
					}
				} else {
					if (!Ext.isEmpty(nombrePrescriptorField)) {
						nombrePrescriptorField.setValue('');
					}
					me
							.fireEvent(
									"errorToast",
									HreRem
											.i18n("msg.buscador.no.encuentra.proveedor.codigo"));
					buscadorPrescriptor
							.markInvalid(HreRem
									.i18n("msg.buscador.no.encuentra.proveedor.codigo"));
				}
			},
			failure : function(response) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			},
			callback : function(options, success, response) {
			}
		});
	},

	buscarSucursal : function(field, e) {

		var me = this;
		var url = $AC.getRemoteUrl('proveedores/searchProveedorCodigoUvem');
		var carteraBankia = me.view.up().lookupController().getViewModel()
				.get('activo.isCarteraBankia');
		var carteraCajamar = me.view.up().lookupController().getViewModel()
				.get('activo.isCarteraCajamar');
		var codSucursal = '';
		var nombreSucursal = '';
		if (carteraBankia) {
			codSucursal = '2038' + field.getValue();
			nombreSucursal = ' (Oficina Bankia)';
		} else if (carteraCajamar) {
			codSucursal = '3058' + field.getValue();
			nombreSucursal = ' (Oficina Cajamar)'
		}
		var data;
		var re = new RegExp("^[0-9]{8}$");

		Ext.Ajax.request({

			url : url,
			params : {
				codigoProveedorUvem : codSucursal
			},

			success : function(response, opts) {
				data = Ext.decode(response.responseText);
				var buscadorSucursal = field.up('formBase')
						.down('[name=buscadorSucursales]'), nombreSucursalField = field
						.up('formBase').down('[name=nombreSucursal]');

				if (!Utils.isEmptyJSON(data.data)) {
					var id = data.data.id;
					nombreSucursal = data.data.nombre + nombreSucursal;

					if (re.test(codSucursal) && nombreSucursal != null
							&& nombreSucursal != '') {
						if (!Ext.isEmpty(nombreSucursalField)) {
							nombreSucursalField.setValue(nombreSucursal);
						}
					} else {
						nombreSucursalField.setValue('');
						me
								.fireEvent("errorToast",
										"El código de la Sucursal introducido no corresponde con ninguna Oficina");
					}
				} else {
					if (!Ext.isEmpty(nombreSucursalField)) {
						nombreSucursalField.setValue('');
					}
					me
							.fireEvent(
									"errorToast",
									HreRem
											.i18n("msg.buscador.no.encuentra.sucursal.codigo"));
					buscadorSucursal.markInvalid(HreRem
							.i18n("msg.buscador.no.encuentra.sucursal.codigo"));
				}
			},
			failure : function(response) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			},
			callback : function(options, success, response) {
			}
		});
	},
	onChangeFechasMinimaMovimientosLlaveList : function() {
		var me = this;
		var dateDevolucion = me.lookupReference('datefieldDevolucion');
		var dateEntrega = me.lookupReference('datefieldEntrega');

		me.setFechaMinimaDevolucionMovimientoLlave(dateEntrega.getValue(),
				dateDevolucion);
	},

	comprobarFechasMinimasMovimientosLlaveList : function(editor, context,
			eOpts) {
		var me = this;
		var fila = context.view.getStore().getData().items[context.rowIdx]
				.getData();
		var dateDevolucion = me.lookupReference('datefieldDevolucion');

		me.setFechaMinimaDevolucionMovimientoLlave(fila.fechaEntrega,
				dateDevolucion);
	},

	// Establece fecha mÃ­nima en DevoluciÃ³n en funciÃ³n de la fecha de
	// Entrega
	setFechaMinimaDevolucionMovimientoLlave : function(valorFecha,
			dateDevolucion) {

		if (!Ext.isEmpty(valorFecha)) {
			dateDevolucion.setDisabled(false);
			dateDevolucion.setMinValue(valorFecha);
		} else {
			dateDevolucion.setDisabled(true);
			dateDevolucion.setValue();
		}
	},

	onChkbxRevisionDeptoCalidadChange : function(btn) {
		var me = this;
		var nomGestorCalidad = me.lookupReference('nomGestorCalidad');
		var fechaRevisionCalidad = me.lookupReference('fechaRevisionCalidad');

		if (!btn.value) {
			nomGestorCalidad.reset();
			fechaRevisionCalidad.reset();
		} else {
			nomGestorCalidad.setValue($AU.getUser().userName);
			fechaRevisionCalidad.setValue(new Date());
		}

	},

	onChangeEstadoCargaCombo : function(combo) {
		var me = this;
		var fechaCancelacionRegistral = me
				.lookupReference('fechaCancelacionRegistral');
		if (CONST.SITUACION_CARGA['CANCELADA'] == combo.getSelection()
				.get('codigo')) {
			fechaCancelacionRegistral.allowBlank = false;
		} else {
			fechaCancelacionRegistral.allowBlank = true;
			if (!Ext.isEmpty(fechaCancelacionRegistral.getValue())) {
				fechaCancelacionRegistral.setValue('');
			}
		}
		me.onChangeChainedCombo(combo);
	},

	onChangeEstadoEconomicoCombo : function(combo) {
		var me = this;
		var fechaCancelacionEconomica = me
				.lookupReference('fechaCancelacionEconomica');
		if (CONST.SITUACION_CARGA['CANCELADA'] == combo.getSelection()
				.get('codigo')) {
			fechaCancelacionEconomica.allowBlank = false;
		} else {
			fechaCancelacionEconomica.allowBlank = true;
			if (!Ext.isEmpty(fechaCancelacionEconomica.getValue())) {
				fechaCancelacionEconomica.setValue('');
			}
		}
	},

	saveActivo : function(jsonData, successFn) {
		var me = this, url = $AC.getRemoteUrl('activo/saveActivo');
		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		successFn = successFn || Ext.emptyFn

		if (Ext.isEmpty(jsonData)) {
			me.fireEvent("log", "Obligatorio jsonData para guardar el activo");
		} else {

			Ext.Ajax.request({
				method : 'POST',
				url : url,
				jsonData : Ext.JSON.encode(jsonData),
				success : successFn,
				failure : function(response, opts) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}

			});
		}
	},

	saveActivosAgrRestringida : function(jsonData, successFn) {
		var me = this, url = $AC
				.getRemoteUrl('activo/saveActivosAgrRestringida');

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		successFn = successFn || Ext.emptyFn

		if (Ext.isEmpty(jsonData)) {
			me.fireEvent("log", "Obligatorio jsonData para guardar el activo");
		} else {

			Ext.Ajax.request({
				method : 'POST',
				url : url,
				jsonData : Ext.JSON.encode(jsonData),
				success : successFn,
				failure : function(response, opts) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
			});
		}
	},

	saveDistribucion : function(jsonData, successFn) {

		var me = this, url = $AC
				.getRemoteUrl('activo/createDistribucionFromRem');

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		successFn = successFn || Ext.emptyFn

		if (Ext.isEmpty(jsonData)) {
			me.fireEvent("log", "Obligatorio jsonData para guardar el activo");
		} else {
			Ext.Ajax.request({
				method : 'POST',
				url : url,
				params : {
					numPlanta : jsonData.numPlanta,
					cantidad : jsonData.cantidad,
					superficie : jsonData.superficie,
					idActivo : jsonData.idEntidad,
					tipoHabitaculoCodigo : jsonData.tipoHabitaculoCodigo
				},
				success : successFn,
				failure : function(response, opts) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
			});
		}
	},

	onClickGuardarPropagarCambios : function(btn) {
		var me = this, window = btn.up("window"), grid = me
				.lookupReference("listaActivos"), radioGroup = me
				.lookupReference("opcionesPropagacion"), formActivo = window.form, activosSeleccionados = grid
				.getSelectionModel().getSelection(), opcionPropagacion = radioGroup
				.getValue().seleccion, cambios = window.propagableData, targetGrid = window.targetGrid;

		me.fireEvent("log", cambios);

		if (opcionPropagacion == "4" && activosSeleccionados.length == 0) {
			me.fireEvent("errorToast", HreRem
							.i18n("msg.no.activos.seleccionados"));
			return false;
		}
		// Si estamos modificando una pestaña con formulario
		if (Ext.isEmpty(targetGrid)) {
			if (!Ext.isEmpty(formActivo)) {
				var successFn = function(record, operation) {
					if (activosSeleccionados.length > 0) {
						me.manageToastJsonResponse(me, record.responseText);
						me.propagarCambios(window, activosSeleccionados,
								record.responseText);
					} else {
						window.destroy();

						if (record) {
							me.manageToastJsonResponse(me, record.responseText);
						} else {
							me.manageToastJsonResponse(me);
						}

						me.getView().unmask();
						me.refrescarActivo(formActivo.refreshAfterSave);

						me.getView().fireEvent("refreshComponentOnActivate",
								"container[reference=tabBuscadorActivos]");

						me.actualizarGridHistoricoDestinoComercial(formActivo);
					}
				};
				if(window.tabData.id == window.activoActual.activoId){
					window.tabData.models[0].data = window.allData;
				}
				me.saveActivo(window.tabData, successFn);

			} else {

				var successFn = function(record, operation) {
					if (activosSeleccionados.length > 0) {
						me.manageToastJsonResponse(me, record.responseText);
						me.propagarCambios(window, activosSeleccionados,
								record.responseText);
					} else {
						window.destroy();
						me.manageToastJsonResponse(me, record.responseText);
						me.getView().unmask();
						me.getView().fireEvent("refreshComponentOnActivate",
								"container[reference=tabBuscadorActivos]");
					}
				};
				me.saveActivo(window.tabData, successFn);

			}
		} else {

			if (targetGrid == 'mediadoractivo') {

				var successFn = function(record, operation) {
					window.destroy();
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().unmask();
					me.getView().fireEvent("refreshComponentOnActivate","container[reference=tabBuscadorActivos]");
				};

				me.saveActivo(me.createTabDataHistoricoMediadores(activosSeleccionados),successFn);
			} else if (targetGrid == 'condicionesespecificas') {

				var successFn = function(record, operation) {
					window.destroy();
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().unmask();
					me.getView().fireEvent("refreshComponentOnActivate","container[reference=tabBuscadorActivos]");
				};
				me.saveActivo(me.createTabDataCondicionesEspecificas(activosSeleccionados, window.tabData),successFn);
				
			} else if (targetGrid == 'calificacionNegativa') {
				var successFn = function(record, operation) {
					window.destroy();
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().unmask();
					me.getView().fireEvent("refreshComponentOnActivate","container[reference=tabBuscadorActivos]");
				};
				me.saveActivo(me.createTabDataCalificacionesNegativas(activosSeleccionados, window.tabData),successFn);
			}
		}
		window.mask("Guardando activos 1 de " + (activosSeleccionados.length + 1));
	},

	onClickCancelarPropagarCambios : function(btn) {
		var me = this, window = btn.up("window");

		window.destroy();

		me.onClickBotonRefrescar();
	},

	/**
	 * Replica una operación ya realizada sobre un activo, utilizando el array
	 * de activos que recibe y llamandose recursivamente hasta que no quedan
	 * activos .
	 * 
	 * @param {}
	 *            config - url y parametros comunes para guardar(datos
	 *            modificados y tab)
	 * @param {}
	 *            activos
	 * @return {Boolean}
	 */
	propagarCambios : function(window, activos, jsonResponse) {

		var me = this, grid = window.down("grid"), propagableData = window.propagableData, numTotalActivos = grid
				.getSelectionModel().getSelection().length
				+ 1, targetGrid = window.targetGrid, numActivoActual = numTotalActivos;
		var indiceDatosRegistrales = null;

		if (activos.length > 0) {
			var activo = activos.shift();

			numActivoActual = numTotalActivos - activos.length;
			if (activo.data.esUnidadAlquilable != undefined
					&& activo.data.esUnidadAlquilable == true) {
				for (var i = 0; i < propagableData.models.length; i++) {
					if (propagableData.models[i].name == "datosregistrales"){
						indiceDatosRegistrales = i;
						break;
					}
				}
				if(indiceDatosRegistrales != null){
					if (propagableData.models[indiceDatosRegistrales].data.numFinca != undefined) {
						var stringnumFinca;
						if (propagableData.models[indiceDatosRegistrales].data.numFinca
								.includes('-')) {
							var numeroguion = propagableData.models[indiceDatosRegistrales].data.numFinca
									.indexOf("-")
							stringnumFinca = propagableData.models[indiceDatosRegistrales].data.numFinca
									.slice(0, numeroguion);
						} else {
							stringnumFinca = propagableData.models[indiceDatosRegistrales].data.numFinca;
						}

						var guion = '-';
						var stringnumUa = activos.length + 1;
						stringnumUa = me.pad(stringnumUa, 4);

						var res = stringnumFinca.concat(guion.concat(stringnumUa));
						propagableData.models[indiceDatosRegistrales].data.numFinca = res;
					}
				}
				propagableData.id = activo.get("activoId");
			} else if (Ext.isEmpty(targetGrid)) {
				propagableData.id = activo.get("activoId");
			} else {
				if (targetGrid == 'mediadoractivo') {
					propagableData = me
							.createTabDataHistoricoMediadores(activos);
					// Los lanzamos todos de golpe sin necesidad de iterar
					activos = [];
				} else if (targetGrid == 'calificacionNegativa') {
					propagableData = me
							.createTabDataCalificacionesNegativas(activos);
					activos = []
				} else if (targetGrid == 'condicionesespecificas') {
					propagableData = me
							.createTabDataCondicionesEspecificas(activos);
					activos = []
				}
			}

			var successFn = function(response, opts) {
				// Lanzamos el evento de refrescar el activo por si está
				// abierto.
				me.getView().fireEvent("refreshEntityOnActivate",
						CONST.ENTITY_TYPES['ACTIVO'], activo.get("activoId"));
				me.manageToastJsonResponse(me, response.responseText);
				me.propagarCambios(window, activos, response.responseText);
			};

			window.mask("Guardando activos " + numActivoActual + " de "
					+ numTotalActivos);
			
			if(propagableData.id != window.activoActual.id){
				propagableData.models[0].data = window.auxDataPropagable;
			}
			me.saveActivo(propagableData, successFn);

		} else {
			Ext.ComponentQuery.query('opcionespropagacioncambios')[0].destroy();
			me.getView().unmask();
			return false;
		}
	},

	createTabData : function(form) {
		var me = this, tabData = {};

		tabData.id = me.getViewModel().get("activo.id");
		tabData.models = [];

		if (form.saveMultiple) {
			var types = form.records;
			Ext.Array.each(form.getBindRecords(), function(record, index) {
						var model = me.createModelToSave(record, types[index]);
						if (!Ext.isEmpty(model)) {
							tabData.models.push(model);
						}
					});

		} else {
			var type = form.recordName;
			var model = me.createModelToSave(form.getBindRecord(), type);
			if (!Ext.isEmpty(model)) {
				tabData.models.push(model);
			}
		}

		if (tabData.models.length > 0) {
			return tabData;

		} else {
			return null;
		}
	},

	createTabDataHistoricoMediadores : function(listadoActivos, records4) {

		var me = this, tabData = {};
		tabData.id = me.getViewModel().get("activo.id");
		tabData.models = [];
		var rol = me.getView().down('[xtype=historicomediadorgrid]').selection.getData().rol;
		var mediador = me.getView().down('[xtype=historicomediadorgrid]').selection.getData().codigo;
		Ext.Array.each(listadoActivos, function(record, index) {
			var model = {};
			model.name = 'mediadoractivo';
			model.type = 'activo';
			model.data = {};
			model.data.idActivo = record.data.activoId;
			model.data.rol = rol;
			model.data.mediador = mediador;
			tabData.models.push(model);
		}); 
		
		return tabData;
	},

	createTabDataCondicionesEspecificas : function(listadoActivos,
			recordsGridArray) {
		var me = this, tabData = {};
		tabData.id = me.getViewModel().get("activo.id");
		tabData.models = [];

		var l_CondicionEspecifica = [];

		for (var i = 0; i < recordsGridArray.length; i++) {
			l_CondicionEspecifica.push(recordsGridArray[i].data.texto);
			l_CondicionEspecifica.push(recordsGridArray[i].data.codigo);
			l_CondicionEspecifica.push(recordsGridArray[i].data.fechaDesde);
			l_CondicionEspecifica.push(recordsGridArray[i].data.fechaHasta);
		}

		Ext.Array.each(listadoActivos, function(record, index) {
					var model = {};
					model.name = 'condicionesespecificas';
					model.type = 'activo';
					model.data = {
						texto : l_CondicionEspecifica[0],
						codigo : l_CondicionEspecifica[1],
						fechaDesde : l_CondicionEspecifica[2],
						fechaHasta : l_CondicionEspecifica[3]
					};
					model.data.idActivo = record.data.activoId;
					tabData.models.push(model);
				});
		return tabData;
	},

	createTabDataCalificacionesNegativas : function(list, recordsGridArray) {

		var me = this, tabData = {};
		tabData.id = me.getViewModel().get("activo.id");
		tabData.models = [];

		var l_idMotivos = [];

		for (var i = 0; i < recordsGridArray.length; i++) {
			l_idMotivos.push(recordsGridArray[i].data.idMotivo);
		}

		Ext.Array.each(list, function(record, index) {
					var model = {};
					model.name = 'calificacionNegativa';
					model.type = 'activo';
					model.data = {
						idsMotivo : l_idMotivos
					};
					model.data.idActivo = record.data.activoId;
					tabData.models.push(model);
				});

		return tabData;
	},

	createModelToSave : function(record, type) {
		var me = this;
		var model = null;
		if (Ext.isDefined(record.getProxy().getApi().update)) {
			model = {};
			model.name = record.getProxy().getExtraParams().tab;
			model.type = type;
			model.data = record.getProxy().getWriter().getRecordData(record);
		}

		return model;

	},

	createFormPropagableData : function(form, tabData) {
		var me = this, propagableData = null, camposPropagables = [], dirtyFieldsModel = [], propagableData = [];
		var records = [], models = [];

		if (form.saveMultiple) {
			records = records.concat(form.getBindRecords())
		} else {
			records.push(form.getBindRecord());
		}

		Ext.Array.each(records, function(record, index) {
					var name = record.getProxy().getExtraParams().tab;
					camposPropagables[name] = record.get("camposPropagables");
				});

		Ext.Array.each(tabData.models, function(model, index) {

					var data = {}, modelHasData = false;
					Ext.Array.each(camposPropagables[model.name], function(
									campo, index) {
								if (Ext.isDefined(model.data[campo])) {
									data[campo] = model.data[campo];
									modelHasData = true;
								}
							});

					if (modelHasData) {
						model.data = data;
						models.push(model);
					}

				});

		if (models.length > 0) {
			propagableData = {};
			propagableData.models = models
		}

		return propagableData;
	},

	onClickBotonGuardarMotivoRechazo : function(btn) {
		var me = this;

		var window = btn.up('window');

		var grid = window.gridOfertas;
		var record = window.getViewModel().get('ofertaRecord');

		if (grid.isValidRecord(record)) {

			record.save({

						params : {
							idEntidad : Ext.isEmpty(grid.idPrincipal)
									? ""
									: this.up('{viewModel}').getViewModel()
											.get(grid.idPrincipal),
							esAnulacion : true
						},
						success : function(a, operation, c) {
							grid.saveSuccessFn();
						},

						failure : function(a, operation) {
							grid.saveFailureFn(operation);

						},
						callback : function() {
							grid.unmask();
							grid.getStore().load();
						}
					});
			grid.disableAddButton(false);
			grid.disablePagingToolBar(false);
			grid.getSelectionModel().deselectAll();
			// TODO: Encontrar la manera de realizar esto que me ha obligado a
			// duplicar este save del record y en este punto "editor" es
			// indefinido
			// editor.isNew = false;
		} else {
			grid.getStore().load();
		}

		window.close();

	},

	onClickBotonCancelarMotivoRechazo : function(btn) {
		var me = this, window = btn.up('window');

		window.gridOfertas.getStore().load();
		window.close();

	},
	
	createTabDataCalificacionesNegativas : function(list, recordsGridArray) {
		
		var me = this, tabData = {};
	    tabData.id = me.getViewModel().get("activo.id");
	    tabData.models = [];
	    
	    var l_idMotivos = [];
	    
	    for (var i = 0; i < recordsGridArray.length; i++) {
	    	l_idMotivos.push(recordsGridArray[i].data.idMotivo);
	    }
	    
	    Ext.Array.each(list, function(record, index) {
	          var model = {};
	          model.name = 'calificacionNegativa';
	          model.type = 'activo';
	          model.data = {idsMotivo: l_idMotivos};
	          model.data.idActivo = record.data.activoId;
	          tabData.models.push(model);
	        });
	    
	    return tabData;
	},

    createModelToSave: function(record, type) {
    	var me = this;
    	var model = null;
    	if (Ext.isDefined(record.getProxy().getApi().update)) { 
    		model = {};
    		model.name= record.getProxy().getExtraParams().tab;
    		model.type= type;
    		model.data= record.getProxy().getWriter().getRecordData(record);
    	} 
    	
    	return model;
    		
    },
    
    createFormPropagableData: function(form, tabData) {
    	var me = this,
    	propagableData=null,
    	camposPropagables = [],
    	dirtyFieldsModel =  [],
    	propagableData = [];
    	var records = [],
    	models = [];
    	if(form.saveMultiple) {
    		records = records.concat(form.getBindRecords()) ;
    	} else {
    		records.push(form.getBindRecord());
    	}

    	Ext.Array.each(records, function(record, index) {
    		var name = record.getProxy().getExtraParams().tab;
    		camposPropagables[name] = record.get("camposPropagables");
    	});

    	Ext.Array.each(tabData.models, function(model, index) {
    		var data = {},
    		modelHasData = false;
    		Ext.Array.each(camposPropagables[model.name], function(campo, index){
    			if(Ext.isDefined(model.data[campo])) {
    				data[campo] = model.data[campo];
    				modelHasData=true;
    			}
    		});
    		
    		if(modelHasData) {
    			model.data=data;
    			models.push(model);	
    		}
    		
    	});	
    	
    	if(models.length>0) {
    		propagableData = {};
    		propagableData.models = models
    	}
	
    	return propagableData;
    },
    
    onClickBotonGuardarMotivoRechazo: function(btn){
    	var me = this;
    	
    	var window = btn.up('window');
    	
    	var grid = window.gridOfertas;
    	var record = window.getViewModel().get('ofertaRecord');
    	
		if (grid.isValidRecord(record)) {				
			
    		record.save({

                params: {
                    idEntidad: Ext.isEmpty(grid.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(grid.idPrincipal),
                    esAnulacion: true
                },
                success: function (a, operation, c) {																			
					grid.saveSuccessFn();
				},
                
				failure: function (a, operation) {
                	grid.saveFailureFn(operation);
              	
                },
    			callback: function() {
                	grid.unmask();
                	grid.getStore().load();
                }
            });	                            
    		grid.disableAddButton(false);
    		grid.disablePagingToolBar(false);
    		grid.getSelectionModel().deselectAll();
// TODO: Encontrar la manera de realizar esto que me ha obligado a
// duplicar este save del record y en este punto "editor" es indefinido
// editor.isNew = false;
		} else {
		   grid.getStore().load(); 	
		}
    	window.close();
	},

	onClickBotonCancelarDistribucion : function(btn) {
		var me = this, window = btn.up('window');
		window.gridDistribuciones.getStore().load();
		window.close();
	},

	onClickBotonGuardarDistribucion : function(btn) {
		var me = this, window = btn.up('window');
		var form = window.down('formBase');
		me.onSaveFormularioCompletoDistribuciones(null, form);
	},

	onChangeComboMotivoOcultacionVenta : function() {

		var me = this;

		var combo = me.lookupReference('comboMotivoOcultacionVenta');
		var textArea = me.lookupReference(combo.textareaRefChained);

		if (combo && combo.value === CONST.MOTIVO_OCULTACION['OTROS']) {
			textArea.setDisabled(false);
		} else {
			textArea.setValue('');
			textArea.setDisabled(true);
		}
	},

	onChangeComboMotivoOcultacionAlquiler : function() {
		var me = this;
		var combo = me.lookupReference('comboMotivoOcultacionAlquiler');
		var textArea = me.lookupReference(combo.textareaRefChained);

		if (combo && combo.value === CONST.MOTIVO_OCULTACION['OTROS']) {
			textArea.setDisabled(false);
		} else {
			textArea.setValue('');
			textArea.setDisabled(true);
		}
	},

	onChangeCheckboxOcultar : function(checkbox, isDirty) {
		var me = this;
		var combobox = me.lookupReference(checkbox.comboRefChained);
		var checkboxThis = me.lookupReference(checkbox.reference).getReference();
		var fechaVenta = me.lookupReference('fechaRevisionPublicacionesVenta');
		var fechaAlquiler = me.lookupReference('fechaRevisionPublicacionesAlquiler');
		var textAreaVenta = me.lookupReference('textareaMotivoOcultacionManualVenta');
		var textAreaAlquiler = me.lookupReference('textareaMotivoOcultacionManualAlquiler');

		if (checkbox.getValue()) {
			combobox.setDisabled(false);
			combobox.setAllowBlank(false);
			
			if ('chkbxocultarventa' === checkboxThis) {
				fechaVenta.setDisabled(false);
			} else if ('chkbxocultaralquiler' === checkboxThis) {
				fechaAlquiler.setDisabled(false);
			}
		} else {
			combobox.setDisabled(true);
			combobox.setAllowBlank(true);
			combobox.clearValue();
			
			if ('chkbxocultarventa' === checkboxThis) {
				textAreaVenta.setDisabled(true);
				textAreaVenta.setValue('');
				fechaVenta.setDisabled(true);
			} else if ('chkbxocultaralquiler' === checkboxThis) {
				textAreaAlquiler.setDisabled(true);
				textAreaAlquiler.setValue('');
				fechaAlquiler.setDisabled(true);
			}
		}

		if (isDirty) {
			combobox.getStore().clearFilter();
			combobox.getStore().filter([{
						filterFn : function(rec) {
							return rec.getData().esMotivoManual === 'true';
						}
					}]);
		}
	},

	onActivateTabDatosPublicacion : function(tab, eOpts) {
		var me = this;

		me.getViewModel().get('filtrarComboMotivosOcultacionVenta');
		me.getViewModel().get('filtrarComboMotivosOcultacionAlquiler');
	},

	onChangeCheckboxPublicarVenta : function(checkbox, isDirty) {

		var me = this;
		var estadoPubVentaPublicado = me.getViewModel().get('activo').getData().estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO']
				|| me.getViewModel().get('activo').getData().estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['OCULTO'];
		var textarea = me.lookupReference(checkbox.textareaRefChained);

		if (!isDirty && estadoPubVentaPublicado) {
			var readOnly = Ext.isEmpty(me.getViewModel()
					.get('datospublicacionactivo').getData());

			checkbox.setReadOnly(readOnly);
			checkbox.setValue(false);
		}

		if (checkbox.getValue()) {
			textarea.setDisabled(false);
		} else {
			textarea.setDisabled(true);
			textarea.setValue("");
		}
	},

	onChangeCheckboxPublicarAlquiler : function(checkbox, isDirty) {
		var me = this;
		var chkbxpublicarControlPrimeravez = checkbox.up('activosdetallemain')
				.lookupReference('chkbxpublicarControlPrimeravez');
		if (chkbxpublicarControlPrimeravez.getValue()) {
			chkbxpublicarControlPrimeravez.setValue(false);

		}
		if (checkbox.getValue()
				&& me.getViewModel()
						.get('debePreguntarPorTipoPublicacionAlquiler')
				&& !chkbxpublicarControlPrimeravez.getValue()) {
			Ext
					.create('HreRem.view.activos.detalle.VentanaEleccionTipoPublicacion')
					.show();
		}

		if (me.getViewModel().get('activo').getData().activoMatriz) {
			if (me.getViewModel().get('activo').getData().estadoAlquilerCodigo == CONST.ESTADO_PUBLICACION_ALQUILER['NO_PUBLICADO']) {
				checkbox.setReadOnly(readOnly);
				checkbox.setValue(false);
			}
		} else {
			var estadoPubAlquilerPublicado = me.getViewModel().get('activo')
					.getData().estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO']
					|| me.getViewModel().get('activo').getData().estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['OCULTO'];
			if (!isDirty && estadoPubAlquilerPublicado) {
				var readOnly = Ext
						.isEmpty(me.getViewModel()
								.get('datospublicacionactivo').getData().precioWebAlquiler)
						&& !checkbox.getValue();
				checkbox.setReadOnly(readOnly);
				checkbox.setValue(true);
			}

			if (!checkbox.getValue()) {
				checkbox.up('activosdetallemain')
						.lookupReference('textareaMotivoPublicacionAlquiler')
						.reset();

			}
		}
	},

	onChangeCheckboxPublicarSinPrecioVenta : function(checkbox, isDirty) {
		var me = this;
		var estadoCheckPublicarFicha = me.getViewModel()
				.get('activo.aplicaPublicar');
		var checkboxPublicarVenta = checkbox.up('activosdetallemain')
				.lookupReference('chkbxpublicarventa');
		var estadoPubVentaPublicado = me.getViewModel().get('activo').getData().estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO']
				|| me.getViewModel().get('activo').getData().estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['PRE_PUBLICADO']
				|| me.getViewModel().get('activo').getData().estadoVentaCodigo === CONST.ESTADO_PUBLICACION_VENTA['OCULTO'];
		var checkboxPublicarVentaDeshabilitado = me.getViewModel()
				.get('datospublicacionactivo').getData().deshabilitarCheckPublicarVenta;

		if (!estadoCheckPublicarFicha) {
			checkboxPublicarAlquiler.setReadOnly(true);
			checkbox.setValue(false);
		} else {
			if (!estadoPubVentaPublicado && checkbox.getValue()
					&& checkboxPublicarVentaDeshabilitado) {

				checkboxPublicarVenta.setValue(true);
				me.getViewModel().get('datospublicacionactivo').set(
						'publicarVenta', true);

			} else if (!estadoPubVentaPublicado && !checkbox.getValue()
					&& checkboxPublicarVentaDeshabilitado) {

				checkboxPublicarVenta.setValue(false);
				me.getViewModel().get('datospublicacionactivo').set(
						'publicarVenta', false);

			}
		}
	},

	onChangeCheckboxPublicarSinPrecioAlquiler : function(checkbox, isDirty) {
		var me = this;
		var estadoCheckPublicarFicha = me.getViewModel()
				.get('activo.aplicaPublicar'), checkboxPublicarAlquiler = checkbox
				.up('activosdetallemain')
				.lookupReference('chkbxpublicaralquiler'), esActivoMatrizNoPublicado = me
				.bloquearPublicarAlquilerActivosMatrizNoPublicados();
		estadoPubAlquilerPublicado = me.getViewModel().get('activo').getData().estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO']
				|| me.getViewModel().get('activo').getData().estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['PRE_PUBLICADO']
				|| me.getViewModel().get('activo').getData().estadoAlquilerCodigo === CONST.ESTADO_PUBLICACION_ALQUILER['OCULTO'];
		if (esActivoMatrizNoPublicado) {
			checkboxPublicarAlquiler.setReadOnly(true);

		} else {
			if (!estadoCheckPublicarFicha) {
				checkboxPublicarAlquiler.setReadOnly(true);
				checkbox.setValue(false);
			} else if (!estadoPubAlquilerPublicado) {
				var readOnly = !(Ext
						.isEmpty(me.getViewModel()
								.get('datospublicacionactivo').getData().precioWebAlquiler) || checkbox
						.getValue());
				checkboxPublicarAlquiler.setReadOnly(readOnly);
				checkbox.up('activosdetallemain').getViewModel()
						.get('datospublicacionactivo')
						.set('eleccionUsuarioTipoPublicacionAlquiler');
				if (!checkbox.getValue()) {
					checkboxPublicarAlquiler.setValue(false);
				}
			}
		}
	},
	bloquearPublicarAlquilerActivosMatrizNoPublicados : function(get) {
		var me = this;
		var estadoPublicacionAlquiler = me.getViewModel()
				.get('datospublicacionactivo.estadoPublicacionAlquilerCodigo');
		var esActivoMatriz = me.getViewModel()
				.get('datospublicacionactivo.isMatriz');
		if (esActivoMatriz) {
			if (!Ext.isEmpty(estadoPublicacionAlquiler)
					&& estadoPublicacionAlquiler == CONST.ESTADO_PUBLICACION_ALQUILER['NO_PUBLICADO']) {
				return true;
			}
		}
		return false;
	},
	establecerTipoPublicacionAlquiler : function(btn) {
		var me = this;
		var list = Ext.ComponentQuery.query('activosdetallemain');
		for (var i = 0; i < list.length; i++) {
			if (list[i].tab.active)
				list[i].getViewModel().get('datospublicacionactivo').set(
						'eleccionUsuarioTipoPublicacionAlquiler', btn.codigo);
		}

		btn.up('window').destroy();
	},

	cancelarEstablecerTipoPublicacionAlquiler : function(btn) {
		var me = this;
		var list = Ext.ComponentQuery.query('activosdetallemain');
		for (var i = 0; i < list.length; i++) {
			if (list[i].tab.active)
				list[i].lookupReference('chkbxpublicaralquiler')
						.setValue(false);
			if (list[i].tab.active)
				list[i].lookupReference('chkbxpublicarsinprecioalquiler')
						.setValue(false);
		}
		btn.up('window').destroy();
	},

	onGridImpuestosActivoRowClick : function(grid, record, tr, rowIndex) {
		grid.up().disableRemoveButton(false);
	},

	onImpuestosActivoDobleClick : function(grid, record, tr, rowIndex) {
		var me = this, record = grid.getStore().getAt(rowIndex);
	},

	checkActivosToPropagate : function(idActivo, form, tabData, restringida) {
		var me = this, url2 = $AC.getRemoteUrl('activo/getIsActivoMatriz');
		Ext.Ajax.request({			
			url : url2,
			method : 'POST',
			params : {
				idActivo : idActivo
			},
			success : function(response, opts) {
				var isActivoMatriz = Ext.decode(response.responseText).data;
				var vistaActual = me.getView();
				var detalle = vistaActual.items.items[1];
				var tabActiva = detalle.getActiveTab();
				var referencia = tabActiva.reference;
				var subReferencia = "";
				if (tabActiva.ariaRole == 'tabpanel') {
					if (referencia == 'publicacionactivoref') {
						var subTabActiva = tabActiva.getActiveTab(), subReferencia = subTabActiva.reference;
					}
				}

				if(isActivoMatriz == "true" && !(referencia == 'publicacionactivoref'
						&& subReferencia == 'datospublicacionactivoref')){
					url3 =  $AC.getRemoteUrl('activo/propagarActivosMatriz');
		    		Ext.Ajax.request({
		        		url: url3,
		    			method : 'POST',
		        		params: {idActivo: idActivo},
	    		    		success: function(response, opts){	
	    		    			var activosSeleccionados = Ext.decode(response.responseText).data.activosPropagables;
		    		    			if(me.getViewModel() != null){
	    		    					if(me.getViewModel().get('activo') != null){
	    		    						if(me.getViewModel().get('activo').data != null){
		    									me.getViewModel().get('activo').data.activosPropagables = activosSeleccionados;
		    								}
		    							}
		    						}
		    		    		
		    		    			var seCompruebanSueprficies = false;
		    		    			if( tabData.models[0].name == "datosregistrales"){
		    		    				seCompruebanSueprficies = true;
		    		    				var EsLaSuperficieMenor = true;
		    		    			}
		    		    			
		    		    			if(seCompruebanSueprficies == true){
			    		    			var superficieConstruidaAcumulable =  parseFloat("0",10);
			    		    			var superficieElementosComunesAcumulables= parseFloat("0",10);
			    		    			var superficieParcelaAcumulable= parseFloat("0",10);
			    		    			var superficieUtilAcumulable= parseFloat("0",10);
			    		    			for(var i = 0; i < activosSeleccionados.length; i++){
			    		    				if(activosSeleccionados[i].superficieConstruida == undefined){
			    		    					activosSeleccionados[i].superficieConstruida = parseFloat("0",10);
			    		    				}
			    		    				superficieConstruidaAcumulable = parseFloat(activosSeleccionados[i].superficieConstruida, 10) + superficieConstruidaAcumulable;
			    		    				if(activosSeleccionados[i].superficieElementoComun == undefined){
			    		    					activosSeleccionados[i].superficieElementoComun = parseFloat("0",10);
			    		    				}
			    		    				superficieElementosComunesAcumulables = parseFloat(activosSeleccionados[i].superficieElementoComun, 10) + superficieElementosComunesAcumulables;
			    		    				if(activosSeleccionados[i].superficieParcela == undefined){
			    		    					activosSeleccionados[i].superficieParcela = parseFloat("0",10);
			    		    				}
			    		    				superficieParcelaAcumulable += parseFloat(activosSeleccionados[i].superficieParcela, 10);
			    		    				if(activosSeleccionados[i].superficieUtil == undefined){
			    		    					activosSeleccionados[i].superficieUtil = parseFloat("0",10);
			    		    				}
			    		    				superficieUtilAcumulable += parseFloat(activosSeleccionados[i].superficieUtil, 10);
			    		    			}
			    		    			
			    		    			if(superficieConstruidaAcumulable > form.viewModel.linkData.datosRegistrales.data.superficieConstruida){
			    		    				EsLaSuperficieMenor = false;
			    		    			}
			    		    			if(superficieElementosComunesAcumulables > form.viewModel.linkData.datosRegistrales.data.superficieElementosComunes){
			    		    				EsLaSuperficieMenor = false;
			    		    			}
			    		    			if(superficieParcelaAcumulable > form.viewModel.linkData.datosRegistrales.data.superficieParcela){
			    		    				EsLaSuperficieMenor = false;
			    		    			}	
			    		    			if(superficieUtilAcumulable > form.viewModel.linkData.datosRegistrales.data.superficieUtil){
			    		    				EsLaSuperficieMenor = false;
			    		    			}	
	    		    				}
		    		    			if(EsLaSuperficieMenor==false){
		    		    				me.getView().fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.propagar.ua.superficies"));
		    		    				me.getView().unmask();
		    		    			}else{
		    		    				if(activosSeleccionados.length > 0) {
		    								tabPropagableData = me.createFormPropagableData(form, tabData);
		    								if (!Ext.isEmpty(tabPropagableData)) {
		    									// sacamos el activo actual del listado
		    									if(tabPropagableData.models[0].data.numFinca != undefined){
		    										tabPropagableData.models[0].data.numFinca = me.pad(tabPropagableData.models[0].data.numFinca, 4);
		    									}
		    									
		    									var activo = function(activo){return activo.activoId == me.getViewModel().get("activo.id")};
		    									for(var cont=0; cont <activosSeleccionados.length; cont++){
		    										activosSeleccionados[cont].esUnidadAlquilable=true;
		    										
		    									}
		    									// Abrimos la ventana de selección de activos
		    									var ventanaOpcionesPropagacionCambios = Ext.create("HreRem.view.activos.detalle.OpcionesPropagacionCambiosMatrizExpediente", {form: form, activoActual: activo, activos: activosSeleccionados, tabData: tabData, propagableData: tabPropagableData}).show();
		    										me.getView().add(ventanaOpcionesPropagacionCambios);
		    										me.getView().unmask();
		    										return false;
		    								}
		    		    				}

		    							me.getView().unmask();
					
	    								var successFn = function(response, eOpts) {
		    		
											me.manageToastJsonResponse(me, response.responseText);
		   									me.getView().unmask();
		   									me.refrescarActivo(form.refreshAfterSave);
		   									me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
		   									me.actualizarGridHistoricoDestinoComercial(form);
		    							}
		    	
										if(restringida == true){
		    								me.saveActivosAgrRestringida(tabData, successFn);
		    							} else {
		    								me.getView().fireEvent("No hay activos propagables");
		    								me.saveActivo(tabData, successFn);
		    							}		    		    			
		    		    		}		
	    		    		},failure: function(record, operation) {
	    		    			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    		    		}
		    		});
				}else{
					url4 =  $AC.getRemoteUrl('activo/getisActivoUa');
	    			Ext.Ajax.request({
	    		   		url: url4,
	    				method : 'POST',
	    				params: {idActivo: idActivo},
	    		   		success: function(response, opts){
	    		   			var isActivoUa = Ext.decode(response.responseText).data;
	    		    		if(isActivoUa != "true"){
								url =  $AC.getRemoteUrl('activo/getActivosPropagables');
								Ext.Ajax.request({
									url : url,
									method : 'POST',
									params : {
										idActivo : idActivo
									},
									success : function(response, opts) {
										var activosPropagables = Ext
												.decode(response.responseText).data.activosPropagables;
										var tabPropagableData = null;
										if (me.getViewModel() != null) {
											if (me.getViewModel().get('activo') != null) {
												if (me.getViewModel()
														.get('activo').data != null) {
													me.getViewModel().get('activo').data.activosPropagables = activosPropagables;
												}
											}
										
											if(activosPropagables != null && isActivoMatriz != "true"){
													if(activosPropagables.length > 0) {
														var auxAllData = tabData.models[0].data;
														tabPropagableData = me.createFormPropagableData(form, tabData);
														if (!Ext.isEmpty(tabPropagableData)) {
															// sacamos el activo actual del listado
															var activo = activosPropagables.splice(activosPropagables.findIndex(function(activo){return activo.activoId == me.getViewModel().get("activo.id")}),1)[0];
															var tieneDatosPropagables = false;
															if(!Ext.isEmpty(form)) {
													    		
													    		var fields = form.getForm().getFields();
													    		fields.each(function(field) {
													    			
													    			if (!Ext.isEmpty(field) && !Ext.isEmpty(field.bind) && !Ext.isEmpty(field.bind.value) && !Ext.isEmpty(field.bind.value.stub)  ) {
													    				var path = field.bind.value.stub.path;
													    				var indexSeparator = path.indexOf(".");
													    				var name = path.substring(0,indexSeparator);
													    				var property = path.substring(indexSeparator+1, path.length);
													    				
													    				Ext.Array.each(tabPropagableData.models, function(model,index) {
													    					if (model.type == name && model.data.hasOwnProperty(property)) {
													    						tieneDatosPropagables = true;
													    					}
													    				});
													    			}
													    		});
													    	}
															
														}
													}

													if (tieneDatosPropagables) {
														// Abrimos la ventana de
														// selección de activos
														var auxDataPropagable = tabData.models[0].data;
														var ventanaOpcionesPropagacionCambios = Ext.create("HreRem.view.activos.detalle.OpcionesPropagacionCambios",
														{
															form : form,
															activoActual : activo,
															activos : activosPropagables,
															tabData : tabData,
															propagableData : tabPropagableData,
															allData:auxAllData,
															auxDataPropagable:auxDataPropagable
														}).show();
														me.getView().add(ventanaOpcionesPropagacionCambios);
														me.getView().unmask();
														return false;
													}
											}

											var successFn = function(response,eOpts) {

												me.manageToastJsonResponse(me,response.responseText);
												me.getView().unmask();
												me.refrescarActivo(form.refreshAfterSave);
												me.getView().fireEvent("refreshComponentOnActivate","container[reference=tabBuscadorActivos]");
												me.actualizarGridHistoricoDestinoComercial(form);
											}

											if (restringida == true) {
												me.saveActivosAgrRestringida(tabData, successFn);
											} else {
												me.getView().fireEvent("No hay activos propagables");
												me.saveActivo(tabData,successFn);
											}
										} else {
											var successFn = function(response,eOpts) {

												me.manageToastJsonResponse(me,response.responseText);
												me.getView().unmask();
												me.refrescarActivo(form.refreshAfterSave);
												me.getView().fireEvent("refreshComponentOnActivate","container[reference=tabBuscadorActivos]");
												me.actualizarGridHistoricoDestinoComercial(form);
											}
											me.saveActivo(tabData, successFn);
											me.getView().unmask();
										}

									},
									failure : function(record, operation) {
										me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
									}
								});
							} else {
								var successFn = function(response, eOpts) {
									me.manageToastJsonResponse(me, response.responseText);
									me.getView().unmask();
									me.refrescarActivo(form.refreshAfterSave);
									me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
									me.actualizarGridHistoricoDestinoComercial(form);
								}
								me.saveActivo(tabData, successFn)
							}

						},
						failure : function(record, operation) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						}
					});
				}
			},
			failure : function(record, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			}
		});
	},

	onClickGuardarComercial : function(btn) {
		var me = this;
		var genericSave = false;
		var form;
		var idActivo = me.getViewModel().getData().activo.id;
		var mask;
		var afterSave;

		var tab = btn.up('tabpanel').getActiveTab();

		if (tab.xtype === "gencatcomercialactivo") {
			// GUARDAR PESTANYA GENCAT
			afterSave = function(btn) {
				btn.up().up().funcionRecargar();
			}
			form = tab.down('gencatcomercialactivoform').getForm();
			mask = btn.up().up().down("gencatcomercialactivo");
			genericSave = true;
		}

		if (genericSave && form && form.isValid()) {

			mask.mask(HreRem.i18n('msg.mask.loading'))

			form.submit({
				waitMsg : HreRem.i18n('msg.mask.loading'),
				params : {
					idActivo : idActivo
				},
				success : function(fp, o) {
					mask.unmask();
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					afterSave(btn);
					me.limpiarBotonesGuardado(btn, tab);
				},
				failure : function(fp, o) {
					mask.unmask();
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.onClickBotonCancelarComercial(btn);
				}
			});
		} else {
			var fechaHoy = new Date();

			var mes = fechaHoy.getMonth() + 1;

			var dia = fechaHoy.getDate();

			if (mes < 10) {
				mes = "0" + mes;
			}

			if (dia < 10) {
				dia = "0" + dia;
			}

			// Transformamos la fecha a string para compararla
			var fechaString = fechaHoy.getFullYear() + "-" + mes + "-" + dia;

			var fechaCom = form.getValues().fechaComunicacion;

			if (new Date(fechaCom) > new Date(fechaString)) {
				me.fireEvent("errorToast", HreRem.i18n("msg.fecha.com.mayor"));
				me.onClickBotonCancelarComercial(btn);
			} else if (form.isValid()) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				me.onClickBotonCancelarComercial(btn);
			}

		}
	},

	existeCliente : function(btn) {
		var me = this;
		var form = btn.up('anyadirnuevaofertadocumento').getForm();
		if (form.isValid()) {
			me.getView().mask(HreRem.i18n("msg.mask.loading"));
			var ventanaWizard;
			var ventanaAltaWizard;
			var idActivo, idAgrupacion;
			var idExpediente = null;
			if (!Ext.isEmpty(btn.up('wizardaltaoferta'))) {
				if (!Ext
						.isEmpty(btn.up('wizardaltaoferta').oferta.data.idActivo)) {
					idActivo = btn.up('wizardaltaoferta').oferta.data.idActivo;
				}
				if (!Ext
						.isEmpty(btn.up('wizardaltaoferta').oferta.data.idAgrupacion)) {
					idAgrupacion = btn.up('wizardaltaoferta').oferta.data.idAgrupacion
				}
			} else {
				idExpediente = btn.up('wizardaltacomprador').expediente.id;
			}
			url = $AC.getRemoteUrl('ofertas/checkPedirDoc');
			var datosForm = form.getValues();
			var codtipoDoc = datosForm.comboTipoDocumento;
			var dniComprador = datosForm.numDocumentoCliente;

			Ext.Ajax.request({
				url : url,
				method : 'POST',
				params : {
					idActivo : idActivo,
					idAgrupacion : idAgrupacion,
					idExpediente : idExpediente,
					dniComprador : dniComprador,
					codtipoDoc : codtipoDoc
				},
				success : function(response, opts) {
					var datos = Ext.decode(response.responseText);
					var pedirDoc = Ext.decode(response.responseText).data;
					var comprador = datos.comprador;
					var destinoComercial = datos.destinoComercial;
					var ventanaWizard = null;
					var carteraInternacional = datos.carteraInternacional;
					var ventanaAnyadirOferta;

					if (!Ext.isEmpty(btn.up('wizardaltaoferta'))) {

						ventanaWizard = btn.up('wizardaltaoferta');
						ventanaAnyadirOferta = ventanaWizard
								.down('anyadirnuevaofertadetalle');
						ventanaWizard.getViewModel().data.destinoComercial = destinoComercial;
						ventanaAnyadirOferta.getForm().reset();
						if (!Ext.isEmpty(pedirDoc)) {
							ventanaAnyadirOferta.getForm()
									.findField('pedirDoc').setValue(pedirDoc);
							if (pedirDoc == "true") {
								ventanaWizard.down('button[itemId=btnGuardar]')
										.setText("Crear");
							} else {
								ventanaWizard.down('button[itemId=btnGuardar]')
										.setText("Continuar");
							}
						}
						if (!Ext.isEmpty(comprador)) {

							if (!Ext.isEmpty(comprador.nombreCliente)) {
								ventanaAnyadirOferta.getForm()
										.findField('nombreCliente')
										.setValue(comprador.nombreCliente);
								ventanaAnyadirOferta.getForm()
										.findField('nombreCliente')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.apellidosCliente)) {
								ventanaAnyadirOferta.getForm()
										.findField('apellidosCliente')
										.setValue(comprador.apellidosCliente);
								ventanaAnyadirOferta.getForm()
										.findField('apellidosCliente')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.razonSocial)) {
								ventanaAnyadirOferta.getForm()
										.findField('razonSocialCliente')
										.setValue(comprador.razonSocial);
								ventanaAnyadirOferta.getForm()
										.findField('razonSocialCliente')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.documento)) {
								ventanaAnyadirOferta.getForm()
										.findField('numDocumentoCliente')
										.setValue(comprador.documento);
								ventanaAnyadirOferta.getForm()
										.findField('numDocumentoCliente')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.tipoDocumentoCodigo)) {
								ventanaAnyadirOferta
										.getForm()
										.findField('comboTipoDocumento')
										.setValue(comprador.tipoDocumentoCodigo);
								ventanaAnyadirOferta.getForm()
										.findField('comboTipoDocumento')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.tipoPersonaCodigo)) {
								ventanaAnyadirOferta.getForm()
										.findField('comboTipoPersona')
										.setValue(comprador.tipoPersonaCodigo);
								ventanaAnyadirOferta.getForm()
										.findField('comboTipoPersona')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.estadoCivilCodigo)) {
								ventanaAnyadirOferta.getForm()
										.findField('comboEstadoCivil')
										.setValue(comprador.estadoCivilCodigo);
								ventanaAnyadirOferta.getForm()
										.findField('comboEstadoCivil')
										.setDisabled('disabled');
							}
							if (!Ext
									.isEmpty(comprador.regimenMatrimonialCodigo)) {
								ventanaAnyadirOferta
										.getForm()
										.findField('comboRegimenMatrimonial')
										.setValue(comprador.regimenMatrimonialCodigo);
								ventanaAnyadirOferta.getForm()
										.findField('comboRegimenMatrimonial')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.codigoPrescriptor)) {
								ventanaAnyadirOferta.getForm()
										.findField('codigoPrescriptor')
										.setValue(comprador.codigoPrescriptor);
								ventanaAnyadirOferta.getForm()
										.findField('codigoPrescriptor')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.cesionDatos)) {
								ventanaAnyadirOferta.getForm()
										.findField('cesionDatos')
										.setValue(comprador.cesionDatos);
							}
							if (!Ext.isEmpty(comprador.comunicacionTerceros)) {
								ventanaAnyadirOferta
										.getForm()
										.findField('comunicacionTerceros')
										.setValue(comprador.comunicacionTerceros);
							}
							if (!Ext
									.isEmpty(comprador.transferenciasInternacionales)) {
								ventanaAnyadirOferta
										.getForm()
										.findField('transferenciasInternacionales')
										.setValue(comprador.transferenciasInternacionales);
							}
							if (!Ext.isEmpty(comprador.direccion)) {
								ventanaAnyadirOferta.getForm()
										.findField('direccion')
										.setValue(comprador.direccion);
								ventanaAnyadirOferta.getForm()
										.findField('direccion')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.telefono)) {
								ventanaAnyadirOferta.getForm()
										.findField('telefono')
										.setValue(comprador.telefono);
								ventanaAnyadirOferta.getForm()
										.findField('telefono')
										.setDisabled('disabled');
							}
							if (!Ext.isEmpty(comprador.email)) {
								ventanaAnyadirOferta.getForm()
										.findField('email')
										.setValue(comprador.email);
								ventanaAnyadirOferta.getForm()
										.findField('email')
										.setDisabled('disabled');
							}

						}
						ventanaWizard.width = Ext.Element.getViewportWidth() > 1370
								? Ext.Element.getViewportWidth() / 2
								: Ext.Element.getViewportWidth() / 1.5;
						ventanaWizard
								.setX(Ext.Element.getViewportWidth()
										/ 2
										- ((Ext.Element.getViewportWidth() > 1370
												? Ext.Element
														.getViewportWidth()
														/ 2
												: Ext.Element
														.getViewportWidth()
														/ 1.5) / 2));
						ventanaWizard.height = Ext.Element.getViewportHeight() > 600
								? 600
								: Ext.Element.getViewportHeight() - 100;
						ventanaWizard
								.setY(Ext.Element.getViewportHeight()
										/ 2
										- ((Ext.Element.getViewportHeight() > 600
												? 600
												: Ext.Element
														.getViewportHeight()
														- 100) / 2));

					} else {

						if (!Ext.isEmpty(btn.up('wizardaltacomprador'))) {

							ventanaWizard = btn.up('wizardaltacomprador');
							ventanaAltaWizard = ventanaWizard
									.down('datoscompradorwizard');

							ventanaAltaWizard.getForm().reset();

							if (!Ext.isEmpty(pedirDoc)) {
								ventanaAltaWizard.getForm()
										.findField('pedirDoc')
										.setValue(pedirDoc);
								if (pedirDoc == "true") {
									ventanaAltaWizard
											.down('button[itemId=btnCrear]')
											.setText("Crear");
								} else {
									ventanaAltaWizard
											.down('button[itemId=btnCrear]')
											.setText("Continuar");
								}
							}

							if (!Ext.isEmpty(datos.compradorId)) {
								ventanaAltaWizard.idComprador = datos.compradorId;
							} else {

								form = ventanaWizard
										.down('anyadirnuevaofertadocumento').form;
								ventanaAltaWizard
										.getForm()
										.findField('numDocumento')
										.setValue(form
												.findField('numDocumentoCliente')
												.getValue());
								ventanaAltaWizard.getForm()
										.findField('numDocumento').readOnly = true;
								ventanaAltaWizard
										.getForm()
										.findField('codTipoDocumento')
										.setValue(form
												.findField('comboTipoDocumento')
												.getValue());
								ventanaAltaWizard.getForm()
										.findField('codTipoDocumento').readOnly = true;
							}

							if (!Ext.isEmpty(comprador)) {
								if (!Ext.isEmpty(comprador.cesionDatos)) {
									ventanaAltaWizard.getForm()
											.findField('cesionDatos')
											.setValue(comprador.cesionDatos);
								}
								if (!Ext
										.isEmpty(comprador.comunicacionTerceros)) {
									ventanaAltaWizard
											.getForm()
											.findField('comunicacionTerceros')
											.setValue(comprador.comunicacionTerceros);
								}
								if (!Ext
										.isEmpty(comprador.transferenciasInternacionales)) {
									ventanaAltaWizard
											.getForm()
											.findField('transferenciasInternacionales')
											.setValue(comprador.transferenciasInternacionales);
								}
							}
						}
						ventanaWizard.width = Ext.Element.getViewportWidth() > 1370
								? Ext.Element.getViewportWidth() / 2
								: Ext.Element.getViewportWidth() / 1.5;
						ventanaWizard
								.setX(Ext.Element.getViewportWidth()
										/ 2
										- ((Ext.Element.getViewportWidth() > 1370
												? Ext.Element
														.getViewportWidth()
														/ 2
												: Ext.Element
														.getViewportWidth()
														/ 1.5) / 2));
						ventanaWizard.height = Ext.Element.getViewportHeight() > 800
								? 800
								: Ext.Element.getViewportHeight() - 100;
						ventanaWizard
								.setY(Ext.Element.getViewportHeight()
										/ 2
										- ((Ext.Element.getViewportHeight() > 800
												? 800
												: Ext.Element
														.getViewportHeight()
														- 100) / 2));
					}

					ventanaAdjuntarDocumento = ventanaWizard
							.down('anyadirnuevaofertaactivoadjuntardocumento');
					if (!Ext.isEmpty(datos.carteraInternacional)) {
						ventanaAdjuntarDocumento.getForm()
								.findField('carteraInternacional')
								.setValue(datos.carteraInternacional);
					}
					var wizard = btn.up().up().up();
					var layout = wizard.getLayout();
					me.getView().unmask();
					layout["next"]();
				},

				failure : function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
			});
		}
	},


	manageToastJsonResponse : function(scope, jsonData) {
		var me = this;

		if (!Ext.isEmpty(scope)) {
			if (me.fireEvent) {
				scope = me;
			} else {
				scope = Ext.GlobalEvents;
			}
		}

		if (!Ext.isEmpty(jsonData)) {
			var data = JSON.parse(jsonData);
			if (data.success !== null && data.success !== undefined
					&& data.success === "false") {
				var modelData = me.getViewModel().getData();
				for (var entry in modelData) {
					if ((modelData[entry] != null && modelData[entry] != undefined)
							&& modelData[entry].isModel) {
						modelData[entry].reject();
					}
				}

				if (!Ext
						.isEmpty(me.getViewModel().getData().situacionPosesoria)) {
					me.getViewModel().getData().situacionPosesoria.reject();
				}

				me.getViewModel().getData().activo.reject();
				scope.fireEvent("errorToast", data.msgError);

			} else {
				scope.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			}
		} else {
			scope.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		}
	},


	onActivateTabPatrimonioActivo : function(tab, eOpts) {
		var me = this;

		me.getViewModel().get('enableComboRentaAntigua');
		me.getViewModel().get('enableCheckPerimetroAlquiler');

	},

	
    actualizarGridHistoricoDestinoComercial : function(form) {

        if (form.down('historicodestinocomercialactivoform')
                && form.down('historicodestinocomercialactivoform').down('gridBase')
                && form.down('historicodestinocomercialactivoform').down('gridBase').store) {
            form.down('historicodestinocomercialactivoform').down('gridBase').store.load();
        }

    },

 
    onSaveFormularioCompletoTabPatrimonio: function(btn, form){
        var me = this;
        var comboEstadoAlquiler = me.lookupReference('comboEstadoAlquilerRef');
        var comboTipoInquilino = me.lookupReference('comboTipoInquilinoRef');
        var comboOcupado = me.getViewModel().get('activo.ocupado');
        var chkPerimetroAlquiler = me.getViewModel().get('patrimonio.chkPerimetroAlquiler');
        var destinoComercialAlquiler = me.getViewModel().get('activo.isDestinoComercialAlquiler');
        var tieneOfertaAlquilerViva = me.getViewModel().get('activo.tieneOfertaAlquilerViva');
        var isRestringida = me.getViewModel().get('activo.pertenceAgrupacionRestringida');
    	var activoChkPerimetroAlquiler = me.getViewModel().get('activo.activoChkPerimetroAlquiler');
    	var checkHPM = me.getViewModel().get('activo.checkHPM');

        if(comboEstadoAlquiler != null && comboTipoInquilino != null && comboOcupado != null){
            if(comboEstadoAlquiler.value == CONST.COMBO_ESTADO_ALQUILER['ALQUILADO'] && comboOcupado.value == CONST.COMBO_OCUPACION["SI"]){
                me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
            } else if(destinoComercialAlquiler == false && chkPerimetroAlquiler == true){
                me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.destino.comercial"));
            } else if(tieneOfertaAlquilerViva == true && comboEstadoAlquiler.value == CONST.COMBO_ESTADO_ALQUILER['LIBRE']) {
                me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.oferta.alquiler"));
            }else if(comboEstadoAlquiler.value == CONST.COMBO_ESTADO_ALQUILER['LIBRE']){
                comboTipoInquilino.setValue(null);
                if(isRestringida == true && activoChkPerimetroAlquiler != chkPerimetroAlquiler &&  checkHPM != chkPerimetroAlquiler){
            		Ext.Msg.confirm(
        				HreRem.i18n("title.agrupacion.restringida"),
        				HreRem.i18n("msg.confirm.agrupacion.restringida"),
        				function(btnConfirm){
        					if (btnConfirm == "yes"){
        						me.onSaveFormularioCompleto(btn, form, true);
        					}
        				}
        			);
            	} else {
            		me.onSaveFormularioCompleto(btn, form, false);
            	}
            } else {
            	if(isRestringida == true && activoChkPerimetroAlquiler != chkPerimetroAlquiler){
            		Ext.Msg.confirm(
        				HreRem.i18n("title.agrupacion.restringida"),
        				HreRem.i18n("msg.confirm.agrupacion.restringida"),
        				function(btnConfirm){
        					if (btnConfirm == "yes"){
        						me.onSaveFormularioCompleto(btn, form, true);
        					}
        				}
        			);
            	} else {
            		me.onSaveFormularioCompleto(btn, form, false);
            	}
            }
        }

    },
	
    esEditableChkYcombo: function(change, newValue, oldValue, eOpts){
        var me = this;
        var comboEstadoAlquiler = me.lookupReference('comboEstadoAlquilerRef');
        var chkPerimetroAlquiler = me.lookupReference('chkPerimetroAlquilerRef');
		var subrogadoCheckbox = me.lookupReference('subrogadoCheckbox');
        var comboTipoInquilino = me.lookupReference('comboTipoInquilinoRef');
        var tipoComercializacion = me.getViewModel().get('activo.tipoComercializacionCodigo');
        var comboValue = comboEstadoAlquiler.value;
        
        if(!Ext.isEmpty(comboEstadoAlquiler)){
            if(comboValue == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"] || comboValue == CONST.COMBO_ESTADO_ALQUILER["CON_DEMANDAS"]) {
				chkPerimetroAlquiler.setValue(true);
				chkPerimetroAlquiler.setDisabled(true);
				comboTipoInquilino.setDisabled(false);
            } else if(CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA'] != tipoComercializacion){
            	if(CONST.TIPOS_COMERCIALIZACION['VENTA'] == tipoComercializacion){
            		chkPerimetroAlquiler.setValue(false);
            	}else if(CONST.TIPOS_COMERCIALIZACION['ALQUILER'] == tipoComercializacion){
            		chkPerimetroAlquiler.setValue(true);
            	}
				subrogadoCheckbox.setValue(false);
				comboTipoInquilino.setDisabled(true);
				comboTipoInquilino.setValue(null);
            }else{
				subrogadoCheckbox.setValue(false);
				comboTipoInquilino.setDisabled(true);
				comboTipoInquilino.setValue(null);
			}
        }
    },
    
    onClickBotonCancelarComercial: function(btn) {
        var me = this;
        var activeTab = btn.up('tabpanel').getActiveTab();

        if (activeTab.xtype === "gencatcomercialactivo") {

            setTimeout(function(){
                activeTab.down('gencatcomercialactivoform').getBindRecord().reject();
            }, 300);

        }

        me.limpiarBotonesGuardado(btn,activeTab);
    },

    limpiarBotonesGuardado: function(btn, activeTab) {
    	var me = this;


        btn.hide();
        btn.up('tabbar').down('button[itemId=botonguardar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();

        Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
                        function (field, index)
                            {
                                field.fireEvent('save');
                                field.fireEvent('update');});

        if(Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
             me.getViewModel().set("editingFirstLevel", false);
         } else {
             me.getViewModel().set("editing", false);
         }
		me.getViewModel().notify();
    },

   
    //si el activo está ocupado, activa el campo titulo y fuerza validación, si no, lo deshabilita y deshabilita validacion
    
    onChangeComboOcupado: function(combo, newValue, oldValue, eOpts) {

        var conTitulo = combo.up('formBase').down('[reference=comboSituacionPosesoriaConTitulo]');
        
        if (newValue == 0 || newValue == null) {
        	
        	conTitulo.setDisabled(true);
        	conTitulo.setValue('');
        	//conTitulo.allowBlank = true;
        	conTitulo.setAllowBlank(true);
        	
        }else if (newValue == 1){
        	 
        	 conTitulo.setDisabled(false);
        	// conTitulo.allowBlank = false;
        	 //conTitulo.setValue(me.getViewModel().get('situacionPosesoria.conTitulo'));
        	 conTitulo.setAllowBlank(false);
        	conTitulo.validateValue(conTitulo.getValue());
            
        }
        

	},

	enableChkPerimetroAlquiler: function(get){
		 var me = this;
		 var esGestorAlquiler = me.getViewModel().get('activo.esGestorAlquiler');
		 var estadoAlquiler = me.getViewModel().get('patrimonio.estadoAlquiler');
		 var tieneOfertaAlquilerViva = me.getViewModel().get('activo.tieneOfertaAlquilerViva');
		 var incluidoEnPerimetro = me.getViewModel().get('activo.incluidoEnPerimetro');
		 var tipoTituloCodigo = me.getViewModel().get('activo.tipoTituloCodigo');
		 if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || (esGestorAlquiler == true || esGestorAlquiler == "true")){
			 var isAM = me.getViewModel().get('activo.activoMatriz'); /*Si el activo no es Activo Matriz devolverá undefined*/
			 var dadaDeBaja = me.getViewModel().get('activo.agrupacionDadaDeBaja');
			 
			 if(isAM == true) {
				 /*Comprobar si su PA está dada de baja*/
				 if(dadaDeBaja == "true") {
				   	return false; //El checkbox será editable.
				   } else {
				   	return true; //El checkbox no será editable.
				   }
			 }
			 
			 if((tipoTituloCodigo == CONST.TIPO_TITULO_ACTIVO['UNIDAD_ALQUILABLE'] && incluidoEnPerimetro) || (tieneOfertaAlquilerViva === true && (estadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"]))){
				return true;
			} else {
				return undefined;
			}
		} else {
			return true;
		}
	},


	 
	 onChangeCheckPerimetroAlquiler: function(checkbox, newValue, oldValue, eOpts) {

		 var me = this;
		 var comboTipoAlquiler = me.lookupReference('comboTipoAlquilerRef');
		 var comboAdecuacion = me.lookupReference('comboAdecuacionRef');

	   	 if (!newValue) {
    		comboTipoAlquiler.setValue(null);
            comboAdecuacion.setValue(null);
	   	 } 
	},

	onRenderCheckPerimetroAlquiler : function(checkbox) {
		checkbox.setReadOnly(this.enableChkPerimetroAlquiler());

	},

	onChangeCalificacionNegativa : function(me, nValue, oValue) {

		var comboCalificacion = nValue;
		var comboMotivo = me.lookupController('activodetalle')
				.lookupReference('itemselMotivo');
		var comboEstadoMotivo = me.lookupController('activodetalle')
				.lookupReference('motivoCalificacionNegativa');
		var comboResponsableSubsanar = me.lookupController('activodetalle')
				.lookupReference('responsableSubsanar');
		var descMotivoInput = me.lookupController('activodetalle')
				.lookupReference('descMotivo');
		var fechaSubsanacion = me.lookupController('activodetalle')
				.lookupReference('fechaSubsanacion');

		// En la primera carga del componente la oValue tiene valor y la nValue
		// se inicializa a null.
		if (nValue == "01" && oValue == null) {
			comboMotivo.setDisabled(false);
		} else if (comboCalificacion == "01") {
			// Combo Motivo
			comboMotivo.setDisabled(false);
		} else if (nValue == "02" && oValue == "01") {
			/*
			 * HREOS-5432 - NO SE HACE NADA POR LA SIGUIENTE COMPROBACION : Si
			 * al cambiar el "Estado" de un motivo a "Subsanado" se debe de
			 * comprobar si todos los "Motivos" est�n "Subsanados", de ser
			 * as� el valor del campo "Calificaci�n negativa" pasar� a ser
			 * "No", sin bloquearlo y permitiendo editar.
			 */
		} else {
			comboEstadoMotivo.setDisabled(true);
			comboEstadoMotivo.setValue("00");
			comboEstadoMotivo.setAllowBlank(true);
			comboResponsableSubsanar.setDisabled(true);
			comboResponsableSubsanar.setAllowBlank(true);
			comboResponsableSubsanar.setValue(null);
			comboMotivo.setDisabled(true);
			descMotivoInput.setDisabled(true);
			fechaSubsanacion.setDisabled(true);
		}

	},

	onEnlaceAbrirOferta : function(button) {
		var me = this;
		var idExpediente = me.getViewModel().get('contrato.idExpediente');

		if (!Ext.isEmpty(idExpediente)) {
			me.getView().fireEvent('abrirDetalleExpedienteById', idExpediente,
					null, button.reflinks);
		}
	},

	onClickActivoMatriz : function() {
		var me = this;
		var numActivo = me.getViewModel().get('activo.numActivoMatriz');
		if (!Ext.isEmpty(numActivo)) {
			var url = $AC.getRemoteUrl('activo/getActivoExists');
			var data;
			Ext.Ajax.request({
				url : url,
				params : {
					numActivo : numActivo
				},
				success : function(response, opts) {
					data = Ext.decode(response.responseText);
					if (data.success == "true") {
						var titulo = "Activo " + numActivo;
						me.getView().up().fireEvent('abrirDetalleActivoById',
								data.data, titulo);
					} else {
						me.fireEvent("errorToast", data.error);
					}

				},
				failure : function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
			});
		}
	},
	onChangeMotivoCalificacionNegativa : function(me, nValue, oValue) {

		var campoDesc = me.lookupController('activodetalle')
				.lookupReference('descMotivo');

		campoDesc.setDisabled(true);
		campoDesc.allowBlank = true;
		campoDesc.setReadOnly(true);
		campoDesc.setDisabled(true);
		campoDesc.fireEvent('cancel');

		if (me.getValue().length == 0) {
			var comboEstadoCalNegativa = me.lookupController('activodetalle')
					.lookupReference('comboCalificacionNegativaRef');
			comboEstadoCalNegativa.setValue('02');
		}
		this.lookupReference('tituloinformacionregistralactivo').getViewModel().data.nClicks = 0;
	},

	onClickMotivoSelected : function(me, a, b) {

		var activoDetalleController = this;
		var itemSelMotivo = this.lookupReference('itemselMotivo');

		if (!Ext.isEmpty(me.record)) {

			var codMotivoClicked = me.record.data.codigo;

			var comboEstadoMotivo = this
					.lookupReference('motivoCalificacionNegativa');
			var comboResponsableSubsanar = this
					.lookupReference('responsableSubsanar');
			var descMotivoInput = this.lookupReference('descMotivo');
			var fechaSubsanacion = this.lookupReference('fechaSubsanacion');

			// SE COMPRUEBA SI EL ELEMENTO ESTA EN EL COMBO SELECCIONADO.
			if (itemSelMotivo.value.indexOf(codMotivoClicked) >= 0) {
				var numeroClicks = this
						.lookupReference('tituloinformacionregistralactivo')
						.getViewModel().data.nClicks;
				var idActivo = this.getViewModel().get("activo.id");
				var url = $AC
						.getRemoteUrl('activo/getCalificacionNegativaMotivo');
				var tituloInfoRegActivo = this
						.lookupReference('tituloinformacionregistralactivo');
				comboEstadoMotivo.setDisabled(false);
				comboEstadoMotivo.setAllowBlank(false);

				comboResponsableSubsanar.setDisabled(false);
				comboResponsableSubsanar.setAllowBlank(false);

				fechaSubsanacion.setDisabled(false);
				fechaSubsanacion.setAllowBlank(false);

				// SI ES LA 1� VEZ QUE SE SELECCIONA UN ELEMENTO EN EL COMBO
				// SELECCIONADO
				if (numeroClicks == 0) {
					this.cargarDataCalificacionNegativa(url, idActivo,
							codMotivoClicked, comboEstadoMotivo,
							comboResponsableSubsanar, fechaSubsanacion,
							descMotivoInput);
					this.lookupReference('tituloinformacionregistralactivo')
							.getViewModel().data.codMotivoClicked = codMotivoClicked;
				} else {
					if (this
							.lookupReference('tituloinformacionregistralactivo')
							.getViewModel().data.codMotivoClicked != codMotivoClicked) {

						Ext.Msg
								.confirm(
										"Modificar cambios"/* HreRem.i18n("title.agrupacion.restringida") */,
										"&#191;Desea guardar los cambios modificados del motivo seleccionado?"/* HreRem.i18n("msg.confirm.agrupacion.restringida") */,
										function(btnConfirm) {
											if (btnConfirm == "yes") {

												activoDetalleController
														.guardarMotivoCalificacionNegativa(
																me,
																tituloInfoRegActivo
																		.getViewModel().data.codMotivoClicked);
												activoDetalleController
														.cargarDataCalificacionNegativa(
																url,
																idActivo,
																codMotivoClicked,
																comboEstadoMotivo,
																comboResponsableSubsanar,
																fechaSubsanacion,
																descMotivoInput);
											} else {
												activoDetalleController
														.cargarDataCalificacionNegativa(
																url,
																idActivo,
																codMotivoClicked,
																comboEstadoMotivo,
																comboResponsableSubsanar,
																fechaSubsanacion,
																descMotivoInput);
											}
											tituloInfoRegActivo.getViewModel().data.codMotivoClicked = codMotivoClicked;
										});
					}
				}

				this.lookupReference('tituloinformacionregistralactivo')
						.getViewModel().data.nClicks = 1;
			} else {
				comboEstadoMotivo.setDisabled(true);
				comboEstadoMotivo.setAllowBlank(true);
				comboEstadoMotivo.setValue("00");

				comboResponsableSubsanar.setDisabled(true);
				comboResponsableSubsanar.setAllowBlank(true);
				comboResponsableSubsanar.setValue("");

				fechaSubsanacion.setDisabled(true);
				fechaSubsanacion.setAllowBlank(true);
				fechaSubsanacion.setValue(null);
				this.lookupReference('tituloinformacionregistralactivo')
						.getViewModel().data.nClicks = 0;
			}
		}

	},

	cargarDataCalificacionNegativa : function(url, idActivo, codMotivoClicked,
			comboEstadoMotivo, comboResponsableSubsanar, fechaSubsanacion,
			descMotivoInput) {

		Ext.Ajax.request({
			url : url,
			params : {
				idActivo : idActivo,
				idMotivo : codMotivoClicked
			},
			method : 'POST',
			success : function(response, opts) {

				var datos = Ext.decode(response.responseText);

				if (!Ext.isEmpty(datos.data)) {

					if (!Ext
							.isEmpty(datos.data.codigoEstadoMotivoCalificacionNegativa)) {
						comboEstadoMotivo
								.setValue(datos.data.codigoEstadoMotivoCalificacionNegativa);
					} else {
						comboEstadoMotivo.setValue(null);
					}

					if (!Ext.isEmpty(datos.data.codigoResponsableSubsanar)) {
						comboResponsableSubsanar
								.setValue(datos.data.codigoResponsableSubsanar);
					} else {
						comboResponsableSubsanar.setValue(null);
					}

					if (!Ext.isEmpty(datos.data.fechaSubsanacion)) {
						fechaSubsanacion
								.setValue(new Date(datos.data.fechaSubsanacion));
					} else {
						fechaSubsanacion.setValue(null);
					}
					if (!Ext.isEmpty(datos.data.descMotivoInput)) {
						descMotivoInput.setValue(datos.data.descMotivoInput);
					} else {
						descMotivoInput.setValue(null);
					}
					
					descMotivoInput
							.lookupController('tituloinformacionregistralactivo')
							.getViewModel().data.codigoMotivo = datos.data.codigoMotivoCalificacionNegativa;
					
					} else {
						comboEstadoMotivo.setValue("");
						comboResponsableSubsanar.setValue("");
						fechaSubsanacion.setValue("");
						descMotivoInput.setValue("");
						descMotivoInput.setDisabled(true);
					}
					
				}
			});
		},



	enableChkPerimetroAlquiler: function(get){
		 var me = this;
		 var esGestorAlquiler = me.getViewModel().get('activo.esGestorAlquiler');
		 var estadoAlquiler = me.getViewModel().get('patrimonio.estadoAlquiler');
		 var tieneOfertaAlquilerViva = me.getViewModel().get('activo.tieneOfertaAlquilerViva');
		 var incluidoEnPerimetro = me.getViewModel().get('activo.incluidoEnPerimetro');
		 var tipoTituloCodigo = me.getViewModel().get('activo.tipoTituloCodigo');
		 if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || (esGestorAlquiler == true || esGestorAlquiler == "true")){
			 var isAM = me.getViewModel().get('activo.activoMatriz'); /*Si el activo no es Activo Matriz devolverá undefined*/
			 var dadaDeBaja = me.getViewModel().get('activo.agrupacionDadaDeBaja');
			 
			 if(isAM == true) {
				 /*Comprobar si su PA está dada de baja*/
				 if(dadaDeBaja == "true") {
				   	return false; //El checkbox será editable.
				   } else {
				   	return true; //El checkbox no será editable.
				   }
			 }
			 
			 if((tipoTituloCodigo == CONST.TIPO_TITULO_ACTIVO['UNIDAD_ALQUILABLE'] && incluidoEnPerimetro) || (tieneOfertaAlquilerViva === true && (estadoAlquiler == CONST.COMBO_ESTADO_ALQUILER["ALQUILADO"]))){
				return true;
			} else {
				return false;
			}
		 }else{
			 return true;
		 }
	 },
	 
	 onChangeCheckPerimetroAlquiler: function(checkbox, newValue, oldValue, eOpts) {

		 var me = this;
		 var comboTipoAlquiler = me.lookupReference('comboTipoAlquilerRef');
		 var comboAdecuacion = me.lookupReference('comboAdecuacionRef');

	   	 if (!newValue) {
		    		comboTipoAlquiler.setValue(null);
		            comboAdecuacion.setValue(null);
	   	 } 
	},


		
	onClickActivoHRE : function() {
		var me = this;
		var containsFocus = me.lookupReference('labelLinkIdOrigenHRE').containsFocus;
		var numActivo = me.getViewModel().get('activo.idOrigenHre');
		if (!Ext.isEmpty(numActivo) && !containsFocus) {
			var url = $AC.getRemoteUrl('activo/getActivoExists');
			var data;
			Ext.Ajax.request({
				url : url,
				params : {
					numActivo : numActivo
				},
				success : function(response, opts) {
					data = Ext.decode(response.responseText);
					if (data.success == "true") {
						var titulo = "Activo " + numActivo;
						me.getView().up().fireEvent('abrirDetalleActivoById',
								data.data, titulo);
					} else {
						me.fireEvent("errorToast", data.error);
					}

				},
				failure : function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
			});
		}
	},

	guardarMotivoCalificacionNegativa : function(me, codigoMotivoClicked) {

		var ventana = this.lookupReference('tituloinformacionregistralactivo');
		var record = ventana.getBindRecord();
		var fecha = null;

		var url = $AC.getRemoteUrl('activo/saveCalificacionNegativaMotivo');
		if (!Ext.isEmpty(ventana.getForm().getValues().fechaSubsanacion)) {
			fecha = new Date(record.data.fechaSubsanacion);
			fecha.setHours(fecha.getHours() + 5);// FIX SOLUCION AL PROBLEMA
													// DE LA ZONA HORARIA.
		}
		var codigoMotivo = ventana.getViewModel().data.codigoMotivo;

		Ext.Ajax.request({
			url : url,
			params : {
				idActivo : record.id,
				idMotivo : codigoMotivoClicked,
				calificacionNegativa : record.data.calificacionNegativa,
				estadoMotivoCalificacionNegativa : record.data.estadoMotivoCalificacionNegativa,
				responsableSubsanar : record.data.responsableSubsanar,
				descripcionCalificacionNegativa : record.data.descripcionCalificacionNegativa,
				fechaSubsanacion : fecha
			},
			method : 'POST',
			success : function(response, opts) {

				var resultado = Ext.decode(response.responseText).success;
				if (resultado) {
					ventana.fireEvent("infoToast", HreRem
									.i18n("msg.operacion.ok"));
				} else {
					ventana
							.fireEvent("errorToast",
									"No se puede guardar el motivo de calificaci&oacute;n negativa sin datos"/* HreRem.i18n("msg.operacion.ko") */);
				}

			},
			failure : function(record, operation) {
				ventana
						.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
			}
		});

	},

	onChangeEstadoMotivo : function(me, nValue, oValue) {

		var comboEstadoCalNegativa = me.lookupController('activodetalle')
				.lookupReference('comboCalificacionNegativaRef');
		var fechaSubsanacion = me.lookupController('activodetalle')
				.lookupReference('fechaSubsanacion');
		var ventana = this.lookupReference('tituloinformacionregistralactivo');
		var record = ventana.getBindRecord();

		if (!Ext.isEmpty(me.getValue())) {
			if (me.getValue()
					.indexOf(CONST.ESTADOS_MOTIVOS_CAL_NEGATIVA["PENDIENTE"]) >= 0) {
				comboEstadoCalNegativa.setValue('01');
				fechaSubsanacion.setAllowBlank(true);
			} else if (me.getValue()
					.indexOf(CONST.ESTADOS_MOTIVOS_CAL_NEGATIVA["SUBSANADO"]) >= 0) {
				fechaSubsanacion.setAllowBlank(false);
				// COMPROBAR SI TODOS MOTIVOS TIENEN ESTADO MOTIVO SUBSANACION
				// INCLUIDO EL QUE SE ACABA DE MODIFICAR
				var url = $AC
						.getRemoteUrl('activo/getMotivosCalificacionNegativaSubsanados');
				Ext.Ajax.request({
							url : url,
							params : {
								idActivo : record.id,
								idMotivo : ventana.getViewModel().data.codMotivoClicked
							},
							method : 'POST',
							success : function(response, opts) {

								var resultado = Ext
										.decode(response.responseText).data;
								if (resultado == "true") {
									comboEstadoCalNegativa.setValue('02');
								}
							},
							failure : function(record, operation) {
								ventana.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
							}
						});

			}
		}
	},

	onClickCrearOferta : function(btn) {
		var me = this;
		var ventanaDetalle = btn.up().up(), ventanaAlta = ventanaDetalle.up().xtype, url = null, ventanaWizard = null;
		var form = ventanaDetalle.getForm();

		if (form.isValid()) {
			var valueDestComercial, destinoComercialActivo;

			if (ventanaAlta.indexOf('wizardaltacomprador') < 0) {
				if (ventanaDetalle.config.xtype
						.indexOf('activoadjuntardocumento') >= 0) {
					valueDestComercial = ventanaDetalle.up().getViewModel().data.valueDestComercial;
					destinoComercialActivo = ventanaDetalle.up().getViewModel().data.destinoComercialActivo;
				} else {
					valueDestComercial = form.findField('tipoOferta')
							.getSelection().data.descripcion;
					destinoComercialActivo = ventanaDetalle.up().getViewModel().data.destinoComercial;
					ventanaDetalle.up().getViewModel().data.valueDestComercial = valueDestComercial;
					ventanaDetalle.up().getViewModel().data.destinoComercialActivo = destinoComercialActivo;
				}
			}

			if (destinoComercialActivo === valueDestComercial
					|| destinoComercialActivo === CONST.TIPO_COMERCIALIZACION_ACTIVO["ALQUILER_VENTA"]) {
				if (ventanaDetalle.config.xtype
						.indexOf('activoadjuntardocumento') >= 0
						&& ventanaAlta.indexOf('wizardaltacomprador') < 0) {
					ventanaDetalle.setController('activodetalle');
					var esCarteraInternacional = ventanaDetalle.getForm()
							.findField('carteraInternacional').getValue();
					var cesionDatos = form.findField('cesionDatos').getValue(), comunicacionTerceros = form
							.findField('comunicacionTerceros').getValue(), transferenciasInternacionales = form
							.findField('transferenciasInternacionales')
							.getValue();
					ventanaDetalle.up().down('anyadirnuevaofertadetalle')
							.getForm().findField('cesionDatos')
							.setValue(cesionDatos);
					ventanaDetalle.up().down('anyadirnuevaofertadetalle')
							.getForm().findField('comunicacionTerceros')
							.setValue(comunicacionTerceros);
					ventanaDetalle.up().down('anyadirnuevaofertadetalle')
							.getForm()
							.findField('transferenciasInternacionales')
							.setValue(transferenciasInternacionales);

					me.onClickBotonGuardarOferta(btn);

				} else if (ventanaDetalle.config.xtype.indexOf('detalle') >= 0) {

					ventanaDetalle.setController('activodetalle');
					pedirDocValor = form.findField('pedirDoc').getValue();

					if (pedirDocValor == 'false') {
						var docCliente = me.getViewModel()
								.get("oferta.numDocumentoCliente");
						me.getView().mask(HreRem.i18n("msg.mask.loading"));
						url = $AC.getRemoteUrl('activooferta/getListAdjuntos');
						ventanaWizard = btn.up('wizardaltaoferta'), idActivo = ventanaWizard.oferta.data.idActivo, idAgrupacion = ventanaWizard.oferta.data.idAgrupacion;
						ventanaWizard.mask("Cargando documentos comprador");
						Ext.Ajax.request({
							url : url,
							method : 'GET',
							waitMsg : HreRem.i18n('msg.mask.loading'),
							params : {
								docCliente : docCliente,
								idActivo : idActivo,
								idAgrupacion : idAgrupacion
							},

							success : function(response, opts) {
								data = Ext.decode(response.responseText);
								if (!Ext.isEmpty(data.data)) {
									var ventanaWizardAdjuntarDocumento = ventanaWizard
											.down('anyadirnuevaofertaactivoadjuntardocumento'), esInternacional = ventanaWizardAdjuntarDocumento
											.getForm()
											.findField('carteraInternacional')
											.getValue(), cesionDatos = ventanaWizardAdjuntarDocumento
											.getForm().findField('cesionDatos'), transferenciasInternacionales = ventanaWizardAdjuntarDocumento
											.getForm()
											.findField('transferenciasInternacionales'), btnGenerarDoc = ventanaWizardAdjuntarDocumento
											.down('button[itemId=btnGenerarDoc]');
									btnFinalizar = ventanaWizardAdjuntarDocumento
											.down('button[itemId=btnFinalizar]');
									ventanaWizardAdjuntarDocumento.getForm()
											.findField('docOfertaComercial')
											.setValue(data.data[0].nombre);
									ventanaWizardAdjuntarDocumento.down()
											.down('panel').down('button')
											.show();
									btnFinalizar.enable();
									ventanaWizard.unmask();
								}
							},

							failure : function(record, operation) {
								me.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
							}

						});

						var valorCesionDatos = form.findField('cesionDatos')
								.getValue(), valorComTerceros = form
								.findField('comunicacionTerceros').getValue(), valorTransferInternacionales = form
								.findField('transferenciasInternacionales')
								.getValue();
						ventanaDetalle
								.up()
								.down('anyadirnuevaofertaactivoadjuntardocumento')
								.getForm().findField('cesionDatos')
								.setValue(valorCesionDatos);
						ventanaDetalle
								.up()
								.down('anyadirnuevaofertaactivoadjuntardocumento')
								.getForm().findField('comunicacionTerceros')
								.setValue(valorComTerceros);
						ventanaDetalle
								.up()
								.down('anyadirnuevaofertaactivoadjuntardocumento')
								.getForm()
								.findField('transferenciasInternacionales')
								.setValue(valorTransferInternacionales);

						btn.up('wizardaltaoferta').height = Ext.Element
								.getViewportHeight() > 500 ? 500 : Ext.Element
								.getViewportHeight()
								- 100;
						btn
								.up('wizardaltaoferta')
								.setY(Ext.Element.getViewportHeight()
										/ 2
										- ((Ext.Element.getViewportHeight() > 500
												? 500
												: Ext.Element
														.getViewportHeight()
														- 100) / 2));

						var wizard = btn.up().up().up();
						var layout = wizard.getLayout();
						me.getView().unmask();
						layout["next"]();

					} else {

						me.onClickBotonGuardarOferta(btn);
					}

				} else if (ventanaDetalle.config.xtype
						.indexOf('activoadjuntardocumento') >= 0
						&& ventanaAlta.indexOf('wizardaltacomprador') >= 0) {
					ventanaDetalle.setController('expedientedetalle');
					ventanaDetalle.getController()
							.onClickBotonCrearComprador(btn);
				}
			} else {
				me.fireEvent("errorToast", HreRem
								.i18n("wizardOferta.operacion.ko.nueva.oferta")
								+ valueDestComercial);
			}
		}
	},

	comprobarFormato : function() { // FIXME: cuando se reubique dentro de un
									// slide en el wizard eliminar de aqui.
		var me = this;
		value = me.lookupReference('nuevoCompradorNumDoc');
		if (Ext.isEmpty(me.getViewModel()
				.get('expediente.tipoExpedienteCodigo'))) {
			if (value != null) {
				if (me.lookupReference('tipoDocumentoNuevoComprador').value == "01"
						|| me.lookupReference('tipoDocumentoNuevoComprador').value == "15"
						|| me.lookupReference('tipoDocumentoNuevoComprador').value == "03") {

					var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					var str = value.value.toString().toUpperCase();

					if (!nifRexp.test(str) && !nieRexp.test(str)) {
						me.fireEvent("errorToast",
								HreRem.i18n("msg.numero.documento.incorrecto"));
						return false;
					}

					var nie = str.replace(/^[X]/, '0').replace(/^[Y]/, '1')
							.replace(/^[Z]/, '2');

					var letter = str.substr(-1);
					var charIndex = parseInt(nie.substr(0, 8)) % 23;

					if (validChars.charAt(charIndex) === letter) {
						return true;
					} else {
						me.fireEvent("errorToast",
								HreRem.i18n("msg.numero.documento.incorrecto"));
						return false;
					}

				} else if (me.lookupReference('tipoDocumentoNuevoComprador').value == "02") {
					var texto = value.value;
					var pares = 0;
					var impares = 0;
					var suma;
					var ultima;
					var unumero;
					var uletra = new Array("J", "A", "B", "C", "D", "E", "F",
							"G", "H", "I");
					var xxx;

					texto = texto.toUpperCase();

					var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g);
					if (!regular.exec(texto)) {
						me.fireEvent("errorToast",
								HreRem.i18n("msg.numero.documento.incorrecto"));
						return false;
					}

					ultima = texto.substr(8, 1);

					for (var cont = 1; cont < 7; cont++) {
						xxx = (2 * parseInt(texto.substr(cont++, 1)))
								.toString()
								+ "0";
						impares += parseInt(xxx.substr(0, 1))
								+ parseInt(xxx.substr(1, 1));
						pares += parseInt(texto.substr(cont, 1));
					}

					xxx = (2 * parseInt(texto.substr(cont, 1))).toString()
							+ "0";
					impares += parseInt(xxx.substr(0, 1))
							+ parseInt(xxx.substr(1, 1));

					suma = (pares + impares).toString();
					unumero = parseInt(suma.substr(suma.length - 1, 1));
					unumero = (10 - unumero).toString();
					if (unumero == 10) {
						unumero = 0;
					}

					if ((ultima == unumero) || (ultima == uletra[unumero])) {
						return true;
					} else {
						me.fireEvent("errorToast",
								HreRem.i18n("msg.numero.documento.incorrecto"));
						return false;
					}
				} else {
					return true;
				}
			}
		} else {
			if (me.getViewModel().get('expediente.tipoExpedienteCodigo') == "01"
					|| me.getViewModel().get('expediente.tipoExpedienteCodigo') == "02") {
				if (value != null) {
					if (me.lookupReference('tipoDocumentoNuevoComprador').value == "01"
							|| me
									.lookupReference('tipoDocumentoNuevoComprador').value == "15"
							|| me
									.lookupReference('tipoDocumentoNuevoComprador').value == "03") {

						var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
						var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
						var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
						var str = value.value.toString().toUpperCase();

						if (!nifRexp.test(str) && !nieRexp.test(str)) {
							me
									.fireEvent(
											"errorToast",
											HreRem
													.i18n("msg.numero.documento.incorrecto"));
							return false;
						}

						var nie = str.replace(/^[X]/, '0').replace(/^[Y]/, '1')
								.replace(/^[Z]/, '2');

						var letter = str.substr(-1);
						var charIndex = parseInt(nie.substr(0, 8)) % 23;

						if (validChars.charAt(charIndex) === letter) {
							return true;
						} else {
							me
									.fireEvent(
											"errorToast",
											HreRem
													.i18n("msg.numero.documento.incorrecto"));
							return false;
						}

					} else if (me
							.lookupReference('tipoDocumentoNuevoComprador').value == "02") {
						var texto = value.value;
						var pares = 0;
						var impares = 0;
						var suma;
						var ultima;
						var unumero;
						var uletra = new Array("J", "A", "B", "C", "D", "E",
								"F", "G", "H", "I");
						var xxx;

						texto = texto.toUpperCase();

						var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g);
						if (!regular.exec(texto)) {
							me
									.fireEvent(
											"errorToast",
											HreRem
													.i18n("msg.numero.documento.incorrecto"));
							return false;
						}

						ultima = texto.substr(8, 1);

						for (var cont = 1; cont < 7; cont++) {
							xxx = (2 * parseInt(texto.substr(cont++, 1)))
									.toString()
									+ "0";
							impares += parseInt(xxx.substr(0, 1))
									+ parseInt(xxx.substr(1, 1));
							pares += parseInt(texto.substr(cont, 1));
						}

						xxx = (2 * parseInt(texto.substr(cont, 1))).toString()
								+ "0";
						impares += parseInt(xxx.substr(0, 1))
								+ parseInt(xxx.substr(1, 1));

						suma = (pares + impares).toString();
						unumero = parseInt(suma.substr(suma.length - 1, 1));
						unumero = (10 - unumero).toString();
						if (unumero == 10) {
							unumero = 0;
						}

						if ((ultima == unumero) || (ultima == uletra[unumero])) {
							return true;
						} else {
							me
									.fireEvent(
											"errorToast",
											HreRem
													.i18n("msg.numero.documento.incorrecto"));
							return false;
						}
					} else {
						return true;
					}
				}
			} else {
				return true;
			}
		}

	},

	pad : function(number, length) {

		var str = '' + number;
		while (str.length < length) {
			str = '0' + str;
		}

		return str;

	},

	checkOfertaTrabajoVivo : function(ref) {
		var me = this;
		var url = $AC.getRemoteUrl('activo/bloquearChecksComercializacion');
		idActivo = me.getViewModel().get('activo.id'), checkBox = me
				.lookupReference(ref), valorCheck = me.lookupReference(ref)
				.getValue(), action = null, finalVal = false, isOk = true;

		if (!valorCheck) {
			finalVal = true;
		} else {
			finalVal = false;
		}
		switch (ref) {
			case 'chkbxPerimetroGestion' :
				if (me.getViewModel().get('activo.checkGestionarReadOnly') === 'false') {
					checkBox.setRawValue(finalVal)
				} else {
					isOk = true;
				}
				;
				break;
			case 'chkbxPerimetroPublicar' :
				if (me.getViewModel().get('activo.checkPublicacionReadOnly') === 'false') {
					checkBox.setRawValue(finalVal)
				} else {
					isOk = true;
				}
				;
				break;
			case 'chkbxPerimetroComercializar' :
				if (me.getViewModel().get('activo.checkComercializarReadOnly') === 'false') {
					checkBox.setRawValue(finalVal)
				} else {
					isOk = true;
				}
				;
				break;
			case 'chkbxPerimetroFormalizar' :
				if (me.getViewModel().get('activo.checkFormalizarReadOnly') === 'false') {
					checkBox.setRawValue(finalVal)
				} else {
					isOk = true;
				}
				;
				break;

		}

		if ((me.getViewModel().get('activo.activoMatriz') || me.getViewModel()
				.get('activo.unidadAlquilable'))) {
			return isOk;
		}
	},

	validateDocOfertante : function(value) {
		var me = this;
		if (me.lookupReference('cbTipoDocumento').value == "01"
				|| me.lookupReference('cbTipoDocumento').value == "15"
				|| me.lookupReference('cbTipoDocumento').value == "03") {

			var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
			var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
			var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
			var str = value.toString().toUpperCase();

			if (!nifRexp.test(str) && !nieRexp.test(str)) {
				return 'Error! Número de identificación incorrecto';
			}

			var nie = str.replace(/^[X]/, '0').replace(/^[Y]/, '1').replace(
					/^[Z]/, '2');

			var letter = str.substr(-1);
			var charIndex = parseInt(nie.substr(0, 8)) % 23;

			if (validChars.charAt(charIndex) === letter) {
				return true;
			} else {
				return 'Error! Número de identificación incorrecto';
			}

		} else if (me.lookupReference('cbTipoDocumento').value == "02") {
			var texto = value;
			var pares = 0;
			var impares = 0;
			var suma;
			var ultima;
			var unumero;
			var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H",
					"I");
			var xxx;

			texto = texto.toUpperCase();

			var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g);
			if (!regular.exec(texto)) {
				return 'Error! Número de identificación incorrecto';
			}

			ultima = texto.substr(8, 1);

			for (var cont = 1; cont < 7; cont++) {
				xxx = (2 * parseInt(texto.substr(cont++, 1))).toString() + "0";
				impares += parseInt(xxx.substr(0, 1))
						+ parseInt(xxx.substr(1, 1));
				pares += parseInt(texto.substr(cont, 1));
			}

			xxx = (2 * parseInt(texto.substr(cont, 1))).toString() + "0";
			impares += parseInt(xxx.substr(0, 1)) + parseInt(xxx.substr(1, 1));

			suma = (pares + impares).toString();
			unumero = parseInt(suma.substr(suma.length - 1, 1));
			unumero = (10 - unumero).toString();
			if (unumero == 10) {
				unumero = 0;
			}

			if ((ultima == unumero) || (ultima == uletra[unumero])) {
				return true;
			} else {
				return 'Error! Número de identificación incorrecto';
			}
		} else {
			return true;
		}
	},

	disableAgregarGestores : function(get) {
		var me = this;
		var usuarioGestor = me.lookupReference('usuarioGestor');
		var agregarGestor = me.lookupReference('agregarGestor');
		var unidadAlquilable = me.getViewModel().get('activo.unidadAlquilable');

		if (!Ext.isEmpty(usuarioGestor.getSelection()) && !unidadAlquilable)
			agregarGestor.setDisabled(false);
	},

	validarEdicionHistoricoTitulo : function(editor, grid, record) {
		var me = this;
		var isBankia = me.getViewModel().get('activo.isCarteraBankia');
		if (isBankia) {
			return false;
		}
		return grid.rowIdx == 0;
	},

	onChangeEstadoHistoricoTramitacionTitulo : function(combo, newValue,
			oldValue, eOps) {
		var me = this;
		var items = combo.up().items.items, fechas = [];
		for (item in items) {
			fechas[items[item].dataIndex] = items[item];
		}
		
		var storeGridCalificacionNegativa;
		var gridCalifcacion;
		
		if('historicotramitaciontituloadref' === combo.up('grid').getReference()){
			gridCalifcacion = me.lookupReference('calificacionnegativagridad');
			storeGridCalificacionNegativa = gridCalifcacion.getStore();
			
		}else{
			gridCalifcacion = me.lookupReference('calificacionnegativagrid');
			storeGridCalificacionNegativa = gridCalifcacion.getStore();
			
		}
		if (storeGridCalificacionNegativa.data.length > 0) {
			var noSubsanado = false;
			for (var iterador in storeGridCalificacionNegativa.data.items) {
				if (storeGridCalificacionNegativa.data.items[iterador].data.codigoEstadoMotivoCalificacionNegativa != CONST.COMBO_ESTADO_CALIFICACION_NEGATIVA['COD_SUBSANADO']) {
					noSubsanado = true;
				}
			}

			if (noSubsanado&& newValue != CONST.DD_ESP_ESTADO_PRESENTACION['CALIFICADO_NEGATIVAMENTE']) {
				me.fireEvent("errorToast",HreRem.i18n("msg.operacion.ko.calificado.negativamente"));
				combo.setValue(CONST.DD_ESP_ESTADO_PRESENTACION['CALIFICADO_NEGATIVAMENTE']); 
				return;
			};
		}
		
		gridCalifcacion.disableAddButton(true);
		if (combo.getValue() == CONST.DD_ESP_ESTADO_PRESENTACION['CALIFICADO_NEGATIVAMENTE'])
			gridCalifcacion.disableAddButton(false);
		switch (newValue) {

			case CONST.DD_ESP_ESTADO_PRESENTACION['PRESENTACION_EN_REGISTRO'] :
				fechas['fechaPresentacionRegistro'].setDisabled(false);
				fechas['fechaPresentacionRegistro'].allowBlank = false;
				fechas['fechaCalificacion'].setDisabled(true);
				fechas['fechaCalificacion'].setValue();
				fechas['fechaInscripcion'].setDisabled(true);
				fechas['fechaInscripcion'].setValue();
				break;

			case CONST.DD_ESP_ESTADO_PRESENTACION['CALIFICADO_NEGATIVAMENTE'] :
				fechas['fechaPresentacionRegistro'].setDisabled(false)
				fechas['fechaPresentacionRegistro'].allowBlank = false;
				fechas['fechaCalificacion'].setDisabled(false);
				fechas['fechaCalificacion'].allowBlank = false;
				fechas['fechaInscripcion'].setDisabled(true);
				fechas['fechaInscripcion'].setValue();
				break;

			case CONST.DD_ESP_ESTADO_PRESENTACION['INSCRITO'] :
				fechas['fechaPresentacionRegistro'].setDisabled(false)
				fechas['fechaPresentacionRegistro'].allowBlank = false;
				fechas['fechaCalificacion'].setDisabled(true);
				fechas['fechaCalificacion'].setValue();
				fechas['fechaInscripcion'].setDisabled(false);
				fechas['fechaInscripcion'].allowBlank = false;
				break;
		}

		me.usuarioLogadoPuedeEditar();
	},
	checkDateInterval : function(obj) {
		if (!obj.readOnly && !obj.disabled) {
			var me = this;
			var dateStamp = obj.previousSibling('[reference=fechaPresentacionRegistro]').getValue().getTime();
			obj.setMinValue(new Date(dateStamp));
			if (obj.isExpanded) {
				obj.collapse();
			} else {
				obj.expand();
			}
		}
	},

	usuarioLogadoPuedeEditar : function() {
		var me = this;
		var usuariosValidos = $AU.userIsRol(CONST.PERFILES['HAYASUPER'])
				|| $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION'])
				|| $AU.userIsRol(CONST.PERFILES['GESTORIA_ADMISION'])
				|| $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']);
		if (!usuariosValidos) {
			me.lookupReference("fechaInscripcion").setDisabled(true);
		}
	},

	usuarioLogadoEditar : function() {
		var me = this;
		var usuariosValidos = $AU.userIsRol(CONST.PERFILES.HAYASUPER)
				|| $AU.userIsRol(CONST.PERFILES.SUPERVISOR_ADMINISTRACION)
				|| $AU.userIsRol(CONST.PERFILES.GESTOR_ADMINISTRACION)
				|| $AU.userIsRol(CONST.PERFILES.GESTORIAS_ADMINISTRACION);

		if (usuariosValidos) {
			me.lookupReference("subestadoGestion").readOnly = false;
			me.lookupReference("estadoLocalizacion").readOnly = false;
		} else {
			me.lookupReference("subestadoGestion").readOnly = true;
			me.lookupReference("estadoLocalizacion").readOnly = true;
		}
	},

	onInsertarAutorizacionTramOfertas : function(btn) {

		var me = this;
		Ext.Msg.confirm(HreRem.i18n("title.autorizar.tramitacion.ofertas"),
				HreRem.i18n("msg.autorizar.tramitacion.activo.ofertas"),
				function(boton) {

					if (boton == "yes") {

						var url = $AC
								.getRemoteUrl('activo/insertarActAutoTram');
						var parametros = btn.up("comercialactivo")
								.getBindRecord().getData();

						Ext.Ajax.request({

							url : url,
							params : parametros,

							success : function(response, opts) {

								if (Ext.decode(response.responseText).success == "false") {
									me
											.fireEvent(
													"errorToast",
													HreRem
															.i18n(Ext
																	.decode(response.responseText).errorCode));
								} else {
									me.fireEvent("infoToast", HreRem
													.i18n("msg.operacion.ok"));
									me.getViewModel().set(
											'comercial.tramitable', true);
									btn
											.up('activosdetallemain')
											.lookupReference('comercialactivotabpanelref')
											.funcionRecargar();
								}

								btn.up("comercialactivo").funcionRecargar();
							},
							failure : function(a, operation, context) {
								me.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
							}
						});
					}
				});
	},

	descargarAdjuntoTributo : function(grid, record) {
		var me = this;

		var nombreAdjuntoTributo = record.data.nombre;
		if (nombreAdjuntoTributo != undefined) {
			var config = {};

			config.url = $AC.getWebPath()
					+ "tributo/bajarAdjuntoActivoTributo."
					+ $AC.getUrlPattern();
			config.params = {};
			config.params.id = record.data.id;
			config.params.nombreDocumento = nombreAdjuntoTributo.replace(",",
					"");
			me.fireEvent("downloadFile", config);
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		}
	},

	eliminarAdjuntoTributo : function(grid, record) {
		var me = this;

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		var id = record.data.id;
		var idEntidad = grid.up().idTributo;

		var url = $AC.getRemoteUrl('tributo/deleteAdjunto');
		Ext.Ajax.request({
					url : url,
					params : {
						id : id,
						idEntidad : idEntidad
					},
					success : function(response, opts) {
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
						grid.getStore().load()
					},
					failure : function(record, operation) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
					},
					callback : function(record, operation) {
						me.getView().unmask();
					}
				});
	},

	abrirVentanaAdjuntarDocTributo : function(grid) {
		var me = this;
		var idTributo = grid.up().idTributo;
		var idActivo = grid.up().idActivo;

		Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoTributo", {
					entidad : 'tributo',
					idEntidad : idActivo,
					parent : grid,
					idTributo : idTributo
				}).show();
	},

	onSelectedRow : function(grid, record, index) {
		me = this;
		if (!Ext.isEmpty(record)) {
			idOferta = record.data.idOferta;
			if (idOferta
					&& !Ext.isEmpty(me.view
							.down('[reference=cloneExpedienteButton]'))) {
				var hideButton = record.data.codigoEstadoOferta != CONST.ESTADOS_OFERTA['RECHAZADA'];
				me.view.down('[reference=cloneExpedienteButton]')
						.setDisabled(hideButton);
			}
		}
	},

	onDeselectedRow : function(grid, record, index) {
		me = this;
		if (!Ext.isEmpty(record)) {
			idOferta = record.get("idOferta");
		}
		if (!Ext.isEmpty(me.view.down('[reference=cloneExpedienteButton]'))) {
			me.view.down('[reference=cloneExpedienteButton]').setDisabled(true);
		}
	},

	clonateOferta : function(numIdOferta, ofertasGrid) {
		var url = $AC.getRemoteUrl('activo/clonateOferta');
		Ext.Ajax.request({
					url : url,
					params : {
						idOferta : numIdOferta
					},

					success : function(response, opts) {
						data = Ext.decode(response.responseText);
						var id = data.data;
						me.fireEvent("infoToast", HreRem
										.i18n("msg.operacion.ok"));
						ofertasGrid.unmask();
						me.onClickBotonRefrescar();
					},
					failure : function(a, operation) {
						me.fireEvent("errorToast", HreRem
										.i18n("msg.operacion.ko"));
						ofertasGrid.unmask();
						me.onClickBotonRefrescar();
					}
				});
	},

	usuarioTieneFuncionPermitirTramitarOfertaC : function(get) {
		var me = this;
		var comercial = me.getViewModel()
				.get('activo.pertenceAgrupacionComercial');
		var restringida = me.getViewModel()
				.get('activo.pertenceAgrupacionRestringida');

		if (!comercial && !restringida
				&& me.getViewModel().get('activo.isCarteraBankia')) {
			var tramitar = me.getView()
					.lookupReference('labelActivoNoTramitable').hidden;
			var funcion = $AU.userHasFunction('AUTORIZAR_TRAMITACION_OFERTA');
			if (!tramitar) {
				me.getView().lookupReference('autorizacionTramOfertas')
						.setHidden(!funcion);
			} else {
				me.getView().lookupReference('autorizacionTramOfertas')
						.setHidden(true);
			}
		} else {
			me.getView().lookupReference('autorizacionTramOfertas')
					.setHidden(true);
		}
	},

	usuarioTieneFuncionPermitirTramitarOferta : function(get) {

		var me = this;
		var comercial = me.getViewModel()
				.get('activo.pertenceAgrupacionComercial');
		var restringida = me.getViewModel()
				.get('activo.pertenceAgrupacionRestringida');
		var tramitar = true;

		if (!comercial && !restringida
				&& me.getViewModel().get('activo.isCarteraBankia')) {

			var esTramitable = me.getViewModel().get('comercial');
			if (esTramitable == null || esTramitable == undefined) {
				esTramitable = me.getViewModel().get('activo.tramitable');
				if (esTramitable == "false") {
					tramitar = false;
				}
			} else {
				if (esTramitable.data.tramitable != undefined
						|| esTramitable.data.tramitable != null) {
					tramitar = esTramitable.data.tramitable;
				}
			}

			var funcion = $AU.userHasFunction('AUTORIZAR_TRAMITACION_OFERTA');
			if (!tramitar) {
				me.getView().lookupReference('autorizacionTramOfertas')
						.setHidden(!funcion);
			} else {
				me.getView().lookupReference('autorizacionTramOfertas')
						.setHidden(true);
			}
		} else {
			me.getView().lookupReference('autorizacionTramOfertas')
					.setHidden(true);
		}

	},

	cargarTabDataComercial : function(form) {
		var me = this, model = null, models = null, nameModels = null, id = me
				.getViewModel().get("activo.id");

		form.mask(HreRem.i18n("msg.mask.loading"));
		if (!form.saveMultiple) {
			model = form.getModelInstance(), model.setId(id);
			if (Ext.isDefined(model.getProxy().getApi().read)) {
				// Si la API tiene metodo de lectura (read).
				model.load({
							success : function(record, b, c, d) {
								form.setBindRecord(record);

								if (Ext.isFunction(form.afterLoad)) {
									form.afterLoad();
								}
								me.usuarioTieneFuncionPermitirTramitarOferta();
								form.unmask();
							},
							failure : function(operation) {
								form.up("tabpanel").unmask();
								me.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
							}
						});
			} else {
				// Si la API no contiene metodo de lectura (read).
				form.setBindRecord(model);
				form.unmask();
				if (Ext.isFunction(form.afterLoad)) {
					form.afterLoad();
				}
			}
		} else {
			models = form.getModelsInstance();
			me.cargarTabDataMultiple(form, 0, models, form.records);
		}
	},

	onTributoClick : function(grid, record) {
		var me = this;
		var gridDocs = grid.up().up()
				.down("[reference='documentostributosgridref']");
		var listadoDocumentosTrabajo = gridDocs
				.down("[reference='listadoDocumentosTributo']");
		gridDocs.idActivo = me.getViewModel().get("activo.id");

		if (!Ext.isEmpty(grid.selection)) {
			gridDocs.down('[xtype=toolbar]').items.items[0].setDisabled(false);
			gridDocs.idTributo = record.data.idTributo;
			listadoDocumentosTrabajo.getStore().getProxy().setExtraParams({
						'idTributo' : record.data.idTributo
					});
			listadoDocumentosTrabajo.getStore().load();
		} else {
			me.deselectTributo();
		}

	},

	deselectTributo : function() {
		var me = this;
		var gridDocs = this.lookupReference('documentostributosgridref')
		var listadoDocumentosTrabajo = gridDocs
				.down("[reference='listadoDocumentosTributo']");
		gridDocs.idActivo = me.getViewModel().get("activo.id");
		listadoDocumentosTrabajo.getStore().getProxy().setExtraParams({
					'idTributo' : null
				});
		gridDocs.idTributo = null;
		listadoDocumentosTrabajo.getStore().load();
		gridDocs.down('[xtype=toolbar]').items.items[0].setDisabled(true);
		gridDocs.down('[xtype=toolbar]').items.items[1].setDisabled(true);
	},

	onChkbxSubfaseChange : function(chkbox, newValue, oldValue) {
		var modelValue = chkbox.lookupController().getViewModel().data.fasepublicacionactivo.data.subfasePublicacionCodigo;
		if (newValue != modelValue) {
			var me = this;
			var faseComentario = me.lookupReference('faseComentario');
			faseComentario.reset();
		}
	},

	onChkbxFaseChange : function(chkbox, newValue, oldValue) {
		var comboSubfase = chkbox.lookupController().getView()
				.lookupReference('chkbxSubfase');
		if (newValue != '01') {
			comboSubfase.setAllowBlank(false);
		} else {
			comboSubfase.setAllowBlank(true);
		}
	},
	comboTipoAlquilerOnChange : function(check, newVal, oldVal, eOps) {
		var me = this;
		try {
			if (CONST.TIPO_ALQUILER['CARITAS'] === newVal) {
				var cesionDatosValue = me.lookupReference('cesionDeUsoRef')
						.getValue();
				if (CONST.DD_CDU_CESION_USO['CESION_GENERALITAT_CX'] === cesionDatosValue) {
					check.reset();
					throw HreRem
							.i18n("msg.exception.no.se.puede.seleccionar.caritas");
				} else {
					me.lookupReference('cesionDeUsoRef').on('expand',
							me.doCesionUsoFilter);
				}
			} else {
				me.doClearFilter(me.lookupReference('cesionDeUsoRef'));
				me.lookupReference('cesionDeUsoRef').un('expand',
						me.doCesionUsoFilter);
			}
		} catch (error) {
			me.fireEvent("errorToast", error);
		}
	},
	comboCesionUsoOnChage : function(check, newVal, oldVal, eOps) {
		var me = this;
		try {
			if (CONST.DD_CDU_CESION_USO['CESION_GENERALITAT_CX'] === newVal) {
				var tipoAlquilerValue = me
						.lookupReference('comboTipoAlquilerRef').getValue();
				if (CONST.TIPO_ALQUILER['CARITAS'] === tipoAlquilerValue) {
					check.reset();
					throw HreRem
							.i18n("msg.exception.no.se.puede.seleccionar.cesion.generalitad.cx");
				} else {
					me.lookupReference('comboTipoAlquilerRef').on('expand',
							me.doTipoAlquilerFilter);
				}
			} else {
				this.doClearFilter(me.lookupReference('comboTipoAlquilerRef'));
				me.lookupReference('comboTipoAlquilerRef').un('expand',
						me.doTipoAlquilerFilter);
			}
		} catch (error) {
			me.fireEvent("errorToast", error);
		}
	},
	doCesionUsoFilter : function() {
		var me = this;
		me.getStore().filter({
			fn : function(record) {
				return CONST.DD_CDU_CESION_USO['CESION_GENERALITAT_CX'] !== record.data.codigo;
			},
			scope : this
		})
	},
	doTipoAlquilerFilter : function() {
		var me = this;
		me.getStore().filter({
					fn : function(record) {
						return CONST.TIPO_ALQUILER['CARITAS'] !== record.data.codigo;
					},
					scope : this
				})
	},
	doClearFilter : function(dom) {
		if (dom !== null && typeof dom !== 'undefined'
				&& typeof dom.getStore === 'function') {
			dom.getStore().clearFilter();
		}
	},
	doFilterEstadoGestionByUserRol : function(combo) {
		if ($AU.userIsRol(CONST.PERFILES['GESTIAFORM'])) {
			if (combo !== null && typeof combo !== "undefined") {
				combo.getStore().filter({
					fn : function(record) {
						return CONST.DD_ESTADO_GEST_PLUVS["RECHAZADO"] !== record.data.codigo;
					},
					scope : this
				});
			}
		}
	},

	onChangeComboGestPlusv : function(combo, value) {
		var me = this;
		var observaciones = me.lookupReference('plusvObservacionesGestion');
		if (value == CONST.DD_ESTADO_GEST_PLUVS["RECHAZADO"]) {
			observaciones.setDisabled(false);
		} else {
			observaciones.setDisabled(true);
		}
	},
	getVisiblityOfBotons : function() {
		return this.getViewModel().get('activo.unidadAlquilable');
	},
	
	validarEdicionHistoricoSolicitudesPrecios: function(editor, grid) {
    	var me = this;
    	
    	if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_PRECIOS']) || $AU.userIsRol(CONST.PERFILES['GESTOR_PUBLICACION'])) {
    		return grid.record.data.esEditable;
    	}
    	
    	return false;
    	
    },
    
    aplicarDescripcion: function(btn, form) {
    	var me = btn.up();
    	Ext.Msg.show({
		   title: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.aplicar'),
		   msg: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.aplicar.desea'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		        if (buttonId == 'yes') {
		        	var url =  $AC.getRemoteUrl('activo/saveDatoRemCalidadDatoPublicacion');
		        	var activoId = btn.up("form").getBindRecord().data.idActivo;
					var activo = btn.up("form").lookupController().getViewModel().get("activo");
					var idActivo = btn.up("form").getBindRecord().data.idActivo;
					var listIdActivo = [idActivo];
					var valor = btn.up("form").getBindRecord().data.dqFase4Descripcion;
					
					// CREACIÓN VENTANA
					
					
							if (activo.get("pertenceAgrupacionObraNueva")){
								me.up('form').mask(HreRem.i18n("msg.mask.loading"));
								btn.up().lookupController().crearVentanaPropagacionCalidadDato(valor);
								
							} else if (activo.get("pertenceAgrupacionRestringida")) {
								Ext.Msg.show({
									   title: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.aplicar'),
									   msg: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.aplicar.lote.restringido'),
									   buttons: Ext.MessageBox.YESNO,
									   fn: function(buttonId) {
									        if (buttonId == 'yes') {      	
									        	me.lookupController().actualizarPropagacionEq(listIdActivo, valor, true);
											
									        } else if(buttonId == 'no') {
									        	me.lookupController().actualizarPropagacionEq(listIdActivo, valor, false);
									        	this.close();
									        }
									   }
									});
								
							} else {
								me.lookupController().actualizarPropagacionEq(listIdActivo, valor, false);
							}

						
		        } else if(buttonId == 'no') {
		        	this.close();
		        }
		   }
		});
    },
    
    disableBtnDescF1: function(get){
     	return get('calidaddatopublicacionactivo.disableDescripcion');
	 },
	 
    crearVentanaPropagacionCalidadDato: function(valor) {
   	 	var url =  $AC.getRemoteUrl('activo/getActivosPropagables');
   	 	var activo = this.getViewModel().get("activo.id");
   	 	var me = this; 
		Ext.Ajax.request({
			url: url,
			method : 'POST',
			params: {idActivo: activo},
			success: function(response, opts){
					var activosPropagables = Ext.decode(response.responseText).data.activosPropagables;
					var arrayPropagables = [];
					for(var i = 0; i < activosPropagables.length; i++){
						arrayPropagables.push(activosPropagables[i]);
					}
					var ventanaOpcionesPropagacionCambios = Ext.create("HreRem.view.activos.detalle.OpcionesPropagacionCambiosDq", {activoActual: activo, activos: arrayPropagables, valor: valor}).show();
					me.getView().add(ventanaOpcionesPropagacionCambios);
					me.getView().unmask();
			}, failure: function (a, operation, context) {
            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
            }
		     
		 });
    },
    
    onClickGuardarPropagarCambiosEq: function(btn) {
        var me = this;
    	var window = btn.up("window"),
    	grid = me.lookupReference("listaActivos"),
    	radioGroup = me.lookupReference("opcionesPropagacion"),
    	activosSeleccionados = grid.getSelectionModel().getSelection(),
    	opcionPropagacion = radioGroup.getValue().seleccion;
        var estaActivoActual = false;
        window.mask(HreRem.i18n("msg.mask.loading"));
    	if (opcionPropagacion == "4" &&  activosSeleccionados.length == 0) {
        	me.fireEvent("errorToast", HreRem.i18n("msg.no.activos.seleccionados"));
        	window.unmask();
        	return false;
    	}
    	
    	var activosParaPropagar = [];
    	for(var i = 0; i < activosSeleccionados.length; i++){
    		activosParaPropagar.push(activosSeleccionados[i].data.activoId);
		}
    	
    	if(!activosParaPropagar.includes(window.activoActual.toString())) {
    		activosParaPropagar.push(window.activoActual);
    	}
    	// Comprobar si en la lista activosParaPropagar está el activoActual. Si no está se añade.
    	
    	me.actualizarPropagacionEq(activosParaPropagar, window.valor, false, window);
    	
	},

	checkVisibilityOfBtnCrearTrabajo: function () {
		var me = this;
		var enPerimetro = me.getViewModel().get('activo.incluidoEnPerimetro') == 'true';
		var isSuper = $AU.userIsRol(CONST.PERFILES['HAYASUPER']);
		var isGestorActivos = $AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']);
		var isGestorAlquiler = $AU.userGroupHasRole(CONST.PERFILES['GESTOR_ALQUILER_HPM']);
		var isUserGestedi = $AU.userIsRol(CONST.PERFILES['GESTEDI']);
		
		return !enPerimetro || (!isSuper && !isGestorActivos && !isGestorAlquiler && !isUserGestedi);
							  
		
	 },

	
    onSaveFormularioCompletoTabAdmisionTitulo : function(btn, form) {
		// Redireccion al controlador de la vista para mantener todos los
		// m�todos ordenados, sin alterar la arquitectura del tab principal.
		form.lookupController().saveTabData(btn, form);
	},

	isGestorAdmisionAndSuperComboTipoAlta: function(combo, value, oldValue, eOpts){
		var me = this; 	
		var gestores = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) ||  $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']);		
		var comboActivoRecovery = me.lookupReference('idRecovery');			
		if(comboActivoRecovery!=null && gestores){					
			combo.setValue(CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']);
			combo.setReadOnly(true);
		}else{
			combo.setReadOnly(false);
		}
					
	},

    
    actualizarPropagacionEq: function(activosParaPropagar, valor, soyRestringidaQuieroActualizar, window ){
    	var me = this;
    	var url = $AC.getRemoteUrl('activo/saveDatoRemCalidadDatoPublicacion');
    	var ventana = window;
    	
    	me.getView().mask(HreRem.i18n("msg.mask.loading"));
    	Ext.Ajax.request({
			url: url,
			method : 'POST',
			params: {
				activosSeleccionados: activosParaPropagar,
				dqFase4Descripcion: valor,
				soyRestringidaQuieroActualizar: soyRestringidaQuieroActualizar
			},
			success: function(response, opts){
				me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				me.refrescarActivo(true);
				if(ventana != undefined){
					ventana.unmask();
					ventana.close();
				}
				me.getView().unmask();
			}, failure: function (a, operation, context) {
            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
            	if(ventana != undefined){
					ventana.unmask();
					ventana.close();
				}
            	me.refrescarActivo(true);
            	me.getView().unmask();
            }
		     
    	});
    },
	
    onChangeComboTributacionAdqusicion: function(combo, newValue, oldValue){
    	var me = this;
		var fechaVencTpoBonificacion = me.lookupReference('fechaVencTpoBonificacion');
		var fechaLiqComplementaria = me.lookupReference('fechaLiqComplementaria');

		if(newValue == "BON"){
			fechaVencTpoBonificacion.setDisabled(false);
			fechaLiqComplementaria.setDisabled(false);
		}else if(newValue == "ORD" && oldValue != null){
			fechaVencTpoBonificacion.setDisabled(true);
			fechaVencTpoBonificacion.setValue("");
			fechaLiqComplementaria.setDisabled(true);
			fechaLiqComplementaria.setValue("");
		}else{
			fechaVencTpoBonificacion.setDisabled(true);
			fechaLiqComplementaria.setDisabled(true);
		}
	},


	onClickDescargarExcelEvolucion : function(btn) {

		var me = this, config = {};
		config.params = {};
		config.params.id = me.getViewModel().getData().activo.id;
		config.method = 'POST';
		config.url = $AC.getWebPath()
				+ "activoadmisionevolucion/generateExcel."
				+ $AC.getUrlPattern();
		me.fireEvent("downloadFile", config);
	},

	checkAdmision : function() {
		var me = this;
		var enPerimetroAdmision = me.getViewModel()
				.get('activo.perimetroAdmision') == false;
		me.isAdmisionActivo(enPerimetroAdmision);
	},

	onSelectPerimetroAdmision : function(combo, record) {
		var me = this;
		var isPerimetroAdmision = record.get('codigo') === 'true';
		me.isAdmisionActivo(isPerimetroAdmision);
	},

	isAdmisionActivo : function(enPerimetroAdmision) {
		var me = this;
		var component = null;
		var detalle = me.getView().down('activosdetalle');
		var isDisabled = false;
		if (detalle && detalle.items && detalle.items.items) {
			var items = detalle.items.items;
			for (var i = 0; i < items.length; i++) {
				var item = items[i];
				if ("admisionactivo".includes(item.xtype)) {
					component = item;
					isDisabled = item.isDisabled();
					break;
				}
			}
		}
		me.setDisabledTabAdmision(isDisabled, enPerimetroAdmision, component);

	},

	setDisabledTabAdmision : function(isDisabled, enPerimetroAdmision,
			component) {
		if (isDisabled && !enPerimetroAdmision) {
			component.setDisabled(false);
		} else if (!isDisabled && enPerimetroAdmision) {
			component.setDisabled(true);
		}
	},

	onChangeExento: function(combo, value){
		var me = this;
		var res = me.lookupReference('motExento');
		if(value == '01'){
			res.allowBlank=false;
		}else{
			res.allowBlank=true;
		}
	},

	mostrarObservacionesGrid : function(event, target, options) {
		var me = this;
		var observacionesAdmision = target.data.observacionesEvolucion;

		me.getView().fireEvent('openModalWindow',
				"HreRem.view.activos.detalle.CrearEvolucionObservaciones", {
					observacionesAdmision : observacionesAdmision
				});

	},

	onClickCerrarObservacionesEvolucion : function(btn) {
		var me = this;
		btn.up('window').hide();
	},

	onActivoEpa : function(combo, value) {
		var me = this,
			activoEpa = me.lookupReference('activoEpa'),
			activobbvaEmpresa = me.lookupReference('activobbvaEmpresa'), 
			activobbvaOficina = me.lookupReference('activobbvaOficina'), 
			activobbvaContrapartida = me.lookupReference('activobbvaContrapartida'), 
			activobbvaFolio = me.lookupReference('activobbvaFolio'), 
			activobbvaCdpen = me.lookupReference('activobbvaCdpen');

		if(activoEpa.value == "true" 
			|| (!Ext.isEmpty(activobbvaEmpresa.getValue()) || !Ext.isEmpty(activobbvaOficina.getValue()) || !Ext.isEmpty(activobbvaContrapartida.getValue()) 
			|| !Ext.isEmpty(activobbvaFolio.getValue()) || !Ext.isEmpty(activobbvaCdpen.getValue()))) {
			activobbvaEmpresa.allowBlank = false;
			activobbvaOficina.allowBlank = false;
			activobbvaContrapartida.allowBlank = false;
			activobbvaFolio.allowBlank = false;
			activobbvaCdpen.allowBlank = false;
		} else{
			activobbvaEmpresa.allowBlank = true;
			activobbvaOficina.allowBlank = true;
			activobbvaContrapartida.allowBlank = true;
			activobbvaFolio.allowBlank = true;
			activobbvaCdpen.allowBlank = true;
		}
	},

	onClickBotonCancelarVentanaComplementoTitulo : function(btn) {
		btn.up('window').hide();
	},

	onClickBotonAnyadirComplementoTitulo : function(btn) {

		var me = this;		
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		var correcto = true;
		var form = btn.up().up().down("form");
		url = $AC.getRemoteUrl("activo/createComplementoTitulo");		
		var idActivo =  me.getViewModel().data.activo;
		var comboTipoTitulo = me.lookupReference('comboTipoTituloRef');
		var fechaSolicitud = me.lookupReference('fechaSolicitudRef');
		var fechaTitulo = me.lookupReference('fechaTituloRef');
		var fechaRecepcion = me.lookupReference('fechaRecepcionRef');
		var fechaInscripcion = me.lookupReference('fechaInscripcionRef');
		var observaciones = me.lookupReference('observacionesRef');
		

		if (fechaRecepcion.getValue() != null) {
			if (fechaRecepcion.getValue() < fechaTitulo.getValue()) {
				correcto = false;
			}
		}

		if (fechaInscripcion.getValue() != null) {
			if (fechaInscripcion.getValue() < fechaTitulo.getValue()) {
				correcto = false;
			}
		}
		if (correcto) {
			if (form.isValid()) {
				form.submit({
							url : url,
							params : {
								activoId : idActivo,
								codTitulo : comboTipoTitulo.getValue(),
								fechaSolicitud : fechaSolicitud.getValue(),
								fechaTitulo : fechaTitulo.getValue(),
								fechaRecepcion : fechaRecepcion.getValue(),
								fechaInscripcion : fechaInscripcion.getValue(),
								observaciones : observaciones.getValue()
							},
							success : function(fp, o) {
								me.fireEvent("infoToast", HreRem
												.i18n("msg.operacion.ok"));
								me.getView().fireEvent(
										"refreshEntityOnActivate",
										CONST.ENTITY_TYPES['ACTIVO'], idActivo);
								me.getView().unmask();
								me
										.onClickBotonCancelarVentanaComplementoTitulo(btn);

							},
							failure : function(record, operation) {
								me.fireEvent("errorToast", HreRem
												.i18n("msg.operacion.ko"));
								me.unmask();
							}
						});
			} else {
				me.getView().unmask();
			}
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.no.valida"));
			me.getView().unmask();
		}

	},

	gestoresEstadoNotarialAndIDHayaNotNull : function(combo, value, oldValue,
			eOpts) {
		var me = this;
		var gestores = $AU.userIsRol(CONST.PERFILES['HAYASUPER'])
				|| $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION'])
				|| $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']);
		var valorIdHaya = me.lookupReference('labelLinkIdOrigenHRE').getValue();
		var origenAnteriorActivo = me.lookupReference('comboOrigenAnteriorActivoRef');
		var origenAnteriorActivoBbva = me.lookupReference('comboOrigenAnteriorActivoBBVARef');		
		var fechatituloAnterior = me.lookupReference('fechaTituloAnteriorRef');
		var sociedadPagoAnterior = me
				.lookupReference('sociedadPagoAnteriorRef');
		if (value == CONST.DD_STA_SUBTIPO_TITULO_ACTIVO['NOTARIAL_RECOMPRA']
				&& valorIdHaya != null && gestores) {
			origenAnteriorActivo.setReadOnly(true);
			origenAnteriorActivoBbva.setReadOnly(true);
			fechatituloAnterior.setReadOnly(true);
			sociedadPagoAnterior.setReadOnly(true);
		} else {
			origenAnteriorActivo.setReadOnly(false);
			origenAnteriorActivoBbva.setReadOnly(false);
			fechatituloAnterior.setReadOnly(false);
			sociedadPagoAnterior.setReadOnly(false);
		}
		//Comprobar de nuevo este metodo solo si tiene IdOrigen (PARA ACTIVOS BBVA)
		var idOrigen = me.getView().getViewModel().get('activo.idOrigenHre');
		if (idOrigen != null) {
			me.ocultarCamposIdOrigen();
		}
	},

	/*isGestorAdmisionAndSuperComboTipoAlta : function(combo, value, oldValue,
			eOpts) {
		var me = this;
		var tipoAlta = me.lookupReference('tipoAltaRef');
		
		var gestores = $AU.userIsRol(CONST.PERFILES['HAYASUPER'])
				|| $AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION'])
				|| $AU.userIsRol(CONST.PERFILES['SUPERUSUARO_ADMISION']);
		//var comboActivoRecovery = me.lookupReference('idRecovery');
		var tipoAltaCodigo = me.getViewModel().get('activo.tipoAltaCodigo');		
		var activoRecovery=me.getViewModel().get('activo.idRecovery');
		if (activoRecovery != null && !gestores) {
			tipoAlta.setValue(CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']);
			tipoAlta.setReadOnly(true);
		} else {
			//tipoAlta.setValue(CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']);
			tipoAlta.setReadOnly(false);
		}
		if (gestores) {
			if (activoRecovery == null) {
				
				tipoAlta.setReadOnly(false);
			}else{
				if (tipoAltaCodigo.getValue() != CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA'] ) {
					
					tipoAlta.setReadOnly(false);
				}else if (tipoAltaCodigo.getValue() == CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA'] ){
					
					tipoAlta.setValue(CONST.DD_TAL_TIPO_ALTA['ALTA_AUTOMATICA']);
					tipoAlta.setReadOnly(true);
				}
			}
		}else{
			tipoAlta.setReadOnly(true);
		}

	},*/

	onClickBotonCancelarVentanaGastoAsociado : function(btn) {
		var me = this;
		btn.up('window').hide();
	}, 
    
    mostrarCrearOfertaTramitada: function(editor, grid, context) {   	
		var me = this;
		
		me.getView().fireEvent('openModalWindow', "HreRem.view.activos.detalle.TramitarOfertaActivoWindow", {
			editor: editor,
			grid: grid,
			context: context
        });	    
	},
	
	hideWindowCrearOferta: function(btn) {
		var me = this;
		me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], idActivo);
		btn.up('window').hide();
	 }, 

    onClickCrearOfertaTramitada: function (btn){
 		var me = this;
 		var ventanaCrearOferta = btn.up('[reference=crearofertawindowref]');
 		var editor = ventanaCrearOferta.editor;
 		var gridListadoOfertas = ventanaCrearOferta.grid;
 		var context = ventanaCrearOferta.context;
 		
 		context.record.data.ventaCartera = ventanaCrearOferta.down('[reference=checkVentaCartera]').value;
 		context.record.data.ofertaEspecial = ventanaCrearOferta.down('[reference=checkOfertaEspecial]').value;
 		context.record.data.ventaSobrePlano = ventanaCrearOferta.down('[reference=checkVentaSobrePlano]').value;
 		context.record.data.codRiesgoOperacion = ventanaCrearOferta.down('[reference=tipoRiesgoOperacionRef]').value;
 		
 		gridListadoOfertas.saveFn(editor, gridListadoOfertas, context);
 		
 		me.hideWindowCrearOferta(btn);
 		
    },

    
    mostrarObservacionesGrid: function(event, target, options) {   	
    	var me = this;
    	var observacionesAdmision = target.data.observacionesEvolucion;
  	
    	me.getView().fireEvent('openModalWindow', "HreRem.view.activos.detalle.CrearEvolucionObservaciones", {
            observacionesAdmision: observacionesAdmision
        });
        
    },
    
    onClickCerrarObservacionesEvolucion: function(btn) {
    	var me = this;
    	btn.up('window').hide();
    },



	onClickBotonAnyadirGastoAsociadoAdquisicion : function(btn) {

		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		var form = btn.up().up().down("form");
		url = $AC.getRemoteUrl("activo/createGastoAsociadoAdquisicion");
		var idActivo = me.getView().idActivo;
		var comboTipoGasto = me.lookupReference('comboTipoGastoAsociadoRef');
		var fechaSolicitud = me.lookupReference('fechaSolicitudRef');
		var fechaPago = me.lookupReference('fechaPagoRef');
		var importe = me.lookupReference('importeRef');
		// var factura = me.lookupReference('facturaRef');
		var observaciones = me.lookupReference('observacionesRef');
		if (form.isValid()) {
			form.submit({
				url : url,
				params : {
					activoId : idActivo,
					gastoAsociado : comboTipoGasto.getValue(),
					fechaSolicitudGastoAsociado : fechaSolicitud.getValue(),
					fechaPagoGastoAsociado : fechaPago.getValue(),
					importe : importe.getValue(),
					observaciones : observaciones.getValue()
				},
				success : function(fp, o) {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().fireEvent("refreshEntityOnActivate",
							CONST.ENTITY_TYPES['ACTIVO'], idActivo);
					me.getView().unmask();
					me.onClickBotonCancelarVentanaGastoAsociado(btn);

				},
				failure : function(record, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.unmask();
				}
			});
		} else {
			me.getView().unmask();
		}

	},

	cargarCamposCalculados : function(me) {
		var grid = this.lookupReference('gastosasociadosadquisiciongridref');
		var listaGastos = grid.getStore().getData().items

		//Campos calculados
		var itp = 0;
		var plusvaliaAdquisicion = 0;
		var notaria = 0;
		var registro = 0;
		var otrosGastos = 0;
		//References
		var iptRef= this.lookupReference('iptRef');
		var plusvaliaAdquisicionRef = this.lookupReference('plusvaliaAdquisicionRef');
		var notariaRef = this.lookupReference('notariaRef');
		var registroRef = this.lookupReference('registroRef');
		var otrosGastosRef = this.lookupReference('otrosGastosRef');
		
				
		for(var i = 0; i < listaGastos.length; i++) {
			var elemento = listaGastos[i].data;
			if (elemento.gastoAsociado == "ITP") {
				itp = itp + parseFloat(elemento.importe);
			} else if(elemento.gastoAsociado.normalize("NFD").replace(/[\u0300-\u036f]/g, "") == "Plusvalia de adquisicion") {
				plusvaliaAdquisicion = plusvaliaAdquisicion + parseFloat(elemento.importe);
			} else if(elemento.gastoAsociado.normalize("NFD").replace(/[\u0300-\u036f]/g, "") == "Notaria") {
				notaria = notaria + parseFloat(elemento.importe);
			} else if(elemento.gastoAsociado == "Registro") {
				registro = registro + parseFloat(elemento.importe);
			} else if(elemento.gastoAsociado == "Otros gastos") {
				otrosGastos = otrosGastos + parseFloat(elemento.importe);
			}
		
		}
		
		iptRef.setValue(itp);
		plusvaliaAdquisicionRef.setValue(plusvaliaAdquisicion);
		notariaRef.setValue(notaria);
		registroRef.setValue(registro);
		otrosGastosRef.setValue(otrosGastos);

	},
	
	onClickDescargarFacturaGastoAsociado: function(view, rowIndex, colIndex, item, e, record, row) {
		var me = this, config = {};
		if(!Ext.isEmpty(record) && !Ext.isEmpty(record.get('idFactura'))){
			config.url = $AC.getWebPath() + "activo/descargarFacturaGastoAsociado."	+ $AC.getUrlPattern();
			config.params = {};
			config.params.id = record.get('idFactura');
			config.params.nombreDocumento = record.get("factura").replace(/,/g, "");
			me.fireEvent("downloadFile", config);
		}
	},
	
	onClickCargarFacturaGastoAsociado: function(view, rowIndex, colIndex, item, e, record, row) {
		var me = this,
		idEntidad = null,
		parent = null;

		if(!Ext.isEmpty(record) && !Ext.isEmpty(record.get('id'))){
			idEntidad = record.get('id');
		}
		if(!Ext.isEmpty(view) && !Ext.isEmpty(view.up('grid'))){
			parent = view.up('grid');
		}
        var ventana = Ext.create('HreRem.view.common.adjuntos.AdjuntarFactura',{idEntidad: idEntidad, parent: parent});
        ventana.show();
	},
	
	onClickBorrarFacturaGastoAsociado: function(view, rowIndex, colIndex, item, e, record, row) {
		var me = this,
		url = null,
		idEntidad = null,
		grid = null;

		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		if(!Ext.isEmpty(record) && !Ext.isEmpty(record.get('idFactura'))){
			idEntidad = record.get('idFactura');
		}

		if(!Ext.isEmpty(view) && !Ext.isEmpty(view.up('grid'))){
			grid = view.up('grid');
		}
		
		url = $AC.getRemoteUrl('activo/deleteFacturaGastoAsociado');
		Ext.Ajax.request({
					url : url,
					params : {
						idFactura : idEntidad
					},
					success : function(response, opts) {
						me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						grid.getStore().load();
					},
					failure : function(record, operation) {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					},
					callback : function(record, operation) {
						me.getView().unmask();
					}
				});
	},
	ocultarCamposIdOrigen: function(){
		var me = this;
		var idOrigen = me.getView().getViewModel().get('activo.idOrigenHre');
		var comboOrigen = me.lookupReference('comboOrigenAnteriorActivoRef');
		var origenAnteriorActivoBbva = me.lookupReference('comboOrigenAnteriorActivoBBVARef');
		var fechaOrigen = me.lookupReference('fechaTituloAnteriorRef');
		var sociedadOrigen = me.lookupReference('sociedadPagoAnteriorRef');
		
		if (idOrigen != null) {
			comboOrigen.setReadOnly(true);
			origenAnteriorActivoBbva.setReadOnly(true);
			fechaOrigen.setReadOnly(true);
			sociedadOrigen.setReadOnly(true);
		}else{
			comboOrigen.setReadOnly(false);
			origenAnteriorActivoBbva.setReadOnly(false);
			fechaOrigen.setReadOnly(false);
			sociedadOrigen.setReadOnly(false);
		}
	},
	
	comprobarNIF: function(record){
		var me = this;
		//record.validateValue(record.getValue()
		var fieldTipoDoc;
		var items = record.up().items.items;
		var botones = record.up().floatingButtons.items.items;
		var fieldDoc;
		var campoDocumento;
		if(botones != null && !Ext.isEmpty(botones)){
			for(var j = 0 ; j<botones.length ; j++){
				if(!Ext.isEmpty(botones[j].itemId) && botones[j].itemId == "update"){
					botonGuardar = botones[j].id;
				}
			}
		}
		if(!Ext.isEmpty(items)){
			for(var i = 0 ; i<items.length ; i++){
				if(!Ext.isEmpty(items[i].column) && items[i].column.reference == "tipoDocDeudor"){
					fieldTipoDoc = items[i].column.field.value;
					
				}
				if(!Ext.isEmpty(items[i].column) && items[i].column.reference == "tipoNumeroDocumentoDeudor"){
					fieldDoc = items[i].column.field.value;
					campoDocumento = items[i];
				}
			}
		}
		campoDocumento.allowBlank = false;
		
			if(fieldTipoDoc == "15"
				|| fieldTipoDoc == "01" || fieldTipoDoc == "NIF"){
				 Ext.getCmp(botonGuardar).disable();
				 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
				 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
				 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
				 var str = fieldDoc.toString().toUpperCase();

				 if (!nifRexp.test(str) && !nieRexp.test(str)){			 
		        	 //me.fireEvent("errorToast", HreRem.i18n("msg.documento.identificativo"));
		        	 //record.markInvalid("")
					 Ext.getCmp(botonGuardar).disable();
		        	 return false;
				 }
				if(fieldDoc.length < 6){
			 		Ext.getCmp(botonGuardar).disable();
					 campoDocumento.allowBlank = true;
					 return false;
				}
				 var nie = str
				     .replace(/^[X]/, '0')
				     .replace(/^[Y]/, '1')
				     .replace(/^[Z]/, '2');

				 var letter = str.substr(-1);
				 var charIndex = parseInt(nie.substr(0, 8)) % 23;

				 if (validChars.charAt(charIndex) === letter){
					 Ext.getCmp(botonGuardar).enable();
					 return true;
					
				 }else{
		        	// me.fireEvent("errorToast", HreRem.i18n("msg.documento.identificativo"));
		        	// record.markInvalid("")
					 Ext.getCmp(botonGuardar).disable();
		        	 return false;
				 }

			}else if(fieldTipoDoc== "02" || fieldTipoDoc == "CIF"){
				Ext.getCmp(botonGuardar).disable();
				var texto=fieldDoc;
		        var pares = 0; 
		        var impares = 0; 
		        var suma; 
		        var ultima; 
		        var unumero; 
		        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
		        var xxx; 
		         
		        texto = texto.toUpperCase(); 
		         
		        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
	        	if (!regular.exec(texto)) {
		        	// me.fireEvent("errorToast", HreRem.i18n("msg.documento.identificativo"));
		        	// record.markInvalid("")
	        		Ext.getCmp(botonGuardar).disable();
		        	 return false;
				}
		        ultima = texto.substr(8,1); 
		 
		        for (var cont = 1 ; cont < 7 ; cont ++){ 
		             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
		             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
		             pares += parseInt(texto.substr(cont,1)); 
		         } 
		         
		         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
		         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
		          
		         suma = (pares + impares).toString(); 
		         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
		         unumero = (10 - unumero).toString(); 
		         if(unumero == 10){
		        	 unumero = 0; 
		         }
		          
		         if ((ultima == unumero) || (ultima == uletra[unumero])) {
		        	 Ext.getCmp(botonGuardar).enable();
		        	 return true;
		         }else{
		        	// me.fireEvent("errorToast", HreRem.i18n("msg.documento.identificativo"));
		        	// record.markInvalid("");
		        	 Ext.getCmp(botonGuardar).disable();
		        	 return false;
		         }
			} else {
				Ext.getCmp(botonGuardar).enable();
				return true;
			}
		
		
		
	},
	onChangeDebeComprobarNIF: function(combo,newValue,oldValue,eOpts){
			this.comprobarNIF(combo);
	},
    
    onChkbxExclValPerimetroChange: function(chkbx){
		var me = this;
		var excluido = chkbx.getValue();
		var comboMotivoGestionComercial = me.lookupReference('comboMotivoGestionComercial');
		disabled = excluido == 0;
		
		comboMotivoGestionComercial.setDisabled(disabled);
    	
    	if(disabled){
    		comboMotivoGestionComercial.editable = false;
    	}else{
    		comboMotivoGestionComercial.editable = true;
    	}
    },

    cargarStoreCalidadDatoFasesGrid: function(grid){
    	var me = this;    	
		
		var storeCalidadDelDatoGrid = me.getViewModel().data.storeCalidadDelDatoGrid;
		storeCalidadDelDatoGrid.getProxy().setExtraParams(
		{'id':grid.idActivo,'codigoGrid':grid.codigoGrid});
		if (grid.getStore() != null) {
			grid.getStore().load();
		}
		
    },
    
    onChangeComboGestionDnd: function(combo){
    	var me = this;
		var comboEstadoFisico = me.lookupReference('estadoActivoCodigoRef');

		if (combo.getValue() === '01') {
			comboEstadoFisico.setDisabled(false);
		} else {
			comboEstadoFisico.setDisabled(true);
		}
    }
});
