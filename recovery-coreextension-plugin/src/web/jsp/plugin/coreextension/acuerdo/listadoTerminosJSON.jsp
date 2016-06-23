<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="terminos" items="${pagina.results}" var="acuTer">
	<%--acuTer[0] --> acuerdo --%>
	<%--acuTer[1] --> término --%>
		<json:object>
			<json:property name="idAcuerdo" value="${acuTer[0].id}"/>
			<json:property name="idTermino" value="${acuTer[1].id}"/>	
			<json:property name="idAsunto" value="${acuTer[0].asunto.id}"/>
			<json:property name="nombreAsunto" value="${acuTer[0].asunto.nombre}"/>
			<json:property name="idExpediente" value="${acuTer[0].expediente.id}"/>
			<json:property name="descripcionExpediente" value="${acuTer[0].expediente.descripcion}"/>
			<json:property name="tipoExpediente" value="${acuTer[0].expediente.tipoExpediente.codigo}"/>
			<json:property name="idContrato" value="${acuTer[1].contratosTermino[0].contrato.codigoContrato}"/>
			<c:if test="${acuTer[0].asunto.id!=null}">               
            	<json:property name="cliente" value="${acuTer[0].asunto.expediente.contratoPase.contratoPersona[0].persona.nom50}" />                              
            </c:if>
            <c:if test="${acuTer[0].expediente.id!=null}">           
            	<json:property name="cliente" value="${acuTer[0].expediente.contratoPase.contratoPersona[0].persona.nom50}" />                              
            </c:if>
            <c:if test="${acuTer[1]!=null}">
            <json:property name="tipoAcuerdo" value="${acuTer[1].tipoAcuerdo.descripcion}"/>
            </c:if>
            <c:if test="${acuTer[1]==null}">
            <json:property name="tipoAcuerdo" value="${acuTer[0].tipoAcuerdo.descripcion}"/>
            </c:if>
            <json:property name="solicitante" value="${acuTer[0].gestorDespacho.despachoExterno.descripcion}"/>
			<json:property name="tipoSolicitante" value="${acuTer[0].gestorDespacho.despachoExterno.tipoDespacho.descripcion}"/>
			<json:property name="estado" value="${acuTer[0].estadoAcuerdo.descripcion}"/>
			<json:property name="fechaAlta"> <fwk:date value="${acuTer[0].fechaPropuesta}"/></json:property>
			<json:property name="fechaEstado"> <fwk:date value="${acuTer[0].fechaEstado}"/></json:property>
			<json:property name="fechaVigencia"> <fwk:date value="${acuTer[0].fechaLimite}"/></json:property>
		</json:object>
	</json:array>
</fwk:json>		