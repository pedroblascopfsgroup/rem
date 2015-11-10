<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

var formBusquedaSubastas=function(){

	var limit=25;	
		
	var txtIdSubasta = app.creaInteger('id', '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.codSubasta" text="**Cï¿½digo de la subasta" />', '${id}');
	 
	var txtNumAutos = app.creaText('numAutos', '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.numAutos" text="**Nï¿½ Autos" />', '${numAutos}');
	

	<pfs:datefield name="txtFechaSolicitudDesde" labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.fechaSolicitud" label="**Fecha solicitud" width="70"/>;
	
	txtFechaSolicitudDesde.id = 'idTxtFechaSolicitudDesde';		
	 
	var txtFechaSolicitudHasta = new Ext.ux.form.XDateField({
		name : 'txtFechaSolicitudHasta'
		,hideLabel:true
		,width:95
	});
	
	
	txtFechaSolicitudHasta.id = 'idTxtFechaSolicitudHasta';
	
	var txtFechaSolicitud = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'idTxtFechaSolicitud'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[txtFechaSolicitudDesde]}
			,{layout:'form',items:[txtFechaSolicitudHasta]}
		]
		,autoWidth:true
	}); 	
	
	
	<pfs:datefield name="txtFechaAnuncioDesde" labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.fechaAnuncio" label="**Fecha anuncio" width="70"/>;
	
	txtFechaAnuncioDesde.id = 'idTxtFechaAnuncioDesde';		
	 
	var txtFechaAnuncioHasta = new Ext.ux.form.XDateField({
		name : 'txtFechaAnuncioHasta'
		,hideLabel:true
		,width:95
	});
	
	txtFechaAnuncioHasta.id = 'idTxtFechaAnuncioHasta';
	
	var txtFechaAnuncio = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'idTxtFechaAnuncio'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[txtFechaAnuncioDesde]}
			,{layout:'form',items:[txtFechaAnuncioHasta]}
		]
	});	
	
	
	<pfs:datefield name="txtFechaSenyalamientoDesde" labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.fechaSenyalamiento" label="**Fecha seï¿½alamiento" width="70"/>;
	
	txtFechaSenyalamientoDesde.id = 'idTxtFechaSenyalamientoDesde';		
	 
	var txtFechaSenyalamientoHasta = new Ext.ux.form.XDateField({
		name : 'txtFechaSenyalamientoHasta'
		,hideLabel:true
		,width:95
	});
	
	txtFechaSenyalamientoHasta.id = 'idTxtFechaSenyalamientoHasta';
	
	var txtFechaSenyalamiento = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'idTxtFechaSenyalamiento'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[txtFechaSenyalamientoDesde]}
			,{layout:'form',items:[txtFechaSenyalamientoHasta]}
		]
	});	
	
		
	<pfs:ddCombo name="comboTasacionCompletada" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.tasacionCompletada" 
		label="**Tasaciï¿½n completada" 	
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
	
	
	// INICIO Estado de Gestiï¿½n	*******************************************************   		   		   		
	var estadoDeGestion=<app:dict value="${estadoSubasta}" />;	
    var estadoDeGestionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : estadoDeGestion
	       ,root: 'diccionario'
	});	 			
	var cfg = {
		store:estadoDeGestionStore,
		id:'comboFiltroEstadoDeGestion'
	};		
	var filtroEstadoDeGestion = app.creaDblSelect(
		estadoDeGestion,
		'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.estadoDeGestion" text="**Estado de gestiï¿½n" />',
		cfg
	);								
	
	// FIN Estado de Gestiï¿½n	*******************************************************
	
	// INICIO Entidad		*******************************************************
	<%-- <pfs:ddCombo name="comboEntidad" 
		labelKey="plugin.nuevoModeloBienes.busquedaSubastas.filtros.entidad" 
		label="**Entidad" 	
		value="${descripcionComboEntidad}" 
		dd="${entidadAdjudicatariaPropietaria}" />; --%>	
		
	/*var comboEntidadSeleccionado = function(){
	
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
	}*/		
		
	//comboEntidad.on('select',comboEntidadSeleccionado);			
	// FIN Entidad			*******************************************************		
		
	// INICIO HITOS ACTUALES		*****************************************************************		
	// INICIO Hito Actual de Bankia ***************************************************				
<%-- 	//var tareasSubastaBankia=<app:dict value="${tareasSubastaBankia}" />; --%>
		
    /*var tareasSubastaBankiaStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : tareasSubastaBankia
	       ,root: 'diccionario'
	});*/ 	
	/*var cfgTareasSubastaBankia = {
		store:tareasSubastaBankiaStore,
		id:'comboFiltroTareasSubastaBankia'
	};*/
	/*var filtroTareasSubastaBankia = app.creaDblSelect(
		tareasSubastaBankia,
		'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.tareasSubastaBankia" text="**Hito actual" />'
		,cfgTareasSubastaBankia
	);*/	
	
	/*recargarTareasSubastaBankia = function(){	
		app.resetCampos([filtroTareasSubastaBankia]);
	};*/	
	// FIN Hito Actual de Bankia ******************************************************
	
	// INICIO Hito Actual de Sareb ****************************************************
<%-- 	//var tareasSubastaSareb=<app:dict value="${tareasSubastaSareb}" />;	 --%>
    /*var tareasSubastaSarebStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : tareasSubastaSareb
	       ,root: 'diccionario'
	});*/ 
			
	/*var cfgTareasSubastaSareb = {
		store:tareasSubastaSarebStore,
		id:'comboFiltroTareasSubastaSareb'
	};*/	
	
	/*var filtroTareasSubastaSareb = app.creaDblSelect(
		tareasSubastaSareb,
		'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.filtros.tareasSubastaSareb" text="**Hito actual" />',
		cfgTareasSubastaSareb
	);*/	
	
	/*recargarTareasSubastaSareb = function(){	
		app.resetCampos([filtroTareasSubastaSareb]);
	};*/	
	// FIN Hito Actual de Sareb *******************************************************
	
	//Para empezar oculta las tareas de Bankia y Sareb
	//filtroTareasSubastaBankia.setVisible(false);
	//filtroTareasSubastaSareb.setVisible(false);			
	// FIN HITOS ACTUALES			*****************************************************************
	
	//Situar los botones
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;		
	
	
<%-- ************************* PESTAï¿½A 1 Datos de Subasta *************************************** --%>
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
					,items: [txtNumAutos,txtFechaSolicitud,txtFechaAnuncio,txtFechaSenyalamiento,comboTasacionCompletada
					//,comboEmbargo
					,comboInfLetradoCompleto,comboInstruccionesCompletadas]
				},{
					layout:'form'
					,items: [comboSubastaRevisada,txtTotalCargasAnteriores.panel,txtTotalImporteAdjudicado.panel,filtroEstadoDeGestion
					<%--,comboEntidad,filtroTareasSubastaBankia,filtroTareasSubastaSareb --%>
					]
				}]
	});
	filtrosTabDatosSubasta.on('activate',function(){
		pestanyaSubasta=true;
	});	

<%-- ************************* PESTAï¿½A 2 Cliente *************************************** --%>	

	var tiposPersona = <app:dict value="${tiposPersona}" blankElement="true" blankElementValue="" blankElementText="---" />;

    var comboTipoPersona = app.creaCombo({
		data:tiposPersona
    	,name : 'tipopersona'
    	,fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipopersona" text="**Tipo Persona" />' <app:test id="comboTipoPersona" addComa="true" />
		,width : 175
    });
	
	var filtroCodCli = app.creaInteger('codigoCliente', '<s:message code="menu.clientes.listado.filtro.codigoCliente" text="**Nï¿½ Cliente" />', '${codigoCliente}');
	
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
	
<%-- ************************* PESTAï¿½A 3 Contrato *************************************** --%>	
		
	var txtContrato = app.creaText('contrato1', '<s:message code="listadoContratos.numContrato" text="**Num. Contrato" />'); 

	var txtCodRecibo = app.creaText('codRecibo', '<s:message code="listadoContratos.codigoRecibo" text="**Cod. recibo" />'); 

	var txtCodEfecto = app.creaText('codEfecto', '<s:message code="listadoContratos.codigoEfecto" text="**Cod. efecto" />'); 

	var txtCodDisposicion = app.creaText('codDisposicion', '<s:message code="listadoContratos.codigoDisposicion" text="**Cod. disposiciï¿½n" />');	

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
	
	
<%-- ************************* PESTAï¿½A 4 Jerarquï¿½a *************************************** --%>	

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
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosJerarquia" text="Jerarquï¿½a" />'
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
	
<%-- ************** PESTAï¿½A 5 ASUNTOS ******************************************************** --%>
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
	
	var pestanyaAsunto=false;	
	var filtrosTabAsunto = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tabFiltros.datosAsunto" text="Asunto" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboPropiedades]
				},{
					layout:'form'
					,items: [comboGestion]
				}]
	});
	filtrosTabAsunto.on('activate',function(){
		pestanyaAsunto=true;
	});		
		
<%-- ************* COMPROBACION FILTROS BUSQUEDA Y DESACTIVAR BOTON PARA IMPRDIR BUSQUEDAS SIMULTÁNEAS *****************   --%>		
	var buscarFunc = function() {
           hayParametros=false;
           
			<%-- Comprueba si se ha añadido algun filtro en la PRIMERA pestaña (DATOS DE SUBASTA) --%>
			if(txtNumAutos.getValue() != '' || txtFechaSolicitudDesde.getValue() != '' || txtFechaSolicitudHasta.getValue() != '' || 
				txtFechaAnuncioDesde.getValue() != '' || txtFechaAnuncioHasta.getValue() != '' || txtFechaSenyalamientoDesde.getValue() != '' || 
				txtFechaSenyalamientoHasta.getValue() != '' || comboTasacionCompletada.getValue() != '' || comboInfLetradoCompleto.getValue() != '' || 
				comboInstruccionesCompletadas.getValue() != '' || comboSubastaRevisada.getValue() != '' || idmintotalCargasAnteriores.value != '' || 
				idmaxtotalCargasAnteriores.value != '' || idmintotalImporteAdjudicado.value != '' || idmaxtotalImporteAdjudicado.value != '' || 
				filtroEstadoDeGestion.getValue() != '' )
			{
				hayParametros = true;
			}
			
			<%-- Comprueba si se ha añadido algun filtro en la SEGUNDA pestaña (CLIENTE) --%>
	        if(comboTipoPersona.getValue() != '' || filtroCodCli.getValue() != '' || filtroNombre.getValue() != '' ||
        		filtroApellidos.getValue() != '' || filtroNif.getValue() != '')
        	{
				hayParametros = true;
			}
			
			<%-- Comprueba si se ha añadido algun filtro en la TERCERA pestaña (CONTRATO) --%>
	        if((txtContrato.getValue()!= null && txtContrato.getValue() != '') || (txtCodRecibo.getValue() != null && txtCodRecibo.getValue() != '') || 
	        	(txtCodEfecto.getValue() != null && txtCodEfecto.getValue() != '') || (txtCodDisposicion.getValue() != null && txtCodDisposicion.getValue() != '')
        		 || (comboEstadoContrato.getStore() != null && comboEstadoContrato.getValue() != '') || 
        		 (comboTiposProducto.getStore() != null && comboTiposProducto.getValue() != ''))
        	{
				hayParametros = true;
			}
			
			<%-- Comprueba si se ha añadido algun filtro en la CUARTA pestaña (JERARQUÍA) --%>
	        if((comboJerarquia.getValue() != null && comboJerarquia.getValue() != '' && comboZonas.getValue() != '') || 
	        (comboJerarquiaAdministrativa.getValue() != null && comboJerarquiaAdministrativa.getValue() != '' && comboZonasAdm.getValue() != ''))
	        {
				hayParametros = true;
			}
           
            <%-- Comprueba si se ha añadido algun filtro en la QUINTA pestaña (ASUNTO) --%>
            if(comboPropiedades.getValue() != '' || comboGestion.getValue() != '')
            {
				hayParametros = true;
			}
           
           if (hayParametros) {		
               	panelFiltros.collapse(true);
               	pagingBar.show();
				subastasStore.webflow(getParametros()); 
			
				parametrosTab = new Array();            
               	panelFiltros.getTopToolbar().setDisabled(true);
           } 
           else {
               Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','Introduzca parámetros de búsqueda');
           }
	};
	
	<%-- Se sustituye el btnBuscar de ButtonsL para poder deshabilitarlo mientras se procesa una búsqueda --%>
	buttonsL[0]=app.crearBotonBuscar({
		handler : buscarFunc
	});	
		
		
		
<%-- *************TABPANEL QUE CONTIENE TODAS LAS PESTAï¿½AS********************************   --%>
	
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosSubasta, filtrosTabCliente, filtrosTabContrato, filtrosTabJerarquia,filtrosTabAsunto]
		,id:'idTabFiltrosSubasta'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});		
			

<%-- **************************** PANEL QUE CONTIENE EL PANEL DE PESTAï¿½AS******************** --%>
	
	var panelFiltros = new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,title : '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.FiltrosTitulo" text="Buscador de Subastas" />'
		,titleCollapse:true
		,collapsible:true
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
	
	//Funciï¿½n que le envï¿½a los datos al DTO
	var getParametros=function(){	
		var b = {};
		
		if (pestanyaSubasta){		
			b.id = txtIdSubasta.getValue();
			
			b.numAutos = txtNumAutos.getValue();
			
			b.fechaSolicitudDesde = idTxtFechaSolicitudDesde.value;
			b.fechaSolicitudHasta = idTxtFechaSolicitudHasta.value;	
	
			b.fechaAnuncioDesde = idTxtFechaAnuncioDesde.value;
			b.fechaAnuncioHasta = idTxtFechaAnuncioHasta.value;
			
			b.fechaSenyalamientoDesde = idTxtFechaSenyalamientoDesde.value;
			b.fechaSenyalamientoHasta = idTxtFechaSenyalamientoHasta.value;
	
			b.idComboTasacionCompletada=getValorComboSiNo(comboTasacionCompletada.getValue());	
						
			//b.idComboEmbargo=getValorComboSiNo(comboEmbargo.getValue());
			
			b.idComboInfLetradoCompleto=getValorComboSiNo(comboInfLetradoCompleto.getValue());
			
			b.idComboInstruccionesCompletadas=getValorComboSiNo(comboInstruccionesCompletadas.getValue());
			
			b.idComboSubastaRevisada=getValorComboSiNo(comboSubastaRevisada.getValue());		
		
			if (comboFiltroEstadoDeGestion!=""){
				b.comboFiltroEstadoDeGestion = comboFiltroEstadoDeGestion.childNodes[1].value;
			}
			else{
				b.comboFiltroEstadoDeGestion = "";
			}
			
			/*if (comboEntidad.selectedIndex>0){
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
					b.comboFiltroTareasSubastaBankia = comboFiltroTareasSubastaBankia.childNodes[1].value;
				}
				else if (entidadSeleccionada == 'SAREB'){
					b.idComboEntidad = "SAREB";
					b.comboFiltroTareasSubastaBankia = "";
					b.comboFiltroTareasSubastaSareb = comboFiltroTareasSubastaSareb.childNodes[1].value;
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
			}*/
						
			b.totalCargasAnterioresDesde = idmintotalCargasAnteriores.value;
			b.totalCargasAnterioresHasta = idmaxtotalCargasAnteriores.value;					
						
			b.totalImporteAdjudicadoDesde = idmintotalImporteAdjudicado.value;
			b.totalImporteAdjudicadoHasta = idmaxtotalImporteAdjudicado.value;			
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
		}

		return b;	
	}
		
	//Funciï¿½n que limpia los filtros de las pestaï¿½as
	resetFiltros = function(){
		
		//Pestaï¿½a Subasta ***********************************
		txtIdSubasta.reset();
		txtNumAutos.reset();
		
		idTxtFechaSolicitudDesde.value="";
		idTxtFechaSolicitudHasta.value="";

		idTxtFechaAnuncioDesde.value="";
		idTxtFechaAnuncioHasta.value="";	

		idTxtFechaSenyalamientoDesde.value="";
		idTxtFechaSenyalamientoHasta.value="";			
		
		comboTasacionCompletada.reset();
		
		//comboEmbargo.reset();
		
		comboInfLetradoCompleto.reset();
		
		comboInstruccionesCompletadas.reset();
		
		comboSubastaRevisada.reset();						

		limpiarYRecargarEstadoDeGestion();
		//comboFiltroEstadoDeGestion.reset();
		filtroEstadoDeGestion.reset();

		//recargarTareasSubastaBankia();
		//recargarTareasSubastaSareb();
		//filtroTareasSubastaBankia.setVisible(false);
		//filtroTareasSubastaSareb.setVisible(false);
		
		//comboEntidad.selectedIndex=0;
		//comboEntidad.reset();
		
		idmintotalCargasAnteriores.value="";
		idmaxtotalCargasAnteriores.value="";
		
		idmintotalImporteAdjudicado.value="";
		idmaxtotalImporteAdjudicado.value="";

		//filtroTareasSubastaBankia.reset();
		//filtroTareasSubastaSareb.reset();
		
		//Pestaï¿½a Cliente ***********************************			
		comboTipoPersona.reset();
    	filtroNombre.reset();
    	filtroApellidos.reset();
		filtroNif.reset();		
		filtroCodCli.reset();					
		
		//Pestaï¿½a Contrato ***********************************
       	txtContrato.reset();
       	comboEstadoContrato.reset();
       	comboTiposProducto.reset();
       	txtCodRecibo.reset();
       	txtCodEfecto.reset();
       	txtCodDisposicion.reset();	
       	
       	//Pestaï¿½a Jerarquï¿½a ***********************************
  		comboZonas.reset();
		comboJerarquia.reset();
		optionsZonasStore.webflow({id:0});
		comboZonasAdm.reset();
		comboJerarquiaAdministrativa.reset();
		optionsZonasAdmStore.webflow({id:0});
		
		//Pestaï¿½a Asunto **************************************
		comboGestion.reset();
		comboPropiedades.reset();	
	}
		

	
<%-- **************************** PANEL INFERIOR (RESULTADO DE LA Bï¿½SQUEDA): SUBASTAS ******************** --%>																												
							
	var subasta = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'numAutos'}
		 ,{name:'fechaSolicitud'}
		 ,{name:'fechaAnuncio'}
		 ,{name:'fechaSenyalamiento'}
		 //,{name:'estado'}
		 ,{name:'estadoSubasta'}
		 ,{name:'tasacion'}
		 ,{name:'embargo'}
		 ,{name:'infLetrado'}
		 ,{name:'instrucciones'}
		 ,{name:'subastaRevisada'}
		 ,{name:'cargasAnteriores'}
		 ,{name:'totalImporteAdjudicado'}		 
		 ,{name:'nombreAsunto'}
		 ,{name:'idAsunto'}
		 ,{name:'propiedadAsunto'}
		 ,{name:'gestionAsunto'}
		 ,{name:'plaza'}
		 ,{name:'juzgado'}
		 ,{name:'despacho'}
		 ,{name:'procurador'}
	]);				

	var subastasStore = page.getStore({
		 flow: 'plugin/nuevoModeloBienes/subastas/busquedas/NMBlistadoSubastasData' 
		,limit: limit
		,remoteSort: true
		,reader: new Ext.data.JsonReader({
	    	 root : 'subastas'
	    	,totalProperty : 'total'
	     }, subasta)
	});	
	
	var OK_KO_Render = function (value, meta, record) {	
		if (value) {
			return '<img src="/pfs/css/true.gif" height="16" width="16" alt=""/>';
		} else {
			return '<img src="/pfs/css/false.gif" height="16" width="16" alt=""/>';
		}
	};
	
	//Listado de resultados de la parte inferior de la pantalla
	var subastasCm = new Ext.grid.ColumnModel([	    
	    {header: '<s:message code="Asunto" text="Asunto"/>', dataIndex: 'nombreAsunto', sortable: false}
	    ,{header: '<s:message code="idAsunto" text="idAsunto"/>', dataIndex: 'idAsunto', hidden: true}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.numAutos" text="Nº Autos"/>', dataIndex: 'numAutos'}	    
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.fechaSolicitud" text="F.Solicitud"/>', dataIndex: 'fechaSolicitud', sortable: true}
		,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.fechaAnuncio" text="F.Anuncio"/>', dataIndex: 'fechaAnuncio', sortable: true}	    	    
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.fechaSenyalamiento" text="F.Señalamiento"/>', dataIndex: 'fechaSenyalamiento', sortable: true}	    
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.estado" text="Estado"/>', dataIndex: 'estadoSubasta', sortable: true}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.tasacion" text="Tasaciï¿½n"/>', dataIndex: 'tasacion', sortable: true, renderer : OK_KO_Render, align:'center'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.embargo" text="Embargo"/>', dataIndex: 'embargo', sortable: true, renderer : OK_KO_Render, align:'center'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.infLetrado" text="Inf.Letrado"/>', dataIndex: 'infLetrado', sortable: true,renderer : OK_KO_Render, align:'center'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.instrucciones" text="Instrucciones"/>', dataIndex: 'instrucciones', sortable: true,renderer : OK_KO_Render, align:'center'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.subastaRevisada" text="Subasta Revisada"/>', dataIndex: 'subastaRevisada', sortable: true,renderer : OK_KO_Render, align:'center'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.totalCargasAnteriores" text="Total cargas anteriores"/>', dataIndex: 'cargasAnteriores', sortable: true, renderer: app.format.moneyRenderer, align:'right'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.totalImporteAdjudicado" text="Total importe adjudicado"/>', dataIndex: 'totalImporteAdjudicado', sortable: true, renderer: app.format.moneyRenderer, align:'right'}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.propiedadAsunto" text="Propiedad"/>', dataIndex: 'propiedadAsunto', sortable: false}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.gestion" text="Gesti&oacute;n"/>', dataIndex: 'gestionAsunto', sortable: false}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.plaza" text="Plaza"/>', dataIndex: 'plaza', sortable: false}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.juzgado" text="Juzgado"/>', dataIndex: 'juzgado', sortable: false}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.despacho" text="Despacho"/>', dataIndex: 'despacho', sortable: false}
	    ,{header: '<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.grid.procurador" text="Procurador"/>', dataIndex: 'procurador', sortable: false}
	]);
	
		
	var pagingBar=fwk.ux.getPaging(subastasStore);
	pagingBar.hide();
	
	
	var cfg={
		title:'<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tituloGrid" text="Subastas"/>'
		,style:'padding-bottom:10px; padding-right:20px;'
		,cls:'cursor_pointer'
		,iconCls : 'icon_bienes'
		,collapsible : true
		,collapsed: true		
		,titleCollapse : true
		,resizable:true
		,dontResizeHeight:true		
		,bbar : [pagingBar]
		,autoHeight:true
	};	

	var subastasGrid = app.crearGrid(subastasStore,subastasCm,cfg);
		
	subastasGrid.on('load', function(){
		subastasGrid.setTitle('<s:message code="plugin.nuevoModeloBienes.busquedaSubastas.tituloGrid" text="Subastas" arguments="'+subastasStore.getTotalCount()+'"/>');
		panelFiltros.collapse(true);
		
	});	
	
	var subastasGridListener = function(grid, rowIndex, e) {		
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_asunto=rec.get('nombreAsunto');
    	var id=rec.get('idAsunto');
    	app.abreAsuntoTab(id, nombre_asunto,'tabSubastas');
    };
	    	
	subastasGrid.addListener('rowdblclick', subastasGridListener);
	
	subastasStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
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
    
	return mainPanel;
}
