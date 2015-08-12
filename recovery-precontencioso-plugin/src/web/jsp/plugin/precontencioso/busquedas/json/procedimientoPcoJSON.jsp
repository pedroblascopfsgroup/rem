<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	<json:property name="total" value="${totalCount}" />
	<json:array name="procedimientosPco" items="${procedimientosPco}" var="p">
		<json:object>
			<json:property name="prcId" value="${p.prcId}" />
			<json:property name="codigo" value="${p.codigo}" />
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
			<json:property name="documentacionCompleta" value="${p.documentacionCompleta}" />
			<json:property name="totalLiquidacion" value="${p.totalLiquidacion}" />
			<json:property name="notificadoClientes" value="${p.notificadoClientes}" />

			<json:property name="fechaEnvioLetrado">
				<fwk:date value="${p.fechaEnvioLetrado}" />
			</json:property>

			<json:property name="aceptadoLetrado" value="${p.aceptadoLetrado}" />
			<json:property name="todosDocumentos" value="${p.todosDocumentos}" />
			<json:property name="todasLiquidaciones" value="${p.todasLiquidaciones}" />
		</json:object>
	</json:array>
</fwk:json>
