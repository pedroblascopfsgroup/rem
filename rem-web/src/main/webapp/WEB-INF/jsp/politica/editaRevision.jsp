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
	
	var titulocomentario = new Ext.form.Label({
		   	text:'<s:message code="analisisPersona.comentario" text="**Comentario"/>'
			,style:'font-weight:bolder; font-size:11' 
			}); 
	var comentario=new Ext.form.TextArea({
		fieldLabel:'<s:message code="analisisPersona.comentario" text="**Comentario"/>'
		,width:590
		,height:200
		,hideLabel:true
		,labelStyle:style
		,name:'comentario'
		,maxLength: 1024
		<c:if test="${esSupervisor}">
			,value:'<s:message text="${analisisPP.comentarioSupervisor}" javaScriptEscape="true"/>'
		</c:if>
	    <c:if test="${esGestor && !esSupervisor}">
			,value:'<s:message text="${analisisPP.comentarioGestor}" javaScriptEscape="true"/>'
		</c:if>
		,blankText: 'Campo requerido'
	});

	var idApp = new Ext.form.Hidden({name:'idAnalisisPolitica', value :'${idAppSeleccionado}'});
	var esGestor = new Ext.form.Hidden({name:'esGestor', value :'${esGestor}'});
	var esSupervisor = new Ext.form.Hidden({name:'esSupervisor', value :'${esSupervisor}'});	

	var validar = function(){
		if (comentario.getValue()==null || comentario.getValue().trim() === ''){
			return false;
		}
	    return true;
	}

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (validar()){
				page.submit({
					 eventName : 'update'
					,formPanel : panelEdicion
					,success : function(){page.fireEvent(app.event.DONE) }
				});
				<c:if test="${esSupervisor}">
					document.getElementById('comentarioSupervisor${analisisPP.id}').value=comentario.getValue();
				</c:if>
				<c:if test="${esGestor && !esSupervisor}">
					document.getElementById('comentarioGestor${analisisPP.id}').value=comentario.getValue();
				</c:if>
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisisPersonas.faltanCampos" text="**Debe completar todos los campos"/>')
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
						titulocomentario
						,comentario
						,idApp
						,esSupervisor
						,esGestor
					], style : 'margin-right:10px' }
				]
			}
		]
		,bbar:[btnGuardar,btnCancelar]
	});	
	page.add(panelEdicion);

</fwk:page>
