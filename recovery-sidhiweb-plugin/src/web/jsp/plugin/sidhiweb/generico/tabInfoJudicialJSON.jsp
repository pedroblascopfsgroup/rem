<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  


<fwk:json>
 	<json:property name="total" value="${acciones.totalCount}" />
	<json:array name="acciones" items="${acciones.results}" var="accion">
		<json:object>
			<json:property name="idAccion" value="${accion.idAccion}"/> 
			<json:property name="idExpedienteExterno" value="${accion.iter.idExpedienteExterno}"/> 
			<json:property name="usernameProcurador" value="${accion.iter.procedimiento.asunto.procurador.usuario.apellidoNombre}"/>
			
			<json:property name="plaza" value="${accion.iter.procedimiento.juzgado.plaza.descripcion}"/>
			<json:property name="juzgado" value="${accion.iter.procedimiento.juzgado.descripcion}"/>
			<json:property name="numeroAutos" value="${accion.iter.procedimiento.codigoProcedimientoEnJuzgado}"/>
			<json:property name="principal" value="${accion.iter.procedimiento.saldoOriginalVencido}"/>
			<json:property name="fechaAccion" >
					<fwk:date value="${accion.fechaAccion}"/>	
			</json:property>
			<json:property name="codigo" value="${accion.estadoProcesal.codigo}"/>
			<json:property name="estadoProcesal" value="${accion.estadoProcesal.descripcion}"/>
			<json:property name="subEstadoProcesal" value="${accion.subestadoProcesal.descripcion}"/>
			<json:property name="tipoValor" value="${accion.valores[0].tipo.descripcion}"/>
			<json:property name="valor" value="${accion.valores[0].valor}"/>
		</json:object> 
		<c:forEach items="${accion.valores}" var="valor">
			<c:if test="${valor.id!=accion.valores[0].id}">
				<json:object>
					<json:property name="tipoValor" value="${valor.tipo.descripcion}"/>
					<json:property name="valor" value="${valor.valor}" />
					<json:property name="principal" value="---"/>
				</json:object>
			</c:if>
		</c:forEach> 
	</json:array>
</fwk:json>