<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

<fwk:page>

	<pfs:hidden name="banderaEditar" value="1"/>
	<pfs:hidden name="idProcedimiento" value="${credito.idProcedimiento}"/>
	<pfs:hidden name="idContratoExpediente" value="${credito.idContratoExpediente}"/>
	<pfs:hidden name="idCredito" value="${credito.id}"/>
		
	<pfs:ddCombo name="supervisorTipoCredito" labelKey="asunto.concurso.tabFaseComun.insinuacionSupervisor" label="**Insinuación supervisor" value="${credito.tipoSupervisor.id}" dd="${tipos}" />
	<pfs:ddCombo name="externoTipoCredito" labelKey="asunto.concurso.tabFaseComun.insinuacionGestor" label="**Insinuación gestor" value="${credito.tipoExterno.id}" dd="${tipos}" />
	<pfs:ddCombo name="definitivoTipoCredito" labelKey="asunto.concurso.tabFaseComun.insinuacionDefinitiva" label="**Insinuación definitiva" value="${credito.tipoDefinitivo.id}" dd="${tipos}" />
	<pfs:ddCombo name="estadoCredito" labelKey="asunto.concurso.tabFaseComun.estado" label="**Estado" value="${credito.estadoCredito.id}" dd="${estados}" />
	
	<pfs:currencyfield name="supervisorPrincipal" labelKey="asunto.concurso.tabFaseComun.principalSupervisor" label="**Principal supervisor" value="${credito.principalSupervisor}" />
	<pfs:currencyfield name="externoPrincipal" labelKey="asunto.concurso.tabFaseComun.principalGestor" label="**Principal gestor" value="${credito.principalExterno}" />
	<pfs:currencyfield name="definitivoPrincipal" labelKey="asunto.concurso.tabFaseComun.principalDefinitivo" label="**Principal definitivo" value="${credito.principalDefinitivo}" />
	
	<pfs:currencyfield name="banderaTipoEdit" labelKey="***" label="**Bandera edit" value="${banderaTipoEdit}" />
	
	
	<pfs:defineParameters name="parametros" paramId=""
		idCredito="idCredito"
		idContratoExpediente="idContratoExpediente"
		idProcedimiento="idProcedimiento"
		supervisorTipoCredito="supervisorTipoCredito"
		supervisorPrincipal="supervisorPrincipal"
		externoTipoCredito="externoTipoCredito"
		externoPrincipal="externoPrincipal"
		definitivoTipoCredito="definitivoTipoCredito"
		definitivoPrincipal="definitivoPrincipal"	
		estadoCredito="estadoCredito"	
		banderaEditar="banderaEditar"
	/>
	
	<pfs:editForm saveOrUpdateFlow="plugin/procedimientos/concursal/editarCredito" 
			rightColumFields="banderaTipoEdit, estadoCredito, supervisorPrincipal, externoPrincipal, definitivoPrincipal"  
			leftColumFields="supervisorTipoCredito, externoTipoCredito, definitivoTipoCredito" 
			parameters="parametros" />
</fwk:page>