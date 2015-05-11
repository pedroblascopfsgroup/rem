<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
var descripcion = app.creaText('descripcion','<s:message code="" text="**Descripcion" />','Prioritario',{width:230});

var plazos = {plazos :[	
	{estado: 'Periodo de carencia', plazo : '10',perfilgestor:'Oficina',perfilsupervisor:'Resp. Zona Recuperaciones',automatico:'Si',telecobro:'No'}
	,{estado: 'Gestion de Vencidos', plazo : '15',perfilgestor:'Oficina',perfilsupervisor:'Resp. Zona Recuperaciones',automatico:'Si',telecobro:'Si'}
	,{estado: 'Decision Comite', plazo : '10',perfilgestor:'Comite',perfilsupervisor:'Supervisor Comite',automatico:'No',telecobro:'No'}
	
	]};

var plazosStore = new Ext.data.JsonStore({
	data : plazos
	,root : 'plazos'
	,fields : ['estado', 'plazo','perfilgestor','perfilsupervisor','automatico','telecobro']
});
var plazosCm = new Ext.grid.ColumnModel([
	{header : '<s:message code="itinerarios.plazosgrid.estado" text="**estado"/>', dataIndex : 'estado' }
	,{header : '<s:message code="itinerarios.plazosgrid.plazo" text="**plazo"/>', dataIndex : 'plazo' ,align:'right'}
	,{header : '<s:message code="itinerarios.plazosgrid.perfilgestor" text="**perfil gestor"/>', dataIndex : 'perfilgestor' }
	,{header : '<s:message code="itinerarios.plazosgrid.perfilsupervisor" text="**perfil supervisor"/>', dataIndex : 'perfilsupervisor' }
	,{header : '<s:message code="itinerarios.plazosgrid.automatico" text="**automatico"/>', dataIndex : 'automatico' }
	,{header : '<s:message code="itinerarios.plazosgrid.telecobro" text="**telecobro"/>', dataIndex : 'telecobro' }
]);

var cfgPlazos={
	title:'<s:message code="itinerarios.plazosgrid.titulo" text="**Configuracion estados/plazos"/>'
	,store: plazosStore
	,cm: plazosCm
	,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
	,width:350
	//,style:'padding-bottom:30px,padding-top:20px'
	//,height:200
	,autoHeight:true
	//,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	,viewConfig:{forceFit:true}
	//,monitorResize:true

};

var plazosGrid = new Ext.grid.GridPanel(cfgPlazos);


var arquetipos={"diccionario":[
	{"codigo":"1","descripcion":"Lista Blanca"}
	,{"codigo":"2","descripcion":"Empleados/Consejeros"}
	,{"codigo":"3","descripcion":"Hipoteca inmig."}
	,{"codigo":"4","descripcion":"Reincidentes > 5"}
	,{"codigo":"5","descripcion":"Importes Pequeños sin gestion"}]};
	
var comboArquetipos = app.creaDblSelect(arquetipos, '<s:message code="itinerarios.arquetipos" text="**Arquetipos" />',{height:200,width:200,style:'padding-top:10px'});

var btnGuardar = new Ext.Button({
	text : '<s:message code="app.guardar" text="**Guardar" />'
	,iconCls : 'icon_ok'
	,handler : function(){
		page.fireEvent(app.event.DONE);		
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
	,bodyStyle:'padding:10px'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errL' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,items:[descripcion, comboArquetipos]
					,columnWidth:.5
				}
			]
		}
		,plazosGrid
		
	]
	,bbar:[btnGuardar,btnCancelar]
});
page.add(panelEdicion);
</fwk:page>