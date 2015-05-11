<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="expedientes" items="${pagina.results}" var="exp">
		<json:object>
			<json:property name="codigo" value="${exp.id}" />
			<json:property name="descripcion" value="${exp.descripcionExpediente}" />
			<json:property name="fcreacion">
				<fwk:date value="${exp.auditoria.fechaCrear}"/>
			</json:property>
			<json:property name="estado" value="${exp.estadoExpediente.descripcion}" />
			<json:property name="situacion" value="${exp.estadoItinerario.descripcion}" />
			<json:property name="volumenRiesgo" value="${exp.volumenRiesgo}" />
			<json:property name="volumenRiesgoVencido" value="${exp.volumenRiesgoVencido}" />
			<c:if test='${exp.manual}'>
				<json:property name="manual">
					<s:message code='expediente.manual' text='**Manual'/>
				</json:property>
			</c:if>
			<c:if test='${!exp.manual}'>
				<json:property name="manual">
					<s:message code='expediente.automatico' text='**Automático'/>
				</json:property>
			</c:if>
			<json:property name="gestor" value="${exp.gestorActual}" />
			<json:property name="oficina" value="${exp.oficina.codigoOficinaFormat}" />
			<json:property name="fechaComite">
				<fwk:date value="${exp.fechaVencimiento}"/>
			</json:property>
			<json:property name="comite" value="${exp.comite.nombre}" />
		</json:object>
	</json:array>
</fwk:json>
