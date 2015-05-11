<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

<fwk:page>
	<pfs:hidden name="idProcedimiento" value="${idProcedimiento}"/>
	<pfs:hidden name="idContratoExpediente" value="${idContratoExpediente}"/>
	<pfs:hidden name="banderaEntrada" value="1"/>
	
	<pfs:ddCombo name="externoTipoCredito" labelKey="asunto.concurso.tabFaseComun.insinuacionGestor" label="**Insinuación gestor" value="" dd="${tipos}" />
	<pfs:ddCombo name="definitivoTipoCredito" labelKey="asunto.concurso.tabFaseComun.insinuacionDefinitiva" label="**Calificación final" value="" dd="${tipos}" />
	<pfs:ddCombo name="estadoCredito" labelKey="asunto.concurso.tabFaseComun.estado" label="**Estado" value="${estado_credito_porDefecto}" dd="${estados}" />
	
	<pfs:currencyfield name="externoPrincipal" labelKey="asunto.concurso.tabFaseComun.principalGestor" label="**Importe inicial" value="" />
	<pfs:currencyfield name="definitivoPrincipal" labelKey="asunto.concurso.tabFaseComun.principalDefinitivo" label="**Importe final" value="" />
	
	<pfs:defineParameters name="parametros" paramId=""
		estadoCredito="estadoCredito"
		externoTipoCredito="externoTipoCredito"
		externoPrincipal="externoPrincipal"
		definitivoTipoCredito="definitivoTipoCredito"
		definitivoPrincipal="definitivoPrincipal"		
		idProcedimiento="idProcedimiento"
		idContratoExpediente="idContratoExpediente"
		banderaEntrada="banderaEntrada"
	/>
	
	<pfs:editForm saveOrUpdateFlow="plugin/procedimientos/concursal/agregarCredito" 
			rightColumFields="externoPrincipal, definitivoPrincipal"  
			leftColumFields="externoTipoCredito, definitivoTipoCredito" 
			parameters="parametros" 
			centerColumFieldsUp="estadoCredito"/>
			
			
	btnGuardar.handler = function() {
		var estado = estadoCredito.getValue();
		var ext1 = externoTipoCredito.getValue();
		var ext2 = externoPrincipal.getValue();
		var def1 = definitivoTipoCredito.getValue();
		var def2 = definitivoPrincipal.getValue();
		if (estado=='') {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.estadoObligatoria"/>');
		} else if (ext1 == '' || ext2 == '') {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.externoObligatoria"/>');
		} if ((def1 != '' && def2 == '') || (def2 != '' && def1 == '')) {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="asunto.concurso.tabFaseComun.error.finalObligatoria"/>');
		} else {
			page.webflow({
				flow: 'plugin/procedimientos/concursal/agregarCredito'
				,params: parametros
				,success :  function(){ 
					page.fireEvent(app.event.DONE); 
				}
			});
		}
	};
			
</fwk:page>