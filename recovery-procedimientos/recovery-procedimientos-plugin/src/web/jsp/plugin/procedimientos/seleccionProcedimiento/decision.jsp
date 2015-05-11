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
	var textError = '${form.errorValidacion}';
	if (textError.indexOf('<div id="permiteGuardar">')>0) {
		muestraBotonGuardar=1;
	}
</c:if>

var values;
var tipoProcedimiento = '';

<c:forEach items="${form.items}" var="item">
	values = <app:dict value="${item.values}" />; 
	<c:if test="${item.nombre=='tipoProcedimiento'}">
		values = {"diccionario":[{"codigo":"P01","descripcion":"P. hipotecario"},{"codigo":"P02","descripcion":"P. Monitorio"},{"codigo":"P03","descripcion":"P. ordinario"},{"codigo":"P04","descripcion":"P. verbal"},{"codigo":"P15","descripcion":"P. Ej. de t�tulo no judicial"},{"codigo":"P16","descripcion":"P. Ej. de T�tulo Judicial"},{"codigo":"P17","descripcion":"P. cambiario"},{"codigo":"P24","descripcion":"T. fase com�n ordinario"},{"codigo":"P56","descripcion":"T. fase com�n abreviado"},{"codigo":"P55","descripcion":"P. solicitud de concurso necesario"}]};
	</c:if>
	<c:if test="${item.nombre=='tipoProcPropuesto'}">
		
		<c:if test="${item.value=='P01'}">
			values = {"diccionario":[{"codigo":"P01","descripcion":"P. hipotecario"}]};
		</c:if>
		<c:if test="${item.value=='P02'}">
			values = {"diccionario":[{"codigo":"P02","descripcion":"P. Monitorio"}]};
		</c:if>
		<c:if test="${item.value=='P03'}">
			values = {"diccionario":[{"codigo":"P03","descripcion":"P. ordinario"}]};
		</c:if>
		<c:if test="${item.value=='P04'}">
			values = {"diccionario":[{"codigo":"P04","descripcion":"P. verbal"}]};
		</c:if>
		<c:if test="${item.value=='P15'}">
			values = {"diccionario":[{"codigo":"P15","descripcion":"P. Ej. de t�tulo no judicial"}]};
		</c:if>
		<c:if test="${item.value=='P16'}">
			values = {"diccionario":[{"codigo":"P16","descripcion":"P. Ej. de T�tulo Judicial"}]};
		</c:if>
		<c:if test="${item.value=='P17'}">
			values = {"diccionario":[{"codigo":"P17","descripcion":"P. cambiario"}]};
		</c:if>
		<c:if test="${item.value=='P24'}">
			values = {"diccionario":[{"codigo":"P24","descripcion":"T. fase com�n ordinario"}]};
		</c:if>
		<c:if test="${item.value=='P56'}">
			values = {"diccionario":[{"codigo":"P56","descripcion":"T. fase com�n abreviado"}]};
		</c:if>
		<c:if test="${item.value==''}">
			values = {"diccionario":[]};
		</c:if>
		
		
	</c:if>
	items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '<s:message text="${item.label}" javaScriptEscape="true" />', '<s:message text="${item.value}" javaScriptEscape="true" />', values));
</c:forEach>


var bottomBar = [];

//mostramos el bot�n guardar cuando la tarea no est� terminada y cuando no hay errores de validacion
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
	
	//Si tiene m�s items que el propio label de descripci�n se crea el bot�n guardar
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
	
	//Si tiene m�s items que el propio label de descripci�n se crea el bot�n guardar
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
var vPrincipal = items[1 + offset];
var vPlazo = items[2 + offset];
var vRecuperacion = items[3 + offset];

vPrincipal.setMinValue(1);
vPlazo.setMinValue(1);
vRecuperacion.setMaxValue(100);
vRecuperacion.setMinValue(1);

//vPrincipal.setReadOnly(true);
//vPlazo.setReadOnly(true);
//vRecuperacion.setReadOnly(true);

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,width:700
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