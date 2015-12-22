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
			<json:property name="idBurofax" value="${burofax.idBurofax}"/>
			<json:property name="idEnvio" value="${burofax.idEnvio}"/>
			<json:property name="idCliente" value="${burofax.idCliente}"/>
			<json:property name="idDireccion" value="${burofax.idDireccion}"/>
			<json:property name="idTipoBurofax" value="${burofax.idTipoBurofax}"/>
			<json:property name="cliente" value="${burofax.cliente}"/>
			<json:property name="contrato" value="${burofax.contrato}"/>
			<json:property name="estado" value="${burofax.estado}"/>
			<json:property name="direccion" value="${burofax.direccion}"/>
			<json:property name="tipo" value="${burofax.tipo}"/>
			<json:property name="tipoDescripcion" value="${burofax.tipoDescripcion}"/>
			<json:property name="tipoIntervencion" value="${burofax.tipoIntervencion}"/>
			<json:property name="fechaSolicitud" >
				<fwk:date value="${burofax.fechaSolicitud}" />
			</json:property>	
			<json:property name="fechaEnvio">
				<fwk:date  value="${burofax.fechaEnvio}" />
			</json:property>	
			<json:property name="fechaAcuse" >
				<fwk:date  value="${burofax.fechaAcuse}" />
			</json:property>	
			<json:property name="resultado" value="${burofax.resultado}"/>
			<json:property name="acuseRecibo" value="${burofax.acuseRecibo}"/>
			<json:property name="esPersonaManual" value="${burofax.esPersonaManual}"/>
		</json:object>
	</json:array>
</fwk:json>		