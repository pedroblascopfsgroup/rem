<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="expedientes" items="${pagina.results}" var="exp">
		<json:object>
			<json:property name="id" value="${exp.id}" />
			<json:property name="descripcionExpediente" value="${exp.descripcionExpediente}" />			
			<json:property name="fechacrear" value="${exp.auditoria.fechaCrear}" />
			<json:property name="fcreacion" value="${exp.auditoria.fechaCrear}" />
			<c:if test='${exp.manual}'>
				<json:property name="origen">
					<s:message code='expediente.manual' text='**Manual'/>
				</json:property>
			</c:if>
			<c:if test='${!exp.manual}'>
				<json:property name="origen">
					<s:message code='expediente.automatico' text='**Automático'/>
				</json:property>
			</c:if>
			<json:property name="estadoItinerario" value="${exp.estadoItinerario.descripcion}" />
			<json:property name="oficina" value="${exp.oficina.codigoOficinaFormat} ${exp.oficina.nombre}" />
			<json:property name="estadoExpediente" value="${exp.estadoExpediente.descripcion}" />
			<json:property name="volumenRiesgo" value="${exp.volumenRiesgoAbsoluto}"/>
			<json:property name="volumenRiesgoVencido" value="${exp.volumenRiesgoVencidoAbsoluto}" />
			<json:property name="gestorActual" value="${exp.gestorActual}" />
			<json:property name="fechaVencimiento" value="${exp.fechaVencimiento}" />
			<json:property name="comite" value="${exp.comite.nombre}" />
         <json:property name="decidido" value="${exp.estaDecidido}" />      
         <json:property name="cantAsuntos" value="${exp.cantidadAsuntos}" />
         <json:property name="cantContratos" value="${exp.cantidadContratos}" />     
   		 <json:property name="itinerario" value="${exp.tipoItinerario}"/>   
   		 <json:property name="tipoExpediente" value="${exp.tipoExpediente.descripcion}"/>       
		</json:object>
	</json:array>
</fwk:json>