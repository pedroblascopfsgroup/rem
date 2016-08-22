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
	
	var idBienSeleccionado;
    var funcionEditarBien= function(){
        var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
        var idEmbargo = rec.get('idEmbargo');
        var id= rec.get('id');
		if(!id)
			return;
        var w = app.openWindow({
            flow : 'procedimientos/embargoProcedimiento/embargoProcedimiento'
			,width:770
			,title : '<s:message code="procedimiento.marcadoBien" text="**Marcado Bien" />'
            ,params : {idEmbargo:idEmbargo,idProcedimiento:panel.getProcedimientoId(),id:id}
        });
        w.on(app.event.DONE, function(){
			w.close();
            embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
            btnEditar.disable();
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
	};

	var embargoProcedimiento = Ext.data.Record.create([
      {name:"fechaSolicitud",type:'date', dateFormat:'d/m/Y'}
      ,{name:"fechaDecreto",type:'date', dateFormat:'d/m/Y'}
      ,{name:"id"}
      ,{name:"idEmbargo"}
      ,{name:"codigo"}
      ,{name:"descripcion"}
      ,{name:"tipo"}
      ,{name:"fechaRegistro",type:'date', dateFormat:'d/m/Y'}
      ,{name:"fechaAdjudicacion",type:'date', dateFormat:'d/m/Y'}
      ,{name:"cargaBien"}
      ,{name:"titular"}
	]);
	var embargoProcedimientoStore = page.getStore({
		event:'listado'
		,storeId : 'embargoProcedimientoStore'
		,flow : 'procedimientos/listadoEmbargoProcedimiento'
		,reader : new Ext.data.JsonReader({root:'listado'}
		, embargoProcedimiento)
	});
	entidad.cacheStore(embargoProcedimientoStore);
	var embargoProcedimientoCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="procedimiento.embargos.grid.codigo" text="**Codigo"/>', dataIndex : 'id' }
		,{header : '<s:message code="procedimiento.embargos.grid.descripcion" text="**Descripcion"/>', dataIndex : 'descripcion' }
		,{header : '<s:message code="procedimiento.embargos.grid.tipo" text="**Tipo"/>', dataIndex : 'tipo' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaSol" text="**fechaSolicitud"/>', dataIndex : 'fechaSolicitud', renderer:app.format.dateRenderer }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaDec" text="**fechaDecreto"/>', dataIndex : 'fechaDecreto', renderer:app.format.dateRenderer }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaRef" text="**fechaRegistro"/>', dataIndex : 'fechaRegistro', renderer:app.format.dateRenderer }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaAdj" text="**fechaAdjudicacion"/>', dataIndex : 'fechaAdjudicacion', renderer:app.format.dateRenderer }
		,{header : '<s:message code="procedimiento.embargos.grid.cargaBien" text="**cargaBien"/>', dataIndex : 'cargaBien'}
		,{header : '<s:message code="procedimiento.embargos.grid.titular" text="**titular"/>', dataIndex : 'titular'}
	]);
	
	var btnVerificarBien = new Ext.Button({
        text:'<s:message code="app.consultar" text="**Consultar" />'
        ,iconCls:'icon_pre_asunto'
        ,cls: 'x-btn-text-icon'
		,disabled:true
        ,handler : function(){
			var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
            if (!rec) return;
				var bienId = rec.get("id");
			var w = app.openWindow({
				flow : 'clientes/consultaBienes' 
				,width:760
				,params : {id:bienId}
				,title : '<s:message code="embargobienes.grid.consulta" text="**Consultar bien" />'
			});
			w.on(app.event.DONE, function(){
				w.close();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });              
		}
    });
  
	var btnEditar = new Ext.Button({
        text:'<s:message code="app.editar" text="**Editar" />'
        ,iconCls : 'icon_edit'
        ,cls: 'x-btn-text-icon'
        ,disabled:true
        ,handler:funcionEditarBien
        <app:test id="btnEditarABM" addComa="true"/>
    });

	var buttonBar = [ btnEditar, btnVerificarBien];

	var embargoProcedimientoGrid = app.crearGrid(embargoProcedimientoStore,embargoProcedimientoCm,{
		title:'<s:message code="procedimiento.embargos.grid" text="**Marcado Bienes" />'
		,height : 400
		,style:'padding-right:10px'
		,bbar:buttonBar
	});
  
	embargoProcedimientoGrid.on('rowclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
        var id= rec.get('id');
		if(!id){
			btnEditar.disable();
			btnVerificarBien.disable();
		}else{
			btnEditar.enable();
			btnVerificarBien.enable();
		}
      
	});

	embargoProcedimientoGrid.on('rowdblclick',function(grid, rowIndex, e){
		funcionEditarBien();
	});
	
	var panel = new Ext.Panel({
		height:420
		,title:'<s:message code="procedimiento.embargos" text="**Bienes" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items :embargoProcedimientoGrid
		,nombreTab : 'embargosProcedimiento'
	});

	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, embargoProcedimientoStore, {idProcedimiento : data.id});

		var visibles = [
			[btnEditar, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
			,[btnVerificarBien, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
		];
		entidad.setVisible(visibles);
	}

	panel.getProcedimientoId = function(){
		return entidad.get("data").id;
	}

	return panel;
})
