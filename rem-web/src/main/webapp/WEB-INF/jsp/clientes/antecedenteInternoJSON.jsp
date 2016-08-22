<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="antecedentes" items="${persona.contratosPersonaConIncidenciaInterna}" var="cpe">
			 <json:object>
			   <json:property name="descripcion" value="${cpe.contrato.descripcionProductoCodificada}" />
			   <json:property name="posMax" value="${cpe.contrato.antecendenteInterno.posIrregularMax}" />
			   <json:property name="diasMax" value="${cpe.contrato.antecendenteInterno.diasIrregularMax}" />
			   <json:property name="fechaRegularizacion" value="${cpe.contrato.antecendenteInterno.fechaUltimaRegularizacionFormateada}" />
			 </json:object>
	</json:array>
</fwk:json>
