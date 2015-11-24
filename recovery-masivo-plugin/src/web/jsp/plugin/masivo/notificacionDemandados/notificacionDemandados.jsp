<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<fwk:page>

var cssIconInformacion = 'background-image: url(\'../img/plugin/masivo/pencil.png\');background-repeat:no-repeat;background-position:right;'; 
var cssIconDemandado = 'background-image: url(\'../img/plugin/masivo/building_edit.png\');background-repeat:no-repeat;background-position:right;'; 

var idProcedimiento = '${idProcedimiento}';
var idPersonaSelected = '';
var idDireccionSelected = '';
var direccionSelected = '';
var tipoFechaHistorico = '';

var resultadoStore = new Ext.data.JsonStore({
	fields: ['codigo', 'descripcion'],
	data: [{
	    codigo: "POSITIVO",
	    descripcion: "Positivo"
	}, {
	    codigo: "NEGATIVO",
	    descripcion: "Negativo"
	}]
});

var estadoRender = function (value, meta, record) {
	var index = resultadoStore.findExact('codigo', value);
	if (index == undefined) return '';
	
	var record = resultadoStore.getAt(index);
	if (!record) return '';
	
	return record.get('descripcion');
};

var estadoEditor = new Ext.form.ComboBox({
	 name: 'comboResultado'
	,store: resultadoStore 
	,displayField: 'descripcion'
	,valueField: 'codigo'
	,mode: 'local'
	,triggerAction: 'all'
	,editable:false
});

var excluidoStore = new Ext.data.JsonStore({
	fields: ['codigo', 'descripcion'],
	data: [{
	    codigo: true,
	    descripcion: "S�"
	}, {
	    codigo: false,
	    descripcion: "No"
	}]
});

var excluidoRender = function (value, meta, record) {
	var index = excluidoStore.findExact('codigo', value);
	if (index == undefined) return '';
	
	var record = excluidoStore.getAt(index);
	if (!record) return '';
	
	return record.get('descripcion');
};

var excluidoEditor = new Ext.form.ComboBox({
	name: 'comboExcluido'
	,store: excluidoStore 
	,displayField: 'descripcion'
	,valueField: 'codigo'
	,mode: 'local'
	,triggerAction: 'all'
	,editable:false
});

var dateRenderer = Ext.util.Format.dateRenderer('d/m/Y');

var dateEditor = new Ext.form.DateField({
	format: 'd/m/y'
});

/***********************************
Definimos el store de demandados
************************************/
var recordResumen = Ext.data.Record.create([
	{name: 'idProcedimiento'},
	{name: 'idDemandado'},
	{name: 'nombreDemandado'},
	{name: 'excluido'},
	{name: 'fechaReqPago',type: 'date',dateFormat: 'c'},
	{name: 'resultadoReqPago'},
	{name: 'fechaSolicitudAvDomiciliaria',type: 'date',dateFormat: 'c'},
	{name: 'resultadoAvDomiciliaria'},
	{name: 'fechaSolicitudReqEdicto',type: 'date',dateFormat: 'c'},
	{name: 'resultadoReqEdicto'}
]);
    
var recordResumenStore = page.getStore({
	id: 'recordResumen'
	,flow:'msvnotificaciondemandados/getResumenFechasNotificacionData'
	,reader: new Ext.data.JsonReader({
  		root : 'data'
	} , recordResumen)
});

recordResumenStore.webflow({idProcedimiento: idProcedimiento});
/*
Creamos el grid de demandados
*/

 var rows = [
        [
             {colspan: 1}
             ,{colspan: 1}
             ,{header: '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.cabeceraRequerimiento" text="**Requerimiento de Pago"/>', colspan: 2, align: 'center'}
             ,{header: '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.cabeceraAveriguacion" text="**Averiguaci�n"/>', colspan: 2, align: 'center'}
             ,{header: '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.cabeceraEdictos" text="**Edictos"/>', colspan: 2, align: 'center'}          
        ]
    ];
    
var resumenNotificacionCM = new Ext.grid.ColumnModel([
	//{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.idProcedimiento" text="**Id Procedimiento" />', dataIndex : 'idProcedimiento' ,sortable:true, hidden:false}
	//,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.idDemandado" text="**Id Demandado" />', dataIndex : 'idDemandado' ,sortable:true, hidden:false}
	{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.nombreDemandado" text="**Demandado" />', dataIndex : 'nombreDemandado',sortable:true, width: 275}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.excluido" text="**Excluido" />', dataIndex : 'excluido',sortable:true, width: 55
	,renderer: excluidoRender
	,editor: excluidoEditor}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.fechaReqPago" text="**Fecha Req. pago" />', dataIndex : 'fechaReqPago' ,sortable:true, hidden:false, renderer: dateRenderer, width: 100, css: cssIconDemandado }
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.resultadoReqPago" text="**Resultado Req." />', dataIndex : 'resultadoReqPago' ,sortable:true, hidden:false, width: 75, renderer: estadoRender}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.fechaSolicitudAvDomiciliaria" text="**Av. Solicitud" />', dataIndex : 'fechaSolicitudAvDomiciliaria',sortable:true, renderer: dateRenderer, width: 100, css: cssIconInformacion}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.resultadoAvDomiciliaria" text="**Av. Resultado" />', dataIndex : 'resultadoAvDomiciliaria' ,sortable:true, hidden:false, width: 75, renderer: estadoRender}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.fechaSolicitudReqEdicto" text="**Ed. Solicitud" />', dataIndex : 'fechaSolicitudReqEdicto' ,sortable:true, hidden:false, renderer: dateRenderer, width: 100, css: cssIconInformacion}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.resultadoReqEdicto" text="**Ed. Resultado" />', dataIndex : 'resultadoReqEdicto',sortable:true, width: 75, renderer: estadoRender}
]);

var resumenNotificacionGrid = new Ext.grid.EditorGridPanel({
	store: recordResumenStore
	,cm: resumenNotificacionCM	
    ,title: '<s:message code="plugin.masivo.notificacionDemandados.gridResumen.titulo" text="**Listado de Demandados" />'
    ,height: 200
    ,width: 868
    ,clicksToEdit: 1
    ,style:'padding-bottom: 10px;'
    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
    //,viewConfig: {forceFit: true}
    ,plugins: [new Ext.ux.grid.ColumnHeaderGroup({rows: rows})]
}); 

/***********************************
Definimos el store detalle direcciones
************************************/
var recordDetalle = Ext.data.Record.create([
	{name: 'idDireccion'},
	{name: 'idPersona'},
	{name: 'idProcedimiento'},
	{name: 'direccion'},
	{name: 'tipoFecha'},
	{name: 'fechaRequerimiento',type: 'date',dateFormat: 'c'},
	{name: 'resultadoRequerimiento'},
	{name: 'fechaHorarioNocturno',type: 'date',dateFormat: 'c'},
	{name: 'resultadoHorarioNocturno'}
]);

var recordDetalleStore = page.getStore({
	flow:'msvnotificaciondemandados/getDetalleFechasNotificacionData'
	,reader: new Ext.data.JsonReader({
  		root : 'data'
	} , recordDetalle)
});

/*
Creamos el grid detalle de direcciones
*/

 var headerDirecciones = [
        [
             {colspan: 1}
             ,{header: '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.cabeceraRequerimiento" text="**Requerimiento de Pago"/>', colspan: 2, align: 'center'}
             ,{header: '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.cabeceraNocturno" text="**Horario Nocturno"/>', colspan: 2, align: 'center'}
        ]
    ];


var detalleDireccionesCM = new Ext.grid.ColumnModel([
	//{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.id" text="**Id Direccion" />', dataIndex : 'idDireccion' ,sortable:false, hidden:false}
	//,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.idPersona" text="**Id Persona" />', dataIndex : 'idPersona' ,sortable:false, hidden:false}
	//,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.idProcedimiento" text="**Id Procedimiento" />', dataIndex : 'idProcedimiento',sortable:false}
	{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.direccion" text="**Direcci�n" />', dataIndex : 'direccion' ,sortable:false, hidden:false, width: 260}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.fechaRequerimiento" text="**Fecha Requerimiento" />', dataIndex : 'fechaRequerimiento' ,sortable:false, hidden:false, renderer: dateRenderer, css: cssIconInformacion}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.resultadoRequerimiento" text="**Resultado Requerimiento" />', dataIndex : 'resultadoRequerimiento',sortable:false, renderer: estadoRender, width: 60}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.fechaHorarioNocturno" text="**Fecha Horario Nocturno" />', dataIndex : 'fechaHorarioNocturno' ,sortable:false, hidden:false, renderer: dateRenderer, css: cssIconInformacion}
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.resultadoHorarioNocturno" text="**Resultado Horario Nocturno" />', dataIndex : 'resultadoHorarioNocturno' , sortable:false, hidden:false, renderer: estadoRender, width: 60}
]);

var detalleNotificacionGrid = new Ext.grid.GridPanel({
	store: recordDetalleStore
	,cm: detalleDireccionesCM
	,title : '<s:message code="plugin.masivo.notificacionDemandados.gridDetalle.titulo" text="**Direcciones por demandado" />'
    ,height: 150
	//,viewConfig: {forceFit: true}
    ,style:'padding-bottom: 10px;padding-right: 10px;'
    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
    ,plugins: [new Ext.ux.grid.ColumnHeaderGroup({rows: headerDirecciones})]
});

recordDetalleStore.setDefaultSort('direccion','DESC');

resumenNotificacionGrid.on('cellclick', function(grid, rowIndex, columnIndex, e){
	var cm = grid.getColumnModel();
    if (cm) {
		var columnName = cm.getColumnAt(columnIndex).dataIndex;
		var tipoFecha;
		if (columnName == 'fechaSolicitudAvDomiciliaria') {
			tipoFecha = 'AVG';
			historicoDetalleNotificacionGrid.setTitle('<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.tituloAv" text="**Hist�rico de Fechas de Averiguaci�n Domiciliaria" />');
		}else if (columnName == 'fechaSolicitudReqEdicto'){
			historicoDetalleNotificacionGrid.setTitle('<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.tituloEd" text="**Hist�rico de Fechas de Requerimiento de Edicto" />');
			tipoFecha = 'EDI';
		}else{
		    var idDemandado = grid.getStore().getAt(rowIndex).get('idDemandado');
		    if (idDemandado) {
		    	idPersonaSelected = idDemandado;
    			idDireccionSelected = '';
    			direccionSelected = '';
		    	historicoDetalleNotificacionGrid.setVisible(false);
		    	recordDetalleStore.webflow({idProcedimiento: idProcedimiento, idPersona: idDemandado});
		    }else{
		    	return false;
		    }		
		}
		if (tipoFecha){
	    	var idPersona = grid.getStore().getAt(rowIndex).get('idDemandado');
		    if (idPersona) {
		       	idPersonaSelected = idPersona;
    			idDireccionSelected = '';
    			direccionSelected = '';
		       	historicoDetalleNotificacionGrid.setVisible(true);
		    	tipoFechaHistorico = tipoFecha;
		    	recordHistoricoDetalleStore.webflow({idProcedimiento: idProcedimiento, idPersona: idPersona, tipoFecha: tipoFecha});
		    }
		}

	    
	}
});

resumenNotificacionGrid.on('afteredit', function(e){
	updateExcluido(e.record, e.value);
});


/*
resumenNotificacionGrid.on('cellclick', function(grid, rowIndex, columnIndex, e){
    var idDemandado = grid.getStore().getAt(rowIndex).get('idDemandado');
    if (idDemandado) {    
    	recordDetalleStore.webflow({idProcedimiento: idProcedimiento, idPersona: idDemandado});
    }else{
    	return false;
    }
});
*/

/***********************************
Definimos el store historico detalle direcciones
************************************/

        
var recordHistoricoDetalle = Ext.data.Record.create([
	{name: 'id'},
	{name: 'idPersona'},
	{name: 'idProcedimiento'},
	{name: 'idDireccion'},	
	{name: 'direccion'},
	{name: 'tipoFecha'},
	{name: 'fechaSolicitud',type: 'date',dateFormat: 'c'},
	{name: 'fechaResultado',type: 'date',dateFormat: 'c'},
	{name: 'resultado'}
]);

var recordHistoricoDetalleStore = page.getStore({
	flow:'msvnotificaciondemandados/getHistoricoDetalleFechasNotificacionData'
	,reader: new Ext.data.JsonReader({
  		root : 'data'
	} , recordHistoricoDetalle)
});

recordHistoricoDetalleStore.setDefaultSort('fechaResultado','DESC');

var updateExcluido = function(record, value) {

	record.commit(false);
    var params = {
		idProcedimiento: record.get('idProcedimiento')
		,idPersona: record.get('idDemandado')
		,excluido: value
	};
	
	Ext.Ajax.request({
	    url:'/'+app.getAppName()+'/msvnotificaciondemandados/updateExcluido.htm'
	    ,params:params	    
	    ,failure: function(response, opt) {}
	});	
	
};

/*
Creamos el grid detalle de direcciones
*/

var enviaUpdate = function(record, field, value) {
	record.commit(false);
    var params = {
		id: record.get('id')
		,fechaSolicitud: record.get('fechaSolicitud')
		,fechaResultado: record.get('fechaResultado')
		,resultado: record.get('resultado')
	};
	
	Ext.Ajax.request({
	    url:'/'+app.getAppName()+'/msvnotificaciondemandados/updateNotificacion.htm'
	    ,params:params
	    ,success: function(response, opt) {
	    	if(record.get('idDireccion')){
	    		recordResumenStore.on('load',function(){
	    				recordDetalleStore.webflow({idProcedimiento: idProcedimiento, idPersona: record.get('idPersona')});
	    				});
	    	}
	    	recordResumenStore.webflow({idProcedimiento: idProcedimiento});
	    }
	    ,failure: function(response, opt) {}
	});	
	
};

var enviaInsert = function(record, field, value) {

	record.commit(false);
    var params = record.data;
	
	Ext.Ajax.request({
	    url:'/'+app.getAppName()+'/msvnotificaciondemandados/insertNotificacion.htm'
	    ,params: record.data
	    ,success: function(response, opt) {
	    	var r = Ext.decode(response.responseText);
	    	var id = r.data.id;
	    	var record = recordHistoricoDetalleStore.getAt(0);
	    	record.set('id', id);
	    	if(record.get('idDireccion')){
	    		recordResumenStore.on('load',function(){
	    				recordDetalleStore.webflow({idProcedimiento: idProcedimiento, idPersona: record.get('idPersona')});
	    				});
	    	}
	    	recordResumenStore.webflow({idProcedimiento: idProcedimiento});
	    }
	    ,failure: function(response, opt) {}
	});	
	
};

var historicoDetalleDireccionesCM = new Ext.grid.ColumnModel([
	//{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.id" text="**Id" />', dataIndex : 'id' ,sortable:false, hidden:false}
	//,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.idPersona" text="**Id Persona" />', dataIndex : 'idPersona' ,sortable:false, hidden:false}
	//,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.idProcedimiento" text="**Id Procedimiento" />', dataIndex : 'idProcedimiento',sortable:false}
	//,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.idDireccion" text="**idDirecci�n" />', dataIndex : 'idDireccion' ,sortable:false, hidden:false}
	//,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.direccion" text="**Direcci�n" />', dataIndex : 'direccion' ,sortable:false, hidden:false}
	//{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.tipoFecha" text="**Tipo Fecha" />', dataIndex : 'tipoFecha' ,sortable:false, hidden:false}	
	{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.fechaSolicitud" text="**Fecha Solicitud" />', id: 'fechaSolicitud', dataIndex : 'fechaSolicitud' ,sortable:false, hidden:false, width: 85
		,renderer: dateRenderer
		,editor: dateEditor 
     }
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.fechaResultado" text="**Fecha Resultado" />', dataIndex : 'fechaResultado',sortable:false, width: 85
		,renderer: dateRenderer
		,editor: dateEditor
     }	
	,{header : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.resultado" text="**Resultado" />', dataIndex : 'resultado' ,sortable:false, hidden:false, width: 70
		,renderer: estadoRender
		,editor: estadoEditor
	}
]);


var historicoDetalleNotificacionGrid = new Ext.grid.EditorGridPanel({
    title : '<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.titulo" text="**Hist�rico Notificaci�n Direcciones" />'
    ,cm: historicoDetalleDireccionesCM
    ,store: recordHistoricoDetalleStore
    ,height: 150
	//,viewConfig: {forceFit: true}    
    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
    ,clicksToEdit: 1
    ,style:'padding-bottom: 10px;'
    ,tbar: [{
    	text: 'Nueva Fecha'
    	,iconCls:'icon_procedimiento'
	    ,handler : function(){
	        // access the Record constructor through the grid's store
    		var direccion;
	        if (detalleNotificacionGrid.getSelectionModel().getSelected()){
	        	idDireccion = detalleNotificacionGrid.getSelectionModel().getSelected().get('idDireccion');
    			direccion = detalleNotificacionGrid.getSelectionModel().getSelected().get('direccion');
    		}
    		
	        var FechasNotificacion = historicoDetalleNotificacionGrid.getStore().recordType;
	        var f = new FechasNotificacion({
	        	id:'',
	        	idProcedimiento: idProcedimiento,
	        	idPersona: idPersonaSelected,
	        	idDireccion: idDireccionSelected,
	        	direccion: direccionSelected,
	        	tipoFecha: tipoFechaHistorico
	        });
	        
	        historicoDetalleNotificacionGrid.stopEditing();
	        recordHistoricoDetalleStore.insert(0, f);
	        historicoDetalleNotificacionGrid.startEditing(0, 0);
		}
	}]
});

detalleNotificacionGrid.on('cellclick', function(grid, rowIndex, columnIndex, e){
	var cm = grid.getColumnModel();
    if (cm) {
		var columnName = cm.getColumnAt(columnIndex).dataIndex;
		var tipoFecha;
		if (columnName == 'fechaRequerimiento') {
			tipoFecha = 'REC';
			historicoDetalleNotificacionGrid.setTitle('<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.tituloRec" text="**Hist�rico de Fechas de Requerimiento" />');			
		}else if (columnName == 'fechaHorarioNocturno'){
			tipoFecha = 'HNO';
			historicoDetalleNotificacionGrid.setTitle('<s:message code="plugin.masivo.notificacionDemandados.gridHistoricoDetalle.tituloHno" text="**Hist�rico de Fechas de Horario Nocturno" />');			
		}else{return false;}
    	var idDireccion = grid.getStore().getAt(rowIndex).get('idDireccion');
    	var idPersona = grid.getStore().getAt(rowIndex).get('idPersona');
    	idPersonaSelected = idPersona;
    	idDireccionSelected = idDireccion;
    	direccionSelected = grid.getStore().getAt(rowIndex).get('direccion');;
	    if (idDireccion) {
	    	historicoDetalleNotificacionGrid.setVisible(true);
	    	tipoFechaHistorico = tipoFecha;
	    	recordHistoricoDetalleStore.webflow({idProcedimiento: idProcedimiento, idPersona: idPersona, idDireccion: idDireccion, tipoFecha: tipoFecha});
	    }else{
	    	return false;
	    }
	}
});

historicoDetalleNotificacionGrid.on('cellclick', function(grid, rowIndex, columnIndex, e){
	if (rowIndex >0){
		return false;
	}
	var cm = grid.getColumnModel();
	if (cm) {
		var columnName = cm.getColumnAt(columnIndex).dataIndex;
	}
});

historicoDetalleNotificacionGrid.on('afteredit', function(e){
	var id = e.record.get('id');
	if (id){
		enviaUpdate(e.record, e.field, e.value);
	}
	else{
		enviaInsert(e.record, e.field, e.value);
	}
});

/***************
Creamos botones
****************/

var btnGuardar = new Ext.Button({
	text : '<s:message code="app.guardar" text="**Guardar" />'
	,iconCls : 'icon_ok'
	,handler : function(){
		page.fireEvent(app.event.DONE);
		/*page.submit({
			eventName : 'ok'
			,formPanel : panelEdicion
			,success : function(){ page.fireEvent(app.event.DONE); }
		});*/
	}
});

var btnCancelar= new Ext.Button({
	text : '<s:message code="plugin.masivo.notificacionDemandados.btnCerrar" text="**Cerrar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);
	}
});

var bottomBar = [];
//bottomBar.push(btnGuardar);
bottomBar.push(btnCancelar);


/**************************
Creamos el panel principal
***************************/
historicoDetalleNotificacionGrid.setVisible(false);



var fieldSet = new Ext.form.FieldSet({
	autoHeight:'true'
	//,style:'padding:2px'
	,border:false
	,layout : 'column'
	,layoutConfig:{
		columns:2
	}
	,width:890
	,defaults : {layout:'form',border: false} 
	,items : [ 
			 { 	columnWidth:.70,
			 	items:[ detalleNotificacionGrid]
			 },
			 {
			 	columnWidth:.30, 
			 	items:[ historicoDetalleNotificacionGrid]
			 }
	]
});

var mainPanel =  new Ext.Panel({
	header: false
    ,autoHeight:true
    ,autoWidth: true
    //,height:400
    //,width:380
	//,style:'padding-bottom: 15px;'
	,layout: 'column'
	,bodyStyle:'padding:10px' 
    ,items:[resumenNotificacionGrid,fieldSet]
	,bbar:bottomBar           
});
   
page.add(mainPanel);
</fwk:page>