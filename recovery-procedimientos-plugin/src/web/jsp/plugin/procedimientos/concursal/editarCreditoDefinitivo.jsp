<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfs:hidden name="banderaEditar" value="1"/>
	<pfs:hidden name="idProcedimiento" value="${credito.idProcedimiento}"/>
	<pfs:hidden name="idContratoExpediente" value="${credito.idContratoExpediente}"/>
	<pfs:hidden name="idCredito" value="${credito.id}"/>
		
	<pfs:ddCombo name="tipoDefinitivo" labelKey="asunto.concurso.tabFaseComun.insinuacionDefinitiva" label="**Insinuación definitiva" value="${credito.tipoDefinitivo.id}" dd="${tipos}" />
	<pfs:currencyfield name="principalDefinitivo" labelKey="asunto.concurso.tabFaseComun.principalDefinitivo" label="**Principal definitivo" value="${credito.principalDefinitivo}" />
	<pfs:ddCombo name="estadoCredito" labelKey="asunto.concurso.tabFaseComun.estado" label="**Estado" value="${credito.estadoCredito.id}" dd="${estados}" />
	
	<pfs:datefield name="fechaVencimiento" label="**Fecha de vencimiento" labelKey="asunto.concurso.tabFaseComun.fechaVencimiento" disabled="${credito.tipoDefinitivo.codigo ne '7'}" value="${credito.fechaVencimiento}" />
	
	<pfs:defineParameters name="parametros" paramId=""
		idCredito="idCredito"
		idContratoExpediente="idContratoExpediente"
		idProcedimiento="idProcedimiento"
		definitivoTipoCredito="tipoDefinitivo"
		definitivoPrincipal="principalDefinitivo"
		estadoCredito="estadoCredito"
		banderaEditar="banderaEditar"
		fechaVencimiento="fechaVencimiento"
	/>
	
	<pfs:editForm saveOrUpdateFlow="plugin/procedimientos/concursal/editarCreditoDefinitivo" 
			rightColumFields="principalDefinitivo"  
			leftColumFields="tipoDefinitivo, fechaVencimiento" 
			parameters="parametros" 
			centerColumFieldsUp="estadoCredito"/>
			
	fechaVencimiento.hide();		
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
	fechaVencimiento.show();
	tipoDefinitivo.on('select', function(){
		
		if(tipoDefinitivo.lastSelectionText != 'Crédito contingente') {
			fechaVencimiento.setDisabled(true);
			fechaVencimiento.allowBlank = true;
			fechaVencimiento.setValue('');
		}
		else{
			fechaVencimiento.setDisabled(false);
			fechaVencimiento.allowBlank = false;
		}
	});		
</sec:authorize>	
			
	btnGuardar.handler = function() {
		var estado = estadoCredito.getValue();
		var def1 = tipoDefinitivo.getValue();
		var def2 = principalDefinitivo.getValue();
		var fecha = fechaVencimiento.getValue();
		if (estado=='') {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.estadoObligatoria"/>');
		} 
		else if ((def1 != '' && def2 == '') || (def2 != '' && def1 == '')) {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.finalObligatoria"/>');
		} 
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">		
		else if (tipoDefinitivo.lastSelectionText == 'Crédito contingente' && fecha == ''){
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.fechaObligatoria"/>');
		}
</sec:authorize>		
		else {
			page.webflow({
				flow: 'plugin/procedimientos/concursal/editarCreditoDefinitivo'
				,params: parametros
				,success :  function(){ 
					page.fireEvent(app.event.DONE); 
				}
			});
		}
	};
			
</fwk:page>