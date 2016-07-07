<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="cambiosGestoresHistorico" items="${cambiosGestoresHistorico}" var="cambioGestorHistorico">
		<json:object>
			<c:forEach items="${cambioGestorHistorico.infoRegistro}" var="registro">			
				<c:if test="${registro.clave=='tipoGestor'}">
					<json:property name="tipoGestor" value="${registro.valor}" />					
				</c:if>
			</c:forEach>
			<c:forEach items="${cambioGestorHistorico.infoRegistro}" var="registro">			
				<c:if test="${registro.clave=='userOld'}">
					<json:property name="antiguoUsuario" value="${registro.valor}" />					
				</c:if>
			</c:forEach>
			<c:forEach items="${cambioGestorHistorico.infoRegistro}" var="registro">			
				<c:if test="${registro.clave=='userNew'}">
					<json:property name="nuevoUsuario" value="${registro.valor}" />					
				</c:if>
			</c:forEach>		
			<c:forEach items="${cambioGestorHistorico.infoRegistro}" var="registro">			
				<c:if test="${registro.clave=='dateBegin'}">
					<json:property name="fechaInicio" value="${registro.valor}" />
				</c:if>
			</c:forEach>	
			<c:forEach items="${cambioGestorHistorico.infoRegistro}" var="registro">			
				<c:if test="${registro.clave=='dateEnd'}">
					<json:property name="fechaFin" value="${registro.valor}" />					
				</c:if>
			</c:forEach>		
			<json:property name="usuarioModifica" value="${cambioGestorHistorico.usuario.nombre} ${cambioGestorHistorico.usuario.apellido1} ${cambioGestorHistorico.usuario.apellido2}" />
		</json:object>
	</json:array>
</fwk:json>