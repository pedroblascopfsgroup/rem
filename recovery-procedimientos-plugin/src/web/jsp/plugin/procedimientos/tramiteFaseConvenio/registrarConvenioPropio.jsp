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

//mostramos el botÛn guardar cuando la tarea no est· terminada y cuando no hay errores de validacion
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
	
	//Si tiene m·s items que el propio label de descripciÛn se crea el botÛn guardar
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
	
	//Si tiene m·s items que el propio label de descripciÛn se crea el botÛn guardar
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
// ***  A–ÅDIMOS LAS FUNCIONALIDADES EXTRA DE ESTE FORMULARIO  *** //
// *************************************************************** //

var valorOp1 = items[25 + offset];
valorOp1.hideLabel = true;
var valorOp2 = items[31 + offset];
valorOp2.hideLabel = true;
var valorOp2 = items[37 + offset];
valorOp2.hideLabel = true;

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,width:700
	,bodyStyle:'padding:10px;cellspacing:20px'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errorList' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,autoHeight:true
					,layoutConfig:{columns:1}
					,items:[items[0 + offset], items[1 + offset], items[2 + offset], items[3 + offset], items[4 + offset], {
						layout:'table'
						,layoutConfig:{columns:6}
						,border:false
						,items:[
							{ layout:'form'
							 ,autoHeight:true
							 ,border:false
							 ,width: 180
							 ,bodyStyle:'padding:0px; cellspacing:0px; font-size: 8pt; font-family: Arial; height:140px; line-height:21px; margin-bottom: 10px; margin-top: 20px;'
							 ,items:[
							 		{ html:"<b> Tipo </b>", border:false},
							 		{ html:"Privilegio especial:", border:false},
							 		{ html:"Privilegio general:", border:false},
							 		{ html:"Cr&eacute;dito ordinario:", border:false},
							 		{ html:"Cr&eacute;dito subordinado:", border:false},
							 		items[25], items[31], items[37]
							]}
							,{border:false
							 ,width: 59
							 ,bodyStyle:'font-size: 8pt; font-family: Arial; line-height:22px;'
							 ,items:[
								{ html:"<b title='N˙mero de operaciones'> Opes. </b>", border:false}
								,items[5 + offset]
								,items[10 + offset]
								,items[15 + offset]
								,items[20 + offset]
								,items[26 + offset]
								,items[32 + offset]
								,items[38 + offset]
							]}
							,{border:false
							 ,width: 59
							 ,bodyStyle:'font-size: 8pt; font-family: Arial; line-height:22px '
							 ,items:[
								{ html:"<b title='Importe principal'> Principal </b>", border:false}
								,items[6 + offset]
								,items[11 + offset]
								,items[16 + offset]
								,items[21 + offset]
								,items[27 + offset]
								,items[33 + offset]
								,items[39 + offset]
							]}
							,{border:false
							  ,width: 60
							  ,bodyStyle:'font-size: 8pt; font-family: Arial;  line-height:22px '
							  ,items:[
								{ html:"<b title='Porcentaje de Quita'> % Quita </b>", border:false}
								,items[7 + offset]
								,items[12 + offset]
								,items[17 + offset]
								,items[22 + offset]
								,items[28 + offset]
								,items[34 + offset]
								,items[40 + offset]
							]}
							,{border:false
							  ,width: 60
							  ,bodyStyle:'font-size: 8pt; font-family: Arial;  line-height:22px '
							  ,items:[
								{ html:"<b title='Tiempo de espera en meses'>Espera</b>", border:false}
								,items[8 + offset]
								,items[13 + offset]
								,items[18 + offset]
								,items[23 + offset]
								,items[29 + offset]
								,items[35 + offset]
								,items[41 + offset]
							]}
							,{border:false
							  ,bodyStyle:'font-size: 8pt; font-family: Arial;  line-height:22px '
							  ,items:[
								{ html:"<b> Descripci&oacute;n</b>", border:false}
								,items[9 + offset]
								,items[14 + offset]
								,items[19 + offset]
								,items[24 + offset]
								,items[30 + offset]
								,items[36 + offset]
								,items[42 + offset]
							]}
						]
					}, items[43 + offset]]
				}
			]
		}
	]
	,bbar:bottomBar
});
page.add(panelEdicion);
</fwk:page>