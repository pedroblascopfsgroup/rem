<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
(function(){
	
	var esSupervisor = false;

	<c:if test="${esSupervisor}">
		//Seteamos la variable en caso de que sea supervisor		
		esSupervisor = true;
	</c:if>


	var tarea = Ext.data.Record.create([                                                                                                                              
		{name  : "tarea"           }
		,{name  : "id"           }
		,{name  : "idTareaProcedimiento"           }
		,{name  : "descTareaProcedimiento"           }
		,{name : "fechaInicio",type:'date', dateFormat:'d/m/Y'}
		,{name : "fechaVenc",type:'date', dateFormat:'d/m/Y'}
		,{name : "fechaFin" ,type:'date', dateFormat:'d/m/Y'}
		,{name : "usuario"         }
		,{name : "prorrogaAsociada"		}
		,{name : "motivo"		}
		,{name : "fechaPropuesta"		}
		,{name : "descPropuesta"		}		
		,{name : "subtipoTarea"}		
		,{name : "vueltaAtras"}
	]);                                                                                                                                                                  
	var fechaVenciProrroga = '';
	var descTareaProrroga = '';
	var idTareaProrroga = '';
	var idProrrogaProrroga = '';
	var fechaPropuestaProrroga = '';
	var motivoProrroga = '';
	var descPropuestaProrroga = '';
	var idTareaVueltaAtras = null;

	var funcionCancelaExterna = function()
	{
		var rec = tareasGrid.getSelectionModel().getSelected();
		var idTareaExterna = null;
	
		//Si no ha seleccionado ninguna fila, podemos consultar si solo tiene una posible tarea vuelta atras
		if (rec != null)
		{
			var idTareaExterna = rec.get('id');

			if (idTareaExterna != null)
			{
				var w = app.openWindow({
					flow : 'procedimientos/cancelarTarea'
					//,width:320
					,autoWidth:true
					,closable:true
					,title : '<s:message code="procedimiento.cancelarTarea.titulo" text="**Cancelar tarea" />'
					,params:{id:idTareaExterna}
				
				});
				w.on(app.event.DONE, function(){			
					w.close();
					app.abreProcedimientoTab('${procedimiento.id}', null, 'tareas');
				});
				w.on(app.event.CANCEL, function(){
					w.close();
				});
				
			}
		}

	}

	var funcionEditaTareaExterna = function(){
		var rec = tareasGrid.getSelectionModel().getSelected();
		var id = rec.get('id');

		var titulo = '${procedimiento.tipoProcedimiento.descripcion}' +' - ' + rec.get('descTareaProcedimiento');
		var w = app.openWindow({
			flow : 'generico/genericForm'
			//,width:320
			,autoWidth:true
			,closable:true
			,title : titulo
			,params:{idTareaExterna:id,idProcedimiento:${procedimiento.id}}
		
		});
		w.on(app.event.DONE, function(){			
			w.close();
			app.abreProcedimientoTab('${procedimiento.id}', null, 'tareas');
		});
		w.on(app.event.CANCEL, function(){
			w.close();
		});
	};


	var redefinirFuncionProrroga = function(){
		var w = app.openWindow({
						flow : 'tareas/solicitarProrroga'
						,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prórroga" />'
						,width:550 
						,params : {
								idEntidadInformacion: '${procedimiento.id}'
								,fechaCreacion: '<fwk:date value="${procedimiento.auditoria.fechaCrear}"/>'
								,situacion: '${procedimiento.asunto.estadoItinerario.descripcion}'
								,fechaVencimiento: app.format.dateRenderer(fechaVenciProrroga)
								,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
								,descripcion: descTareaProrroga
								,idTareaAsociada:idTareaProrroga
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_EXTERNA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						btnContestarProrroga.setDisabled(true);
						btnProrroga.setDisabled(true);
						tareasProcStore.webflow({idProcedimiento:'${procedimiento.id}'}); 
						
					});
					w.on(app.event.CANCEL, function(){ 
					w.close(); });
	};
	
	var redefinirFuncionContestarProrroga = function(){
		var w = app.openWindow({
						flow : 'tareas/decisionProrroga'
						,title : '<s:message code="expedientes.menu.aceptarprorroga" text="**Solicitar Prorroga" />'
						,width:470 
						,params : {
								idEntidadInformacion: '${procedimiento.id}'
								,isConsulta:false
								,fechaVencimiento: app.format.dateRenderer(fechaVenciProrroga)
								,fechaCreacion: '<fwk:date value="${procedimiento.auditoria.fechaCrear}"/>'
								,situacion: '${procedimiento.asunto.estadoItinerario.descripcion}'
								,destareaOri: descPropuestaProrroga
								,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
								,fechaPropuesta: fechaPropuestaProrroga
								,motivo: motivoProrroga
								,idTareaOriginal: idProrrogaProrroga		
								,descripcion:descTareaProrroga		
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_EXTERNA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						btnContestarProrroga.setDisabled(true);
						btnProrroga.setDisabled(true);
						tareasProcStore.webflow({idProcedimiento:'${procedimiento.id}'}); 
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				
	};
	                                                                                                                                                               
	var btnProrroga =new Ext.Button({
			text : '<s:message code="procedimiento.gridtareas.solicitarprorroga" text="**Solicitar Prórroga" />'
			,iconCls : 'icon_sol_prorroga'
			,disabled:true
			,handler:redefinirFuncionProrroga
	});
	
	var btnContestarProrroga =new Ext.Button({
			text : '<s:message code="procedimiento.gridtareas.aceptarprorroga" text="**Aceptar Prórroga" />'
			,iconCls : 'icon_aceptar_prorroga'
			,disabled:true
			,handler:redefinirFuncionContestarProrroga
	});

	var btnEditar =new Ext.Button({
    	text:'<s:message code="app.ver_editar" text="**Ver/Editar" />'
		<app:test id="btnVerEditarTareaExterna" addComa="true" />
       	,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:funcionEditaTareaExterna
		,disabled: true
	});

	var btnVueltaAtras =new Ext.Button({
    	text:'<s:message code="app.botones.vueltaAtras" text="**Cancelar última tarea" />'
		<app:test id="btnVueltaAtras" addComa="true" />
       	,iconCls : 'icon_cancel'
		,cls: 'x-btn-text-icon'
		,handler:funcionCancelaExterna
		,disabled: true
	});


	                                                                                                                                                                     
	var tareasProcStore = page.getStore({                                                                                                                                 
		event:'listado'
		,flow : 'procedimientos/tareasProcedimiento'                                                                                                                          
		,reader : new Ext.data.JsonReader(
			{root:'tareasProcedimiento'}
			, tarea
		)                                                                                                  
	});                                                                                                                                                                  
	                                                                                                                                                                     
	tareasProcStore.webflow({idProcedimiento:'${procedimiento.id}'}); 
	

	var tareasCm = new Ext.grid.ColumnModel([
		{dataIndex : 'id', fixed:true, hidden:true}
		,{dataIndex : 'prorrogaAsociada', fixed:true, hidden:true}
		,{dataIndex : 'motivo', fixed:true, hidden:true}
		,{dataIndex : 'fechaPropuesta', fixed:true, hidden:true}
		,{dataIndex : 'descPropuesta', fixed:true, hidden:true}
		,{header : '<s:message code="procedimiento.gridtareas.tarea" text="**tarea"/>', dataIndex : 'tarea', width:275}
		,{header : '<s:message code="procedimiento.gridtareas.fechaInicio" text="**fecha inicio"/>', dataIndex : 'fechaInicio', renderer:app.format.dateRenderer, width:75}
		,{header : '<s:message code="procedimiento.gridtareas.fechaVenc" text="**fecha vencimiento"/>', dataIndex : 'fechaVenc', renderer:app.format.dateRenderer, width:75}
		,{header : '<s:message code="procedimiento.gridtareas.fechaFin" text="**fecha fin"/>', dataIndex : 'fechaFin', renderer:app.format.dateRenderer, width:75}
		,{header : '<s:message code="procedimiento.gridtareas.usuarioCreacion" text="**usuario"/>', dataIndex : 'usuario', width:50}
	]);
	

	var btnBar = [];
	<c:if test="${procedimiento.estaAceptado && (esGestor || esSupervisor)}">
		if (!esSupervisor)
		{
			btnBar.push(btnProrroga);
		}
		else
		{
			btnBar.push(btnContestarProrroga);
		}
	
		btnBar.push(btnEditar);
		btnBar.push(btnVueltaAtras);
	</c:if>

    var tareasGrid = app.crearGrid(tareasProcStore,tareasCm,{
		title:'<s:message code="procedimiento.gridtareas.titulo" text="**tareas del procedimiento" />'
		,cls:'cursor_pointer'
		,width : 700
		,height : 400
		,bbar:btnBar
    });


	tareasGrid.on('rowclick',function(grid, rowIndex, e){
		
		var rec = grid.getStore().getAt(rowIndex);
		var fechaFin = rec.get('fechaFin');
		var vueltaAtras = rec.get('vueltaAtras');

		var prorrogaAsociada = rec.get('prorrogaAsociada');
		if (fechaFin == '' && prorrogaAsociada==''){
			btnProrroga.setDisabled(false);
			fechaVenciProrroga = rec.get('fechaVenc');
			descTareaProrroga = rec.get('tarea');
			idTareaProrroga = rec.get('id');
			btnContestarProrroga.setDisabled(true);
		}else if (fechaFin == '' && prorrogaAsociada!=''){
			fechaVenciProrroga = rec.get('fechaVenc');
			descTareaProrroga = rec.get('tarea');
			idTareaProrroga = rec.get('id');
			motivoProrroga = rec.get('motivo');
			descPropuestaProrroga = rec.get('descPropuesta');			
			fechaPropuestaProrroga = rec.get('fechaPropuesta');
			idProrrogaProrroga = prorrogaAsociada;
			btnContestarProrroga.setDisabled(false);
			btnProrroga.setDisabled(true); 
		}else{	
			btnContestarProrroga.setDisabled(true);
			btnProrroga.setDisabled(true);
		}

		if (vueltaAtras == true)
			btnVueltaAtras.setDisabled(false);
		else
			btnVueltaAtras.setDisabled(true);

	
		
			btnEditar.enable();
		
	});

	<c:if test="${esGestor || esSupervisor}">
	    //Solo puede acceder a la tarea si es gestor o supervisor de ella 
		tareasGrid.on('rowdblclick',function(grid, rowIndex, e){
			var rec = grid.getStore().getAt(rowIndex);
			funcionEditaTareaExterna();
		});
	</c:if>

	var panel = new Ext.Panel({
		title:'<s:message code="procedimiento.tareas" text="**tareas"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[tareasGrid]
		,nombreTab : 'tareas'
	});
	
	return panel;
})()
