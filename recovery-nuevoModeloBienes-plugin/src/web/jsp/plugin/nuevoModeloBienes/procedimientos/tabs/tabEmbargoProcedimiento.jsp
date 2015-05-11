<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){
	
	Ext.util.CSS.createStyleSheet("Button.icon_buildingEdit { background-image: url('../img/plugin/nuevoModeloBienes/building_edit.png');}");
	
	var idBienSeleccionado;
	
	var funcionEditarBien= function()
	{
       	var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
           var idEmbargo = rec.get('idEmbargo');
           var id= rec.get('id');
		if(!id)
			return;
           var w = app.openWindow({
            <%-- flow : 'procedimientos/embargoProcedimiento/embargoProcedimiento' --%>
            flow : 'editbien/openEmbargoProcedimiento'
			,width:650
			,title : '<s:message code="procedimiento.marcadoBien" text="**Marcado Bien" />'
               ,params : {idEmbargo:idEmbargo,idProcedimiento:${procedimiento.id},idBien:id}
           });
           w.on(app.event.DONE, function(){
               w.close();
               embargoProcedimientoStore.webflow({idProcedimiento:${procedimiento.id}});
               //btnEditar.disable();
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
		,flow : 'procedimientos/listadoEmbargoProcedimiento'
		,reader : new Ext.data.JsonReader({root:'listado'}
		, embargoProcedimiento)
	});

	embargoProcedimientoStore.webflow({idProcedimiento:${procedimiento.id}}); 
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
        ,handler:function(){
		     var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();		     
		     var id= rec.get('id');
	         if(!id) return;		    
		     var w = app.openWindow({
		    	flow : 'editbien/openByIdBien'
				,width:770
				,title : '<s:message code="embargobienes.grid.consulta" text="**Consultar bien" />'
				,params : {id:id}
	 	     });
	         w.on(app.event.DONE, function(){
			 	w.close();
			 	embargoProcedimientoStore.webflow({idProcedimiento:${procedimiento.id}});
			 	page.fireEvent(app.event.DONE);
		     });
		     w.on(app.event.CANCEL, function(){ w.close(); })
		}		
	});
<%-- Fase 3 - no presente en rurales
	<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		btnVerificarBien = new Ext.Button({
	        text:'<s:message code="app.consultar" text="**Consultar" />'
			<app:test id="btnAgregarIngreso" addComa="true" />
           	,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
           	,handler:function(){
				var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
	            if (!rec) return;
	            var idBien=rec.get("id");
	            var desc = idBien + ' ' +  rec.get('tipo');
	            app.abreBien(idBien,desc);
       		}
		});
	</sec:authorize>--%>
	
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
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.mensajeConfirmacion" text="**¿Seguro que desea marcar la solvencia seleccionada?" />', this.decide, this);
			}
			,decide : function(boton){
				if (boton=='yes') this.marcar();
			}
			,marcar : function(){
				page.webflow({
					 flow : 'plugin/nuevoModeloBienes/clientes/marcarBien'
					,params : {idBien:embargoProcedimientoGrid.getSelectionModel().getSelected().get("id")}
					,success : function(){
						embargoProcedimientoStore.webflow({idProcedimiento:${procedimiento.id}});
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
				
	<c:if test="${procedimiento.estaAceptado && (esGestor || esSupervisor)}">
		buttonBar.push(btnEditar);
		embargoProcedimientoGrid.on('rowdblclick',function(grid, rowIndex, e){
			funcionEditarBien();
		});
	</c:if>
	
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
	return panel;
})()
