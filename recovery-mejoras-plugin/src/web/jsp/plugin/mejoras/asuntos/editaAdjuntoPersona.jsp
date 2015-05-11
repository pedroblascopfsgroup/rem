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

	<pfsforms:textfield name="nombre" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.nombre" 
		label="**Nombre" value="${adjunto.nombre}" readOnly="true"/>
		
	<pfsforms:textfield name="contentType" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.contenetType" 
		label="**Tipo de contenido" value="${adjunto.contentType}" readOnly="true"/>
		
	<pfsforms:textfield name="length" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.length" 
		label="**Tamaño" value="${adjunto.length}" readOnly="true"/>
	 <%--	
	<pfsforms:textfield name="descripcion" labelKey="plugin.mejoras.asunto.editarAdjuntoExpediente.descripcion" 
		label="**Descripcion" value='<s:message text="${adjunto.descripcion}" javaScriptEscape="true" />' />
		
	--%>
		
	var descripcion = new Ext.form.TextArea({
		fieldLabel : '<s:message code='plugin.mejoras.asunto.editarAdjuntoExpediente.descripcion' text='**Descripcion' />',
    	maxLength:1000,
    	width: 275,
    	value:'<s:message text="${adjunto.descripcion}" javaScriptEscape="true" />'
	}); 	
	<pfs:defineParameters name="parametros" paramId="${adjunto.id}" 
		descripcion="descripcion"
		/>

<%--
	var validarDescripcion=function(){
		var valid=true;
		if(descripcion.getSize() > 1000){
			valid = false;
		}
		return valid;
	}
	
	var btnGuardarComprobacion = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if(!validarDescripcion()){
				alert(descripcion.getSize());
			}
			else{
				alert(descripcion.getSize());
				page.webflow({
						flow: 'plugin/mejoras/asuntos/plugin.mejoras.asuntos.guardaDescripcionAdjExpediente'
						,params: parametros()
						,success : function(){
							page.fireEvent(app.event.DONE);
						}
				});
			}
			
		}
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,border : false
		,layoutConfig:{columns:2}
		,bodyStyle:'padding:5px'
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,autoHeight:true
				,xtype:'fieldset'
				,defaults :  {layout: 'form' }
				,items : [nombre,contentType,length,descripcion]
			}
		]
		,bbar : [
			btnGuardarComprobacion, btnCancelar
		]
	});	
	page.add(panelEdicion);	--%>
	
	<pfs:editForm saveOrUpdateFlow="plugin/mejoras/asuntos/plugin.mejoras.asuntos.guardaDescripcionAdjPersona"
		leftColumFields="nombre,contentType,length,descripcion"
		parameters="parametros"
		/>
		 
	
	
	

</fwk:page>