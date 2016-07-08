<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
(function(){
	var idBienSeleccionado;
	
	var funcionEditarBien= function()
	{
       	//var grid = fwk.dom.findParentPanel(this.id);
       	var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
           var idEmbargo = rec.get('idEmbargo');
           var id= rec.get('id');
		if(!id)
			return;
           var w = app.openWindow({
               flow : 'procedimientos/embargoProcedimiento/embargoProcedimiento'
			,width:770
			,title : '<s:message code="procedimiento.marcadoBien" text="**Marcado Bien" />'
               ,params : {idEmbargo:idEmbargo,idProcedimiento:${procedimiento.id},id:id}
           });
           w.on(app.event.DONE, function(){
               w.close();
               embargoProcedimientoStore.webflow({idProcedimiento:${procedimiento.id}});
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
		,flow : 'procedimientos/listadoEmbargoProcedimiento'
		,reader : new Ext.data.JsonReader({root:'listado'}
		, embargoProcedimiento)
	});
	embargoProcedimientoStore.webflow({idProcedimiento:${procedimiento.id}}); 
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
					page.fireEvent(app.event.DONE);
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


	var buttonBar = new Array();
	<c:if test="${procedimiento.estaAceptado && (esGestor || esSupervisor)}">
		buttonBar.push(btnEditar);
		buttonBar.push(btnVerificarBien);
	</c:if>


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
		}
			
		else{
			btnEditar.enable();
			btnVerificarBien.enable();
		}
			
	});

	embargoProcedimientoGrid.on('rowdblclick',function(grid, rowIndex, e){
		funcionEditarBien();
	});
	var btnEditarBien = app.crearBotonEditar({
	            text:'<s:message code="app.editar" text="**Editar" />'
				<app:test id="btnEditarBien" addComa="true" />
				,flow : 'clientes/bienes'
				,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />' 
				,params : {idPersona:"${persona.id}"}
				,width:650
				,success : function(){
					bienesST.webflow({id:"${persona.id}"});
				}
				
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
	return panel;
})()
