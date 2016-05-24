<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	var labelStyle='font-weight:bolder;width:150px';
 	
 	var observaciones = new Ext.form.TextArea({
    	hideParent:true
       	,fieldLabel:'<s:message code="plugin.mejoras.analisisAsunto.observaciones" text="**Observaciones" />'
       	,hideLabel:true
       	,autoScroll:true
       	,style:"font-size:300%"
       	,height:350
       	,width:550
       	,readOnly:false
       	,labelStyle:labelStyle
       	<%-- ,value:'<s:message text="${analisis.observacion}" javaScriptEscape="true"/>' --%>
 	});
	
	<pfs:hidden name="idProcedimientoPCO" value="${idPcoPrc}"/>
	<pfs:hidden name="idUsuario" value="${idUsuario}"/>
	
	<pfs:defineParameters name="parametros" paramId="${null}"
		idProcedimientoPCO="idProcedimientoPCO"
		idUsuario="idUsuario"
		textoAnotacion="observaciones"/>
		
	<pfs:editForm saveOrUpdateFlow="observacion/guardarObservacion"
		leftColumFields="observaciones"
		rightColumFields=""
		parameters="parametros" />		
	
</fwk:page>