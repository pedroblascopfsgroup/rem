<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="embargosBien" items="${embargosBien}" var="eb">
		<json:object>
			<json:property name="idEmbargo" value="${eb.id}"/>
			<json:property name="idBien" value="${eb.bien.id}"/>
			<json:property name="idProcedimiento" value="${eb.procedimiento.id}"/>
			<json:property name="nbProcedimiento" value="${eb.procedimiento.nombreProcedimiento}"/>
			<json:property name="actuacion" value="${eb.procedimiento.tipoActuacion.descripcion}"/>
			<json:property name="numProcJuz" value="${eb.procedimiento.codigoProcedimientoEnJuzgado}"/>
			<json:property name="despacho" value="${eb.procedimiento.asunto.gestor.despachoExterno.despacho}"/>
			<json:property name="estadoActuacion" value="${eb.procedimiento.estadoProcedimiento.descripcion}"/>
			<json:property name="fechaSolicitud" >
				<fwk:date value="${eb.fechaSolicitud}"/>
			</json:property>
			<json:property name="fechaDecreto" >
				<fwk:date value="${eb.fechaDecreto}"/>
			</json:property>
			<json:property name="fechaRegistro" >
				<fwk:date value="${eb.fechaRegistro}"/>
			</json:property>
			<json:property name="fechaAdjudicacion" >
				<fwk:date value="${eb.fechaAdjudicacion}"/>
			</json:property>
			<json:property name="fechaDenegacion" >
				<fwk:date value="${eb.fechaDenegacion}"/>
			</json:property>
 		</json:object>
	</json:array>
</fwk:json>
