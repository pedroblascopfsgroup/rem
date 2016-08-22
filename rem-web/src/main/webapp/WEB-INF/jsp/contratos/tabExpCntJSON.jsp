<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
    <json:array name="expedientes" items="${cex}" var="cex">   
        <json:object>
            <json:property name="id" value="${cex.expediente.id}"/>
            <json:property name="descripcion">
            	<s:message text="${cex.expediente.descripcionExpediente}" javaScriptEscape="true" />
            </json:property>
            <json:property name="fechaCrear">
            	<fwk:date value="${cex.expediente.auditoria.fechaCrear}"/>
            </json:property>
            <c:if test="${cex.expediente.manual}">
				 <json:property name="origen">
				 	<s:message code="contrato.tabExpAsunto.manual" text="**Manual"/>
				 </json:property>       	
            </c:if>
			<c:if test="${!cex.expediente.manual}">
				 <json:property name="origen">
				 	<s:message code="contrato.tabExpAsunto.automatico" text="**Automático"/>
				 </json:property>       	
            </c:if>
            <json:property name="situacion" value="${cex.expediente.estadoItinerario.descripcion}" />
            <json:property name="estadoExpediente" value="${cex.expediente.estadoExpediente.descripcion}" />
            <json:property name="volumenRiesgo" value="${cex.expediente.volumenRiesgoAbsoluto}" />
            <json:property name="volumenRiesgoVencido" value="${cex.expediente.volumenRiesgoVencidoAbsoluto}" />
            <json:property name="oficina" value="${cex.expediente.oficina.nombre}" />
            <json:property name="gestor" value="${cex.expediente.gestorActual}" />
            <json:property name="diasVencimiento" value="${cex.expediente.diasParaVencimiento}" />
			<json:property name="fechaVencimiento">
				<fwk:date value="${cex.expediente.fechaVencimiento}" />
			</json:property>
			<c:if test="${cex.auditoria.borrado}">
				<json:property name="pertenece">
					<s:message code="contrato.tabExpAsuCnt.historico" text="**Histórico" />
				</json:property>
			</c:if>
			<c:if test="${!cex.auditoria.borrado}">
				<json:property name="pertenece">
					<s:message code="contrato.tabExpAsuCnt.actual" text="**Actual" />
				</json:property>
			</c:if>
			<c:if test="${cex.pase != null && cex.pase == 1}">
				<json:property name="pase">
					<s:message code="label.si" text="**Si" />				
				</json:property>
			</c:if>
			<c:if test="${cex.pase == null || cex.pase == 0}">
				<json:property name="pase" value="" />
			</c:if>
        </json:object>
    </json:array>
</fwk:json>