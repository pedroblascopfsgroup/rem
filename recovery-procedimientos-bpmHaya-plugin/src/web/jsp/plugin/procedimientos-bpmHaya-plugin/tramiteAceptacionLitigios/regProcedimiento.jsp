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
	items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '<s:message text="${item.label}" javaScriptEscape="true" />', '<s:message text="${item.value}" javaScriptEscape="true" />', values));
</c:forEach>


var bottomBar = [];

//mostramos el bot贸n guardar cuando la tarea no est谩 terminada y cuando no hay errores de validacion
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
	
	//Si tiene m谩s items que el propio label de descripci贸n se crea el bot贸n guardar
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
	
	//Si tiene m谩s items que el propio label de descripci贸n se crea el bot贸n guardar
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

// *************************************************************** //
// ***  A袮DIMOS LAS FUNCIONALIDADES EXTRA DE ESTE FORMULARIO  *** //
// *************************************************************** //
	var procedimientosStore = page.getStore({
	       remoteSort:false
	       ,id:'procedimientosStore'
	       ,flow:'asignaciongestores/listTipoProcedimiento'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'tiposProcedimiento',fields:[
             {name: 'codigo'}
             ,{name: 'descripcion'}
         ]
	    })	       
	});
	
	var tipoPropuestoEntidad = items[4 + offset];
	tipoPropuestoEntidad.readOnly = true;
	items[4 + offset] = tipoPropuestoEntidad;
	
	if(btnGuardar == null){		
		var tipoProcedimiento = items[5 + offset];
		//comboProcedimientos.store = procedimientosStore;
		//Ext.onReady(function() {
		//	comboProcedimientos.store.webflow({idAsunto:"${form.tareaExterna.tareaPadre.asunto.id}"});		
		//});
		//comboProcedimientos.store.on('load',function(){
		//	comboProcedimientos.setValue(comboProcedimientos.getValue());			
		//});	
		tipoProcedimiento.readOnly = true;
		items[5 + offset] = tipoProcedimiento;
	} else{		
		var comboProcedimientos = new Ext.form.ComboBox({
			store: procedimientosStore
			,hiddenName: items[5 + offset].hiddenName
			,displayField: items[5 + offset].displayField
			,valueField: items[5 + offset].valueField
			,mode: items[5 + offset].mode
			,editable: items[5 + offset].editable
			,emptyText:''
			,width: 300
			,resizable: true		
			,triggerAction: 'all'
			,fieldLabel : items[5 + offset].fieldLabel
		});
		Ext.onReady(function() {
			comboProcedimientos.store.webflow({idAsunto:"${form.tareaExterna.tareaPadre.asunto.id}"});
		});
			
		items[5 + offset] = comboProcedimientos;
	}


var fechaDocumentacion = items[1 + offset];
var comboDocCompleta = items[2 + offset];
var fechaEnvio = items[3 + offset];
var tipoProcedimiento = items[5 + offset];
fechaDocumentacion.setMaxValue(new Date());


comboDocCompleta.on('select', function(){
	//Borramos todos los combos dependientes ante cualquier cambio
	fechaEnvio.setValue('');
	tipoProcedimiento.setValue('');
	if(comboDocCompleta.getValue() == '01') {//si
		fechaEnvio.setDisabled(true);
		tipoProcedimiento.setDisabled(false);
		tipoProcedimiento.allowBlank = false;
	}
	else if(comboDocCompleta.getValue() == '02') {//no
		fechaEnvio.setDisabled(false);
		tipoProcedimiento.setDisabled(true);
		tipoProcedimiento.allowBlank = true;
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