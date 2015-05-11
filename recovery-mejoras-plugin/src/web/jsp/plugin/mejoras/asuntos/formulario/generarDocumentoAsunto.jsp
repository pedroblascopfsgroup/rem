<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>

<fwk:page>

	var idAsunto = ${idAsunto};

	var tiposDocumento=[
		'Demanda'
		,'Impugnación de oposición'
		,'Recurso de apelación'
		,'Solicitud de certificación de cargas'
		,'Solicitud de subasta'
		,'Solicitud de mejora de embargo'
		,'Solicitud de impulso procesal'
		,'Solicitud de averiguación de bienes'
		];  

    var comboDocumentos = app.creaCombo({
	 	labelStyle: 'width:220px'
	 	,fieldLabel : '<s:message code="plugin.mejoras.asunto.generarDocumento.comboTipoDocumento" text="**Selecciona el documento" />'
	 	,triggerAction: 'all'
      	,store: tiposDocumento
        ,value: 'Demanda'
        ,name : 'comboDocumentos'
	});
    	
	<pfs:buttoncancel name="btCancelar"/>
	
	<pfs:button name="btAceptar" caption="**Aceptar"  captioneKey="plugin.burofax.confirmardatos.action.aceptar" iconCls="icon_ok">
		var flow='plugin.mejoras.asuntos.openPlantillaDemanda';
		var tipo='generaPDF';
		var params='idAsunto='+ idAsunto+'&REPORT_NAME=demanda_procedimiento_'+idAsunto+'.pdf';
		app.openPDF(flow,tipo,params);
		page.fireEvent(app.event.DONE);
	</pfs:button>

	
	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:10px;cellspacing:20px;'
		,border : false
		,layout:'form'
		,items : comboDocumentos
		,bbar : [btAceptar, btCancelar]
	});	
	
	page.add(panelEdicion);
	
</fwk:page>