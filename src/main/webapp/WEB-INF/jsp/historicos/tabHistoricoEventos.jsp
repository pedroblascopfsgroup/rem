<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

/**
 * Crea un tab con el historico de eventos segun el tipo de entidad (Asunto,Expediente, Cliente)<br>
 * El listado contendrá todos los eventos de esa entidad
 * @param {Object} tipoEntidad
 * @param {Object} idEntidad
 */
var createTabHistoricoEventos=function(tipoEntidad, idEntidad){

	var evento = Ext.data.Record.create([
		{name:'descripcion'}
		,{name:'tipoSolicitud'}
		,{name:'fechaInicio'}
		,{name:'fechaFin'}
		,{name:'fechaVenc'}
		,{name:'alertada'}
		,{name:'finalizada'}	
		,{name:'emisor'}
		,{name:'codigoSubtipoTarea'}
		,{name:'codigotipoTarea'}
		,{name:'idEntidad'}
		,{name:'codigoEntidadInformacion'}
		,{name:'descripcionTarea'}
		,{name:'descripcionEntidad'}
		,{name:'fcreacionEntidad'}
		,{name:'codigoSituacion'}
		,{name:'idEntidadPersona'}
		,{name:'motivoProrroga'}
		,{name:'fechaPropuestaProrroga'}
		,{name:'id'}
	]);
	
    
    var eventosStore = page.getStore({
            flow:'historicos/listadoHistoricoEventos'
            ,reader: new Ext.data.JsonReader({
                root: 'eventos'
            }, evento)
        });
	var eventosCM  = new Ext.grid.ColumnModel([
		{hidden:true,sortable: false, dataIndex: 'id',fixed:true},
		{header:'<s:message code="historicoEventos.grid.descripcion" text="**descripcion"/>',dataIndex:'descripcion',width:200},
		{header:'<s:message code="historicoEventos.grid.tarea" text="**Tarea"/>',dataIndex:'descripcionEntidad',width:200},
		{header:'<s:message code="historicoEventos.grid.tipoSolicitud" text="**tipo solicitud"/>',dataIndex:'tipoSolicitud',width:200},
		{header:'<s:message code="historicoEventos.grid.fechaInicio" text="**F. Inicio"/>',dataIndex:'fechaInicio',align:'right'},
		{header:'<s:message code="historicoEventos.grid.fechaFin" text="**F. Fin"/>',dataIndex:'fechaFin',align:'right'},
		{header:'<s:message code="historicoEventos.grid.fechaVenc" text="**F. Venc"/>',dataIndex:'fechaVenc',align:'right'},
		{header:'<s:message code="historicoEventos.grid.alertada" text="**Alertada"/>',dataIndex:'alertada',renderer:app.format.booleanToYesNoRenderer},
		{header:'<s:message code="historicoEventos.grid.finalizada" text="**Finalizada"/>',dataIndex:'alertada',renderer:app.format.booleanToYesNoRenderer},
		{header:'<s:message code="historicoEventos.grid.emisor" text="**Emisor"/>',dataIndex:'emisor'}
	]);
	
	var eventosGrid = app.crearGrid(eventosStore,eventosCM,{
		title:'<s:message code="historicoEventos.grid.title" text="**eventos"/>'
		,style:'padding-right:10px;'
		,iconCls:'icon_listado_eventos'
		,cls:'cursor_pointer'
		,width : 700
		,height : 420
	});
	
	eventosGrid.on('rowdblclick', function(grid, rowIndex, e) {
		
    	var rec = grid.getStore().getAt(rowIndex);
		
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		
		var codigotipoTarea = rec.get('codigotipoTarea');
		
			switch(codigoSubtipoTarea){
				//solo para expedientes
				
				//La tarea es una prorroga
				case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE:
				case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE:
				case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC:
					var w = app.openWindow({
							flow : 'tareas/decisionProrroga'
							,title : '<s:message code="expedientes.menu.consultarprorroga" text="**Consultar Prórroga" />'
							,width:500
							,params : {
									idEntidadInformacion: rec.get('idEntidad')
									,isConsulta:true
									,fechaVencimiento:''
									,fechaCreacion: rec.get('fcreacionEntidad')
									,situacion: '${expediente.estadoItinerario.descripcion}'
									,destareaOri: rec.get('descripcionTarea')
									,idTipoEntidadInformacion: rec.get('codigoEntidadInformacion')
									,fechaPropuesta: rec.get('fechaPropuestaProrroga')
									,motivo: rec.get('motivoProrroga')
									,idTareaOriginal: rec.get('id')	
									,descripcion:'<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />'												
									,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'
							}
						});
						w.on(app.event.DONE, function(){
							w.close();
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
				break;
				
				
				
				//La tarea es una solicitud de cancelacion
				case app.subtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR:
					var w = app.openWindow({
						flow : 'expedientes/decisionSolicitudCancelacionConTarea'
						,eventName: 'tarea'
						,title : '<s:message code="expedientes.consulta.solicitarcancelacion" text="**Solicitar cancelacion" />'
						,params : {idExpediente:rec.get('idEntidad'), idTarea:rec.get('id'), espera:true}
					});
				
					w.on(app.event.DONE, function(){
									w.close();
								 }	 
					);
					w.on(app.event.CANCEL, function(){ w.close(); });
				break;
				//La tarea es una comunicacion
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
									,isConsulta:true
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
				default:
					if (codigotipoTarea == app.tipoTarea.TIPO_NOTIFICACION) {
						//La tarea es una notificacion
						var w = app.openWindow({
							flow: 'tareas/consultaNotificacion',
							title: '<s:message code="tareas.notificacion" text="**Notificacion" />',
							width: 400,
							params: {
								idEntidad: rec.get('idEntidad'),
								codigoTipoEntidad: rec.get('codigoEntidadInformacion'),
								descripcion: rec.get('descripcionTarea'),
								fecha: rec.get('fcreacionEntidad'),
								situacion: rec.get('codigoSituacion'),
								descripcionTareaAsociada: rec.get('descripcionTareaAsociada'),
								idTareaAsociada: rec.get('idTareaAsociada'),
								idTarea: rec.get('id'),
								tipoTarea: rec.get('codigotipoTarea'),
								readOnly: true
							}
						});
						w.on(app.event.CANCEL, function(){
							w.close();
						});
						w.on(app.event.DONE, function(){
							w.close();
						});
						w.on(app.event.OPEN_ENTITY, function(){
							w.close();
							if (rec.get('codigoEntidadInformacion') == '1') {
								app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
							}
							if (rec.get('codigoEntidadInformacion') == '2') {
								app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
							}
							if (rec.get('codigoEntidadInformacion') == '3') {
								app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
							}
							if (rec.get('codigoEntidadInformacion') == '5') {
								app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
							}
							if (rec.get('codigoEntidadInformacion') == '7') {
								app.abreClienteTab(rec.get('idEntidadPersona'), rec.get('descripcion'), 'politicaPanel');
							}
						});
					}
				break;				
			}
		
		
	});
		
	var panel = new Ext.Panel({
		title:'<s:message code="historicoEventos.tabTitle" text="**eventos"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[eventosGrid]
		,nombreTab : 'historicoEventos'
	});
	eventosStore.webflow({tipoEntidad:tipoEntidad, idEntidad:idEntidad});
	return panel;
}
