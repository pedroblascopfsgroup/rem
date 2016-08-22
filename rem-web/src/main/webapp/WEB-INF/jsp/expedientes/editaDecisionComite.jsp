<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

	

	var observaciones = app.crearTextArea(
		'<s:message code="decisioncomite.edicion.observaciones" text="**Observaciones" />',
		'<s:message text="${content}" javaScriptEscape="true" />'
		,false,'font-weight:bolder;','',{maxLength:100, width:450, height:200});

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
					if (observaciones.getValue().length >100){
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.obs.editar.maxLenght"/>')
					}else{
						document.getElementById('${id}').value=observaciones.getValue();
						page.fireEvent(app.event.DONE);
					} 
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
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : [
					{ items : [ observaciones ], style : 'margin-right:10px' }
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});

	page.add(panelEdicion);
	
</fwk:page>