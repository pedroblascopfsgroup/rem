<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="antExt">
		<json:object>
			<json:property name="idAntExt" value="${externo.id}" />
			<json:property name="descripcion">
				<s:message code="menu.clientes.consultacliente.antecedentesTab.incidencias" text="**Incidencias Judiciales" />
			</json:property>
			<json:property name="numIncidenciasJudiciales" value="${externo.numIncidenciasJudiciales}" />
			<json:property name="fechaIncidenciaJudicial">
				<fwk:date value="${externo.fechaIncidenciaJudicial}" />
			</json:property>			
		</json:object>
		<json:object>
			<json:property name="idAntExt" value="${externo.id}" />
			<json:property name="descripcion">
				<s:message code="menu.clientes.consultacliente.antecedentesTab.impagos" text="**Impagos" />
			</json:property>
			<json:property name="numIncidenciasJudiciales" value="${externo.numImpagos}" />
			<json:property name="fechaIncidenciaJudicial">
				<fwk:date value="${externo.fechaImpagos}" />
			</json:property>			
		</json:object>
	</json:array>
</fwk:json>
