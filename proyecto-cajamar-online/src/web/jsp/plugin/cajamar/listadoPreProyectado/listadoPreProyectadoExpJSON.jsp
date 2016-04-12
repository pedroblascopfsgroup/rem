<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<fwk:json>
	<json:property name="total" value="${listadoPreProyectadoExp.totalCount}" />
	<json:array name="expedientes" items="${listadoPreProyectadoExp.results}" var="exp">
		<json:object>			 
			<json:property name="expId" value="${exp.expId}" />
			<json:property name="titular" value="${exp.titular}" />
			<json:property name="nifTitular" value="${exp.nifTitular}" />
			<json:property name="telf1" value="${exp.telf1}" />
			<json:property name="fase" value="${exp.fase}" />
			<json:property name="fechaVtoTarea">
				<fwk:date value="${exp.fechaVtoTarea}"/>
			</json:property>
			<json:property name="numContratos" value="${exp.numContratos}" />
			<json:property name="volRiesgoExp" value="${exp.volRiesgoExp}" />
			<json:property name="importeInicialExp" value="${exp.importeInicialExp}" />
			<json:property name="regularizadoExp" value="${exp.regularizadoExp}" />
			<json:property name="importeActual" value="${exp.importeActual}" />
			<json:property name="importePteDifer" value="${exp.importePteDifer}" />
			<json:property name="tramoExp" value="${exp.tramoExp}" />
			<json:property name="diasVencidosExp" value="${exp.diasVencidosExp}" />
			<json:property name="fechaPaseAMoraExp" >
				<fwk:date value="${exp.fechaPaseAMoraExp}"/>
			</json:property>
			<json:property name="propuesta" value="${exp.propuesta}" />
			<json:property name="fechaPrevReguExp" >
				<fwk:date value="${exp.fechaPrevReguExp}"/>
			</json:property>
			<json:property name="expDescripcion" value="${exp.expDescripcion}" />
			<json:array name="contratos" items="${exp.contratos}" var="cnt">
				<json:object>			 
					<json:property name="cntId" value="${cnt.cntId}" />
					<json:property name="contrato" value="${cnt.contrato}" />
					<json:property name="expId" value="${cnt.expId}" />
					<json:property name="riesgoTotal" value="${cnt.riesgoTotal}"/>
					<json:property name="deudaIrregular" value="${cnt.deudaIrregular}"/>
					<json:property name="tramo" value="${cnt.tramo}" />
					<json:property name="diasVencidos" value="${cnt.diasVencidos}" />
					<json:property name="fechaPaseAMoraCnt" >
						<fwk:date value="${cnt.fechaPaseAMoraCnt}"/>
					</json:property>
					<json:property name="propuesta" value="${cnt.propuesta}" />
					<json:property name="estadoGestion" value="${cnt.estadoGestion}" />
					<json:property name="fechaPrevReguCnt" >
						<fwk:date value="${cnt.fechaPrevReguCnt}"/>
					</json:property>
					<json:property name="importePteDifer" value="${cnt.importePteDifer}" />
				</json:object>
			</json:array>			
		</json:object>
	</json:array>
</fwk:json>