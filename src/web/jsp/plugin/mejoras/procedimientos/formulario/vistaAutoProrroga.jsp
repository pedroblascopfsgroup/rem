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
	
	<pfsforms:textfield name="tarea" labelKey="plugin.mejoras.procedimiento.consultaAutoprorroga.tarea" 
		label="**Tarea" value="" readOnly="true"/>
		
	tarea.setValue('<s:message text="${infoRegistro['tarId']}" javaScriptEscape="true" />');
	
	<pfsforms:textfield name="motivo" labelKey="plugin.mejoras.procedimiento.consultaAutoprorroga.motivo" 
		label="**Motivo" value="${infoRegistro['motivo']}" readOnly="true"/>
	
	<pfsforms:textfield name="fechaVieja" labelKey="plugin.mejoras.procedimiento.consultaAutoprorroga.fechaVieja" 
		label="**Fecha de vencimiento anterior" value="${infoRegistro['tarFecVencOld']}" readOnly="true"/>
	
		
	<pfsforms:textfield name="fechaNueva" labelKey="plugin.mejoras.procedimiento.consultaAutoprorroga.fechaNueva" 
		label="**Fecha de vencimiento actual" value="${infoRegistro['tarFecVencNew']}" readOnly="true"/>
	
	<%-- 
	<pfs:textarea labelKey="plugin.mejoras.procedimiento.consultaAutoprorroga.detalles" 
		label="**Detalles" name="detalles" value="${infoRegistro['motivo']}" width="500" />	
	--%> 	
		
	var detalles = new Ext.form.TextArea({
		fieldLabel : '<s:message code='plugin.mejoras.procedimiento.consultaAutoprorroga.detalles' text='**Detalles' />'
		,value : '<s:message javaScriptEscape="true" text="${infoRegistro['detalle']}" />'
		,name : 'detalles'
		,labelStyle:'font-weight:bolder'
		,width : 500 
	});	
		
	var btnAceptar = new Ext.Button({
			text : '<s:message code="app.botones.aceptar" text="**Aceptar" />'
			,iconCls : 'icon_ok'
			,handler : function(){
				 page.fireEvent(app.event.DONE) 
			}
		});	
	<%--
	<pfs:panel name="panelEdicion" columns="2" collapsible="false" bbar="btnAceptar">
		<pfs:items items="tarea,motivo"/>
		<pfs:items items="fechaVieja,fechaNueva"/>
	</pfs:panel>
	
		 --%>
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,style:'padding-right:0px;padding-bottom:0px'
		,bodyStyle : 'padding:5px'
		,border : false
		,defaults : {xtype:'panel', border : false ,autoHeight:true}
		,items : [
				{ 
				border : false
				,layout : 'table'
				,layoutConfig:{columns:1}
				,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form'}
				,items : [{items:[tarea,motivo,fechaVieja,fechaNueva,detalles]}]
			}]
		,bbar : [btnAceptar]
	});	
	
	
	
	
	page.add(panelEdicion);

</fwk:page>