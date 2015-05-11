<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="procedimientos" items="${procedimientos}" var="pro">
		<json:object>
			<json:property name="id" value="${pro.id}"/> 
			<json:property name="idPrc" value="${pro.procedimiento.id}"/> 
			<json:property name="descPrc" value="${pro.procedimiento.asunto.nombre}"/> 
			<json:property name="tipoProcedimiento" value="${pro.procedimiento.tipoProcedimiento.descripcion}"/>
			<json:property name="asuntoId" value="${pro.procedimiento.asunto.id}"/>
			<json:property name="asuntoNombre" value="${pro.procedimiento.asunto.nombre}"/>	
			<json:property name="juzgado" value="${pro.procedimiento.juzgado.descripcion}"/>
			<json:property name="plazaJuzgado" value="${pro.procedimiento.juzgado.plaza.descripcion}" /> 
			<json:property name="principal" value="${pro.procedimiento.saldoRecuperacion}" />
			<json:property name="fechaInicio">
				<fwk:date value="${pro.procedimiento.auditoria.fechaCrear}" />
	  		</json:property>
	  		<json:property name="despacho" value="${pro.procedimiento.asunto.gestor.despachoExterno.despacho}" />
			<json:property name="idBien" value="${pro.bien.id}"/>
			<c:if test="${pro.solvenciaGarantia != null}">
				<json:property name="solvenciaGarantia" value="${pro.solvenciaGarantia.descripcion}"/>
			</c:if>	
 		</json:object>
	</json:array>
</fwk:json>
