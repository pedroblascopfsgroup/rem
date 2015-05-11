<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:150px';
	
	var tituloComentarios = new Ext.form.Label({
   		text:'<s:message code="plugin.mejoras.tareas.alerta.comentarios" text="**Comentarios"/>'
		,style:'font-weight:bolder; font-size:11'
	});	
		
	var comentariosAlerta = new Ext.form.TextArea({
		width:600
		,hideLabel: true
		,height:200
		,maxLength:3500
		,value:'<s:message text="${tarea.comentariosAlertaSupervisor}" javaScriptEscape="true" />'
	});
	
	<pfsforms:check name="revisada" labelKey="plugin.mejoras.tareas.alertas.revidada"
		label="**Revisada" value="${tarea.revisada}" />
		
	<pfsforms:ddCombo name="tipoRevision" 
		labelKey="plugin.mejoras.tareas.alertas.tipoRevision" 
		label="**Tipo de Revisión" value="${tarea.tipoRevision.id}" 
		dd="${tiposRevision}" width="200"/>	
		
	var fechaRev=app.creaLabel('<s:message code="plugin.mejoras.tareas.alerta.fecharev" text="**Fecha revisión"/>',"<fwk:date value='${tarea.fechaRevisionAlerta}' />",{labelStyle:labelStyle});
	
	<pfs:defineParameters name="parametros" paramId="${tarea.id}" 
		revisada="revisada"
		tipoRevision="tipoRevision"
		comentariosAlerta="comentariosAlerta"
		/>

	<pfs:editForm saveOrUpdateFlow="tareanotificacion/guardarModificacionAlerta"
		leftColumFields="revisada,tipoRevision,fechaRev,tituloComentarios,comentariosAlerta"
		rightColumFields=""
		parameters="parametros" />

</fwk:page>