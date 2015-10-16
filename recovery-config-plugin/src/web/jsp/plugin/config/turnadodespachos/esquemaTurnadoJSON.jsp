<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"
	import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig"
%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="id" value="${data.id}" />
	<json:property name="descripcion" value="${data.descripcion}" />
	<json:property name="estado">
		<json:object>
			<json:property name="id" value="${data.estado.id}" />
			<json:property name="codigo" value="${data.estado.codigo}" />
			<json:property name="descripcion" value="${data.estado.descripcion}" />
		</json:object>
	</json:property>
	<json:property name="limiteStockAnualConcursos" value="${data.limiteStockAnualConcursos}" />
	<json:property name="limiteStockAnualLitigios" value="${data.limiteStockAnualLitigios}" />
	<json:property name="fechaInicioVigencia" value="${data.fechaInicioVigencia}" />
	<json:property name="fechaFinVigencia" value="${data.fechaFinVigencia}" />
	<json:property name="configuracionLI">
		<json:array name="usuarios" items="${data.configuracion}" var="config">
			<c:if test="${config.tipo==EsquemaTurnadoConfig.TIPO_LITIGIOS_IMPORTE}">
				<json:object>
					<json:property name="id" value="${config.id}" />
					<json:property name="codigo" value="${config.codigo}" />
					<json:property name="importeDesde" value="${config.importeDesde}" />
					<json:property name="importeHasta" value="${config.importeHasta}" />
					<json:property name="porcentaje" value="${config.porcentaje}" />
				</json:object>
			</c:if>
		</json:array>
	</json:property>
	<json:property name="configuracionLC">
		<json:array name="usuarios" items="${data.configuracion}" var="config">
			<c:if test="${config.tipo==EsquemaTurnadoConfig.TIPO_LITIGIOS_CALIDAD}">
				<json:object>
					<json:property name="id" value="${config.id}" />
					<json:property name="codigo" value="${config.codigo}" />
					<json:property name="importeDesde" value="${config.importeDesde}" />
					<json:property name="importeHasta" value="${config.importeHasta}" />
					<json:property name="porcentaje" value="${config.porcentaje}" />
				</json:object>
			</c:if>
		</json:array>
	</json:property>
</fwk:json>