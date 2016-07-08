<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	
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
	
	<pfs:defineRecordType name="HistoricoAsuntoRT">
		<pfs:defineTextColumn name="idEntidad"/>
		<pfs:defineTextColumn name="tipoEntidad"/>
		<pfs:defineTextColumn name="tarea"/>
		<pfs:defineTextColumn name="idTarea"/>
		<pfs:defineTextColumn name="tipoActuacion"/>
		<pfs:defineTextColumn name="tipoProcedimiento"/>
		<pfs:defineTextColumn name="numeroProcedimiento"/>
		<pfs:defineTextColumn name="fechaInicio"/>
		<pfs:defineTextColumn name="fechaFin"/>
		<pfs:defineTextColumn name="fechaVencimiento"/>
		<pfs:defineTextColumn name="nombreUsuario"/>
		<pfs:defineTextColumn name="importe"/>
		<pfs:defineTextColumn name="numeroAutos"/>
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="historicoAsuntoCM">
		<pfs:defineHeader dataIndex="tarea" captionKey="plugin.mejoras.asunto.tabHistorico.tarea" 
			caption="**Tarea" sortable="true" firstHeader="true"/>
		<pfs:defineHeader dataIndex="idTarea" captionKey="plugin.mejoras.asunto.tabHistorico.tarea" 
			caption="**Tarea" sortable="true" firstHeader="false" hidden="true"/>
		<pfs:defineHeader dataIndex="numeroProcedimiento" captionKey="plugin.mejoras.asunto.tabHistorico.numeroProcedimiento" 
			caption="**Nmero de procedimiento" sortable="true"  />
		<pfs:defineHeader dataIndex="tipoActuacion" captionKey="plugin.mejoras.asunto.tabHistorico.tipoActuacion" 
			caption="**Tipo de actuacin" sortable="true"  hidden="true"/>
		<pfs:defineHeader dataIndex="tipoProcedimiento" captionKey="plugin.mejoras.asunto.tabHistorico.tipoProcedimiento" 
			caption="**Tipo de procedimiento" sortable="true"  />
		<pfs:defineHeader dataIndex="fechaInicio" captionKey="plugin.mejoras.asunto.tabHistorico.fechainicio" 
			caption="**fecha inicio" sortable="true" />
		<pfs:defineHeader dataIndex="fechaFin" captionKey="plugin.mejoras.asunto.tabHistorico.fechafin" 
			caption="**fecha fin" sortable="true" />
		<pfs:defineHeader dataIndex="fechaVencimiento" captionKey="plugin.mejoras.asunto.tabHistorico.fechaVencimiento" 
			caption="**fecha venc" sortable="true" />
		<pfs:defineHeader dataIndex="nombreUsuario" captionKey="plugin.mejoras.asunto.tabHistorico.usuario" 
			caption="**usuario" sortable="true" />
		<pfs:defineHeader dataIndex="importe" captionKey="plugin.mejoras.asunto.tabHistorico.importe" 
			caption="**importe" sortable="true" renderer="app.format.moneyRenderer"/>
		<pfs:defineHeader dataIndex="numeroAutos" captionKey="plugin.mejoras.asunto.tabHistorico.numeroAutos" 
			caption="**Numero autos" sortable="true"  />
	</pfs:defineColumnModel>
	
	var tareasProcStore = page.getStore({
        flow: 'historicoasunto/getHistoricoAgregadoAsunto'
        ,storeId : 'tareasProcStore'
        ,reader : new Ext.data.JsonReader(
            {root:'historicoAsunto'}
            , HistoricoAsuntoRT
        )
	});  
	
	<pfs:grid name="historicoGrid" 
		dataStore="tareasProcStore" 
		columnModel="historicoAsuntoCM" 
		title="**Histico de tareas" 
		collapsible="false" 
		titleKey="plugin.mejoras.asunto.tabHistorico.grid.titulo"/>
	
	historicoGrid.on('rowdblclick', function(grid, rowIndex, e) {
		
		var recStore = grid.getStore().getAt(rowIndex);
		
    	if(recStore.get('idTarea')){

			var w = app.openWindow({
								flow : 'tareas/generarNotificacion'
								,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
								,width:650 
								,params : {
										idEntidad: recStore.get('idEntidad')
										,codigoTipoEntidad: recStore.get('tipoEntidad')
										,descripcion: recStore.get('tarea')
										,fecha: recStore.get('fechaInicio')
										,situacion: 'Asunto'
										,idTareaAsociada: recStore.get('idTarea')
										,isConsulta:true
								}
							});
							w.on(app.event.DONE, function(){
								w.close();
							});
							w.on(app.event.CANCEL, function(){ w.close(); });
							w.on(app.event.OPEN_ENTITY, function(){
								w.close();
																						
								app.abreAsuntoTab(recStore.get('idEntidad'), recStore.get('tarea'), 'cabeceraAsunto');
								
											
							});
		}
		
	});	
	
	entidad.cacheStore(historicoGrid.getStore());
	
	var panel = new Ext.Panel({
		title: '<s:message code="procedimiento.historico" text="**Historico" />'
		,autoHeight: true
		,items : [
				{items:historicoGrid
				,border:false
				,style:'margin-top: 7px; margin-left:5px'}
			]
		,nombreTab : 'tabAdjuntosAsunto'			
	});

	panel.getValue = function(){}
	
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, tareasProcStore, {id : data.id });
		//tareasProcStore.webflow({id : data.id });
		//this.doLayout()
	}
   
	return panel;
})