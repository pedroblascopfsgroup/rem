<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${efectos.totalCount}" />
	<json:array name="efectos" items="${efectos.results}" var="efecto">
		<json:object>
			<json:property name="id" value="${efecto.id}"/>
			<json:property name="idContrato" value="${efecto.contrato.id}"/>
			<json:property name="codigoEntidad" value="${efecto.codigoEntidad}"/>
			<json:property name="codigoEfecto" value="${efecto.codigoEfecto}"/>
			<json:property name="codigoLinea" value="${efecto.codigoLinea}"/>	
			<json:property name="codigoAcuerdo" value="${efecto.codigoAcuerdo}"/>	
			<json:property name="DDtipoEfecto" value="${efecto.tipoEfecto.descripcion}"/>
			<json:property name="DDsituacionEfecto" value="${efecto.situacionEfecto.descripcion}"/>
			<json:property name="DDmoneda" value="${efecto.moneda.descripcion}"/>
			<json:property name="importe" value="${efecto.importe}"/>
			<json:property name="capital" value="${efecto.capital}"/>
			<json:property name="interesesOrdinarios" value="${efecto.interesesOrdinarios}"/>
			<json:property name="interesesMoratorios" value="${efecto.interesesMoratorios}"/>
			<json:property name="comisiones" value="${efecto.comisiones}"/>
			<json:property name="gastos" value="${efecto.gastos}"/>
			<json:property name="impuestos" value="${efecto.impuestos}"/>
			<json:property name="fechaDescuento">
				<fwk:date value="${efecto.fechaDescuento}"/>
			</json:property>
			<json:property name="DDtipoFechaVencimiento" value="${efecto.tipoFechaVencimiento.descripcion}"/>
			<json:property name="fechaVencimiento">
				<fwk:date value="${efecto.fechaVencimiento}"/>
			</json:property>
			<json:property name="fechaExtraccion">
				<fwk:date value="${efecto.fechaExtraccion}"/>
			</json:property>
			<json:property name="fechaDato">
				<fwk:date value="${efecto.fechaDato}"/>
			</json:property>
			<json:property name="charExtra1" value="${efecto.charExtra1}"/>
			<json:property name="charExtra2" value="${efecto.charExtra2}"/>
			<json:property name="flagExtra1" value="${efecto.flagExtra1}"/>
			<json:property name="flagExtra2" value="${efecto.flagExtra2}"/>
			<json:property name="dateExtra1" value="${efecto.dateExtra1}"/>
			<json:property name="dateExtra2" value="${efecto.dateExtra2}"/>
			<json:property name="numExtra1" value="${efecto.numExtra1}"/>
			<json:property name="numExtra2" value="${efecto.numExtra2}"/>	
			<c:if test="${efecto.efectosPersona[0].persona != null}">
				<json:property name="titulares" value="${efecto.efectosPersona[0].persona.apellidoNombre}" />
			</c:if>
			<c:if test="${efecto.efectosPersona[0].persona == null}">
				<json:property name="titulares" value="${efecto.efectosPersona[0].apellido1} ${efecto.efectosPersona[0].apellido2}, ${efecto.efectosPersona[0].nombre}" />
			</c:if>					
			<json:property name="orden" value="${efecto.efectosPersona[0].orden}" />
			<json:property name="tipoIntervencionEfecto" value="${efecto.efectosPersona[0].tipoIntervencionEfecto.descripcion}"/>
		</json:object>
		<c:forEach items="${efecto.efectosPersona}" var="ep">
			<c:if test="${ep.id!=efecto.efectosPersona[0].id}">
				<json:object>
					<c:if test="${ep.persona != null}">
						<json:property name="titulares" value="${ep.persona.apellidoNombre}" />
					</c:if>
					<c:if test="${ep.persona == null}">
						<json:property name="titulares" value="${ep.apellido1} ${ep.apellido2}, ${ep.nombre}" />
					</c:if>					
					<json:property name="orden" value="${ep.orden}" />
					<json:property name="tipoIntervencionEfecto" value="${ep.tipoIntervencionEfecto.descripcion}"/>
					<json:property name="importe" value="---"/>
					<json:property name="capital" value="---"/>
					<json:property name="interesesOrdinarios" value="---"/>
					<json:property name="interesesMoratorios" value="---"/>
					<json:property name="comisiones" value="---"/>
					<json:property name="gastos" value="---"/>
					<json:property name="impuestos" value="---"/>
				</json:object>
			</c:if>
		</c:forEach>
	</json:array>
</fwk:json>