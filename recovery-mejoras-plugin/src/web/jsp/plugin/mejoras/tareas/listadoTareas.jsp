<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<%@ include file="/WEB-INF/jsp/main/comunicaciones.jsp" %>	
	
	var buttonsRTP = <app:includeArray files="${buttonsRightTarPte}" />;
	var buttonsLTP = <app:includeArray files="${buttonsLeftTarPte}" />;
	var buttonsRPanel = <app:includeArray files="${buttonsRightTarPanel}" />;
	var buttonsLPanel = <app:includeArray files="${buttonsLeftTarPanel}" />;
	var buttonsRTE = <app:includeArray files="${buttonsRightTarEspera}" />;
	var buttonsLTE = <app:includeArray files="${buttonsLeftTarEspera}" />;
	var buttonsRNot=<app:includeArray files="${buttonsRightNotificacion}" />;
	var buttonsLNot=<app:includeArray files="${buttonsLeftNotificacion}" />;12
	var buttonsRAle=<app:includeArray files="${buttonsRightAlertas}" />;
	var buttonsLAle=<app:includeArray files="${buttonsLeftAlertas}" />;
	var buzonOptimizado='${buzonOptimizado}';
		
	var nombreTareaField = (buzonOptimizado == 'true') ? 'nombreTarea' : 'descripcionTarea';
	var codigoTipoTarea="${codigoTipoTarea}";
	var esAlerta="${alerta}";
	var enEspera="${espera}";
	var limit = 25;
	var isBusqueda='${isBusqueda}';
	var noGrouping='${noGrouping}';
	var operadorFechaDesde='';
	var operadorFechaHasta='';
	
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
		,hidden: true
		,triggerAction : 'all'
		,mode:'local'
		//,labelSeparator:""
		,fieldLabel:'<s:message code="tareas.filtros.desde" text="**Venc Desde" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
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
	
	
	var comboEstado=new Ext.form.ComboBox({
		store:["Todas","Pendientes validar"]
		,name: 'comboEstado'
		,triggerAction : 'all'
		,mode:'local'
		,editable: false
    	,emptyText: 'Seleccionar...'
		,fieldLabel:'<s:message code="tareas.filtro.procuradores.estado" text="**Estado" />'
		,width:100
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,value:'${estado}'
	})
	
	
	comboEstado.on('select', function(){
		if(comboEstado.getValue()=="Pendientes validar")
		{
			comboCtgResol.setDisabled(false);
		}else{
			comboCtgResol.setDisabled(true);
		}
	});
	
	
	var categoriasRecord = Ext.data.Record.create([
		 {name:'id'}
        ,{name:'nombre'}
    ]);
       
    var categoriasStore = page.getStore({   
		flow : 'categorias/getListaCategorias'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,reader : new Ext.data.JsonReader({root:'categorias', totalProperty : 'total'}, categoriasRecord)
	});

	categoriasStore.webflow({idcategorizacion: "${idCategorizacion}"});
	
	//Combo Categorias Resoluciones
	var comboCtgResol = new Ext.form.ComboBox({
		name: 'comboCtgResol'
    	//,store: categorizacionesStore
    	,store: categoriasStore
    	,id: 'comboCtgResol'
    	,displayField: 'nombre'
    	,valueField: 'id'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,editable: false
    	,emptyText: 'Seleccionar...'
   		,fieldLabel: '<s:message code="tareas.filtro.procuradores.categorias" text="**Categorías" />'
		,labelStyle: 'width:100'
		,forceSelection: true
	});
	
	var fechaVencDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaVencDesde'
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,fieldLabel:'<s:message code="tareas.filtros.fvencimiento.desde" text="**F. Vencimiento desde" />'
		,value:'${fechaVencDesde}'
	});
	
	var comboFechaHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,hidden: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="tareas.filtros.hasta" text="**Venc hasta" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,value:'${fechaVencHastaOp}'
	})
	
	var fechaVencHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaVencHasta'
		,height:20
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,fieldLabel:'<s:message code="tareas.filtros.fvencimiento.hasta" text="**F. Vencimiento hasta" />'
		,value:'${fechaVencHasta}'
	});
	
	var descTarea=new Ext.form.TextField({
		fieldLabel:'<s:message code="tareas.filtros.descripciontarea" text="**Descripcion Tarea" />'
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
	});
	
	var nombreTarea=new Ext.form.TextField({
		fieldLabel:'<s:message code="tareas.filtros.nombretarea" text="**Nombre Tarea" />'
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
	});
	
	var validarForm=function(){
		if(descTarea.getValue()!='')
			return true;
		if(nombreTarea.getValue()!='')
			return true;
		if(fechaVencDesde.getValue()!='')
			return true;
		if(fechaVencHasta.getValue()!='')
			return true;
		if(${tieneProcurador} == true && comboEstado.getValue()!='') 
			return true;
	}
	
	var validaFechasVenc=function(){
		var valid=true;
		if(fechaVencDesde.getValue()!='' && fechaVencHasta.getValue()!=''){
			valid = (fechaVencDesde.getValue()<= fechaVencHasta.getValue())
		}
		return valid;
	}
	
	var getParametrosBusqueda=function(){
		var params = {
			codigoTipoTarea:codigoTipoTarea
			,perfilUsuario:perfilUsuario
			,enEspera:enEspera
			,esAlerta:esAlerta
			,limit:limit
			,busqueda:true
			,start:0
			,nombreTarea:nombreTarea.getValue()
			,descripcionTarea:descTarea.getValue()
			//Filtros fecha vencimiento					
			,fechaVencimientoDesde:app.format.dateRenderer(fechaVencDesde.getValue())
			,fechaVencDesdeOperador:operadorFechaDesde
			,fechaVencimientoHasta:app.format.dateRenderer(fechaVencHasta.getValue())
			,fechaVencimientoHastaOperador:operadorFechaHasta
		};
		
		if(${tieneProcurador} == true) {
			params.estado = comboEstado.getValue();
			params.categorizacion = comboCtgResol.getValue();
		}

		
		return params;
	}
	
	var buscarFunc=function(){
		if(${tieneProcurador} == true) {
			var estado = comboEstado.getValue();
			var categorizacion = comboCtgResol.getValue();
		}
		
		if(validarForm()){
			if(validaFechasVenc()){
				isBusqueda=true;
				panelFiltros.collapse(true);
				conversionOperadores();
				tareasStore.webflow(getParametrosBusqueda());
				tareasGrid.setTitle('${titulo}');
				panelFiltros.getTopToolbar().setDisabled(true);
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
			app.resetCampos([nombreTarea, comboFechaDesdeOp, comboFechaHastaOp, descTarea, fechaVencDesde, fechaVencHasta]);
			tareasStore.webflow(paramsBusquedaInicial);
			panelFiltros.collapse(true);
		}
	});
	
	var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
			if(validarForm()|| (panelFiltros.validate && panelFiltros.validate())){
				if(validaFechasVenc()){
					
					conversionOperadores();
                    			var params ;
			        	if(isBusqueda)
						params = getParametrosBusqueda();
					else
						params = paramsBusquedaInicial;

                    			params.REPORT_NAME='listado_tareas.xls';
					var parametros = new Array();
					parametros['codigoTipoTarea'] = codigoTipoTarea;
					if(perfilUsuario == null || perfilUsuario == 'undefined' || perfilUsuario == '')
						{parametros['perfilUsuario'] = '';}else{parametros['perfilUsuario'] = perfilUsuario;}
					parametros['enEspera'] = enEspera;
					parametros['esAlerta'] = esAlerta;
					parametros['limit'] = limit;
					parametros['nombreTarea'] = nombreTarea.getValue();
					parametros['descripcionTarea'] = descTarea.getValue();
					parametros['fechaVencimientoDesde'] = app.format.dateRenderer(fechaVencDesde.getValue());
					parametros['fechaVencDesdeOperador'] = operadorFechaDesde;
					parametros['fechaVencimientoHasta'] = app.format.dateRenderer(fechaVencHasta.getValue());
					parametros['fechaVencimientoHastaOperador'] = operadorFechaHasta;
					
					Ext.Ajax.request({
						url: page.resolveUrl('tareanotificacion/exportacionTareasExcelCount')
						,params: {codigoTipoTarea:codigoTipoTarea
							,perfilUsuario:perfilUsuario
							,enEspera:enEspera
							,esAlerta:esAlerta
							,limit:limit
							,nombreTarea:nombreTarea.getValue()
							,descripcionTarea:descTarea.getValue()
							//Filtros fecha vencimiento					
							,fechaVencimientoDesde:app.format.dateRenderer(fechaVencDesde.getValue())
							,fechaVencDesdeOperador:operadorFechaDesde
							,fechaVencimientoHasta:app.format.dateRenderer(fechaVencHasta.getValue())
							,fechaVencimientoHastaOperador:operadorFechaHasta},
						success : function(data) {
							var data = Ext.decode(data.responseText);
							var count = data.count;
							var limit = data.limit;
							if(count < limit){
							 app.openBrowserWindow('/pfs/tareanotificacion/exportacionTareasPaginaDescarga',parametros);  
							}else{
								Ext.MessageBox.hide();
								Ext.Msg.alert('<s:message code="plugin.mejoras.error" text="**Error" />', '<s:message code="plugin.mejoras.tareas.exportarExcel.limiteSuperado1" text="**Se ha establecido un lï¿½mite mï¿½ximo de " />'+ limit + ' '+
									'<s:message code="plugin.mejoras.tareas.exportarExcel.limiteSuperado2" text="**Tareas a Exportar. Por favor utilice los filtros para limitar el nï¿½mero de resultados." />');
							}							    			
						},
						failure: function (result) {
							Ext.MessageBox.hide();
							Ext.Msg.alert('<s:message code="plugin.ugas.ws.error" text="**Error" />', '<s:message code="plugin.ugas.asuntos.exportarExcel.errorExportando" text="**Se ha producido un error durante el proceso de validaciï¿½n de la exportaciï¿½n a excel." />');
					    }
					});
       					
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="tareas.filtros.errores.fechasvenc" text="** La fecha desde debe ser menor a la fecha Hasta"/>')
				}
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
			}
        }
    });
	
	var btnAyuda = app.crearBotonAyuda();
	
	/**
	 * funcion de conversi\F3n de los operadores para evitar el car\E1cter = en las urls
	 * 
	 */
	var conversionOperadores=function(){

		if(comboFechaDesdeOp.getValue() != ''){
			if(comboFechaDesdeOp.getValue() == '>=')
				operadorFechaDesde='ME';
			else if(comboFechaDesdeOp.getValue() == '<=')
				operadorFechaDesde='LE';
			else if(comboFechaDesdeOp.getValue() == '=')
				operadorFechaDesde='E';
			else
				operadorFechaDesde = comboFechaDesdeOp.getValue();
		}
	
		if(comboFechaHastaOp.getValue() != ''){
			if(comboFechaHastaOp.getValue() == '>=')
				operadorFechaHasta='ME';
			else if(comboFechaHastaOp.getValue() == '<=')
				operadorFechaHasta='LE';
			else if(comboFechaHastaOp.getValue() == '=')
				operadorFechaHasta='E';
			else
				operadorFechaHasta =comboFechaHastaOp.getValue();
		}

	}
	
	
	var panelFiltros = new Ext.Panel({
		title : '<s:message code="tareas.listado.busqueda" text="**Busqueda de Tareas"/>'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {columns:3}
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset',border:false}
				,width:'320px'
				<c:choose>
				    <c:when test="${tieneProcurador == true && activoDespachoIntegral==true}">
				       ,items:[nombreTarea, fechaVencDesde, comboFechaDesdeOp, comboFechaHastaOp, comboEstado]
				    </c:when>
				    <c:otherwise>
				        ,items:[nombreTarea, fechaVencDesde, comboFechaDesdeOp, comboFechaHastaOp]
				    </c:otherwise>
				</c:choose>
			},{
				layout:'form' 
				,width:'320px'
				,defaults:{xtype:'fieldset',border:false}
				<c:choose>
				    <c:when test="${tieneProcurador == true && activoDespachoIntegral==true}">
				       ,items:[descTarea, fechaVencHasta, comboCtgResol]
				    </c:when>
				    <c:otherwise>
				        ,items:[descTarea, fechaVencHasta]
				    </c:otherwise>
				</c:choose>
			}
		]              
		,tbar:new Ext.Toolbar()
	});
	
	<c:if test="${tieneProcurador == true && activoDespachoIntegral==true}">
		comboCtgResol.setDisabled(true);
	</c:if>
	
	if(!eval(enEspera) && ("${codigoTipoTarea}" == "3")){
		panelFiltros.getTopToolbar().add(btnBuscar,btnClean,btnExportarXls,buttonsLNot,'->',buttonsRNot);
	}
	
	if(!eval(enEspera) && ("${codigoTipoTarea}" != "3" )){
		if(eval(esAlerta)){
			panelFiltros.getTopToolbar().add(btnBuscar,btnClean,btnExportarXls,buttonsLAle,'->',buttonsRAle);
		}else{
			panelFiltros.getTopToolbar().add(btnBuscar,btnClean,btnExportarXls,buttonsLTP,'->',buttonsRTP);
		}
	}
	
	if(eval(enEspera)){
		panelFiltros.getTopToolbar().add(btnBuscar,btnClean,btnExportarXls,buttonsLTE,'->',buttonsRTE);
	}
	
	// -- End Filtros	
	
	var tarea = Ext.data.Record.create([
		{name:'subtipo'}
		,{name:'fechaInicio'}
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
		,{name:'fechaVenc'}
		,{name:'fechaVencReal'}
		,{name:'idTareaAsociada'}
		,{name:'descripcionTareaAsociada'}
		,{name:'tipoSolicitudSQL'}
		,{name:'emisor'}
		,{name:'supervisor'}
		,{name:'diasVencidoSQL'}
		,{name:'descripcionExpediente'}
		,{name:nombreTareaField}		
		,{name:'gestorId'}
		,{name:'supervisorId'}
		,{name:'idEntidadPersona'}
		,{name:'volumenRiesgoSQL'}
		,{name:'volumenRiesgoVencido'}
		,{name:'group'}
		,{name:'itinerario'}
		,{name:'fechaPropuesta'}
		,{name:'motivo'}
		,{name:'prorrogaAsociada'}
		,{name:'descPropuesta'}
		,{name:'tarea'}
		,{name:'revisada', type:'bool'}
		,{name:'fechaRevisionAlerta'}
		,{name:'dtype'}
		,{name:'categoriaTarea'}
		,{name:'esPeticionProrroga'}
	]);
	
	Ext.grid.CheckColumn = function(config){ 
        Ext.apply(this, config); 
        if(!this.id){ 
            this.id = Ext.id(); 
        } 
        this.renderer = this.renderer.createDelegate(this); 
    }; 
   
    Ext.grid.CheckColumn.prototype = { 
        init : function(grid){ 
            this.grid = grid; 
            this.grid.on('render', function(){ 
                var view = this.grid.getView(); 
                view.mainBody.on('mousedown', this.onMouseDown, this); 
            }, this); 
        }, 
        onMouseDown : function(e, t){ 
            if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){ 
                e.stopEvent(); 
                var index = this.grid.getView().findRowIndex(t); 
                var record = this.grid.store.getAt(index); 
                var value = !record.data[this.dataIndex];
                record.set(this.dataIndex, value); 
            } 
        }, 
        renderer : function(v, p, record){ 
            p.css += ' x-grid3-check-col-td';  
            return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>'; 
        } 
    };
    
	var revisada_edit = new Ext.grid.CheckColumn({ 
		header: '<s:message code="plugin.mejoras.tareas.alertas.revidada" text="**Revisada" />'
		,dataIndex: 'revisada'
		,width: 50
		,sortable: true   
	});

	var tareasStore = page.getGroupingStore({
		eventName : 'listado'
		,limit: limit
		,flow:'plugin/mejoras/tareas/MEJlistadoTareasBusqueda'
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
	
	//Hace la b\FAsqueda inicial
	tareasStore.webflow(paramsBusquedaInicial);
	
	var alertasRenderer = function(value){
		var idx = parseInt(value);
		var iconos = [0,'alerta.gif', 'notificacion.gif'];
		return "<img src='/${appProperties.appName}/css/" +iconos[idx] + "' />";
	};
	
	var groupRenderer=function(val){
		if(val==-1)
			return '<s:message code="main.arbol_tareas.groups.sinvencimiento" text="**Sin vencimiento" />';
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
	
	if(eval(esAlerta)){
	
	var tareasNewCm=new Ext.grid.ColumnModel([
		{	/*Columna 0*/ header: '<s:message code="tareas.listado.tarea" text="**Tarea"/>', sortable: true, dataIndex: nombreTareaField}
		,{	/*Columna 2*/ header: '<s:message code="tareas.listado.descripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion'}
		,{	/*Columna 1*/ header: '<s:message code="tareas.listado.entidadinformacion" text="**Entidad Informacion"/>', sortable: false, dataIndex: 'entidadInformacion'}
		,{	/*Columna 3*/ header: '<s:message code="tareas.listado.itinerario" text="**Itinerario"/>', sortable: false, dataIndex: 'itinerario'}
		,{	/*Columna 4*/ header: '<s:message code="tareas.listado.fechainicio" text="**Fecha inicio"/>', sortable: true, hidden:true, dataIndex: 'fechaInicio', width:50}
		,{	/*Columna 5*/ header: '<s:message code="tareas.listado.fechavenc" text="**Fecha Vto."/>', sortable: true, dataIndex: 'fechaVenc', width:50}
		,{	/*Columna 5*/ header: '<s:message code="plugin.mejoras.tareas.listado.fechavencOri" text="**Fecha Vto. Orig."/>', sortable: true, dataIndex: 'fechaVencReal', width:50}
		,{	/*Columna 6*/ header: '<s:message code="tareas.listado.tiposolicitud" text="**Tipo solicitud"/>',sortable: true, dataIndex: 'tipoSolicitudSQL', width:75}
		,{  /*Columna 7*/ header: '<s:message code="tareas.listado.diasvencida" text="**Dias Vencida"/>', sortable: true, dataIndex: 'diasVencidoSQL', width:50}
		,{  /*Columna 8*/ header: '<s:message code="tareas.listado.gestor" text="**Gestor"/>', sortable: false, dataIndex: 'gestor', hidden:true}
		,{  /*Columna 9*/ header: '<s:message code="tareas.listado.supervisor" text="**Supervisor"/>', sortable: false, dataIndex: 'supervisor', hidden:true}
		,{  /*Columna 10*/ header: '<s:message code="tareas.listado.emisor" text="**Emisor"/>', sortable: true, dataIndex: 'emisor', width:50}		
		,{  /*Columna 11*/ header: '<s:message code="tareas.listado.id" text="**Id"/>', sortable: true, hidden:true ,dataIndex: 'id'}
		,{  /*Columna 12*/ header: '<s:message code="tareas.listado.volumenRiesgo" text="**VR"/>',	sortable: true, dataIndex: 'volumenRiesgoSQL' <sec:authorize ifAllGranted="PERSONALIZACION-BCC">,hidden:true </sec:authorize> ,renderer:app.format.moneyRendererNull,align:'right'}
		,{  /*Columna 13*/ header: '<s:message code="tareas.listado.volumenRiesgoVencido" text="**VRV"/>', sortable: false, dataIndex: 'volumenRiesgoVencido',hidden:true,renderer:app.format.moneyRendererNull,align:'right'}
		,{  /*Columna 14*/ header: '<s:message code="tareas.listado.vencimiento" text="**vencimiento"/>', 	sortable: false, dataIndex: 'group', hidden:true,renderer:groupRenderer}
		<sec:authorize ifAllGranted="ROLE_REVISAR_ALERTA">
				,revisada_edit
				,{  /*Columna 16*/ header: '<s:message code="plugin.mejoras.tareas.alerta.fecharev" text="**fecha revisi\F3n alerta"/>',sortable: true, dataIndex: 'fechaRevisionAlerta', hidden:true}
		</sec:authorize>
	]);
	} else {
	if(eval(enEspera)) {
		var tareasNewCm=new Ext.grid.ColumnModel([
			{	/*Columna 0*/ header: '<s:message code="tareas.listado.tarea" text="**Tarea"/>', sortable: true, dataIndex: nombreTareaField}
			,{	/*Columna 2*/ header: '<s:message code="tareas.listado.descripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion'}
			,{	/*Columna 1*/ header: '<s:message code="tareas.listado.entidadinformacion" text="**Entidad Informacion"/>', sortable: false, dataIndex: 'entidadInformacion'}
			,{	/*Columna 3*/ header: '<s:message code="tareas.listado.itinerario" text="**Itinerario"/>', sortable: false, dataIndex: 'itinerario'}
			,{	/*Columna 4*/ header: '<s:message code="tareas.listado.fechainicio" text="**Fecha inicio"/>', sortable: true, hidden:true, dataIndex: 'fechaInicio', width:50}
			,{	/*Columna 5*/ header: '<s:message code="tareas.listado.fechavenc" text="**Fecha Vto."/>', sortable: true, dataIndex: 'fechaVenc', width:50}
			,{	/*Columna 5*/ header: '<s:message code="plugin.mejoras.tareas.listado.fechavencOri" text="**Fecha Realizacion."/>', sortable: true, dataIndex: 'fechaVencReal', width:50}
			,{	/*Columna 6*/ header: '<s:message code="tareas.listado.tiposolicitud" text="**Tipo solicitud"/>',sortable: true, dataIndex: 'tipoSolicitudSQL', width:75}
			,{  /*Columna 7*/ header: '<s:message code="tareas.listado.diasvencida" text="**Dias Vencida"/>', sortable: true, dataIndex: 'diasVencidoSQL', width:50}
			,{  /*Columna 8*/ header: '<s:message code="tareas.listado.gestor" text="**Gestor"/>', sortable: false, dataIndex: 'gestor', hidden:true}
			,{  /*Columna 9*/ header: '<s:message code="tareas.listado.supervisor" text="**Supervisor"/>', sortable: false, dataIndex: 'supervisor', hidden:true}
			,{  /*Columna 10*/ header: '<s:message code="tareas.listado.emisor" text="**Emisor"/>', sortable: true, dataIndex: 'emisor', width:50}		
			,{  /*Columna 11*/ header: '<s:message code="tareas.listado.id" text="**Id"/>', sortable: true, hidden:true ,dataIndex: 'id'}
			,{  /*Columna 12*/ header: '<s:message code="tareas.listado.volumenRiesgo" text="**VR"/>',	sortable: true, dataIndex: 'volumenRiesgoSQL' <sec:authorize ifAllGranted="PERSONALIZACION-BCC">,hidden:true </sec:authorize>,renderer:app.format.moneyRendererNull,align:'right'}
			,{  /*Columna 13*/ header: '<s:message code="tareas.listado.volumenRiesgoVencido" text="**VRV"/>', sortable: false, dataIndex: 'volumenRiesgoVencido', hidden:true,renderer:app.format.moneyRendererNull,align:'right'}
			,{  /*Columna 14*/ header: '<s:message code="tareas.listado.vencimiento" text="**vencimiento"/>', 	sortable: false, dataIndex: 'group', hidden:true,renderer:groupRenderer}
			<sec:authorize ifAllGranted="ROLE_REVISAR_ESPERA">
				,revisada_edit
				,{  /*Columna 16*/ header: '<s:message code="plugin.mejoras.tareas.alerta.fecharev" text="**fecha revisi\F3n alerta"/>',sortable: true, dataIndex: 'fechaRevisionAlerta', hidden:true}
			</sec:authorize>
		]);
	} else {	
	if(eval(codigoTipoTarea==3)) {
		var tareasNewCm=new Ext.grid.ColumnModel([
			{	/*Columna 0*/ header: '<s:message code="tareas.listado.tarea" text="**Tarea"/>', sortable: true, dataIndex: nombreTareaField}
			,{	/*Columna 2*/ header: '<s:message code="tareas.listado.descripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion'}
			,{	/*Columna 1*/ header: '<s:message code="tareas.listado.entidadinformacion" text="**Entidad Informacion"/>', sortable: false, dataIndex: 'entidadInformacion'}
			,{	/*Columna 3*/ header: '<s:message code="tareas.listado.itinerario" text="**Itinerario"/>', sortable: false, dataIndex: 'itinerario'}
			,{	/*Columna 4*/ header: '<s:message code="tareas.listado.fechainicio" text="**Fecha inicio"/>', sortable: true, hidden:true, dataIndex: 'fechaInicio', width:50}
			,{	/*Columna 5*/ header: '<s:message code="tareas.listado.fechavenc" text="**Fecha Vto."/>', sortable: true, dataIndex: 'fechaVenc', width:50}
			,{	/*Columna 5*/ header: '<s:message code="plugin.mejoras.tareas.listado.fechavencOri" text="**Fecha Realizacion."/>', sortable: true, dataIndex: 'fechaVencReal', width:50}
			,{	/*Columna 6*/ header: '<s:message code="tareas.listado.tiposolicitud" text="**Tipo solicitud"/>',sortable: true, dataIndex: 'tipoSolicitudSQL', width:75}
			,{  /*Columna 7*/ header: '<s:message code="tareas.listado.diasvencida" text="**Dias Vencida"/>', sortable: true, dataIndex: 'diasVencidoSQL', width:50}
			,{  /*Columna 8*/ header: '<s:message code="tareas.listado.gestor" text="**Gestor"/>', sortable: false, dataIndex: 'gestor', hidden:true}
			,{  /*Columna 9*/ header: '<s:message code="tareas.listado.supervisor" text="**Supervisor"/>', sortable: false, dataIndex: 'supervisor', hidden:true}
			,{  /*Columna 10*/ header: '<s:message code="tareas.listado.emisor" text="**Emisor"/>', sortable: true, dataIndex: 'emisor', width:50}		
			,{  /*Columna 11*/ header: '<s:message code="tareas.listado.id" text="**Id"/>', sortable: true, hidden:true ,dataIndex: 'id'}
			,{  /*Columna 12*/ header: '<s:message code="tareas.listado.volumenRiesgo" text="**VR"/>',	sortable: true, dataIndex: 'volumenRiesgoSQL'<sec:authorize ifAllGranted="PERSONALIZACION-BCC">,hidden:true </sec:authorize>,renderer:app.format.moneyRendererNull,align:'right'}
			,{  /*Columna 13*/ header: '<s:message code="tareas.listado.volumenRiesgoVencido" text="**VRV"/>', sortable: false, dataIndex: 'volumenRiesgoVencido', hidden:true,renderer:app.format.moneyRendererNull,align:'right'}
			,{  /*Columna 14*/ header: '<s:message code="tareas.listado.vencimiento" text="**vencimiento"/>', 	sortable: false, dataIndex: 'group', hidden:true,renderer:groupRenderer}
			<sec:authorize ifAllGranted="ROLE_REVISAR_NOTIFICACION">
				,revisada_edit
				,{  /*Columna 16*/ header: '<s:message code="plugin.mejoras.tareas.alerta.fecharev" text="**fecha revisi\F3n alerta"/>',sortable: true, dataIndex: 'fechaRevisionAlerta', hidden:true}
			</sec:authorize>
		]);
	} else {
		var tareasNewCm=new Ext.grid.ColumnModel([
			{	/*Columna 0*/ header: '<s:message code="tareas.listado.tarea" text="**Tarea"/>', sortable: true, dataIndex: nombreTareaField}
			,{	/*Columna 2*/ header: '<s:message code="tareas.listado.descripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion'}
			,{	/*Columna 1*/ header: '<s:message code="tareas.listado.entidadinformacion" text="**Entidad Informacion"/>', sortable: false, dataIndex: 'entidadInformacion'}
			,{	/*Columna 3*/ header: '<s:message code="tareas.listado.itinerario" text="**Itinerario"/>', sortable: false, dataIndex: 'itinerario'}
			,{	/*Columna 4*/ header: '<s:message code="tareas.listado.fechainicio" text="**Fecha inicio"/>', sortable: true, hidden:true, dataIndex: 'fechaInicio', width:50}
			,{	/*Columna 5*/ header: '<s:message code="tareas.listado.fechavenc" text="**Fecha Vto."/>', sortable: true, dataIndex: 'fechaVenc', width:50}
			,{	/*Columna 5*/ header: '<s:message code="plugin.mejoras.tareas.listado.fechavencOri" text="**Fecha Realizacion."/>', sortable: true, dataIndex: 'fechaVencReal', width:50}
			,{	/*Columna 6*/ header: '<s:message code="tareas.listado.tiposolicitud" text="**Tipo solicitud"/>',sortable: true, dataIndex: 'tipoSolicitudSQL', width:75}
			,{  /*Columna 7*/ header: '<s:message code="tareas.listado.diasvencida" text="**Dias Vencida"/>', sortable: true, dataIndex: 'diasVencidoSQL', width:50}
			,{  /*Columna 8*/ header: '<s:message code="tareas.listado.gestor" text="**Gestor"/>', sortable: false, dataIndex: 'gestor', hidden:true}
			,{  /*Columna 9*/ header: '<s:message code="tareas.listado.supervisor" text="**Supervisor"/>', sortable: false, dataIndex: 'supervisor', hidden:true}
			,{  /*Columna 10*/ header: '<s:message code="tareas.listado.emisor" text="**Emisor"/>', sortable: true, dataIndex: 'emisor', width:50}		
			,{  /*Columna 11*/ header: '<s:message code="tareas.listado.id" text="**Id"/>', sortable: true, hidden:true ,dataIndex: 'id'}
			,{  /*Columna 12*/ header: '<s:message code="tareas.listado.volumenRiesgo" text="**VR"/>',	sortable: true, dataIndex: 'volumenRiesgoSQL'<sec:authorize ifAllGranted="PERSONALIZACION-BCC">,hidden:true </sec:authorize>,renderer:app.format.moneyRendererNull,align:'right'}
			,{  /*Columna 13*/ header: '<s:message code="tareas.listado.volumenRiesgoVencido" text="**VRV"/>', sortable: false, dataIndex: 'volumenRiesgoVencido', hidden:true,renderer:app.format.moneyRendererNull,align:'right'}
			,{  /*Columna 14*/ header: '<s:message code="tareas.listado.vencimiento" text="**vencimiento"/>', 	sortable: false, dataIndex: 'group', hidden:true,renderer:groupRenderer}
			 <sec:authorize ifAllGranted="ROLE_REVISAR_TAREA">
				,revisada_edit
				,{  /*Columna 16*/ header: '<s:message code="plugin.mejoras.tareas.alerta.fecharev" text="**fecha revisi\F3n alerta"/>',sortable: true, dataIndex: 'fechaRevisionAlerta', hidden:true}
			</sec:authorize>
		]);
	}}}
		
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
		text:'<s:message code="expedientes.solicitudCancelacion.rechaza" text="**Rechazar Cancelaci\F3n" />'
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
			//Si est\E1 aceptada, el codigo de respuesta ser\E1 7, sino 10
			if(acepta){
				params.descripcionCausa='<s:message code="expedientes.menu.prorrogaaceptada" text="**Pr\F3rroga Aceptada" />';
				params.codigoRespuesta='7';
			}else{
				params.descripcionCausa='<s:message code="expedientes.menu.prorrogarechazada" text="**Pr\F3rroga Rechazada" />';
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
						msg='<s:message code="expedientes.menu.prorrogaaceptada" text="**Pr\F3rroga Aceptada" />';
					else
						msg='<s:message code="expedientes.menu.prorrogarechazada" text="**Pr\F3rroga Rechazada" />';
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
	
	var redefinirFuncionContestarProrroga = function(params){
		var w = app.openWindow({
			flow : 'tareas/decisionProrroga'
			,title : '<s:message code="expedientes.menu.aceptarprorroga" text="**Solicitar Prorroga" />'
			,width:470 
			,params : params
		});
		w.on(app.event.DONE, function(){
			w.close(); 
			btnQuickRechazarProrroga.setVisible(false);
			btnQuickAceptarProrroga.setVisible(false);
			tareasStore.webflow(paramsBusquedaInicial);
			
		});
		w.on(app.event.CANCEL, function(){
			 w.close(); 
		});
	};
	
	var btnQuickAceptarProrroga=new Ext.Button({
		text:'<s:message code="decisionprorroga.acepta" text="**Acepta Pr\F3rroga" />'
		,iconCls:'icon_ok'
		,hidden:true
	});
	
	var btnQuickRechazarProrroga=new Ext.Button({
		text:'<s:message code="expedientes.menu.rechazarprorroga" text="**Rechazar Pr\F3rroga" />'
		,iconCls:'icon_cancel'
		,hidden:true
	});
	
	var handlerRevisionAlerta=function(id){
		var params ={id:id};
		var w= app.openWindow({
             flow: 'tareanotificacion/editarAlertaTarea'
             ,closable: true
             ,width : 700
             ,title : '<s:message code="plugin.mejoras.tareas.listado.revisionAlerta" text="**Revision Alerta" />'
             ,params: params
        });
		w.on(app.event.DONE, function(){
			w.close();
			tareasStore.webflow(paramsBusquedaInicial) ;				
		});
		w.on(app.event.CANCEL, function(){
			w.close(); 
		});
	}
	
	var btnRevisionAlerta=new Ext.Button({
		text:'<s:message code="plugin.mejoras.tareas.listado.revisionAlerta" text="**Revisi\F3n Alerta" />'
		,iconCls:'icon_edit'
		,hidden:true
	});
	
	<sec:authorize ifAllGranted="ROLE_REVISAR_TAREA">
		btnRevisionAlerta.show();
		btnRevisionAlerta.disable();	
	</sec:authorize>
	<sec:authorize ifAllGranted="ROLE_REVISAR_ALERTA">
		btnRevisionAlerta.show();
		btnRevisionAlerta.disable();	
	</sec:authorize>
	<sec:authorize ifAllGranted="ROLE_REVISAR_NOTIFICACION">
		btnRevisionAlerta.show();
		btnRevisionAlerta.disable();	
	</sec:authorize>
	<sec:authorize ifAllGranted="ROLE_REVISAR_ESPERA">
		btnRevisionAlerta.show();
		btnRevisionAlerta.disable();	
	</sec:authorize>
	
	var pagingBar=fwk.ux.getPaging(tareasStore);
	var tituloGrid = '${titulo}';
	
	if('${tituloAdicionalGrid}'!= null && '${tituloAdicionalGrid}'!="")
		tituloGrid = tituloGrid + ' - [${tituloAdicionalGrid}]';
		
	var cfg = {	
		title:tituloGrid
		,style:'padding-top:10px'
		,bbar : [  pagingBar ,'-',btnQuickAceptarCancelacion,btnQuickRechazarCancelacion,btnQuickAceptarProrroga,btnQuickRechazarProrroga,btnRevisionAlerta]
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
		
		var tipoTareaNotificacion=rec.get('dtype');
		
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
				
			case app.subtipoTarea.CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO:
				var params ={
								idEntidadInformacion: rec.get('idEntidad')
								,isConsulta:false
								,fechaVencimiento: app.format.dateRenderer(rec.get('fechaVenc'))
								,fechaCreacion: rec.get('fcreacionEntidad')
								,situacion:'Asunto' 
								,destareaOri:  rec.get(nombreTareaField)
								,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
								,fechaPropuesta: rec.get('fechaPropuesta')
								,motivo: rec.get('motivo')
								,idTareaOriginal: rec.get('id')	
								,descripcion:"Toma decision procedimiento"		
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_EXTERNA" />'
						}
			btnQuickAceptarProrroga.setHandler(function(){
					redefinirFuncionContestarProrroga(params)
				});	
			btnQuickAceptarProrroga.setVisible(true);
			break;
					
			<%-- 
			case app.subtipoTarea.CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION:
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
				btnQuickRechazarProrroga.setVisible(true);
				btnQuickAceptarProrroga.setVisible(true);
				break;
			--%>	
			default:
				if(rec.get('esPeticionProrroga')){
					var params ={
							idEntidadInformacion: rec.get('idEntidad')
							,isConsulta:false
							,fechaVencimiento: app.format.dateRenderer(rec.get('fechaVenc'))
							,fechaCreacion: rec.get('fcreacionEntidad')
							,situacion:'Asunto' 
							,destareaOri:  rec.get(nombreTareaField)
							,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
							,fechaPropuesta: rec.get('fechaPropuesta')
							,motivo: rec.get('motivo')
							,idTareaOriginal: rec.get('id')	
							,descripcion:"Toma decision procedimiento"		
							,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_EXTERNA" />'
					}
					btnQuickAceptarProrroga.setHandler(function(){
							redefinirFuncionContestarProrroga(params)
						});	
					btnQuickAceptarProrroga.setVisible(true);
				}else{
					btnQuickAceptarCancelacion.setVisible(false);
					btnQuickRechazarCancelacion.setVisible(false);
					btnQuickRechazarProrroga.setVisible(false);
					btnQuickAceptarProrroga.setVisible(false);
				}

				break;
		}
		if(tipoTareaNotificacion=='EXTTareaNotificacion'){
			var idTareaOriginal= rec.get('id');
			btnRevisionAlerta.setHandler(function(){
				handlerRevisionAlerta(idTareaOriginal);
			});
			btnRevisionAlerta.enable();	
		}else{
			btnRevisionAlerta.disable();	
		}	
		
	});
	
	
	tareasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		//agregar funcionalidad....
		var rec = grid.getStore().getAt(rowIndex);
		
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		var categoriaTarea = rec.get('categoriaTarea');
		
		
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR && permisosVisibilidadGestorSupervisor(rec.get('gestorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR;
		}
		
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR && permisosVisibilidadGestorSupervisor(rec.get('supervisorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR;
		}
		
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR_EXPTE && permisosVisibilidadGestorSupervisor(rec.get('gestorId')) == true){
			
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR;
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
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_INTERCOMUNICACION:
			
				var w = app.openWindow({
						flow : 'plugin.intercomunicaciones.tareas.generarNotificacion'
						,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
						,width:650 
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get(nombreTareaField)
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
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_GESTOR_CONFECCION_EXPTE:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR_EXPTE:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR_EXPTE:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR: 
				 
				 var w = app.openWindow({
						flow : 'tareas/generarNotificacion'
						,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
						,width:650 
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get(nombreTareaField)
								,fecha: app.format.dateRenderer(rec.get('fechaInicio'))
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
                                ,descripcion: rec.get(nombreTareaField)
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
                                ,descripcion: rec.get(nombreTareaField)
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
			case app.subtipoTarea.CODIGO_PRECONTENCIOSO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTORIA:
		    case app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR:
		    case app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_LETRADO:
		    case app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_LIQUIDACIONES:
		    case app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_DOCUMENTOS:
		    case app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_ESTUDIO:
		    
		    		Ext.Ajax.request({
						url: page.resolveUrl('expedientejudicial/getEsTareaPrecontenciosoEspecial')
						,method: 'POST'
						,params:{
									idTarea : rec.get('id')
								}
						,success: function (result, request){
													
							var isEspecial = Ext.util.JSON.decode(result.responseText);
							
							if(isEspecial.okko){
								app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'precontencioso');
							}else{
								app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
							}
						
						}
						,error: function(){
			
						}       				
					});
		
			break;

			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR:
			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO:
			case app.subtipoTarea.CODIGO_TAREA_GESTOR_CONFECCION_EXPTE:
			case app.subtipoTarea.CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE:
			case 'TCGA':
			case 'TCRC':
			case '100':
			case '101':			
			case '105':
			case '102':
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
				break;			
			case '103':
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
				break;			
			case '104':
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
				break;			

			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR:
			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR: 
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'recursos');
			break;
			<%--
			case app.subtipoTarea.CODIGO_TOMA_DECISION_BPM: --Pasado a default para varios tipos DECISION
				app.openTab(rec.get('descripcion'), 'procedimientos/consultaProcedimiento', {id:rec.get('idEntidad'),tarea:rec.get('id'),fechaVenc:rec.get('fechaVenc'),nombreTab:'decision'} , {id:'procedimiento'+rec.get('idEntidad'),iconCls:'icon_procedimiento'});
				app.addFavorite(rec.get('idEntidad'), rec.get('descripcion'), app.constants.FAV_TIPO_PROCEDIMIENTO);
			break;
			 --%>
			case app.subtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO:
			//case app.subtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'decision');
			break;
			case app.subtipoTarea.CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'cabeceraProcedimiento');
			break;
            case 'NTGPS':
            
                var w = app.openWindow({
                                flow : 'tareas/consultaNotificacion'
                                ,title : 'Notificacion'
                                ,width:400
                                ,params : {
                                                idEntidad: rec.get('idEntidad')
                                                ,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
                                                ,descripcion: rec.get('descripcion')
                                                ,fecha: rec.get('fcreacionEntidad')
                                                ,situacion: rec.get('codigoSituacion')
                                                ,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
                                                ,idTareaAsociada: rec.get('idTareaAsociada')
                                                ,idTarea:rec.get('id')
                                                ,tipoTarea:rec.get('tipoTarea')
                                }
                        });
                        w.on(app.event.CANCEL, function(){ 
                            w.close();
                        });
                        w.on(app.event.DONE, function(){
                            w.close();
                            tareasStore.webflow(paramsBusquedaInicial);
                            //Recargamos el arbol de tareas
                            app.recargaTree();
                        });
                        w.on(app.event.OPEN_ENTITY, function(){
                            w.close();
                            //Abre docadjunta del procedimiento
                            app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tabAdjuntosAsunto');
                        });
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
                w.on(app.event.DONE, function(){w.close();});
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
            case '700':
            case '701':
            case '99700':
            case '99701':
                var idTarea = rec.get('id');
                var w = app.openWindow({
                    flow: 'buzontareas/abreTarea'
                    ,width: 835
                    ,y:1 
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idTarea:idTarea, subtipoTarea:codigoSubtipoTarea}
                });
                w.on(app.event.OPEN_ENTITY, function(){
                	w.close();
                	if (rec.get('codigoEntidadInformacion') == '1'){
							app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
					}
					if (rec.get('codigoEntidadInformacion') == '9'){
							app.abreCliente(rec.get('idEntidad'), rec.get('descripcion'));
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
                w.on(app.event.DONE, function(){
                	w.close();
                	tareasStore.webflow(paramsBusquedaInicial); 
							//Recargamos el arbol de tareas
							app.recargaTree();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });
			break;
		case '26':
		// Notificacion sin respuesta
		var w = app.openWindow({
			flow : 'buzontareas/abreTarea'
			,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
			,width:400 
			,params : {
				 idTarea:rec.get('id')
                		,subtipoTarea:'26'
			}
		});		
		w.on(app.event.OPEN_ENTITY, function(){
						w.close();
						if (rec.get('codigoEntidadInformacion') == '3'){
							app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '5'){
							app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
						}			
					});
                w.on(app.event.DONE, function(){
                	w.close();
                	tareasStore.webflow(paramsBusquedaInicial); 
							//Recargamos el arbol de tareas
							app.recargaTree();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });
		break;
		
		case app.subtipoTarea.CODIGO_ACEPTACION_ACUERDO:
		case app.subtipoTarea.CODIGO_REVISION_ACUERDO_ACEPTADO:
		case app.subtipoTarea.CODIGO_ACUERDO_GESTIONES_CIERRE:
		case app.subtipoTarea.CODIGO_CUMPLIMIENTO_ACUERDO:
				app.abreAsuntoTab(rec.get('idEntidad'), rec.get('descripcion'),'acuerdos');
		break;
		
			// Por default abre una notificacion standard
			default:
				//Seleccionarmos por tipo de Categoria Tarea
				switch(categoriaTarea) {
				
					case app.categoriaSubTipoTarea.CATEGORIA_SUBTAREA_TOMA_DECISION:
						app.openTab(rec.get('descripcion'), 'procedimientos/consultaProcedimiento', {id:rec.get('idEntidad'),tarea:rec.get('id'),fechaVenc:rec.get('fechaVenc'),nombreTab:'decision'} , {id:'procedimiento'+rec.get('idEntidad'),iconCls:'icon_procedimiento'});
						//app.addFavorite(rec.get('idEntidad'), rec.get('descripcion'), app.constants.FAV_TIPO_PROCEDIMIENTO);
						break;
					case app.categoriaSubTipoTarea.CATEGORIA_SUBTAREA_ABRIR_TAREA_PROCEDIMIENTO:
						app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
						break;
					case app.categoriaSubTipoTarea.CATEGORIA_SUBTAREA_ABRIR_EXP:
						app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
						break;
						

					default:
				
					var w = app.openWindow({
							flow : 'tareas/consultaNotificacion'
							,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
							,width:400 
							,params : {
									idEntidad: rec.get('idEntidad')
									,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
									,descripcion: rec.get(nombreTareaField)
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
			<sec:authorize ifNotGranted="PERSONALIZACION-BCC">
				tareasNewCm.setHidden(13,false);
			</sec:authorize>
			<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
				tareasNewCm.setHidden(13,true);
			</sec:authorize>
			tareasNewCm.setHidden(12,false);
		</sec:authorize>
		
			
		
		
	}
	if(!eval(enEspera) && ("${codigoTipoTarea}" == "3")){
		//Listado de notificaciones
		//oculto las columnas [fecha vto,supervisor,gestor]
		tareasNewCm.setHidden(5,true);
		tareasNewCm.setHidden(8,true);
		tareasNewCm.setHidden(9,true);
		tareasNewCm.setColumnHeader(14,'<s:message code="tareas.listado.inicio" text="**inicio"/>');
	}
	if(eval(enEspera)){
		//Listado de tareas en espera
		//oculto columna supervisor
		tareasNewCm.setHidden(9,true);
		//cambia nombre de columna gestor a responsable
		tareasNewCm.setColumnHeader(9,'Responsable');
		//muestro columna tipo solicitud
		tareasNewCm.setHidden(6,false);
	}
	
	if(!(eval(enEspera) || ("${codigoTipoTarea}" == "3"))){
		//Listado de tareas
		//Muestro las columnas VR y VRV si lo permite el perfil
		<sec:authorize ifAllGranted="MOSTRAR_VR_TAREAS">
			<sec:authorize ifNotGranted="PERSONALIZACION-BCC">
				tareasNewCm.setHidden(13,false);
			</sec:authorize>
			<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
				tareasNewCm.setHidden(13,true);
			</sec:authorize>
			tareasNewCm.setHidden(12,false);
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
	
	mainPanel.getTopToolbar().add(buttonsLPanel);
	mainPanel.getTopToolbar().add('->');
	mainPanel.getTopToolbar().add(buttonsRPanel);
	page.add(mainPanel);
	
	Ext.onReady(function(){
		tareasStore.fireEvent('beforeload');
	});
	
	tareasStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
    });
	
	
	panelFiltros.collapse(true);
		
</fwk:page>
