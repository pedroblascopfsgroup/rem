<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){

	var decisionProcedimiento = Ext.data.Record.create([
			{name:"id"}
			,{name:"finalizada"}
			,{name:"derivaciones"}
			,{name:"paralizada"}
			,{name:"causaDecision"}
			,{name:"estadoDecision"}
			,{name:"fechaParalizacion"}
			,{name:"comentarios"}
			,{name:"detenida"}
	]);
	
	<%--var tareaReanudada = null;--%>
	var decisionProcedimientoStore = page.getStore({
		event:'listado'
		,flow : 'plugin/mejoras/procedimientos/plugin.mejoras.procedimientos.listadoDecisionProcedimiento'
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
		,{header : '<s:message code="procedimiento.listadoDecisiones.fechaParalizacion" text="**fechaParalizacion"/>', dataIndex : 'fechaParalizacion'}
		,{header : '<s:message code="procedimiento.listadoDecisiones.comentarios" text="**comentarios"/>', dataIndex : 'comentarios'}
		,{header : '<s:message code="plugin.mejoras.procedimiento.listadoDecisiones.detenida" text="**detenida"/>', dataIndex : 'detenida'}
	]);
	
	var btnNuevo= app.crearBotonAgregar({
		text:'<s:message code="app.agregar" text="**Agregar" />'
		,flow : 'procedimientos/decisionProcedimiento'
		,width:870
		,title : '<s:message code="procedimiento.listadoDecisiones.alta" text="**Alta DecisionProcedimiento" />'
		,params:{idProcedimiento:${procedimiento.id}, isConsulta:false}
		,success:function(){
			decisionProcedimientoStore.webflow({id:${procedimiento.id}}); 
			<%--if ('${tarea}'!=''){
				app.openTab('<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />', 'procedimientos/consultaProcedimiento', {id:'${procedimiento.id}',tarea:'${tarea}',fechaVenc:'${fechaVenc}',nombreTab:'decision'} , {id:'procedimiento'+'${procedimiento.id}',iconCls:'icon_procedimiento'});
			}else{
				app.abreProcedimientoTab('${procedimiento.id}'
			 		, '<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />'
			 		, procedimientoTabPanel.getActiveTab().initialConfig.nombreTab);
			}--%>		 		
		}
	});
	
	
	<c:if test="${!procedimiento.estaAceptado || !procedimiento.derivacionAceptada}">
		btnNuevo.setDisabled(true);
	</c:if>
	
	
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

	<%--var btnReanudar = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.decision.reanudarProcedimiento" text="**Reanudar"/>'
		,iconCls: 'icon_reanudar'
		,handler : function() {
		
			if (decisionProcedimientoGrid.getSelectionModel().getCount()>0){
				if (tareaReanudada!= decisionProcedimientoGrid.getSelectionModel().getSelected().get('id')){
				
				var id = ${procedimiento.id};
				var parms = {id : id};
				
				tareaReanudada = decisionProcedimientoGrid.getSelectionModel().getSelected().get('id');
                
                page.webflow({
                	flow: 'plugin/mejoras/procedimientos/plugin.mejoras.procedimientos.reanudasProcedimiento'
                    ,params: parms
                    ,success : function(){
                    	decisionProcedimientoGrid.store.webflow(parms);
                    	Ext.Msg.alert('<s:message code="plugin.mejoras.procedimiento.decision.reanudar" text="**Reanudar Procedimiento" />','<s:message code="plugin.mejoras.procedimiento.decision.reaunudado" text="**El procedimiento ha sido reanudado" />');
                    }
                   });
                  
                   }
                   else{
                   	Ext.Msg.alert('<s:message code="plugin.mejoras.procedimiento.decision.reanudar" text="**Editar descripción del adjunto del expediente" />','<s:message code="plugin.mejoras.asunto.adjuntos.yaReanudada" text="**El procedimiento ya ha sido reanudado" />');
                   }   
			}else{
				Ext.Msg.alert('<s:message code="plugin.mejoras.procedimiento.decision.reanudar" text="**Editar descripción del adjunto del expediente" />','<s:message code="plugin.mejoras.asunto.adjuntos.noValor" text="**Debe seleccionar un valor de la lista" />');
			}
		}
		
	});--%>
	
	
	var fechaVenciProrroga = '${fechaVenc}';
	
	var funcionProrroga = function(){
		var w = app.openWindow({
						flow : 'tareas/solicitarProrroga'
						,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prórroga" />'
						,width:550 
						,params : {
								idEntidadInformacion: '${procedimiento.id}'
								,fechaCreacion: '<fwk:date value="${procedimiento.auditoria.fechaCrear}"/>'
								,situacion: '${procedimiento.asunto.estadoItinerario.descripcion}'
								,fechaVencimiento: app.format.dateRenderer(fechaVenciProrroga)
								,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'
								,descripcion: 'decision'
								,idTareaAsociada:'${tarea}'
								,permiteAutoprorroga:'false'
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_EXTERNA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						btnProrroga2.setDisabled(true);
					});
					w.on(app.event.CANCEL, function(){ 
						w.close(); 
					});
	};
	
	var btnProrroga2 =new Ext.Button({
			text : '<s:message code="procedimiento.gridtareas.solicitarprorroga" text="**Solicitar Prórroga" />'
			,iconCls : 'icon_sol_prorroga'
			,disabled:false
			,handler:funcionProrroga
	});
	 
	 
	
	var buttonBar = new Array();
	<c:if test="${procedimiento.estaAceptado && (esGestor || esSupervisor)}">
		buttonBar.push(btnNuevo);
		buttonBar.push(btnEditar);
		<%--buttonBar.push(btnReanudar);--%>
	</c:if>
	 
	<c:if test="${tarea!=null}">
		buttonBar.push(btnProrroga2);
	</c:if>
	  

	<%--btnReanudar.disable();--%>
	var decisionProcedimientoGrid = app.crearGrid(decisionProcedimientoStore,decisionProcedimientoCm,{
		title:'<s:message code="procedimiento.listadoDecisiones.titulo" text="**DecisionProcedimiento" />'
		,height : 400
		,style:'padding-right:10px'
		,bbar:buttonBar
	});
 	<%--
 	if ('${paralizado}'!= null && '${paralizado}'==false){
 		btnReanudar.enable();
		} else {
			btnReanudar.disable();
 	}
  --%>
 	decisionProcedimientoGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var paralizada = rec.get('paralizada');
		var aceptada = rec.get('estadoDecision');
		var detenida = rec.get('detenida');
		<%--if(paralizada == true && aceptada=='ACEPTADO' ) {
			btnReanudar.enable();
		} else {
			btnReanudar.disable();
		}--%>
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
		,nombreTab : 'decision'
	});
	
	<%--btnReanudar.hide()
	<sec:authorize ifAllGranted="ROLE_REANUDAR_PROC">
		btnReanudar.show();
	</sec:authorize>
	--%>
	return panel;
})()