<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="entregas" items="${entregas}" var="rec">
	<json:object>
	
		<json:property name="fechaEntrega" >
			<fwk:date value="${rec.fechaEntrega}"/>
		</json:property>
		<json:property name="fechaValor" >
			<fwk:date value="${rec.fechaValor}"/>
		</json:property>
		<json:property name="tipoEntrega" value="${rec.tipoEntrega.descripcion}"/>
		<json:property name="conceptoEntrega" value="${rec.conceptoEntrega.descripcion}"/>
		<json:property name="totalEntrega" value="${rec.totalEntrega}"/>
		<json:property name="gastosProcurador" value="${rec.gastosProcurador}"/>
		<json:property name="gastosLetrado" value="${rec.gastosLetrado}"/>
		<json:property name="idEntrega" value="${rec.id}"/>
		
		
	</json:object>
	</json:array>
</fwk:json>