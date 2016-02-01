<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  


<fwk:json>
 	<json:property name="total" value="${acciones.totalCount}" />
	<json:array name="acciones" items="${acciones.results}" var="accion">
		<json:object>
			<json:property name="contrato" value="${accion.contrato.codigoContrato}"/> 
			<json:property name="iter" value="${accion.iterJudicial.id}"/>
			<c:if test="${accion.persona==null}">
				<json:property name="codigoPersona" value="${accion.codigoPersona}"/>
			</c:if>
			<c:if test="${accion.persona!=null}">
				<json:property name="codigoPersona" value="${accion.persona.apellidoNombre}"/>
			</c:if>
			<json:property name="fechaInteraccion" >
					<fwk:date value="${accion.fechaAccion}"/>	
			</json:property>
			<json:property name="tipoInteraccion" value="${accion.tipoAccionNoProc.descripcion}"/>
			<json:property name="subtipoInteraccion" value="${accion.subtipoAccionNoProc.descripcion}"/>
			<c:if test="${accion.usuario==null}">
				<json:property name="gestor" value="${accion.gestor}"/>
			</c:if>
			<c:if test="${accion.usuario!=null}">
				<json:property name="gestor" value="${accion.usuario.apellidoNombre}"/>
			</c:if>	
			<json:property name="tipoResultado" value="${accion.tipoResultado.descripcion}"/>
			<json:property name="subtipoResultado" value="${accion.subTipoResultado.descripcion}"/>
			<json:property name="observaciones" value="${accion.observaciones}"/>
			<json:property name="codigoInterfaz" value="${accion.tipoAccionNoProc.codigoInterfaz}"/>
			<json:property name="idAccion" value="${accion.idAccion}"/>
			<%-- 
			<json:property name="tipoPersona" value="${accion.tipoPersona.descripcion}"/>
			--%>
		</json:object> 
	</json:array>
</fwk:json>