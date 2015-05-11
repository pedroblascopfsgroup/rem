<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	<%@ include file="../main/comunicaciones.jsp" %>	

	var codigoTipoTarea="${codigoTipoTarea}";
	var esAlerta="${alerta}";
	var enEspera="${espera}";
	var limit = 25;
	var isBusqueda='${isBusqueda}';
	var noGrouping='${noGrouping}';
	
	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			maskPanel=new Ext.LoadMask(mainPanel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
		}
		maskPanel.show();
		
	};
	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
		
	};
	
	var paramsBusquedaInicial={
				codigoTipoTarea:codigoTipoTarea
				,start:0
				,limit:limit
				,perfilUsuario:perfilUsuario
				,enEspera:enEspera
				,esAlerta:esAlerta
				,busqueda:isBusqueda
				,fechaVencimientoDesde:'${fechaVencDesde}'
				,fechaVencDesdeOperador:'${fechaVencDesdeOp}'
				,fechaVencimientoHasta:'${fechaVencHasta}'
				,fechaVencimientoHastaOperador:'${fechaVencHastaOp}'
				
				,fechaInicioDesde:'${fechaInicioDesde}'
				,fechaInicioDesdeOperador:'${fechaInicioDesdeOp}'
				,fechaInicioHasta:'${fechaInicioHasta}'
				,fechaInicioHastaOperador:'${fechaInicioHastaOp}'
				,traerGestionVencidos:'${traerGestionVencidos}'
				
			};
	
	//Fitros	
	var comboFechaDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		//,labelSeparator:""
		,fieldLabel:'<s:message code="tareas.filtros.desde" text="**Venc Desde" />'
		,width:40
		,value:'${fechaVencDesdeOp}'
	})
	comboFechaDesdeOp.on('select',function(){
			var val = comboFechaDesdeOp.getValue();
			if(val == "=" || val == "<>"){
				comboFechaHastaOp.disable();
				fechaVencHasta.disable();
				fechaVencHasta.reset();
				comboFechaHastaOp.reset();
			}else{
				comboFechaHastaOp.enable();
				fechaVencHasta.enable();
			}	
		});
	var fechaVencDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaVencDesde'
		,fieldLabel:'<s:message code="tareas.filtros.fvencimiento" text="**F. Vencimiento" />'
		,value:'${fechaVencDesde}'
	});
	var comboFechaHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="tareas.filtros.hasta" text="**Venc hasta" />'
		,width:40
		,value:'${fechaVencHastaOp}'
		
	})
	var fechaVencHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaVencHasta'
		,height:20
		,fieldLabel:'<s:message code="tareas.filtros.fvencimiento" text="**F. Vencimiento" />'
		,value:'${fechaVencHasta}'
	});
	var cfg={style:'padding:5px'}
	var panelFechasVenc=new Ext.form.FieldSet({
		//title:'<s:message code="tareas.filtros.panelfechasvenc" text="**Vechas Vencimiento" />'
		border:false
		,autoHeight:true
		,items:[{
				layout:'table'
				//,style:'padding:5px'
				,border:false
				,layoutConfig:{
					columns:4
				}
				,defaults:{xtype:'fieldset',border:false,autoHeight:true}
				,items:[
					{items:comboFechaDesdeOp,width:80}
					,{items:fechaVencDesde,width:150}
					,{items:comboFechaHastaOp,width:80}
					,{items:fechaVencHasta,width:150}
				]
			}
		]
		
	})
	var descTarea=new Ext.form.TextField({
		fieldLabel:'<s:message code="tareas.filtros.descripciontarea" text="**Descripcion Tarea" />'
		
	});
	var nombreTarea=new Ext.form.TextField({
		fieldLabel:'<s:message code="tareas.filtros.nombretarea" text="**Nombre Tarea" />'
		
	});
	
	
	//Panel fechas inicio tareas, por ahora oculto
	var panelFechasInicioTareas=app.crearRangoFechasPanel({
		fechaDesdeValue:'${fechaInicioDesde}'
		,desdeOperadorValue:'${fechaInicioDesdeOp}'
		,fechaHastaValue:'${fechaInicioHasta}'
		,hastaOperadorValue:'${fechaInicioHastaOp}'
	});
	
	var validarForm=function(){
		if(descTarea.getValue()!='')
			return true;
		if(nombreTarea.getValue()!='')
			return true;
		if(fechaVencDesde.getValue()!='' && comboFechaDesdeOp.getValue()!='')
			return true;
		if(fechaVencHasta.getValue()!='' && comboFechaHastaOp.getValue()!='')
			return true;
				
	}
	var validaFechasVenc=function(){
		var valid=true;
		if(fechaVencDesde.getValue()!='' && fechaVencHasta.getValue()!=''){
			valid = (fechaVencDesde.getValue()< fechaVencHasta.getValue())
		}
		if(comboFechaDesdeOp.getValue()=='>=' || comboFechaDesdeOp.getValue()=='>'){
			if (fechaVencHasta.getValue()!='' && comboFechaHastaOp.getValue()!='') 
				if(fechaVencDesde.getValue()=='')
					valid = valid && false;
				else
					valid = valid && true;
		}
		return valid;
	}
	var getParametrosBusqueda=function(){
		return {
					codigoTipoTarea:codigoTipoTarea
					,perfilUsuario:perfilUsuario
					,enEspera:enEspera
					,esAlerta:esAlerta
					,limit:limit
					,busqueda:true
					,start:0
					//Filtros fecha vencimiento					
					,fechaVencimientoDesde:app.format.dateRenderer(fechaVencDesde.getValue())
					,fechaVencDesdeOperador:comboFechaDesdeOp.getValue()
					,fechaVencimientoHasta:app.format.dateRenderer(fechaVencHasta.getValue())
					,fechaVencimientoHastaOperador:comboFechaHastaOp.getValue()
					
					//filtros fecha inicio
					,fechaInicioDesde:app.format.dateRenderer(panelFechasInicioTareas.fechaDesde.getValue())
					,fechaInicioDesdeOperador:panelFechasInicioTareas.comboFechaDesdeOp.getValue()
					,fechaInicioHasta:app.format.dateRenderer(panelFechasInicioTareas.fechaHasta.getValue())
					,fechaInicioHastaOperador:panelFechasInicioTareas.comboFechaHastaOp.getValue()
					
					,nombreTarea:nombreTarea.getValue()
					,descripcionTarea:descTarea.getValue()
				}
	}
	var buscarFunc=function(){
		//Ext.Msg.alert('form',panelFiltros.getForm().getValues().fechaVencHasta);
		if(validarForm() || panelFechasInicioTareas.validate()){
			if(validaFechasVenc()){
				isBusqueda=true;
				panelFiltros.collapse(true);
				tareasStore.webflow(getParametrosBusqueda());
				tareasGrid.setTitle('${titulo}');
				
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="tareas.filtros.errores.fechasvenc" text="** La fecha desde debe ser menor a la fecha Hasta"/>')
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		}
		
			
	}
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
		
	});
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			panelFiltros.getForm().reset()
			tareasStore.webflow(paramsBusquedaInicial);
		}
	});
	var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
			if(validarForm()|| panelFechasInicioTareas.validate()){
				if(validaFechasVenc()){
				var flow='tareas/listadoTareasExcelData';
                    var params ;
					if(isBusqueda)
						params = getParametrosBusqueda();
					else
						params = paramsBusquedaInicial;
                    params.REPORT_NAME='listado_tareas.xls';
                    app.openBrowserWindow(flow,params);
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="tareas.filtros.errores.fechasvenc" text="** La fecha desde debe ser menor a la fecha Hasta"/>')
				}
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
			}
                    
           }
        }
    );
	var btnAyuda = app.crearBotonAyuda();
	
	var panelFiltros=new Ext.form.FormPanel({
		title:'<s:message code="tareas.listado.busqueda" text="**Busqueda de Tareas"/>'
		,collapsible:true
		,collapsed:true
		,autoWidth:true
		,style:'padding-right:10px;padding-bottom: 10px'
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,autoHeight:true
		,defaults : {xtype:'panel', border : false ,autoHeight:true}
		,items:[{
				layout:'table'
				,style:'padding:5px'
				,layoutConfig:{
					columns:3
				}
				,defaults:{xtype:'fieldset',border:false,labelAlign:'top',cellCls:'vtop',height:80}
				,items:[
					{
						xtype:'fieldset'
						,border:false
						,layout:'table'
						,layoutConfig:{columns:2}
						,defaults:{xtype:'fieldset',border:false,labelAlign:'top',cellCls:'vtop',autoHeight:true}
						,items:[{
							items: nombreTarea
						},{
							items: descTarea
						}]
					}
					//,{items: descTarea}
					,{items:panelFechasVenc}
				]
			}
		]
		,tbar:[btnBuscar,btnClean,btnExportarXls,'->',btnAyuda]
	})
	
	// -- End Filtros
	
	var tarea = Ext.data.Record.create([
		{name:'subtipo'}
		,{name:'fechaInicio',type:'date', dateFormat:'d/m/Y'}
		,{name:'id'}
		,{name:'descripcion'}
		,{name:'codentidad'}
		,{name:'plazo'}
		,{name:'entidadInformacion'}
		,{name:'gestor'}
		,{name:'tipoTarea'}
		,{name:'idEntidad'}		
		,{name:'codigoSubtipoTarea'}
		,{name:'codigoEntidadInformacion'}
		,{name:'codigoSituacion'}
		,{name:'fcreacionEntidad'}
		,{name:'fechaVenc',type:'date', dateFormat:'d/m/Y'}
		,{name:'idTareaAsociada'}
		,{name:'descripcionTareaAsociada'}
		,{name:'tipoSolicitud'}
		,{name:'emisor'}
		,{name:'supervisor'}
		,{name:'diasVencido'}
		,{name:'descripcionExpediente'}
		,{name:'descripcionTarea'}
		,{name:'gestorId'}
		,{name:'supervisorId'}
		,{name:'idEntidadPersona'}
		,{name:'volumenRiesgo'}
		,{name:'volumenRiesgoVencido'}
		,{name:'group'}
		,{name:'itinerario'}
	]);
	
	var tareasStore = page.getGroupingStore({
		eventName : 'listado'
		,limit: limit
		,flow:'tareas/listadoTareasBusqueda'
		,sortInfo:{field: 'fechaVenc', direction: "ASC"}
		,groupField:'group'
		,remoteSort : true
		,baseParams:paramsBusquedaInicial
		,groupOnSort:'true'
		,reader: new Ext.data.JsonReader({
	    	root : 'tareas'
	    	,totalProperty : 'total'
	    }, tarea)
	});
	
	tareasStore.addListener('load', agrupa);
	tareasStore.setDefaultSort('fechaVenc', 'ASC');
	function agrupa(store, meta) {
		if (!('${noGrouping}'=='true')) {
			store.groupBy('group', true);
		}		
		tareasStore.removeListener('load', agrupa);
    };
	
	var perfilUsuario;
	//Hace la búsqueda inicial
	tareasStore.webflow(paramsBusquedaInicial);
	
	
	
	var alertasRenderer = function(value){
		var idx = parseInt(value);
		var iconos = [0,'alerta.gif', 'notificacion.gif'];
		return "<img src='/${appProperties.appName}/css/" +iconos[idx] + "' />";
	};
	//Se quita por ahora, quizas mas adelante se vuelva a agregar
	/*var btnSolProrroga = new Ext.Button({
		text:'Solicitar prorroga'
		,iconCls:'icon_sol_prorroga'
		,disabled:true
		,handler:function(){
			
		}
	});
	
	var btnComunicacion = new Ext.Button({
		text:'enviar comunicacion'
		,iconCls:'icon_comunicacion'
		,disabled:true
		,handler:function(){
			
		}
	});*/
	var groupRenderer=function(val){
		if(val==0)
			return '<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />';
		if(val==1)
			return '<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" />';
		if(val==2)
			return '<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" />';
		if(val==3)
			return '<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" />';
		if(val==4)
			return '<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" /> ';
		if(val==5)
			return '<s:message code="main.arbol_tareas.groups.mesesanteriores" text="**meses Anteriores" /> ';
	}
	var tareasNewCm=new Ext.grid.ColumnModel([
		{	/*Columna 0*/ header: '<s:message code="tareas.listado.tarea" text="**Tarea"/>', sortable: true, dataIndex: 'descripcionTarea'}
		,{	/*Columna 1*/ header: '<s:message code="tareas.listado.entidadinformacion" text="**Entidad Informacion"/>', sortable: false, hidden:true, dataIndex: 'entidadInformacion'}
		,{	/*Columna 2*/ header: '<s:message code="tareas.listado.descripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion'}
		,{	/*Columna 3*/ header: '<s:message code="tareas.listado.itinerario" text="**Itinerario"/>', sortable: false, dataIndex: 'itinerario'}
		,{	/*Columna 4*/ header: '<s:message code="tareas.listado.fechainicio" text="**Fecha inicio"/>', sortable: true, hidden:true, dataIndex: 'fechaInicio', renderer:app.format.dateRenderer, width:50}
		,{	/*Columna 5*/ header: '<s:message code="tareas.listado.fechavenc" text="**Fecha Vto."/>', sortable: true, dataIndex: 'fechaVenc', renderer:app.format.dateRenderer, width:50}
		,{	/*Columna 6*/ header: '<s:message code="tareas.listado.tiposolicitud" text="**Tipo solicitud"/>',sortable: false, dataIndex: 'tipoSolicitud', width:75}
		,{  /*Columna 7*/ header: '<s:message code="tareas.listado.diasvencida" text="**Dias Vencida"/>', sortable: false, dataIndex: 'diasVencido', width:50}
		,{  /*Columna 8*/ header: '<s:message code="tareas.listado.gestor" text="**Gestor"/>', sortable: false, dataIndex: 'gestor', hidden:true}
		,{  /*Columna 9*/ header: '<s:message code="tareas.listado.supervisor" text="**Supervisor"/>', sortable: false, dataIndex: 'supervisor', hidden:true}
		,{  /*Columna 10*/ header: '<s:message code="tareas.listado.emisor" text="**Emisor"/>', sortable: true, dataIndex: 'emisor', width:50}		
		,{  /*Columna 11*/ header: '<s:message code="tareas.listado.id" text="**Id"/>', sortable: true, hidden:true ,dataIndex: 'id'}
		,{  /*Columna 12*/ header: '<s:message code="tareas.listado.volumenRiesgo" text="**VR"/>',	sortable: false, dataIndex: 'volumenRiesgo', hidden:true,renderer:app.format.moneyRendererNull,align:'right'}
		,{  /*Columna 13*/ header: '<s:message code="tareas.listado.volumenRiesgoVencido" text="**VRV"/>', sortable: false, dataIndex: 'volumenRiesgoVencido', hidden:true,renderer:app.format.moneyRendererNull,align:'right'}
		,{  /*Columna 14*/ header: '<s:message code="tareas.listado.vencimiento" text="**vencimiento"/>', 	sortable: false, dataIndex: 'group', hidden:true,renderer:groupRenderer}
	]);
	
	/**
	 * funcion para pasarle parametros al handler del boton de aceptar/rechazar cancelacion
	 * @param {Object} idExpediente el id del expediente
	 * @param {Object} decision true acepta la cancelacion, false rechaza la cancelacion
	 */
	var handlerRechazarAceptarCancelacion=function(idExpediente,decision){
		maskAll();
		page.webflow({
					flow:'expedientes/enviarDecisionSolicitudCancelacion'
					,eventName : 'update'
					,params: {idExpediente:idExpediente,decision:decision}
					,success : function(){
						unmaskAll(); 
						var msg;
						if(decision)
							msg='<s:message code="expedientes.solicitudCancelacion.aceptada" text="**Solicitud Aceptada" />';
						else
							msg='<s:message code="expedientes.solicitudCancelacion.rechazada" text="**Solicitud Rechazada" />';
						Ext.Msg.show({
							title:'<s:message code="app.aviso" text="**Aviso" />',
							   msg: msg,
							   buttons: Ext.Msg.OK,
							   //fn: _cerrarTab,
							   icon: Ext.MessageBox.INFO
						});
						btnQuickAceptarCancelacion.setVisible(false);
						btnQuickRechazarCancelacion.setVisible(false);
						tareasStore.webflow(paramsBusquedaInicial);
					}
					,error:function(){
						unmaskAll();
					}
			
				});
	}
	var btnQuickAceptarCancelacion=new Ext.Button({
		text:'<s:message code="expedientes.solicitudCancelacion.acepta" text="**Acepta Cancelacion" />'
		,iconCls:'icon_ok'
		,hidden:true
	});
	var btnQuickRechazarCancelacion=new Ext.Button({
		text:'<s:message code="expedientes.solicitudCancelacion.rechaza" text="**Rechazar Cancelación" />'
		,iconCls:'icon_cancel'
		,hidden:true
	});
	/**
	 * funcion para pasarle parametros al handler del boton de aceptar/rechazar prorroga
	 * @param {Object} acepta true o false (aceptada o rechazada)
	 * @param {Object} params los parametros que se le pasaran al flow
	 */
	var handlerProrroga=function(acepta,params){
		{
			params.aceptada=acepta;
			//Si está aceptada, el codigo de respuesta será 7, sino 10
			if(acepta){
				params.descripcionCausa='<s:message code="expedientes.menu.prorrogaaceptada" text="**Prórroga Aceptada" />';
				params.codigoRespuesta='7';
			}else{
				params.descripcionCausa='<s:message code="expedientes.menu.prorrogarechazada" text="**Prórroga Rechazada" />';
				params.codigoRespuesta='10';
			}
			maskAll();
			page.webflow({
				flow:  'tareas/rechazarAceptarProrroga'
				,eventName: 'decisionProrroga'
				,params:params
				,success: function(){
					unmaskAll();
					var msg;
					if(acepta)
						msg='<s:message code="expedientes.menu.prorrogaaceptada" text="**Prórroga Aceptada" />';
					else
						msg='<s:message code="expedientes.menu.prorrogarechazada" text="**Prórroga Rechazada" />';
					Ext.Msg.show({
						title:'<s:message code="app.aviso" text="**Aviso" />',
						   msg: msg,
						   buttons: Ext.Msg.OK,
						   //fn: _cerrarTab,
						   icon: Ext.MessageBox.INFO
					});
					btnQuickRechazarProrroga.setVisible(false);
					btnQuickAceptarProrroga.setVisible(false);
					tareasStore.webflow(paramsBusquedaInicial);
				},error:function(){
						unmaskAll();
						
				}	 
			});
			
		}
	}
	var btnQuickAceptarProrroga=new Ext.Button({
		text:'<s:message code="decisionprorroga.acepta" text="**Acepta Prórroga" />'
		,iconCls:'icon_ok'
		,hidden:true
	});
	var btnQuickRechazarProrroga=new Ext.Button({
		text:'<s:message code="expedientes.menu.rechazarprorroga" text="**Rechazar Prórroga" />'
		,iconCls:'icon_cancel'
		,hidden:true
	});
	
	var pagingBar=fwk.ux.getPaging(tareasStore);
	var tituloGrid = '${titulo}' 
	if('${tituloAdicionalGrid}'!= null && '${tituloAdicionalGrid}'!="")
		tituloGrid = tituloGrid + ' - [${tituloAdicionalGrid}]';
		var cfg = {	
				title:tituloGrid
				<app:test id="tareasGrid" addComa="true" />
				,style:'padding-right:10px'
				,bbar : [  pagingBar ,'-',btnQuickAceptarCancelacion,btnQuickRechazarCancelacion,btnQuickAceptarProrroga,btnQuickRechazarProrroga]
				,iconCls : '${icon}'
				,cls:'cursor_pointer'
			    ,height: 400
				,view: new Ext.grid.GroupingView({
		            forceFit:true
		            ,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
					//,enableNoGroups:true
		        })


			};
	var tareasGrid = app.crearGrid(tareasStore,tareasNewCm,cfg);
	
    tareasGrid.getView().getRowClass = function(record, index){
		return (record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO
			|| record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO 
			|| record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_VENCIDOS) ? "marked_row" : ""; 
	};

	tareasGrid.on('rowclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		
		if(!permisosVisibilidadGestorSupervisor(rec.get('supervisorId')) //no es supervisor de la tarea
			&&	!(!(eval(enEspera) || ("${codigoTipoTarea}" == "3"))) 	//no es listado de tareas
			){
			//los botones de acciones rapidas son solo para el supervisor de la tarea, 
			//en caso contrario no hay nada que hacer aqui
			//ocultamos todos los botones
			btnQuickAceptarCancelacion.setVisible(false);
			btnQuickRechazarCancelacion.setVisible(false);
			btnQuickRechazarProrroga.setVisible(false);
			btnQuickAceptarProrroga.setVisible(false);
			return;
		}
		
		//alert(codigoSubtipoTarea+'-'+ app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE);
		switch(codigoSubtipoTarea){
			case app.subtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR:
				var idExpediente=rec.get('idEntidad')
				
				//decision:decision.getValue(), idExpediente:${expediente.id} ,idSolicitud:${solicitud.id}
				
				
				btnQuickAceptarCancelacion.setHandler(function(){
					handlerRechazarAceptarCancelacion(idExpediente,true);
				});
				btnQuickRechazarCancelacion.setHandler(function(){
					handlerRechazarAceptarCancelacion(idExpediente,false);
				});
				btnQuickRechazarProrroga.setVisible(false);
				btnQuickAceptarProrroga.setVisible(false);
				btnQuickAceptarCancelacion.setVisible(true);
				btnQuickRechazarCancelacion.setVisible(true);
				break;
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE:	
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC:
				var params={
					idTipoEntidadInformacion:rec.get('codigoEntidadInformacion')
					,idEntidadInformacion:rec.get('idEntidad')
					,idTareaOriginal: rec.get('id')
					,idTareaAsociada:rec.get('idTareaAsociada') 
				};
				//var paramsAceptar=params;
				//paramsAceptar.codigoRespuesta='1';
				//var paramsRechazar=params;
				//paramsRechazar.codigoRespuesta='4';
				btnQuickAceptarProrroga.setHandler(function(){
					handlerProrroga(true, params)
				});
				btnQuickRechazarProrroga.setHandler(function(){
					handlerProrroga(false, params)
				});
				btnQuickAceptarCancelacion.setVisible(false);
				btnQuickRechazarCancelacion.setVisible(false);
				btnQuickRechazarProrroga.setVisible(true);
				btnQuickAceptarProrroga.setVisible(true);
				break;
			default:
				btnQuickAceptarCancelacion.setVisible(false);
				btnQuickRechazarCancelacion.setVisible(false);
				btnQuickRechazarProrroga.setVisible(false);
				btnQuickAceptarProrroga.setVisible(false);
				break;
			
		}
		
	});
	tareasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		//agregar funcionalidad....
    	var rec = grid.getStore().getAt(rowIndex);
		
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR && permisosVisibilidadGestorSupervisor(rec.get('gestorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR;
		}
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR && permisosVisibilidadGestorSupervisor(rec.get('supervisorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR;
		}
		
		switch (codigoSubtipoTarea){
			case app.subtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE:
			case app.subtipoTarea.CODIGO_REVISAR_EXPEDIENE:
			case app.subtipoTarea.CODIGO_DECISION_COMITE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC:
				app.abreExpediente(rec.get('idEntidad'), rec.get('descripcionExpediente'));
			break;
			case app.subtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL:
            case app.subtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO:
				app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
			break;
			case app.subtipoTarea.CODIGO_GESTION_VENCIDOS:
				app.openTab("<s:message code="tareas.gv" text="**Gesti&oacute;n de Vencidos"/>", "clientes/listadoClientes", {gv:true,gsis:false,gsin:false},{id:'GV',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO:
				app.openTab("<s:message code="tareas.gsis" text="**Gesti&oacute;n de Seguimiento Sistem&aacute;tico"/>", "clientes/listadoClientes", {gv:false,gsis:true,gsin:false},{id:'GSIN',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO:
				app.openTab("<s:message code="tareas.gsin" text="**Gesti&oacute;n de Seguimiento Sintom&aacute;tico"/>", "clientes/listadoClientes", {gv:false,gsis:false,gsin:true},{id:'GSIS',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR:
				 var w = app.openWindow({
						flow : 'tareas/generarNotificacion'
						,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
						,width:650 
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get('descripcionTarea')
								,fecha: rec.get('fcreacionEntidad')
								,situacion: rec.get('codigoSituacion')
								,idTareaAsociada: rec.get('id')
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.OPEN_ENTITY, function(){
						w.close();
						if (rec.get('codigoEntidadInformacion') == '1'){
							app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '2'){
							app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
						}		
						if (rec.get('codigoEntidadInformacion') == '3'){
							app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '5'){
							app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
						}				
					});
			break;
            case app.subtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO:
                var w = app.openWindow({
                        flow : 'clientes/decisionTelecobro'
                        ,title : '<s:message code="clientes.menu.aceptarRechazarExclusion" text="**Aceptar/Rechazar Exclusion Recobro" />'
                        ,width:400 
                        ,params : {
                                idEntidad: rec.get('idEntidad')
                                ,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
                                ,descripcion: rec.get('descripcionTarea')
                                ,fecha: rec.get('fcreacionEntidad')
                                ,situacion: rec.get('codigoSituacion')
                                ,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
                                ,idTareaAsociada: rec.get('idTareaAsociada')
                                ,idTarea:rec.get('id')
                                ,enEspera:${espera}
                        }
                    });
                    w.on(app.event.DONE, function(){w.close();});
                    w.on(app.event.CANCEL, function(){ w.close(); });
                    w.on(app.event.OPEN_ENTITY, function(){
                        w.close();
                        app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));             
                    });
            break; 
            case app.subtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO:    
                var w = app.openWindow({
                        flow : 'clientes/consultaDecisionTelecobro'
                        ,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
                        ,width:400 
                        ,params : {
                                idEntidad: rec.get('idEntidad')
                                ,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
                                ,descripcion: rec.get('descripcionTarea')
                                ,fecha: rec.get('fcreacionEntidad')
                                ,situacion: rec.get('codigoSituacion')
                                ,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
                                ,idTareaAsociada: rec.get('idTareaAsociada')
                                ,idTarea:rec.get('id')
                        }
                    });
                    w.on(app.event.DONE, function(){
						w.close();
						//Recargamos el flow
                    	tareasStore.webflow(paramsBusquedaInicial);
                    });
                    w.on(app.event.CANCEL, function(){ w.close(); });
                    w.on(app.event.OPEN_ENTITY, function(){
                        w.close();
                        app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));             
                    });
            break; 
            case app.subtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR:
				var w = app.openWindow({
					flow : 'expedientes/decisionSolicitudCancelacionConTarea'
					,eventName: 'tarea'
					,title : '<s:message code="expedientes.consulta.solicitarcancelacion" text="**Solicitar cancelacion" />'
					,params : {idExpediente:rec.get('idEntidad'), idTarea:rec.get('id'), espera:${espera}}
				});
			
				w.on(app.event.DONE, function(){
								w.close();
								tareasStore.webflow(paramsBusquedaInicial);
							 }	 
				);
				w.on(app.event.CANCEL, function(){ w.close(); });
			break;
			case app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR:
			case app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_ASUNTO_PROPUESTO:
				app.abreAsuntoTab(rec.get('idEntidad'), rec.get('descripcion'),'aceptacionAsunto');
			break;
			case app.subtipoTarea.CODIGO_ACUERDO_PROPUESTO:
			case app.subtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO:
				app.abreAsuntoTab(rec.get('idEntidad'), rec.get('descripcion'),'acuerdos');
			break;
			case app.subtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'docRequerida');
			break;
			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR:
			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
			break;
			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR:
			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR: 
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'recursos');
			break;
			case app.subtipoTarea.CODIGO_TOMA_DECISION_BPM:
			case app.subtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO:
			//case app.subtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'decision');
			break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarTareaObjetivo'
                    ,width: 900
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idObjetivo:idObjetivo
					          ,aceptarBorrar:'borrar'
					          ,checkBoxTexto:'<s:message code="objetivo.aceptarPropuestaBorrado"
                                                         text="**Permito el borrado del objetivo" />'}
                });
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarTareaObjetivo'
                    ,width: 900
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idObjetivo:idObjetivo
					          ,aceptarBorrar:'aceptar'
					          ,checkBoxTexto:'<s:message code="objetivo.aceptarPropuesta"
                                                         text="**Permito la propuesta del objetivo" />'}
                });
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarPropuestaCumplimiento'
                    ,width: 900
                    ,title: '<s:message code="objetivos.propuestaCumplimiento.titulo" text="**Propuesta Cumplimiento" />'
                    ,params: {idObjetivo:idObjetivo}
                });
            
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
			// Por default abre una notificacion standard
			default:
				var w = app.openWindow({
						flow : 'tareas/consultaNotificacion'
						,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
						,width:400 
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get('descripcionTarea')
								,fecha: rec.get('fcreacionEntidad')
								,situacion: rec.get('codigoSituacion')
								,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
								,idTareaAsociada: rec.get('idTareaAsociada')
								,idTarea:rec.get('id')
                                ,tipoTarea:rec.get('tipoTarea')
						}
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.DONE, function(){ 
                            w.close();
                            tareasStore.webflow(paramsBusquedaInicial); 
							//Recargamos el arbol de tareas
							app.recargaTree();
                    });
					w.on(app.event.OPEN_ENTITY, function(){
						w.close();
						if (rec.get('codigoEntidadInformacion') == '1'){
							app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '2'){
							app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
						}	
						if (rec.get('codigoEntidadInformacion') == '3'){
							app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '5'){
							app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
						}			
                        if (rec.get('codigoEntidadInformacion') == '7'){
                            app.abreClienteTab(rec.get('idEntidadPersona'), rec.get('descripcion'),'politicaPanel');
                        }	
					});
			break;
		}
		
		//var tipoTarea = rec.get('tipoTarea');
		
		/*if (tipoTarea == "3"){
			var idTarea = rec.get('id');
			//Tipo tarea notificacion, poner tarea como finalizada
			page.webflow({
				flow:'tareas/finalizarNotificacion'
				,method : 'POST'
				,params:{idTarea:idTarea}
			});
		}*/
    });

	tareasGrid.on('click', function(grid, rowIndex, e) {
		//agregar funcionalidad..
    	//btnComunicacion.setDisabled(false);
    	//btnSolProrroga.setDisabled(false);
    	
    });
	
	if(eval(esAlerta)){
		//muestro la columna diasvencida
		tareasNewCm.setHidden(7,false);
		
		//Muestro las columnas VR y VRV si lo permite el perfil
		<sec:authorize ifAllGranted="MOSTRAR_VR_TAREAS">
			tareasNewCm.setHidden(12,false);
			tareasNewCm.setHidden(13,false);
		</sec:authorize>
		
	}
	if(!eval(enEspera) && ("${codigoTipoTarea}" == "3")){
		//Listado de notificaciones
		//oculto las columnas [fecha vto,supervisor,gestor]
		tareasNewCm.setHidden(5,true);
		tareasNewCm.setHidden(8,true);
		tareasNewCm.setHidden(9,true);
		tareasNewCm.setColumnHeader(14,'<s:message code="tareas.listado.inicio" text="**inicio"/>');
		//Oculto filtros de fechas
		panelFechasVenc.hide();
		
	}
	if(eval(enEspera)){
		//Listado de tareas en espera
		//oculto columna supervisor
		tareasNewCm.setHidden(9,true);
		//cambia nombre de columna gestor a responsable
		tareasNewCm.setColumnHeader(8,'Responsable');
		//muestro columna tipo solicitud
		tareasNewCm.setHidden(6,false);
	}
	if(!(eval(enEspera) || ("${codigoTipoTarea}" == "3"))){
		//Listado de tareas
		//Muestro las columnas VR y VRV si lo permite el perfil
		<sec:authorize ifAllGranted="MOSTRAR_VR_TAREAS">
			tareasNewCm.setHidden(12,false);
			tareasNewCm.setHidden(13,false);
		</sec:authorize>
	}
	
	if(eval(${traerGestionVencidos})){
		tareasNewCm.setHidden(13,true);
		tareasNewCm.setHidden(12,true);
		tareasNewCm.setHidden(10,true);
		tareasNewCm.setHidden(7,true);
		tareasNewCm.setHidden(6,true);
		tareasNewCm.setHidden(5,true);
		tareasNewCm.setHidden(3,true); 
	}
	
	if(eval(${traerGestionVencidos})){
		var mainPanel = new Ext.Panel({
		    items : [
					tareasGrid
		    	]
		    ,bodyStyle:'padding:10px'
		    ,autoHeight : true
		    ,border: false
			,tbar:new Ext.Toolbar()
	    });
	}else{
		var mainPanel = new Ext.Panel({
		    items : [
		    		panelFiltros
					,tareasGrid
		    	]
		    ,bodyStyle:'padding:10px'
		    ,autoHeight : true
		    ,border: false
			,tbar:new Ext.Toolbar()
	    });
	}    
	page.add(mainPanel);
	
	mainPanel.getTopToolbar().add('->');
	//Handler de prueba para el boton ayuda
	var handler=function(){
		
	}
	Ext.onReady(function(){
		tareasStore.fireEvent('beforeload');
	});
	
	mainPanel.getTopToolbar().add(app.crearBotonAyuda(handler));
	
	
	
	
	
</fwk:page>