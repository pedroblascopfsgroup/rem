<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>


<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="contratos" items="${pagina.results}" var="cnt">
		<json:object>
			<json:property name="id" value="${cnt.id}"/>
			<json:property name="bloquear" value="${false}" />
			<json:property name="codigoContrato" value="${cnt.codigoContrato}"/>
			<json:property name="tipoProducto" value="${cnt.tipoProducto.descripcion}"/>
			<json:property name="saldoVencido" value="${cnt.lastMovimiento.posVivaVencidaAbsoluta}"/>
			<json:property name="diasIrregular" value="${cnt.diasIrregular}"/>
			<json:property name="riesgo" value="${cnt.lastMovimiento.riesgo}"/>
			<json:property name="estadoContrato" value="${cnt.estadoContrato.descripcion}"/>
			<json:property name="titular" value="${cnt.primerTitular.apellidoNombre}"/>
			<json:property name="estadoFinanciero" value="${cnt.estadoFinanciero.descripcion}"/>
		</json:object>
	</json:array>
</fwk:json>	 		