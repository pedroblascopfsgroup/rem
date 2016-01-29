<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="contratos"
		items="${procedimiento.expedienteContratos}" var="ec">
		<json:object>
			<json:property name="id" value="${ec.contrato.id}" />
			<json:property name="codigo" value="${ec.contrato.codigoContrato}" />
		</json:object>
	</json:array>
</fwk:json>