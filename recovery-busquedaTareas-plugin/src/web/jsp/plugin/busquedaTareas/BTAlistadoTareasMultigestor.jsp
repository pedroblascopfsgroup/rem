<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>
	

	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	// STORES
	var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'plugin/busquedaTareas/BTAbuscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	});
	
	var tipoSubtareaStore = page.getStore({
		 flow:'plugin/busquedaTareas/BTAlistadoSubTiposTarea'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id',
    		root: 'subTiposTarea',
    		totalProperty: 'results',
			fields : [
				 {name: 'codigoSubtarea'}
				,{name:'descripcion'}
			]})
	});
	
	var Gestor = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsGestoresStore = page.getStore({
	       flow: 'asuntos/buscarGestores'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	
	// FIN STORES
	
	
	var tabs = <app:includeArray files="${tabs}" />;
	
	//Buscamos la solapa que queremos abrir
    var nombreTab = '${nombreTab}';
    var nrotab = 0;
        
    //tab activo por nombre
    if (nombreTab != null){
        for(var i=0;i< tabs.length;i++){
            if (tabs[i].initialConfig && nombreTab==tabs[i].initialConfig.nombreTab){
                nrotab = i;
                break;
            }
        }
    }
		
	var tareasTabPanel=new Ext.TabPanel({
        items:tabs
        ,layoutOnTabChange:true 
        ,activeItem:nrotab
        ,autoScroll:true
        ,autoHeight:true
        ,autoWidth : true
        ,border : false
            
    });	
		
	var esAlerta="${alerta}";
	var enEspera="${espera}";
	var limit = 25;
	var isBusqueda='${isBusqueda}';
	var noGrouping='${noGrouping}';
	
	var scopeMarcar = 0;
	var seleccionado = false;
	
	var j=0;
	var parametrosTab = new Array();
	
	var btnMarcarTodas = new Ext.Button({
	    text:'<s:message code="plugin.busquedaTareas.marcar" text="**Marcar todos los registros"/>'
	    ,iconCls:'icon_vacio'
	    ,menu : {
	      	items: [
			    {text:'<s:message code="plugin.busquedaTareas.botonMarcarPagina" text="**Marcar los de esta pagina"/>'
			    ,iconCls:'icon_page'
			    ,itemId:'mnuPagina'
			    ,handler:function(){			    		
			        	marcarTodasAutoProrrogas("PAG");
			        }
			    }
			    ,
			    {text:'<s:message code="plugin.busquedaTareas.botonMarcarTodas" text="**Marcar todos los encontrados" arguments="0"/>'
			    ,iconCls:'icon_pages'			
			    ,itemId:'mnuTodos'   
			    ,handler:function(){
			        	marcarTodasAutoProrrogas("ALL");
			        }
			    }
			]
		}
	});

	var parametros = new Array();
	var hayParametros = false;		

	var deshabilitarTabGrupos = function(cte) {
		tareasTabPanel.items.get(2).setDisabled(cte);
		
	}
	
	var deshabilitarTabIndividual = function(cte) {
		tareasTabPanel.items.get(3).setDisabled(cte);		
	}

	var buscarFunc = function() {
            parametros = new Array();
            parametros['busquedaUsuario'] = '';
			parametros['despacho'] = '';
			parametros['gestores'] = '';
			parametros['tipoActuacion'] = '';
			parametros['tipoProcedimiento'] = '';
			parametros['tipoTarea'] = '';
			parametros['tipoGestor'] = '';
			parametros['tipoGestorTarea'] = '';
			parametros['perfilesAbuscar'] = '';
			parametros['nivelEnTarea'] = '';
			parametros['zonasAbuscar'] = '';
			parametros['usuarioExterno'] = app.usuarioLogado.externo;
			parametros['usuarioId'] = app.usuarioLogado.id;
		
            hayParametros = false;
            
            var anadirParametros = function(newParametros) {
  
                for (var i in newParametros) {
                    hayParametros = true;
                    parametros[i] = newParametros[i];
                    if(i == 'params'){
                    	
                    	parametrosTab[j] = newParametros[i];
                    	j++;
                    }
                }     
            };
            
            var error=false;

            var hayError = function() {
                error = true;
            };
            
            for (var tab=0;tab < tareasTabPanel.items.length && error==false;tab++) {
            	 tareasTabPanel.items.get(tab).fireEvent('getParametros', anadirParametros, hayError);
            }
            
            if (hayParametros) {
				
                flitrosPlegables.collapse(true);
                pagingBar.show();
				
				tareasStore.webflow(parametros); 
				
				parametrosTab = new Array();            
                flitrosPlegables.getTopToolbar().setDisabled(true);
            } else {
                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
            }
        };

	
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
		
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			for (var tab=0; tab < tareasTabPanel.items.length; tab++) {
                tareasTabPanel.items.get(tab).fireEvent('limpiar');
                if (tab == 2){
                	tareasTabPanel.items.get(tab).setDisabled(false);
                }
                if (tab == 3){
                	tareasTabPanel.items.get(tab).setDisabled(true);
                }
            }
            optionsZonasStore.webflow({id:0});
            optionsGestoresStore.webflow({id:0});
            tareasGrid.collapse(false);
        }
	});
	
	
	var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
			

            if (hayParametros) {
                flitrosPlegables.collapse(true);
				
                parametros.tipoSalida='<fwk:const value="es.pfsgroup.plugin.recovery.busquedaTareas.dto.BTADtoBusquedaTareas.SALIDA_XLS" />';
                var paramsExp=parametros;
                
                Ext.Ajax.request({
                	url: page.resolveUrl('btabusquedatareas/exportacionTareasCount'),
					params : {nombreTarea: parametros.nombreTarea,
							descripcionTarea: parametros.descripcionTarea,
							ambitoTarea: parametros.ambitoTarea,
							estadoTarea: parametros.estadoTarea,									
							ugGestion: parametros.ugGestion,
							codigoTipoTarea: parametros.codigoTipoTarea,
							codigoTipoSubTarea: parametros.codigoTipoSubTarea,									
							fechaVencDesdeOperador: parametros.fechaVencDesdeOperador, 
							fechaInicioDesdeOperador: parametros.fechaInicioDesdeOperador,
							fechaFinDesdeOperador: parametros.fechaFinDesdeOperador,
							fechaVencimientoDesde: parametros.fechaVencimientoDesde,
							fechaInicioDesde: parametros.fechaInicioDesde,
							fechaFinDesde: parametros.fechaFinDesde,
							fechaVencimientoHastaOperador: parametros.fechaVencimientoHastaOperador,
							fechaInicioHastaOperador: parametros.fechaInicioHastaOperador,
							fechaFinHastaOperador: parametros.fechaFinHastaOperador,
							fechaVencimientoHasta: parametros.fechaVencimientoHasta,
							fechaInicioHasta: parametros.fechaInicioHasta,
							fechaFinHasta: parametros.fechaFinHasta,
							busquedaUsuario: parametros.busquedaUsuario,
							despacho: parametros.despacho,
							gestores: parametros.gestores,
							tipoActuacion: parametros.tipoActuacion,
							tipoProcedimiento: parametros.tipoProcedimiento,
							tipoTarea: parametros.tipoTarea,
							tipoGestor: parametros.tipoGestor,
							tipoGestorTarea: parametros.tipoGestorTarea,
							perfilesAbuscar: parametros.perfilesAbuscar,
							nivelEnTarea: parametros.nivelEnTarea,
							zonasAbuscar: parametros.zonasAbuscar,
							params: parametros.params},
					success : function(data) {
							var data = Ext.decode(data.responseText);
							var count = data.count;
							var limit = data.limit;
							if(count < limit){
								app.openBrowserWindow('/pfs/btabusquedatareas/exportacionTareasPage', parametros);  
								parametrosTab = new Array();    
							}else{
								Ext.MessageBox.hide();
								Ext.Msg.alert('<s:message code="plugin.busquedaTareas.error" text="**Error" />', '<s:message code="plugin.busquedaTareas.exportarExcel.limiteSuperado1" text="**Se ha establecido un l\EDmite m\E1ximo de " />'+ limit + ' '+
									'<s:message code="plugin.busquedaTareas.exportarExcel.limiteSuperado2" text="**Tareas a Exportar. Por favor utilice los filtros para limitar el n\FAmero de resultados." />');
							}							    			
						},
						failure: function (result) {
							Ext.MessageBox.hide();
							Ext.Msg.alert('<s:message code="plugin.busquedaTareas.error" text="**Error" />', '<s:message code="plugin.busquedaTareas.exportarExcel.errorExportando" text="**Se ha producido un error durante el proceso de validaci\F3n de la exportaci\F3n a excel." />');
					    }
					});
            } else {
                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
            }
           }
        }
    );
    
    function marcarTodasAutoProrrogas(paramScope){ 
    	seleccionado = !seleccionado; 
		var store = tareasGrid.getStore();
		var str = '';
		var datos;

		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			datos.set('marcar',seleccionado);
		}
		
		if (store.data.length == 0) seleccionado = false;
		    	
    	scopeMarcar = paramScope;
		
    	cambiarBotonMarcar(seleccionado,paramScope);
				
	};
	
	function cambiarBotonMarcar(sel,paramScope) {
		if (seleccionado) {	    		
    		btnMarcarTodas.setIconClass('icon_lleno');
    		var btnText = (paramScope == "ALL") ? '<s:message code="plugin.busquedaTareas.botonMarcarSeleccionaTodos" text="**Seleccion todos"/>' : '<s:message code="plugin.busquedaTareas.botonMarcarSeleccionaPag" text="**Seleccion pagina"/>';
			btnMarcarTodas.setText(btnText);
    	} else {
    		btnMarcarTodas.setIconClass('icon_vacio');
    		btnMarcarTodas.setText('<s:message code="plugin.busquedaTareas.marcar" text="**Marcar" />');
    	}
	}
	
	
	
    var definirAutoProrroga=function(){
    	var listaIds = transformParamInc();
		if(listaIds != ''){
			var maximoTareasProrrogar = '${appProperties.pluginBusquedaTareasMaximoTareasProrrogar}'||'500';
			var numIds = (scopeMarcar == "ALL" ? tareasStore.getTotalCount() : listaIds.split(",").length);
			if (numIds > maximoTareasProrrogar) {
				Ext.Msg.alert('<s:message code="plugin.busquedaTareas.excedeMaximoTareas" text="**El n\FAmero de tareas a prorrogar supera el m\E1ximo permitido, modifique su selecci\F3n para no exceder {0} tareas" arguments="'+maximoTareasProrrogar+'"/>');
			} else {
				var valores = getParametrosBusqueda();
				var paramBusqueda = Ext.encode(valores);
				var w = app.openWindow({
							flow : 'btaautoprorrogamasiva/autoprorrogarTareas'
							,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Pr\F3rroga" />'
							,width:550
							,params :{lista:listaIds,scope:scopeMarcar,paramBusquedaJSON:paramBusqueda}
						});
						w.on(app.event.DONE, function(){
							w.close();
							tareasStore.webflow(getParametrosBusqueda());
						});
						w.on(app.event.CANCEL, function(){ 
							w.close(); 
						});
			}
		} else {
			Ext.Msg.alert('<s:message code="plugin.busquedaTareas.prorrogarTareas" text="**Prorrogar tareas" />','<s:message code="plugin.busquedaTareas.prorrogar.novalor" text="**Debe seleccionar al menos una tarea de la lista" />');
		}
	};
    
    var btnAutoprorrogaMasiva = new Ext.Button({
	text : '<s:message code="plugin.busquedaTareas.prorrogar" text="**Prorrogar" />'
	,iconCls:'icon_aceptar_prorroga'
	,handler: definirAutoProrroga
	});
	
	function transformParamInc() {
		var store = tareasGrid.getStore();
		var str = '';
		var datos;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('marcar') == true) {
				if(str!='') str += ',';
	      		str += datos.get('id');
			}
		}
		return str;
	};


 
	Ext.grid.CheckColumn = function(config){ 
        Ext.apply(this, config); 
        if(!this.id){ 
            this.id = Ext.id(); 
        } 
        this.renderer = this.renderer.createDelegate(this); 
    }; 
    
    Ext.grid.CheckColumn.prototype = { 
        init : function(tareasGrid){ 
            this.tareasGrid = tareasGrid; 
            this.tareasGrid.on('render', function(){ 
                var view = this.tareasGrid.getView(); 
                view.mainBody.on('mousedown', this.onMouseDown, this); 
            }, this); 
        }, 
        onMouseDown : function(e, t){ 
            if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
                e.stopEvent(); 
                var index = this.tareasGrid.getView().findRowIndex(t); 
                var record = this.tareasGrid.store.getAt(index); 
                var value = !record.data[this.dataIndex];
                record.set(this.dataIndex, value);
                //this.tareasGrid.modifiedData['tareas['+index	+'].'+this.dataIndex]=value;
                
                scopeMarcar = 0;
	        	seleccionado = false;
	        	cambiarBotonMarcar(seleccionado,scopeMarcar);
	        	
            } 
        }, 
        renderer : function(v, p, record){ 
            p.css += ' x-grid3-check-col-td';  
            return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>'; 
        } 
    };
    
	var tarea = Ext.data.Record.create([
		{name : 'marcar', type:'bool'}
		,{name:'subtipo'}
		,{name:'fechaInicio',type:'date', dateFormat:'d/m/Y'}
		,{name:'fechaFin',type:'date', dateFormat:'d/m/Y'}
		,{name:'id'}
		,{name:'descripcion'}
		,{name:'codentidad'}
		,{name:'plazo'}
		,{name:'entidadInformacion'}
		,{name:'entidadInformacion_id'}
		,{name:'gestor'}
		,{name:'tipoTarea'}
		,{name:'tipoTareaDescripcion'}
		,{name:'subTipoTarea'}
		,{name:'idEntidad'}		
		,{name:'codigoSubtipoTarea'}
		,{name:'codigoEntidadInformacion'}
		,{name:'codigoSituacion'}
		,{name:'fcreacionEntidad'}
		,{name:'fechaVenc',type:'date', dateFormat:'d/m/Y'}
		,{name:'fechaRealizacion',type:'date', dateFormat:'d/m/Y'}
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
		,{name:'descripcionEntidadInformacion'}
		,{name:'zona'}
	]);
	
	var tareasStore = page.getGroupingStore({
		eventName : 'listado'
		,limit: limit
		,flow:'btabusquedatareas/busquedaTareas'
		,sortInfo:{field: 'tar.tarea.fechaVenc', direction: "ASC"}
		,groupField:'group'
		,remoteSort : false
		,groupOnSort:'true'
		,reader: new Ext.data.JsonReader({
	    		root : 'tareas'
	    		,totalProperty : 'total'
	   	}, tarea)
	});
	   
	
	tareasStore.addListener('load', agrupa);
	tareasStore.setDefaultSort('tar.tarea.fechaVenc', 'ASC');
	function agrupa(store, meta) {
		if (!('${noGrouping}'=='true')) {
			store.groupBy('group', true);
		}		
		tareasStore.removeListener('load', agrupa);
    };
	
	var perfilUsuario;

	var alertasRenderer = function(value){
		var idx = parseInt(value);
		var iconos = [0,'alerta.gif', 'notificacion.gif'];
		return "<img src='/${appProperties.appName}/css/" +iconos[idx] + "' />";
	};

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
	};
	
	var seleccionada_edit = new Ext.grid.CheckColumn({ 
        header: '<s:message code="plugin.busquedaTareas.marcar" text="**Marcar" />'   
        ,width: 50
        ,dataIndex: 'marcar'  
        ,sortable: true
    });
     
	var tareasNewCm=new Ext.grid.ColumnModel([
		<sec:authorize ifAllGranted="ROLE_PRORROGA_MASIVA">
			seleccionada_edit,
		</sec:authorize>
		{	/*Columna 0*/ header: '<s:message code="plugin.busquedaTareas.cabeceraUnidadGestion" text="**Unidad Gestión"/>', sortable: false, dataIndex: 'descripcionEntidadInformacion'}
		,{	/*Columna 1*/ header: '<s:message code="plugin.busquedaTareas.cabeceraUnidadGestionId" text="**Unidad Gestión Id"/>', sortable: true, dataIndex: 'entidadInformacion_id', hidden:true}
		,{	/*Columna 1*/ header: '<s:message code="plugin.busquedaTareas.cabeceraTarea" text="**Tarea"/>', sortable: true, dataIndex: 'descripcionTarea', width:150}
		,{	/*Columna 2*/ header: '<s:message code="plugin.busquedaTareas.cabeceraDescripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion', width:150}
		,{	/*Columna 3*/ header: '<s:message code="plugin.busquedaTareas.cabeceraFechaInicio" text="**Fecha inicio"/>', sortable: true, dataIndex: 'fechaInicio', renderer:app.format.dateRenderer, width:70}
		,{	/*Columna 4*/ header: '<s:message code="plugin.busquedaTareas.cabeceraFechaVencimiento" text="**Fecha Vto."/>', sortable: true, dataIndex: 'fechaVenc', renderer:app.format.dateRenderer, width:70}
		,{	/*Columna 3*/ header: '<s:message code="plugin.busquedaTareas.cabeceraFechaFin" text="**Fecha fin"/>', sortable: true, dataIndex: 'fechaFin', renderer:app.format.dateRenderer, width:70}
		,{  /*Columna 5*/ header: '<s:message code="plugin.busquedaTareas.cabeceraDiasVencida" text="**Dias Vencida"/>', sortable: false, dataIndex: 'diasVencido', width:70}
		,{  /*Columna 6*/ header: '<s:message code="plugin.busquedaTareas.cabeceraGestor" text="**Gestor"/>', sortable: false, dataIndex: 'gestor', width:70}
		,{  /*Columna 7*/ header: '<s:message code="plugin.busquedaTareas.cabeceraSupervisor" text="**Supervisor"/>', sortable: false, dataIndex: 'supervisor', width:70}
		,{  /*Columna 8*/ header: '<s:message code="plugin.busquedaTareas.cabeceraEmisor" text="**Emisor"/>', sortable: true, dataIndex: 'emisor', width:70, hidden:true}
		,{  /*Columna 9*/ header: '<s:message code="plugin.busquedaTareas.cabeceraClasificacion" text="**Clasificación"/>', sortable: false, dataIndex: 'tipoTareaDescripcion'}
		,{  /*Columna 10*/ header: '<s:message code="plugin.busquedaTareas.cabeceraTipo" text="**Tipo"/>', sortable: false, dataIndex: 'subTipoTarea'}
		,{	/*Columna 11*/ header: '<s:message code="plugin.busquedaTareas.cabeceraItinerario" text="**Itinerario"/>', sortable: false, dataIndex: 'itinerario', hidden:true}
		,{	/*Columna 12*/ header: '<s:message code="plugin.busquedaTareas.cabeceraTipoSolicitud" text="**Tipo solicitud"/>',sortable: false, dataIndex: 'tipoSolicitud', width:75, hidden:true}
		,{  /*Columna 13*/ header: '<s:message code="plugin.busquedaTareas.cabeceraId" text="**Id"/>', sortable: true,dataIndex: 'id', hidden:true}
		,{  /*Columna 14*/ header: '<s:message code="plugin.busquedaTareas.total" text="**Total"/>',	sortable: false, dataIndex: 'volumenRiesgo', renderer:app.format.moneyRendererNull, align:'right', hidden:true}
		,{  /*Columna 15*/ header: '<s:message code="plugin.busquedaTareas.cabeceraVRV" text="**VRV"/>', sortable: false, dataIndex: 'volumenRiesgoVencido', renderer:app.format.moneyRendererNull,align:'right', hidden:true}
		,{  /*Columna 16*/ header: '<s:message code="plugin.busquedaTareas.cabeceraVencimiento" text="**vencimiento"/>', sortable: false, dataIndex: 'group',renderer:groupRenderer, hidden:true}
		,{  /*Columna 17*/ header: '<s:message code="plugin.busquedaTareas.cabeceraZona" text="**Zonificación"/>', sortable: false, dataIndex: 'zona', width:70}
	]);
	
	var pagingBar=fwk.ux.getPaging(tareasStore);
	pagingBar.hide();

	var tareasGrid = app.crearGrid(tareasStore,tareasNewCm, {
		title : '<s:message code="plugin.busquedaTareas.tituloResltado" text="**Tareas" arguments="0"/>'
		,style:'padding-bottom:10px; padding-right:20px;'
		,stripeRows: true
		,cls:'cursor_pointer'
		,iconCls:'icon_pendientes_tab'
		,collapsible : true
		,collapsed: true		
		,titleCollapse : true
		,plugins:seleccionada_edit
		,bbar : [
			<sec:authorize ifAllGranted="ROLE_PRORROGA_MASIVA">
			btnMarcarTodas,
			</sec:authorize>
			pagingBar
			<sec:authorize ifAllGranted="ROLE_PRORROGA_MASIVA">
			,btnAutoprorrogaMasiva 
			</sec:authorize>
		]
		,autoHeight: true
		,view: new Ext.grid.GroupingView({
	            forceFit:true
	            ,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
	        })
	});
	

	
	
	tareasStore.on('load', function(){
		tareasGrid.setTitle('<s:message code="plugin.busquedaTareas.tituloResltado" text="**Tareas" arguments="'+tareasStore.getTotalCount()+'"/>');
		btnMarcarTodas.menu.items.get('mnuTodos').setText('<s:message code="plugin.busquedaTareas.botonMarcarTodas" text="**Marcar todos" arguments="'+tareasStore.getTotalCount()+'"/>');
		flitrosPlegables.collapse(true);
		flitrosPlegables.getTopToolbar().setDisabled(false);
		scopeMarcar = 0;
       	seleccionado = false;
       	cambiarBotonMarcar(seleccionado,scopeMarcar);
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
				app.openTab("<s:message code="tareas.gv" text="**Gesti&oacute;n de Vencidos"/>", "clientes/listadoClientes", {gv:true},{id:'GV',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO:
				app.openTab("<s:message code="tareas.gsis" text="**Gesti&oacute;n de Seguimiento Sistem&aacute;tico"/>", "clientes/listadoClientes", {gsis:true},{id:'GSIN',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO:
				app.openTab("<s:message code="tareas.gsin" text="**Gesti&oacute;n de Seguimiento Sintom&aacute;tico"/>", "clientes/listadoClientes", {gsin:true},{id:'GSIS',iconCls:'icon_busquedas'});
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
                                ,enEspera:'${espera}'
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
                    	tareasStore.webflow(parametros);
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
					,params : {idExpediente:rec.get('idEntidad'), idTarea:rec.get('id'), espera:'${espera}'}
				});
			
				w.on(app.event.DONE, function(){
								w.close();
								tareasStore.webflow(parametros);
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
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(parametros);});
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
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(parametros);});
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
            
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(parametros);});
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
                            tareasStore.webflow(parametros); 
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
				
	});
	
	tareasGrid.getView().getRowClass = function(record, index){
		return (record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO
			|| record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO 
			|| record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_VENCIDOS) ? "marked_row" : ""; 
	};
	
	var flitrosPlegables = new Ext.Panel({
		items:[tareasTabPanel]
		,title : '<s:message code="plugin.busquedaTareas.tituloFiltros" text="**Filtro de bienes" />'
		,titleCollapse : true
		,style:'padding-bottom:10px; padding-right:10px;'
		,collapsible:true
		,tbar : [btnBuscar, btnClean, btnExportarXls,buttonsL,'->',buttonsR]
		,listeners:{	
			beforeExpand:function(){
				tareasGrid.setHeight(175);
			}
			,beforeCollapse:function(){
				tareasGrid.setHeight(435);
				tareasGrid.expand(true);
			}
		}
	});
	
	var mainPanel = new Ext.Panel({
		items : [
			 flitrosPlegables
			,tareasGrid
    	]
	    ,bodyStyle:'padding:15px'
	    ,autoHeight : true
	    ,border: false
	    
    });
    
    
    var getParametrosBusqueda=function(){
        var p = {nombreTarea: parametros.nombreTarea,
							descripcionTarea: parametros.descripcionTarea,
							ambitoTarea: parametros.ambitoTarea,
							estadoTarea: parametros.estadoTarea,									
							ugGestion: parametros.ugGestion,
							codigoTipoTarea: parametros.codigoTipoTarea,
							codigoTipoSubTarea: parametros.codigoTipoSubTarea,									
							fechaVencDesdeOperador: parametros.fechaVencDesdeOperador, 
							fechaInicioDesdeOperador: parametros.fechaInicioDesdeOperador,
							fechaFinDesdeOperador: parametros.fechaFinDesdeOperador,
							fechaVencimientoDesde: parametros.fechaVencimientoDesde,
							fechaInicioDesde: parametros.fechaInicioDesde,
							fechaFinDesde: parametros.fechaFinDesde,
							fechaVencimientoHastaOperador: parametros.fechaVencimientoHastaOperador,
							fechaInicioHastaOperador: parametros.fechaInicioHastaOperador,
							fechaFinHastaOperador: parametros.fechaFinHastaOperador,
							fechaVencimientoHasta: parametros.fechaVencimientoHasta,
							fechaInicioHasta: parametros.fechaInicioHasta,
							fechaFinHasta: parametros.fechaFinHasta,
							busquedaUsuario: parametros.busquedaUsuario,
							despacho: parametros.despacho,
							gestores: parametros.gestores,
							tipoActuacion: parametros.tipoActuacion,
							tipoProcedimiento: parametros.tipoProcedimiento,
							tipoTarea: parametros.tipoTarea,
							tipoGestor: parametros.tipoGestor,
							tipoGestorTarea: parametros.tipoGestorTarea,
							perfilesAbuscar: parametros.perfilesAbuscar,
							nivelEnTarea: parametros.nivelEnTarea,
							zonasAbuscar: parametros.zonasAbuscar,
							params: parametros.params};
        return p;
    }  
    
	page.add(mainPanel);

</fwk:page>