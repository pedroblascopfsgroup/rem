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
		
	<pfs:ddCombo name="externoTipoCredito" labelKey="asunto.concurso.tabFaseComun.insinuacionGestor" label="**Insinuaci�n gestor" value="${credito.tipoExterno.id}" dd="${tipos}" />
	<pfs:currencyfield name="externoPrincipal" labelKey="asunto.concurso.tabFaseComun.principalGestor" label="**Principal gestor" value="${credito.principalExterno}" />
	
	<pfs:defineParameters name="parametros" paramId=""
		idCredito="idCredito"
		idContratoExpediente="idContratoExpediente"
		idProcedimiento="idProcedimiento"
		externoTipoCredito="externoTipoCredito"
		externoPrincipal="externoPrincipal"
		banderaEditar="banderaEditar"
	/>
	
	<pfs:editForm saveOrUpdateFlow="plugin/procedimientos/concursal/editarCreditoGestor" 
			rightColumFields="externoPrincipal"  
			leftColumFields="externoTipoCredito" 
			parameters="parametros" />
			
	btnGuardar.handler = function() {
		var ext1 = externoTipoCredito.getValue();
		var ext2 = externoPrincipal.getValue();
		if (ext1 == '' || ext2 == '') {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.externoObligatoria"/>');
		} else {
			page.webflow({
				flow: 'plugin/procedimientos/concursal/editarCreditoGestor'
				,params: parametros
				,success :  function(){ 
					page.fireEvent(app.event.DONE); 
				}
			});
		}
	};

</fwk:page>