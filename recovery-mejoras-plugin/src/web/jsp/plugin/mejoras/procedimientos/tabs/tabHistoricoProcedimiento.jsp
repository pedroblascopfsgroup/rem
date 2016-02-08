<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(page,entidad){

	var panel = new Ext.Panel({
		title:'<s:message code="procedimiento.historico" text="**Historico"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,nombreTab : 'historico'
	});

	constantes={};
	constantes.TIPO_ENTIDAD_TAREA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_TAREA" />';
	constantes.TIPO_ENTIDAD_COMUNICACION = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_COMUNICACION" />';
	constantes.TIPO_ENTIDAD_PETICION_RECURSO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_RECURSO" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_RECURSO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_RECURSO" />';
	constantes.TIPO_ENTIDAD_PETICION_PRORROGA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_PRORROGA" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_PRORROGA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_PRORROGA" />';
	constantes.TIPO_ENTIDAD_PETICION_ACUERDO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_ACUERDO" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_ACUERDO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_ACUERDO" />';
	constantes.TIPO_ENTIDAD_PETICION_DECISION = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_DECISION" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_DECISION = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_DECISION" />';
	constantes.TIPO_ENTIDAD_TAREA_CANCELADA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_TAREA_CANCELADA" />';
	constantes.TIPO_ENTIDAD_AUTOPRORROGA = '13';
	constantes.TIPO_ENTIDAD_MODIF_CABECERA = '14';

	var funcionVerTarea = function(webflow, id, titulo, parametros, width){

		//Activamos para que el formulario sea readonly
		parametros['isConsulta'] = 'true';

		var config = {
			flow : webflow
			,closable:true
			,title : titulo
			,params:parametros
		};

		if (width != null) config.width = width; 
		else config.autoWitdh='true';

		var w = app.openWindow(config);

		w.on(app.event.DONE, function(){
			w.close();
		});
		w.on(app.event.CANCEL, function(){
			w.close();
		});

		w.on(app.event.OPEN_ENTITY, function(){
			w.close();

			var codigoEntidadInformacion = parametros['codigoTipoEntidad'];
			var idEntidad = parametros['idEntidad'];
			var descripcion = parametros['descripcion'];

			if (codigoEntidadInformacion == '1'){
				app.abreCliente(idEntidadPersona,descripcion);
			}
			if (codigoEntidadInformacion == '2'){
				app.abreExpediente(idEntidadPersona,descripcion);
			}
			if (codigoEntidadInformacion == '3'){
				app.abreAsunto(idEntidadPersona,descripcion);
			}
			if (codigoEntidadInformacion == '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'){
				app.abreProcedimiento(idEntidadPersona,descripcion);
			}
		});
	};


	//Las tareas que se deben implementar son: tareas externas del bpm, recursos, acuerdos, decisiones, prorrogas y comunicaciones
	var funcionConsultar = function(){

		var rec = historicoGrid.getSelectionModel().getSelected();

		if (rec == null) return;

		var idEntidad = rec.get('idEntidad');
		var tipoEntidad = rec.get('tipoEntidad');

		var titulo = rec.get('tarea');
		var webflow = '';
		var parametros = '';
		var width = 320;

		//tareas del bpm
		if(tipoEntidad == constantes.TIPO_ENTIDAD_TAREA){
			page.webflow({
				flow : 'bpm/buscarDatosTarea'
				,params : {id:idEntidad}
				,success : function(response, config){
					var recDatos = response['datos'];

					titulo = panel.getData().nombreProcedimiento+ ' - ' + rec.get('tarea');
					webflow = 'generico/genericForm';
					width = null;

					parametros = {idTareaExterna:recDatos['idTareaExterna'], readOnly:'true', idProcedimiento:panel.getProcedimientoId()};

					funcionVerTarea(webflow, id, titulo, parametros, width);
				}
			});
		}//comunicaciones
		else if (tipoEntidad == constantes.TIPO_ENTIDAD_COMUNICACION){
			page.webflow({
				flow : 'bpm/buscarDatosTarea'
				,params : {id:idEntidad}
				,success : function(response, config){
					var recDatos = response['datos'];

					titulo = '<s:message code="tareas.notificacion" text="**Notificacion" />';
					webflow = 'tareas/consultaNotificacion';
					width = 400;

					parametros = {
						idEntidad: recDatos['idEntidad']
						,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
						,descripcion: recDatos['descripcion']
						,fecha: recDatos['fecha']
						,situacion: recDatos['situacion']
						,idTareaAsociada: recDatos['idTareaAsociada']
						,descripcionTareaAsociada: recDatos['descripcionTareaAsociada']
						,idTarea:recDatos['id']
						,tipoTarea:recDatos['tipoTarea']
					};

					funcionVerTarea(webflow, id, titulo, parametros, width);
				}
			});
		}//recursos
		else if(tipoEntidad == constantes.TIPO_ENTIDAD_PETICION_RECURSO || tipoEntidad == constantes.TIPO_ENTIDAD_RESPUESTA_RECURSO){
			page.webflow({
				flow : 'bpm/buscarDatosRecurso'
				,params : {id:idEntidad}
				,success : function(response, config){
					var recDatos = response['datos'];

					titulo = '<s:message code="procedimiento.recursos.verEditar" text="**Consultar Recurso" />';
					webflow = 'procedimientos/recursos';
					width = 850;

					parametros = {idProcedimiento:panel.getProcedimientoId(),id: recDatos['idRecurso']};

					funcionVerTarea(webflow, id, titulo, parametros, width);
				}
			});
		}//prorrogas
		else if(tipoEntidad == constantes.TIPO_ENTIDAD_PETICION_PRORROGA || tipoEntidad == constantes.TIPO_ENTIDAD_RESPUESTA_PRORROGA){
			page.webflow({
				flow : 'bpm/buscarDatosProrroga'
				,params : {id:idEntidad}
				,success : function(response, config){
					var recDatos = response['datos'];

					titulo = '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prórroga" />';
					webflow = 'tareas/decisionProrroga';
					width = 470;

					parametros = recDatos;
					parametros.codigoTipoProrroga = '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_EXTERNA" />';
					parametros.fechaVencimiento='';

					funcionVerTarea(webflow, id, titulo, parametros, width);
				}
			});
		}//auto-prorrogas
		else if(tipoEntidad == constantes.TIPO_ENTIDAD_AUTOPRORROGA ){
			var allowClose= false;
			var w = app.openWindow({
				flow: 'consultahistorico/consultarHistoricoAutoprorroga'
				,closable: allowClose
				,width : 700
				,title :  '<s:message code="plugin.mejoras.procedimientos.tabTareas.autoprorroga" text="**Autoprórroga" />'
				,params: {id:idEntidad}
			});
			w.on(app.event.DONE, function(){
				w.close();
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});
		}//cabecera
		else if(tipoEntidad == constantes.TIPO_ENTIDAD_MODIF_CABECERA){
			var allowClose= false;
			var w = app.openWindow({
				flow: 'consultahistorico/consultarModificarCabeceraProcedimiento'
				,closable: allowClose
				,width : 700
				,title :  '<s:message code="plugin.mejoras.procedimiento.historico.consulta.modificarCabecera" text="**Modificar cabecera del procedimiento" />'
				,params: {id:idEntidad}
			});
			w.on(app.event.DONE, function(){
				w.close();
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});
		}//acuerdos
		else if(tipoEntidad == constantes.TIPO_ENTIDAD_PETICION_ACUERDO || tipoEntidad == constantes.TIPO_ENTIDAD_RESPUESTA_ACUERDO){
			page.webflow({
				flow : 'bpm/buscarDatosAcuerdo'
				,params : {id:idEntidad}
				,success : function(response, config){
					var recDatos = response['datos'];

					titulo = '<s:message code="procedimiento.historico.consultaAcuerdo" text="**Consulta de acuerdo" />';
					webflow = 'acuerdos/consultaAcuerdo';
					width = 800;

					parametros = {idAsunto:recDatos['idAsunto'], idAcuerdo:recDatos['idAcuerdo'], readOnly:'true'};

					funcionVerTarea(webflow, id, titulo, parametros, width);
				}
			});
		}//decisiones
		else if(tipoEntidad == constantes.TIPO_ENTIDAD_PETICION_DECISION || tipoEntidad == constantes.TIPO_ENTIDAD_RESPUESTA_DECISION) {
			titulo = '<s:message code="procedimiento.listadoDecisiones.editar" text="**Editar Decision" />';
			webflow = 'decisionprocedimiento/ventanaDecision';
			width = 870;

			parametros = {idProcedimiento:panel.getProcedimientoId(), id:idEntidad, readOnly:'true'};

			funcionVerTarea(webflow, id, titulo, parametros, width);
		}
	};

	var tarea = Ext.data.Record.create([
		,{name : "tipoEntidad"}
		,{name : "tarea"}
		,{name : "idEntidad"}
		,{name : "fechaInicio"}
		,{name : "fechaFin"}
		,{name : "fechaVencimiento"}
		,{name : "nombreUsuario"}
		,{name  : "usuarioResponsable"}
	]);

	var btnConsultar =new Ext.Button({
		text:'<s:message code="app.consultar" text="**Consultar" />'
		<app:test id="btnConsultarTareahistorica" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:funcionConsultar
		,disabled: false
	});

	var tareasProcStore = page.getStore({
		event:'listado'
		,flow : 'procedimientos/historicoProcedimiento'
		,reader : new Ext.data.JsonReader(
			{root:'historicoProcedimiento'}
			,tarea
		)
	});

	entidad.cacheStore(tareasProcStore);

	var pagingBar=fwk.ux.getPaging(tareasProcStore);

	var historicoCm = new Ext.grid.ColumnModel([
		{dataIndex : 'idEntidad', fixed:true, hidden:true}
		,{dataIndex : 'tipoEntidad', fixed:true, hidden:true}
		,{header : '<s:message code="procedimiento.historico.grid.tareas" text="**tarea"/>', dataIndex : 'tarea', width:275}
		,{header : '<s:message code="procedimiento.historico.grid.fechaInicio" text="**fecha inicio"/>', dataIndex : 'fechaInicio', width:65}
		,{header : '<s:message code="procedimiento.historico.grid.fechaFin" text="**fecha fin"/>', dataIndex : 'fechaFin', width:65}
		,{header : '<s:message code="procedimiento.historico.grid.fechaVencimiento" text="**fecha venc"/>', dataIndex : 'fechaVencimiento', width:65}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.destinatarioTarea" text="**destinatario"/>', dataIndex : 'usuarioResponsable', width:50}
	]);

    var historicoGrid = app.crearGrid(tareasProcStore,historicoCm,{
		title:'<s:message code="procedimiento.historico.grid" text="**Historico del procedimiento" />'
		,cls:'cursor_pointer'
		,width : 700
		,height : 400
		,bbar:[btnConsultar]
    });

	historicoGrid.on('rowdblclick',function(grid, rowIndex, e){
		funcionConsultar();
	});

	tareasProcStore.on('load', function(store, records, options){
		for (var i=0; i < records.length; i++){
			var rec = records[i];
			var tipoEntidad = rec.get('tipoEntidad');
			var titulo = rec.get('tarea');
			if(tipoEntidad == constantes.TIPO_ENTIDAD_TAREA_CANCELADA){
				var nombreTarea = "<font color='red'>" + titulo + " (Cancelada)</font>";
				rec.set('tarea', nombreTarea);
			}
		}
	});

	panel.add(historicoGrid);

	panel.getData = function(){
		return entidad.get("data").historico;
	}

	panel.getValue = function(){
  	}

	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, tareasProcStore, {idProcedimiento : data.id});
	}

	panel.getProcedimientoId = function(){
		return entidad.get("data").id;
	}

	return panel;
})