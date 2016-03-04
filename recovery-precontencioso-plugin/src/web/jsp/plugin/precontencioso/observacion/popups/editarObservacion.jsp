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
       	,value:'<s:message text="${textoAnotacion}" javaScriptEscape="true"/>'
 	});
 	
	<pfs:hidden name="idProcedimientoPCO" value="${idPcoPrc}"/>
	<pfs:hidden name="idUsuario" value="${Usuario.id}"/>
	<pfs:hidden name="id" value="${idObservacion}"/>
	
	<pfs:defineParameters name="parametros" paramId="${idObservacion}"
		id="id"
		idProcedimientoPCO="idProcedimientoPCO"
		idUsuario="idUsuario"
		textoAnotacion="observaciones"/>
<%--		
	<pfs:editForm saveOrUpdateFlow="observacion/guardarObservacion"
		leftColumFields="observaciones"
		rightColumFields=""
		parameters="parametros" />		
 --%>	
	
	var btnGuardar= new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler:function(){
			var mask=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Guardando..."/>'});
			mask.show();
	    	Ext.Ajax.request({
			url : page.resolveUrl('observacion/guardarObservacion'), 
			params : parametros ,
			method: 'POST',
			success: function ( result, request ) {
				page.fireEvent(app.event.DONE);
				mask.hide();
			}
		});
	     }
	});	
		
		
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});	
		
		
		
	var panelEdicion = new Ext.form.FieldSet({
		title:'<s:message code="plugin.precontencioso.grid.observacion.titulo.editar.panel" text="**Observaciones"  arguments="${Usuario.username}" />'
		,layout:'table'
		,layoutConfig:{columns:1}
		,border:true
		,autoHeight : true
   	    ,autoWidth : true
		,defaults : {xtype : 'fieldset', border:false , cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,items: observaciones
	});	
	
	var panel=new Ext.Panel({
		border:false
		,bodyStyle : 'padding:5px'
		,autoHeight:true
		,autoScroll:true
		,width:600
		,height:620
		,defaults:{xtype:'fieldset',cellCls : 'vtop',width:600,autoHeight:true}
		,items:panelEdicion
		,bbar:[<c:if test="${Usuario.id eq idUserLogado}">btnGuardar,</c:if> btnCancelar]
	});	
		
	page.add(panel);	
		
		
	
</fwk:page>