<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

(function(){
	
	var  CODIGO_ASUNTO_ACEPTADO = "<fwk:const value="es.capgemini.pfs.asunto.model.DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO" />";
	var estadoAsunto='${asunto.estadoAsunto.codigo}';
	var cobroPago = Ext.data.Record.create([
			{name:"id"}
			,{name:"procedimiento"}
			,{name:"estado"}
			,{name:"subTipo"}
			,{name:"importe"}
			,{name:"fecha"}
			,{name:"origenCobro"}
			,{name:"modalidadCobro"}
	]);
	var cobroPagoStore = page.getStore({event:'listado',flow : 'asuntos/listadoCobroPago',reader : new Ext.data.JsonReader({root:'listado'}, cobroPago)});
	
	cobroPagoStore.webflow({id:'${asunto.id}'}); 
	var cobroPagoCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="" text="**id"/>', dataIndex : 'id',hidden:true}
		,{header : '<s:message code="cobroPago.procedimiento" text="**procedimiento"/>', dataIndex : 'procedimiento'}
		,{header : '<s:message code="cobroPago.estado" text="**estado"/>', dataIndex : 'estado'}
		,{header : '<s:message code="cobroPago.subTipo" text="**subTipo"/>', dataIndex : 'subTipo'}
		,{header : '<s:message code="cobroPago.importe" text="**importe"/>', dataIndex : 'importe'}
		,{header : '<s:message code="cobroPago.fecha" text="**fecha"/>', dataIndex : 'fecha'}
		,{header : '<s:message code="plugin.liquidaciones.cobroPago.origenCobro" text="**Origen cobro"/>', dataIndex : 'origenCobro'}
		,{header : '<s:message code="plugin.liquidaciones.cobroPago.modalidadCobro" text="**Modalidad cobro"/>', dataIndex : 'modalidadCobro'}
	]);

	var btnNuevo= app.crearBotonAgregar({
		text:'<s:message code="app.agregar" text="**Agregar" />'
		,flow : 'asuntos/cobroPago'
		,width:700
		,title : '<s:message code="cobroPago.alta" text="**Alta CobroPago" />'
		,params:{idAsunto:'${asunto.id}'}
		,success:function(){
			cobroPagoStore.webflow({id:'${asunto.id}'});	
		}
	});
	var btnEditar= app.crearBotonEditar({
		text:'<s:message code="app.editar" text="**Editar" />'
		,flow : 'asuntos/cobroPago'
		,width:700
		,title : '<s:message code="cobroPago.edicion" text="**Editar CobroPago" />'
		
		,params:{idAsunto:'${asunto.id}'}
		,success:function(){
			cobroPagoStore.webflow({id:'${asunto.id}'});	
		}
		});
		
	
	var btnBorrar = app.crearBotonBorrar({
		text : '<s:message code="app.borrar" text="**Borrar" />'
		,flow : 'asuntos/borraCobroPago'
		,success : function(){
			cobroPagoStore.webflow({id:'${asunto.id}'});
		}
		,page : page
	});
	var bbar=new Ext.Toolbar();
	var cobroPagoGrid = app.crearGrid(cobroPagoStore,cobroPagoCm,{
		title:'<s:message code="cobroPago.grid" text="**CobroPago" />'
		,height : 420
		,style:'padding-right:10px'
		,bbar:[
	        	btnNuevo,btnEditar,btnBorrar
			
		]
	});
	//"${asunto.estadoAsunto.codigo}" 
	//"${asunto.estadoAsunto.codigo == CODIGO_ASUNTO_ACEPTADO}"
	//${esGestor || esSupervisor}
	var puedeEditar = eval(${asunto.estadoAsunto.codigo} == CODIGO_ASUNTO_ACEPTADO)
	btnNuevo.setVisible(puedeEditar);
	btnEditar.setVisible(puedeEditar);
	btnBorrar.setVisible(puedeEditar);
	  
	<c:if test="${esGestor || esSupervisor}">
		cobroPagoGrid.on('rowdblclick',function(grid, rowIndex, e){
			if(!puedeEditar)
				return; 
	       	var rec = grid.getSelectionModel().getSelected();
	        var id= rec.get('id');  
			if(!id)
				return;
	           var w = app.openWindow({
	            flow : 'asuntos/cobroPago'
				,width:700
				,title : '<s:message code="cobroPago.edicion" text="**Editar CobroPago" />'
	             ,params : {id:id,idAsunto:'${asunto.id}'}
	          });
	           w.on(app.event.DONE, function(){
	               w.close();
				  cobroPagoStore.webflow({id:'${asunto.id}'});
	           });
	           w.on(app.event.CANCEL, function(){ w.close(); });
		});
	</c:if>
	var panel = new Ext.Panel({
		autoHeight : true
		,title:'<s:message code="cobroPago.titulo" text="**Cobros/Pagos" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items :cobroPagoGrid
		,nombretab : 'cobrosPagos'
	});
	return panel;
})()
