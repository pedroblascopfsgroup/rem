<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:150px'	

	var fechaRecopilacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.documentacion.fechaRecopilacion" text="**Fecha recopilación" />'
		<app:test id="fechaRecopilacionField" addComa="true" />
		,name:'procedimiento.fechaRecopilacion'
		,value:'<fwk:date value="${procedimiento.fechaRecopilacion}" />'
		,labelStyle:labelStyle
		,maxValue: new Date()
	});
	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="procedimiento.documentacion.observaciones" text="**Observaciones" />'
		,style:labelStyle
	});
	var observacionesRecopilacion = new Ext.form.TextArea({
		fieldLabel:'<s:message code="procedimiento.documentacion.observaciones" text="**Observaciones" />'
		<app:test id="observacionesRecopilacionField" addComa="true" />
		,name: 'procedimiento.observacionesRecopilacion'
		,value:'<s:message javaScriptEscape="true" text="${procedimiento.observacionesRecopilacion}" />'
		,width: 530
		,height:220 
		,maxLength: 500
		,labelStyle:labelStyle
	});

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarRec" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false}
				,items : [
					{ items : [ 
						fechaRecopilacion
						,tituloobservaciones
						,{items:observacionesRecopilacion,border:false,style:'margin-top:5px'} 
					], style : 'margin-right:10px' }
					
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});
	
	page.add(panelEdicion);
	
</fwk:page>
