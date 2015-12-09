<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

	var limit=50;
	
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
			dataIndex: 'cliente', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.tipoIntervencion" text="**Tipo Intervencion"/>',
			dataIndex: 'tipoIntervencion', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.contrato" text="**Contrato"/>',
			dataIndex: 'contrato', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.estado" text="**Estado"/>',
			dataIndex: 'estado', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.direccion" text="**Dirección"/>',
			dataIndex: 'direccion', sortable: false,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.tipo" text="**Tipo"/>',
			dataIndex: 'tipoDescripcion', sortable: false,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.fechaSolicitud" text="**Fecha Solicitud"/>',
			dataIndex: 'fechaSolicitud', sortable: false,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.fechaEnvio" text="**Fecha Envío"/>',
			dataIndex: 'fechaEnvio', sortable: false,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.fechaAcuse" text="**Fecha Acuse"/>',
			dataIndex: 'fechaAcuse', sortable: false,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultado" text="**Resultado"/>'
			,dataIndex: 'resultado', sortable: true,autoWidth:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoo" text="**IdDireccion"/>'
			,dataIndex: 'idDireccion', sortable: false,autoWidth:true,hidden:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoo" text="**idCliente"/>'
			,dataIndex: 'idCliente', sortable: true,autoWidth:true,hidden:true
		}
		, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoo" text="**idTipoBurofax"/>'
			,dataIndex: 'idTipoBurofax', sortable: false,autoWidth:true,hidden:true
		}
		, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoo" text="**idBurofax"/>'
			,dataIndex: 'idBurofax', sortable: false,autoWidth:true,hidden:false,hidden:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoo" text="**idEnvio"/>'
			,dataIndex: 'idEnvio', sortable: false,autoWidth:true,hidden:true
		}, {
			header: '<s:message code="plugin.precontencioso.grid.burofax.resultadoo" text="**id"/>'
			,dataIndex: 'id', sortable: true,autoWidth:true,hidden:true
		}
	];


	
	var Burofax = Ext.data.Record.create([
		{name:'cliente'}
	   ,{name:'tipoIntervencion'}
	   ,{name:'contrato'}
	   ,{name:'estado'}
	   ,{name:'direccion'}
	   ,{name:'tipo'}
	   ,{name:'tipoDescripcion'}
	   ,{name:'fechaSolicitud'}
	   ,{name:'fechaEnvio'}
	   ,{name:'fechaAcuse'}
	   ,{name:'resultado'}
	   ,{name: 'idDireccion'}
	   ,{name: 'idCliente'}
	   ,{name: 'idTipoBurofax'}
	   ,{name: 'idBurofax'}
	   ,{name: 'idEnvio'}
	   ,{name: 'id'}
		
	]);
	
	var burofaxStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,flow:'burofax/getListaBurofax'
		,sortInfo:{field: 'idCliente', direction: "DESC"}
		,groupField:'group'
		,groupOnSort:'true'
		,reader: new Ext.data.JsonReader({
			root: 'listadoBurofax'
			,totalProperty : 'total'
		}, Burofax)
		,remoteSort : false
	});
	
	burofaxStore.addListener('load', agrupa);
	//burofaxStore.setDefaultSort('idCliente', 'DESC');
	function agrupa(store, meta) {
		if (!('${noGrouping}'=='true')) {
			//store.groupBy('group', true);
		}		
		burofaxStore.removeListener('load', agrupa);
    };
	
	var botonesTabla = fwk.ux.getPaging(burofaxStore);
	botonesTabla.hide();
	
	var btnAddPersona = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.agregarPersona" text="**Añadir Persona" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			
	});
	
	var btnEnviar = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.enviar" text="**Enviar" />'
			,iconCls : 'icon_comunicacion'
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
			,hidden: true
	});
	
	
	var btnNotificar = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.añadir.informacion.envio" text="**Añadir Información de Envío" />'
			,iconCls : 'icon_info'
			,cls: 'x-btn-text-icon'
			,hidden: true
	});
	
	var btnDescargarBurofax = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.descargar.burofax" text="**Descargar Burofax" />'
			,iconCls : 'icon_download'
			,cls: 'x-btn-text-icon'
<%-- 			,hidden:true --%>
	});		
	
	// nuevos botones
	
	var btnBorrarDirOrigenManual = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.borrarOrigenManual" text="**Borrar Dir. Manual" />'
			,iconCls : 'icon_menos'
			,cls: 'x-btn-text-icon'
<%-- 			,hidden:true --%>
	});	
	var btnDescartarPersEnvio = new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.descartar" text="**Descartar persona" />'
			,iconCls : 'icon_cancel'
			,cls: 'x-btn-text-icon'
<%-- 			,hidden:true --%>
	});
	
	var btnCancelarEnEstPrep = 	new Ext.Button({
			text : '<s:message code="plugin.precontencioso.grid.burofax.anular" text="**Anular Burofax" />'
			,iconCls : 'icon_menos'
			,cls: 'x-btn-text-icon'
<%-- 			,hidden:true --%>
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
      		//this.idProperty = 'idEnvio';
      		
   		},

   		init: function(grid){
			this.store = grid.getStore();
      		this.sm = grid.getSelectionModel();
      		this.sm.on('rowselect', this.onSelect, this);
      		this.sm.on('rowdeselect', this.onDeselect, this);
      		this.store.on('load', this.restoreState, this);
      		btnPreparar.disabled=true;
      		btnEditar.disabled=true;
      		btnNuevaDir.disabled=true;
      		btnEnviar.disabled=true;
      		btnNotificar.disabled=true;
      		btnDescargarBurofax.disabled=true;
      		btnBorrarDirOrigenManual.disabled=true;
      		btnDescartarPersEnvio.disabled=true;
      		btnCancelarEnEstPrep.disabled=true;
      		//this.store.sort('idCliente','DESC');
	        //this.store.setDefaultSort('idCliente', 'DESC');
      		
   		},

   		onSelect: function(sm, idx, rec)
   		{
      		this.items[this.getId(rec)] = true;
      		if (this.idArray.indexOf(rec.get(this.idProperty)) < 0){
      			this.idArray.push(rec.get(this.idProperty));
      		}
      		
      		if(actualizarBotonesBurofax()){      		
      			if(myCboxSelModel.getCount() == 1) {
		      		validarBotonesSeleccionUnica();

				}
				else {
					comprobarEstadoBotones();
				}	
			}
			
		  <%--comprobamos si es de origen manual --%>
		  var idDireccion = gridBurofax.getSelectionModel().getSelected().get('idDireccion');
		  var esManual = comprobarEsManual(idDireccion);
   		},

   		onDeselect: function(sm, idx, rec)
   		{
      		delete this.items[this.getId(rec)];
      		var i = this.idArray.indexOf(rec.get(this.idProperty));
      		if (i >= 0){
      			delete this.idArray.splice(i,1);
      		}
      		
      		if(myCboxSelModel.getCount() == 0){
      			btnPreparar.setDisabled(true);
      			btnEditar.setDisabled(true);
      			btnNuevaDir.setDisabled(true);
      			btnEnviar.setDisabled(true);
      			btnNotificar.setDisabled(true);
      			btnDescargarBurofax.setDisabled(true);
      			btnBorrarDirOrigenManual.setDisabled(true);
      			btnDescartarPersEnvio.setDisabled(true);
      			btnCancelarEnEstPrep.setDisabled(true);
      		}
      		else {
      			if(actualizarBotonesBurofax()){
      				if(myCboxSelModel.getCount() == 1) {
      					validarBotonesSeleccionUnica();			      		
					}
					else {
	      				comprobarEstadoBotones();
	      			}
	      		}
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
	
	var botonRefresh = new Ext.Button({
		text : 'Refresh'
		,iconCls : 'icon_refresh'
		,handler:function(){
			refrescarBurofaxGrid();
		}
	});
	
	var separadorButtons = new Ext.Toolbar.Fill();	
	
	var gridBurofax = new Ext.grid.GridPanel({
		title: '<s:message code="plugin.precontencioso.grid.burofax.titulo" text="**Burofaxes" />'	
		,columns: columnArray
		,store: burofaxStore
		,height: 270
		,loadMask: true
        ,sm: myCboxSelModel
        ,viewConfig: {forceFit: true}
        ,autoExpand:true
        ,clicksToEdit: 1
        ,plugins: [columMemoryPlugin]
       	,style:'padding-top:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_asuntos'
		<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_BUR_BTN">
			,bbar : [ botonesTabla,btnAddPersona,btnEnviar, btnNuevaDir, btnEditar, btnPreparar,btnCancelar, btnNotificar,btnDescargarBurofax, btnBorrarDirOrigenManual, btnDescartarPersEnvio,  separadorButtons, btnCancelarEnEstPrep, botonRefresh ]
		</sec:authorize>
		,autoWidth: true
		,collapsible: true
		,doLayout: function() {
			if(this.isVisible()){
				var margin = 10;
				var parentSize = app.contenido.getSize(true);
				var width = (parentSize.width) - (2*margin);
				this.setWidth(width);
				Ext.grid.GridPanel.prototype.doLayout.call(this);
			}
		}		
	});
	

   <%-- Eventos para los botones --%>
   
   btnPreparar.on('click', function(){
	var rowsSelected=new Array(); 
	var arrayIdBurofax=new Array();
	var arrayIdDirecciones=new Array();
	var arrayIdEnvios=new Array();
		 
	rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
		
	for (var i=0; i < rowsSelected.length; i++){
	  arrayIdBurofax.push(rowsSelected[i].get('idBurofax'));
	  if(rowsSelected[i].get('idDireccion') != ''){
	  	arrayIdDirecciones.push(rowsSelected[i].get('idDireccion'));
	  }
	  arrayIdEnvios.push(rowsSelected[i].get('idEnvio'));
	}

	
     <%--Comprobamos que hay direcciones seleccionadas en TODAS las selecciones --%>
     if(myCboxSelModel.getCount() > 0 && arrayIdDirecciones.length == myCboxSelModel.getCount()){
     	 var arrayIdDirecciones = Ext.encode(arrayIdDirecciones);
		 var arrayIdBurofax = Ext.encode(arrayIdBurofax);
		 var arrayIdEnvios = Ext.encode(arrayIdEnvios);
		var w = app.openWindow({
		  flow : 'burofax/getTipoBurofax'
		  //,width:320
		  ,autoWidth:true
		  ,closable:true
		  ,title : '<s:message code="plugin.precontencioso.grid.burofax.tipo.titulo" text="**Seleccionar tipo burofax" />'
		  ,params:{arrayIdDirecciones:arrayIdDirecciones,arrayIdBurofax:arrayIdBurofax,arrayIdEnvios:arrayIdEnvios}
		
		});
		w.on(app.event.DONE,function(){
				w.close();
				refrescarBurofaxGrid();
				
			});
		w.on(app.event.CANCEL, function(){w.close();});
	  }
	  else{
	  	 Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.noDirecciones" text="**No hay direcciones seleccionadas" />'
                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.noDirecciones" text="**Todas las selecciones deben tener una dirección asociada" />');
	  }
	});	
	
	
	btnEditar.on('click', function(){
		var rowsSelected=new Array(); 
		
		var arrayIdTipoBurofax=new Array();
		var arrayIdEnvios=new Array();
		var arrayResultados=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdEnvios.push(rowsSelected[i].get('idEnvio'));
		  arrayIdTipoBurofax.push(rowsSelected[i].get('idTipoBurofax'));
		  arrayResultados.push(rowsSelected[i].get('resultado'));
		   
		}
		
		<%-- Comprobamos que todas las filas seleccionadas estan en estado Preparado --%>
		uniqueArrayResultados = arrayResultados.filter(function(item, pos) {
		    return arrayResultados.indexOf(item) == pos;
		});
		
		
		if(uniqueArrayResultados.length == 1 && uniqueArrayResultados[0] == 'Preparado'){
		
			<%--Para saber si las filas seleccionadas tienen el mismo tipo de burofax, eliminamos los elementos duplicados del array
				entonces si todas las filas seleccionadas tienen el mismo tipo de burofax el array tendrá un tamaño=1 --%>
			uniqueArray = arrayIdTipoBurofax.filter(function(item, pos) {
			    return arrayIdTipoBurofax.indexOf(item) == pos;
			});
	
		     
			 var arrayIdEnvios = Ext.encode(arrayIdEnvios);
			
			
		     <%--Comprobamos que el tamaño del array es 1 --%>
		     if(uniqueArray.length==1){
				var w = app.openWindow({
				  flow : 'burofax/getEditarBurofax'
				  ,width:740
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.precontencioso.grid.burofax.editar.titulo" text="**Editar Contenido Burofax" />'
				  ,params:{arrayIdEnvios:arrayIdEnvios}
				
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
		}
		else{
			 Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.noPreparados" text="**Envios no preparados" />'
                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.noPreparados" text="**Todos los envios tienen que estar preparados" />');
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
				  ,width:720
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.precontencioso.grid.burofax.agregar.direccion" text="**Agregar Dirección" />'
				  ,params:{idCliente:idCliente,idProcedimiento:idProcedimiento}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						refrescarBurofaxGrid();
						
				});
				w.on(app.event.CANCEL, function(){w.close();});
		 }
		 else{
		 	 Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.variosClientes" text="**Varios clientes seleccionados" />'
                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.variosClientes" text="**Debe seleccionar un unico cliente" />');
		 }		
	
	});	
	
	
	btnAddPersona.on('click', function(){
			var w = app.openWindow({
				  flow : 'burofax/getAltaPersona'
				  ,width:820
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.precontencioso.grid.burofax.agregar.persona" text="**Añadir Notificado" />'
				  ,params:{idProcedimiento:idProcedimiento}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						refrescarBurofaxGrid();
						
						
				});
				w.on(app.event.CANCEL, function(){w.close();});
			
	
	});
	
	btnCancelarEnEstPrep.on('click', function(){
	 var arrayIdClientes=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdClientes.push(rowsSelected[i].get('idCliente'));
		}
	uniqueArray = arrayIdClientes.filter(function(item, pos) {
		    return arrayIdClientes.indexOf(item) == pos;
		});
		if(uniqueArray.length==1){
		Ext.Msg.confirm(
			'<s:message code="plugin.precontencioso.grid.burofax.cancelarBurofax.EstadoPreparado" text="**Cancelar burofax" />', 
			'<s:message code="plugin.precontencioso.grid.burofax.cancelarBurofax.EstadoPreparado.Mensaje"
 				text="**Va a cancelar el burofax ¿Está usted seguro?" />', 
			function(btn) {
				if (btn == 'yes') {
				var idEnvio=gridBurofax.getSelectionModel().getSelected().get('idEnvio');
				var idCliente=gridBurofax.getSelectionModel().getSelected().get('idCliente');
					Ext.Ajax.request({
							url: page.resolveUrl('burofax/cancelarEnEstPrep'),
							params: {idEnvio:idEnvio, idCliente:idCliente},
							method: 'POST',
							success: function (result, request) {
								Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.grid.burofax.cancelarBurofax.correcto"
									text="**El burofax se ha cancelado correctamente" />',
									buttons: Ext.Msg.OK
								});
								refrescarBurofaxGrid();
							},
							error: function() {
								mask.hide();
								Ext.MessageBox.show({
							    	title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />',
									width: 300,
									buttons: Ext.MessageBox.OK
								});
							} 
					});
				}else{
					Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.grid.burofax.cancelarBurofax.NoCorrecto"
									text="**El burofax no se ha cancelado" />',
									buttons: Ext.Msg.OK
								});
				}
			});
		}else{
			Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.variosClientes" text="**Varios clientes seleccionados" />'
                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.variosClientes" text="**Debe seleccionar un unico cliente" />');
		}
	});
	
	
	btnDescartarPersEnvio.on('click', function(){
	 var arrayIdClientes=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdClientes.push(rowsSelected[i].get('idCliente'));
		}
	uniqueArray = arrayIdClientes.filter(function(item, pos) {
		    return arrayIdClientes.indexOf(item) == pos;
		});
		if(uniqueArray.length==1){
		Ext.Msg.confirm(
			'<s:message code="plugin.precontencioso.grid.burofax.descartarPersona" text="**Descartar Persona" />', 
			'<s:message code="plugin.precontencioso.grid.burofax.descartarPersona.mensaje"
 				text="**Va a descartar esta persona para el envío ¿Está usted seguro?" />', 
			function(btn) {
				if (btn == 'yes') {
				var idBurofax=gridBurofax.getSelectionModel().getSelected().get('idBurofax');
					Ext.Ajax.request({
							url: page.resolveUrl('burofax/descartarPersonaEnvio'),
							params: {idBurofax:idBurofax},
							method: 'POST',
							success: function (result, request) {
								Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.grid.burofax.descartarPersonaEnvio.correcto"
									text="**Se ha descartado correctamente" />',
									buttons: Ext.Msg.OK
								});
								refrescarBurofaxGrid();
							},
							error: function() {
								mask.hide();
								Ext.MessageBox.show({
							    	title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />',
									width: 300,
									buttons: Ext.MessageBox.OK
								});
							} 
					});
				}else{
					Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.grid.burofax.descartarPersona.NoCorrecto"
									text="**La persona no se ha descartado" />',
									buttons: Ext.Msg.OK
								});
				}
			});
		}else{
			Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.variosClientes" text="**Varios clientes seleccionados" />'
                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.variosClientes" text="**Debe seleccionar un unico cliente" />');
		}
	});
	
	btnBorrarDirOrigenManual.on('click', function(){
		var arrayIdClientes=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdClientes.push(rowsSelected[i].get('idDireccion'));
		}
		uniqueArray = arrayIdClientes.filter(function(item, pos) {
		    return arrayIdClientes.indexOf(item) == pos;
		});
		if(uniqueArray.length==1){
			Ext.Msg.confirm(
			'<s:message code="plugin.precontencioso.grid.burofax.borrarDireccion" text="**Borrar dirección" />', 
			'<s:message code="plugin.precontencioso.grid.burofax.borrarDireccion.mensaje"
 				text="**Va a borrar la dirección de esta persona ¿Está usted seguro?" />', 
			function(btn) {
				if (btn == 'yes') {
					var idDireccion=gridBurofax.getSelectionModel().getSelected().get('idDireccion');
					Ext.Ajax.request({
							url: page.resolveUrl('burofax/borrarDirecManual'),
							params: {idDireccion:idDireccion},
							method: 'POST',
							success: function (result, request) {
								Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.grid.burofax.borrarDireccion.correcto"
									text="**Se ha borrado correctamente" />',
									buttons: Ext.Msg.OK
								});
								refrescarBurofaxGrid();
							},
							error: function() {
								mask.hide();
								Ext.MessageBox.show({
							    	title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.button.finalizarPreparacion.error.exception" text="**Se ha producido un error. Consulte con soporte" />',
									width: 300,
									buttons: Ext.MessageBox.OK
								});
							} 
					});
				}else{
					Ext.Msg.show({
									title: fwk.constant.alert,
									msg: '<s:message code="plugin.precontencioso.grid.burofax.borrarDireccion.NoCorrecto"
									text="**La dirección no se ha eliminado" />',
									buttons: Ext.Msg.OK
					});
				}
			});
		}else{
			Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.variasDirecciones" text="**Varias direcciones seleccionadas" />'
                ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.variasDirecciones" text="**Debe seleccionar una única dirección" />');
        };
	});
	
	
	btnEnviar.on('click', function(){
	
		var rowsSelected=new Array(); 
		var arrayResultado=new Array();
		var arrayIdEnvios=new Array();
		var arrayIdBurofax=new Array();
		var arrayIdDirecciones=new Array();
		var tipoBurofax=gridBurofax.getSelectionModel().getSelected().get('tipoBurofax');
		
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayResultado.push(rowsSelected[i].get('resultado'));
		  arrayIdEnvios.push(rowsSelected[i].get('idEnvio'));
		  arrayIdBurofax.push(rowsSelected[i].get('idBurofax'));
  		  
  		  if(rowsSelected[i].get('idDireccion') != ''){
  		  	arrayIdDirecciones.push(rowsSelected[i].get('idDireccion'));
  		  }
  		 
		}
	
		<%--Comprobamos que hay direcciones seleccionadas en TODAS las selecciones --%>
    		if(myCboxSelModel.getCount() > 0 && arrayIdDirecciones.length == myCboxSelModel.getCount()){	
			//Parametros para configurar el tipo de burofax
			var arrayIdDirecciones = Ext.encode(arrayIdDirecciones);
	 		var arrayIdBurofax = Ext.encode(arrayIdBurofax);
			var arrayIdEnvios =	Ext.encode(arrayIdEnvios);
			
			//Comprobamos que los resultados son iguales
			uniqueArray = arrayResultado.filter(function(item, pos) {
			    return arrayResultado.indexOf(item) == pos;
			});
			
			if(uniqueArray.length==1){
			  //Como los resultados son iguales , comprobamos si el estado es NO preparado
			  if(uniqueArray[0]==''){
			    //Comprobamos que el tipo de burofax configurado por defecto es el mismo para todos
			    var arrayTipoBurofax=new Array();
			    
			    for (var i=0; i < rowsSelected.length; i++){
			  		arrayTipoBurofax.push(rowsSelected[i].get('tipo'));
			 
				}
				
				uniqueArrayTipoBurofax = arrayTipoBurofax.filter(function(item, pos) {
			    	return arrayTipoBurofax.indexOf(item) == pos;
				});
				
				if(uniqueArrayTipoBurofax.length == 1){
				 //Abrimos ventana
				 var w = app.openWindow({
						  flow : 'burofax/getEnvioBurofax'
						  ,width:320
						  ,autoWidth:true
						  ,closable:true
						  ,title : '<s:message code="plugin.precontencioso.grid.burofax.envio" text="**Envio Burofaxes" />'
						  ,params:{codigoTipoBurofax:uniqueArrayTipoBurofax[0],arrayIdDirecciones:arrayIdDirecciones,arrayIdBurofax:arrayIdBurofax,arrayIdEnvios:arrayIdEnvios,comboEditable:true}
						  		  
						});
						w.on(app.event.DONE,function(){
								w.close();
								refrescarBurofaxGrid();
						});
						w.on(app.event.CANCEL, function(){w.close();});
					}
				  else{
					//Mensaje de error
						Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.tipoDistinto" text="**Envios con tipos de burofax distinto" />'
	                 ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.burofaxDistintoDefecto" text="**Debe seleccionar envios con el mismo tipo de burofax configurado por defecto" />');
				  }	
				 
				}
				 
				 else if(uniqueArray[0]=='Preparado'){
				  	//Comprobamos que el tipo de burofax  es el mismo para todos
				    var arrayTipoBurofax=new Array();
				    
				    for (var i=0; i < rowsSelected.length; i++){
				  		arrayTipoBurofax.push(rowsSelected[i].get('tipo'));
				 
					}
					
					uniqueArrayTipoBurofax = arrayTipoBurofax.filter(function(item, pos) {
				    	return arrayTipoBurofax.indexOf(item) == pos;
					});
					
					if(uniqueArrayTipoBurofax.length == 1){
					 //Abrimos ventana
					 var w = app.openWindow({
						  flow : 'burofax/getEnvioBurofax'
						  ,width:320
						  ,autoWidth:true
						  ,closable:true
						  ,title : '<s:message code="plugin.precontencioso.grid.burofax.envio" text="**Envio Burofaxes" />'
						 ,params:{codigoTipoBurofax:uniqueArrayTipoBurofax[0],arrayIdDirecciones:arrayIdDirecciones,arrayIdBurofax:arrayIdBurofax,arrayIdEnvios:arrayIdEnvios,comboEditable:false}
						
						});
						w.on(app.event.DONE,function(){
								w.close();
								refrescarBurofaxGrid();
						});
						w.on(app.event.CANCEL, function(){w.close();});
					}
					else{
						//Mensaje de error
						Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.tipoDistinto" text="**Envios con tipos de burofax distinto" />'
	                 		,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.tipoDistinto" text="**Debe seleccionar envios con el mismo tipo de burofax" />');
					}
				    
				  }
				
			    
			  
			  }
			  else{
				Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.resultadoDistinto" text="**Envios con resultado distinto" />'
	                 		,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.resultadoDistinto" text="**Debe seleccionar envios con el mismo resultado" />');
				}
		}
		else{
			 Ext.MessageBox.alert('<s:message code="plugin.precontencioso.grid.burofax.mensajes.titulo.noDirecciones" text="**No hay direcciones seleccionadas" />'
                ,'<s:message code="plugin.precontencioso.grid.burofax.mensajes.noDirecciones" text="**Todas las selecciones deben tener una dirección asociada" />');
		}
	});
	
	
	btnNotificar.on('click', function(){
	
			var arrayIdEnvios=new Array();
		 
			rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
				
			for (var i=0; i < rowsSelected.length; i++){
			  arrayIdEnvios.push(rowsSelected[i].get('idEnvio'));
			 
			}
			
			//Parametros para configurar el tipo de burofax
			var arrayIdEnvios = Ext.encode(arrayIdEnvios);
	 		
			var w = app.openWindow({
				  flow : 'burofax/getPantallaInformacionEnvio'
				  ,width:400
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.precontencioso.grid.burofax.añadir.informacion.envio" text="**Añadir Información de Envío" />'
				  ,params:{arrayIdEnvios:arrayIdEnvios}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						refrescarBurofaxGrid();
						
				});
				w.on(app.event.CANCEL, function(){w.close();});
			
	
	});
	
	btnDescargarBurofax.on('click', function(){
		var flow='/pfs/burofax/descargarBurofax';
		var params={idEnvio:gridBurofax.getSelectionModel().getSelected().get('idEnvio')};
		app.openBrowserWindow(flow,params);
		page.fireEvent(app.event.DONE);
	});
	
	var idProcedimiento;
	var refrescarBurofaxGrid = function() {
		burofaxStore.webflow({idProcedimiento: data.precontencioso.id});
		idProcedimiento=data.precontencioso.id;
		debugger;
		gridBurofax.getSelectionModel().clearSelections();
		actualizarBotonesBurofax();
		
	}
	
	var actualizarBotonesBurofax = function() {
	// Se comprueba que el procedimiento se encuentre en un estado que permita editar los burofaxes
	
		if (data != null) {
			var estadoActualCodigoProcedimiento = data.precontencioso.estadoActualCodigo;
			if (!data.esExpedienteEditable || (estadoActualCodigoProcedimiento != 'PR'  && estadoActualCodigoProcedimiento != 'SU' && estadoActualCodigoProcedimiento != 'SC')) {
				btnAddPersona.setDisabled(true);
				btnEnviar.setDisabled(true);
				btnNuevaDir.setDisabled(true);
				btnEditar.setDisabled(true);
				btnPreparar.setDisabled(true);
				btnCancelar.setDisabled(true);
				btnNotificar.setDisabled(true);
				btnDescargarBurofax.setDisabled(true);
				return false;
			}

		}
		return true;

	}

	
	var comprobarEstadoBotones = function() {
	
		if(!btnEnviar.disabled && !validarBotonEnviarHabilitado()) {
			btnEnviar.setDisabled(true);
		}
		
		if(!btnNuevaDir.disabled && !validarBotonNuevaDirHabilitado()) {
			btnNuevaDir.setDisabled(true);
		}		
		
		if(!btnEditar.disabled && !validarBotonEditarHabilitado()) {
			btnEditar.setDisabled(true);
		}	
		
		if(!btnPreparar.disabled && !validarBotonPrepararHabilitado()) {
			btnPreparar.setDisabled(true);
		}	
	}
	
	var validarBotonEnviarHabilitado = function() {
		
		var rowsSelected=new Array(); 
		var arrayResultado=new Array();
		var arrayIdEnvios=new Array();
		var arrayIdBurofax=new Array();
		var arrayIdDirecciones=new Array();
		var tipoBurofax=gridBurofax.getSelectionModel().getSelected().get('tipoBurofax');
				 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
				
		for (var i=0; i < rowsSelected.length; i++){
			arrayResultado.push(rowsSelected[i].get('resultado'));
			arrayIdEnvios.push(rowsSelected[i].get('idEnvio'));
			arrayIdBurofax.push(rowsSelected[i].get('idBurofax'));
			 		  
			if(rowsSelected[i].get('idDireccion') != ''){
				arrayIdDirecciones.push(rowsSelected[i].get('idDireccion'));
			}
		}
		
		<%--Comprobamos que hay direcciones seleccionadas en TODAS las selecciones --%>
		if(myCboxSelModel.getCount() > 0 && arrayIdDirecciones.length == myCboxSelModel.getCount()){	
			//Parametros para configurar el tipo de burofax
			var arrayIdDirecciones = Ext.encode(arrayIdDirecciones);
			var arrayIdBurofax = Ext.encode(arrayIdBurofax);
			var arrayIdEnvios =	Ext.encode(arrayIdEnvios);
			
			//Comprobamos que los resultados son iguales
			uniqueArray = arrayResultado.filter(function(item, pos) {
				return arrayResultado.indexOf(item) == pos;
			});
			
			if(uniqueArray.length==1){
				//Como los resultados son iguales , comprobamos si el estado es NO preparado
				if(uniqueArray[0]==''){
					//Comprobamos que el tipo de burofax configurado por defecto es el mismo para todos
					var arrayTipoBurofax=new Array();
					    
					for (var i=0; i < rowsSelected.length; i++){
						arrayTipoBurofax.push(rowsSelected[i].get('tipo'));
					}
						
					uniqueArrayTipoBurofax = arrayTipoBurofax.filter(function(item, pos) {
						return arrayTipoBurofax.indexOf(item) == pos;
					});
						
					if(uniqueArrayTipoBurofax.length == 1){
						return true;
					}
					else{
						return false
					}	
				}
				else if(uniqueArray[0]=='Preparado'){
					//Comprobamos que el tipo de burofax  es el mismo para todos
					var arrayTipoBurofax=new Array();
					    
					for (var i=0; i < rowsSelected.length; i++){
						arrayTipoBurofax.push(rowsSelected[i].get('tipo'));
					}
						
					uniqueArrayTipoBurofax = arrayTipoBurofax.filter(function(item, pos) {
						return arrayTipoBurofax.indexOf(item) == pos;
					});
						
					if(uniqueArrayTipoBurofax.length == 1){
						return true;
					}
					else{
						return false;
					}
				}
			}
			else{
				return false;
			}
		}
		else{
			return false;
		}
				
		return true;	
	}
	
	var validarBotonesSeleccionUnica = function() {
		btnPreparar.setDisabled(false);
		<%-- Si la dirección ha sido borrada y no tiene una asignada se desactiva el botón preparar --%>
		<%-- if(gridBurofax.getSelectionModel().getSelected().get('direccion') == ''){
			btnPreparar.setDisabled(true);
		}--%>
     		<%-- Si el envio esta en estado preparado, habilitamos el boton editar --%>
		if(gridBurofax.getSelectionModel().getSelected().get('resultado') == 'Preparado'){
			btnEditar.setDisabled(false);
		}
		else{
			btnEditar.setDisabled(true);
		}
		
		
		<%-- Comprobamos que se ha seleccionado un cliente --%>
		if(gridBurofax.getSelectionModel().getSelected().get('idCliente') != ''){
			btnNuevaDir.setDisabled(false);
		}
		
		<%--Si el resultado del envio es enviado y todavia no ha sido enviado habilitamos el boton de notificar --%>
		if(gridBurofax.getSelectionModel().getSelected().get('idEnvio') != '' && gridBurofax.getSelectionModel().getSelected().get('fechaAcuse') == ''){
			btnNotificar.setDisabled(false);
		}
		
		<%-- Como se puede enviar sin estar preparado habilitamos el boton enviar--%>
		btnEnviar.setDisabled(false);
		
		<%-- Si el Resultado es notificado habilitamos el boton de añadir notificacion --%>
		if(gridBurofax.getSelectionModel().getSelected().get('resultado') == 'Enviado'){
			btnNotificar.setDisabled(false);
		}
		else{
			btnNotificar.setDisabled(true);
		}
		<%-- Si hay un envio seleccionado y su estado es ENVIADO habilitamos el boton de descargar burofax --%>
		if(gridBurofax.getSelectionModel().getSelected().get('resultado') == 'Enviado' && myCboxSelModel.getCount() == 1){
			btnDescargarBurofax.setDisabled(false);
		}
		else{
			btnDescargarBurofax.setDisabled(true);
		}
								
		<%--Si ya se ha producido el envio y se ha añadido informacion de envio se desabilitan todos los botones menos añadir persona ,añadir direccion y descargarBurofax --%>
		if(gridBurofax.getSelectionModel().getSelected().get('fechaAcuse') != ''){
			//btnAddPersona.setDisabled(true);
			btnEnviar.setDisabled(true);
			//btnNuevaDir.setDisabled(true);
			btnEditar.setDisabled(true);
			btnPreparar.setDisabled(true);
			btnCancelar.setDisabled(true);
			btnNotificar.setDisabled(true);
			
		}
		else {
			if(!btnEnviar.disabled && !validarBotonEnviarHabilitado()) {
				btnEnviar.setDisabled(true);
			}
			
			if(!btnNuevaDir.disabled && !validarBotonNuevaDirHabilitado()) {
				btnNuevaDir.setDisabled(true);
			}
			
			if(!btnEditar.disabled && !validarBotonEditarHabilitado()) {
				btnEditar.setDisabled(true);
			}
			
			if(!btnPreparar.disabled && !validarBotonPrepararHabilitado()) {
				btnPreparar.setDisabled(true);
			}
		}
		var tmp = gridBurofax.getSelectionModel().getSelected().get('idCliente');
		<%-- Si el Resultado NO es enviado y el estado NO es descartado habilitamos el boton de descartar persona y el idBurofax es distinto de vacio(nos aseguramos que está marcada una persona)--%>
		if(gridBurofax.getSelectionModel().getSelected().get('resultado') != 'Enviado' && gridBurofax.getSelectionModel().getSelected().get('estado') != 'Descartada' && tmp != ""){
			btnDescartarPersEnvio.setDisabled(false);
		}
		
		<%-- si la persona esta en estado "Descartada" no se le puede enviar --%>
		var idBurofaxComparar = gridBurofax.getSelectionModel().getSelected().get('idBurofax');
		var idDireccionComparar = gridBurofax.getSelectionModel().getSelected().get('idDireccion');

		for (var i = 0; i < gridBurofax.getStore().data.length; i++) { <%-- lo que hacemos en este bucle es recorrer todo el grid, y ver si --%>
	    	var element = Ext.get(gridBurofax.getView().getRow(i));	   <%-- hay algun burofax con el mismo id que el seleccionado y que su --%>
	   		var record = gridBurofax.getStore().getAt(i);			   <%-- estado sea "Descartada". Si es asi, desactivamos el boton enviar --%>
	   		var tmpBurofax = record.data.idBurofax;
	   		var tmpDireccion = record.data.idDireccion;
	   		if(tmpBurofax == idBurofaxComparar || tmpDireccion == idDireccionComparar){
	   			var estadoComparar = record.data.estado;
	   			if(estadoComparar == 'Descartada'){
	   				btnEnviar.setDisabled(true);
	   				break;
	   			}
	   		}
		}
		
				
		if(gridBurofax.getSelectionModel().getSelected().get('estado') == 'Descartada'){
			btnEnviar.setDisabled(true);
		}
		<%-- Si no tiene direccion asignada, no se habilita 
		if(gridBurofax.getSelectionModel().getSelected().get('idDireccion') != ""){
			btnBorrarDirOrigenManual.setDisabled(false);
		}else{
			btnBorrarDirOrigenManual.setDisabled(true);
		}--%>
		<%--Si el burafax se encuentra en Preparado, mientras no se envíe podremos cancelarlo --%>
		if((gridBurofax.getSelectionModel().getSelected().get('resultado') == 'Preparado' ||  gridBurofax.getSelectionModel().getSelected().get('resultado') == 'Solicitado') && myCboxSelModel.getCount() == 1){
			btnCancelarEnEstPrep.setDisabled(false);
		}
	}
	
	var comprobarEsManual = function(idDireccion){
		debugger;
			Ext.Ajax.request({
				url: page.resolveUrl('burofax/saberOrigen')
				,params: {idDireccion:idDireccion}
				,method: 'POST'
				,success: function (result, request)
				{
					var r = Ext.util.JSON.decode(result.responseText);
					var solucion = r.esManual;
				 	if(solucion){
						<%--Si ya se ha enviado el burofax, tampoco deja borrar la dirección --%>
						if(gridBurofax.getSelectionModel().getSelected().get('resultado') == 'Solicitado' || gridBurofax.getSelectionModel().getSelected().get('resultado') == 'Enviado' ){
							btnBorrarDirOrigenManual.setDisabled(true);
						}else{
							btnBorrarDirOrigenManual.setDisabled(false);	
							var idClienteComparar = gridBurofax.getSelectionModel().getSelected().get('idCliente');
							for (var i = 0; i < gridBurofax.getStore().data.length; i++) {
						    	var element = Ext.get(gridBurofax.getView().getRow(i));
						   		var record = gridBurofax.getStore().getAt(i);
						   		var tmpDireccion = record.data.idDireccion;
						   		if(tmpDireccion == idDireccion && (idClienteComparar == null || idClienteComparar == '')){
						   			btnBorrarDirOrigenManual.setDisabled(true);
						   		}
							}
						}
		  			}else{
						btnBorrarDirOrigenManual.setDisabled(true);
		  			}
				}
			});
	}
	
	var validarBotonNuevaDirHabilitado = function() {
		var arrayIdClientes=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdClientes.push(rowsSelected[i].get('idCliente'));
		}
		
		uniqueArray = arrayIdClientes.filter(function(item, pos) {
		    return arrayIdClientes.indexOf(item) == pos;
		});
		
		if(uniqueArray.length==1){
			return true;
		}
		else{
			return false;
		}
	}
	
	var validarBotonEditarHabilitado = function() {
		var rowsSelected=new Array(); 
		
		var arrayIdTipoBurofax=new Array();
		var arrayIdEnvios=new Array();
		var arrayResultados=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdEnvios.push(rowsSelected[i].get('idEnvio'));
		  arrayIdTipoBurofax.push(rowsSelected[i].get('idTipoBurofax'));
		  arrayResultados.push(rowsSelected[i].get('resultado'));
		   
		}
		
		<%-- Comprobamos que todas las filas seleccionadas estan en estado Preparado --%>
		uniqueArrayResultados = arrayResultados.filter(function(item, pos) {
		    return arrayResultados.indexOf(item) == pos;
		});		
		
		if(uniqueArrayResultados.length == 1 && uniqueArrayResultados[0] == 'Preparado'){
		
			<%--Para saber si las filas seleccionadas tienen el mismo tipo de burofax, eliminamos los elementos duplicados del array
				entonces si todas las filas seleccionadas tienen el mismo tipo de burofax el array tendrá un tamaño=1 --%>
			uniqueArray = arrayIdTipoBurofax.filter(function(item, pos) {
			    return arrayIdTipoBurofax.indexOf(item) == pos;
			});
			
			var arrayIdEnvios = Ext.encode(arrayIdEnvios);
			
			
		    <%--Comprobamos que el tamaño del array es 1 --%>
		    if(uniqueArray.length==1){
				return true;
			}
			else {
			  	return false;
			}
		}
		else {
			 return false;
		}
	}
	
	var validarBotonPrepararHabilitado = function() {
		var rowsSelected=new Array(); 
		var arrayIdBurofax=new Array();
		var arrayIdDirecciones=new Array();
		var arrayIdEnvios=new Array();
			 
		rowsSelected=gridBurofax.getSelectionModel().getSelections(); 
			
		for (var i=0; i < rowsSelected.length; i++){
		  arrayIdBurofax.push(rowsSelected[i].get('idBurofax'));
		  if(rowsSelected[i].get('idDireccion') != ''){
		  	arrayIdDirecciones.push(rowsSelected[i].get('idDireccion'));
		  }
		  arrayIdEnvios.push(rowsSelected[i].get('idEnvio'));
		}

		<%--Comprobamos que hay direcciones seleccionadas en TODAS las selecciones --%>
     	if(myCboxSelModel.getCount() > 0 && arrayIdDirecciones.length == myCboxSelModel.getCount()){
     		return true;
	  	}
	  	else {
	  		return false;
	  	}
	}
