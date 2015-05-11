﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
	
	Ext.util.CSS.createStyleSheet("Button.icon_buildingEdit { background-image: url('../img/plugin/nuevoModeloBienes/building_edit.png');}");

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
		{name:"fechaSolicitud"}
		,{name:"fechaDecreto"}
		,{name:"fechaDenegacion"}
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
           	,{name:"origen"}
        </sec:authorize>
        <sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
           	,{name:"marca"}
        </sec:authorize>
		,{name:"id"}
		,{name:"idEmbargo"}
		,{name:"codigo"}
		,{name:"descripcion"}
		,{name:"tipo"}
		,{name:"fechaRegistro"}
		,{name:"fechaAdjudicacion"}
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
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
        	,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.origen" text="**Carga"/>', width: 67, dataIndex : 'origen' }
        </sec:authorize>
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
			,{header: '<s:message code="plugin.nuevoModeloBienes.columnaMarcaBien" text="**Marcado"/>', width: 67, sortable: true, dataIndex: 'marca', 
		       		 renderer: function (val){if (val==1) {return "SI";} else {return "NO"}} }
	    </sec:authorize>
		,{header : '<s:message code="procedimiento.embargos.grid.descripcion" text="**Descripcion"/>', dataIndex : 'descripcion' }
		,{header : '<s:message code="procedimiento.embargos.grid.tipo" text="**Tipo"/>', dataIndex : 'tipo' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaSol" text="**fechaSolicitud"/>', dataIndex : 'fechaSolicitud' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaDec" text="**fechaDecreto"/>', dataIndex : 'fechaDecreto' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaRef" text="**fechaRegistro"/>', dataIndex : 'fechaRegistro' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaAdj" text="**fechaAdjudicacion"/>', dataIndex : 'fechaAdjudicacion' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaDene" text="**fechaDenegacion"/>', dataIndex : 'fechaDenegacion' }
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
				flow : 'plugin/nuevoModeloBienes/bienes/NMBBienes' 
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

	<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
		var btnMarcarGarantia = new Ext.Button({
			 text : '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien" text="**Marcar / Desmarcar" />'
			,iconCls : 'icon_buildingEdit'
			,disabled:true
			,cls: 'x-btn-text-icon'
			,handler : function(){
				var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
				if (!rec){
					Ext.Msg.alert('<s:message code="app.error" text="**Error"/>','<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.debeSeleccionar" text="**Debe seleccionar el bien que desea Marcar o Desmarcar"/>');
					return;
				}	
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.mensajeConfirmacion" text="**Seguro que desea marcar la solvencia seleccionada?" />', this.decide, this);
			}
			,decide : function(boton){
				if (boton=='yes') this.marcar();
			}
			,marcar : function(){
				page.webflow({
					 flow : 'plugin/nuevoModeloBienes/clientes/marcarBien'
					,params : {idBien:embargoProcedimientoGrid.getSelectionModel().getSelected().get("id")}
					,success : function(){
						embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
					}
				})
			}
		});
	</sec:authorize>
	
	var buttonBar = new Array();

	<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
		buttonBar.push(btnMarcarGarantia);
	</sec:authorize>
	
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
			<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
				btnMarcarGarantia.disable();
			</sec:authorize>
		} else {
			btnEditar.enable();
			btnVerificarBien.enable();
			<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
				if(rec.get('origen')=='Manual'){btnMarcarGarantia.disable();}
				else {btnMarcarGarantia.enable()};
			</sec:authorize>
		}
	});

	buttonBar.push(btnVerificarBien);
	
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

		if (data.procedimientoAceptado && (data.esGestor || data.esSupervisor)){
			embargoProcedimientoGrid.on('rowdblclick',function(grid, rowIndex, e){
				funcionEditarBien();
			});
		}
		
		var visibles = [
			[btnEditar, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
		];
		entidad.setVisible(visibles);
	}

	panel.getProcedimientoId = function(){
		return entidad.get("data").id;
	}

	return panel;
})
