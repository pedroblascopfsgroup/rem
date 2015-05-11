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

var fecha = items[1 + offset];
var numProponentes = items[2 + offset];
var totalMasa = items[3 + offset];
var porcenProp = items[4 + offset];
var proponentes = items[5 + offset];
fecha.setValue("${valores['P29_RegistrarPropuestaTerceros']['fecha']}");
numProponentes.setValue("${valores['P29_RegistrarPropuestaTerceros']['numProponentes']}");
totalMasa.setValue("${valores['P29_RegistrarPropuestaTerceros']['totalMasa']}");
porcenProp.setValue("${valores['P29_RegistrarPropuestaTerceros']['porcenProp']}");
proponentes.setValue("${valores['P29_RegistrarPropuestaTerceros']['proponentes']}");
fecha.setDisabled(true);
numProponentes.setDisabled(true);
totalMasa.setDisabled(true);
porcenProp.setDisabled(true);
proponentes.setDisabled(true);

var privilegioEspecial_NO = items[6 + offset];
var privilegioEspecial_PR = items[7 + offset];
var privilegioEspecial_QU = items[8 + offset];
var privilegioEspecial_EM = items[9 + offset];
var privilegioEspecial_DE = items[10 + offset];
privilegioEspecial_NO.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioEspecial_NO']}");
privilegioEspecial_PR.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioEspecial_PR']}");
privilegioEspecial_QU.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioEspecial_QU']}");
privilegioEspecial_EM.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioEspecial_EM']}");
privilegioEspecial_DE.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioEspecial_DE']}");
fecha.setDisabled(true);
numProponentes.setDisabled(true);
totalMasa.setDisabled(true);
porcenProp.setDisabled(true);
proponentes.setDisabled(true);

var privilegioGeneral_NO = items[11 + offset];
var privilegioGeneral_PR = items[12 + offset];
var privilegioGeneral_QU = items[13 + offset];
var privilegioGeneral_EM = items[14 + offset];
var privilegioGeneral_DE = items[15 + offset];
privilegioGeneral_NO.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioGeneral_NO']}");
privilegioGeneral_PR.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioGeneral_PR']}");
privilegioGeneral_QU.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioGeneral_QU']}");
privilegioGeneral_EM.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioGeneral_EM']}");
privilegioGeneral_DE.setValue("${valores['P29_RegistrarPropuestaTerceros']['privilegioGeneral_DE']}");
privilegioGeneral_NO.setDisabled(true);
privilegioGeneral_PR.setDisabled(true);
privilegioGeneral_QU.setDisabled(true);
privilegioGeneral_EM.setDisabled(true);
privilegioGeneral_DE.setDisabled(true);

var creditoOrdinario_NO = items[16 + offset];
var creditoOrdinario_PR = items[17 + offset];
var creditoOrdinario_QU = items[18 + offset];
var creditoOrdinario_EM = items[19 + offset];
var creditoOrdinario_DE = items[20 + offset];
creditoOrdinario_NO.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoOrdinario_NO']}");
creditoOrdinario_PR.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoOrdinario_PR']}");
creditoOrdinario_QU.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoOrdinario_QU']}");
creditoOrdinario_EM.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoOrdinario_EM']}");
creditoOrdinario_DE.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoOrdinario_DE']}");
creditoOrdinario_NO.setDisabled(true);
creditoOrdinario_PR.setDisabled(true);
creditoOrdinario_QU.setDisabled(true);
creditoOrdinario_EM.setDisabled(true);
creditoOrdinario_DE.setDisabled(true);

var creditoSubordinado_NO = items[21 + offset];
var creditoSubordinado_PR = items[22 + offset];
var creditoSubordinado_QU = items[23 + offset];
var creditoSubordinado_EM = items[24 + offset];
var creditoSubordinado_DE = items[25 + offset];
creditoSubordinado_NO.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoSubordinado_NO']}");
creditoSubordinado_PR.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoSubordinado_PR']}");
creditoSubordinado_QU.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoSubordinado_QU']}");
creditoSubordinado_EM.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoSubordinado_EM']}");
creditoSubordinado_DE.setValue("${valores['P29_RegistrarPropuestaTerceros']['creditoSubordinado_DE']}");
creditoSubordinado_NO.setDisabled(true);
creditoSubordinado_PR.setDisabled(true);
creditoSubordinado_QU.setDisabled(true);
creditoSubordinado_EM.setDisabled(true);
creditoSubordinado_DE.setDisabled(true);

var valorOp1_NO = items[27 + offset];
var valorOp1_PR = items[28 + offset];
var valorOp1_QU = items[29 + offset];
var valorOp1_EM = items[30 + offset];
var valorOp1_DE = items[31 + offset];
valorOp1_NO.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp1_NO']}");
valorOp1_PR.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp1_PR']}");
valorOp1_QU.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp1_QU']}");
valorOp1_EM.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp1_EM']}");
valorOp1_DE.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp1_DE']}");
valorOp1_NO.setDisabled(true);
valorOp1_PR.setDisabled(true);
valorOp1_QU.setDisabled(true);
valorOp1_EM.setDisabled(true);
valorOp1_DE.setDisabled(true);

var valorOp2_NO = items[33 + offset];
var valorOp2_PR = items[34 + offset];
var valorOp2_QU = items[35 + offset];
var valorOp2_EM = items[36 + offset];
var valorOp2_DE = items[37 + offset];
valorOp2_NO.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp2_NO']}");
valorOp2_PR.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp2_PR']}");
valorOp2_QU.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp2_QU']}");
valorOp2_EM.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp2_EM']}");
valorOp2_DE.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp2_DE']}");
valorOp2_NO.setDisabled(true);
valorOp2_PR.setDisabled(true);
valorOp2_QU.setDisabled(true);
valorOp2_EM.setDisabled(true);
valorOp2_DE.setDisabled(true);

var valorOp3_NO = items[39 + offset];
var valorOp3_PR = items[40 + offset];
var valorOp3_QU = items[41 + offset];
var valorOp3_EM = items[42 + offset];
var valorOp3_DE = items[43 + offset];
valorOp3_NO.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp3_NO']}");
valorOp3_PR.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp3_PR']}");
valorOp3_QU.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp3_QU']}");
valorOp3_EM.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp3_EM']}");
valorOp3_DE.setValue("${valores['P29_RegistrarPropuestaTerceros']['valorOp3_DE']}");
valorOp3_NO.setDisabled(true);
valorOp3_PR.setDisabled(true);
valorOp3_QU.setDisabled(true);
valorOp3_EM.setDisabled(true);
valorOp3_DE.setDisabled(true);

var obsAnteriores = items[44];
obsAnteriores.setValue("${valores['P29_RegistrarPropuestaTerceros']['observaciones']}");
obsAnteriores.setDisabled(true);

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
					,items:[items[0 + offset], items[1 + offset], items[2 + offset], items[3 + offset], items[4 + offset], items[5 + offset], {
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
							 		items[26], items[32], items[38]
							]}
							,{border:false
							 ,width: 59
							 ,bodyStyle:'font-size: 8pt; font-family: Arial; line-height:22px;'
							 ,items:[
								{ html:"<b title='N˙mero de operaciones'> Opes. </b>", border:false}
								,items[6 + offset]
								,items[11 + offset]
								,items[16 + offset]
								,items[21 + offset]
								,items[27 + offset]
								,items[33 + offset]
								,items[39 + offset]
							]}
							,{border:false
							 ,width: 59
							 ,bodyStyle:'font-size: 8pt; font-family: Arial; line-height:22px '
							 ,items:[
								{ html:"<b title='Importe principal'> Principal </b>", border:false}
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
								{ html:"<b title='Porcentaje de Quita'> % Quita </b>", border:false}
								,items[8 + offset]
								,items[13 + offset]
								,items[18 + offset]
								,items[23 + offset]
								,items[29 + offset]
								,items[35 + offset]
								,items[41 + offset]
							]}
							,{border:false
							  ,width: 60
							  ,bodyStyle:'font-size: 8pt; font-family: Arial;  line-height:22px '
							  ,items:[
								{ html:"<b title='Tiempo de espera en meses'>Espera</b>", border:false}
								,items[9 + offset]
								,items[14 + offset]
								,items[19 + offset]
								,items[24 + offset]
								,items[30 + offset]
								,items[36 + offset]
								,items[42 + offset]
							]}
							,{border:false
							  ,bodyStyle:'font-size: 8pt; font-family: Arial;  line-height:22px '
							  ,items:[
								{ html:"<b> Descripci&oacute;n</b>", border:false}
								,items[10 + offset]
								,items[15 + offset]
								,items[20 + offset]
								,items[25 + offset]
								,items[31 + offset]
								,items[37 + offset]
								,items[43 + offset]
							]}
						]
					}, items[44 + offset], items[45 + offset], items[46 + offset], items[47 + offset]]
				}
			]
		}
	]
	,bbar:bottomBar
});
page.add(panelEdicion);
</fwk:page>