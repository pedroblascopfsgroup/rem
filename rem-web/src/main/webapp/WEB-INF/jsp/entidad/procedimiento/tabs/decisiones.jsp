<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad){

	var panel = new Ext.Panel({
		autoHeight : true
		,title:'<s:message code="procedimiento.listadoDecisiones.titulo" text="**Decisiones" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,nombreTab : 'decision'
	});

	var idTareaDecision = '';
	var fechaVencimiento = '';
	
	panel.getProcedimientoId = function(){
		return entidad.get("data").id;
	}

	panel.getFechaCreacion = function(){
		return entidad.get("data").tareas.fechaCreacion;
	}
	
	panel.getSituacion = function(){
		return entidad.get("data").tareas.estadoItinerario;
	}
	
	panel.getFechaVenc = function(){
		return entidad.get("data").fechaVenc;
	}
	
	panel.getIdTareaAsociada = function(){
		return entidad.get("data").tarea;
	}
	
	var decisionProcedimiento = Ext.data.Record.create([
		{name:"id"}
		,{name:"finalizada"}
		,{name:"derivaciones"}
		,{name:"paralizada"}
		,{name:"causaDecision"}
		,{name:"estadoDecision"}
		,{name:"fechaParalizacion",type:'date', dateFormat:'d/m/Y'}
		,{name:"comentarios"}
		,{name:"detenida"}
	]);
  
	var decisionProcedimientoStore = page.getStore({
		event:'listado'
		,storeId : 'decisionProcedimientoStore'
		,flow : 'plugin/mejoras/procedimientos/plugin.mejoras.procedimientos.listadoDecisionProcedimiento'
		,reader : new Ext.data.JsonReader({root:'listado'}
		, decisionProcedimiento)
	});

	entidad.cacheStore(decisionProcedimientoStore);
  
	var decisionProcedimientoCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="procedimiento.listadoDecisiones.id" text="**id"/>', dataIndex : 'id',hidden:true}
		,{header : '<s:message code="procedimiento.listadoDecisiones.finalizada" text="**finalizada"/>', dataIndex : 'finalizada',renderer:app.format.booleanToYesNoRenderer}
		,{header : '<s:message code="procedimiento.listadoDecisiones.paralizada" text="**paralizada"/>', dataIndex : 'paralizada',renderer:app.format.booleanToYesNoRenderer}
		,{header : '<s:message code="procedimiento.listadoDecisiones.nroderivaciones" text="**Cant. Derivaciones"/>', dataIndex : 'derivaciones'}
		,{header : '<s:message code="procedimiento.listadoDecisiones.causaDecision" text="**causaDecision"/>', dataIndex : 'causaDecision'}
		,{header : '<s:message code="procedimiento.listadoDecisiones.estado" text="**estadoDecision"/>', dataIndex : 'estadoDecision'}
		,{header : '<s:message code="procedimiento.listadoDecisiones.fechaParalizacion" text="**fechaParalizacion"/>', dataIndex : 'fechaParalizacion', renderer:app.format.dateRenderer }
		,{header : '<s:message code="procedimiento.listadoDecisiones.comentarios" text="**comentarios"/>', dataIndex : 'comentarios'}
		,{header : '<s:message code="plugin.mejoras.procedimiento.listadoDecisiones.detenida" text="**detenida"/>', dataIndex : 'detenida'}
	]);
  
	var btnNuevo = new Ext.Button({
		 text: '<s:message code="app.agregar" text="**Agregar" />'
		 ,iconCls : 'icon_mas'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
			var parametros = {
				idProcedimiento : panel.getProcedimientoId()
				,isConsulta : false
			};
			var w = app.openWindow({
				flow : 'procedimientos/decisionProcedimiento'
				,width : 870
				,title : '<s:message code="procedimiento.listadoDecisiones.alta" text="**Alta DecisionProcedimiento" />'
				,params : parametros
			});
			w.on(app.event.DONE, function(){
				w.close();
				decisionProcedimientoStore.webflow({id:panel.getProcedimientoId()});
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var btnEditar = new Ext.Button({
		 text: '<s:message code="procedimiento.listadoDecisiones.botoneditar" text="**Editar / Ver" />'
		 ,iconCls : 'icon_edit'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
			var rec =  decisionProcedimientoGrid.getSelectionModel().getSelected();
			if (!rec) return;
				var id = rec.get("id");
			var parametros = {
					idProcedimiento : panel.getProcedimientoId(),
					isConsulta : false,
					id : id
			};
			var w = app.openWindow({
				flow : 'procedimientos/decisionProcedimiento'
				,width : 870
				,title : '<s:message code="procedimiento.listadoDecisiones.editar" text="**Editar Decision" />'
				,params : parametros
			});
			w.on(app.event.DONE, function(){
				w.close();
				decisionProcedimientoStore.webflow({id:panel.getProcedimientoId()});
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});
	
	var funcionProrroga = function(){
		var w = app.openWindow({
			flow : 'tareas/solicitarProrroga'
			,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prórroga" />'
			,width:550 
			,params : {
				idEntidadInformacion: panel.getProcedimientoId()
				,fechaCreacion: panel.getFechaCreacion()
				,situacion: panel.getSituacion()
				,fechaVencimiento: app.format.dateRenderer(panel.getFechaVenc())
				,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'
				,descripcion: 'decision'
				,idTareaAsociada: panel.getIdTareaAsociada()
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
	
	var buttonBar = [ btnNuevo, btnEditar, btnProrroga2 ];

	var decisionProcedimientoGrid = app.crearGrid(decisionProcedimientoStore,decisionProcedimientoCm,{
		title:'<s:message code="procedimiento.listadoDecisiones.titulo" text="**DecisionProcedimiento" />'
		,height : 400
		,style:'padding-right:10px'
		,bbar:buttonBar
	});
 
	decisionProcedimientoGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idTareaDecision = rec.get('id')
		fechaVencimiento = rec.get('fechaVenc')
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
            ,params : {idProcedimiento:panel.getProcedimientoId(),id:id, isConsulta:false}
        });
        w.on(app.event.DONE, function(){
			w.close();
			decisionProcedimientoStore.webflow({id:panel.getProcedimientoId()});
		});
        w.on(app.event.CANCEL, function(){ w.close(); });
	});


	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, decisionProcedimientoStore, {id : data.id});
		var visibles = [
			 [btnNuevo, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
			,[btnEditar, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
			,[btnProrroga2, data.tarea!=null && data.tarea!='']
		];
		
		entidad.setVisible(visibles);
		var enabled= [
			[btnNuevo, data.procedimientoAceptado && data.derivacionAceptada ]
		];
		entidad.setEnabled(enabled);
	}

	panel.add(decisionProcedimientoGrid);

	return panel;
})
