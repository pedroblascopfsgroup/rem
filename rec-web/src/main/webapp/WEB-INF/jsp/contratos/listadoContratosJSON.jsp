<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="contratos" items="${pagina.results}" var="cnt">
		<json:object>
			<json:property name="id" value="${cnt.id}"/>
			<json:property name="incluir" value="${false}" />
			<json:property name="codigoContrato" value="${cnt.codigoContrato}"/>
			<json:property name="tipoProducto" value="${cnt.tipoProducto.descripcion}"/>
			<json:property name="tipoProductoEntidad" value="(${cnt.tipoProductoEntidad.codigo}) ${cnt.tipoProductoEntidad.descripcion}"/>
			<c:if test="${cnt.lastMovimiento != null}">
				<json:property name="saldoVencido" value="${cnt.lastMovimiento.posVivaVencidaAbsoluta}" />
				<json:property name="diasIrregular" value="${cnt.diasIrregular}" />
				<json:property name="riesgo" value="${cnt.lastMovimiento.riesgo}" />
			</c:if>
			<json:property name="situacion2"  value="${cnt.primerTitular.situacion}" />
			<json:property name="situacion">
				<s:message code="situacion.normal" text="**Normal" />
			</json:property>
			<c:if test="${cnt.expedienteContratoActivo != null && cnt.expedienteContratoActivo.sinActuacion == null && !cnt.expedienteContratoActivo.auditoria.borrado}">
				<json:property name="situacion">
					<s:message code="situacion.expedimentado" text="**Expedientado" />
				</json:property>
			</c:if>
			<c:if test="${cnt.expedienteContratoActivo != null  && !cnt.expedienteContratoActivo.sinActuacion && !cnt.expedienteContratoActivo.auditoria.borrado && cnt.expedienteContratoActivo.cantidadProcedimientos > 0}">
				<json:property name="situacion">
					<s:message code="situacion.enAsunto" text="**En Asunto" />
				</json:property>
			</c:if>
			<json:property name="fechaDato">
				<fwk:date value="${cnt.fechaDato}"/>
			</json:property>
			<json:property name="estadoContrato" value="${cnt.estadoContrato.descripcion}"/>
			<json:property name="titular" value="${cnt.primerTitular.apellidoNombre}"/>
			<json:property name="cuotaImporte" value="${cnt.cuotaImporte}"/>
			<json:property name="dispuesto" value="${cnt.dispuesto}"/>
			<json:property name="limiteInicial" value="${cnt.limiteInicial}"/>
			<json:property name="limiteFinal" value="${cnt.limiteFinal}"/>
			<json:property name="condEspeciales" value="${cnt.condicionesEspeciales}"/>
			<json:property name="estadoFinanciero" value="${cnt.estadoFinanciero.descripcion}"/>
			<json:property name="segmentoCartera" value="${cnt.segmentoCartera}"/>			
		</json:object>
	</json:array>
</fwk:json>	 		 