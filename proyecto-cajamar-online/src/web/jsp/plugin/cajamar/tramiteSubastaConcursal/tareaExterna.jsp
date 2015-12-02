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

var creaElemento = function(nombre,index,type,label,value,values){
	var name='values['+(index)+']';
	switch(type) {
		case 'textarea' :
			return app.crearTextArea(label, value, false, null, name, {width:'440px'});
			break;
		case 'text' :
			return app.creaText(name, label, value );
			break;
		case 'textproc':
			var text = app.creaText(name, label, value );
			text.validator = function(v) {
      			return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : '<s:message code="genericForm.validacionProcedimiento" text="**Debe introducir un número con formato xxxxx/xxxx" />';
    		}			
			return text;
			break;
		case 'number' :
		case 'currency':
			return app.creaNumber(name, label, value ); 
			break;
		case 'date' :
			value = value.replace(/(\d*)-(\d*)-(\d*)/,"$3/$2/$1");  //conversión de yyyy-MM-dd a dd/MM/yyyy
			return new Ext.ux.form.XDateField({fieldLabel:label, name:name, value:value,style:'margin:0px'});
			break;
		case 'combo' :
			return app.creaCombo({name:name, fieldLabel:label, value:value, data:values, width:'60px'});
			break;
		case 'label' :
 			return { html:label, border:false};
			break;
	}
};

var items=[];

<c:if test="${form.errorValidacion!=null}">
	items.push({ html : '<s:message code="${form.errorValidacion}" text="${form.errorValidacion}" />', border:false, bodyStyle:'color:red;margin-bottom:5px'});
</c:if>

var values;
<c:forEach items="${form.items}" var="item">
values = <app:dict value="${item.values}" />;
items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '${item.label}', '${item.value}', values));
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

bottomBar.push(btnGuardar);
</c:if>

var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);
	}
});
bottomBar.push(btnCancelar);

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