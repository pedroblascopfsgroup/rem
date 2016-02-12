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

	var funcionEditaRecurso=function(){
		var rec = recursosGrid.getSelectionModel().getSelected();
		var w = app.openWindow({
            text:'<s:message code="app.editar" text="**Editar" />'
			,flow : 'procedimientos/recursos'
			,width:850
			,title : '<s:message code="procedimiento.recursos.verEditar" text="**Editar Recurso" />'
			,params:{
				idProcedimiento:panel.getProcedimientoId()
				,id: rec.get('id')
			}
		});
		w.on(app.event.DONE, function(){
			w.close();
			recursosStore.webflow({idProcedimiento : entidad.get("data").id});
			entidad.refrescar();
		});
		w.on(app.event.CANCEL, function(){ 
			w.close(); 
		});
	};

    var recurso = Ext.data.Record.create([
		{name:"id"}
		,{name:"actor"}
		,{name:"tipo"}
		,{name:"causa"}
		,{name:"fecha"}
		,{name:"resultado"}
    ]);
    var recursosStore = page.getStore({
    event:'listado'
    ,storeId : 'recursosStore'
    ,flow : 'procedimientos/listadoRecursos'
    ,reader : new Ext.data.JsonReader(
      {root:'listadoRecursos'}
      , recurso
    )
  });

  entidad.cacheStore(recursosStore);

    var recursosCm = new Ext.grid.ColumnModel([
      {header : '<s:message code="procedimiento.recursos.grid.actor" text="**Actor"/>', dataIndex : 'actor' }
      ,{header : '<s:message code="procedimiento.recursos.grid.tipo" text="**Tipo"/>', dataIndex : 'tipo' }
      ,{header : '<s:message code="procedimiento.recursos.grid.causa" text="**Causa"/>', dataIndex : 'causa' }
      ,{header : '<s:message code="procedimiento.recursos.grid.fechaRec" text="**Fecha Recurso"/>', dataIndex : 'fecha' }
      ,{header : '<s:message code="procedimiento.recursos.grid.resultado" text="**Resultado"/>', dataIndex : 'resultado' }
    ]);

    var btnNuevoRecurso = new Ext.Button({
		text:'<s:message code="app.agregar" text="**Agregar" />'
		<app:test id="btnAgregarRecurso" addComa="true" />
			,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
		,handler:function(){
			var w = app.openWindow({
			flow : 'procedimientos/recursos'
				,width:850
				,title : '<s:message code="procedimiento.recursos.alta" text="**Alta Recurso" />'
				,params:{idProcedimiento:panel.getProcedimientoId()}
			});
			w.on(app.event.DONE, function(){
				w.close();
				recursosStore.webflow({idProcedimiento : entidad.get("data").id});
				entidad.refrescar();
			});
			w.on(app.event.CANCEL, function(){ 
				w.close(); 
			});
		}  
    });

    var btnEditarRecurso = new Ext.Button({
		text:'<s:message code="app.ver_editar" text="**Ver/Editar" />'
		<app:test id="btnVerEditarRecurso" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:funcionEditaRecurso
		,disabled: true
    });

  

  var buttonBar = [<sec:authorize ifNotGranted="SOLO_CONSULTA"> btnNuevoRecurso,</sec:authorize> btnEditarRecurso ];

  var recursosGrid = app.crearGrid(recursosStore,recursosCm,{
      title:'<s:message code="procedimiento.recursos.grid" text="**Recursos ya existentes en el procedimiento" />'
      ,height : 400
      ,style:'padding-right:10px'
      ,cls:'cursor_pointer'
      ,bbar: buttonBar
  });

  recursosGrid.on('rowclick', function(grid, rowIndex, e) {
	btnEditarRecurso.enable();
  });

  recursosGrid.on('rowdblclick', function(grid, rowIndex, e) {
    funcionEditaRecurso();
  });

  var panel = new Ext.Panel({
    autoHeight : true
    ,title:'<s:message code="procedimiento.recursos" text="**Recursos" />'
    ,autoWidth:true
    ,bodyStyle : 'padding:10px'
    ,border : false
    ,items :recursosGrid
    ,nombreTab : 'recursos'
  });

  panel.getValue = function(){
  }

  panel.setValue = function(){
	var data = entidad.get("data");
	entidad.cacheOrLoad(data, recursosStore, {idProcedimiento : data.id});
	var visible=[
		[btnNuevoRecurso, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
		,[btnEditarRecurso, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
	]
	entidad.setVisible(visible);
	var enabled = [
		[ btnNuevoRecurso , data.puedeCrearRecurso ]
	];
	entidad.setEnabled(enabled);
  }

  panel.getProcedimientoId = function(){
    return entidad.get("data").id;
  }

  return panel;

})
