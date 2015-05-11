<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="asuntos" items="${pagina.results}" var="asu">
		<json:object>
			<json:property name="id" value="${asu.id}" />
			<json:property name="codigo" value="${asu.id}" />
			<json:property name="nombre" value="${asu.nombre}" />
			<json:property name="fechaCrear">
				<fwk:date value="${asu.auditoria.fechaCrear}" />
			</json:property>					
			<json:property name="gestorNombreApellidosSQL"> 
				<c:if test="${asu.gestoresAsunto == null}">
					${asu.gestor.usuario.apellidoNombre}
				</c:if>
				<c:if test="${(asu.gestoresAsunto != null) && (asu.gestoresMap != null)}">
					${asu.gestorNombreApellidosSQL}
				</c:if>
			</json:property>			
			<json:property name="despachoSQL">
				<c:if test="${asu.gestoresAsunto == null}">
					${asu.gestor.despachoExterno.despacho}"
				</c:if>
				<c:if test="${(asu.gestoresAsunto != null) && (asu.gestoresMap != null)}">
					${asu.despachoSQL}
				</c:if>
			</json:property>			
			<json:property name="supervisorNombreApellidosSQL">
				<c:if test="${asu.gestoresAsunto == null}">
					${asu.supervisor.usuario.apellidoNombre}
				</c:if>
				<c:if test="${(asu.gestoresAsunto != null) && (asu.gestoresMap != null)}">
					${asu.supervisorNombreApellidosSQL}
				</c:if>
			</json:property>
			<json:property name="estadoAsunto" value="${asu.estadoAsunto.descripcion}" />
			<c:if test="${asu.tipoAsunto != null}">	
				<json:property name="tipoAsunto" value="${asu.tipoAsunto.descripcion}" />		
			</c:if>
			<json:property name="confirmado" value="${asu.estaConfirmado}" />
			<json:property name="saldoTotalPorContratosSQL" value="${asu.saldoTotalPorContratosSQL}" />
			<json:property name="importeEstimado" value="${asu.importeEstimado}" />
		</json:object>
	</json:array>
</fwk:json>