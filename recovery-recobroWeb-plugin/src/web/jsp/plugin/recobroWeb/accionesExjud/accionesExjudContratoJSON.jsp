<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${accionesExjud.totalCount}" />
	<json:array name="accionesExjud" items="${accionesExjud.results}" var="accionExjud">
		<json:object>
			<json:property name="id" value="${accionExjud.id}"/>
			<json:property name="fechaExtraccion">
				<fwk:date value="${accionExjud.fechaExtraccion}"/>
			</json:property>
			<json:property name="idAccion" value="${accionExjud.codigoAccion}"/>			
			<json:property name="idEnvio" value="${accionExjud.idEnvio}"/>
			<json:property name="propietarios" value="${accionExjud.propietarios.descripcion}"/>	
			<json:property name="agencia" value="${accionExjud.agencia.nombre}"/>
			<json:property name="apellidoNombre" value="${accionExjud.persona.apellidoNombre}"/>
			<json:property name="codigoEntidadPersona" value="${accionExjud.codigoEntidadPersona}"/>
			<json:property name="contrato" value="${accionExjud.contrato.codigoContrato}"/>
			<json:property name="codigoContrato" value="${accionExjud.codigoContrato}"/>
			<json:property name="fechaGestion">
				<fwk:date value="${accionExjud.fechaGestion}"/>
			</json:property>
			<json:property name="horaGestion" value="${accionExjud.horaGestion}"/>
			<json:property name="tipoGestion" value="${accionExjud.tipoGestion.descripcion}"/>
			<json:property name="telefono" value="${accionExjud.telefono}"/>
			<json:property name="codigoDir" value="${accionExjud.codigoDir}"/>
			<json:property name="observacionesGestor" value="${accionExjud.observacionesGestor}"/>
			<json:property name="resultadoGestionTelefonica" value="${accionExjud.resultadoGestionTelefonica.descripcion}"/>
			<json:property name="importeComprometido" value="${accionExjud.importeComprometido}"/>
			<json:property name="fechaPagoComprometido">
				<fwk:date value="${accionExjud.fechaPagoComprometido}"/>
			</json:property>
			<json:property name="importePropuesto" value="${accionExjud.importePropuesto}"/>
			<json:property name="importeAceptado" value="${accionExjud.importeAceptado}"/>
			<json:property name="datoNuevoOrigen" value="${accionExjud.datoNuevoOrigen.descripcion}"/>
			<json:property name="bbddOrigenNuevoDato" value="${accionExjud.bbddOrigenNuevoDato}"/>
			<json:property name="datoNuevoConfirmado" value="${accionExjud.datoNuevoConfirmado.descripcion}"/>
			<json:property name="nuevoTelefono" value="${accionExjud.nuevoTelefono}"/>
			<json:property name="nuevoDomicilio" value="${accionExjud.nuevoDomicilio}"/>
			<json:property name="fechaExtra1">
				<fwk:date value="${accionExjud.fechaExtra1}"/>
			</json:property>
			<json:property name="fechaExtra2">
				<fwk:date value="${accionExjud.fechaExtra2}"/>
			</json:property>
			<json:property name="fechaExtra3">
				<fwk:date value="${accionExjud.fechaExtra3}"/>
			</json:property>
			<json:property name="fechaExtra4">
				<fwk:date value="${accionExjud.fechaExtra4}"/>
			</json:property>
			<json:property name="fechaExtra5">
				<fwk:date value="${accionExjud.fechaExtra5}"/>
			</json:property>			
			<json:property name="numeroExtra1" value="${accionExjud.numeroExtra1}"/>
			<json:property name="numeroExtra2" value="${accionExjud.numeroExtra2}"/>
			<json:property name="numeroExtra3" value="${accionExjud.numeroExtra3}"/>
			<json:property name="numeroExtra4" value="${accionExjud.numeroExtra4}"/>
			<json:property name="numeroExtra5" value="${accionExjud.numeroExtra5}"/>
			<json:property name="textoExtra1" value="${accionExjud.textoExtra1}"/>
			<json:property name="textoExtra2" value="${accionExjud.textoExtra2}"/>
			<json:property name="textoExtra3" value="${accionExjud.textoExtra3}"/>
			<json:property name="textoExtra4" value="${accionExjud.textoExtra4}"/>
			<json:property name="textoExtra5" value="${accionExjud.textoExtra5}"/>
		</json:object>
	</json:array>
</fwk:json>