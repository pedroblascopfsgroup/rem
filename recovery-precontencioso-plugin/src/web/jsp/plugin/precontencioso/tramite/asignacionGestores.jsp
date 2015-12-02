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
var tipo_wf='${tipoWf}';
var bottomBar = [];

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/elementos.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/precontencioso/items.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/precontencioso/botonExportar.jsp" %>

//mostramos el botón guardar cuando la tarea no está terminada y cuando no hay errores de validacion
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){
					var a;
				}
			});
		}
	});
	
	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)
	{
		bottomBar.push(btnGuardar);
	}
	muestraBotonGuardar = 0;
</c:if>

if (muestraBotonGuardar==1){
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){}
			});
		}
	});
	
	//Si tiene mï¿½s items que el propio label de descripciï¿½n se crea el botï¿½n guardar
	if (items.length > 1)	{
		bottomBar.push(btnGuardar);
	}
}

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/botonCancelar.jsp" %>

<c:if test="${form.tareaExterna.tareaProcedimiento.descripcion=='Dictar Instrucciones'}">
	bottomBar.push(btnExportarPDF);
</c:if>
	
	var dsProcedimientos = new Ext.data.Store({
		autoLoad:true,
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('expedientejudicial/getTiposProcedimientoAsignacionDeGestores')
		}),
		reader: new Ext.data.JsonReader({
			root: 'listadoProcedimientos'
			,totalProperty: 'total'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});

for(i=0;i < items.length; i++){
	if(items[i].nombre == "procPropuesto"){
		items[i] = new Ext.form.ComboBox({
							name:items[i].name
							,hiddenName:items[i].name
							,disabled:items[i].disabled
							,value:items[i].value
							,data:items[i].values
							,allowBlank : false
							,store:dsProcedimientos
							,displayField:'descripcion'
							,valueField:'codigo'
							,mode: 'local'
							,emptyText:'----'
							,triggerAction: 'all'
							,fieldLabel : '<s:message code="plugin.precontencioso.asignar.gestor.procedimiento.iniciar" text="**Procedimiento a iniciar" />'
					});
	}
}



<%@ include file="/WEB-INF/jsp/plugin/precontencioso/panelEdicion.jsp" %>

page.add(panelEdicion);

</fwk:page>