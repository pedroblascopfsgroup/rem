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
 	
 	var observaciones = new Ext.form.HtmlEditor({
    	hideParent:true
       	,fieldLabel:'<s:message code="plugin.mejoras.analisisAsunto.observaciones" text="**Observaciones" />'
       	,hideLabel:true
		,enableColors: false
       	,enableFont:false
       	,enableFontSize:false
       	,enableFormat:true
       	,enableAlignments: false
       	,enableLists:false
       	,enableSourceEdit:false
       	,height:350
       	,width:550
       	,readOnly:false
       	,labelStyle:labelStyle
       	,value:'<s:message text="${analisis.observacion}" javaScriptEscape="true"/>'
 	});
	
	<pfs:hidden name="idAsunto" value="${idAsunto}"/>
	
	<pfs:defineParameters name="parametros" paramId="${asunto.id}"
		idAsunto="idAsunto"
		observaciones="observaciones"/>
		
	<pfs:editForm saveOrUpdateFlow="plugin.mejoras.analisisAsunto.guardarAnalisis"
		leftColumFields="observaciones"
		rightColumFields=""
		parameters="parametros" />		
	
</fwk:page>