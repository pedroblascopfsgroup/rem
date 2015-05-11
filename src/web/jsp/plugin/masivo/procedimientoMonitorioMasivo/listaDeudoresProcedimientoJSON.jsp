<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

	<fwk:json>
       <json:array name="demandados" items="${demandados}" var="demandado">
               <json:object>
                       <json:property name="idCliente" value="${demandado.id}" />
                       <json:property name="nombre" value="${demandado.apellidoNombre}" />
                       <json:property name="ultimaFechaReqPago" value="" />
                       <json:property name="direccionReqPago" value="" />
                       <json:property name="fechaReqPago" value="" />
               </json:object>
       </json:array>
</fwk:json>