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

	<%-- Panel (TAB) --%>
	var panel = new Ext.Panel({
		autoHeight : true
		,title:'<s:message code="contabilidad.tab.titulo" text="**Contabilidad Cobros" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,nombreTab : 'contabilidadcobros'
	});
	
	<%-- Variables --%>
	panel.getAsuntoId = function(){ return entidad.get("data").id; }
	panel.puedeEditar = function(){ return true; }
   	panel.esSupervisor = function(){ return entidad.get("data").toolbar.esSupervisor; }
   	panel.esGestor = function(){ return entidad.get("data").toolbar.esGestor; }
	var estadoAsunto='${asunto.estadoAsunto.codigo}';
	var cobroSinNotificar = false;
	<sec:authentication var="user" property="principal" />
	var userLogado = '${user.username}';
	panel.getValue = function(){}
	panel.setValue = function(){
		var data = entidad.get("data");
		var d=data.contabilidadCobros;
		entidad.cacheOrLoad(data, contabilidadCobrosStore, { id : data.id } );
		var puedeEditar = panel.puedeEditar();
		var esVisible = [
			[btnNuevo, puedeEditar]
			,[btnEditarVer, puedeEditar]
			,[btnBorrar, puedeEditar]
		];
		entidad.setVisible(esVisible);
	}
	panel.setVisibleTab = function(data){
	//	return data.toolbar.esSupervisor || data.toolbar.esGestor;
		return true;
	}
	
	<%-- Store Modelo --%>
	var contabilidadCobros = Ext.data.Record.create([
			 {name:"id"}
			,{name:"fechaEntrega"}
			,{name:"fechaValor"}
			,{name:"tipoEntrega"}
			,{name:"conceptoEntrega"}
			,{name:"nominal"}
			,{name:"intereses"}
			,{name:"demoras"}
			,{name:"impuestos"}
			,{name:"gastosProcurador"}
			,{name:"gastosLetrado"}
			,{name:"otrosGastos"}
			,{name:"quitaNominal"}
			,{name:"quitaIntereses"}
			,{name:"quitaDemoras"}
			,{name:"quitaImpuestos"}
			,{name:"quitaGastosProcurador"}
			,{name:"quitaGastosLetrado"}
			,{name:"quitaOtrosGastos"}
			,{name:"totalEntrega"}
			,{name:"numEnlace"}
			,{name:"numMandamiento"}
			,{name:"numCheque"}
			,{name:"observaciones"}
			,{name:"asunto"}
			,{name:"operacionesTramite"}
			,{name:"usuarioCrear"}
			,{name:"quitaOperacionesEnTramite"}
			,{name:"operacionesEnTramite"}
			,{name:"totalQuita"}
	]);
	
	<%-- Store Grid --%>
	var contabilidadCobrosStore = page.getStore({
		event:'listado'
		,storeId : 'contabilidadCobrosStore'
		,flow : 'contabilidadcobros/getListadoContabilidadCobros'
		,reader : new Ext.data.JsonReader({root:'listado'}, contabilidadCobros)
	});
	
	contabilidadCobrosStore.on( 'load', function( store, records, options ) {
		<%-- Comprobar si existen cobros sin notificar --%>
		Ext.Ajax.request({
    				url: page.resolveUrl('contabilidadcobros/comprobarCobroSinNotificar')
   					,params: {id: panel.getAsuntoId()}
  					,method: 'POST'
   					,success: function (data){
	   					var result = JSON.parse(data.responseText);
	   					cobroSinNotificar = result.boolResponse;
	   					if(result.boolResponse){
	   						btnEnviarContabilidad.setDisabled(false);
	   					}else{
	   						btnEnviarContabilidad.setDisabled(true);
	   					}
   					}
   					,error : function (data){
   					}
       				,failure: function (data){
	   				}
				});
		
		<%-- Comprobar si existen cobros sin contabilizar --%>
		Ext.Ajax.request({
    				url: page.resolveUrl('contabilidadcobros/comprobarCobroSinContabilizar')
   					,params: {id: panel.getAsuntoId()}
  					,method: 'POST'
   					,success: function (data){
	   					var result = JSON.parse(data.responseText);
	   					if(result.boolResponse){
	   						btnContabilizar.setDisabled(false);
	   					}else{
	   						btnContabilizar.setDisabled(true);
	   					}
   					}
   					,error : function (data){
   					}
       				,failure: function (data){
	   				}
				});
	});  
	
	entidad.cacheStore(contabilidadCobrosStore);

	<%-- Columnas Grid --%>
	var contabilidadCobrosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="contabilidad.fechaEntrega" text="**Fecha Entrega"/>', dataIndex : 'fechaEntrega'}
		,{header : '<s:message code="contabilidad.fechaValor" text="**Fecha Valor"/>', dataIndex : 'fechaValor'}
		,{header : '<s:message code="contabilidad.tipoEntrega" text="**Tipo Entrega"/>', dataIndex : 'tipoEntrega'}
		,{header : '<s:message code="contabilidad.conceptoEntrega" text="**Concepto Entrega"/>', dataIndex : 'conceptoEntrega'}
		,{header : '<s:message code="contabilidad.nominal" text="**Nominal"/>', dataIndex : 'nominal'}
		,{header : '<s:message code="contabilidad.intereses" text="**Intereses"/>', dataIndex : 'intereses'}
		,{header : '<s:message code="contabilidad.demoras" text="**Demoras"/>', dataIndex : 'demoras'}
		,{header : '<s:message code="contabilidad.impuestos" text="**Impuestos"/>', dataIndex : 'impuestos'}
		,{header : '<s:message code="contabilidad.gastosProcurador" text="**Gastos Procurador"/>', dataIndex : 'gastosProcurador'}
		,{header : '<s:message code="contabilidad.gastosLetrado" text="**Gastos Letrado"/>', dataIndex : 'gastosLetrado'}
		,{header : '<s:message code="contabilidad.operacionesEnTramite" text="**Operaciones En Tramite"/>', dataIndex : 'operacionesEnTramite'}
		,{header : '<s:message code="contabilidad.otrosGastos" text="**Otros Gastos"/>', dataIndex : 'otrosGastos'}
		,{header : '<s:message code="contabilidad.quitaNominal" text="**Quita Nominal"/>', dataIndex : 'quitaNominal', hidden:true}
		,{header : '<s:message code="contabilidad.quitaIntereses" text="**Quita Intereses"/>', dataIndex : 'quitaIntereses', hidden:true}
		,{header : '<s:message code="contabilidad.quitaDemoras" text="**Quita Demoras"/>', dataIndex : 'quitaDemoras', hidden:true}
		,{header : '<s:message code="contabilidad.quitaImpuestos" text="**Quita Impuestos"/>', dataIndex : 'quitaImpuestos', hidden:true}
		,{header : '<s:message code="contabilidad.quitaGastosProcurador" text="**Quita Gastos Procurador"/>', dataIndex : 'quitaGastosProcurador', hidden:true}
		,{header : '<s:message code="contabilidad.quitaGastosLetrado" text="**Quita Gastos Letrado"/>', dataIndex : 'quitaGastosLetrado', hidden:true}
		,{header : '<s:message code="contabilidad.quitaOperacionesEnTramite" text="**Quita Operaciones En Tramite"/>', dataIndex : 'quitaOperacionesEnTramite', hidden:true}
		,{header : '<s:message code="contabilidad.quitaOtrosGastos" text="**Quita Otros Gastos"/>', dataIndex : 'quitaOtrosGastos', hidden:true}
		,{header : '<s:message code="contabilidad.totalQuita" text="**Total Quita"/>', dataIndex : 'totalQuita', hidden:true}
		,{header : '<s:message code="contabilidad.totalEntrega" text="**Total Entrega"/>', dataIndex : 'totalEntrega'}
		,{header : '<s:message code="contabilidad.numEnlace" text="**NºEnlace"/>', dataIndex : 'numEnlace'}
		,{header : '<s:message code="contabilidad.numMandamiento" text="**NºMandamiento"/>', dataIndex : 'numMandamiento'}
		,{header : '<s:message code="contabilidad.numCheque" text="**NºCheque"/>', dataIndex : 'numCheque'}
		,{header : '<s:message code="contabilidad.observaciones" text="**Observaciones"/>', dataIndex : 'observaciones', hidden:true}
		,{hidden:true, dataIndex : 'usuarioCrear'}
	]);
	 
	 <%-- Botones Grid --%>
	var btnNuevo = new Ext.Button({
		 text: '<s:message code="app.agregar" text="**Agregar" />'
		 ,iconCls : 'icon_mas'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var w = app.openWindow({
					flow : 'contabilidadcobros/showNewContabilidadCobro'
					,width:700
					,title : '<s:message code="contabilidad.alta" text="**Alta Contabilidad Cobro" />' 
					,params : {idAsunto: panel.getAsuntoId()}
				});
				w.on(app.event.DONE, function(){
					w.close();
					contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var btnEditarVer = new Ext.Button({
		 text: '<s:message code="app.ver_editar" text="**Ver/Editar" />'
		 ,iconCls : 'icon_edit'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var rec =  contabilidadCobrosGrid.getSelectionModel().getSelected();
				if (!rec) return;
				var usuCrear = rec.get("usuarioCrear");
				var id = rec.get("id");<%-- TODO: enviar el usuCrear y/o Supervisor u obtenerlo desde esta jsp padre y crear func para poner todos los campos a 'readOnly(true)' si no es de los usus anteriores. --%>
				var editable = false;
				if(usuCrear === userLogado || panel.esSupervisor()){
					<%-- Si el usuario actual es quien lo ha creado o es el supervisor del asunto--%>
					editable = true;
				} else {
					<%-- Si el usuario actual NO es quien lo ha creado o NO es el supervisor del asunto --%>
					editable = false;
				}
				var parametros = {
						asunto: panel.getAsuntoId()
						,id: id
						,puedeEditar: editable
				};
				var w;
				if(editable){
					w = app.openWindow({
						flow : 'contabilidadcobros/showEditContabilidadCobro'
						,width:700
						,title : '<s:message code="contabilidad.edicion" text="**Editar Contabilidad Cobro" />'
						,params : parametros
					});
				}else{
					w = app.openWindow({
						flow : 'contabilidadcobros/showEditContabilidadCobro'
						,width:700
						,title : '<s:message code="contabilidad.ver" text="**Ver Contabilidad Cobro" />'
						,params : parametros
					});
				}
				w.on(app.event.DONE, function(){
					w.close();
					contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});
	<%-- Por defecto desahabilitado hasta que se selecciona elemento del grid --%>
	btnEditarVer.setDisabled(true);
	
	var btnBorrar = app.crearBotonBorrar({
		text : '<s:message code="app.borrar" text="**Borrar" />'
		,flow : 'contabilidadcobros/deleteContabilidadCobro'
		,success : function(){
			contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
		}
		,page : page
	});
	<%-- Por defecto desahabilitado hasta que se selecciona elemento del grid --%>
	btnBorrar.setDisabled(true);
	
	var btnEnviarContabilidad = new Ext.Button({
		 text: '<s:message code="contabilidad.enviarContabilidad" text="**Enviar a contabilidad" />'
		 ,iconCls : 'icon_asuntos'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var parametros = {
						idEntidad: panel.getAsuntoId()
				};
				Ext.Ajax.request({
    				url: page.resolveUrl('contabilidadcobros/crearNuevaTarea')
   					,params: parametros
  					,method: 'POST'
   					,success: function (data){
	   					var result = JSON.parse(data.responseText);
   						if(result.msgOK == true){
   							Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaInfoTitle" text="**Información" />', result.message);
   							
   						} else {
   							Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaErrorTitle" text="**Error" />', result.message);
   						}
   						btnEnviarContabilidad.setDisabled(true);
   						cobroSinNotificar = false;
   					}
   					,error : function (data){
   						Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaErrorTitle" text="**Error" />', '<s:message code="contabilidad.msgNuevaTareaError" text="**No se ha podido generar una nueva tarea para el gestor de contabilidad" />');
	   				}
       				,failure: function (data){
       					Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaErrorTitle" text="**Error" />', '<s:message code="contabilidad.msgNuevaTareaError" text="**No se ha podido generar una nueva tarea para el gestor de contabilidad" />');
	   				}
				});
		}
	});
	
	var btnContabilizar = new Ext.Button({
		 text: '<s:message code="contabilidad.contabilizarCobros" text="**Contabilizar Cobros" />'
		 ,iconCls : 'icon_asuntos'
		 ,cls: 'x-btn-text-icon'
		 ,handler:function(){
				var parametros = {
						asunto: panel.getAsuntoId()
				};
				Ext.Ajax.request({
    				url: page.resolveUrl('contabilidadcobros/contabilizarCobros')
   					,params: parametros
  					,method: 'POST'
   					,success: function (data){
	   					var result = JSON.parse(data.responseText);
   						if(result.msgOK == true){
   							Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaInfoTitle" text="**Información" />', result.message);
   							contabilidadCobrosStore.webflow({id:panel.getAsuntoId()});
   						} else {
   							Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaErrorTitle" text="**Error" />', result.message);
	   					}
   					}
   					,error : function (data){
   						Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaErrorTitle" text="**Error" />', '<s:message code="contabilidad.msgcontabilizarCobrosError" text="**No se ha podido marcar los cobros como contabilizados" />');
	   				}
       				,failure: function (data){
       					Ext.MessageBox.alert('<s:message code="contabilidad.msgNuevaTareaErrorTitle" text="**Error" />', '<s:message code="contabilidad.msgcontabilizarCobrosError" text="**No se ha podido marcar los cobros como contabilizados" />');
	   				}
				});
		}
	});
	
	<%-- Por defecto desahabilitado hasta que se selecciona elemento del grid --%>
	btnEnviarContabilidad.setDisabled(true);

	<%-- Grid --%>
	var contabilidadCobrosGrid = app.crearGrid(contabilidadCobrosStore,contabilidadCobrosCm,{
		title:'<s:message code="contabilidad.grid.titulo" text="**Contabilidad Cobros" />'
		,height : 420
		,style:'padding-right:10px'
		,width: '100%'
		,autoScroll: true
		,minColumnWidth: 200
		,bbar:[btnEditarVer
			<sec:authorize ifAllGranted="ROLE_PUEDE_VER_BOTONES_GRID_CONTABILIDAD_COBRO">,btnNuevo,btnBorrar
			<sec:authorize ifAllGranted="ROLE_PUEDE_VER_BOTON_ENVIAR_CONTABILIDAD_COBRO">,btnEnviarContabilidad</sec:authorize>
			</sec:authorize>
			
			<sec:authorize ifNotGranted="ROLE_PUEDE_VER_BOTONES_GRID_CONTABILIDAD_COBRO">
			<sec:authorize ifAllGranted="ROLE_PUEDE_VER_BOTON_ENVIAR_CONTABILIDAD_COBRO">,btnEnviarContabilidad,btnContabilizar</sec:authorize>
			</sec:authorize>
			
			<sec:authorize ifAllGranted="ROLE_PUEDE_VER_BOTON_CONTABILIZAR_COBROS">,btnContabilizar</sec:authorize>
		]
	});
	  
	contabilidadCobrosGrid.on('rowclick',function(grid, rowIndex, e){
		<%-- Comprobar usuario --%>
		var usuCrear = grid.getSelectionModel().getSelected().get("usuarioCrear");
		
		if(usuCrear === userLogado || panel.esSupervisor()){
			<%-- Si el usuario actual es quien lo ha creado o es el supervisor del asunto--%>
			btnBorrar.setDisabled(false);
		} else {
			<%-- Si el usuario actual NO es quien lo ha creado o NO es el supervisor del asunto --%>
			btnBorrar.setDisabled(true);
		}
		<%-- Habilitar siempre el boton de 'Ver / Editar' al seleccionar un cobro --%>
		btnEditarVer.setDisabled(false);
		<%-- Habilitar el boton de 'Enviar a Contabilidad' solo si existen tareas no enviadas --%>
		if(cobroSinNotificar){
			btnEnviarContabilidad.setDisabled(false);
		}
	});
	
	panel.add(contabilidadCobrosGrid);
  
	return panel;
})
