<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){
	var limit=25;
	var labelStyle2 = 'font-size:12px;';
	//Campo Código Asunto
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
	
	
	//Campo Nombre Persona Procedimiento Asunto
	var nombrePersonaProcedimiento = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.nombrePersonaProcedimiento" text="**Nombre Persona Procedimiento" />'
		,name:'nombrePersonaProcedimiento'
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
		<app:test id="nombrePersonaProcedimiento" addComa="true"/>
	});
	
	//Campo Apellido1 Persona Procedimiento Asunto
	var apellido1PersonaProcedimiento = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.apellido1PersonaProcedimiento" text="**Primer apellido" />'
		,name:'apellido1PersonaProcedimiento'
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
		<app:test id="apellido1PersonaProcedimiento" addComa="true"/>
	});
	
	//Campo Apellido2 Persona Procedimiento Asunto
	var apellido2PersonaProcedimiento = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.apellido2PersonaProcedimiento" text="**Segundo apellido" />'
		,name:'apellido2PersonaProcedimiento'
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
		<app:test id="apellido2PersonaProcedimiento" addComa="true"/>
	});
	
	//Campo dni/nif Persona Procedimiento Asunto
	var dniPersonaProcedimiento = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.dni" text="**Documento DNI/NIF" />'
		,name:'dniPersonaProcedimiento'
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
		<app:test id="dniPersonaProcedimiento" addComa="true"/>
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

	//Listado de Decisiones de finalizacion del asunto, viene del flow
	var dictDecisiones = <app:dict value="${decisionesFinalizar}" blankElement="true" blankElementValue="" blankElementText="---"/>;


	//store generico de combo diccionario
	var optionsDecisionesFinalizacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictDecisiones
	});

	//Campo Combo Decisiones Finalizar Asunto
	var comboDecisionesFinalizacion = new Ext.form.ComboBox({
		store:optionsDecisionesFinalizacionStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,editable:false
		,emptyText:"---"
		,triggerAction: 'all'
		,fieldLabel:'<s:message code="asuntos.busqueda.filtro.decisionFinalizacion" text="**Motivo Finalización"/>'
		<app:test id="comboDecisionesFinalizacion" addComa="true"/>
	});
	
	
	
	
	
	
	
	
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
		// Si estamos corriendo tests selenium esta función debe ser global para que
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

	//Combo número de contrato... debería ser TextField? Ver con el CU
	var filtroContrato =new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.contrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,maxLength:50 
		,autoCreate : {tag: "input", type: "text",maxLength:"50", autocomplete: "off"}
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
	});

	/*Jerarquía*/
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
		{name:'id'}
		,{name:'codigo'}
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
				,valueField:'id'
				,mode: 'remote'
				,width:300
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="menu.clientes.listado.filtro.errorPostEnvio" text="**Resultado propuestas enviadas a cierre"/>'
	});	
	
		
	var fechaEntregaDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.fechaDeEnvioCierre" text="**Fecha de envío" />'
		,name : 'fechaEntregaDesde'
	});
	
	var fechaEntregaHasta = new Ext.ux.form.XDateField({
		 hideLabel:true
		,name : 'fechaEntregaHasta'
		,style: 'margin-bottom: 7px'
	});



	var filtrosCDD = new Ext.Panel({
		layout:'table'
		,title : ''
		,width: 410
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns: 1
		}
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{items:[
				{border: false,layout:'form', items:[comboErrorPreviCDD]}
				]
			},
			{items:[
				{border: false,layout:'form', items:[comboErrorPostCDD]}
				]
			},
			{
			layout:'table'			
			,layoutConfig : {
				columns: 2
			},
			items:[
				{border: false,layout:'form', items:[fechaEntregaDesde]}
				,{border: false,layout:'form',items:[fechaEntregaHasta]}
				]
			}
		]
	}); 
	
	
	              
    var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'asuntos/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});    
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas, width:200, height: 140});
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
	,bodyStyle:'margin:0px;padding:5px;cellspacing:10px;margin-bottom:0px'
	};
    comboTipoProcedimientos = app.creaDblSelect(tipoProcedimientos, '<s:message code="asuntos.busqueda.filtro.tipoActuacion" text="**Tipo de actuación" />',cfgComboTipoProc);
	
	//Campo Nombre Asunto
	var codigoProcedimientoEnJuzgado = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtro.nroAuto" text="**Nº Auto" />'
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
		text:'<s:message code="asuntos.busqueda.filtro.datosGenerales.nroAuto" text="Nº Auto"/>'+':'
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
		,bodyStyle:'padding:0px;cellspacing:5px;padding-bottom: 5px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{items:[filtroNumeroCodigoProclabel]}
			,{width:'52px'}
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
		
		if (nombrePersonaProcedimiento.getValue() != '' ){
			return true;
		}
		if (apellido1PersonaProcedimiento.getValue() != '' ){
			return true;
		}
		if (apellido2PersonaProcedimiento.getValue() != '' ){
			return true;
		}
		if (dniPersonaProcedimiento.getValue() != '' ){
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
		if (comboDecisionesFinalizacion.getValue() != '') {
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
		if (!Ext.isEmpty(comboErrorPreviCDD.getValue())){
			return true;
		}
		if (!Ext.isEmpty(comboErrorPostCDD.getValue())){
			return true;
		}
		if (fechaEntregaDesde.getValue() != '' ){
			return true;
		}
		if (fechaEntregaHasta.getValue() != '' ){
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
			,nombrePersonaProcedimiento: nombrePersonaProcedimiento.getValue()
			,apellido1PersonaProcedimiento: apellido1PersonaProcedimiento.getValue()
			,apellido2PersonaProcedimiento: apellido2PersonaProcedimiento.getValue()
			,dniPersonaProcedimiento: dniPersonaProcedimiento.getValue()
			<%-- ,comboDespachos:comboDespachos.getValue()
			,comboGestor:comboGestor.getValue()
			,comboTiposGestor:comboTiposGestor.getValue()--%>
			,comboEstados:comboEstados.getValue()
			,comboGestion:comboGestion.getValue()
			,comboPropiedades:comboPropiedades.getValue()
			,comboDecisionesFinalizacion:comboDecisionesFinalizacion.getValue()
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
			,fechaEntregaDesde:app.format.dateRenderer(fechaEntregaDesde.getValue())
			,fechaEntregaHasta:app.format.dateRenderer(fechaEntregaHasta.getValue())
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
		,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,autoHeight:true
					,items:[codigoAsunto,nombre,nombrePersonaProcedimiento,apellido1PersonaProcedimiento,apellido2PersonaProcedimiento,dniPersonaProcedimiento,comboEstados,fechaCreacionDesde,fechaCreacionHasta,comboGestion,comboPropiedades,comboDecisionesFinalizacion
									 <sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">,filtrosCDD</sec:authorize>]}
			   ,{	layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,autoHeight:true
			   		,items:[saldoTotalContratos.panel,importeEstimado.panel,comboTipoAsunto,filtroContrato,filtroNumeroAutosPanel,comboTipoProcedimientos,comboJerarquia, comboZonas]}
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
    		           ,nombrePersonaProcedimiento
    		           ,apellido1PersonaProcedimiento
    		           ,apellido2PersonaProcedimiento
    		           ,dniPersonaProcedimiento
    		           <%-- ,comboDespachos
    		           ,comboGestor
    		           ,comboTiposGestor--%>
    		           ,comboEstados
    		           ,comboGestion
    		           ,comboPropiedades
    		           ,comboDecisionesFinalizacion
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
    		           ,fechaEntregaDesde
    		           ,fechaEntregaHasta
    		           ,comboZonas
    		           ,codigoProcedimientoEnJuzgado
    		           ,filtroNumeroCodigoProc
    		           ,filtroAnyoCodigoProc
    		           ,comboTipoProcedimientos // Incidencia UGAS-524
	           ]); 
	           optionsZonasStore.webflow({id:0}); // Incidencia UGAS-524
	           comboErrorPreviCDD.clearValue();
    		   comboErrorPostCDD.clearValue();
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