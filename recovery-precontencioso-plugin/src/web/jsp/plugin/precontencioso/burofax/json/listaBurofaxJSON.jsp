<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:json>
	<json:array name="listadoBurofax" items="${listadoBurofax}" var="burofax">
		<json:object>
			<json:property name="id" value="${burofax.id}"/>
			<json:property name="idCliente" value="${burofax.idCliente}"/>
			<json:property name="idDireccion" value="${burofax.idDireccion}"/>
			<json:property name="idTipoBurofax" value="${burofax.idTipoBurofax}"/>
			<json:property name="cliente" value="${burofax.cliente}"/>
			<json:property name="estado" value="${burofax.estado}"/>
			<json:property name="direccion" value="${burofax.direccion}"/>
			<json:property name="tipo" value="${burofax.tipo}"/>
			<json:property name="fechaSolicitud" value="${burofax.fechaSolicitud}"/>
			<json:property name="fechaEnvio" value="${burofax.fechaEnvio}"/>
			<json:property name="fechaAcuse" value="${burofax.fechaAcuse}"/>
			<json:property name="resultado" value="${burofax.resultado}"/>
		</json:object>
	</json:array>
</fwk:json>		