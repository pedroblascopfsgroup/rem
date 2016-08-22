<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="expedientes" items="${pagina.results}" var="exp">
		<json:object>
			<json:property name="id" value="${exp.id}" />
			<json:property name="descripcion" value="${exp.descripcionExpediente}" />
			<json:property name="fcreacion">
				<fwk:date value="${exp.auditoria.fechaCrear}" />
			</json:property>
			<c:if test='${exp.manual}'>
				<json:property name="origen" value="<s:message code='expediente.manual' text='**Manual'/>" />
			</c:if>
			<c:if test='${!exp.manual}'>
				<json:property name="origen" value="<s:message code='expediente.automatico' text='**Automático'/>" />
			</c:if>
			<json:property name="situacion" value="${exp.estadoItinerario.descripcion}" />
			<json:property name="oficina" value="${exp.oficina.codigoOficinaFormat} ${exp.oficina.nombre}" />
			<json:property name="estado" value="${exp.estadoAsString}" />
			<json:property name="volumenRiesgo" value="${exp.volumenRiesgoAbsoluto}" />
			<json:property name="volumenRiesgoVencido" value="${exp.volumenRiesgoVencidoAbsoluto}" />
			<json:property name="gestor" value="${exp.gestorActual}" />
			<json:property name="fcomite">
				<fwk:date value="${exp.fechaVencimiento}" />
			</json:property>
			<json:property name="comite" value="${exp.comite.nombre}" />
		</json:object>
	</json:array>
</fwk:json>