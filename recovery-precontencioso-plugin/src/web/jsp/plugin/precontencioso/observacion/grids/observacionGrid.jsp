<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- Buttons --%>

var btnAgregar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.observacion.button.agregar" text="**Agregar" />'
	,id : 'btnAgregar'
	,iconCls: 'icon_mas'
	,cls: 'x-btn-text-icon'
	,handler: function() {
			var w = app.openWindow({
			flow: 'observacion/agregarNuevaObservacion'
			,autoWidth: true
			,closable: true
			,title: '<s:message code="plugin.precontencioso.grid.observacion.titulo.nuevaObs" text="**Nueva observación" />'
			,params: {
				idProcedimientoPCO: data.precontencioso.id
			}
		});
	
		w.on(app.event.DONE, function() {
			refrescarObservacionesGrid();
			w.close();
		});
	
		w.on(app.event.CANCEL, function() {
			w.close();
		});
	}
});

var btnEditarObservacion = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.observacion.button.editar" text="**Editar observación" />'
	,id : 'btnEditarObservacion'
	,iconCls: 'icon_edit'
	,cls: 'x-btn-text-icon'
	,handler: function() {
		editarObservacionSeleccionada();
	}
});

var btnBorrarObservacion = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.observacion.button.borrar" text="**Borrar Observación" />'
			,iconCls : 'icon_menos'
			,cls: 'x-btn-text-icon'
<%-- 			,hidden:true --%>
	});	

<%-- Grid --%>
var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Cargando..."});

var observacionesRecord = Ext.data.Record.create([
	{name: 'id'}
	,{name: 'idProcedimientoPCO'}
	,{name: 'fecha'}
	,{name: 'textoAnotacion'}
	,{name: 'resumen'}
	,{name: 'idUsuario'}
	,{name: 'username'}
	,{name: 'idUserLogado'}
]);

var storeObservaciones = page.getStore({
	eventName: 'resultado'
	,flow: 'observacion/getObservacionesPorProcedimientoId'
	,storeId: 'storeObservaciones'
	,reader: new Ext.data.JsonReader({
		root: 'observaciones'
	}, observacionesRecord)
});

var cmObservacion = new Ext.grid.ColumnModel([
	{header: '<s:message code="plugin.precontencioso.grid.observacion.procedimiento" text="**Procedimiento" />', dataIndex: 'idProcedimientoPCO', hidden: true}
	,{header: '<s:message code="plugin.precontencioso.grid.observacion.textoAnotacion" text="**Texto Anotacion" />', dataIndex: 'resumen'}
	,{header: '<s:message code="plugin.precontencioso.grid.observacion.fechaAnotacion" text="**Fecha Anotacion" />', dataIndex: 'fecha'}
	,{header: '<s:message code="plugin.precontencioso.grid.observacion.usuario" text="**Usuario" />', dataIndex: 'username'}
]);

var gridObservaciones = app.crearGrid(storeObservaciones, cmObservacion, {
	title: '<s:message code="plugin.precontencioso.grid.observacion.titulo" text="**Observaciones" />'
	<%-- <sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_LIQ_BTN">    PENDIENTE DE QUE INDIQUEN PERFILES O FUNCIONES REQUERIDAS--%>
	,bbar: [
		btnAgregar 
		,btnEditarObservacion
		,btnBorrarObservacion
	]
	<%--</sec:authorize>--%>
	,height: 250
	,autoWidth: true
	,style:'padding-top:10px'
	,collapsible: true
	,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
});

gridObservaciones.on('rowdblclick', function(grid, rowIndex, e) {
	editarObservacionSeleccionada();
});

gridObservaciones.on('rowclick', function(grid, rowIndex, e) {
	btnBorrarObservacion.setDisabled(false);
	if(gridObservaciones.getSelectionModel().getSelected().get('idUsuario') != 
		gridObservaciones.getSelectionModel().getSelected().get('idUserLogado') ) {
			btnBorrarObservacion.setDisabled(true);
	}
});


btnBorrarObservacion.on('click', function(){
			 
		var rowSelected=gridObservaciones.getSelectionModel().getSelected(); 

		if(rowSelected){
			Ext.Msg.confirm(
			'<s:message code="plugin.precontencioso.grid.observacion.button.borrar" text="**Borrar observación" />'
			,'<s:message code="plugin.precontencioso.grid.observacion.button.borrar.mensaje"
 				text="**Va a borrar el comentario seleccionado ¿Está usted seguro?" />'
			,function(btn) {
				if (btn == 'yes') {
					var idObservacion=rowSelected.get('id');
					Ext.Ajax.request({
							url: page.resolveUrl('observacion/borrarObservacion')
							,params: {idObservacion:idObservacion}
							,method: 'POST'
							,success: function (result, request) {
								Ext.Msg.show({
									title: fwk.constant.alert
									,msg: '<s:message code="plugin.precontencioso.grid.observacion.button.borrarObs.correcto"
									text="**Se ha borrado correctamente" />'
									,buttons: Ext.Msg.OK
								});
								refrescarObservacionesGrid();
							},
							error: function() {
								mask.hide();
								Ext.MessageBox.show({
							    	title: fwk.constant.alert
									,msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />'
									,width: 300
									,buttons: Ext.MessageBox.OK
								});
							} 
					});
				}else{
					Ext.Msg.show({
									title: fwk.constant.alert
									,msg: '<s:message code="plugin.precontencioso.grid.observacion.borrarObs.NoCorrecto"
									text="**La observación no se ha eliminado" />'
									,buttons: Ext.Msg.OK
					});
				}
			});
		}else{
			Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.observacion.borrarObs.NoSeleccionada" text="**Ninguna Observación seleccionada" />'
                ,'<s:message code="plugin.precontencioso.grid.observacion.borrarObs.NoSeleccionada.mensaje" text="**Debe seleccionar alguna observación" />');
        };
	});

<%-- States --%>

<%-- Utils --%>

var editarObservacionSeleccionada = function() {
	
	var w = app.openWindow({
			flow: 'observacion/abrirEditarObservacion'
			,autoWidth: true
			,closable: true
			,title: '<s:message code="plugin.precontencioso.grid.observacion.titulo.editarObs" text="**Editar Observación" />'
			,params: {idObservacion: idObservacionSeleccionada() }
		});
	
		w.on(app.event.DONE, function() {
			refrescarObservacionesGrid();
			w.close();
		});
	
		w.on(app.event.CANCEL, function() {
			w.close();
		});
}

var idObservacionSeleccionada = function() {
	return gridObservaciones.getSelectionModel().getSelected().get('id');
}

var refrescarObservacionesGrid = function() {
	storeObservaciones.webflow({idProcedimientoPCO: data.precontencioso.id});
}

var ponerVisibilidadBotonesObs = function(visibles, invisibles) {
	for (var i=0; i < visibles.length; i++){
		if (typeof(Ext.getCmp(visibles[i].boton)) != 'undefined') {
			Ext.getCmp(visibles[i].boton).setVisible(true);
		}
	}
	for (var i=0; i < invisibles.length; i++){
		if (typeof(Ext.getCmp(visibles[i].boton)) != 'undefined') {
			Ext.getCmp(invisibles[i].boton).setVisible(false);
		}
	}
}