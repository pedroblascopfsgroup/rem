<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<fwk:page>
	var width=250;
	var style='text-align:left;font-weight:bolder;width:140';
	
	
	var titulogestionesRealizadas = new Ext.form.Label({
   	text:'<s:message code="expedientes.consulta.tabgestion.revision.observaciones" text="**Observaciones"/>'
	,style:'font-weight:bolder; font-size:11'
	});
	var gestionesRealizadas=new Ext.form.TextArea({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.revision.observaciones" text="**Observaciones"/>'
		,width:590
		,hideLabel:true
		,height:150
		,labelStyle:style
		,name:'aaa.revision'
		,maxLength: 1024
		,value : '<s:message text="${aaa.revision}" javaScriptEscape="true" />'
		,blankText: 'Campo requerido'
		<app:test id="campoGestion" addComa="true"/>
	});
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				 eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){page.fireEvent(app.event.DONE) }
			});
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var codigoAAA = new Ext.form.Hidden({name:'aaa.id', value :'${aaa.id}'}) ;
	
	var panelEdicion = new Ext.form.FormPanel({
		layout:'form'
		,autoHeight:true
		//,width:400
		,bodyStyle : 'padding:10px'
		,items:[
			{ xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 1 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false ,width:620}
				,items : [
					{ items : [
					titulogestionesRealizadas
						,gestionesRealizadas
					], style : 'margin-right:10px' }
				]
			}
		]
		,bbar:[btnGuardar,btnCancelar]
	});	
	page.add(panelEdicion);

</fwk:page>
