<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

var tipo_wf='${tipoWf}'
var creaElemento = function(index,type,label,value,values){
	var name='values['+index+']';
	switch(type) {
		case 'text' :
			return app.creaText(name, label, value );
			break;
		case 'number' :
			return app.creaNumber(name, label, value );
			break;
		case 'date' :
			return new Ext.ux.form.XDateField({fieldLabel:label, name:name, value:value});
			break;
		case 'combo' :
			return app.creaCombo({name:name, fieldLabel:label, value:value, data:values});
			break;
		case 'label' :
 			return { html:value, border:false};
			break;
	}
};

var items=[];
var values;
<c:forEach items="${form.items}" var="item">
values = null;
<c:if test="${item.values!=null}">
	values = <app:dict value="${item.values}" />;
</c:if>
items.push(creaElemento('${item.order}','${item.type}', '<s:message code="${item.label}" text="**dummy" />', '${item.value}', values));
</c:forEach>

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

var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);
	}

});
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
					,items:items
					//,columnWidth:.5
				}
			]
		}
	]
	,bbar:[btnGuardar,btnCancelar]
});
page.add(panelEdicion);
</fwk:page>