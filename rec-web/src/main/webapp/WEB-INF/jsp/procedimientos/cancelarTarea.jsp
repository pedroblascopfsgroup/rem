<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

/*
var creaElemento = function(nombre,index,type,label,value,values){
	var name='values['+(index)+']';
	switch(type) {
		case 'textarea' :
			return app.crearTextArea(label, value, false, null, name, {width:'150px'});
			break;
		case 'text' :
			return app.creaText(name, label, value );
			break;
		case 'number' :
		case 'currency' :
			return app.creaNumber(name, label, value );
			break;
		case 'date' :
			value = value.replace(/(\d*)-(\d*)-(\d*)/,"$3/$2/$1");  //conversión de yyyy-MM-dd a dd/MM/yyyy
			return new Ext.ux.form.XDateField({fieldLabel:label, name:name, value:value});
			break;
		case 'combo' :
			return app.creaCombo({name:name, fieldLabel:label, value:value, data:values, width:'60px'});
			break;
		case 'label' :
 			return { html:label, border:false};
			break;
	}
};
*/



var texto = { html : '<s:message code="${tarea.tareaProcedimiento.alertVueltaAtras}" text="**${tarea.tareaProcedimiento.alertVueltaAtras}" />', border:false, bodyStyle:'color:red;margin-bottom:5px'};

//items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '${item.label}', '${item.value}', values));


var bottomBar = [];

var btnAceptar = new Ext.Button({
	text : '<s:message code="app.aceptar" text="**Aceptar" />'
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

bottomBar.push(btnAceptar);


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
					,items:texto
					//,columnWidth:.5
				}
			]
		}
	]
	,bbar:bottomBar
});
page.add(panelEdicion);
</fwk:page>