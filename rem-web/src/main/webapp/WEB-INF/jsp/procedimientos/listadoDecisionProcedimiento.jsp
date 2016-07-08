<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var createDecisionProcedimientoTab=function(){

	var decisionProcedimiento = Ext.data.Record.create([
			{name:"id"}
			,{name:"finalizada"}
			,{name:"derivaciones"}
			,{name:"paralizada"}
			,{name:"causaDecision"}
			,{name:"estadoDecision"}
			,{name:"fechaParalizacion",type:'date', dateFormat:'d/m/Y'}
			,{name:"comentarios"}
	]);
	var decisionProcedimientoStore = page.getStore({
		event:'listado'
		,flow : 'procedimientos/listadoDecisionProcedimiento'
		,reader : new Ext.data.JsonReader({root:'listado'}
		, decisionProcedimiento)
	});
	
	decisionProcedimientoStore.webflow({id:${procedimiento.id}}); 
	var decisionProcedimientoCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="procedimiento.listadoDecisiones.id" text="**id"/>', dataIndex : 'id',hidden:true}
		,{header : '<s:message code="procedimiento.listadoDecisiones.finalizada" text="**finalizada"/>', dataIndex : 'finalizada',renderer:app.format.booleanToYesNoRenderer}
		,{header : '<s:message code="procedimiento.listadoDecisiones.paralizada" text="**paralizada"/>', dataIndex : 'paralizada',renderer:app.format.booleanToYesNoRenderer}
		,{header : '<s:message code="procedimiento.listadoDecisiones.nroderivaciones" text="**Cant. Derivaciones"/>', dataIndex : 'derivaciones'}
		,{header : '<s:message code="procedimiento.listadoDecisiones.causaDecision" text="**causaDecision"/>', dataIndex : 'causaDecision'}
		,{header : '<s:message code="procedimiento.listadoDecisiones.estado" text="**estadoDecision"/>', dataIndex : 'estadoDecision'}
		,{header : '<s:message code="procedimiento.listadoDecisiones.fechaParalizacion" text="**fechaParalizacion"/>', dataIndex : 'fechaParalizacion', renderer:app.format.dateRenderer }
		,{header : '<s:message code="procedimiento.listadoDecisiones.comentarios" text="**comentarios"/>', dataIndex : 'comentarios'}
	]);
	
	var btnNuevo= app.crearBotonAgregar({
		text:'<s:message code="app.agregar" text="**Agregar" />'
		,flow : 'procedimientos/decisionProcedimiento'
		,width:870
		,title : '<s:message code="procedimiento.listadoDecisiones.alta" text="**Alta DecisionProcedimiento" />'
		,params:{idProcedimiento:${procedimiento.id}, isConsulta:false}
		,success:function(){
			decisionProcedimientoStore.webflow({id:${procedimiento.id}});
		}
	});
	var btnEditar= app.crearBotonEditar({
		text:'<s:message code="procedimiento.listadoDecisiones.botoneditar" text="**Editar / Ver" />'
		,flow : 'procedimientos/decisionProcedimiento'
			,width:870
		,title : '<s:message code="procedimiento.listadoDecisiones.editar" text="**Editar Decision" />'
		,params:{idProcedimiento:${procedimiento.id}, isConsulta:false}
		,success:function(){
		
			decisionProcedimientoStore.webflow({id:${procedimiento.id}});
		}
	});


	var buttonBar = new Array();
	<c:if test="${procedimiento.estaAceptado && (esGestor || esSupervisor)}">
		buttonBar.push(btnNuevo);
		buttonBar.push(btnEditar);
	</c:if> 

	var decisionProcedimientoGrid = app.crearGrid(decisionProcedimientoStore,decisionProcedimientoCm,{
		title:'<s:message code="procedimiento.listadoDecisiones.titulo" text="**DecisionProcedimiento" />'
		,height : 400
		,style:'padding-right:10px'
		,bbar:buttonBar
	});
 
	decisionProcedimientoGrid.on('rowdblclick',function(grid, rowIndex, e){
		
       	var rec = decisionProcedimientoGrid.getSelectionModel().getSelected();
           var id= rec.get('id');
		if(!id)
			return;
           var w = app.openWindow({
               flow : 'procedimientos/decisionProcedimiento'
			,width:870
			,title : '<s:message code="procedimiento.listadoDecisiones.editar" text="**Editar Decision" />'
               ,params : {idProcedimiento:${procedimiento.id},id:id, isConsulta:false}
           });
           w.on(app.event.DONE, function(){
               w.close();
			  decisionProcedimientoStore.webflow({id:${procedimiento.id}});
           });
           w.on(app.event.CANCEL, function(){ w.close(); });
	});
	var panel = new Ext.Panel({
		autoHeight : true
		,title:'<s:message code="procedimiento.listadoDecisiones.titulo" text="**Decisiones" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items :decisionProcedimientoGrid
	});
	return panel;
}
