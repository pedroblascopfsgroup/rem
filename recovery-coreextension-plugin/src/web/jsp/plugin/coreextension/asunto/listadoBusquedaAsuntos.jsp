<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	
	var limit=25;
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
		

	
	//var tabs = <app:includeArray files="${tabsAsunto}" />;
	
	//Campo Código Asunto
	var codigoAsunto=app.creaNumber('codigo',
			'<s:message code="asuntos.busqueda.filtro.codigo" text="**Codigo Asunto" />','',{autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}<app:test id="idAsunto" addComa="true"/>});
	
	//Campo Nombre Asunto
	var nombre = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.nombre" text="**Nombre Asunto" />'
		,name:'nombre'
		<app:test id="nombreAsunto" addComa="true"/>
	});
	
	//Listado de despachos, viene del flow
	var dictDespachos = <app:dict value="${despachos}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	//store generico de combo diccionario
	var optionsDespachosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictDespachos
	});
	
	//Campo Combo Despacho
	var comboDespachos = new Ext.form.ComboBox({
				store:optionsDespachosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'---'
				,editable: false
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="asuntos.busqueda.filtro.despacho" text="**Despacho"/>'
				<app:test id="comboDespachos" addComa="true"/>
	});

	var gestores={diccionario:[]};
	
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

	var optionsSupervisoresStore = page.getStore({
	       flow: 'asuntos/buscarSupervisores'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	});

	optionsSupervisoresStore.webflow({});

	var recargarComboGestores = function(){
		if (comboDespachos.getValue()!=null && comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
		}else{
			optionsGestoresStore.webflow({id:0});
		}
	}
	

	
	//Campo Gestores, double select
	var comboGestor = app.creaDblSelect(gestores,'<s:message code="asuntos.busqueda.filtro.gestor" text="**Gestor" />',{store:optionsGestoresStore, funcionReset:recargarComboGestores <app:test id="comboGestores" addComa="true"/>});
		
	
	//Listado de Estados, viene del flow
	var dictEstados = <app:dict value="${estados}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store generico de combo diccionario
	var optionsEstadosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictEstados
	});

	//Campo Combo Estados
	var comboEstados = new Ext.form.ComboBox({
				store:optionsEstadosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="asuntos.busqueda.filtro.estado" text="**Estado"/>'
				<app:test id="comboEstados" addComa="true"/>
	});
	
	//Campo combo Supervisor VER STORE!!!!
	var comboSupervisor = new Ext.form.ComboBox({
				store:optionsSupervisoresStore
				,hiddenName:'comboSupervisor'
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="asuntos.busqueda.filtro.supervisor" text="**Supervisor"/>'
				<app:test id="comboSupervisores" addComa="true"/>
	});
	

	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarCombos = function(){
		if (comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
			comboGestor.enable();
		}else{
			//comboSupervisor.setValue('');
			optionsGestoresStore.removeAll();
		}
	}
	
	var bloquearCombos = function(){
		comboGestor.disable();
	}
	
	comboDespachos.on('focus',bloquearCombos);
	
	comboDespachos.on('change',recargarCombos);
	
	var limpiarYRecargarGestores = function(){
		app.resetCampos([comboGestor]);
		recargarComboZonas();
	}
	
	comboDespachos.on('select',limpiarYRecargarGestores);
	
	//Listado de Estados, viene del flow
	//var dictEstadosAnalisis = "";
	
	//var estadoAnalisis=app.creaDblSelect(dictEstadosAnalisis,'<s:message code="asuntos.busqueda.filtro.estadoanalisis" text="**Estado An&aacute;lisis" />'); 
	
	//var diasCreacion=app.creaNumber('diasCreacion','<s:message code="asuntos.busqueda.filtro.diascreacion" text="**Dias Creacion" />');;
	
	//Campo Saldo Total
	var saldoTotalContratos = app.creaMinMaxMoneda('<s:message code="asuntos.busqueda.filtro.saldtotal" text="**Saldo Total" />', 'saldoTotal',{width : 90, widthPanel : 350, widthFieldSet : 220});
	
	//Campo Importe Estimado
	var importeEstimado = app.creaMinMaxMoneda('<s:message code="asuntos.busqueda.filtro.importeestimado" text="**Importe Estimado" />', 'importeEstimado',{width : 90, widthPanel : 350, widthFieldSet : 220});

	
	var fechaCreacionDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.creaciondesde" text="**Desde" />'
		,name:'fechaCreacionDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaCreacionHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.creacionhasta" text="**Hasta" />'
		,name:'fechaCreacionHasta'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});

	/*var fieldSetFechas=new Ext.form.FieldSet({
		title:'<s:message code="asuntos.busqueda.filtro.diascreacion" text="**D&iacute;as Creacion" />'
		,autoHeight:true
		,width:250
		,items:[fechaCreacionDesde,fechaCreacionHasta]
	});*/

	//Combo número de contrato... debería ser TextField? Ver con el CU
	var filtroContrato =new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.contrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,maxLength:50 
		,autoCreate : {tag: "input", type: "text",maxLength:"50", autocomplete: "off"}
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
	});

	/*Jerarquía*/
	var zonas=<app:dict value="${zonas}" />;
	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name : 'jerarquia', fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});
	              
    var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'clientes/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});    
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas});
	/*Fin jerarquia*/
	
	var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
			comboZonas.setValue('');
			optionsZonasStore.removeAll();
		}
	}
	
	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
	
	recargarComboZonas();
	
	//Tipos de procedimiento
	var tipoProcedimientos=<app:dict value="${tipoProcedimientos}" />;
    comboTipoProcedimientos = app.creaDblSelect(tipoProcedimientos, '<s:message code="asuntos.busqueda.filtro.tipoActuacion" text="**Tipo de actuación" />');
	
	//Campo Nombre Asunto
	var codigoProcedimientoEnJuzgado = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.nroAuto" text="**Nº Auto" />'
		,name:'codigoProcedimientoEnJuzgado'
		<app:test id="nroAuto" addComa="true"/>
	});
	
	
	var validarEmptyForm = function(){

		if (codigoAsunto.getValue() != '' && app.validate.validateInteger(codigoAsunto.getValue())){
			return true;
		}
		if (nombre.getValue() != '' ){
			return true;
		}
		if (comboDespachos.getValue() != '' ){
			return true;
		}
		if (comboGestor.getValue() != '' ){
			return true;
		}
		if (comboEstados.getValue() != '' ){
			return true;
		}
		if (comboSupervisor.getValue() != '' ){
			return true;
		}
		/*if (estadoAnalisis.getValue() != '' ){
			return true;
		}*/
		if (saldoTotalContratos.min.getValue() != '' ){
			return true;
		}
		if (saldoTotalContratos.max.getValue() != '' ){
			return true;
		}
		if (importeEstimado.min.getValue() != '' ){
			return true;
		}
		if (importeEstimado.max.getValue() != '' ){
			return true;
		}
		if (filtroContrato.getValue() != '' ){
			return true;
		}
		if (fechaCreacionDesde.getValue() != '' ){
			return true;
		}
		if (fechaCreacionHasta.getValue() != '' ){
			return true;
		}
		if (comboJerarquia.getValue() != '' ){
			return true;
		}
		if (comboZonas.getValue() != '' ){
			return true;
		}			
		if (comboTipoProcedimientos.getValue() != '' ){
			return true;
		}			
		if (codigoProcedimientoEnJuzgado.getValue() != '' ){
			return true;
		}			
		return false;
			
	}
	
	var validaMinMax = function(){
		if (!app.validaValoresDblText(importeEstimado)){
			return false;
		}
		if (!app.validaValoresDblText(saldoTotalContratos)){
			return false;
		}
		return true;
	}

	var getParametros = function() {
		return {
			codigoAsunto: codigoAsunto.getValue()
			,nombre:nombre.getValue()
			,comboDespachos:comboDespachos.getValue()
			,comboGestor:comboGestor.getValue()
			,comboEstados:comboEstados.getValue()
			,comboSupervisor:comboSupervisor.getValue()
			//,estadoAnalisis:estadoAnalisis.getValue()
			,minSaldoTotalContratos:saldoTotalContratos.min.getValue()
			,maxSaldoTotalContratos:saldoTotalContratos.max.getValue()
			,minImporteEstimado:importeEstimado.min.getValue()
			,maxImporteEstimado:importeEstimado.max.getValue()
			,filtroContrato:filtroContrato.getValue()
			,fechaCreacionDesde:app.format.dateRenderer(fechaCreacionDesde.getValue())
			,fechaCreacionHasta:app.format.dateRenderer(fechaCreacionHasta.getValue())
			,jerarquia:comboJerarquia.getValue()
			,codigoZona:comboZonas.getValue()
			,tipoSalida:'<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.SALIDA_LISTADO" />'
			,codigoProcedimientoEnJuzgado:codigoProcedimientoEnJuzgado.getValue()
			,tipoProcedimiento:comboTipoProcedimientos.getValue()
			
		};
	};
	
	var buscarFunc = function()
	{
		if (validarEmptyForm()){
			if (validaMinMax()){
				panelFiltros.collapse(true);
				
				//Enviar los datos.
				asuntosStore.webflow(getParametros());
				botonesTabla.show();	
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
		}
	};
	
	var btnReset = app.crearBotonResetCampos([
		codigoAsunto
		,nombre
		,comboDespachos
		,comboGestor
		,comboEstados
		,comboSupervisor
		//,estadoAnalisis
		,saldoTotalContratos.min
		,saldoTotalContratos.max
		,importeEstimado.min
		,importeEstimado.max
		,filtroContrato
		,fechaCreacionDesde
		,fechaCreacionHasta
		,comboJerarquia
		,comboZonas
		,codigoProcedimientoEnJuzgado
		,comboTipoProcedimientos
		
	]);



	<c:if test="${usuario.usuarioExterno}">
		comboDespachos.disable(true);
		comboGestor.disable(true);
		comboSupervisor.disable(true);
		comboJerarquia.disable(true);
		comboZonas.disable(true);
	</c:if>

    var btnExportarXLS=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
                    var flow='asuntos/exportAsuntos';
					if (validarEmptyForm()){
						if (validaMinMax()){
		                    var params=getParametros();
							params.tipoSalida='<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.SALIDA_XLS" />';
		                    app.openBrowserWindow(flow,params);
						}else{
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
						}
					}else{
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
					}
                }
        }
    );

	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	var panelFiltros=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="asuntos.busqueda.filtros" text="**Filtro de Asuntos" />'
		,layoutConfig:{columns:2}
		,titleCollapse : true
		,collapsible:true
		,tbar : [btnBuscar,btnReset,btnExportarXLS,buttonsL, '->',buttonsR]
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				width:325
				,items:[codigoAsunto,nombre,comboEstados,saldoTotalContratos.panel,importeEstimado.panel,filtroContrato,fechaCreacionDesde,fechaCreacionHasta,codigoProcedimientoEnJuzgado
					//espacios en blanco para alinear ambas columnas
					,{border:false,html:'&nbsp;'},{border:false,html:'&nbsp;'}
				]
			},{
				width:440
				,items:[ comboSupervisor,comboDespachos,comboGestor,comboJerarquia,comboZonas,comboTipoProcedimientos]
			}
		]
		,listeners:{	
			beforeExpand:function(){
				gridAsuntos.setHeight(175);
			}
			,beforeCollapse:function(){
				gridAsuntos.setHeight(435);
			}
		}
	});

	var Asunto = Ext.data.Record.create([
		{name:'id'}
		,{name:'nombre'}
		,{name:'fcreacion'}
		,{name:'gestor'}
		,{name:'despacho'}	
		,{name:'supervisor'}
		,{name:'estado'}
		,{name:'saldototal'}	
	]);
	
	var asuntosStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,flow:'expedientes/listadoAsuntosData'
		,reader: new Ext.data.JsonReader({
			root: 'asuntos'
			,totalProperty : 'total'
		}, Asunto)
		,remoteSort : true
	});
	
	//asuntosStore.webflow({id:'1', idSesion:'1'});

	var asuntosCm = new Ext.grid.ColumnModel([
	{
		header: '<s:message code="asuntos.listado.codigo" text="**Codigo"/>',
		dataIndex: 'id', sortable: true
	}, {
		header: '<s:message code="asuntos.listado.nombreasunto" text="**Nombre"/>',
		dataIndex: 'nombre', sortable: true
	}, {
		header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion"/>',
		dataIndex: 'fcreacion', sortable: false
	}, {
		header: '<s:message code="asuntos.listado.estado" text="**Estado"/>',
		dataIndex: 'estado', sortable: false
	}, {
		header: '<s:message code="asuntos.listado.gestor" text="**Gestor"/>',
		dataIndex: 'gestor', sortable: false
	}, {
		header: '<s:message code="asuntos.listado.despacho" text="**Despacho"/>',
		dataIndex: 'despacho', sortable: false
	}, {
		header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor"/>',
		dataIndex: 'supervisor', sortable: false
	}, {
		header: '<s:message code="asuntos.listado.saldototal" text="**Saldo Total"/>'
		,dataIndex: 'saldototal'
		,renderer: app.format.moneyRenderer
		,align:'right'
		, sortable: false
	}
	]);
	
	var botonesTabla = fwk.ux.getPaging(asuntosStore);
	botonesTabla.hide();
	
	var gridAsuntos=app.crearGrid(asuntosStore,asuntosCm,{
		title: '<s:message code="asuntos.grid.titulo" text="**asuntos" />'	
		,style:'padding:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_asuntos'
		,height:175
		,bbar : [ botonesTabla  ]
		<app:test id="listaAsuntos" addComa="true"/>
	});
	
	gridAsuntos.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_asunto=rec.get('nombre');
    	var id=rec.get('id');
    	app.abreAsunto(id, nombre_asunto);
    });

	
	
	var mainPanel = new Ext.Panel({
		items : [
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[panelFiltros]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[gridAsuntos]
			}
    	]
	    //,bodyStyle:'padding:10px'
	    ,autoHeight : true
	    ,border: false
    });
	page.add(mainPanel);

</fwk:page>