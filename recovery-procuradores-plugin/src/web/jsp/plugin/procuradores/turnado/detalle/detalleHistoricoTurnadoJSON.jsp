<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	 <json:array name="detalleHistorico" items="${listaDetalle.results}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <c:if test="${d.asunto != null}">
	       		<json:property name="asunto" value="${d.asunto.nombre}"/>
	        </c:if>
            <c:if test="${d.tipoPlaza != null}">
	       		<json:property name="plaza" value="${d.tipoPlaza.descripcion}"/>
	        </c:if>
	       	<c:if test="${d.tipoProcedimiento != null}">
	       		<json:property name="actuacion" value="${d.tipoProcedimiento.descripcion}"/>
	        </c:if>
           	<json:property name="principalTurnado" value="${d.importe}"/>
            <json:property name="reglaAplicada" value="${d.mensaje}"/>
            <c:if test="${d.procuAsign != null}">
	       		<json:property name="procuAsign" value="${d.procuAsign.nombre}"/>
	        </c:if>
	        <c:if test="${d.procedimiento != null}">
	       		<json:property name="principalVigente" value="${d.procedimiento.saldoRecuperacion}"/>
	        </c:if>
            <json:property name="letrado" value="${d.auditoria.usuarioCrear}"/>
            <json:property name="fecha" >
				<fwk:date value="${d.auditoria.fechaCrear}"/>
			</json:property>
            <c:if test="${d.procuGaa != null}">
	       		<json:property name="procuGaa" value="${d.procuGaa.nombre}"/>
	        </c:if>
            
        </json:object>
    </json:array>
</fwk:json>