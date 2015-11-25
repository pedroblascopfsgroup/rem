<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

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
      			return /[0-9]{5}\/[0-9]{4}$/.test(v)? true : '<s:message code="genericForm.validacionProcedimiento" text="**Debe introducir un n˙mero con formato xxxxx/xxxx" />';
    		}			
			return text;
			break;
		case 'number' :
		case 'currency':
			return app.creaNumber(name, label, value ); 
			break;
		case 'date' :
			value = value.replace(/(\d*)-(\d*)-(\d*)/,"$3/$2/$1");  //conversiÛn de yyyy-MM-dd a dd/MM/yyyy
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
var offset=0;

<c:if test="${form.errorValidacion!=null}">
	items.push({ html : '<s:message code="${form.errorValidacion}" text="${form.errorValidacion}" />', border:false, bodyStyle:'color:red;margin-bottom:5px'});
	offset=1;
</c:if>

var values;
<c:forEach items="${form.items}" var="item">
values = <app:dict value="${item.values}" />;
items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '${item.label}', '${item.value}', values));
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

</c:if>

var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);
	}
});
bottomBar.push(btnCancelar);

// *************************************************************** //
// ***  A—AÅDIMOS LAS FUNCIONALIDADES EXTRA DE ESTE FORMULARIO  *** //
// *************************************************************** //

	// grid con el listado de todos los demandados
	<pfs:defineParameters name="params" paramId="${idProcedimiento}"/>
	
	<pfs:defineRecordType name="DemandadosRT">
		<pfs:defineTextColumn name="idCliente"/>
		<pfs:defineTextColumn name="nombre"/>
		<pfs:defineTextColumn name="ultimaFechaReqPago"/>
		<pfs:defineTextColumn name="direccionReqPago"/>
		<pfs:defineTextColumn name="fechaReqPago"/>
	</pfs:defineRecordType>
	
	 
	<pfs:remoteStore name="storeDemandados" 
		dataFlow="msvprocedimientosmasivo/listaDemandadosProcedimientoData"
		resultRootVar="demandados" 
		recordType="DemandadosRT" 
		parameters="params"
		autoload="true"/>
		
	var direccionReqPago_edit = new Ext.form.TextField();
	var fechaReqPago_edit = new Ext.form.DateField();	
	
	
	var grid = new Ext.grid.EditorGridPanel({
		title: '<s:message code="plugin.masivo.confirmarReqPrevioTodosDemandados.editar.titulo" text="**Lista de demandados" />',
		stripeRows: true,
		resizable:true, 
		autoHeight: true,z
		cls:'cursor_pointer',
		clickstoEdit: 1,
		store: storeDemandados,
		columns: [
			{header: '<s:message code="plugin.masivo.confirmarReqPrevioTodosDemandados.nombre" text="**Nombre" />', dataIndex: 'nombre'},
			{header: '<s:message code="plugin.masivo.confirmarReqPrevioTodosDemandados.ultimaFechaReqPago" text="**Ultima fecha requerimiento" />', dataIndex: 'ultimaFechaReqPago'},
			{header: '<s:message code="plugin.masivo.confirmarReqPrevioTodosDemandados.direccion" text="**DirecciÛn" />', dataIndex:'direccionReqPago', editor: direccionReqPago_edit},
			{header: '<s:message code="plugin.masivo.confirmarReqPrevioTodosDemandados.fechaReqPago" text="**Fecha requerimiento pago" />', dataIndex: 'fechaReqPago',editor: fechaReqPago_edit}
			]
	});
	
	
	grid.modifiedData={};
	grid.on('afteredit', function(editEvent){
		grid.modifiedData['dto['+editEvent.row+'].'+editEvent.field]= editEvent.value;
	});
	
	items[offset] = grid;

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
			,items:[
					{
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