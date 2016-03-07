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

//mostramos el boton guardar cuando la tarea no esta terminada y cuando no hay errores de validacion
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){
				}
			});
		}
	});
	
	//Si tiene mass items que el propio label de descripcion se crea el boton guardar
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
	
	//Si tiene mas items que el propio label de descripcion se crea el boton guardar
	if (items.length > 1)	{
		bottomBar.push(btnGuardar);
	}
}

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/botonCancelar.jsp" %>

var conflicto = items[1];
var aceptacion = items[2];
var fecha_aceptacion = items[4];

//Conflicto intereses
var diccionarioRecord = Ext.data.Record.create([
	{name : 'id'}
	,{name : 'codigo'}
	,{name : 'descripcion'}
]);

var dsConflictos = page.getStore({
	flow : 'subasta/getDiccionario'
	,storeId : 'sinoStore'
	,reader : new Ext.data.JsonReader({
		root : 'diccionario'
	},diccionarioRecord)
});

dsConflictos.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDSiNo'});

items[1] = new Ext.form.ComboBox({
						name:conflicto.name
						,hiddenName:conflicto.name
						,disabled:conflicto.disabled
						,value:conflicto.value
						,allowBlank : true
						,store:dsConflictos
						,displayField:'descripcion'
						,valueField:'codigo'
						,mode: 'local'
						,emptyText:''
						,triggerAction: 'all'
						,fieldLabel : '<s:message code="plugin.precontencioso.registrar.aceptacion.asunto.conflicto" text="**Conflicto intereses" />'
				});

conflicto = items[1];

var dsAceptacion = page.getStore({
	flow : 'subasta/getDiccionario'
	,storeId : 'sinoStore'
	,reader : new Ext.data.JsonReader({
		root : 'diccionario'
	},diccionarioRecord)
});

dsAceptacion.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDSiNo'});
					
items[2] = new Ext.form.ComboBox({
							name:aceptacion.name
							,hiddenName:aceptacion.name
							,disabled:aceptacion.disabled
							,value:aceptacion.value
							,allowBlank : true
							,store:dsAceptacion
							,displayField:'descripcion'
							,valueField:'codigo'
							,mode: 'local'
							,emptyText:''
							,triggerAction: 'all'
							,fieldLabel : '<s:message code="plugin.precontencioso.registrar.aceptacion.asunto.aceptacionAsunto" text="**Aceptación asunto" />'
					});

aceptacion = items[2];

conflicto.on('select', function(){
	if(conflicto.getValue() == 'S'){
		aceptacion.setValue('N');
	}else{
		aceptacion.setValue('');
	}
});

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/panelEdicion.jsp" %>

page.add(panelEdicion);

</fwk:page>