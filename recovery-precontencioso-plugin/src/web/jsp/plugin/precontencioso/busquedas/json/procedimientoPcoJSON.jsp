<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	<json:property name="total" value="${totalCount}" />
	<json:array name="procedimientosPco" items="${procedimientosPco}" var="p">
		<json:object>
			<json:property name="prcId" value="${p.prcId}" />
			<json:property name="codigo" value="${p.codigo}" />
			<json:property name="nombreProcedimiento" value="${p.nombreProcedimiento}" />
			<json:property name="nombreExpediente" value="${p.nombreExpediente}" />
			<json:property name="estadoExpediente" value="${p.estadoExpediente}" />
			<json:property name="diasEnGestion" value="${p.diasEnGestion}" />
			<json:property name="fechaEstado">
				<fwk:date value="${p.fechaEstado}" />
			</json:property>
			<json:property name="tipoProcPropuesto" value="${p.tipoProcPropuesto}" />
			<json:property name="tipoPreparacion" value="${p.tipoPreparacion}" />
			<json:property name="fechaInicioPreparacion">
				<fwk:date value="${p.fechaInicioPreparacion}" />
			</json:property>
			<json:property name="diasEnPreparacion" value="${p.diasEnPreparacion}" />
			<json:property name="totalLiquidacion" value="${p.totalLiquidacion}" />
			<json:property name="fechaEnvioLetrado">
				<fwk:date value="${p.fechaEnvioLetrado}" />
			</json:property>
			<json:property name="aceptadoLetrado" value="${p.aceptadoLetrado}" />
			<json:property name="todosDocumentos" value="${p.todosDocumentos}" />
			<json:property name="todasLiquidaciones" value="${p.todasLiquidaciones}" />
			<json:property name="todosBurofaxes" value="${p.todosBurofaxes}" />
			<json:property name="importe" value="${p.importe}" />

			<%-- Documentos --%>
			<json:property name="docEstado" value="${p.documento.estado}" />
			<json:property name="docUltimaRespuesta" value="${p.documento.ultimaRespuesta}" />
			<json:property name="docUltimoActor" value="${p.documento.ultimoActor}" />
			<json:property name="docFechaResultado">
				<fwk:date value="${p.documento.fechaResultado}" />
			</json:property>
			<json:property name="docFechaEnvio">
				<fwk:date value="${p.documento.fechaEnvio}" />
			</json:property>
			<json:property name="docFechaRecepcion">
				<fwk:date value="${p.documento.fechaRecepcion}" />
			</json:property>
			<json:property name="docAdjunto" value="${p.documento.adjunto}" />

			<%-- Liquidaciones --%>
			<json:property name="liqEstado" value="${p.liquidacion.estado}" />
			<json:property name="liqContrato" value="${p.liquidacion.contrato}" />
			<json:property name="liqFechaRecepcion">
				<fwk:date value="${p.liquidacion.fechaRecepcion}" />
			</json:property>
			<json:property name="liqFechaConfirmacion">
				<fwk:date value="${p.liquidacion.fechaConfirmacion}" />
			</json:property>
			<json:property name="liqFechaCierre">
				<fwk:date value="${p.liquidacion.fechaCierre}" />
			</json:property>
			<json:property name="liqTotal" value="${p.liquidacion.total}" />

			<%-- Burofax --%>
			<json:property name="burEstado" value="${p.burofax.estado}" />
			<json:property name="burNif" value="${p.burofax.nif}" />
			<json:property name="burApellidoNombre" value="${p.burofax.apellidoNombre}" />
			<json:property name="burFechaSolicitud">
				<fwk:date value="${p.burofax.fechaSolicitud}" />
			</json:property>
			<json:property name="burFechaEnvio">
				<fwk:date value="${p.burofax.fechaEnvio}" />
			</json:property>
			<json:property name="burFechaAcuse">
				<fwk:date value="${p.burofax.fechaAcuse}" />
			</json:property>
			<json:property name="burRegManual" value="${p.burofax.regManual}" />
			<json:property name="burRefExternaEnvio" value="${p.burofax.refExternaEnvio}" />
			<json:property name="burResultado" value="${p.burofax.resultado}" />

		</json:object>
	</json:array>
</fwk:json>
