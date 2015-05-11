<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:array name="procedimiento" items="${procedimientos}" var="procedimiento">
		<json:object>
			<json:property name="id" value="${procedimiento.id}" />
			<json:property name="tipoProcedimiento" value="${procedimiento.tipoProcedimiento.codigo}" />
			<json:property name="numeroAutos" value="${procedimiento.codigoProcedimientoEnJuzgado}" />
			<json:property name="demandado" value="${procedimiento.personasAfectadas[0].apellidoNombre}" />
			<json:property name="importe" value="${procedimiento.saldoRecuperacion}" />
			<c:if test="${procedimiento.juzgado != '' || procedimiento.juzgado!=null}">
				<json:property name="codigoPlaza" value="${procedimiento.juzgado.plaza.codigo}" />
				<json:property name="codigoJuzgado" value="${procedimiento.juzgado.codigo}" />
			</c:if>
		</json:object>
	</json:array>	
</fwk:json>