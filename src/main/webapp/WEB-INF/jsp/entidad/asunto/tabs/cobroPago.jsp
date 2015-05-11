<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
	
	var panel = new Ext.Panel({
		autoHeight : true
		,title:'<s:message code="cobroPago.titulo" text="**Cobros/Pagos" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,nombretab : 'cobrosPagos'
	});

	panel.getAsuntoId = function(){ return entidad.get("data").id; }
	panel.puedeEditar = function(){ return entidad.get("data").cobroPago.estadoAsunto==CODIGO_ASUNTO_ACEPTADO; }
   	panel.esSupervisor = function(){ return entidad.get("data").toolbar.esSupervisor; }
   	panel.esGestor = function(){ return entidad.get("data").toolbar.esGestor; }

	var CODIGO_ASUNTO_ACEPTADO = "<fwk:const value="es.capgemini.pfs.asunto.model.DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO" />";
	var estadoAsunto='${asunto.estadoAsunto.codigo}';
	var cobroPago = Ext.data.Record.create([
			{name:"id"}
			,{name:"procedimiento"}
			,{name:"estado"}
			,{name:"subTipo"}
			,{name:"importe"}
			,{name:"fecha"}
	]);
	var cobroPagoStore = page.getStore({
		event:'listado'
		,storeId : 'cobroPagoStore'
		,flow : 'asuntos/listadoCobroPago'
		,reader : new Ext.data.JsonReader({root:'listado'}, cobroPago)
	});
	
	entidad.cacheStore(cobroPagoStore);

	var cobroPagoCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="cobroPago.procedimiento.id" text="**id"/>', dataIndex : 'id',hidden:true}
		,{header : '<s:message code="cobroPago.procedimiento" text="**procedimiento"/>', dataIndex : 'procedimiento'}
		,{header : '<s:message code="cobroPago.estado" text="**estado"/>', dataIndex : 'estado'}
		,{header : '<s:message code="cobroPago.subTipo" text="**subTipo"/>', dataIndex : 'subTipo'}
		,{header : '<s:message code="cobroPago.importe" text="**importe"/>', dataIndex : 'importe'}
		,{header : '<s:message code="cobroPago.fecha" text="**fecha"/>', dataIndex : 'fecha'}
	]);
	 
	var btnNuevo = new Ext.Button({
		 text: '<s:message code="app.agregar" text="**Agregar" />'
		 ,iconCls : 'icon_mas'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var w = app.openWindow({
					flow : 'asuntos/cobroPago'
					,width:700
					,title : '<s:message code="cobroPago.alta" text="**Alta CobroPago" />' 
					,params : {idAsunto: panel.getAsuntoId()}
				});
				w.on(app.event.DONE, function(){
					w.close();
					cobroPagoStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var btnEditar = new Ext.Button({
		 text: '<s:message code="app.editar" text="**Editar" />'
		 ,iconCls : 'icon_edit'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var rec =  cobroPagoGrid.getSelectionModel().getSelected();
				if (!rec) return;
					var id = rec.get("id");
				var parametros = {
						idAsunto: panel.getAsuntoId(),
						id: id
				};
				var w = app.openWindow({
					flow : 'asuntos/cobroPago'
					,width:700
					,title : '<s:message code="cobroPago.edicion" text="**Editar CobroPago" />' 
					,params : parametros
				});
				w.on(app.event.DONE, function(){
					w.close();
					cobroPagoStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});
	
	var btnBorrar = app.crearBotonBorrar({
		text : '<s:message code="app.borrar" text="**Borrar" />'
		,flow : 'asuntos/borraCobroPago'
		,success : function(){
			cobroPagoStore.webflow({id:panel.getAsuntoId()});
		}
		,page : page
	});

	var cobroPagoGrid = app.crearGrid(cobroPagoStore,cobroPagoCm,{
		title:'<s:message code="cobroPago.grid" text="**CobroPago" />'
		,height : 420
		,style:'padding-right:10px'
		,bbar:[ btnNuevo,btnEditar,btnBorrar ]
	});
	  
	cobroPagoGrid.on('rowdblclick',function(grid, rowIndex, e){
		if(!panel.puedeEditar()) return; 
		if ( !(panel.esGestor() || panel.esSupervisor())) return;
	   	var rec = grid.getSelectionModel().getSelected();
	    var id= rec.get('id');  
		if(!id)
			return;
	    var w = app.openWindow({
	        flow : 'asuntos/cobroPago'
			,width:700
			,title : '<s:message code="cobroPago.edicion" text="**Editar CobroPago" />'
	        ,params : {id:id,idAsunto:panel.getAsuntoId()}
	    });
	    w.on(app.event.DONE, function(){
	        w.close();
			cobroPagoStore.webflow({id:panel.getAsuntoId()});
	    });
	    w.on(app.event.CANCEL, function(){ w.close(); });
	});

	panel.add(cobroPagoGrid);

	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		var d=data.cobroPago;
		entidad.cacheOrLoad(data, cobroPagoStore, { id : data.id } );
		var puedeEditar = panel.puedeEditar();
		var esVisible = [
			[btnNuevo, puedeEditar]
			,[btnEditar, puedeEditar]
			,[btnBorrar, puedeEditar]
		];
		entidad.setVisible(esVisible);
	}

	panel.setVisibleTab = function(data){
	//	return data.toolbar.esSupervisor || data.toolbar.esGestor;
		return true;
	}
  
	return panel;
})
