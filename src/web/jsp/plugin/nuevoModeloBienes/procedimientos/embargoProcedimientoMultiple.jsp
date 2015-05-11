<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<fwk:page>
var idProcedimiento = '${idProcedimiento}';
var idAsunto = '${idAsunto}';


var dateRenderer = Ext.util.Format.dateRenderer('d/m/Y');

var dateEditor = new Ext.form.DateField({
	format: 'd/m/y'
});

var numberEditor = new Ext.form.NumberField({
     minValue: 0     
});

var textEditor = new Ext.form.TextField({
     
});

/***********************************
Definimos el store de EMBARGOS
************************************/
var recordEmbargo = Ext.data.Record.create([
	{name: 'id'},
	{name: 'idProcedimiento'},
	{name: 'idEmbargo'},
	{name: 'descripcion'},
	{name: 'tipo'},
	{name: 'observaciones'},
	{name: 'fechaSolicitud',type: 'date',dateFormat: 'c'},
	{name: 'fechaDecreto',type: 'date',dateFormat: 'c'},
	{name: 'fechaRegistro',type: 'date',dateFormat: 'c'},
	{name: 'fechaDenegacion',type: 'date',dateFormat: 'c'},
	{name: 'importeValor'},
	{name: 'letra'},
	{name: 'importeAval'},
	{name: 'fechaAval',type: 'date',dateFormat: 'c'},
	{name: 'importeTasacion'},
	{name: 'fechaTasacion',type: 'date',dateFormat: 'c'},
	{name: 'importeAdjudicacion'},
	{name: 'fechaAdjudicacion',type: 'date',dateFormat: 'c'}
]);
    
var recordEmbargoStore = page.getStore({
	id: 'recordEmbargo'
	,flow:'editbien/getEmbargoProcedimientoMultiple'
	,reader: new Ext.data.JsonReader({
  		root : 'listado'
	} , recordEmbargo)
});

recordEmbargoStore.webflow({idProcedimiento: idProcedimiento, idAsunto: idAsunto});

var embargoCM = new Ext.grid.ColumnModel([
	{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.idProcedimiento" text="**Id Procedimiento" />', dataIndex : 'idProcedimiento' , hidden:true}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.idBien" text="**idBien" />', dataIndex : 'id',sortable:true, width: 75, hidden:true}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.idEmbargo" text="**idEmbargo" />', dataIndex : 'idEmbargo',sortable:true, width: 75, hidden:true}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.tipo" text="**Tipo" />', dataIndex : 'tipo' ,sortable:true, width: 100}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.descripcion" text="**Descripcion" />', dataIndex : 'descripcion' ,sortable:true, hidden:false, width: 100}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.observaciones" text="**Observaciones" />', dataIndex : 'observaciones' ,sortable:true, hidden:true, width: 100}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.fechaCertificacion" text="**F.Certificacion" />', dataIndex : 'fechaSolicitud',sortable:true, renderer: dateRenderer, editor: dateEditor, width: 100}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.fechaDecreto" text="**F.Decreto" />', dataIndex : 'fechaDecreto' ,sortable:true, hidden:false, width: 100, renderer: dateRenderer, editor: dateEditor}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.fechaRegistro" text="**F.Registro" />', dataIndex : 'fechaRegistro' ,sortable:true, hidden:false, renderer: dateRenderer, editor: dateEditor, width: 100}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.fechaDenegacion" text="**F.Denegacion" />', dataIndex : 'fechaDenegacion',sortable:true, width: 100, renderer: dateRenderer, editor: dateEditor}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.importeTotal" text="**Importe Total" />', dataIndex : 'importeValor',sortable:true, width: 75, editor: numberEditor,renderer: app.format.moneyRenderer}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.letra" text="**Letra" />', dataIndex : 'letra',sortable:true, width: 75, editor: textEditor}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.importeAvaluo" text="**Importe Avaluo" />', dataIndex : 'importeAval',sortable:true, width: 75, editor: numberEditor,renderer: app.format.moneyRenderer}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.fechaAvaluo" text="**F.Avaluo" />', dataIndex : 'fechaAval',sortable:true, width: 100, renderer: dateRenderer, editor: dateEditor}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.importeTasacion" text="**Importe Tasacion" />', dataIndex : 'importeTasacion',sortable:true, width: 75, editor: numberEditor,renderer: app.format.moneyRenderer}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.fechaTasacion" text="**F.Tasacion" />', dataIndex : 'fechaTasacion',sortable:true, width: 75, renderer: dateRenderer, editor: dateEditor}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.importeAdjudicacion" text="**Importe Adjudicacion" />', dataIndex : 'importeAdjudicacion',sortable:true, width: 75, editor: numberEditor,renderer: app.format.moneyRenderer}
	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.fechaAdjudicacion" text="**F.Adjudicacion" />', dataIndex : 'fechaAdjudicacion',sortable:true, width: 75, renderer: dateRenderer, editor: dateEditor}
]);

var embargoGrid = new Ext.grid.EditorGridPanel({
	store: recordEmbargoStore
	,cm: embargoCM	
    ,title: '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.titulo" text="**Marcado bienes" />'
    ,height: 300
    ,width: 810
    ,clicksToEdit: 1
    ,style:'padding-bottom: 10px;'
    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
}); 


var enviaUpdate = function(record, field, value) {
	record.commit(false);
    var params = getParametros(record);
	var existe = record.get('idEmbargo');
	Ext.Ajax.request({
	   	url:'/'+app.getAppName()+'/editbien/saveEmbargo.htm'
	    ,params:params
	    ,success: function(response, opt) {
	    	if (!existe) {
	    		recordEmbargoStore.webflow({idProcedimiento: idProcedimiento, idAsunto: idAsunto});
	    	}
	    }
	    ,failure: function(response, opt) {
	    	Ext.Msg.alert('<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.titulo" text="**Marcado bienes" />','<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.MSGError" text="**Error"/>');
	    }
	});	
	
};

var getParametros = function(record) {
	var param = {};
	param.idBien = record.get('id');
	param.idEmbargo = record.get('idEmbargo');
	param.idProcedimiento = record.get('idProcedimiento');
	param.descripcion = record.get('descripcion');
	param.tipo = record.get('tipo');
	param.observaciones = record.get('observaciones');
	
	
	
	param.fechaSolicitud = (record.get('fechaSolicitud') == null || record.get('fechaSolicitud') == '') ? null : record.get('fechaSolicitud').format('d/m/Y');
	param.fechaDecreto = (record.get('fechaDecreto') == null || record.get('fechaDecreto') == '') ? null : record.get('fechaDecreto').format('d/m/Y');
	param.fechaRegistro = (record.get('fechaRegistro') == null || record.get('fechaRegistro') == '') ? null : record.get('fechaRegistro').format('d/m/Y');
	param.fechaDenegacion = (record.get('fechaDenegacion') == null || record.get('fechaDenegacion') == '') ? null : record.get('fechaDenegacion').format('d/m/Y');

	param.importeValor = record.get('importeValor');
	param.letra = record.get('letra');
	param.importeAval = record.get('importeAval');
	param.fechaAval = (record.get('fechaAval') == null || record.get('fechaAval') == '') ? null : record.get('fechaAval').format('d/m/Y');
	param.importeTasacion = record.get('importeTasacion');
	param.fechaTasacion = (record.get('fechaTasacion') == null || record.get('fechaTasacion') == '') ? null : record.get('fechaTasacion').format('d/m/Y');
	param.importeAdjudicacion = record.get('importeAdjudicacion');
	param.fechaAdjudicacion = (record.get('fechaAdjudicacion') == null || record.get('fechaAdjudicacion') == '') ? null : record.get('fechaAdjudicacion').format('d/m/Y');
	return param;
};


embargoGrid.on('afteredit', function(e){
	enviaUpdate(e.record, e.field, e.value);	
});

/***************
Creamos botones
****************/

var btnCancelar= new Ext.Button({
	text : '<s:message code="plugin.nuevoModeloBienes.procedimiento.gridEmbargosMultiple.btnCerrar" text="**Cerrar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.DONE);
	}
});

var bottomBar = [];
bottomBar.push(btnCancelar);


/**************************
Creamos el panel principal
***************************/


var mainPanel =  new Ext.Panel({
	header: false
    ,autoHeight:true
    ,autoWidth: true
    //,height:400
    //,width:380
	//,style:'padding-bottom: 15px;'
	,layout: 'column'
	,bodyStyle:'padding:10px' 
    ,items:[embargoGrid]
	,bbar:bottomBar           
});
   
page.add(mainPanel);
</fwk:page>