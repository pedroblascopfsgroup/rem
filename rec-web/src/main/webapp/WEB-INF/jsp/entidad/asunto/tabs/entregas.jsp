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
		,title:'<s:message code="entregas.tab.titulo" text="**Entregas" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,nombretab : 'entregas'
	});

	panel.getAsuntoId = function(){ return entidad.get("data").id; }
	panel.puedeEditar = function(){ return entidad.get("data").cobroPago.estadoAsunto==CODIGO_ASUNTO_ACEPTADO; }
   	panel.esSupervisor = function(){ return entidad.get("data").toolbar.esSupervisor; }
   	panel.esGestor = function(){ return entidad.get("data").toolbar.esGestor; }

	var CODIGO_ASUNTO_ACEPTADO = "<fwk:const value="es.capgemini.pfs.asunto.model.DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO" />";
	var estadoAsunto='${asunto.estadoAsunto.codigo}';
	var entrega = Ext.data.Record.create([
			{name:"id"}
			,{name:"codigoCobro"}
			,{name:"fecha"}
			,{name:"fechaValor"}
			,{name:"tipoEntrega"}
			,{name: "tipoCobro"}
			,{name:"conceptoEntrega"}
			,{name:"origenCobro"}
			,{name:"nominal"}
			,{name:"capital"}
			,{name:"capitalNoVencido"}
			,{name:"interesesOrdinarios"}
			,{name:"interesesMoratorios"}
			,{name:"impuestos"}
			,{name:"comisiones"}
			,{name:"importe"}
			,{name:"gastosProcurador"}
			,{name:"gastosAbogado"}
			,{name:"gastosOtros"}
			,{name:"gastos"}
			,{name:"totalEntrega"}
	]);
	var entregaStore = page.getStore({
		event:'listado'
		,storeId : 'entregaStore'
		,flow : 'entregas/getListbyAsuntoId'
		,params: {id: '${asunto.id}'}
		,reader : new Ext.data.JsonReader({root:'listado'}, entrega)
	});
	
	entidad.cacheStore(entregaStore);

	var entregaCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="entregas.codigoEntrega" text="**Codigo Entraga"/>', dataIndex : 'id',hidden:true}
		,{header : '<s:message code="entregas.codigoCobro" text="**Codigo Cobro"/>', dataIndex : 'codigoCobro'}
		,{header : '<s:message code="entregas.fechaEntrega" text="**Fecha Entrega"/>', dataIndex : 'fecha'}
		,{header : '<s:message code="entregas.fechaValor" text="**Fecha Valor"/>', dataIndex : 'fechaValor'}
		,{header : '<s:message code="entregas.tipoEntrega" text="**Tipo Entrega"/>', dataIndex : 'tipoCobro'}
		,{header : '<s:message code="entregas.origenEntrega" text="**Origen Entrega"/>', dataIndex : 'origenCobro'}
		,{header : '<s:message code="entregas.nominal" text="**Nominal"/>', dataIndex : 'nominal', hidden:true}
		,{header : '<s:message code="entregas.intereses" text="**Intereses"/>', dataIndex : 'interesesOrdinarios', hidden:true}
		,{header : '<s:message code="entregas.demoras" text="**Demoras"/>', dataIndex : 'interesesMoratorios', hidden:true}
		,{header : '<s:message code="entregas.impuestos" text="**Impuestos"/>', dataIndex : 'impuestos', hidden:true}
		,{header : '<s:message code="entregas.gastosProcurador" text="**Gastos Procurador"/>', dataIndex : 'gastosProcurador', hidden:true}
		,{header : '<s:message code="entregas.gastosAbogado" text="**Gastos Abogado"/>', dataIndex : 'gastosAbogado', hidden:true}
		,{header : '<s:message code="entregas.otrosGastos" text="**Otros Gastos"/>', dataIndex : 'gastosOtros', hidden:true}
		,{header : '<s:message code="entregas.totalGastos" text="**Total Gastos "/>', dataIndex : 'gastos', hidden:true}
		,{header : '<s:message code="entregas.comisiones" text="**Comisiones"/>', dataIndex : 'comisiones', hidden:true}
		,{header : '<s:message code="entregas.totalEntrega" text="**Total Entrega "/>', dataIndex : 'importe'}
		
	]);
	 
	<%-- var btnNuevo = new Ext.Button({
		 text: '<s:message code="app.agregar" text="**Agregar" />'
		 ,iconCls : 'icon_mas'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var w = app.openWindow({
					flow : 'entregas/nuevaEntrega'
					,width:700
					,title : '<s:message code="entregas.alta" text="**Alta Entrega" />' 
					,params : {idAsunto: panel.getAsuntoId()}
				});
				w.on(app.event.DONE, function(){
					w.close();
					entregaStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var btnEditar = new Ext.Button({
		 text: '<s:message code="app.editar" text="**Editar" />'
		 ,iconCls : 'icon_edit'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var rec =  entregaGrid.getSelectionModel().getSelected();
				if (!rec) return;
					var id = rec.get("id");
				var parametros = {
						idAsunto: panel.getAsuntoId(),
						id: id
				};
				var w = app.openWindow({
					flow : 'entregas/editarEntrega'
					,width:700
					,title : '<s:message code="entregas.editar" text="**Editar CobroPago" />' 
					,params : parametros
				});
				w.on(app.event.DONE, function(){
					w.close();
					entregaStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});--%>
	

	var entregaGrid = app.crearGrid(entregaStore,entregaCm,{
		title:'<s:message code="entregas.grid.titulo" text="**Entregas" />'
		,height : 420
		,style:'padding-right:10px'
		<%--,bbar:[ 
			 <sec:authorize ifAllGranted="ROLE_PUEDE_VER_BOT_AGREGAR_ENTREGA">btnNuevo
				<sec:authorize ifAllGranted="ROLE_PUEDE_VER_BOT_MODIFICAR_ENTREGA">,btnEditar</sec:authorize>
			</sec:authorize>
			
			<sec:authorize ifNotGranted="ROLE_PUEDE_VER_BOT_AGREGAR_ENTREGA">
				<sec:authorize ifAllGranted="ROLE_PUEDE_VER_BOT_MODIFICAR_ENTREGA">btnEditar</sec:authorize>
			</sec:authorize>
		
		]--%>
	});
	  
	<%-- entregaGrid.on('rowdblclick',function(grid, rowIndex, e){
		if(!panel.puedeEditar()) return; 
		if ( !(panel.esGestor() || panel.esSupervisor())) return;
	   	var rec = grid.getSelectionModel().getSelected();
	    var id= rec.get('id');  
		if(!id)
			return;
	    var w = app.openWindow({
	        flow : 'entregas/editarEntrega'
			,width:700
			,title : '<s:message code="cobroPago.edicion" text="**Editar CobroPago" />'
	        ,params : {id:id,idAsunto:panel.getAsuntoId()}
	    });
	    w.on(app.event.DONE, function(){
	        w.close();
			entregaStore.webflow({id:panel.getAsuntoId()});
	    });
	    w.on(app.event.CANCEL, function(){ w.close(); });
	});--%>

	panel.add(entregaGrid);

	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		var d=data.entrega;
		entidad.cacheOrLoad(data, entregaStore, { id : data.id } );
		var puedeEditar = panel.puedeEditar();
		var esVisible = [
			[btnNuevo, puedeEditar]
			,[btnEditar, puedeEditar]
		];
		entidad.setVisible(esVisible);
	}

	panel.setVisibleTab = function(data){
	//	return data.toolbar.esSupervisor || data.toolbar.esGestor;
		return true;
	}
  
	return panel;
})
