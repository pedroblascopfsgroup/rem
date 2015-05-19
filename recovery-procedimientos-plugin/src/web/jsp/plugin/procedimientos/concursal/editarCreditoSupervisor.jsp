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
		
	<pfs:ddCombo name="supervisorTipoCredito" labelKey="asunto.concurso.tabFaseComun.insinuacionSupervisor" label="**Insinuaci�n supervisor" value="${credito.tipoSupervisor.id}" dd="${tipos}" />
	<pfs:currencyfield name="supervisorPrincipal" labelKey="asunto.concurso.tabFaseComun.principalSupervisor" label="**Principal supervisor" value="${credito.principalSupervisor}" />
	
	<pfs:defineParameters name="parametros" paramId=""
		idCredito="idCredito"
		idContratoExpediente="idContratoExpediente"
		idProcedimiento="idProcedimiento"
		supervisorTipoCredito="supervisorTipoCredito"
		supervisorPrincipal="supervisorPrincipal"
		banderaEditar="banderaEditar"
	/>
	
	<pfs:editForm saveOrUpdateFlow="plugin/procedimientos/concursal/editarCreditoSupervisor" 
			rightColumFields="supervisorPrincipal"  
			leftColumFields="supervisorTipoCredito" 
			parameters="parametros" />
			
	btnGuardar.handler = function() {
		var sup1 = tipoDefinitivo.getValue();
		var sup1 = principalDefinitivo.getValue();

		if ((sup1 != '' && sup2 == '') || (sup2 != '' && sup1 == '')) {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.supervisorObligatoria"/>');
		} else {
			page.webflow({
				flow: 'plugin/procedimientos/concursal/editarCreditoSupervisor'
				,params: parametros
				,success :  function(){ 
					page.fireEvent(app.event.DONE); 
				}
			});
		}
	};
			
</fwk:page>