<%@page pageEncoding="iso-8859-1" contentType="application/json; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="personas" items="${pagina.results}" var="p">
		<json:object>
			<json:property name="id" value="${p.id}" />
			<json:property name="tipo" value="${p.tipoPersona.descripcion}" />
			<json:property name="nombre" value="${p.nombre}" />
			<json:property name="apellido1" value="${p.apellido1}" />
			<json:property name="apellido2" value="${p.apellido2}" />
			<json:property name="codClienteEntidad" value="${p.codClienteEntidad}" />
			<json:property name="docId" value="${p.docId}" />
			<json:property name="telefono1" value="${p.telefono1}" />
			<json:property name="direccion" value="${p.direcciones[0].domicilio} ${p.direcciones[0].localidad.descripcion}" />
			<json:property name="segmento" value="${p.segmento.descripcion}" />
			<json:property name="situacion" value="${p.situacion}" />
			<json:property name="numContratos" value="${p.numContratos}" />
			<json:property name="deudaIrregular" value="${p.deudaIrregular}"/>
			<json:property name="totalSaldo" value="${p.riesgoTotal}"/>
			<json:property name="diasVencido" value="${p.diasVencido}" />
			<json:property name="apellidoNombre" value="${p.apellidoNombre}"/>
            <c:if test="${p.clienteActivo != null}"> 
            	<json:property name="arquetipo" value="${p.clienteActivo.arquetipo.nombre}"/>
  				<json:property name="itinerario" value="${p.clienteActivo.tipoItinerario}"/>                          
                <c:if test="${!p.clienteActivo.bajoUmbral}">
                	<json:property name="diasCambioEstado" value="${p.clienteActivo.diasParaCambioEstado}"/>
                </c:if>
                <c:if test="${p.clienteActivo.bajoUmbral}">
                	<json:property name="diasCambioEstado">
                		<s:message code="clientes.listado.pendienteDeUmbral" text="**Pendiente de Umbral" />
                	</json:property>
                </c:if>
            </c:if>            
            <json:property name="ofiCntPase" value="${p.oficinaCliente.codigo} ${p.oficinaCliente.nombre}"/>
            <json:property name="deudaDirecta" value="${p.riesgoDirecto}"/>
            <json:property name="riesgoDirectoNoVencidoDanyado" value="${p.riesgoDirectoNoVencidoDanyado}"/>
            <json:property name="relacionExpediente" value="${p.relacionExpediente}"/>
            <json:property name="situacionFinanciera" value="${p.situacionFinanciera.descripcion}"/>
		</json:object>
	</json:array>
</fwk:json>
