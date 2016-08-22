<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	/* Grid historial de aceptacion asunto */

	var historial = <json:object>
			<json:array name="historial" items="${asunto.fichaAceptacion.observaciones}" var="obs">
				 <json:object>
				   <json:property name="fecha">
				       <fwk:date value="${obs.fecha}" />
				   </json:property>
				   <json:property name="usuario">
						${obs.usuario.apellidoNombre}
						<c:if test="${obs.usuario.id==asunto.gestor.usuario.id && obs.usuario.id!=asunto.supervisor.usuario.id}"><s:message code="asunto.tabaceptacion.gridhistorial.gestor" text="**(gestor)" /></c:if>
						<c:if test="${obs.usuario.id==asunto.supervisor.usuario.id}"><s:message code="asunto.tabaceptacion.gridhistorial.supervisor" text="**(supervisor)" /></c:if>
				   </json:property>
				   <json:property name="detalle" value="${obs.detalle}" />
				   <json:property name="accion" value="${obs.accion}" />
				 </json:object>
			</json:array>
		</json:object>
		;

	var historialStore = new Ext.data.JsonStore({
		data : historial
		,root : 'historial'
		,fields : ['fecha', 'usuario','detalle','accion']
	});
	var historialCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="asunto.tabaceptacion.gridhistorial.fecha" text="**Fecha" />', dataIndex : 'fecha', sortable:true, width:80 }
		,{header : '<s:message code="asunto.tabaceptacion.gridhistorial.usuario" text="**Usuario" />', dataIndex : 'usuario', sortable:true, width:200 }
		,{header : '<s:message code="asunto.tabaceptacion.gridhistorial.detalle" text="**Detalle" />', dataIndex : 'detalle', sortable:true, width:400 }
		,{header : '<s:message code="asunto.tabaceptacion.gridhistorial.tipoAccion" text="**Tipo Acción" />', dataIndex : 'accion', sortable:true, width:200 }
	]);

	var historialGridPanel = new Ext.grid.GridPanel({
		store : historialStore
		,cm : historialCm
		//,width : 700
		,frame:false
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,width:addressCM.getTotalWidth()
		,autoHeight:true
		,autoWidth : true
	});

	page.add(historialGridPanel);

</fwk:page>
