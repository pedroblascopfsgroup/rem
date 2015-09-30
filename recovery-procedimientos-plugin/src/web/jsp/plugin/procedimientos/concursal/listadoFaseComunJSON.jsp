<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
	<json:array name="concursos" items="${pagina}" var="conc">
		<json:object>
			<json:property name="numeroAuto" value="${conc.numeroAuto}" />
		</json:object>
		<c:forEach items="${conc.contratos}" var="cont">
			<json:object>
				<json:property name="idProcedimiento"
					value="${cont.idProcedimiento}" />
				<json:property name="idContratoExpediente"
					value="${cont.idContratoExpediente}" />
				<json:property name="codigoContrato"
					value="${cont.contrato.codigoContrato}" />
 				<json:property name="producto"
					value="${cont.contrato.tipoProductoEntidad.descripcion}" />
 				<json:property name="saldoIrregular">
 					<pfsformat:money value="${cont.contrato.lastMovimiento.posVivaVencidaAbsoluta}"/>
 				</json:property>  
			</json:object>
			<c:forEach items="${cont.creditos}" var="cre">
				<json:object>
					<json:property name="idCredito"
						value="${cre.id}" />
					<json:property name="tipoExterno"
						value="${cre.tipoExterno.descripcion}" />
					<json:property name="tipoSupervisor"
						value="${cre.tipoSupervisor.descripcion}" />
					<json:property name="tipoDefinitivo"
						value="${cre.tipoDefinitivo.descripcion}" />
					<json:property name="principalSupervisor">
 						<pfsformat:money value="${cre.principalSupervisor}"/>
 					</json:property> 
					<json:property name="principalExterno">
 						<pfsformat:money value="${cre.principalExterno}"/>
 					</json:property> 
					<json:property name="principalDefinitivo">
 						<pfsformat:money value="${cre.principalDefinitivo}"/>
 					</json:property>
 					<json:property name="estado"
						value="${cre.estadoCredito.descripcion}" />
<sec:authorize ifAllGranted="PERSONALIZACION-BCC"> 					 
 					<json:property name="fechaVencimiento">
 						<pfsformat:normalize value="${cre.fechaVencimiento}"/>
 					</json:property> 
</sec:authorize>					
				</json:object>
			</c:forEach>
		</c:forEach>
	</json:array>
</fwk:json>