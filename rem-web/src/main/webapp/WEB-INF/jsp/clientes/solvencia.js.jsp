<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:150px'
	var fechaVerificacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="solvencia.editar.fechaverificacion" text="**Fecha Verificacion" />'
		<app:test id="fechaVerificacionSolvencia" addComa="true" />
		,labelStyle:labelStyle
        ,maxValue : new Date()
        ,style:'margin:0px'
		,name:'persona.fechaVerifSolvencia'
		,value:'<fwk:date value="${persona.fechaVerifSolvencia}" />'
	});
	
	
	var tituloobservaciones = new Ext.form.Label({
   	text:'<s:message code="solvencia.editar.observaciones" text="**Observaciones" />'
	,style:'font-weight:bolder; font-size:11'
	}); 

	
		var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="solvencia.editar.observaciones" text="**Observaciones" />'
		,value:'<s:message javaScriptEscape="true" text="${persona.observacionesSolvencia}" />'
		,name:'persona.observacionesSolvencia'
			,hideLabel: true
			,width:580
			,height: 200
			,maxLength: 1024
			,labelStyle:labelStyle
	});

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarSolvencia" addComa="true" />
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
		,autoWidth:true
		,width:580 
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
		
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 1 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false}
				,items : [
					{ items : [ fechaVerificacion,tituloobservaciones,observaciones ], style : 'margin-right:10px' }
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});

	page.add(panelEdicion);
	
</fwk:page>