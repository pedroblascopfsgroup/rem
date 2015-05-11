<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${ciclosRecCnt.totalCount}" />
	<json:array name="ciclosRecCnt" items="${ciclosRecCnt.results}" var="cicloRecCnt">
		<json:object>
			<json:property name="id" value="${cicloRecCnt.id}"/>
			<json:property name="idEnvio" value="${cicloRecCnt.idEnvio}"/>
			<json:property name="idContrato" value="${cicloRecCnt.contrato.id}"/>
			<json:property name="codContrato" value="${cicloRecCnt.contrato.codigoContrato}"/>
			<json:property name="idCicloRecobroExpediente" value="${cicloRecCnt.cicloRecobroExpediente.id}"/>			
			<json:property name="motivoBaja" value="${cicloRecCnt.motivoBaja.descripcion}"/>
			<json:property name="exceptuacion" value="${cicloRecCnt.exceptuacion.motivo}"/>
			<json:property name="fechaAlta">
				<fwk:date value="${cicloRecCnt.fechaAlta}"/>
			</json:property>
			<json:property name="fechaBaja">
				<fwk:date value="${cicloRecCnt.fechaBaja}"/>
			</json:property>
			<json:property name="posVivaNoVencida" value="${cicloRecCnt.posVivaNoVencida}"/>
			<json:property name="posVivaVencida" value="${cicloRecCnt.posVivaVencida}"/>	
			<json:property name="interesesOrdDeven" value="${cicloRecCnt.interesesOrdDeven}"/>
			<json:property name="interesesMorDeven" value="${cicloRecCnt.interesesMorDeven}"/>
			<json:property name="comisiones" value="${cicloRecCnt.comisiones}"/>
			<json:property name="gastos" value="${cicloRecCnt.gastos}"/>
			<json:property name="impuestos" value="${cicloRecCnt.impuestos}"/>
		</json:object>
	</json:array>
</fwk:json>