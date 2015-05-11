<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="contrato" items="${listado}" var="anc">
		<json:object>
			<json:property name="id" value="${anc.id}"/>
			<json:property name="asuId" value="${anc.asunto.id}"/>
			<json:property name="contratoId" value="${anc.contrato.id}"/>
			<json:property name="contrato" value="${anc.contrato.codigoContrato}"/>
			<json:property name="tipoContrato" value="${anc.contrato.tipoProducto.descripcion}"/>
			<json:property name="ejecucionIniciada" value="${anc.ejecucionIniciada}"/>
			<json:property name="revisadoA" value="${anc.revisadoA}"/>
			<json:property name="propuestaEjecucion" value="${anc.propuestaEjecucion}"/>
			<json:property name="iniciarEjecucion" value="${anc.iniciarEjecucion}"/>
			<json:property name="revisadoB" value="${anc.revisadoB}"/>
			<json:property name="solicitarSolvencia" value="${anc.solicitarSolvencia}"/>
			<json:property name="fechaSolicitarSolvencia">
				<fwk:date value="${anc.fechaSolicitarSolvencia}"/>
			</json:property>
			<json:property name="fechaRecepcion">
				<fwk:date value="${anc.fechaRecepcion}"/>
			</json:property>
			<json:property name="resultado" value="${anc.resultado}"/>
			<json:property name="decisionB" value="${anc.decisionB}"/>
			<json:property name="revisadoC" value="${anc.revisadoC}"/>
			<json:property name="decisionC" value="${anc.decisionC}"/>
			<json:property name="fechaProximaRevision">
				<fwk:date value="${anc.fechaProximaRevision}"/>
			</json:property>
			<json:property name="decisionRevision" value="${anc.decisionRevision}"/>
 		</json:object>
	</json:array>
</fwk:json>
