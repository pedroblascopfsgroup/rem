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
	<%-- Panel (TAB) --%>
	var panel = new Ext.Panel({
		autoHeight : true
		,title:'<s:message code="contabilidad.tab.titulo" text="**Contabilidad Cobros" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,nombretab : 'contabilidadcobros'
	});

	panel.getAsuntoId = function(){ return entidad.get("data").id; }
	panel.puedeEditar = function(){ return entidad.get("data").contabilidadCobros.estadoAsunto==CODIGO_ASUNTO_ACEPTADO; }
   	panel.esSupervisor = function(){ return entidad.get("data").toolbar.esSupervisor; }
   	panel.esGestor = function(){ return entidad.get("data").toolbar.esGestor; }

	<%-- Variables --%>
	var CODIGO_ASUNTO_ACEPTADO = "<fwk:const value="es.capgemini.pfs.asunto.model.DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO" />";
	var estadoAsunto='${asunto.estadoAsunto.codigo}';
	
	<%-- Store Modelo --%>
	var contabilidadCobros = Ext.data.Record.create([
			 {name:"id"}
			,{name:"fechaEntrega"}
			,{name:"fechaValor"}
			,{name:"importe"}
			,{name:"tipoEntrega"}
			,{name:"conceptoEntrega"}
			,{name:"nominal"}
			,{name:"intereses"}
			,{name:"demoras"}
			,{name:"impuestos"}
			,{name:"gastosProcurador"}
			,{name:"gastosLetrado"}
			,{name:"otrosGastos"}
			,{name:"quitaNominal"}
			,{name:"quitaIntereses"}
			,{name:"quitaDemoras"}
			,{name:"quitaImpuestos"}
			,{name:"quitaGastosProcurador"}
			,{name:"quitaGastosLetrado"}
			,{name:"quitaOtrosGastos"}
			,{name:"totalEntrega"}
			,{name:"numEnlace"}
			,{name:"numMandamiento"}
			,{name:"numCheque"}
			,{name:"observaciones"}
			,{name:"asunto"}
	]);
	<%-- Store Grid --%>
	var contabilidadCobrosStore = page.getStore({
		event:'listado'
		,storeId : 'contabilidadCobrosStore'
		,flow : 'contabilidadcobros/getListadoContabilidadCobros'
		,reader : new Ext.data.JsonReader({root:'listado'}, contabilidadCobros)
	});
	
	entidad.cacheStore(contabilidadCobrosStore);

	<%-- Columnas Grid --%>
	var contabilidadCobrosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="contabilidad.fechaEntrega" text="**Fecha Entrega"/>', dataIndex : 'fechaEntrega'}
		,{header : '<s:message code="contabilidad.fechaValor" text="**Fecha Valor"/>', dataIndex : 'fechaValor'}
		,{header : '<s:message code="contabilidad.importe" text="**Importe"/>', dataIndex : 'importe'}
		,{header : '<s:message code="contabilidad.tipoEntrega" text="**Tipo Entrega"/>', dataIndex : 'tipoEntrega'}
		,{header : '<s:message code="contabilidad.conceptoEntrega" text="**Concepto Entrega"/>', dataIndex : 'conceptoEntrega'}
		,{header : '<s:message code="contabilidad.nominal" text="**Nominal"/>', dataIndex : 'nominal'}
		,{header : '<s:message code="contabilidad.intereses" text="**Intereses"/>', dataIndex : 'intereses'}
		,{header : '<s:message code="contabilidad.demoras" text="**Demoras"/>', dataIndex : 'demoras'}
		,{header : '<s:message code="contabilidad.impuestos" text="**Impuestos"/>', dataIndex : 'impuestos'}
		,{header : '<s:message code="contabilidad.gastosProcurador" text="**Gastos Procurador"/>', dataIndex : 'gastosProcurador'}
		,{header : '<s:message code="contabilidad.gastosLetrado" text="**Gastos Letrado"/>', dataIndex : 'gastosLetrado'}
		,{header : '<s:message code="contabilidad.otrosGastos" text="**Otros Gastos"/>', dataIndex : 'otrosGastos'}
		,{header : '<s:message code="contabilidad.quitaNominal" text="**Quita Nominal"/>', dataIndex : 'quitaNominal'}
		,{header : '<s:message code="contabilidad.quitaIntereses" text="**Quita Intereses"/>', dataIndex : 'quitaIntereses'}
		,{header : '<s:message code="contabilidad.quitaDemoras" text="**Quita Demoras"/>', dataIndex : 'quitaDemoras'}
		,{header : '<s:message code="contabilidad.quitaImpuestos" text="**Quita Impuestos"/>', dataIndex : 'quitaImpuestos'}
		,{header : '<s:message code="contabilidad.quitaGastosProcurador" text="**Quita Gastos Procurador"/>', dataIndex : 'quitaGastosProcurador'}
		,{header : '<s:message code="contabilidad.quitaGastosLetrado" text="**Quita Gastos Letrado"/>', dataIndex : 'quitaGastosLetrado'}
		,{header : '<s:message code="contabilidad.quitaOtrosGastos" text="**Quita Otros Gastos"/>', dataIndex : 'quitaOtrosGastos'}
		,{header : '<s:message code="contabilidad.totalEntrega" text="**Total Entrega"/>', dataIndex : 'totalEntrega'}
		,{header : '<s:message code="contabilidad.numEnlace" text="**Número Enlace"/>', dataIndex : 'numEnlace'}
		,{header : '<s:message code="contabilidad.numMandamiento" text="**Número Mandamiento"/>', dataIndex : 'numMandamiento'}
		,{header : '<s:message code="contabilidad.numCheque" text="**Número Cheque"/>', dataIndex : 'numCheque'}
		,{header : '<s:message code="contabilidad.observaciones" text="**Observaciones"/>', dataIndex : 'observaciones'}
	]);
	 
	 <%-- Botones Grid --%>
	var btnNuevo = new Ext.Button({
		 text: '<s:message code="app.agregar" text="**Agregar" />'
		 ,iconCls : 'icon_mas'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var w = app.openWindow({
					flow : 'contabilidadcobros/showNewContabilidadCobro'
					,width:700
					,title : '<s:message code="contabilidad.alta" text="**Alta Contabilidad Cobro" />' 
					,params : {idAsunto: panel.getAsuntoId()}
				});
				w.on(app.event.DONE, function(){
					w.close();
					contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var btnEditar = new Ext.Button({
		 text: '<s:message code="app.editar" text="**Editar" />'
		 ,iconCls : 'icon_edit'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var rec =  contabilidadCobrosGrid.getSelectionModel().getSelected();
				if (!rec) return;
					var id = rec.get("id");
				var parametros = {
						asunto: panel.getAsuntoId(),
						id: id
				};
				var w = app.openWindow({
					flow : 'contabilidadcobros/showEditContabilidadCobro'
					,width:700
					,title : '<s:message code="contabilidad.edicion" text="**Editar Contabilidad Cobro" />'
					,params : parametros
				});
				w.on(app.event.DONE, function(){
					w.close();
					contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});
	
	var btnBorrar = app.crearBotonBorrar({
		text : '<s:message code="app.borrar" text="**Borrar" />'
		,flow : 'contabilidadcobros/deleteContabilidadCobro'
		,success : function(){
			contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
		}
		,page : page
	});

<%-- Grid --%>
	var contabilidadCobrosGrid = app.crearGrid(contabilidadCobrosStore,contabilidadCobrosCm,{
		title:'<s:message code="contabilidad.grid.titulo" text="**Contabilidad Cobros" />'
		,height : 420
		,style:'padding-right:10px'
		,bbar:[ btnNuevo,btnEditar,btnBorrar ]
	});
	  
	contabilidadCobrosGrid.on('rowdblclick',function(grid, rowIndex, e){
		if(!panel.puedeEditar()) return; 
		if ( !(panel.esGestor() || panel.esSupervisor())) return;
	   	var rec = grid.getSelectionModel().getSelected();
	    var id= rec.get('id');  
		if(!id)
			return;
	    var w = app.openWindow({
	        flow : 'asuntos/contabilidadCobros'
			,width:700
			,title : '<s:message code="contabilidadCobros.edicion" text="**Editar contabilidadCobros" />'
	        ,params : {id:id,idAsunto:panel.getAsuntoId()}
	    });
	    w.on(app.event.DONE, function(){
	        w.close();
			contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
	    });
	    w.on(app.event.CANCEL, function(){ w.close(); });
	});

	panel.add(contabilidadCobrosGrid);

	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		var d=data.contabilidadCobros;
		entidad.cacheOrLoad(data, contabilidadCobrosStore, { id : data.id } );
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
