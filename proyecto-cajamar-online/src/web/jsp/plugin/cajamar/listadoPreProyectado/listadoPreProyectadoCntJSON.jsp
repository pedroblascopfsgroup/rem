<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<fwk:json>
	<json:property name="total" value="${totalCount}" />
	<json:array name="contratos" items="${listadoPreProyectadoCnt}" var="cnt">
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
</fwk:json>