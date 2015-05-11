<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

var createRecursosTab=function(){

	var funcionEditaRecurso=function(){
	    	var rec = recursosGrid.getSelectionModel().getSelected();
			
			var w = app.openWindow({
		        text:'<s:message code="app.editar" text="**Editar" />'
				,flow : 'procedimientos/recursos'
				,width:850
				,title : '<s:message code="procedimiento.recursos.verEditar" text="**Editar Recurso" />'
				,params:{
						idProcedimiento:'${procedimiento.id}'
						,id: rec.get('id')
				}
			});
			w.on(app.event.DONE, function(){
				w.close();
				app.abreProcedimientoTab('${procedimiento.id}', null, 'recursos');
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
		,flow : 'procedimientos/listadoRecursos'
		,reader : new Ext.data.JsonReader(
			{root:'listadoRecursos'}
			, recurso
		)
	});

	recursosStore.webflow({idProcedimiento:'${procedimiento.id}'});

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
				,params:{idProcedimiento:'${procedimiento.id}'}
			});
			w.on(app.event.DONE, function(){
				w.close();
				app.abreProcedimientoTab('${procedimiento.id}', null, 'recursos');

			});
			w.on(app.event.CANCEL, function(){ 
				w.close(); 
			});
		}	
		//,success:
   	});

     <c:if test="${!puedeCrearRecurso}">
		btnNuevoRecurso.setDisabled(true);
     </c:if>



   	var btnEditarRecurso = new Ext.Button({
    	text:'<s:message code="app.ver_editar" text="**Ver/Editar" />'
		<app:test id="btnVerEditarRecurso" addComa="true" />
       	,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:funcionEditaRecurso
		,disabled: true
   	});

	

	var buttonBar = new Array();
	<c:if test="${procedimiento.estaAceptado && (esGestor || esSupervisor)}">
		buttonBar.push(btnNuevoRecurso);
		buttonBar.push(btnEditarRecurso);
	</c:if>


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
    });
	return panel;



}