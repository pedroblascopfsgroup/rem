<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>


(function(page,entidad){

	var riesgoOperacional = label('riesgoOperacional', '<s:message code="contrato.consulta.tabOtrosDatos.riesgoOperacional" text="**Estado"/>');

	var otrosDatosFieldSet = new Ext.form.FieldSet({
		autoHeight:true
		,autowidth:true
		,style: 'padding:0px'
		,border: true
		,layout: 'table'
		,layoutConfig: {columns:2}
		,title: ''
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375, style:'padding:10px'}
		//,items:[{},{}]
		
	});
	
	
	var panel = new Ext.Panel({
	title : '<s:message code="contrato.consulta.tabcabecera.otrosdatos" text="**Otros Datos"/>'
	,layout: 'table'
	,layoutConfig: {columns:1}
	,autoScroll : true
	,bodyStyle: 'padding:5px;margin:5px'
	,autoHeight : true
	,autoWidth : true
	,defaults: {xtype: 'fieldset', autoHeight: true, border: true, cellCls: 'vtop'}
	,items: [otrosDatosFieldSet]
	,nombreTab : 'otrosDatos'
	});
})