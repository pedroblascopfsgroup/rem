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
		title:'<s:message code="procedimiento.tareas" text="**tareas"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,nombreTab : 'tareas'
	});

	var tarea = Ext.data.Record.create([                                                                                                                              
		{name  : "tarea"           }
		,{name  : "id"           }
		,{name  : "idTareaProcedimiento"           }
		,{name  : "descTareaProcedimiento"           }
		,{name : "fechaInicio"}
		,{name : "fechaVenc"}
		,{name : "fechaFin"}
		,{name : "usuario"         }
		,{name : "prorrogaAsociada"    }
		,{name : "motivo"    }
		,{name : "fechaPropuesta"    }
		,{name : "descPropuesta"    }    
		,{name : "subtipoTarea"}    
		,{name : "vueltaAtras"}
		,{name : "autoprorroga"}
		,{name : "maximoAutoprorrogas"}
		,{name : "numeroAutoprorrogas"}
		,{name : "permiteProrrogas"}
	]);                                                                                                                                                                  
	
	var fechaVenciProrroga = '';
	var descTareaProrroga = '';
	var idTareaProrroga = '';
	var idProrrogaProrroga = '';
	var fechaPropuestaProrroga = '';
	var motivoProrroga = '';
	var descPropuestaProrroga = '';
	var idTareaVueltaAtras = null;
	var maximoAutoP='';
	var numeroAutoP='';
	
	var funcionCancelaExterna = function() {
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
			  ,autoWidth:true
			  ,closable:true
			  ,title : '<s:message code="procedimiento.cancelarTarea.titulo" text="**Cancelar tarea" />'
			  ,params:{id:idTareaExterna}
			
			});
			w.on(app.event.DONE, function(){      
			  w.close();
			  app.abreProcedimientoTab(panel.getProcedimientoId(), null, 'tareas');
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

		var titulo = panel.getData().cabecera.procedimiento +' - ' + rec.get('descTareaProcedimiento');
		var w = app.openWindow({
		  flow : 'generico/genericForm'
		  //,width:320
		  ,autoWidth:true
		  ,closable:true
		  ,title : titulo
		  ,params:{idTareaExterna:id,idProcedimiento:panel.getProcedimientoId()}
		
		});
		w.on(app.event.DONE, function(){      
		  w.close();
		  app.abreProcedimientoTab(panel.getProcedimientoId(), null, 'tareas');
		});
		w.on(app.event.CANCEL, function(){
		  w.close();
		});
  };
  
	var funcionValidarResolucion = function(){
		//Ext.MessageBox.alert("funcionValidarResolucion","funcionValidarResolucion")
		var rec = tareasGrid.getSelectionModel().getSelected();
		//var id = rec.get('id');

		var titulo = panel.getData().cabecera.procedimiento +' - ' + rec.get('descTareaProcedimiento');
		var w = app.openWindow({
		  flow : 'pcdprocesadoresoluciones/abreFormularioDinamicoDesdeProcedimiento'
		  ,width:858
		  ,autoWidth:true
		  ,closable:true
		  ,title : titulo
		  ,params:{idResolucion:idResolucion}
		
		});
		w.on(app.event.DONE, function(){      
		  w.close();
		  app.abreProcedimientoTab(panel.getProcedimientoId(), null, 'tareas');
		});
		w.on(app.event.CANCEL, function(){
		  w.close();
		});
  };  


	var redefinirFuncionProrroga = function(){
		var w = app.openWindow({
            flow : 'tareas/solicitarProrroga'
            ,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prorroga" />'
            ,width:550 
            ,params : {
                idEntidadInformacion:panel.getProcedimientoId()
                ,fechaCreacion: panel.getData().tareas.fechaCreacion
                ,situacion: panel.getData().tareas.estadoItinerario
                ,fechaVencimiento: fechaVenciProrroga
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
			btnAutoProrroga.setDisabled(true);
            tareasProcStore.webflow({idProcedimiento:panel.getProcedimientoId()}); 
        });
        w.on(app.event.CANCEL, function(){ 
        w.close(); });
	};
  
	var definirAutoProrroga=function(){
		var w = app.openWindow({
			flow : 'plugin/mejoras/tareas/plugin.mejoras.tareas.generarAutoprorroga'
			,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prórroga" />'
			,width:550 
			,params : {
				idEntidadInformacion: panel.getProcedimientoId()
				,fechaCreacion: panel.getData().tareas.fechaCreacion
				,situacion: panel.getData().tareas.estadoItinerario
				,fechaVencimiento: fechaVenciProrroga
				,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
				,descripcion: descTareaProrroga
				,idTareaAsociada: idTareaProrroga
				,maximoAutoprorrogas: maximoAutoP
				,numeroAutoprorrogas: numeroAutoP
				,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_EXTERNA" />'
			}
		});
		w.on(app.event.DONE, function(){
			w.close();
			btnContestarProrroga.setDisabled(true);
			btnProrroga.setDisabled(true);
			btnAutoProrroga.setDisabled(true);
			tareasProcStore.webflow({idProcedimiento:panel.getProcedimientoId()}); 
			
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
				idEntidadInformacion:panel.getProcedimientoId()
				,isConsulta:false
				,fechaVencimiento: fechaVenciProrroga
				,fechaCreacion: panel.getData().tareas.fechaCreacion 
				,situacion: panel.getData().tareas.estadoItinerario
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
			btnAutoProrroga.setDisabled(true);
			tareasProcStore.webflow({idProcedimiento:panel.getProcedimientoId()}); 
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};
                                                                                                                                                                 
  var btnProrroga =new Ext.Button({
      text : '<s:message code="procedimiento.gridtareas.solicitarprorroga" text="**Solicitar Prórroga" />'
      ,iconCls : 'icon_sol_prorroga'
      ,disabled:true
      ,handler:redefinirFuncionProrroga
  });
  
  
	var btnAutoProrroga =new Ext.Button({
		text : '<s:message code="plugin.mejoras.procedimientos.tabTareas.autoprorroga" text="**Autoprórroga" />'
		,iconCls : 'icon_sol_prorroga'
		,disabled: true
		,handler: definirAutoProrroga
	});
	
	var btnContestarProrroga =new Ext.Button({
		text : '<s:message code="procedimiento.gridtareas.aceptarprorroga" text="**Aceptar Prórroga" />'
		,iconCls : 'icon_aceptar_prorroga'
		,disabled:true
		,handler: redefinirFuncionContestarProrroga
	});

	var btnEditar =new Ext.Button({
		text:'<s:message code="app.ver_editar" text="**Ver/Editar" />'
		<app:test id="btnVerEditarTareaExterna" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:funcionEditaTareaExterna
		,disabled: true
	});
	
	var btnValidar =new Ext.Button({
		text:'<s:message code="procuradores.Validar" text="**Validar Y Procesar" />'
		<app:test id="btnVerEditarTareaExterna" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:funcionValidarResolucion
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
		,storeId : 'tareasProcStore'
		,reader : new Ext.data.JsonReader( {root:'tareasProcedimiento'} , tarea )
	});
	  
	entidad.cacheStore(tareasProcStore);

	var tareasCm = new Ext.grid.ColumnModel([
		{dataIndex : 'id', fixed:true, hidden:true}
		,{dataIndex : 'prorrogaAsociada', fixed:true, hidden:true}
		,{dataIndex : 'motivo', fixed:true, hidden:true}
		,{dataIndex : 'fechaPropuesta', fixed:true, hidden:true}
		,{dataIndex : 'descPropuesta', fixed:true, hidden:true}
		,{header : '<s:message code="procedimiento.gridtareas.tarea" text="**tarea"/>', dataIndex : 'tarea', width:275}
		,{header : '<s:message code="procedimiento.gridtareas.fechaInicio" text="**fecha inicio"/>', dataIndex : 'fechaInicio', width:75}
		,{header : '<s:message code="procedimiento.gridtareas.fechaVenc" text="**fecha vencimiento"/>', dataIndex : 'fechaVenc', width:75}
		,{header : '<s:message code="procedimiento.gridtareas.fechaFin" text="**fecha fin"/>', dataIndex : 'fechaFin', width:75}
		,{header : '<s:message code="procedimiento.gridtareas.usuarioCreacion" text="**usuario"/>', dataIndex : 'usuario', width:50}
	]);
  

	var btnBar = [btnProrroga, btnAutoProrroga, btnContestarProrroga, btnEditar, btnValidar, btnVueltaAtras];

    var tareasGrid = app.crearGrid(tareasProcStore,tareasCm,{
		title:'<s:message code="procedimiento.gridtareas.titulo" text="**tareas del procedimiento" />'
		,cls:'cursor_pointer'
		,width : 700
		,height : 400
		<sec:authorize ifNotGranted="SOLO_CONSULTA">
		,bbar:btnBar
		</sec:authorize>
    });    

	tareasGrid.on('rowclick',function(grid, rowIndex, e){
    
		var rec = grid.getStore().getAt(rowIndex);
		var fechaFin = rec.get('fechaFin');
		if (fechaFin == null){
			fechaFin = '';
		}
		
		var vueltaAtras = rec.get('vueltaAtras');
		var autoprorroga = rec.get ('autoprorroga');
		var permiteProrrogas = rec.get ('permiteProrrogas');
		var prorrogaAsociada = rec.get('prorrogaAsociada');
		var params = {idTareaExterna:rec.get('id')};
		buscaResolucion(params);
		if (permiteProrrogas == false){
			btnContestarProrroga.setDisabled(true);
			btnProrroga.setDisabled(true);
			btnAutoProrroga.setDisabled(true);
		} else if (fechaFin == '' && prorrogaAsociada==''){
			btnProrroga.setDisabled(false);
			btnAutoProrroga.setDisabled(false);
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
			btnAutoProrroga.setDisabled(true);
		}else{  
			btnContestarProrroga.setDisabled(true);
			btnProrroga.setDisabled(true);
			btnAutoProrroga.setDisabled(true);
		}

		if (vueltaAtras == true)
			btnVueltaAtras.setDisabled(false);
		else
			btnVueltaAtras.setDisabled(true);

		if (autoprorroga == true){
			maximoAutoP= rec.get('maximoAutoprorrogas');
			numeroAutoP= rec.get('numeroAutoprorrogas');
			btnProrroga.hide();
			btnAutoProrroga.show();
			if (numeroAutoP >= maximoAutoP) {
				btnProrroga.show();
				btnProrroga.setDisabled(false);
				btnAutoProrroga.hide();
			}
		}else{
			btnAutoProrroga.hide();
			btnProrroga.show();
		}
		
	  	//Si es un gestor o (es supervisor y se trata de una tarea de supervisor) activamos el botón de editar
		btnEditar.enable();
	});
	var idResolucion = '';
	var codigoTipoAccion = '';
	var buscaResolucion = function(params){
		Ext.Ajax.request({
			url: '/'+app.getAppName()+'/pcdprocesadoresoluciones/getResolucionByTarea.htm'
			,params: params
			,method: 'POST'
			,success: function (result, request){
				//debugger;
				var r = Ext.util.JSON.decode(result.responseText);
				idResolucion = r.resolucion.idResolucion;
				codigoTipoAccion = r.resolucion.codigoTipoAccion;
				actualizaBotonValidar();
				//Ext.MessageBox.alert("resultado","Resultado Ok.");
				
			}
			, failure: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				idResolucion = '';
				Ext.MessageBox.alert("resultado","Resultado Fallido.");
			} 
		})
	};
	
	var actualizaBotonValidar = function(){
		if (idResolucion!= null && idResolucion!= '' && codigoTipoAccion != "INFO"){
			btnValidar.enable();
			btnValidar.setVisible(true);
		}
		else{
			btnValidar.setDisabled(true);
			btnValidar.setVisible(false);
		}
	}
	
	
     //Solo puede acceder a la tarea si es gestor o supervisor de ella 
    tareasGrid.on('rowdblclick',function(grid, rowIndex, e){
		if(panel.esGestor() || panel.esSupervisor()){
			var rec = grid.getStore().getAt(rowIndex);
			//Si es un gestor o (es supervisor y se trata de una tarea de supervisor) puede editar la tarea
			funcionEditaTareaExterna();
		}
    });

	panel.getData = function() {
		return entidad.get("data");
	}
	
	panel.add(tareasGrid);

	panel.getValue = function(){
	}

	panel.esSupervisor = function(){
		var data = entidad.get("data");
		return data.esSupervisor;
	}

	panel.esGestor = function(){
		var data = entidad.get("data");
		return data.esGestor;
	}

	panel.getProcedimientoId = function(){
		return entidad.get("data").id;
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data,tareasProcStore, {idProcedimiento : panel.getProcedimientoId()});

		var visible = [
			[ btnProrroga, data.procedimientoAceptado && data.esGestor  ]
			,[ btnContestarProrroga, data.procedimientoAceptado && data.esSupervisor ]
			,[ btnEditar, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
			,[ btnValidar, false ]
			,[ btnVueltaAtras, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
			,[ btnAutoProrroga, true  ]
		];
		entidad.setVisible(visible);
		var enabled = [];
		entidad.setEnabled(enabled);

		btnContestarProrroga.setDisabled(true);
		btnProrroga.setDisabled(true);
		btnAutoProrroga.setDisabled(true);	
		btnEditar.setDisabled(true);
		btnValidar.setDisabled(true);
	}

	return panel;
	
})