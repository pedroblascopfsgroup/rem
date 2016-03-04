<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
    <json:array name="politicas" items="${politicas}" var="p">
        <json:object>
            <json:property name="id" value="${p.id}" />
            <json:property name="fecha"><fwk:date value="${p.auditoria.fechaCrear}"/></json:property>
            <json:property name="estado" value="${p.estadoItinerarioPolitica.codigo}" />
            <json:property name="idEstadoItinerario" value="${p.estadoItinerarioPolitica.id}" />
            <c:if test="${p.usuarioCreacion!=null}">
	            <json:property name="usuario" value="${p.usuarioCreacion.apellidoNombre}" />
            </c:if>
            <c:if test="${p.usuarioCreacion==null}">
	            <json:property name="usuario" value="Sistema" />
            </c:if>
            <json:property name="gestor" value="${p.perfilGestor.descripcion}" />
            <json:property name="supervisor" value="${p.perfilSupervisor.descripcion}" />
            <json:property name="politica" value="${p.tipoPolitica.descripcion}" />
            <json:property name="propuesta" value="${p.esPropuesta}" />
            <json:property name="vigente" value="${p.esVigente}" />
        </json:object>
    </json:array>
</fwk:json>  