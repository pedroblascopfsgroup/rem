<%@page pageEncoding="iso-8859-1" contentType="application/json; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="clientes" items="${pagina.results}" var="dto">
		<json:object>
			<json:property name="id" value="${dto.id}" />
			<json:property name="tipo" value="${dto.descripcion}" />
			<json:property name="nombre" value="${dto.nombre}" />
			<json:property name="apellidos" value="${dto.apellido1} ${dto.apellido2}" />
			<json:property name="apellido1" value="${dto.apellido1}" />
			<json:property name="apellido2" value="${dto.apellido2}" />
			<json:property name="codClienteEntidad" value="${dto.codClienteEntidad}" />
			<json:property name="docId" value="${dto.docId}" />
			<json:property name="telefono1" value="${dto.telefono1}" />
			<json:property name="direccion" value="${dto.domicilio} ${dto.localidad}" />

			<json:property name="segmento" value="${dto.descripcionSegmento}" />
			<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
				<json:property name="segmento" value="${dto.descripcionSegmentoEntidad}" />
			</sec:authorize>

			<json:property name="situacion" value="${dto.situacion}" />
			<json:property name="numContratos" value="${dto.numContratos}" />
			<json:property name="deudaIrregular" value="${dto.deudaIrregular}"/>
			<json:property name="totalSaldo" value="${dto.riesgoTotal}"/>
			<json:property name="diasVencido" value="${dto.diasVencidos}" />
			<json:property name="apellidoNombre" value="${dto.apellidoNombre}"/>
			<json:property name="arquetipo" value="${dto.nombreArquetipo}"/>
  			<json:property name="itinerario" value="${dto.tipoItinerario}"/>                          
                
           	<c:if test="${!dto.bajoUmbral}">
				<json:property name="diasCambioEstado" value="${dto.diasParaCambioEstado}"/>
			</c:if>
			<c:if test="${dto.bajoUmbral}">
				<json:property name="diasCambioEstado">
               		<s:message code="clientes.listado.pendienteDeUmbral" text="**Pendiente de Umbral" />
				</json:property>
			</c:if>

			<json:property name="ofiCntPase" value="${dto.codigoOficina} ${dto.nombreOficina}"/>
			<json:property name="deudaDirecta" value="${dto.riesgoTotalDirecto}"/>
            <json:property name="riesgoDirectoNoVencidoDanyado" value="${dto.riesgoDirectoDanyado}"/>
			<json:property name="relacionExpediente" value="${dto.relacionExpediente}"/>
			<json:property name="situacionFinanciera" value="${dto.descripcionEstadoFinanciero}"/>

			<json:property name="fechaDato" >
            	<fwk:date value="${dto.fechaDato}"/>
            </json:property>

			<json:property name="riesgoAutorizado" value="${dto.riesgoAutorizado}"/>
			<json:property name="dispuestoNoVencido" value="${dto.dispuestoNoVencido}"/>
			<json:property name="dispuestoVencido" value="${dto.dispuestoVencido}"/>
			<json:property name="riesgoDispuesto" value="${dto.riesgoDispuesto}"/>                			            

		</json:object>
	</json:array>
</fwk:json>