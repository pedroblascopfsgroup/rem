<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var ugCodigo = '1';
	var gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'usuario'}
		,{name:'tipoGestor'}
		,{name:'tipoGestorDescripcion'}
		
    ]);
    
    var gestorStore = page.getStore({
		event:'listado'
		,storeId : 'idGestorStore'
		,flow:'plugin/coreextension/multigestor/consultaMultigestorData'
		,reader : new Ext.data.JsonReader({root:'gestor',totalProperty : 'total'}, gestor)
	});
	
	
	//entidad.cacheStore(gestorStore);
	
	
	
	var gestorCM  = new Ext.grid.ColumnModel([
        {header: 'Id',sortable: true, dataIndex: 'id', hidden:'true'}
        ,{header: '<s:message code="plugin.coreextension.multigestor.usuario" text="**Usuario" />',sortable: true, dataIndex: 'usuario'}
        ,{header: '<s:message code="plugin.coreextension.multigestor.tipoGestor" text="**Tipo gestor" />',sortable: true, dataIndex: 'tipoGestor'}
		,{header: '<s:message code="plugin.coreextension.multigestor.descripcion" text="**Descripcion" />',sortable: true, dataIndex: 'tipoGestorDescripcion'}
        
    ]);
    
    //Funcion encargada de abrir el popup para añadir un nuevo gestor.
	var nuevoGestor=function(ugCodigo,ugId){
			win = app.openWindow(
				{
					flow:'plugin/coreextension/multigestor/nuevoGestor', 
					title : '<s:message code="plugin.coreextension.multigestor.nuevoGestor.titulo" text="**Nuevo gestor" />',
					params: {ugCodigo:ugCodigo,ugId:ugId},
					width: 600
				}
			);
			win.on(app.event.CANCEL,
					function(){
						win.close();
					}
			);
			win.on(app.event.DONE,
					function(){
						win.close();
						recargar();
					}
			);
	};
    
    var recargar = function(){
		gestorStore.webflow({ugCodigo:ugCodigo, ugId: data.id});
	}
    
    var agregar = new Ext.Button({
		text : '<s:message code="app.agregar" text="**Agregar" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
		,handler:function(){
			nuevoGestor(ugCodigo,data.id);
		}
	});
	
	
    
    var borrar = app.crearBotonBorrar({
		page : page
		,disabled:true
		,flow : 'plugin/coreextension/multigestor/removeGestor'
		,success : function(){
			recargar();
		}
		
	});
 
   var grid= app.crearGrid(gestorStore,gestorCM,{
        title:'<s:message code="plugin.coreextension.multigestor.gridGestores.titulo" text="**Lista gestores" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_bienes'
       ,height: 448
      <sec:authorize ifAllGranted="EDIT_GESTORES">
        ,bbar:[agregar,borrar]
      </sec:authorize>   
       
    });
    
    var recStore;
    grid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
    	var recStore=gestorStore.getAt(rowIndex);
   		borrar.setDisabled(false);
	  }); 
	  
    
    var panel = new Ext.Panel({
		title:'<s:message code="plugin.coreextension.multigestor.panel.titulo" text="**Gestores" />'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [grid]
		,nombreTab : 'tabContratoBienes'
	});
	
	
	panel.getValue = function(){
	}
	var data;
	panel.setValue = function(){
	data = entidad.get("data");
			
		 gestorStore.webflow({ugCodigo:ugCodigo, ugId: data.id});
	}

	panel.setVisibleTab = function(data){
		return true;
	}
  
	return panel;
})