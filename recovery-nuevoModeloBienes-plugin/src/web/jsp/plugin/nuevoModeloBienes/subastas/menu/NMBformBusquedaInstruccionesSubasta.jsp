<%@page import="es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta"%>
<%@page import="es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta"%>
<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

var formBusquedaInstruccionesSubasta=function(){

	var limit=25;	
		
	var txtIdSubasta = app.creaInteger('id', '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.codSubasta" text="**C�digo de la subasta" />', '${id}');
	 
	var txtNumAutos = app.creaText('numAutos', '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.numAutos" text="**N� Autos" />', '${numAutos}');
	

	<pfs:datefield name="txtFechaSolicitudDesdeLS" labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.fechaSolicitud" label="**Fecha solicitud" width="70"/>;
	
	txtFechaSolicitudDesdeLS.id = 'idTxtFechaSolicitudDesdeLS';		
	 
	var txtFechaSolicitudHastaLS = new Ext.ux.form.XDateField({
		name : 'txtFechaSolicitudHastaLS'
		,hideLabel:true
		,width:95
	});
	
	
	txtFechaSolicitudHastaLS.id = 'idTxtFechaSolicitudHastaLS';
	
	var txtFechaSolicitudLS = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'idTxtFechaSolicitudLS'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[txtFechaSolicitudDesdeLS]}
			,{layout:'form',items:[txtFechaSolicitudHastaLS]}
		]
		,autoWidth:true
	}); 	
	
	
	<pfs:datefield name="txtFechaAnuncioDesdeLS" labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.fechaAnuncio" label="**Fecha anuncio" width="70"/>;
	
	txtFechaAnuncioDesdeLS.id = 'idTxtFechaAnuncioDesdeLS';		
	 
	var txtFechaAnuncioHastaLS = new Ext.ux.form.XDateField({
		name : 'txtFechaAnuncioHastaLS'
		,hideLabel:true
		,width:95
	});
	
	txtFechaAnuncioHastaLS.id = 'idTxtFechaAnuncioHastaLS';
	
	var txtFechaAnuncioLS = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'idTxtFechaAnuncioLS'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[txtFechaAnuncioDesdeLS]}
			,{layout:'form',items:[txtFechaAnuncioHastaLS]}
		]
		,autoWidth:true
	});	
	
	
	<pfs:datefield name="txtFechaSenyalamientoDesdeLS" labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.fechaSenyalamiento" label="**Fecha se�alamiento" width="70"/>;
	
	txtFechaSenyalamientoDesdeLS.id = 'idTxtFechaSenyalamientoDesdeLS';		
	 
	var txtFechaSenyalamientoHastaLS = new Ext.ux.form.XDateField({
		name : 'txtFechaSenyalamientoHastaLS'
		,hideLabel:true
		,width:95
	});
	
	txtFechaSenyalamientoHastaLS.id = 'idTxtFechaSenyalamientoHastaLS';
	
	var txtFechaSenyalamientoLS = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'idTxtFechaSenyalamientoLS'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[txtFechaSenyalamientoDesdeLS]}
			,{layout:'form',items:[txtFechaSenyalamientoHastaLS]}
		]
		,autoWidth:true
	});	
	
		
	<pfs:ddCombo name="comboTasacionCompletada" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.tasacionCompletada" 
		label="**Tasaci�n completada" 	
		value="${idComboTasacionCompletada}" 
		dd="${ddSiNo}" />;
	
	<%-- 	
	<pfs:ddCombo name="comboEmbargo" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.embargo" 
		label="**Embargo" 	
		value="${idComboEmbargo}" 
		dd="${ddSiNo}" />;
	 --%>		
		
	<pfs:ddCombo name="comboInfLetradoCompleto" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.infLetradoCompleto" 
		label="**Inf. letrado completo" 	
		value="${idComboInfLetradoCompleto}" 
		dd="${ddSiNo}" />;	
		
	<pfs:ddCombo name="comboInstruccionesCompletadas" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.instruccionesCompletadas" 
		label="**Instrucciones completadas" 	
		value="${idComboInstruccionesCompletadas}" 
		dd="${ddSiNo}" />;				

	<pfs:ddCombo name="comboSubastaRevisada" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.subastaRevisada" 
		label="**Subasta revisada" 	
		value="${idComboSubastaRevisada}" 
		dd="${ddSiNo}" />;	

	<c:set var="estadoInicial" value="-1"/>		
	<c:forEach var="estadoL" items="${estadoLoteSubasta}">
		<c:if test="${estadoL.codigo eq 'PROPUESTA'}">
			<c:set var="estadoInicial" value="${estadoL.codigo}"/>
		</c:if>
	</c:forEach>

	var estadoInstrucciones=<app:dict value="${estadoLoteSubasta}" />;	
	var filtroEstadoInstrucciones = app.creaDblSelect(
		estadoInstrucciones
		,'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.estadoDeGestion" text="**Estado de gesti�n" />'
		,{
			id:'filtroEstadoInstruccionesLS'
		}
	);								
	filtroEstadoInstrucciones.setValue('${estadoInicial}');
	
	var txtTipoSubasta = app.creaMinMaxMonedaConId(
		'<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.filtros.tipoSubasta" text="**Tipo subasta" />', 
		'tipoSubasta',
		{width : 90, widthPanel : 350, widthFieldSet : 220}
	);	
	
	var txtTotalCargasAnteriores = app.creaMinMaxMonedaConId(
		'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.totalCargasAnteriores" text="**Total cargas anteriores" />', 
		'totalCargasAnteriores',
		{width : 90, widthPanel : 350, widthFieldSet : 220}
	);	

	var txtTotalImporteAdjudicado = app.creaMinMaxMonedaConId(
		'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.totalImporteAdjudicado" text="**Total importe adjudicado" />', 
		'totalImporteAdjudicado',
		{width : 90, widthPanel : 350, widthFieldSet : 220}
	);	
	
	
	// INICIO Estado de Gesti�n	*******************************************************   		   		   		
	var estadoDeGestion=<app:dict value="${estadoSubasta}" />;	
    var estadoDeGestionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : estadoDeGestion
	       ,root: 'diccionario'
	});	 			
	var filtroEstadoDeGestion = app.creaDblSelect(
		estadoDeGestion
		,'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.estadoDeGestion" text="**Estado de gesti�n" />'
		,{
			store:estadoDeGestionStore,
			id:'comboFiltroEstadoDeGestionLS'
		}
	);								
	
	// FIN Estado de Gesti�n	*******************************************************
	
	// INICIO Entidad		*******************************************************
	<pfs:ddCombo name="comboEntidad" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.entidad" 
		label="**Entidad" 	
		value="${descripcionComboEntidad}" 
		dd="${entidadAdjudicatariaPropietaria}" />;	
		
	var comboEntidadSeleccionado = function(){
	
		if (comboEntidad.data.diccionario[comboEntidad.selectedIndex].descripcion == 'BANKIA'){
			filtroTareasSubastaBankia.setVisible(true);
			filtroTareasSubastaSareb.setVisible(false);			
		}
		else if (comboEntidad.data.diccionario[comboEntidad.selectedIndex].descripcion == 'SAREB'){
			filtroTareasSubastaBankia.setVisible(false);
			filtroTareasSubastaSareb.setVisible(true);		
		}
		else{
			filtroTareasSubastaBankia.setVisible(false);
			filtroTareasSubastaSareb.setVisible(false);		
		}
	}		
		
	comboEntidad.on('select',comboEntidadSeleccionado);			
	// FIN Entidad			*******************************************************		
		
	// INICIO HITOS ACTUALES		*****************************************************************		
	// INICIO Hito Actual de Bankia ***************************************************				
	var tareasSubastaBankia=<app:dict value="${tareasSubastaBankia}" />;
		
    var tareasSubastaBankiaStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : tareasSubastaBankia
	       ,root: 'diccionario'
	}); 	
	var cfgTareasSubastaBankia = {
		store:tareasSubastaBankiaStore,
		id:'comboFiltroTareasSubastaBankiaLS'
	};
	var filtroTareasSubastaBankia = app.creaDblSelect(
		tareasSubastaBankia,
		'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.tareasSubastaBankia" text="**Hito actual" />'
		,cfgTareasSubastaBankia
	);	
	
	recargarTareasSubastaBankia = function(){	
		app.resetCampos([filtroTareasSubastaBankia]);
	};	
	// FIN Hito Actual de Bankia ******************************************************
	
	// INICIO Hito Actual de Sareb ****************************************************
	var tareasSubastaSareb=<app:dict value="${tareasSubastaSareb}" />;	
    var tareasSubastaSarebStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : tareasSubastaSareb
	       ,root: 'diccionario'
	}); 
			
	var cfgTareasSubastaSareb = {
		store:tareasSubastaSarebStore,
		id:'comboFiltroTareasSubastaSarebLS'
	};	
	
	var filtroTareasSubastaSareb = app.creaDblSelect(
		tareasSubastaSareb,
		'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.tareasSubastaSareb" text="**Hito actual" />',
		cfgTareasSubastaSareb
	);	
	
	recargarTareasSubastaSareb = function(){	
		app.resetCampos([filtroTareasSubastaSareb]);
	};	
	// FIN Hito Actual de Sareb *******************************************************
	
	//Para empezar oculta las tareas de Bankia y Sareb
	filtroTareasSubastaBankia.setVisible(false);
	filtroTareasSubastaSareb.setVisible(false);			
	// FIN HITOS ACTUALES			*****************************************************************
	
	//Situar los botones
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;		
	
	
<%-- ************************* PESTA�A 1 Datos de Subasta *************************************** --%>
	var pestanyaSubasta=false;	
	var filtrosTabDatosSubasta = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosSubasta" text="Datos de Subasta" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtNumAutos,txtFechaSolicitudLS,txtFechaAnuncioLS,txtFechaSenyalamientoLS,comboTasacionCompletada
					//,comboEmbargo
					,comboInfLetradoCompleto,comboInstruccionesCompletadas]
				},{
					layout:'form'
					,items: [comboSubastaRevisada,txtTipoSubasta.panel,txtTotalCargasAnteriores.panel,txtTotalImporteAdjudicado.panel,filtroEstadoDeGestion,filtroEstadoInstrucciones
					<%--,comboEntidad,filtroTareasSubastaBankia,filtroTareasSubastaSareb --%>
					]
				}]
	});
	filtrosTabDatosSubasta.on('activate',function(){
		pestanyaSubasta=true;
	});	

<%-- ************************* PESTA�A 2 Cliente *************************************** --%>	

	var tiposPersona = <app:dict value="${tiposPersona}" blankElement="true" blankElementValue="" blankElementText="---" />;

    var comboTipoPersona = app.creaCombo({
		data:tiposPersona
    	,name : 'tipopersona'
    	,fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipopersona" text="**Tipo Persona" />' <app:test id="comboTipoPersona" addComa="true" />
		,width : 175
    });
	
	var filtroCodCli = app.creaInteger('codigoCliente', '<s:message code="menu.clientes.listado.filtro.codigoCliente" text="**N� Cliente" />', '${codigoCliente}');
	
	var filtroNombre = app.creaText('nombre', '<s:message code="menu.clientes.listado.filtro.nombre" text="**Nombre" />', '${nombre}');
	
	var filtroApellidos = app.creaText('apellidos', '<s:message code="menu.clientes.listado.filtro.apellidos" text="**Apellidos" />', '${apellidos}'); 
    
	var filtroNif = app.creaText('nif', '<s:message code="menu.clientes.listado.filtro.nif" text="**Nro. Documento" />', '${nif}'); 
    
	
	var pestanyaCliente=false;
	var filtrosTabCliente = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosCliente" text="Cliente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroCodCli, filtroNombre, filtroApellidos]
				},{
					layout:'form'
					,items: [filtroNif, comboTipoPersona]
				}]
	});
	filtrosTabCliente.on('activate',function(){
		pestanyaCliente=true;
	});	
	
<%-- ************************* PESTA�A 3 Contrato *************************************** --%>	
		
	var txtContrato = app.creaText('contrato1', '<s:message code="listadoContratos.numContrato" text="**Num. Contrato" />'); 

	var txtCodRecibo = app.creaText('codRecibo', '<s:message code="listadoContratos.codigoRecibo" text="**Cod. recibo" />'); 

	var txtCodEfecto = app.creaText('codEfecto', '<s:message code="listadoContratos.codigoEfecto" text="**Cod. efecto" />'); 

	var txtCodDisposicion = app.creaText('codDisposicion', '<s:message code="listadoContratos.codigoDisposicion" text="**Cod. disposici�n" />');	

	var dictEstados= <app:dict value="${estadosContrato}" />;

	var comboEstadoContrato = app.creaDblSelect(dictEstados, '<s:message code="listadoContratos.estado" text="**Estado" />',{width:220});
		
	//diccionario de tiposProducto
	var diccTiposProducto = 
		<json:object>
			<json:array name="diccionario" items="${tiposProductoEntidad}" var="d">	
			 <json:object>
			   <json:property name="codigo" value="${d.codigo}" />
			   <json:property name="descripcion" value="(${d.codigo}) ${d.descripcion}" />
			 </json:object>
			</json:array>
		</json:object>;

    var comboTiposProducto = app.creaDblSelect(diccTiposProducto
            ,'<s:message code="menu.clientes.listado.filtro.tiposProducto" text="**Tipo de Producto" />'
            ,{
            	height: 180
               	,width:220
           	});		
		
	var pestanyaContrato=false;	
	var filtrosTabContrato = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosContrato" text="Contrato" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtContrato,txtCodRecibo,txtCodEfecto,txtCodDisposicion]
				},{
					layout:'form'
					,items: [comboEstadoContrato,comboTiposProducto]
				}]
	});
	filtrosTabContrato.on('activate',function(){
		pestanyaContrato=true;
	});	
	
	
<%-- ************************* PESTA�A 4 Jerarqu�a *************************************** --%>	

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

	var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	}

    recargarComboZonas();

    comboJerarquia.on('select',recargarComboZonas);

	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, /*funcionReset:recargarComboZonas,*/ width:160});

	var comboJerarquiaAdministrativa = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name : 'jerarquia', fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquiaAdministrativa" text="**Jerarquia administrativa" />'});
	
 	var zonasAdmRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);

    var optionsZonasAdmStore = page.getStore({
	       flow: 'clientes/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasAdmRecord)
	       
	});

	var recargarComboZonasAdm = function(){
		if (comboJerarquiaAdministrativa.getValue()!=null && comboJerarquiaAdministrativa.getValue()!=''){
			optionsZonasAdmStore.webflow({id:comboJerarquiaAdministrativa.getValue()});
		}else{
			optionsZonasAdmStore.webflow({id:0});
		}
	}

    recargarComboZonasAdm();

    comboJerarquiaAdministrativa.on('select',recargarComboZonasAdm);
    
	var comboZonasAdm = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centroAdministrativo" text="**Centro administrativo" />',{store:optionsZonasAdmStore, /*funcionReset:recargarComboZonasAdm,*/ width:160});
	
	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
	}
	
	comboJerarquia.on('select',limpiarYRecargar);

	var pestanyaJerarquia=false;
	var filtrosTabJerarquia = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosJerarquia" text="Jerarqu�a" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboJerarquia,comboZonas]
				},{
					layout:'form'
					,items: [comboJerarquiaAdministrativa,comboZonasAdm]
				}]
	});			
	filtrosTabJerarquia.on('activate',function(){
		pestanyaJerarquia=true;
	});	
	
<%-- ************** PESTA�A 5 ASUNTOS ******************************************************** --%>
	//Listado de Gestiones, viene del flow
	var dictPropiedades = <app:dict value="${propiedades}" blankElement="true" blankElementValue="" blankElementText="---"/>;

	//store generico de combo diccionario
	var optionsPropiedadesStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictPropiedades
	});

	//Campo Combo propiedad Asunto
	var comboPropiedades = new Ext.form.ComboBox({
		store:optionsPropiedadesStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,editable:false
		,emptyText:"---"
		,triggerAction: 'all'
		,fieldLabel:'<s:message code="asuntos.busqueda.filtro.propiedad" text="**Propiedad"/>'
		<app:test id="comboPropiedades" addComa="true"/>
	});
	
	//Listado de Gestiones, viene del flow
	var dictGestion = <app:dict value="${gestiones}" blankElement="true" blankElementValue="" blankElementText="---"/>;

	//store generico de combo diccionario
	var optionsGestionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictGestion
	});

	//Campo Combo gestion Asunto
	var comboGestion = new Ext.form.ComboBox({
		store:optionsGestionStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,editable:false
		,emptyText:"---"
		,triggerAction: 'all'
		,fieldLabel:'<s:message code="asuntos.busqueda.filtro.gestion" text="**Gestion"/>'
		<app:test id="comboGestion" addComa="true"/>
	});	
	

	var codPlaza = '';
	var decenaInicio = 0;
	var dsplazas = new Ext.data.Store({
		autoLoad: false,
		baseParams: {limit:10, start:0},
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('plugin/busquedaProcedimientos/plugin.busquedaProcedimientos.plazasPorDescripcion')
		}),
		reader: new Ext.data.JsonReader({
			root: 'plazas'
			,totalProperty: 'total'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	
	var filtroPlaza = new Ext.form.ComboBox ({
		store:  dsplazas,
		allowBlank: true,
		blankElementText: '--',
		disabled: false,
		displayField: 'descripcion', 	// descripcion
		valueField: 'codigo', 		// codigo
		fieldLabel: '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.filtros.plazaJuzgado" text="**Plaza de Juzgado" />',		// Pla de juzgado
		loadingText: 'Searching...',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});	
	
	
	<%--c:if test="${filtroPlaza.value!=null}">
		codPlaza='${filtroPlaza.value}';
	</c:if --%>	
		
	Ext.onReady(function() {
		decenaInicio = 0;
		if (codPlaza!=''){
			Ext.Ajax.request({
					url: page.resolveUrl('plugin/busquedaProcedimientos/plugin.plazosExterna.plazasPorCod')
					,params: {codigo: codPlaza}
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText)
						decenaInicio = (r.paginaParaPlaza);
						dsplazas.baseParams.start = decenaInicio;	
						filtroPlaza.store.reload();
						dsplazas.on('load', function(){  
							filtroPlaza.setValue(codPlaza);
							dsplazas.events['load'].clearListeners();
						});
					}				
			});
		}
	});
	filtroPlaza.on('afterrender', function(combo) {
		combo.mode='remote';
	});
		
		
	var idTipoJuzgadoRecord = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var idTipoJuzgadoStore = page.getStore({
		flow:'plugin.busquedaProcedimientos.buscarJuzgadosPlaza'
		,reader: new Ext.data.JsonReader({
			idProperty: 'codigo'
			,root:'juzgado'
		},idTipoJuzgadoRecord)
	});
	
	var filtroJuzgado =new Ext.form.ComboBox({
		store: idTipoJuzgadoStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.filtros.juzgado" text="**Juzgado" />'
		,width:250
		,value:''
		
	});	
	
	var recargarIdTipoJuzgado = function(){
		filtroJuzgado.store.removeAll();
		filtroJuzgado.clearValue();
		if (filtroPlaza.getValue()!=null && filtroPlaza.getValue()!=''){
			idTipoJuzgadoStore.webflow({codigo:filtroPlaza.getValue()});
		}
		
	}
	
	filtroPlaza.on('select', function(){
		recargarIdTipoJuzgado();
		filtroJuzgado.setDisabled(false);
	});


	var pestanyaAsunto=false;	
	var filtrosTabAsunto = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosAsunto" text="**Asunto" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboPropiedades, comboGestion]
				},{
					layout:'form'
					,items: [filtroPlaza, filtroJuzgado]
				}]
	});
	filtrosTabAsunto.on('activate',function(){
		pestanyaAsunto=true;
	});		



<%-- ************** PESTA�A 6 BIENES ******************************************************** --%>

	var txtNumActivo = app.creaText('numActivo', '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.filtros.numActivo" text="**Num. Activo" />'); 
	var txtFincaRegistral = app.creaText('fincaRegistral', '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.filtros.fincaRegistral" text="**Finca Registral" />'); 

	var pestanyaBienes=false;	
	var filtrosTabBienes = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosBienes" text="**Bienes" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtNumActivo, txtFincaRegistral]
				}]
	});
	filtrosTabBienes.on('activate',function(){
		pestanyaBienes=true;
	});		
		
<%-- *************TABPANEL QUE CONTIENE TODAS LAS PESTA�AS********************************   --%>
	
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosSubasta, filtrosTabCliente, filtrosTabContrato, filtrosTabJerarquia,filtrosTabAsunto,filtrosTabBienes]
		,id:'idTabFiltrosSubastaLS'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});		
			

<%-- **************************** PANEL QUE CONTIENE EL PANEL DE PESTA�AS******************** --%>
	
	var panelFiltros = new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,title : '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.FiltrosTitulo" text="Buscador de Subastas" />'
		,titleCollapse:true
		,collapsible:true
        ,collapsed: true
		,tbar : [buttonsL,'->', buttonsR]
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,style:'padding-bottom:10px; padding-right:10px;'
		,items:[{items:[{
						layout:'form'
						,items:[
								filtroTabPanel
							   ]
					   }]	
				}]
		,listeners:{	
			beforeExpand:function(){
				subastasGrid.setHeight(125);
				}
			,beforeCollapse:function(){
				subastasGrid.setHeight(435);
				subastasGrid.expand(true);			
			}
		}
	});
	
	var getValorComboSiNo=function(valor){	
		if (valor=="1"){
			return "1";
		}
		else if (valor=="2"){
			return "0";
		}
		else{
			return "";
		}
	}
	
	var recargarEstadoDeGestion = function(){	
		/*	
		if (filtroEstadoDeGestion.getValue()!=null && filtroEstadoDeGestion.getValue()!=''){
			estadoDeGestionStore.webflow({filtroEstadoDeGestion()});
		}
		else{
			estadoDeGestionStore.webflow({id:0});
		}
		*/		
	};
		
	recargarEstadoDeGestion();
    
    var limpiarYRecargarEstadoDeGestion = function(){
		app.resetCampos([filtroEstadoDeGestion]);
		recargarEstadoDeGestion();
	}
	
	filtroEstadoDeGestion.on('select',limpiarYRecargarEstadoDeGestion);	
	
	//Funci�n que le env�a los datos al DTO
	var getParametros=function(){	
		var b = {};

		if (pestanyaSubasta){		
			b.id = txtIdSubasta.getValue();
			
			b.numAutos = txtNumAutos.getValue();
			
			b.fechaSolicitudDesde = idTxtFechaSolicitudDesdeLS.value;
			b.fechaSolicitudHasta = idTxtFechaSolicitudHastaLS.value;	
	
			b.fechaAnuncioDesde = idTxtFechaAnuncioDesdeLS.value;
			b.fechaAnuncioHasta = idTxtFechaAnuncioHastaLS.value;
			
			b.fechaSenyalamientoDesde = idTxtFechaSenyalamientoDesdeLS.value;
			b.fechaSenyalamientoHasta = idTxtFechaSenyalamientoHastaLS.value;
	
			b.idComboTasacionCompletada=getValorComboSiNo(comboTasacionCompletada.getValue());	
						
			//b.idComboEmbargo=getValorComboSiNo(comboEmbargo.getValue());
			
			b.idComboInfLetradoCompleto=getValorComboSiNo(comboInfLetradoCompleto.getValue());
			
			b.idComboInstruccionesCompletadas=getValorComboSiNo(comboInstruccionesCompletadas.getValue());
			
			b.idComboSubastaRevisada=getValorComboSiNo(comboSubastaRevisada.getValue());		
		
			if (comboFiltroEstadoDeGestionLS!=""){
				b.comboFiltroEstadoDeGestion = comboFiltroEstadoDeGestionLS.childNodes[1].value;
			}
			else{
				b.comboFiltroEstadoDeGestion = "";
			}
			
			if (comboEntidad.selectedIndex>0){
				debugger;
				var entidadSeleccionada = '';
				if (comboEntidad.value==3){
					entidadSeleccionada = 'BANKIA';
				}
				else if (comboEntidad.value==4){
					entidadSeleccionada = 'SAREB';
				}
				else{
					entidadSeleccionada = '';
				}
				
				if (entidadSeleccionada == 'BANKIA'){
					b.idComboEntidad = "BANKIA";
					b.comboFiltroTareasSubastaSareb = "";
					b.comboFiltroTareasSubastaBankia = comboFiltroTareasSubastaBankiaLS.childNodes[1].value;
				}
				else if (entidadSeleccionada == 'SAREB'){
					b.idComboEntidad = "SAREB";
					b.comboFiltroTareasSubastaBankia = "";
					b.comboFiltroTareasSubastaSareb = comboFiltroTareasSubastaSarebLS.childNodes[1].value;
				}
				else{
					b.idComboEntidad = "";
					b.comboFiltroTareasSubastaBankia = "";
					b.comboFiltroTareasSubastaSareb = "";
				}		 
			}
			else{
				b.idComboEntidad = "";
				b.comboFiltroTareasSubastaBankia = "";
				b.comboFiltroTareasSubastaSareb = "";				
			}
						
			b.totalCargasAnterioresDesde = idmintotalCargasAnteriores.value;
			b.totalCargasAnterioresHasta = idmaxtotalCargasAnteriores.value;					
						
			b.totalImporteAdjudicadoDesde = idmintotalImporteAdjudicado.value;
			b.totalImporteAdjudicadoHasta = idmaxtotalImporteAdjudicado.value;
			
			b.tipoSubastaDesde = idmintipoSubasta.value;			
			b.tipoSubastaHasta = idmaxtipoSubasta.value;

			b.idEstadoInstrucciones = filtroEstadoInstrucciones.getValue();
			limit = (b.idEstadoInstrucciones=='<c:out value="${estadoInicial}"/>') ? 1000 : 25;
		}
		
		if (pestanyaCliente){	
			b.tipoPersona=comboTipoPersona.getValue();
	    	b.nombre=filtroNombre.getValue();
	    	b.apellidos=filtroApellidos.getValue();
			b.nif=filtroNif.getValue();
			b.codigoCliente=filtroCodCli.getValue();		
		}

       	if (pestanyaContrato){
       		b.nroContrato=txtContrato.getValue();
       		b.stringEstadosContrato=comboEstadoContrato.getValue();
       		b.tiposProductoEntidad=comboTiposProducto.getValue();
       		b.codRecibo=txtCodRecibo.getValue();
       		b.codEfecto=txtCodEfecto.getValue();
       		b.codDisposicion=txtCodDisposicion.getValue();			
       	}

		if (pestanyaJerarquia){
        		b.codigoZona=comboZonas.getValue();
    			b.jerarquia=comboJerarquia.getValue();
    			b.codigoZonaAdm =comboZonasAdm.getValue();
    			b.jerarquiaAdm=comboJerarquiaAdministrativa.getValue();		
		}
		
		if (pestanyaAsunto) {
			b.gestion = comboGestion.getValue();
			b.propiedad = comboPropiedades.getValue();
			b.idPlazaJuzgado = filtroPlaza.getValue();
			b.idJuzgado = filtroJuzgado.getValue();
		}

		if (pestanyaBienes) {
			b.numeroActivo = txtNumActivo.getValue();
			b.fincaRegistral = txtFincaRegistral.getValue();
		}

		return b;	
	}
		
	//Funci�n que limpia los filtros de las pesta�as
	resetFiltros = function(){
		
		//Pesta�a Subasta ***********************************
		txtIdSubasta.reset();
		txtNumAutos.reset();
		
		idTxtFechaSolicitudDesdeLS.value="";
		idTxtFechaSolicitudHastaLS.value="";

		idTxtFechaAnuncioDesdeLS.value="";
		idTxtFechaAnuncioHastaLS.value="";	

		idTxtFechaSenyalamientoDesdeLS.value="";
		idTxtFechaSenyalamientoHastaLS.value="";			
		
		comboTasacionCompletada.reset();
		
		//comboEmbargo.reset();
		
		comboInfLetradoCompleto.reset();
		
		comboInstruccionesCompletadas.reset();
		
		comboSubastaRevisada.reset();						

		limpiarYRecargarEstadoDeGestion();
		//comboFiltroEstadoDeGestionLS.reset();
		filtroEstadoDeGestion.reset();

		recargarTareasSubastaBankia();
		recargarTareasSubastaSareb();
		filtroTareasSubastaBankia.setVisible(false);
		filtroTareasSubastaSareb.setVisible(false);
		
		comboEntidad.selectedIndex=0;
		comboEntidad.reset();
		
		idmintotalCargasAnteriores.value="";
		idmaxtotalCargasAnteriores.value="";
		
		idmintotalImporteAdjudicado.value="";
		idmaxtotalImporteAdjudicado.value="";

		filtroTareasSubastaBankia.reset();
		filtroTareasSubastaSareb.reset();

		idmintipoSubasta.value = "";			
		idmaxtipoSubasta.value = "";
		//filtroEstadoInstrucciones.reset();
		app.resetCampos([filtroEstadoInstrucciones]);
		
		//Pesta�a Cliente ***********************************			
		comboTipoPersona.reset();
    	filtroNombre.reset();
    	filtroApellidos.reset();
		filtroNif.reset();		
		filtroCodCli.reset();					
		
		//Pesta�a Contrato ***********************************
       	txtContrato.reset();
       	comboEstadoContrato.reset();
       	comboTiposProducto.reset();
       	txtCodRecibo.reset();
       	txtCodEfecto.reset();
       	txtCodDisposicion.reset();	
       	
       	//Pesta�a Jerarqu�a ***********************************
  		comboZonas.reset();
		comboJerarquia.reset();
		optionsZonasStore.webflow({id:0});
		comboZonasAdm.reset();
		comboJerarquiaAdministrativa.reset();
		optionsZonasAdmStore.webflow({id:0});
		
		//Pesta�a Asunto **************************************
		comboGestion.reset();
		comboPropiedades.reset();	
		filtroJuzgado.reset();
		filtroPlaza.reset();

		//Pestaña Bienes **************************************
		txtNumActivo.value="";
		txtFincaRegistral.value="";
	}
		

	
<%-- **************************** PANEL INFERIOR (RESULTADO DE LA B�SQUEDA): SUBASTAS ******************** --%>																												

	var getParametrosEstado = function(codEstado) {
		var selModel = subastasGrid.getSelectionModel()
		var selections = selModel.getSelections();
		var sel = '';							
		var parametros = {
			idLotes : []
			,codEstado : codEstado
		};
		for (i = 0; i <= selModel.getCount()-1; i++) {
			parametros.idLotes.push(selections[i].json.idLote);
		}
		return parametros;
	}	
	
	var btnAprobar = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.boton.aprobar" text="**Aprobar" />'
			,iconCls : 'icon_edit'
			,handler : function(){ 
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.boton.aprobar.confirm" text="**�La acción maracará como aceptada la instrucciones y continuará con el flujo. ¿Desea continuar?" />' 
					,function(boton){
						if (boton=='yes') {
			      			page.webflow({
				      			flow:'subasta/guardarEstadoLotesSubasta'
				      			,params: getParametrosEstado('<%=DDEstadoLoteSubasta.APROBADA %>')
				      			,success: function(){
			            		   page.fireEvent(app.event.DONE);
			            		   subastasStore.webflow(getParametros());
			            		}	
				      		});
						}
					}, this);
			}
		});
	var btnDevolver = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.boton.devolver" text="**Devolver" />'
			,iconCls : 'icon_edit'
			,handler : function(){ 
					var w= app.openWindow({
								flow: 'subasta/editarObservacionesLotesSubasta'
								,params : getParametrosEstado('<%=DDEstadoLoteSubasta.DEVUELTA %>')
								,closable: true
								,width : 850
								,title : '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.boton.devolver.titulo" text="**Devolver instrucciones de lote de subasta" />'
					});
					w.on(app.event.DONE, function(){
								w.close();
								subastasStore.webflow(getParametros());
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
					 }
		});
	var btnSuspender = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.boton.suspender" text="**Suspender" />'
			,iconCls : 'icon_edit'
			,handler : function(){ 
					var w= app.openWindow({
								flow: 'subasta/editarObservacionesLotesSubasta'
								,params : getParametrosEstado('<%=DDEstadoLoteSubasta.SUSPENDIDA %>')
								,closable: true
								,width : 850
								,title : '<s:message code="plugin.nuevoModeloBienes.busquedaLotesSubastas.boton.suspender.titulo" text="**Suspender instrucciones de lote de subasta" />'
					});
					w.on(app.event.DONE, function(){
								w.close();
								subastasStore.webflow(getParametros());
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
					 }
		});
							
	var subasta = Ext.data.Record.create([
		 {name:'idLote'}
		 ,{name:'idSubasta'}
		 ,{name:'idAsunto'}
		 ,{name:'nombreAsunto'}
		 ,{name:'operacion'}
		 ,{name:'fechaSubasta'}
		 ,{name:'oficina'}
		 ,{name:'centro'}
		 ,{name:'tipoSubasta'}
		 ,{name:'valorSubasta'}
		 ,{name:'deudaJudicial'}
		 ,{name:'pujaSin'}
		 ,{name:'pujaConDesde'}
		 ,{name:'pujaConHasta'}
		 ,{name:'numActivos'}
		 ,{name:'tasacion'}
		 ,{name:'riesgoConsignacion'}
		 ,{name:'cargas'}
		 ,{name:'estado'}
		 ,{name:'estadoCodigo'}
	]);				

	var subastasStore = page.getStore({
		 flow: 'subasta/buscarLotesSubasta' 
		,limit: limit
		,remoteSort: true
		,reader: new Ext.data.JsonReader({
	    	 root : 'lotes'
	    	,totalProperty : 'total'
	     }, subasta)
	});	
	
	subastasStore.on('load', function() {
		pagingBar.show();
		debugger;
	    var match = this.find('estadoCodigo','<%=DDEstadoLoteSubasta.PROPUESTA %>');
	    var ocultar = (match == -1);
		subastasGrid.getColumnModel().setHidden(0, ocultar);
	});		
	
	var OK_KO_Render = function (value, meta, record) {	
		if (value) {
			return '<img src="/pfs/css/true.gif" height="16" width="16" alt=""/>';
		} else {
			return '<img src="/pfs/css/false.gif" height="16" width="16" alt=""/>';
		}
	};
	
	var SI_NO_Render = function (value, meta, record) {
		if (value) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		} if (value=='NO' ) {
			return '<s:message code="label.no" text="**No;" />';
		}if (value=='01' ) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		} if (value=='02' ) {
			return '<s:message code="label.no" text="**No;" />';
		}if (value==true ) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		}else {
			return '<s:message code="label.no" text="**No" />';
		}
	};
	
	var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly : true
		,singleSelect: false
        ,listeners: {
            selectionchange: function(sel) {
            	var seleccionados = sel.getCount(); 
               	btnSuspender.setDisabled(!seleccionados);
               	btnDevolver.setDisabled(!seleccionados);
               	btnAprobar.setDisabled(!seleccionados);
            }
         }
		,renderer : function(v,p,record) {
			// First condition : show
			if (record.data.estadoCodigo == '<%=DDEstadoLoteSubasta.PROPUESTA %>') return '<div class="x-grid3-row-checker">&nbsp;</div>';
			// else hide 
			else return '';
		}
	});
	
	//Listado de resultados de la parte inferior de la pantalla
	var subastasCm = new Ext.grid.ColumnModel([	    
		sm,
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.operacion" text="**Operacion"/>', width: 180, dataIndex : 'operacion'},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.fechaSenyalamiento" text="**Fecha"/>', width: 80, dataIndex : 'fechaSubasta', sortable: true},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.oficina" text="**oficina"/>', width: 60, dataIndex : 'oficina'},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.centro" text="**centro"/>', width: 60, dataIndex : 'centro'},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.valorSubasta" text="**Valor de la subasta"/>', width: 120,  dataIndex: 'valorSubasta', sortable: true, renderer: app.format.moneyRenderer, align:'right'},
	    {header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.deudaJudicial" text="**Deuda Judicial"/>', width: 180,  dataIndex: 'deudaJudicial', sortable: true, renderer: app.format.moneyRenderer, align:'right' },
	    {header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.pujaSinPostores" text="**Puja sin postores"/>', width: 180,  dataIndex: 'pujaSin', sortable: true, renderer: app.format.moneyRenderer, align:'right' },
	    {header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.pujaConPostoresDesde" text="**Puja con postores desde"/>', width: 120,  dataIndex: 'pujaConDesde', sortable: true, renderer: app.format.moneyRenderer, align:'right'},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.pujaConPostoresHasta" text="**Puja con postores hasta"/>', width: 120, dataIndex: 'pujaConHasta', sortable: true, renderer: app.format.moneyRenderer, align:'right'},

		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.numActivos" text="**Num Activos"/>', width: 80,  dataIndex: 'numActivos', sortable: false},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.tasacionActiva" text="**Tasación Activa"/>', width: 120, dataIndex: 'tasacion', sortable: true, renderer: app.format.moneyRenderer, align:'right'},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.riesgoConsignacion" text="**Riesgo Consignación"/>', width: 40,  dataIndex: 'riesgoConsignacion', sortable: true, renderer: SI_NO_Render},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.cargas" text="**Cargas"/>', width: 40,  dataIndex: 'cargas', sortable: true, renderer: SI_NO_Render},
		{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.estadoLote" text="**Estado"/>', width: 135, dataIndex: 'estado', sortable: true}
		]);
	
	var pagingBar=fwk.ux.getPaging(subastasStore);
    var subastasGrid = new Ext.grid.EditorGridPanel({
        store: subastasStore
        ,cm: subastasCm
        ,title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tituloGrid" text="Subastas"/>'
        ,stripeRows: true
        ,autoHeight:true
        ,resizable:true
        ,collapsible : true
        ,titleCollapse : true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,iconCls : 'icon_bienes'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,clicksToEdit:1
		,selModel: sm
		,bbar : [pagingBar,btnAprobar,btnDevolver,btnSuspender]
		,renderer: function (value, metadata, record) {
	        /*if (record.get('price') < 50) {
	            grid.columns[0].items[0].icon = 'http://dl.dropbox.com/u/14161146/ddt/green_circle.png';
	        } else {
	            grid.columns[0].items[0].icon = 'http://dl.dropbox.com/u/14161146/ddt/red_circle.png';
	        }*/
	    }
 
    });

	subastasGrid.on('load', function(){
		subastasGrid.setTitle('<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tituloGrid" text="Subastas" arguments="'+subastasStore.getTotalCount()+'"/>');
		panelFiltros.collapse(true);
	});	
	
	subastasGrid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var idSubasta=rec.get('idSubasta');
    	var idAsunto=rec.get('idAsunto');
    	var nombreAsunto=rec.get('nombreAsunto');
    	if (idAsunto!=null && idSubasta != null){
    		app.abreAsuntoTab(
    			idAsunto
	    		,nombreAsunto
	    		,{id: idAsunto, nombreTab: 'tabSubastas',idSubasta: idSubasta}
    		);
    	}
    });
	
	//PANEL PRINCIPAL ********************************************************************
	var mainPanel = new Ext.Panel({
		items : [
			 panelFiltros
			,subastasGrid
    	]
	    ,bodyStyle:'padding:15px'
	    ,autoHeight : true
	    ,border: false
    });

	btnSuspender.setDisabled(true);
	btnDevolver.setDisabled(true);
	btnAprobar.setDisabled(true);
	subastasStore.webflow({idEstadoInstrucciones: '<c:out value="${estadoInicial}"/>'});
	pagingBar.hide();
	return mainPanel;
}
