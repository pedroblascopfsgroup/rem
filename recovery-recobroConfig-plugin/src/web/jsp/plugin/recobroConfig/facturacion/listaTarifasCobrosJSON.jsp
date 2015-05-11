<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="tarifas" items="${tarifasCobro}" var="tarifas">
		<json:object>
			<json:property name="id" value="${tarifas.id}"/>
			<json:property name="idCobroFacturacion" value="${tarifas.cobroFacturacion.id}"/>
			<json:property name="concepto" value="${tarifas.tipoTarifa.descripcion}"/>
			<json:property name="minimo" value="${tarifas.minimo}"/>
			<json:property name="maximo" value="${tarifas.maximo}"/>
			<json:property name="porcentajeDefecto" value="${tarifas.porcentajePorDefecto}"/>
			<c:forEach items="${tarifas.tarifasCobrosTramos}" var="tramos">
				<json:property name="idTramo${tramos.tramoFacturacion.id}" value="${tramos.id}"/>
				<c:if test="${tramos.porcentaje == null}">
					<json:property name="tramo${tramos.tramoFacturacion.id}" value="0"/>
				</c:if>
				<c:if test="${tramos.porcentaje != null}">
					<json:property name="tramo${tramos.tramoFacturacion.id}" value="${tramos.porcentaje}"/>
				</c:if>
			</c:forEach>
			
		</json:object>		
	</json:array>
</fwk:json>	