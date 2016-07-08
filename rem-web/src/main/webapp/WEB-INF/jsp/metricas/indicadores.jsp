<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<%@ include file="indicadoresIntervalosPanel.jsp" %>
	<%@ include file="metricasGridsPanel.jsp" %>
	<%@ include file="simulacionPanel.jsp" %>


	var panelConfiguracion = new Ext.form.FieldSet({
		title: '<s:message code="menu.configuracion" text="**Configuración" />'
		,autoHeight: true
		,autoWidth: true
		,layout: 'table'
		,layoutConfig: {columns:1}
		,defaults: {xtype:'panel', border: false, cellCls: 'vtop'}
		,items: [
			{items:[panelNumIntervalos], border:false, style:'margin-top:10px;'}
			,{items:[panelMetricasGrids],border:false, style:'margin-top:20px;'}
		   ]
	});

	var panel = new Ext.Panel({
		layout: 'form'
        ,autoHeight: true
        ,autoWidth: true
		//,border: false
		//,defaults: {xtype:'panel', border:false, cellCls:'vtop'}
		,items: [
				{items:[panelConfiguracion], border:false, style:'padding:10px'}
				,{items:[panelSimulacion], border:false, style:'padding:10px'}
			]
	});

	page.add(panel);   

</fwk:page>
