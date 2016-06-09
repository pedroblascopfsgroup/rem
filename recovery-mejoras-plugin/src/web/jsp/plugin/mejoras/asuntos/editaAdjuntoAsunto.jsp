<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	var nombre = new Ext.form.DisplayField({
		fieldLabel : '<s:message code='plugin.mejoras.asunto.editarAdjuntoExpediente.nombre' text='**Nombre' />',
    	labelStyle: 'font-weight:bolder',
    	value:'<s:message text="${adjunto.nombre}" javaScriptEscape="true" />'
	});
	
	var contentType = new Ext.form.DisplayField({
		fieldLabel : '<s:message code='plugin.mejoras.asunto.editarAdjuntoExpediente.contenetType' text='**Tipo de contenido' />',
    	labelStyle: 'font-weight:bolder',
    	value:'<s:message text="${adjunto.contentType}" javaScriptEscape="true" />'
	}); 
	
	var length = new Ext.form.DisplayField({
		fieldLabel : '<s:message code='plugin.mejoras.asunto.editarAdjuntoExpediente.length' text='**Tamaño' />',
    	labelStyle: 'font-weight:bolder',
    	value:'<s:message text="${adjunto.length}" javaScriptEscape="true" />'
	});

<%-- 	<pfsforms:textfield name="nombre" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.nombre" 
		label="**Nombre" value="${adjunto.nombre}" readOnly="true"/>
		
	<pfsforms:textfield name="contentType" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.contenetType" 
		label="**Tipo de contenido" value="${adjunto.contentType}" readOnly="true"/>
		
	<pfsforms:textfield name="length" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.length" 
		label="**Tamaño" value="${adjunto.length}" readOnly="true"/> --%>
	
	<%-- 
	<pfsforms:textfield name="descripcion" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.descripcion" 
		label="**Descripcion" value="<s:message text="${adjunto.descripcion}" javaScriptEscape="true" />"/>
		--%>
	var descripcion = new Ext.form.TextArea({
		fieldLabel : '<s:message code='plugin.mejoras.asunto.editarAdjuntoExpediente.descripcion' text='**Descripcion' />',
    	maxLength:1000,
    	width: 275,
    	value:'<s:message text="${adjunto.descripcion}" javaScriptEscape="true" />'
	});
		
	<pfs:defineParameters name="parametros" paramId="${adjunto.id}" 
		descripcion="descripcion"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/mejoras/asuntos/plugin.mejoras.asuntos.guardaDescripcionAdjAsunto"
		leftColumFields="nombre,contentType,length,descripcion"
		parameters="parametros"
		/>
		

</fwk:page>