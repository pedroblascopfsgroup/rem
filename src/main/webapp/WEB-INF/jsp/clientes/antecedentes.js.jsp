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
		fieldLabel:'<s:message code="antecedentes.edicion.fechaverificacion" text="**Fecha Verificacion" />'
		<app:test id="fechaVerificacionSolvencia" addComa="true" />
		,name:'antecedente.fechaVerificacion'
		,style:'margin:0px'
        ,maxValue : new Date()
		,value:'<fwk:date value="${antecedente.fechaVerificacion}" />'
		,labelStyle:labelStyle
		//,disabled:true
	});

	<%--
	var numReincidenciasInterno = new Ext.form.NumberField({
		fieldLabel:'<s:message code="antecedentes.edicion.incidenciasint" text="**Nro. Incidencias Internas" />'
		,allowNegative:false
		,allowDecimals:false
		,value:'${antecedente.numReincidenciasInterno}'
		,name:'antecedente.numReincidenciasInterno'
		,labelStyle:labelStyle
	});
	--%>
	var tituloobservaciones = new Ext.form.Label({
   	text:'<s:message code="antecedentes.edicion.observaciones" text="**Observaciones" />'
	,style:'font-weight:bolder; font-size:11'
	}); 
	var observaciones = new Ext.form.TextArea({
			fieldLabel:'<s:message code="antecedentes.edicion.observaciones" text="**Observaciones" />'
			<app:test id="observacionesAntecedentes" addComa="true" />
			,name: 'antecedente.observaciones'
			,value:'<s:message javaScriptEscape="true" text="${antecedente.observaciones}" />'
			,hideLabel: true
			,width:580
			,height: 200
			,maxLength: 1024
			,labelStyle:labelStyle
	});

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		<app:test id="btnGuardarAntecedente" addComa="true" />
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
		,width:580
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false}
				,items : [
					{ items : [ fechaVerificacion,<%--numReincidenciasInterno,--%>tituloobservaciones,observaciones ], style : 'margin-right:10px' }
					
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});
	
	page.add(panelEdicion);
	
</fwk:page>