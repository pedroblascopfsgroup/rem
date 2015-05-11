<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
		<json:object>
			<json:property name="idProcedimiento" value="${idProcedimiento}"/>
			<json:property name="id" value="${rec.id}"/>
			<json:property name="codigo" value="${rec.codigoInterno}"/>
			<json:property name="descripcion" value="${rec.descripcionBien}"/>
			<json:property name="tipo" value="${rec.tipoBien.descripcion}"/>
			<json:property name="observaciones" value="${rec.observaciones}"/>			
			<c:forEach items="${rec.NMBEmbargosProcedimiento}" var="ins">
			    <c:if test="${ins.procedimiento.id == idProcedimiento}">
					<json:property name="idEmbargo" value="${ins.id}"/>
					<json:property name="letra" value="${ins.letra}"/>
					<json:property name="fechaSolicitud" value="${ins.fechaSolicitud}"/>
					<json:property name="fechaDecreto" value="${ins.fechaDecreto}"/>
					<json:property name="fechaRegistro" value="${ins.fechaRegistro}"/>
					<json:property name="fechaDenegacion" value="${ins.fechaDenegacion}"/>
					<json:property name="importeValor" value="${ins.importeValor}"/>					
					<json:property name="fechaAval" value="${ins.fechaAval}"/>
					<json:property name="importeAval" value="${ins.importeAval}"/>
					<json:property name="fechaTasacion" value="${ins.fechaTasacion}"/>
					<json:property name="importeTasacion"  value="${ins.importeTasacion}"/>
					<json:property name="fechaAdjudicacion" value="${ins.fechaAdjudicacion}"/>
					<json:property name="importeAdjudicacion"  value="${ins.importeAdjudicacion}"/>
			    </c:if>
			</c:forEach>			
		</json:object>
	</json:array>
</fwk:json>

