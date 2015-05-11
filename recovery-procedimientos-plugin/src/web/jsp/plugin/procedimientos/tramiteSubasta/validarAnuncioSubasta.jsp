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

<%@ include file="/WEB-INF/jsp/plugin/procedimientos/elementos.jsp" %>

var items=[];
var offset=0;
var muestraBotonGuardar = 0;

<c:if test="${form.errorValidacion!=null}">
	items.push({ html : '<s:message code="${form.errorValidacion}" text="${form.errorValidacion}" />', border:false, bodyStyle:'color:red;margin-bottom:5px'});
	offset=1;
	var textError = '${form.errorValidacion}';
	if (textError.indexOf('<div id="permiteGuardar">')>0) {
		<c:if test="${!readOnly}">muestraBotonGuardar=1;</c:if>
	}
</c:if>

var values;
<c:forEach items="${form.items}" var="item">
values = <app:dict value="${item.values}" />;
items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '<s:message text="${item.label}" javaScriptEscape="true" />', '<s:message text="${item.value}" javaScriptEscape="true" />', values));
</c:forEach>


var bottomBar = [];

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
			});
		}
	});
	
	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)	{
		bottomBar.push(btnGuardar);
	}
}


var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);
	}
});
bottomBar.push(btnCancelar);


var fechaAnuncio = items[1 + offset];
var fechaSubasta = items[2 + offset];
var costasLetrado = items[3 + offset];
var costasProcurador = items[4 + offset];
var observaciones = items[5 + offset];
var fechaValidacion = items[6 + offset];
var comboValidacion = items[7 + offset];

fechaAnuncio.setDisabled(true);
fechaSubasta.setDisabled(false);
costasLetrado.setDisabled(true);
costasProcurador.setDisabled(true);
//observaciones.setDisabled(true);
//fechaValidacion.setDisabled(false);
//comboValidacion.setDisabled(false);

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,bodyStyle:'padding:10px;cellspacing:20px'
	//,xtype:'fieldset'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errorList' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			//,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,autoHeight:true
					,items:items
					//,columnWidth:.5
				}
			]
		}
	]
	,bbar:bottomBar
});
page.add(panelEdicion);
</fwk:page>