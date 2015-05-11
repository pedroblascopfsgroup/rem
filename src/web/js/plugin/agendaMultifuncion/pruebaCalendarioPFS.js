
app.calendario=function() {

	Ext.ensible.Date.use24HourTime=true;

	var TIPO_TAREA_CITA = 4;
			/*var eventStoreXX = new Ext.ensible.sample.MemoryEventStore({
				data : {
					evts : []
				}
			});*/

			var eventStore = new Ext.data.JsonStore({
				storeId: 'eventStore',
	            root: 'evts',
	            proxy: new Ext.data.MemoryProxy(),
				fields: Ext.ensible.cal.EventRecord.prototype.fields.getRange().concat(
            		['tipoTarea','tipoTareaDescripcion','codigoSubtipoTarea', 'idEntidad','codigoEntidadInformacion', 'descripcionEntidadInformacion', 'descripcion', 'descripcionTarea', 'tipoSolicitud','codigoSituacion','fcreacionEntidad']
            		)
            });

			var CalendarStore =  Ext.extend(Ext.data.Store, {
			    constructor: function(config){
			        config = Ext.applyIf(config || {}, {
			            storeId: 'calendarStore',
			            root: 'calendars',
			            idProperty: Ext.ensible.cal.CalendarMappings.CalendarId.mapping || 'id',
			            proxy: new Ext.data.MemoryProxy(),
			            autoLoad: true,
			            fields: Ext.ensible.cal.CalendarRecord.prototype.fields.getRange()
			        });
			        this.reader = new Ext.data.JsonReader(config);
			        CalendarStore.superclass.constructor.call(this, config);
			    }
			});

			var calendars = window.calendars = new CalendarStore({
				data : {"calendars":[{
					"id":1,
					"title":"Tareas pendientes",
					"color":8
				    },{
					"id":2,
					"title":"Notificaciones",
					"color":23
				    },{
					"id":5,
					"title":"Alertas",
					"color":8
				    },{
					"id":600,
					"title":"Citas",
					//"hidden":true, // optionally init this calendar as hidden by default
					"color":5
				    },
				    {"id":16,
					"title":"Expediente",
					"color":2
				    }]
				}
			});





			//esto es una copia de la funcion que hay en BTAlistadoTareas
			var abrirSegunTipo = function(rec){
					var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR && permisosVisibilidadGestorSupervisor(rec.get('gestorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR;
		}
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR && permisosVisibilidadGestorSupervisor(rec.get('supervisorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR;
		}


		switch (codigoSubtipoTarea){
			case app.subtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE:
			case app.subtipoTarea.CODIGO_REVISAR_EXPEDIENE:
			case app.subtipoTarea.CODIGO_DECISION_COMITE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC:
				app.abreExpediente(rec.get('idEntidad'), rec.get('descripcionExpediente'));
			break;
			case app.subtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL:
            case app.subtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO:
				app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
			break;
			case app.subtipoTarea.CODIGO_GESTION_VENCIDOS:
				app.openTab("**Gesti&oacute;n de Vencidos", "clientes/listadoClientes", {gv:true},{id:'GV',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO:
				app.openTab("**Gesti&oacute;n de Seguimiento Sistem&aacute;tico", "clientes/listadoClientes", {gsis:true},{id:'GSIN',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO:
				app.openTab("**Gesti&oacute;n de Seguimiento Sintom&aacute;tico", "clientes/listadoClientes", {gsin:true},{id:'GSIS',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR:
				 var w = app.openWindow({
						flow : 'tareas/generarNotificacion'
						,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
						,width:650
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get('descripcionTarea')
								,fecha: rec.get('fcreacionEntidad')
								,situacion: rec.get('codigoSituacion')
								,idTareaAsociada: rec.get('id')
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.OPEN_ENTITY, function(){
						w.close();
						if (rec.get('codigoEntidadInformacion') == '1'){
							app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '2'){
							app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '3'){
							app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '5'){
							app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
						}
					});
			break;
            case app.subtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO:
                var w = app.openWindow({
                        flow : 'clientes/decisionTelecobro'
                        ,title : '<s:message code="clientes.menu.aceptarRechazarExclusion" text="**Aceptar/Rechazar Exclusion Recobro" />'
                        ,width:400
                        ,params : {
                                idEntidad: rec.get('idEntidad')
                                ,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
                                ,descripcion: rec.get('descripcionTarea')
                                ,fecha: rec.get('fcreacionEntidad')
                                ,situacion: rec.get('codigoSituacion')
                                ,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
                                ,idTareaAsociada: rec.get('idTareaAsociada')
                                ,idTarea:rec.get('id')
                                ,enEspera:'${espera}'
                        }
                    });
                    w.on(app.event.DONE, function(){w.close();});
                    w.on(app.event.CANCEL, function(){ w.close(); });
                    w.on(app.event.OPEN_ENTITY, function(){
                        w.close();
                        app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
                    });
            break;
            case app.subtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO:
                var w = app.openWindow({
                        flow : 'clientes/consultaDecisionTelecobro'
                        ,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
                        ,width:400
                        ,params : {
                                idEntidad: rec.get('idEntidad')
                                ,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
                                ,descripcion: rec.get('descripcionTarea')
                                ,fecha: rec.get('fcreacionEntidad')
                                ,situacion: rec.get('codigoSituacion')
                                ,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
                                ,idTareaAsociada: rec.get('idTareaAsociada')
                                ,idTarea:rec.get('id')
                        }
                    });
                    w.on(app.event.DONE, function(){
						w.close();
						//Recargamos el flow
                    	tareasStore.webflow(paramsBusquedaInicial);
                    });
                    w.on(app.event.CANCEL, function(){ w.close(); });
                    w.on(app.event.OPEN_ENTITY, function(){
                        w.close();
                        app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
                    });
            break;
            case app.subtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR:
				var w = app.openWindow({
					flow : 'expedientes/decisionSolicitudCancelacionConTarea'
					,eventName: 'tarea'
					,title : '<s:message code="expedientes.consulta.solicitarcancelacion" text="**Solicitar cancelacion" />'
					,params : {idExpediente:rec.get('idEntidad'), idTarea:rec.get('id'), espera:'${espera}'}
				});

				w.on(app.event.DONE, function(){
								w.close();
								tareasStore.webflow(paramsBusquedaInicial);
							 }
				);
				w.on(app.event.CANCEL, function(){ w.close(); });
			break;
			case app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR:
			case app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_ASUNTO_PROPUESTO:
				app.abreAsuntoTab(rec.get('idEntidad'), rec.get('descripcion'),'aceptacionAsunto');
			break;
			case app.subtipoTarea.CODIGO_ACUERDO_PROPUESTO:
			case app.subtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO:
				app.abreAsuntoTab(rec.get('idEntidad'), rec.get('descripcion'),'acuerdos');
			break;
			case app.subtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'docRequerida');
			break;
			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR:
			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
			break;
			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR:
			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'recursos');
			break;
			case app.subtipoTarea.CODIGO_TOMA_DECISION_BPM:
			case app.subtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO:
			//case app.subtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'decision');
			break;
			case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarTareaObjetivo'
                    ,width: 900
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idObjetivo:idObjetivo
					          ,aceptarBorrar:'borrar'
					          ,checkBoxTexto:'<s:message code="objetivo.aceptarPropuestaBorrado" text="**Permito el borrado del objetivo" />'}
                });
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarTareaObjetivo'
                    ,width: 900
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idObjetivo:idObjetivo
					          ,aceptarBorrar:'aceptar'
					          ,checkBoxTexto:'<s:message code="objetivo.aceptarPropuesta" text="**Permito la propuesta del objetivo" />'}
                });
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarPropuestaCumplimiento'
                    ,width: 900
                    ,title: '<s:message code="objetivos.propuestaCumplimiento.titulo" text="**Propuesta Cumplimiento" />'
                    ,params: {idObjetivo:idObjetivo}
                });

                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            // Por default abre una notificacion standard
			default:
				var w = app.openWindow({
						flow : 'tareas/consultaNotificacion'
						,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
						,width:400
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get('descripcionTarea')
								,fecha: rec.get('fcreacionEntidad')
								,situacion: rec.get('codigoSituacion')
								,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
								,idTareaAsociada: rec.get('idTareaAsociada')
								,idTarea:rec.get('id')
                                ,tipoTarea:rec.get('tipoTarea')
						}
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.DONE, function(){
                            w.close();
                            tareasStore.webflow(paramsBusquedaInicial);
							//Recargamos el arbol de tareas
							app.recargaTree();
                    });
					w.on(app.event.OPEN_ENTITY, function(){
						w.close();
						if (rec.get('codigoEntidadInformacion') == '1'){
							app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '2'){
							app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '3'){
							app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '5'){
							app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
						}
                        if (rec.get('codigoEntidadInformacion') == '7'){
                            app.abreClienteTab(rec.get('idEntidadPersona'), rec.get('descripcion'),'politicaPanel');
                        }
					});
			break;
		}
			};


			var monthEventClick = function(cal, rec){
			console.log(rec);
				var tipo =rec.get('tipoTarea');
				if (tipo==TIPO_TAREA_CITA) return;

				abrirSegunTipo(rec);
				return false; // false==> no abrir el popup de edicion
			};

			window.dd = eventStore;
			var cal = window.cal = new Ext.ensible.cal.CalendarPanel({
				title : 'Calendar',
				eventStore : eventStore,
				calendarStore : calendars,
				width : 700,
				height : 500,
				activeItem : 3,
				startDay : 1,
				todayText : 'Hoy',
				monthViewCfg : {
					startDay : 1
					,listeners : {
					  'eventclick' : monthEventClick
					}
				},
				editModal : true,
				editViewCfg : {
					title : 'Evento',
					titleTextAdd : 'Nuevo evento',
					titleTextEdit : 'Editar evento',
					titleLabelText : 'Nombre',
					datesLabelText : 'Cuando',
					saveButtonText : 'Guardar',
					deleteButtonText : 'Borrar',
					cancelButtonText : 'Cancelar',
					enableEditDetails : false
				}

			});


			var parseDate = function(fecha, hora){
				return Date.parseDate(fecha+" "+hora, 'd/m/yy H:i') || Date.parseDate(fecha+" "+hora, 'd/m/yy')
			};

			var fechaLabel = new Ext.form.Label();

			var cargarEventos =  function() {
				var fechas = cal.getActiveView().getViewBounds();
				fechaLabel.setText("Visualizando del " + fechas.start.format('d-F-Y') + " al " + fechas.end.format('d-F-Y') );
				Ext.Ajax.request({
					//url : '/pfs/calendario/listadoCalendarioEventos.htm',
					url : '/pfs/plugin/busquedaTareas/BTAlistadoTareasBusqueda.htm',
					params : {
						star : 0,
						busqueda : true,
						ambitoTarea : 3,
						limit : 25,
						sort : 'fechaVenc',
						dir : 'ASC',
						fechaVencimientoDesde : fechas.start.format('d/m/Y h:m'),
						fechaVencDesdeOperador : '>=',
						fechaVencimientoHasta : fechas.end.format('d/m/Y h:m'),
						fechaVencimientoHastaOperador : '<=',
						defeatCache : Math.random(),
						perfilUsuario:'',
						enEspera:'',
						esAlerta:'',
						busqueda:true,
						codigoTipoTarea:'',
						codigoTipoSubTarea:'',
						nombreTarea:'',
						descripcionTarea:'',
						gestorSupervisorUsuario:'',
						nombreUsuario:'',
						ugGestion:'',
						nivelEnTarea:'',
						usernameUsuario:'',
						estadoTarea:1,
						fechaInicioDesde:'',
						fechaInicioDesdeOperador:'',
						fechaInicioHasta:'',
						fechaInicioHastaOperador:'',
						fechaFinDesde:'',
						fechaFinDesdeOperador:'',
						fechaFinHasta:'',
						fechaFinHastaOperador:'',
						_eventId : 'listado'
					},
					success : function(data) {
						var data = Ext.decode(data.responseText);
						var id = 1000;
						var evts = [];

						Ext.each(data.tareas, function(ev) {
console.log(ev);
							evts.push({
								id : ev.id,
								cid : ev.codigoSubtipoTarea,
								title : ev.descripcion,
								notes : 'nota:' + ev.descripcionTarea,
								start : parseDate(ev.fechaVenc, ev.horaVenc),
								end : parseDate(ev.fechaInicio, ev.horaInicio) || parseDate(ev.fechaVenc, ev.horaVenc) ,
								//end : Date.parseDate(ev.fechaFin, ev.horaFin 'd/m/yy H:i'),
								ad : ev.tipoTarea!=TIPO_TAREA_CITA || ev.fechaInicio=='',
								codigoSubtipoTarea : ev.codigoSubtipoTarea,
								tipoTarea : ev.tipoTarea
								,tipoTareaDescripcion: ev.tipoTareaDescripcion
								,codigoSubtipoTarea:ev.codigoSubtipoTarea
								,idEntidad:ev.idEntidad
								,codigoEntidadInformacion:ev.codigoEntidadInformacion
								,descripcionEntidadInformacion:ev.descripcionEntidadInformacion
								,tipoSolicitud:ev.tipoSolicitud
								,codigoSituacion: ev.codigoSituacion
								,fcreacionEntidad: ev.fcreacionEntidad
								,descripcionTarea: ev.descripcionTarea
								,descripcion: ev.descripcion

							// AllDay
							});
						});
						eventStore.loadData({
							evts : evts
						});
					}
				});
			};

			cal.on('datechange',cargarEventos);

			var actualizar = function(cal, rec){
				console.log(rec);
				var id = rec.get("EventId");
				id = parseInt(id) ? id : -1;
				Ext.Ajax.request({
					url : '/pfs/calendario/nuevoCalendarioEvento.htm',
					params : {
						_eventId :'nuevoEvento'
						,id : id
						,fechaInicio : rec.get("StartDate").format('d/m/Y H:i')
						,fechaFin : rec.get("EndDate").format('d/m/Y H:i')
						,descripcion: rec.get("Title")
						,diaCompleto : rec.get("IsAllDay")? 'S':'N'
					}
					,success : function(data){
						console.log(data);
					}
				});
			};

			cal.on('clickevent', function(cal,rec){
			   console.log('clickevent',rec);
			   return false;
			});

			/*
			cal.on('eventclick', function(cal,rec){
			   console.log('cal eventclick',rec);
			   return false;
			});
			*/


			cal.on('eventadd', actualizar);
			cal.on('eventupdate', actualizar);

			cal.on('eventdelete', function(cal, rec){
				Ext.Ajax.request({
					url : '/pfs/calendario/borrarCalendarioEvento.htm',
					params : { id : rec.get("EventId") },
					success : function(){
						cal.dismissEventEditor();
					}

				});
			});

			app.contenido.add(cal);



			cal.on('afterrender', function(){
				cal.getTopToolbar().insert(6, fechaLabel);
				cargarEventos.defer(10)
			} );

};
