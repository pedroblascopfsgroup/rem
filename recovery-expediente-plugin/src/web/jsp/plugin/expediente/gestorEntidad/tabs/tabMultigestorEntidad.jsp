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

	var ugCodigo = '3';
	var tipoEntidad = '1';
	
	var gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'idGestor'}
		,{name:'usuario'}
		,{name:'tipoGestor'}
		,{name:'tipoGestorDescripcion'}
		,{name:'fechaDesde',type: 'string'}
		,{name:'fechaHasta',type: 'string'}
		
    ]);
    
    var gestorStore = page.getStore({
		event:'listado'
		,storeId : 'idGestorStore'
		,flow:'gestorentidad/getListGestoresAdicionalesHistoricoData'
		,reader : new Ext.data.JsonReader({root:'listaGestoresAdicionales',totalProperty : 'total'}, gestor)
	});
	
	
	//entidad.cacheStore(gestorStore);
	
	var coloredRender = function (value, meta, record) {
		var fechaHasta = record.get('fechaHasta');
		if (fechaHasta){
			return '<span style="color: #CC6600; font-weight: bold;">'+value+'</span>';
			//return value;
		}
		else {
			return '<span style="color: #4169E1; font-weight: bold;">'+value+'</span>';
		}
		return value;
	};	
	
    var dateRendererJuniper = function(value) {
        var resultado = "";
        if (value.length > 10) {
	   	    var dt = new Date();
	   	    dt = Date.parseDate(value, "d/m/Y");
            if (dt != undefined) {
                resultado = dt.format('d/m/Y');
            } else {
                resultado = value.substring(8,10) + "/" + value.substring(5,7) + "/" + value.substring(0,4);
            }
  	    }
	    return resultado;
    }

	var dateColoredRender = function (value, meta, record) {
		var valor = dateRendererJuniper(value);
		return coloredRender(valor, meta, record);
	};	
		
	var gestorCM  = new Ext.grid.ColumnModel([
        {header: 'Id',sortable: false, dataIndex: 'id', hidden:'true'}
        ,{header: 'IdGestor',sortable: false, dataIndex: 'idGestor', hidden:'true'}
        ,{header: '<s:message code="plugin.expediente.gestorEntidad.tab.descripcion" text="**Descripcion" />',sortable: false, dataIndex: 'tipoGestorDescripcion',width:50, renderer: coloredRender}
        ,{header: '<s:message code="plugin.expediente.gestorEntidad.tab.usuario" text="**Usuario" />',sortable: false, dataIndex: 'usuario',width:100, renderer: coloredRender}
        ,{header: '<s:message code="plugin.expediente.gestorEntidad.tab.tipoGestor" text="**Tipo gestor" />',sortable: false, dataIndex: 'tipoGestor',width:50, hidden:'true', renderer: coloredRender}
        ,{header: '<s:message code="plugin.expediente.gestorEntidad.tab.fechaDesde" text="**Desde" />',sortable: false, dataIndex: 'fechaDesde',width:30, renderer: dateColoredRender}
        ,{header: '<s:message code="plugin.expediente.gestorEntidad.tab.fechaHasta" text="**Hasta" />',sortable: false, dataIndex: 'fechaHasta',width:30, renderer: dateColoredRender}        
        
    ]);

    var recargar = function(){
		gestorStore.webflow({idEntidad: data.id, tipoEntidad:tipoEntidad});
	}
    

	
	
 
    var idCompuesto;
    var recStore;
   
	  
	  
	<%-- GESTION DE GESTORES - Oscar --%>  
	<%-- combo tipo gestor --%>
	
	var tipoGestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsGestorStore = page.getStore({
	       flow: 'gestorentidad/getListTipoGestorEditables'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoGestores'
	    }, tipoGestor)	       
	});

	var comboTipoGestor = new Ext.form.ComboBox({
		store:optionsGestorStore
		,displayField:'descripcion'
		,valueField:'id'
		//,disabled:true
		,mode: 'remote'
		,width: 200
		,forceSelection: true
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.expediente.gestorEntidad.tab.cmbTipoGestor" text="**Tipo gestor" />'
	});
	
	var tipoDespacho = Ext.data.Record.create([
		 {name:'cod'}
		,{name:'descripcion'}
	]);
	
	var optionsDespachoStore = page.getStore({
	       flow: 'coreextension/getListTipoDespachoData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoDespachos'
	    }, tipoDespacho)	       
	});

	var comboTipoDespacho = new Ext.form.ComboBox({
		store:optionsDespachoStore
		,displayField:'descripcion'
		,valueField:'cod'
		,mode: 'remote'
		,disabled:true
		,forceSelection: true
		,editable: false
		,width: 250
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.expediente.gestorEntidad.tab.cmbTipoDespacho" text="**Tipo despacho" />'
	});
	
	var tipoUsuario = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);
	
	var optionsUsuarioStore = page.getStore({
	       flow: 'coreextension/getListUsuariosPaginatedData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, tipoUsuario)	       
	});
/*
	var comboTipoUsuario = new Ext.form.ComboBox({
		store:optionsUsuarioStore
		,displayField:'username'
		,valueField:'id'
		,mode: 'remote'
		,disabled:true
		,forceSelection: true
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.expediente.gestorEntidad.tab.cmbUsuario" text="**Usuario" />'
		,width: 250
	});
*/	
	var comboTipoUsuario = new Ext.form.ComboBox ({
		store:  optionsUsuarioStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText:'---',
		disabled:true,
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.expediente.gestorEntidad.tab.cmbUsuario" text="**Usuario" />',
		loadingText: 'Buscando...',
		labelStyle:'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});
	
	comboTipoUsuario.on('afterrender', function(combo) {
		combo.mode='remote';
	});
	
	comboTipoGestor.on('select', function(){
		comboTipoUsuario.reset();
		comboTipoDespacho.reset();
		optionsDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue()}); 
		
		comboTipoDespacho.setDisabled(false);
		
		comboTipoUsuario.setDisabled(true);
		
	});
	
	comboTipoDespacho.on('select', function(){

		optionsUsuarioStore.webflow({'idTipoDespacho': comboTipoDespacho.getValue(),'idTipoGestor': comboTipoGestor.getValue()}); 
		comboTipoUsuario.reset();		
		comboTipoUsuario.setDisabled(false);
	});	
	
	
	var validar = function(){
	
		if(comboTipoDespacho.getValue()==''){
			return false;
		}	
		if(comboTipoGestor.getValue()==''){
			return false;
		}	
		if(comboTipoUsuario.getValue()==''){
			return false;
		}
		return true;
	};
	
	
	
	var resetCombos = function(){
		comboTipoDespacho.reset();
		comboTipoUsuario.reset();
		comboTipoGestor.reset();
		
		comboTipoDespacho.setDisabled(true);
		comboTipoUsuario.setDisabled(true);
		comboTipoGestor.setValue('');
		
	
	};
	
	var insertar = new Ext.Button({
		text:'<s:message code="app.agregar" text="**Agregar" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
		//,disabled:true
		,handler:function(){
			if(validar()){
				insertarFunction();
				resetCombos();
			}
			else{
				alert('Obligado');
			}
		}
	});
	
	var insertarFunction=function(){
		data = entidad.get("data");
		Ext.Ajax.request({
			url: page.resolveUrl('gestorentidad/insertarGestorAdicionalEntidad')
			,params: {
				idTipoGestor:comboTipoGestor.getValue()
				,idEntidad:data.id
				,tipoEntidad:tipoEntidad
				,idUsuario:comboTipoUsuario.getValue()
				,idTipoDespacho:comboTipoDespacho.getValue()
			}
		
			,success:function(){
				recargar();
			}
		})
	}; 
	 
	var borrar = new Ext.Button({
		text : '<s:message code="app.borrar" text="**borrar" />'
		,iconCls : 'icon_menos'
		,cls: 'x-btn-text-icon'
		,disabled:true
		,handler:function(){
			Ext.Msg.show({
				   title:'Confirmación',
				   msg: '<s:message code="plugin.expediente.gestorEntidad.tab.confirmarBorrado" text="**Confirmar borrado" />',
				   buttons: Ext.Msg.YESNO,
				   animEl: 'elId',
				   width:450,
				   fn: deleteGestor,
				   icon: Ext.MessageBox.QUESTION
				});
		}
	});
	
	var idTipoGestor;
	var idEntidad;
	var idUsuario;
	var idTipoDespacho;
	
	var deleteGestor = function(opt){
		
	   if(opt == 'no'){
	      //page.fireEvent(app.event.CANCEL);
	   }
	   if(opt == 'yes'){
			page.webflow({
	      			flow:'gestorentidad/removeGestor'
	      			,params:{
						idTipoGestor:idTipoGestor
						,idEntidad:idEntidad
						,tipoEntidad:tipoEntidad
						,idUsuario:idUsuario
						,idTipoDespacho:idTipoDespacho
      				}
	      			,success: function(){
						recargar();
            		}	
	      		});
	      }
	}
	
	
	
	 var panelGestores = new Ext.Panel({
	 	title:'<s:message code="plugin.expediente.gestorEntidad.tab.formGestores.titulo" text="**Modificar Gestores" />'
	 	,layout:'form'
	 	,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;'
	 	,items: [comboTipoGestor, comboTipoDespacho, comboTipoUsuario]
	 	 <sec:authorize ifAllGranted="EDIT_GESTORES">
		,bbar:[insertar] 
		</sec:authorize>
	 });
	 
	 var grid = new Ext.grid.GridPanel({
		title:'<s:message code="plugin.expediente.gestorEntidad.tab.gridGestores.titulo" text="**Lista gestores" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_bienes'
       ,height: 400
	   //,width:100
	   ,autoWidth:false
	   ,store: gestorStore
	   ,cm:gestorCM
	   ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
	   ,collapsible :false
	   //,resizable:true
	   ,viewConfig : {  forceFit : true}
	   ,monitorResize: true
	   	 <sec:authorize ifAllGranted="EDIT_GESTORES">
	   ,bbar:[borrar] 
		</sec:authorize>
	   
	});
	
	 grid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
    	var recStore=gestorStore.getAt(rowIndex);
   		
   		if((recStore.get('fechaHasta')==null || recStore.get('fechaHasta')=='') && recStore.get('editableWeb')){
   			borrar.setDisabled(false);
   		}
   		else{
   			borrar.setDisabled(true);
   		}
   		
		idEntidad = recStore.get('id');
		idUsuario = recStore.get('idGestor');
   		
	  }); 
	 
	 <%-- RESTO DE PAGINA --%>
	
    var panel = new Ext.Panel({
		title:'<s:message code="plugin.expediente.gestorEntidad.tab.panel.titulo" text="**Gestores" />'
		,layout : 'column'
		,viewConfig : { columns : 1 }
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [{ columnWidth:0.6, border:false, items:[grid]},{ columnWidth:0.4, border:false, items:[panelGestores]}]
		,nombreTab : 'tabContratoBienes'
	});
	
	
	
	
	panel.getValue = function(){
	}
	var data;
	panel.setValue = function(){
		
		data = entidad.get("data");
		recargar();
		optionsGestorStore.webflow({idTipoGestor:ugCodigo});
		borrar.setDisabled(true);
	}

	panel.setVisibleTab = function(data){
	
	    //Solo se mostrará la pestaña en los expedientes de recobro "REC"
		if(data.cabecera.tipoExpediente=="REC"){
			return true;
		}
		else{
			return false;
		}
	}
  
	return panel;
})