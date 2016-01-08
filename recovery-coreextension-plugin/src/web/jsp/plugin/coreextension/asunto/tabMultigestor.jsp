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

	var porUsuario = false;
	var adicional = false;
	var procuradorAdicional = false;
	<sec:authorize ifAllGranted="ASU_GESTOR_SOLOPROPIAS">
		porUsuario = true;
		<sec:authorize ifAllGranted="ASU_GESTOR_SOLOPROPIAS_ADIC">
		 adicional = true;
		</sec:authorize>
		<sec:authorize ifAllGranted="ASU_PROCURADOR_SOLOPROPIAS_ADIC">
		 procuradorAdicional = true;
		</sec:authorize>
	</sec:authorize>
	<sec:authorize ifAllGranted="ASU_MULTIGESTOR_SUPERVISOR">
		porUsuario = false;
		adicional = false;
		procuradorAdicional = false;
	</sec:authorize>
	
	var ugCodigo = '3';
	var gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'idGestor'}
		,{name:'usuario'}
		,{name:'tipoGestor'}
		,{name:'tipoGestorDescripcion'}
		,{name:'fechaDesde'}
		,{name:'fechaHasta'}
		,{name: 'tipoVia'}
		,{name: 'domicilio'}
		,{name: 'domicilioPlaza'}
		,{name: 'telefono1'}
		,{name: 'email'}
		
		
    ]);
    
    var gestorStore = page.getStore({
		event:'listado'
		,storeId : 'idGestorStore'
		,flow:'coreextension/getListGestoresAdicionalesHistoricoData'
		,reader : new Ext.data.JsonReader({root:'gestor',totalProperty : 'total'}, gestor)
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
	
	var dateColoredRender = function (value, meta, record) {
		<%--var valor = app.format.dateRenderer(value, meta, record); --%>
		return coloredRender(value, meta, record);
	};	
		
	var gestorCM  = new Ext.grid.ColumnModel([
        {header: 'Id',sortable: false, dataIndex: 'id', hidden:'true'}
        ,{header: 'IdGestor',sortable: false, dataIndex: 'idGestor', hidden:'true'}
        ,{header: '<s:message code="plugin.coreextension.multigestor.descripcion" text="**Descripcion" />',sortable: false, dataIndex: 'tipoGestorDescripcion',width:100, renderer: coloredRender}
        ,{header: '<s:message code="plugin.coreextension.multigestor.usuario" text="**Usuario" />',sortable: false, dataIndex: 'usuario',width:150, renderer: coloredRender}
        ,{header: '<s:message code="plugin.coreextension.multigestor.tipoGestor" text="**Tipo gestor" />',sortable: false, dataIndex: 'tipoGestor',width:50, hidden:'true', renderer: coloredRender}
        ,{header: '<s:message code="plugin.coreextension.multigestor.fechaDesde" text="**Desde" />',sortable: false, dataIndex: 'fechaDesde',width:50, renderer: dateColoredRender}       
		,{header: '<s:message code="plugin.coreextension.multigestor.fechaHasta" text="**Hasta" />',sortable: false, dataIndex: 'fechaHasta',width:50, renderer: dateColoredRender}
		,{header: '<s:message code="plugin.coreextension.multigestor.tVia" text="**T.Via" />',sortable: false, dataIndex: 'tipoVia',width:30, renderer: coloredRender}
		,{header: '<s:message code="plugin.coreextension.multigestor.domicilio" text="**Domicilio" />',sortable: false, dataIndex: 'domicilio',width:150, renderer: coloredRender}
		,{header: '<s:message code="plugin.coreextension.multigestor.localidad" text="**Localidad" />',sortable: false, dataIndex: 'domicilioPlaza',width:100, renderer: coloredRender}
		,{header: '<s:message code="plugin.coreextension.multigestor.telefono" text="**Teléfono" />',sortable: false, dataIndex: 'telefono1',width:50, renderer: coloredRender} 
		,{header: '<s:message code="plugin.coreextension.multigestor.email" text="**email" />',sortable: false, dataIndex: 'email', renderer: coloredRender}      
    ]);

    var recargar = function(){
		gestorStore.webflow({idAsunto: data.id});
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
	       flow: 'coreextension/getListTipoGestorAdicionalData'
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
		,forceSelection: true
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoGestor" text="**Tipo gestor" />'
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
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoDespacho" text="**Tipo despacho" />'
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
		,fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbUsuario" text="**Usuario" />'
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
		fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbUsuario" text="**Usuario" />',
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
	
	<%-- BKREC-1041 Al cargar los usuarios de un despacho, muestra en su combo el valor por defecto del listado --%>
	var primeraVez=true;
	optionsUsuarioStore.on('load',function(ds,records,o){
		if(primeraVez){
			comboTipoUsuario.setValue(records[0].data.id);
			primeraVez=false;
		}
	});

	comboTipoGestor.on('select', function(){
		comboTipoUsuario.reset();
		comboTipoDespacho.reset();
		optionsDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue(), porUsuario: porUsuario, adicional: adicional, procuradorAdicional: procuradorAdicional}); 
		
		comboTipoDespacho.setDisabled(false);
		
		comboTipoUsuario.setDisabled(true);
		
	});
	
	comboTipoDespacho.on('select', function(){

		optionsUsuarioStore.webflow({'idTipoDespacho': comboTipoDespacho.getValue()}); 
		comboTipoUsuario.reset();		
		comboTipoUsuario.setDisabled(false);
		primeraVez=true;
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
			data = entidad.get("data");
			
			if(validar()){
			
				Ext.Ajax.request({
					url: page.resolveUrl('coreextension/isProcuradorConProvisiones')
					,params: {
						idAsunto:data.id
					}
					,success:function(result, request){
						var resultado = Ext.decode(result.responseText);
						var tienePermisoCambioProcuradorConProvision = false;
						
						<sec:authorize ifAllGranted="ROLE_PUEDE_CAMBIAR_PROCURADORES_CON_PROVISION">
						tienePermisoCambioProcuradorConProvision = true;
						</sec:authorize>
						
						if((resultado.okko == 'KO') || (tienePermisoCambioProcuradorConProvision) ||
							((resultado.okko == 'OK') && (comboTipoGestor.getRawValue().toUpperCase() != 'PROCURADOR' ))){
							insertarFunction();
							resetCombos();
						}else{
							Ext.Msg.show({
								title:'Atención: Operación no válida',
								msg: 'El gestor asociado contiene provisiones y no puede cambiarse.',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.WARNING});
						}
					}
				});

			}else{
				Ext.Msg.show({
					title:'Atención: Operación no válida',
					msg: 'Tipo gestor, Despacho y Usuario son datos obligatorios.',
					buttons: Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING});
			}
		}
	});


	var insertarFunction=function(){
		data = entidad.get("data");
		Ext.Ajax.request({
			url: page.resolveUrl('coreextension/insertarGestorAdicionalAsuto')
			,params: {
				idTipoGestor:comboTipoGestor.getValue()
				,idAsunto:data.id
				,idUsuario:comboTipoUsuario.getValue()
				,idTipoDespacho:comboTipoDespacho.getValue()
			}
		
			,success:function(){gestorStore.webflow({idAsunto: data.id});}
		})
	}; 
	 
	var borrar = new Ext.Button({
		text : '<s:message code="app.borrar" text="**borrar" />'
		,iconCls : 'icon_menos'
		,cls: 'x-btn-text-icon'
		,disabled:true
		,handler:function(){
			
				borrarFunction();
				borrar.setDisabled(true);
			
		}
	}); 
	
	var borrarFunction=function(){
		data = entidad.get("data");
		Ext.Ajax.request({
			url: page.resolveUrl('coreextension/removeGestor')
			,params: {
				id:idCompuesto
				,idAsunto:data.id
			}
			,success:function(){gestorStore.webflow({idAsunto: data.id});}
		})
	}; 
	
	 var panelGestores = new Ext.Panel({
	 	title:'<s:message code="plugin.coreextension.multigestor.formGestores.titulo" text="**Modificar Gestores" />'
	 	,layout:'form'
	 	,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;'
	 	,style : 'margin-bottom:10px;padding-right:10px'
	 	,items: [comboTipoGestor, comboTipoDespacho, comboTipoUsuario]
	 	 <sec:authorize ifAllGranted="EDIT_GESTORES">
		,bbar:[insertar] 
		</sec:authorize>
	 });
	 
	 var grid = new Ext.grid.GridPanel({
		title:'<s:message code="plugin.coreextension.multigestor.gridGestores.titulo" text="**Lista gestores" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_bienes'
       ,height: 300
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
   		<%--Temporalmente no lo habilitamos
   		borrar.setDisabled(false);
   		 --%>
   		if (recStore.get('id')!=null && recStore.get('id')!="") idCompuesto = recStore.get('id');
	  }); 
	 
	 <%-- RESTO DE PAGINA --%>
	
    var panel = new Ext.Panel({
		title:'<s:message code="plugin.coreextension.multigestor.panel.titulo" text="**Gestores" />'
		,layout : 'column'
		,viewConfig : { columns : 2 }
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [{ columnWidth:1, border:false, items:[panelGestores]},{ columnWidth:1, border:false, items:[grid]}]
		,nombreTab : 'tabContratoBienes'
	});
	
	
	
	
	panel.getValue = function(){
	}
	var data;
	panel.setValue = function(){
	data = entidad.get("data");
			
		 gestorStore.webflow({idAsunto: data.id});
		 optionsGestorStore.webflow({ugCodigo:ugCodigo, porUsuario: porUsuario, adicional: adicional, procuradorAdicional: procuradorAdicional});
	}

	panel.setVisibleTab = function(data){
		return true;
	}
  
	return panel;
})