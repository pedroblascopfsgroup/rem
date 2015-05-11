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
	<c:if test="${item.nombre=='tipoProcedimiento' || item.nombre=='tipoPropuestoEntidad'}">
		values = {"diccionario":[{"codigo":"P01","descripcion":"P. hipotecario"},{"codigo":"P02","descripcion":"P. Monitorio"},{"codigo":"P03","descripcion":"P. ordinario"},{"codigo":"P04","descripcion":"P. verbal"},{"codigo":"P15","descripcion":"P. Ej. de título no judicial"},{"codigo":"P16","descripcion":"P. Ej. de Título Judicial"},{"codigo":"P17","descripcion":"P. cambiario"},{"codigo":"P24","descripcion":"T. fase común ordinario"},{"codigo":"P412","descripcion":"T. fase común abreviado"},{"codigo":"P55","descripcion":"P. solicitud de concurso necesario"}]};
	</c:if>
	<c:if test="${item.nombre=='tipoPropuestoEntidad'}">
		
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
			values = {"diccionario":[{"codigo":"P15","descripcion":"P. Ej. de título no judicial"}]};
		</c:if>
		<c:if test="${item.value=='P16'}">
			values = {"diccionario":[{"codigo":"P16","descripcion":"P. Ej. de Título Judicial"}]};
		</c:if>
		<c:if test="${item.value=='P17'}">
			values = {"diccionario":[{"codigo":"P17","descripcion":"P. cambiario"}]};
		</c:if>
		<c:if test="${item.value=='P24'}">
			values = {"diccionario":[{"codigo":"P24","descripcion":"T. fase común ordinario"}]};
		</c:if>
		<c:if test="${item.value=='P412'}">
			values = {"diccionario":[{"codigo":"P412","descripcion":"T. fase común abreviado"}]};
		</c:if>
		<c:if test="${item.value=='P55'}">
			values = {"diccionario":[{"codigo":"P55","descripcion":"P. solicitud de concurso necesario"}]};
		</c:if>
		<c:if test="${item.value==''}">
			values = {"diccionario":[]};
		</c:if>
	</c:if>
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
var fechaDocumentacion = items[1 + offset];
var comboDocCompleta = items[2 + offset];
var fechaEnvio = items[3 + offset];
var tipoProcedimientoOriginal = items[4 + offset];
var tipoProcedimiento = items[5 + offset];
fechaDocumentacion.setMaxValue(new Date());
tipoProcedimientoOriginal.setReadOnly(true);

comboDocCompleta.on('select', function(){
	//Borramos todos los combos dependientes ante cualquier cambio
	fechaEnvio.setValue('');
	tipoProcedimiento.setValue('');
	if(comboDocCompleta.getValue() == '01') {//si
		fechaEnvio.setDisabled(true);
		tipoProcedimiento.setDisabled(false);
	}
	else if(comboDocCompleta.getValue() == '02') {//no
		fechaEnvio.setDisabled(false);
		tipoProcedimiento.setDisabled(true);
	}
});

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