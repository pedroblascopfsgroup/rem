<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
array = [];
array['uno']=1;
array['dos']=2;
array['tres']=3;
var tipo_wf='${tipoWf}'

//var mask=new Ext.LoadMask(app.contenido.el.dom, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando..."/>'});
//mask.show();

fwk.toast('<s:message code="plugin.precontencioso.redireccion" text="**Se va a redirigir a la pestaña de Preparacion Documental" />',
	'<s:message code="app.informacion" text="**Informacion" />');

//Ext.Msg.show({title:'<s:message code="app.informacion" text="**Información" />',
//	msg:'<s:message code="plugin.precontencioso.redireccion" text="**Se va a redirigir a la pestaña de Preparacion Documental" />', 
//	icon:Ext.MessageBox.WARNING});

app.abreProcedimientoTab(data.id
						, '<s:message text="titicaca" javaScriptEscape="true" />'
	 					, 'precontencioso');
	 					
page.fireEvent(app.event.CANCEL);
//mask.hide();


</fwk:page>