<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

(function(){
	var limit=25;
	var labelStyle2 = 'font-size:12px;';
	
	//Campo C�digo Asunto
	var codigoAsunto=app.creaNumber('codigo',
			'<s:message code="asuntos.busqueda.filtro.codigo" text="**Codigo Asunto" />','',{autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"},listeners:{ specialkey: function(f,e){ if(e.getKey() == e.ENTER) { buscarFunc(); } } }<app:test id="idAsunto" addComa="true"/>});
	
	//Campo Nombre Asunto
	var nombre = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.nombre" text="**Nombre Asunto" />'
		,name:'nombre'
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
		<app:test id="nombreAsunto" addComa="true"/>
	});
	<%-- 
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


	var recargarComboGestores = function(){
		if (comboDespachos.getValue()!=null && comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
		}else{
			optionsGestoresStore.webflow({id:0});
		}
	}
	
	
	//Listado de tipos de gestor, viene del flow
	var dictTiposGestor = <app:dict value="${tiposGestor}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store para los tipos de testor
	var optionsTiposGestor = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTiposGestor
	});
	
	//Campo Combo Tipos de Gestor
	var comboTiposGestor = new Ext.form.ComboBox({
				store:optionsTiposGestor
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="ext.asuntos.busqueda.filtro.tipoGestor" text="**Tipo de gestor"/>'
				<app:test id="comboTiposGestor" addComa="true"/>
	});
	
	//Campo Gestores, double select
	var comboGestor = app.creaDblSelect(gestores,'<s:message code="asuntos.busqueda.filtro.gestor" text="**Gestor" />',{store:optionsGestoresStore, funcionReset:recargarComboGestores <app:test id="comboGestores" addComa="true"/>});
		
--%>	

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
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
				<app:test id="comboEstados" addComa="true"/>
	});
	
	//Listado de Estados, viene del flow
	var dictTipoAsunto = <app:dict value="${tipoAsunto}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	
	//store generico de combo diccionario
	var comboTipoAsuntoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoAsunto
	});
	
	//Campo Combo Estados
	var comboTipoAsunto = new Ext.form.ComboBox({
				store: comboTipoAsuntoStore
				,displayField:'descripcion'
				,valueField:'descripcion'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="asuntos.busqueda.filtro.tipo.asunto" text="**Tipo Asunto"/>'
				<app:test id="comboTipoAsunto" addComa="true"/>
	});
	
	<%--
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
	 --%>

	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta funci�n debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarCombos = function(){
		<%-- if (comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
			comboGestor.enable();
			comboTiposGestor.enable();
		}else{
			//comboSupervisor.setValue('');
			optionsGestoresStore.removeAll();
		}
		--%>
	}
	
	var bloquearCombos = function(){
		<%--comboGestor.disable();
		comboTiposGestor.disable();--%>
	}
	
	<%--comboDespachos.on('focus',bloquearCombos);
	
	comboDespachos.on('change',recargarCombos);
	
	bloquearCombos(); --%>
	
	var limpiarYRecargarGestores = function(){
		<%--app.resetCampos([comboGestor,comboTiposGestor]);
		recargarComboZonas();--%>
	}
	
	//comboDespachos.on('select',limpiarYRecargarGestores);
	
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
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
	});
	
	var fechaCreacionHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.creacionhasta" text="**Hasta" />'
		,name:'fechaCreacionHasta'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
	});

<%--
	/*var fieldSetFechas=new Ext.form.FieldSet({
		title:'<s:message code="asuntos.busqueda.filtro.diascreacion" text="**D&iacute;as Creacion" />'
		,autoHeight:true
		,width:250
		,items:[fechaCreacionDesde,fechaCreacionHasta]
	});*/
 --%>

	//Combo n�mero de contrato... deber�a ser TextField? Ver con el CU
	var filtroContrato =new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.contrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,maxLength:10 
		,autoCreate : {tag: "input", type: "text",maxLength:"10", autocomplete: "off"}
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
	});

	/*Jerarqu�a*/
	var zonas=<app:dict value="${zonas}" />;
	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name : 'jerarquia', fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});
	
	
	//Listado de Estados, viene del flow
	var siNo = <app:dict value="${sino}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store generico de combo diccionario
	var optionsSINOStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : siNo
	});

	//Campo Combo Situacion CDD
	var comboSituacionCDD = new Ext.form.ComboBox({
				store:optionsSINOStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="menu.clientes.listado.filtro.situacionCDD" text="**Situaci&oacute;n cierre de deuda"/>'
	});
	
	var generico = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
		,{name:'codigoDescripcion'}
	]);
	
	var optionsErrorPrevioStore = page.getStore({
	       flow: 'subasta/getListErrorPreviCDDData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, generico)	       
	});

	//Campo Combo Error previo envio CDD
	var comboErrorPreviCDD = new Ext.form.ComboBox({
				store:optionsErrorPrevioStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'remote'
				,width:300
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="menu.clientes.listado.filtro.errorPrevioEnvio" text="**Error previo env&iacute;o a cierre"/>'
	});
	
	var optionsErrorPostStore = page.getStore({
	       flow: 'subasta/getListErrorPostCDDData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, generico)	       
	});
	
	//Campo Combo Error post envio CDD
	var comboErrorPostCDD = new Ext.form.ComboBox({
				store:optionsErrorPostStore
				,displayField:'codigoDescripcion'
				,valueField:'codigo'
				,mode: 'remote'
				,width:300
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="menu.clientes.listado.filtro.errorPostEnvio" text="**Error post env&iacute;o a cierre"/>'
	});	
	
	              
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
	var cfgComboTipoProc = {
	width:250
	};
    comboTipoProcedimientos = app.creaDblSelect(tipoProcedimientos, '<s:message code="asuntos.busqueda.filtro.tipoActuacion" text="**Tipo de actuaci�n" />',cfgComboTipoProc);
	
	//Campo Nombre Asunto
	var codigoProcedimientoEnJuzgado = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.nroAuto" text="**N� Auto" />'
		,name:'codigoProcedimientoEnJuzgado'
		<app:test id="nroAuto" addComa="true"/>
	});
	
	var filtroNumeroCodigoProc = new Ext.form.TextField({
		name : 'filtroNumeroCodigoProc'
		,width : 100
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
	});
	
	var filtroAnyoCodigoProc = new Ext.form.TextField({
		name : 'filtroAnyoCodigoProc'
		,hideLabel:true
		,width: 75
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
	});
	var filtroNumeroCodigoProclabel = new Ext.form.Label({
		text:'<s:message code="asuntos.busqueda.filtro.datosGenerales.nroAuto" text="N� Auto"/>'+':'
		,style:labelStyle2
	});
	
	var filtroNumeroAutosPanel = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:5
		}
		,width:300
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,bodyStyle:'padding:0px;cellspacing:5px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{items:[filtroNumeroCodigoProclabel]}
			,{width:'60px'}
			,{items:[filtroNumeroCodigoProc]}
			,{items:[{border:false,html:'/'}]}
			,{items:[filtroAnyoCodigoProc]}
		]
	});
	

	
	var validarEmptyForm = function(){

		if (codigoAsunto.getValue() != '' && app.validate.validateInteger(codigoAsunto.getValue())){
			return true;
		}
		if (nombre.getValue() != '' ){
			return true;
		}
		<%--if (comboDespachos.getValue() != '' ){
			return true;
		}
		 if (comboGestor.getValue() != '' ){
			return true;
		}
		if (comboTiposGestor.getValue() != '' ){
			return true;
		}--%>
		if (comboEstados.getValue() != '' ){
			return true;
		}
		if (comboGestion.getValue() != '') {
			return true;
		}
		if (comboPropiedades.getValue() != '') {
			return true;
		}
		if (comboTipoAsunto.getValue() != '' ){
			return true;
		}
		<%--
		if (comboSupervisor.getValue() != '' ){
			return true;
		}
		 --%>
		<%--
		/*if (estadoAnalisis.getValue() != '' ){
			return true;
		}*/
		 --%>
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
		if (comboSituacionCDD.getValue() != '' ){
			return true;
		}
		if (comboErrorPreviCDD.getValue() != '' ){
			return true;
		}
		if (comboErrorPostCDD.getValue() != '' ){
			return true;
		}
		if (comboZonas.getValue() != '' ){
			return true;
		}			
		if (comboTipoProcedimientos.getValue() != '' ){
			return true;
		}			
		<%--
		if (codigoProcedimientoEnJuzgado.getValue() != '' ){
			return true;
		} --%>				
			
		if (filtroNumeroCodigoProc.getValue() != '' ){
			return true;
		}
		if (filtroAnyoCodigoProc.getValue() != '' ){
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
			<%-- ,comboDespachos:comboDespachos.getValue()
			,comboGestor:comboGestor.getValue()
			,comboTiposGestor:comboTiposGestor.getValue()--%>
			,comboEstados:comboEstados.getValue()
			,comboGestion:comboGestion.getValue()
			,comboPropiedades:comboPropiedades.getValue()
			,comboTipoAsunto: comboTipoAsunto.getValue()
			<%--,comboSupervisor:comboSupervisor.getValue() --%>
			<%--//,estadoAnalisis:estadoAnalisis.getValue() --%>
			,minSaldoTotalContratos:saldoTotalContratos.min.getValue()
			,maxSaldoTotalContratos:saldoTotalContratos.max.getValue()
			,minImporteEstimado:importeEstimado.min.getValue()
			,maxImporteEstimado:importeEstimado.max.getValue()
			,filtroContrato:filtroContrato.getValue()
			,fechaCreacionDesde:app.format.dateRenderer(fechaCreacionDesde.getValue())
			,fechaCreacionHasta:app.format.dateRenderer(fechaCreacionHasta.getValue())
			,jerarquia:comboJerarquia.getValue()
			,comboSituacionCDD:comboSituacionCDD.getValue()
			,comboErrorPreviCDD:comboErrorPreviCDD.getValue()
			,comboErrorPostCDD:comboErrorPostCDD.getValue()
			,codigoZona:comboZonas.getValue()
			,tipoSalida:'<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.SALIDA_LISTADO" />'
			//,codigoProcedimientoEnJuzgado:codigoProcedimientoEnJuzgado.getValue()
			,numeroProcedimientoEnJuzgado:filtroNumeroCodigoProc.getValue()
			,anyoProcedimientoEnJuzgado:filtroAnyoCodigoProc.getValue()
			,tipoProcedimiento:comboTipoProcedimientos.getValue()
			
			
		};
	};
	
	<c:if test="${usuario.usuarioExterno}">
		<%--comboDespachos.disable(true);
		comboGestor.disable(true);
		comboTiposGestor.disable(true);--%>
		<%--comboSupervisor.disable(true);--%>
		comboJerarquia.disable(true);
		comboZonas.disable(true);
	</c:if>


	var panel=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="asuntos.busqueda.filtros.tabs.datosGenerales.title" text="**Filtro de Asuntos" />'
		,layoutConfig:{columns:2}
	    ,header: false
	    ,border:false
		//,titleCollapse : true
		//,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-left:10px;padding-right:10px;padding-top:1px;padding-bottom:1px;cellspacing:10px'}
		,items:[{items:[codigoAsunto]}
				,{items:[saldoTotalContratos.panel]}
				,{items:[nombre]}
				,{items:[importeEstimado.panel]}
				,{items:[comboEstados]}
				,{items:[comboTipoAsunto]}
				,{items:[fechaCreacionDesde]}
				,{items:[filtroContrato]}
				,{items:[fechaCreacionHasta]}
				,{items:[filtroNumeroAutosPanel]}
				,{items:[comboJerarquia]}
				,{items:[comboErrorPreviCDD]}
				,{items:[comboZonas]}
				,{items:[comboErrorPostCDD]}
				,{colspan:2,items:[comboTipoProcedimientos]}
				,{items:[comboGestion]}
				,{items:[comboPropiedades]}
		]
		,listeners:{	
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	            if (validaMinMax()){
    	                anadirParametros(getParametros());
    	            }else{
    	                hayError();
    	                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
    	            }
    	        }
//		        else{
//    	            Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
//    	        }
			}
    		,limpiar: function() {
    		   app.resetCampos([      
    		           codigoAsunto
    		           ,nombre
    		           <%-- ,comboDespachos
    		           ,comboGestor
    		           ,comboTiposGestor--%>
    		           ,comboEstados
    		           ,comboGestion
    		           ,comboPropiedades
    		           ,comboTipoAsunto
    		           <%--,comboSupervisor --%>
    		           <%--//,estadoAnalisis --%>
    		           ,saldoTotalContratos.min
    		           ,saldoTotalContratos.max
    		           ,importeEstimado.min
    		           ,importeEstimado.max
    		           ,filtroContrato
    		           ,fechaCreacionDesde
    		           ,fechaCreacionHasta
    		           ,comboJerarquia
    		           ,comboSituacionCDD
    		           ,comboErrorPreviCDD
    		           ,comboErrorPostCDD
    		           ,comboZonas
    		           ,codigoProcedimientoEnJuzgado
    		           ,filtroNumeroCodigoProc
    		           ,filtroAnyoCodigoProc
    		           ,comboTipoProcedimientos // Incidencia UGAS-524
	           ]); 
	           optionsZonasStore.webflow({id:0}); // Incidencia UGAS-524
    		}
    		,exportar: function() {
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
	});



    return panel;
    
})()