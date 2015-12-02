<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>	
	<json:array name="contratosBien" items="${contratosBienes}" var="cb">
		<json:object>
			<json:property name="idContratoBien" value="${cb.id}"/>
			<json:property name="idBien" value="${cb.bien.id}"/>
			<json:property name="idContrato" value="${cb.contrato.id}"/>
			<json:property name="importeGarantizado" value="${cb.importeGarantizado}"/>
			<json:property name="importeGarantizadoAprov" value="${cb.importeGarantizadoAprov}"/>
			<c:if test="${cb.tipo != null}">
				<json:property name="codRelacion" value="${cb.tipo.codigo}"/>
				<json:property name="relacion" value="${cb.tipo.descripcion}"/>
			</c:if>
			<c:if test="${cb.estado != null}">
				<json:property name="estado" value="${cb.estado.descripcion}"/>
			</c:if>
			<json:property name="codigoContrato" value="${cb.contrato.codigoContrato}"/>
			<c:if test = "${cb.contrato.tipoProducto != null}">
				<json:property name="tipoProducto" value="${cb.contrato.tipoProducto.descripcion}"/>
			</c:if>
			<c:if test="${cb.contrato.lastMovimiento != null}">
				<json:property name="diasIrregular" value="${cb.contrato.diasIrregular}"/>
				<json:property name="riesgo" value="${cb.contrato.lastMovimiento.riesgo}"/>
				<json:property name="saldoVencido" value="${cb.contrato.lastMovimiento.posVivaVencidaAbsoluta}"/>
			</c:if>
			<json:property name="titular" value="${cb.contrato.primerTitular.apellidoNombre}"/>
			<json:property name="estadoFinanciero" value="${cb.contrato.estadoFinanciero.descripcion}"/>
			<c:if test="${cb.contrato.expedienteContratoActivo != null && cb.contrato.expedienteContratoActivo.sinActuacion == null && !cb.contrato.expedienteContratoActivo.auditoria.borrado}">
				<json:property name="situacion">
					<s:message code="situacion.expedimentado" text="**Expedientado" />
				</json:property>
			</c:if>
			<c:if test="${cb.contrato.expedienteContratoActivo != null  && !cb.contrato.expedienteContratoActivo.sinActuacion && !cb.contrato.expedienteContratoActivo.auditoria.borrado && cb.contrato.expedienteContratoActivo.cantidadProcedimientos > 0}">
				<json:property name="situacion">
					<s:message code="situacion.enAsunto" text="**En Asunto" />
				</json:property>
			</c:if>
			<json:property name="usuarioExterno" value="${usuario.usuarioExterno}"/>
 		</json:object>
	</json:array>
</fwk:json>
