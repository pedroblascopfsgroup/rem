<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>


	var limit=25;
	
	var myCboxSelModel = new Ext.grid.CheckboxSelectionModel({
 		handleMouseDown : function(g, rowIndex, e){
  		 	var view = this.grid.getView();
    		var isSelected = this.isSelected(rowIndex);
    		if(isSelected) {
      			this.deselectRow(rowIndex);
    		} 
    		else if(!isSelected || this.getCount() > 1) {
      			this.selectRow(rowIndex, true);
      			view.focusRow(rowIndex);
    		}
    		
  		},
  		singleSelect: false
	});

	var columnArray = [
		myCboxSelModel
		,{
			header: '<s:message code="plugin.precontencioso.grid.burofax.cliente" text="**Cliente"/>',
			dataIndex: 'cliente', sortable: true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.estado" text="**Estado"/>',
			dataIndex: 'estado', sortable: true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.direccion" text="**Dirección"/>',
			dataIndex: 'direccion', sortable: false
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.tipo" text="**Tipo"/>',
			dataIndex: 'tipo', sortable: false
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.fechaSolicitud" text="**Fecha Solicitud"/>',
			dataIndex: 'fechaSolicitud', sortable: false
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.fechaEnvio" text="**Fecha Envío"/>',
			dataIndex: 'fechaEnvio', sortable: false
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.fechaAcuse" text="**Fecha Acuse"/>',
			dataIndex: 'fechaAcuse', sortable: false
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultado" text="**Resultado"/>'
			,dataIndex: 'resultado', sortable: false
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoooo" text="**IdDireccion"/>'
			,dataIndex: 'idDireccion', sortable: false
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadooooo" text="**idCliente"/>'
			,dataIndex: 'idCliente', sortable: true
		}
		, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoooooo" text="**idTipoBurofax"/>'
			,dataIndex: 'idTipoBurofax', sortable: false
		}
		, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoOOO" text="**id"/>'
			,dataIndex: 'id', sortable: false
		}
	];


	
	var Burofax = Ext.data.Record.create([
		{name:'cliente'}
	   ,{name:'estado'}
	   ,{name:'direccion'}
	   ,{name:'tipo'}
	   ,{name:'fechaSolicitud'}
	   ,{name:'fechaEnvio'}
	   ,{name:'fechaAcuse'}
	   ,{name:'resultado'}
	   ,{name: 'idDireccion'}
	   ,{name: 'idCliente'}
	   ,{name: 'idTipoBurofax'}
	   ,{name: 'id'}
		
	]);
	
	var burofaxStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,flow:'burofax/getListaBurofax'
		,sortInfo:{field: 'idCliente', direction: "ASC"}
		,groupField:'group'
		,groupOnSort:'true'
		,reader: new Ext.data.JsonReader({
			root: 'listadoBurofax'
			,totalProperty : 'total'
		}, Burofax)
		,remoteSort : false
	});
	
	burofaxStore.addListener('load', agrupa);
	burofaxStore.setDefaultSort('idCliente', 'ASC');
	function agrupa(store, meta) {
		if (!('${noGrouping}'=='true')) {
			//store.groupBy('group', true);
		}		
		burofaxStore.removeListener('load', agrupa);
    };
	
	burofaxStore.webflow();
	
	
	var botonesTabla = fwk.ux.getPaging(burofaxStore);
	botonesTabla.hide();
	
	var btnAddPersona = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.agregarPersona" text="**Añadir Persona" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			
	});
	
	var btnEnviar = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.enviar" text="**Enviar" />'
			,iconCls : 'email'
			,cls: 'x-btn-text-icon'
	});
	
	var btnNuevaDir = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.nuevaDireccion" text="**Nueva Dirección" />'
			,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
	});
	
	var btnEditar = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.editar" text="**Editar" />'
			,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
	});
	
	var btnPreparar = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.preparar" text="**Preparar" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
	});	
	
	var btnCancelar = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,cls: 'x-btn-text-icon'
	});	
	
	Ext.namespace('Ext.ux.plugins');
	
	Ext.ux.plugins.CheckBoxMemory = Ext.extend(Object,{
   		constructor: function(config){
	      	if (!config)
				config = {};

      		this.prefix = 'id_';
      		this.items = {};
      		this.idArray = new Array();
      		this.idProperty = config.idProperty || 'id';
   		},

   		init: function(grid){
			this.store = grid.getStore();
      		this.sm = grid.getSelectionModel();
      		this.sm.on('rowselect', this.onSelect, this);
      		this.sm.on('rowdeselect', this.onDeselect, this);
      		this.store.on('load', this.restoreState, this);
      		btnPreparar.disabled=true;
      		btnEditar.disabled=true;
      		
      		this.store.sort('idCliente','ASC');
	        this.store.setDefaultSort('idCliente', 'ASC');
      		
   		},

   		onSelect: function(sm, idx, rec){
      		this.items[this.getId(rec)] = true;
      		if (this.idArray.indexOf(rec.get(this.idProperty)) < 0){
      			this.idArray.push(rec.get(this.idProperty));
      		}
      		btnPreparar.setDisabled(false);
      		<%-- Si el envio esta en estado preparado, habilitamos el boton editar --%>
			if(gridBurofax.getSelectionModel().getSelected().get('estado') == 'Preparado'){
				btnEditar.setDisabled(false);
			}
   		},

   		onDeselect: function(sm, idx, rec){
      		delete this.items[this.getId(rec)];
      		var i = this.idArray.indexOf(rec.get(this.idProperty));
      		if (i >= 0){
      			delete this.idArray.splice(i,1);
      		}
      		
      		if(myCboxSelModel.getCount() == 0){
      			btnPreparar.setDisabled(true);
      			btnEditar.setDisabled(true);
      		}
   		},

   		restoreState: function(){
      		var i = 0;
      		var sel = [];
      		this.store.each(function(rec){
         		var id = this.getId(rec);
         		if (this.items[id] === true)
            		sel.push(i);
		
         		++i;
      		}, this);
      		if (sel.length > 0)
         		this.sm.selectRows(sel);
   		},

	   getId: function(rec){
      		return this.prefix + rec.get(this.idProperty);
   		},
   	   getIds: function(){
   	   		return this.idArray;
   	   }	
	});
	
	var columMemoryPlugin = new Ext.ux.plugins.CheckBoxMemory();	
	
	
	
	var gridBurofax = new Ext.grid.GridPanel({
		title: '<s:message code="plugin.precontencioso.grid.burofax.titulo" text="**Burofaxes" />'	
		,columns: columnArray
		,store: burofaxStore
		,height: 170
		,loadMask: true
        ,sm: myCboxSelModel
        ,viewConfig: {forceFit: true}
        ,clicksToEdit: 1
        ,viewConfig: {forceFit:true}
        ,plugins: [columMemoryPlugin]
       	,style:'padding:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_asuntos'
		,height:175
		,bbar : [ botonesTabla,btnAddPersona,btnEnviar, btnNuevaDir, btnEditar, btnPreparar,btnCancelar  ]
	});
	

	<%--
	gridBurofax.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_asunto=rec.get('nombre');
    	var id=rec.get('id');
    	app.abreAsunto(id, nombre_asunto);
    });--%>

	
	
   <%-- Eventos para los botones --%>
   
   btnPreparar.on('click', function(){
	var rowsSelected=new Array(); 
	var arrayIdClientes=new Array();
	var arrayIdDirecciones=new Array();
		 
	rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
		
	for (var i=0; i < rowsSelected.length; i++){
	  arrayIdClientes.push(rowsSelected[i].get('idCliente'));
	  arrayIdDirecciones.push(rowsSelected[i].get('idDireccion'));
	}

	 var arrayIdDirecciones = Ext.encode(arrayIdDirecciones);
	 var arrayIdClientes = Ext.encode(arrayIdClientes);
     <%--Comprobamos que hay direcciones seleccionadas --%>
     if(myCboxSelModel.getCount() > 0){
		var w = app.openWindow({
		  flow : 'burofax/getTipoBurofax'
		  //,width:320
		  ,autoWidth:true
		  ,closable:true
		  ,title : '<s:message code="plugin.precontencioso.grid.burofax.tipo.titulo" text="**Seleccionar tipo burofax" />'
		  ,params:{idProcedimiento:1,arrayIdClientes:arrayIdClientes,arrayIdDirecciones:arrayIdDirecciones}
		
		});
		w.on(app.event.DONE,function(){
				w.close();
				burofaxStore.webflow();
				
			});
		w.on(app.event.CANCEL, function(){w.close();});
	  }
	});	
	
	
	btnEditar.on('click', function(){
		var rowsSelected=new Array(); 
		var arrayIdClientes=new Array();
		var arrayIdDirecciones=new Array();
		var arrayIdTipoBurofax=new Array();
		
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdClientes.push(rowsSelected[i].get('idCliente'));
		  arrayIdDirecciones.push(rowsSelected[i].get('idDireccion'));
		  arrayIdTipoBurofax.push(rowsSelected[i].get('idTipoBurofax'));
		 
		}
		
		<%--Para saber si las filas seleccionadas tienen el mismo tipo de burofax, eliminamos los elementos duplicados del array
			entonces si todas las filas seleccionadas tienen el mismo tipo de burofax el array tendrá un tamaño=1 --%>
		uniqueArray = arrayIdTipoBurofax.filter(function(item, pos) {
		    return arrayIdTipoBurofax.indexOf(item) == pos;
		});

	     
		 var arrayIdDirecciones = Ext.encode(arrayIdDirecciones);
		 var arrayIdClientes = Ext.encode(arrayIdClientes);
	     <%--Comprobamos que el tamaño del array es 1 --%>
	     if(uniqueArray.length==1){
			var w = app.openWindow({
			  flow : 'burofax/getEditarBurofax'
			  //,width:320
			  ,autoWidth:true
			  ,closable:true
			  ,title : '<s:message code="plugin.precontencioso.grid.burofax.editar.titulo" text="**Editar Contenido Burofax" />'
			  ,params:{idProcedimiento:1,arrayIdClientes:arrayIdClientes,arrayIdDirecciones:arrayIdDirecciones}
			
			});
			w.on(app.event.DONE,function(){
					w.close();
					
				});
			w.on(app.event.CANCEL, function(){w.close();});
		  }
		  else{
		  	<%--Como los tipos de burofax no son todos iguales NO podemos editar--%>
		  	
		  	 Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.burofaxDistinto" text="**Tipos de burofax distintos" />'
                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.burofaxDistinto" text="**Debe seleccionar envios con el mismo tipo de burofax" />');
		  }
	
	});
	
	
	btnNuevaDir.on('click', function(){
	   
	    var arrayIdClientes=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdClientes.push(rowsSelected[i].get('idCliente'));
		}
		uniqueArray = arrayIdClientes.filter(function(item, pos) {
		    return arrayIdClientes.indexOf(item) == pos;
		});
		if(uniqueArray.length==1){
			var idCliente = gridBurofax.getSelectionModel().getSelected().get('idCliente');
			var w = app.openWindow({
				  flow : 'burofax/getAltaDireccion'
				  //,width:320
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.precontencioso.grid.burofax.editar.titulo" text="**Editar Contenido Burofax" />'
				  ,params:{idCliente:idCliente}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						burofaxStore.webflow();
						
				});
				w.on(app.event.CANCEL, function(){w.close();});
		 }
		 else{
		 	 Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.burofaxDistintooooo" text="**Varios clientes seleccionados" />'
                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.burofaxDistintoooooo" text="**Debe seleccionar un unico cliente" />');
		 }		
	
	});	
	
	
	btnAddPersona.on('click', function(){
	   
			
			var w = app.openWindow({
				  flow : 'burofax/getAltaPersona'
				  ,width:820
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.precontencioso.grid.burofax.editar.titulossss" text="**Agregar Persona" />'
				  //,params:{idCliente:idCliente}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						burofaxStore.webflow();
						
				});
				w.on(app.event.CANCEL, function(){w.close();});
			
	
	});
