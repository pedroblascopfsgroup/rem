<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${accionesExjud.totalCount}" />
	<json:array name="accionesExjud" items="${accionesExjud.results}" var="accionExjud">
		<json:object>
			<json:property name="id" value="${accionExjud.accion.id}"/>
			<json:property name="fechaExtraccion">
				<fwk:date value="${accionExjud.accion.fechaExtraccion}"/>
			</json:property>
			<json:property name="idAccion" value="${accionExjud.accion.codigoAccion}"/>			
			<json:property name="idEnvio" value="${accionExjud.accion.idEnvio}"/>
			<json:property name="propietarios" value="${accionExjud.accion.propietarios.descripcion}"/>
			<json:property name="agencia" value="${accionExjud.agencia}" />
			<json:property name="apellidoNombre" value="${accionExjud.accion.persona.apellidoNombre}"/>
			<json:property name="codigoEntidadPersona" value="${accionExjud.accion.codigoEntidadPersona}"/>
			<json:property name="contrato" value="${accionExjud.accion.contrato.codigoContrato}"/>
			<json:property name="codigoContrato" value="${accionExjud.accion.codigoContrato}"/>
			<json:property name="fechaGestion">
				<fwk:date value="${accionExjud.accion.fechaGestion}"/>
			</json:property>
			<%-- --%>
			<json:property name="horaGestion" value="${accionExjud.accion.horaGestion}"/>
			<json:property name="tipoGestion" value="${accionExjud.accion.tipoGestion.descripcion}"/>
			<json:property name="telefono" value="${accionExjud.accion.telefono}"/>
			<json:property name="codigoDir" value="${accionExjud.accion.codigoDir}"/>
			<json:property name="observacionesGestor" value="${accionExjud.accion.observacionesGestor}"/>
			<json:property name="resultadoGestionTelefonica" value="${accionExjud.accion.resultadoGestionTelefonica.descripcion}"/>
			<json:property name="importeComprometido" value="${accionExjud.accion.importeComprometido}"/>
			<json:property name="fechaPagoComprometido">
				<fwk:date value="${accionExjud.accion.fechaPagoComprometido}"/>
			</json:property>
			<json:property name="importePropuesto" value="${accionExjud.accion.importePropuesto}"/>
			<json:property name="importeAceptado" value="${accionExjud.accion.importeAceptado}"/>
			<json:property name="datoNuevoOrigen" value="${accionExjud.accion.datoNuevoOrigen.descripcion}"/>
			<json:property name="bbddOrigenNuevoDato" value="${accionExjud.accion.bbddOrigenNuevoDato}"/>
			<json:property name="datoNuevoConfirmado" value="${accionExjud.accion.datoNuevoConfirmado.descripcion}"/>
			<json:property name="nuevoTelefono" value="${accionExjud.accion.nuevoTelefono}"/>
			<json:property name="nuevoDomicilio" value="${accionExjud.accion.nuevoDomicilio}"/>
			<json:property name="fechaExtra1">
				<fwk:date value="${accionExjud.accion.fechaExtra1}"/>
			</json:property>
			<json:property name="fechaExtra2">
				<fwk:date value="${accionExjud.accion.fechaExtra2}"/>
			</json:property>
			<json:property name="fechaExtra3">
				<fwk:date value="${accionExjud.accion.fechaExtra3}"/>
			</json:property>
			<json:property name="fechaExtra4">
				<fwk:date value="${accionExjud.accion.fechaExtra4}"/>
			</json:property>
			<json:property name="fechaExtra5">
				<fwk:date value="${accionExjud.accion.fechaExtra5}"/>
			</json:property>			
			<json:property name="numeroExtra1" value="${accionExjud.accion.numeroExtra1}"/>
			<json:property name="numeroExtra2" value="${accionExjud.accion.numeroExtra2}"/>
			<json:property name="numeroExtra3" value="${accionExjud.accion.numeroExtra3}"/>
			<json:property name="numeroExtra4" value="${accionExjud.accion.numeroExtra4}"/>
			<json:property name="numeroExtra5" value="${accionExjud.accion.numeroExtra5}"/>
			<json:property name="textoExtra1" value="${accionExjud.accion.textoExtra1}"/>
			<json:property name="textoExtra2" value="${accionExjud.accion.textoExtra2}"/>
			<json:property name="textoExtra3" value="${accionExjud.accion.textoExtra3}"/>
			<json:property name="textoExtra4" value="${accionExjud.accion.textoExtra4}"/>
			<json:property name="textoExtra5" value="${accionExjud.accion.textoExtra5}"/>
			<c:if test="${accionExjud.accion.resultadoMensajeria == null}">
				<json:property name="resultadoMensajeria" value="No" />
			</c:if>
			<c:if test="${accionExjud.accion.resultadoMensajeria != null}">
				<json:property name="resultadoMensajeria" value="Sí" />
			</c:if>
		</json:object>
	</json:array>
</fwk:json>