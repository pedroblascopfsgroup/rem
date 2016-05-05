<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="historicoLiquidaciones" items="${historicoLiquidaciones}" var="rec">
	<json:object>
		<json:property name="nombre" value="${rec.nombre}"/>
		<json:property name="contrato" value="${rec.contrato.nroContratoFormat}"/>
		<json:property name="fecha" >
			<fwk:date value="${rec.fechaLiquidacion}"/>
		</json:property>
		<json:property name="importe" value="${rec.totalCaculo}"/>
		
		
	</json:object>
	</json:array>
</fwk:json>