<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fwk:json>
	<json:array name="eventos" items="${data}" var="ev">
		<json:object>
			<json:property name="nombreTarea" value="${ev.nombreTarea}" escapeXml="false"/>
			<json:property name="descripcion" value="${ev.descripcionEntidad}" />
			<json:property name="subtipo" value="${ev.subtipoTareaDescripcion}" />
			<json:property name="codigoSubtipoTarea" value="${ev.subtipoTareaCodigoSubtarea}" />
			<json:property name="dtype" value="${ev.tipo}" />
			<%-- Si es gestion de vencidos, entra en el grupo "esta semana" --%>
			<c:if test='${ev.subtipoTareaCodigoSubtarea == 1 || ev.subtipoTareaCodigoSubtarea == 98 || ev.subtipoTareaCodigoSubtarea == 99}'>
				<json:property name="group" value="2" />
				<json:property name="nombreTarea" value="${ev.nombreTarea}"/>
				<json:property name="descripcion" value="${ev.descripcionTarea}" />
			</c:if>		
			<c:if test='${ev.subtipoTareaCodigoSubtarea != 1 && ev.subtipoTareaCodigoSubtarea != 98 && ev.subtipoTareaCodigoSubtarea != 99}'>
				<json:property name="fechaInicio" > 
					<fwk:date value="${ev.fechaInicio}"/>
				</json:property>
 				<json:property name="group">
						<app:groupTareasOptimizacion value="${ev.groupTareasDataInfo}" />
				</json:property>	
				<json:property name="id" value="${ev.id}" />
 				<json:property name="plazo" value="${ev.plazo}" /> 
 				<json:property name="entidadInformacion" value="${ev.entidadInformacion}"/> 

				<json:property name="codigoEntidadInformacion" value="${ev.tipoEntidadCodigo}" />
 				<json:property name="codentidad" value="${ev.codEntidad}" />
 				<json:property name="gestor" value="${ev.gestor}" />
				<json:property name="tipoTarea" value="${ev.subtipoTareaTipoTareaCodigoTarea}" />
 				<json:property name="tipoSolicitudSQL" value="${ev.tipoSolicitudSQL}" /> 
 				<json:property name="idEntidad" value="${ev.idEntidad}" /> 
 				<json:property name="fcreacionEntidad" value="${ev.fechaCreacionEntidadFormateada}" /> 
 				<json:property name="codigoSituacion" value="${ev.situacionEntidad}" /> 

				<c:if test="${ev.tipo != 'TareaNotificacion'}">
					<json:property name="fechaVencReal"><fwk:date value="${ev.fechaVencReal}"/></json:property>
					<json:property name="revisada" value="${ev.revisada}" />
					<json:property name="fechaRevisionAlerta" >
						<fwk:date value="${ev.fechaRevisionAlerta}"/>
					</json:property>
				</c:if>
				<c:if test="${ev.tipo == 'TareaNotificacion'}">
					<json:property name="fechaVencReal"><fwk:date value="${ev.fechaVenc}"/></json:property>
				</c:if>
				<fmt:formatDate value="${ev.fechaVenc}" pattern="dd/MM/yyyy HH:mm:ss" var="timestamp_asdate" />
				<json:property name="fechaVenc" value="${timestamp_asdate}"/>
				<%--<json:property name="fechaVenc"><fwk:date value="${ev.fechaVenc}"/></json:property> --%>
 				<json:property name="idTareaAsociada" value="${ev.idTareaAsociada}"/>
				<json:property name="descripcionTareaAsociada" value="${ev.descripcionTarea}"/>
				<json:property name="emisor" value="${ev.emisor}"/>
 				<json:property name="supervisor" value="${ev.supervisor}"/>
 				<json:property name="diasVencidoSQL" value="${ev.diasVencidoSQL}"/> 
 				<json:property name="descripcionExpediente">
					<%--<s:message text="${ev.expediente.descripcionExpediente}" javaScriptEscape="true" /> --%>
					<s:message text="${ev.descripcionExpediente}" javaScriptEscape="true" />
				</json:property>
				<c:if test="${ev.contrato != null}">
					<%--<json:property name="descripcionContrato" value="${ev.contrato.codigoContrato}"/> --%>
					<json:property name="descripcionContrato" value="${ev.codigoContrato}"/>
				</c:if>
				<c:if test="${ev.contrato == null}">
					<json:property name="descripcionContrato" value=""/>
				</c:if>
 				<json:property name="gestorId" value="${ev.gestor}"/>
				<json:property name="supervisorId" value="${ev.supervisor}"/>						
				<json:property name="idEntidadPersona" value="${ev.idEntidadPersona}"/>
				<json:property name="volumenRiesgoSQL" value="${ev.volumenRiesgoSQL}"/>
				<json:property name="volumenRiesgoVencido" value="${ev.volumenRiesgoSQL}"/>
				<json:property name="itinerario" value="${ev.tipoItinerarioEntidad}"/>	 		
			</c:if>
			<c:if test='${ev.subtipoTareaCodigoSubtarea == "503" }'>
				<json:property name="fechaPropuesta" >
					<fwk:date  value="${ev.prorrogaFechaPropuesta}"/>
				</json:property>
				<json:property name="motivo" value="${ev.prorrogaCausaProrrogaDescripcion}"/>
			</c:if>
		</json:object>
	</json:array>
</fwk:json>