var calendario = function() {

	Ext.ensible.Date.use24HourTime = true;

	var TIPO_TAREA_CITA = 4;

	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			maskPanel=new Ext.LoadMask(cal.body, {msg:'Cargando eventos...<br/>Esta operación puede tardar varios segundos, espere por favor.'});
		}
		maskPanel.show();
	};

	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
	};
	
	var eventStore = new Ext.data.JsonStore({
		storeId : 'eventStore',
		root : 'evts',
		proxy : new Ext.data.MemoryProxy(),
		fields : Ext.ensible.cal.EventRecord.prototype.fields.getRange().concat([
		        'ad', 'tipoTarea', 'tipoTareaDescripcion', 'codigoSubtipoTarea', 'idEntidad',
				'codigoEntidadInformacion', 'descripcionEntidadInformacion', 'descripcion',
				'descripcionTarea', 'tipoSolicitud', 'codigoSituacion', 'fcreacionEntidad'])
	});

	window.dd = eventStore;

	var CalendarStore = Ext.extend(Ext.data.Store, {
		constructor : function(config) {
			config = Ext.applyIf( config || {},
					{
						storeId : 'calendarStore',
						root : 'calendars',
						idProperty : Ext.ensible.cal.CalendarMappings.CalendarId.mapping || 'id',
						proxy : new Ext.data.MemoryProxy(),
						autoLoad : true,
						fields : Ext.ensible.cal.CalendarRecord.prototype.fields.getRange()
					});
			this.reader = new Ext.data.JsonReader(config);
			CalendarStore.superclass.constructor.call(this,	config);
		}
	});
	
/*

Se muestran los colores segun el STA o subtipotarea

DD_STA_CODIGO DD_STA_DESCRIPCION
	1	GV
	2	CE
	3	RE
	4	DC
	5	Solicitar Prorroga CE
	6	Solicitar Prorroga RE
	7	Notificacin Contrato Cancelado
	8	Notificacin Saldo Reducido
	9	Notificacin Cliente cancelado
	10	Notificacin Expediente cerrado
	11	Notificacin Contrato pagado
	12	Notificacion CE Vencida
	13	Notificacion RE Vencida
	14	Notificacion DC Vencida
	15	Notificacion Comunicacion de Supervisor
	16	Comunicacion de Gestor
	17	Solicitud Cancelar Expediente
	18	Solic Canc Expe rechazada
	19	Tarea CE Completada
	20	Tarea RE Completada
	21	Notif Solic Prorroga CE Rechazada
	22	Notif Solic Prorroga RE Rechazada
	23	Notif Cierre sesion comite
	24	Comunicacion de Gestor
	25	Notif Expediente Decidido
	26	Comunicacion de Supervisor
	27	Notificacion Comunicacion de Gestor
	28	Comunicacion de Supervisor
	29	Solicitud Expediente Manual
	30	Solicitud de Preasunto
	31	Verificar Telecobro
	32	Solicitud exclusion de telecobro
	33	Respuesta solicitud exclusion de telecobro
	34	Solicitud de cancelacion de Expediente Rechazada
	35	Recopilacion de documentos
	36	Aceptacion asunto gestor
	37	Aceptacion asunto supervisor
	38	Asunto Propuesto
	39	Tarea externa
	40	Tarea externa
	41	Solicitar Prorroga PRC
	42	Notif Solic Prorroga PRC Rechazada
	43	Actualizar estado recurso
	44	Actualizar estado recurso
	45	Notificacion de recurso
	46	Tomar Decision de Continuidad
	47	Propuesta Decision Procedimiento
	48	Aceptacion/Rechazo Decision Procedimiento
	49	Acuerdo Propuesto
	50	AcuerdoRechazado
	51	Gestiones para el cierre del acuerdo
	52	Acuerdo Cerrado
	53	Umbral
	54	Solicitar Prorroga DC
	55	Notif Solic Prorroga DC Rechazada
	521	acuerdo anual
	522	acuerdo mensual
	523	acuerdo semestral
	524	acuerdo trimestral
	525	acuerdo bimestral
	526	acuerdo semanal
	527	acuerdo unico
	528	plazo maximo autoprorroga
	98	GS
	99	GS
	57	Propuesta de borrado de objetivo
	58	Aceptar propuesta de borrado de objetivo
	59	Rechazar propuesta de borrado de objetivo
	60	Propuesta de alta de objetivo
	61	Aceptar propuesta de alta de objetivo
	62	Rechazar propuesta de alta de objetivo
	63	Propuesta de cumplimiento de objetivo
	64	Aceptar propuesta de cumplimiento de objetivo
	65	Justificar incumplimiento de objetivo
	66	Notificacion objetivo aceptado
	67	Notificacion objetivo rechazado
	501	Solicitud Expediente Manual Seguimiento
	503	Prorroga toma decision
	502	cambiar umbral
	542	Tarea de Gestor Documental
	543	Tarea de Procurador
	9999999999	Aceptacion/Rechazo Decision Procedimiento (Gestor)
	583	Notificacion Comunicacion de Supervisor expediente
	584	Comunicacion de Gestor expediente
	585	Notificacion Comunicacion de Gestor expediente
	586	Comunicacion de Supervisor expediente
	589	Comunicacion de Supervisor de asunto a destinatario
	590	Comunicacion de Supervisor de asunto a destnatario pendiente de respuesta
	587	Comunicacion de Gestor en el expediente
	588	Comunicacion de Supervisor en el expediente
	600	Tarea de Gestor Confeccion Expediente
	601	Tarea de Supervisor Confeccion Expediente
	700	Anotacion
	701	Anotacion
	TCGA	Tareas concursal gestor Administrativo
	702	Nueva variaci�n de saldo
	TCRC	Tareas concursal responsable concursal
*/
/*
COLORES: 1: Coral, 2: Rojo, 3: Granate, 4: Granate Oscuro, 5: Ocre, 6: Naranja, 7: Ocre II, 8: Dorado, 9: Lila, 10: Morado, 11: Morado II, 
	12: Berenjena, 13: Morado III, 14: Morado Fuerte, 15: Morado Clarito, 16: Lila Clarito, 17: Azul Claro, 18: Azul, 19: Azul Marino, 
	20: Azul Fuerte, 21: Casi Azul Marino, 22: Azul Verdoso, 23: Azul Turquesa, 24: Azul SuperClarito, 25: Verde Clarito, 26: Verde Menos Clarito,
	27: Verde, 28: Verde Mas Oscuro, 29: Verde Oscuro, 30: Verde SuperOscuro, 31: Verde Azulado, 32: Verde SuperClarito, >33 Transparente.

*/
/*
 data : {
			"calendars" : [ {
				"id" : 700,
				"title" : "Anotacion",
				"color" : 21
			}, {
				"id" : 701,
				"title" : "Anotacion",
				"color" : 22
			},  {
				"id" : 16,
				"title" : "Comunicacion de Gestor",
				"color" : 23
			}]
		}
*/	
		
var calendars = window.calendars = new CalendarStore({
		data : {
			"calendars" : [ {
				"id" : 700,
				"title" : "Anotacion",
				"color" : 8
			}, {
				"id" : 701,
				"title" : "Anotacion",
				"color" : 8
			}]
		}
	});

	var monthEventClick = function(cal, rec) {		
		var tipo = rec.get('tipoTarea');
		if (tipo == TIPO_TAREA_CITA)
			return;
		abrirSegunTipo(rec);
		return false; // false==> no abrir el popup de edicion
	};

	var cal = window.cal = new Ext.ensible.cal.CalendarPanel({
		title : 'Calendario',
		id : 'plugin_calendario_calendarioPanel',
		eventStore : eventStore,
		calendarStore : calendars,
		//iconCls : 'icon_calendario_azul',
		closable: true,
		showNavJump: false,
		width : 700,
		height : 500,
		activeItem : 2,
		startDay : 1,
		todayText : 'Hoy',
		monthViewCfg : {
			startDay : 1
		},
		listeners : {'eventclick' : monthEventClick},
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

	function parsearFecha(input) {
		if(input != null && input != ''){
			var parts = input.match(/(\d+)/g); 
 		 	// new Date(year, month [, date [, hours[, minutes[, seconds[, ms]]]]])
 	 		return new Date(parts[2], parts[1]-1, parts[0]); // months are 0-based  Wed Jun 13 12:15:49 CEST 2012
		}
	}

	function parsearFechaHoraInput(input) {
		if(input != null && input != ''){
			var parts =input.match(/(\d+)/g);  // 0 = Wed; 1 = Jun; 2 = 13; 3 = 12:15:49; 4 = CEST; 5 = 2012
			var fecha = parts[0].split('/');
			var hora = parts[1].split(':');
			//alert(new Date(fecha[0], fecha[1], fecha[2], hora[0], hora[1], hora[2], 0));
 	 		//return new Date(fecha[0], fecha[1], fecha[2], hora[0], hora[1], hora[2], 0);
			return new Date(parts[2],  parts[1]-1, parts[0], parts[3]-1, parts[4], parts[5]);
		}
	}
	
	function parsearFechaHora(input) {
		if(input != null && input != ''){
			var parts =input.match(/(\d+)/g);  // 0 = Wed; 1 = Jun; 2 = 13; 3 = 12:15:49; 4 = CEST; 5 = 2012
			var fecha = parts[0].split('/');
			var hora = parts[1].split(':');
			//alert(new Date(fecha[0], fecha[1], fecha[2], hora[0], hora[1], hora[2], 0));
 	 		//return new Date(fecha[0], fecha[1], fecha[2], hora[0], hora[1], hora[2], 0);
			return new Date(parts[2],  parts[1]-1, parts[0], parts[3], parts[4], parts[5]);
		}
	}

	var fechaLabel = new Ext.form.Label();

	var cargarEventos = function() {
		var fechas = cal.getActiveView().getViewBounds();
		var userIni=app.usuarioLogado.username;
		var perfilUsuario=app.usuarioLogado.perfiles[0].id;
		fechaLabel.setText("Visualizando del " + fechas.start.format('d-F-Y')+ " al " + fechas.end.format('d-F-Y'));
		maskAll();
		Ext.Ajax.request({
			url : '/pfs/calendario/cargarTareasCalendario.htm',  // '/pfs/plugin/calendario/json/eventosCalendario.htm', 
			params : {
				star : 0,
				busqueda : true,
				ambitoTarea : 3,
				limit : 500,
				sort : 'fechaVenc',
				dir : 'ASC',
				fechaVencimientoDesde : fechas.start.format('d/m/Y h:m'),
				fechaVencDesdeOperador : '>=',
				fechaVencimientoHasta : fechas.end.format('d/m/Y h:m'),
				fechaVencimientoHastaOperador : '<=',
				defeatCache : Math.random(),
				perfilUsuario : perfilUsuario,
				enEspera : false,
				esAlerta : false,
				busqueda : true,
				codigoTipoTarea : '',
				codigoTipoSubTarea : '',
				nombreTarea : '',
				descripcionTarea : '',
				gestorSupervisorUsuario : '',
				nombreUsuario : '',
				ugGestion : '',
				nivelEnTarea : '',
				usernameUsuario : '',
				estadoTarea : 1,
				fechaInicioDesde : '',
				fechaInicioDesdeOperador : '',
				fechaInicioHasta : '',
				fechaInicioHastaOperador : '',
				fechaFinDesde : '',
				fechaFinDesdeOperador : '',
				fechaFinHasta : '',
				fechaFinHastaOperador : '',
				_eventId : 'listado'
			},
			success : function(data) {

				var data = Ext.decode(data.responseText);
				var id = 1000;
				var evts = [];
				Ext.each(
						data.eventos,
						function(ev) {
							if(ev.fechaVenc != null && ev.fechaVenc != ''){
								//console.log(ev);

								evts.push({
									id : ev.id,
									cid : ev.codigoSubtipoTarea,
									title : ev.descripcion,
									notes : 'nota:' + ev.descripcionTarea,
									start : parsearFecha(ev.fechaVenc),
									end :  parsearFecha(ev.fechaVenc),
									ad : ev.tipoTarea != TIPO_TAREA_CITA || ev.fechaInicio == '',	
									tipoTarea : ev.tipoTarea,
									tipoTareaDescripcion : ev.nombreTarea,
									codigoSubtipoTarea : ev.codigoSubtipoTarea,
									idEntidad : ev.idEntidad,
									codigoEntidadInformacion : ev.codigoEntidadInformacion,
									descripcionEntidadInformacion : ev.entidadInformacion,
									descripcion : ev.descripcion,			
									descripcionTarea : ev.subtipo,
									tipoSolicitud : ev.tipoSolicitudSQL,
									codigoSituacion : ev.codigoSituacion,
									fcreacionEntidad : ev.fcreacionEntidad
								});									
							}
						});
				eventStore.loadData({
					evts : evts
				});
				unmaskAll();
			},
			failure: function (result) {
		           var jsonData = Ext.util.JSON.decode(result.responseText);                
		    }
		});
	};

	var actualizar = function(cal, rec) {		
		var id = rec.get("EventId");
		id = parseInt(id) ? id : -1;
		Ext.Ajax.request({
			url : '/pfs/calendario/nuevaTareaCalendario.htm',
			params : {
				_eventId : 'nuevoEvento',
				id : id,
				fechaInicio : rec.get("StartDate").format('d/m/Y H:i'),
				fechaFin : rec.get("EndDate").format('d/m/Y H:i'),
				descripcion : rec.get("Title"),
				diaCompleto : rec.get("IsAllDay") ? 'S' : 'N'
			},
			success : function(data) {
				//console.log(data);
			}
		});
	};

	cal.on('clickevent', function(cal, rec) {
		//console.log('clickevent', rec);
		return false;
	});
	
	cal.on('datechange', cargarEventos);

	cal.on('eventadd', actualizar);
	
	cal.on('eventupdate', actualizar);

	cal.on('eventdelete', function(cal, rec) {
		Ext.Ajax.request({
			url : '/pfs/calendario/borrarTareaCalendario.htm',
			params : {
				id : rec.get("EventId")
			},
			success : function() {
				cal.dismissEventEditor();
			}
		});
	});

	cal.on('afterrender', function() {
		cal.getTopToolbar().insert(3, fechaLabel);
		cargarEventos.defer(10)
	});	
	
	var abrirSegunTipo = function(rec) {
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
				
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO:
				
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO:
				
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
								,idTareaAsociada: rec.get('EventId')
						}
					});
					w.on(app.event.DONE, function(){w.close();cargarEventos();});
					w.on(app.event.CANCEL, function(){ w.close();});
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
                                ,idTarea:rec.get('EventId')
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
                                ,idTarea:rec.get('EventId')
                        }
                    });
                    w.on(app.event.DONE, function(){w.close();});
                    w.on(app.event.CANCEL, function(){ w.close();});
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
					,params : {idExpediente:rec.get('idEntidad'), idTarea:rec.get('EventId'), espera:'${espera}'}
				});
			
				w.on(app.event.DONE, function(){w.close();});
				w.on(app.event.CANCEL, function(){ w.close();});
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
			w.on(app.event.DONE, function(){w.close();});
			w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarTareaObjetivo'
                    ,width: 900
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idObjetivo:idObjetivo, aceptarBorrar:'aceptar', checkBoxTexto:'<s:message code="objetivo.aceptarPropuesta" text="**Permito la propuesta del objetivo" />'}
                });
                w.on(app.event.DONE, function(){w.close();});
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
                w.on(app.event.DONE, function(){w.close();});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            // Por default abre una notificacion standard
	    default:
		var w = app.openWindow({
				flow : 'buzontareas/abreTarea'
				,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
				,width:835 
				,params : {
						idEntidad: rec.get('idEntidad')
						,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
						,descripcion: rec.get('descripcionTarea')
						,fecha: rec.get('fcreacionEntidad')
						,situacion: rec.get('codigoSituacion')
						,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
						,idTareaAsociada: rec.get('idTareaAsociada')
						,idTarea:rec.get('EventId')
						,subtipoTarea:codigoSubtipoTarea
                				,tipoTarea:rec.get('tipoTarea')
				}
			});
			w.on(app.event.CANCEL, function(){ w.close();});
			w.on(app.event.DONE, function(){w.close();cargarEventos();});
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
	}; // end de abrirSegunTipo()

	//app.contenido.add(cal);
	return cal;
};