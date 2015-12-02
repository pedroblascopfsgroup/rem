<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	var labelStyle2 = 'font-size:12px;';
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;

	<%--***************************************************
	**************DATOS DEL ASUNTO*************************
	 *****************************************************--%> 
	<pfsforms:textfield name="filtroDescripcionAsunto" 
		labelKey="plugin.busquedaProcedimientos.busca.descripcionAsunto" 
		label="**Descripción" 
		value="" searchOnEnter="true"/>
	
	<%--	
	<pfsforms:ddCombo name="filtroDespacho" labelKey="plugin.busquedaProcedimientos.busca.despacho" 
		label="**Despacho" value="" dd="${despachos}" propertyCodigo="id" 
		propertyDescripcion="despacho"/>
--%>		

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
				,fieldLabel : '<s:message code="plugin.busquedaProcedimientos.busca.despacho" text="**Despacho"/>'
				<app:test id="comboDespachos" addComa="true"/>
				,listeners:{
					specialkey: function(f,e){  
			            if(e.getKey()==e.ENTER){  
			                buscarFunc();
			            }  
			        } 
				}				
	});

<%--	
	<pfsforms:ddCombo name="filtroGestor" labelKey="plugin.busquedaProcedimientos.busca.gestor" 
		label="**Gestor del Asunto" value="" dd="${gestores}"   
		propertyCodigo="id" propertyDescripcion="usuario"
		/>
	
	 --%>
	 
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
	
	//Campo Gestores, double select
	var comboGestor = app.creaDblSelect(gestores,'<s:message code="plugin.busquedaProcedimientos.busca.gestor" text="**Gestor" />',{store:optionsGestoresStore, funcionReset:recargarComboGestores <app:test id="comboGestores" addComa="true"/>});
	 
		
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
				,listeners:{
					specialkey: function(f,e){  
			            if(e.getKey()==e.ENTER){  
			                buscarFunc();
			            }  
			        } 
				}
				,fieldLabel : '<s:message code="plugin.busquedaProcedimientos.busca.tipoGestor" text="**Tipo de gestor"/>'
				<app:test id="comboTiposGestor" addComa="true"/>
	});
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta funcion debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarCombos = function(){
		if (comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
			comboGestor.enable();
			comboTiposGestor.enable();
		}else{
			//comboSupervisor.setValue('');
			optionsGestoresStore.removeAll();
		}
	}
	
	var bloquearCombos = function(){
		comboGestor.disable();
		//comboTiposGestor.disable();
	}
	
	comboDespachos.on('focus',bloquearCombos);
	
	comboDespachos.on('change',recargarCombos);
	
	bloquearCombos();
	
	var limpiarYRecargarGestores = function(){
		app.resetCampos([comboGestor,comboTiposGestor]);
		recargarComboZonas();
	}
	
	comboDespachos.on('select',limpiarYRecargarGestores);
	
	<pfsforms:ddCombo name="filtroComite" labelKey="plugin.busquedaProcedimientos.busca.comite" 
		label="**Comité" value="" dd="${comites}" 
		propertyCodigo="id" propertyDescripcion="nombre" searchOnEnter="true"/>	
	filtroComite.setWidth(185);
	
	<pfsforms:ddCombo name="filtroEstadoAsunto" labelKey="plugin.busquedaProcedimientos.busca.estadoAsunto" 
		label="**Estado" value="" dd="${ddEstadoAsunto}" searchOnEnter="true"/>
	filtroEstadoAsunto.setWidth(185);
		
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busca.fechaConformacionAsuntoDesde" 
		label="**Fecha de conformación entre" name="filtroFechaConformacionAsuntoDesde" searchOnEnter="true"/>
	<%-- 	
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busca.fechaConformacionAsuntoY" 
		label="**...y" name="filtroFechaConformacionAsuntoHasta"/>
	--%>
	var filtroFechaConformacionAsuntoHasta = new Ext.ux.form.XDateField({
		name : 'filtroFechaConformacionAsuntoHasta'
		,hideLabel:true
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
	}); 
	<%--var filtroFechaConformacionAsuntoHasta = new Ext.ux.form.XDateField({
		name : 'filtroFechaConformacionAsuntoHasta'
		,hideLabel:true
	});  --%>
	
	var fechaConformacionAsuntoMinMax = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:3
		}
		,width:400
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,bodyStyle:'padding:0px;cellspacing:5px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{width:'0px'}
			<pfs:items items="filtroFechaConformacionAsuntoDesde" />
			<pfs:items items="filtroFechaConformacionAsuntoHasta" />
		]
	});
	
	
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busca.fechaAceptacionInicialMin" 
		label="**Fecha de aceptación desde " name="filtroFechaAceptacionInicialDesde" searchOnEnter="true"/>
	<%--	
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busca.fechaAceptacionInicialMax" 
		label="**Fecha de aceptaci�n hasta " name="filtroFechaAceptacionInicialHasta"/>
	--%> 
	var filtroFechaAceptacionInicialHasta = new Ext.ux.form.XDateField({
		name : 'filtroFechaAceptacionInicialHasta'
		,hideLabel:true		
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
	}); 
	
	var fechaAceptacionInicialMinMax = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:3
		}
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{width:'0px'}
			<pfs:items items="filtroFechaAceptacionInicialDesde" />
			<pfs:items items="filtroFechaAceptacionInicialHasta" />
		]
	}); 

		
	<pfs:minmaxmoneda labelKey="plugin.busquedaProcedimientos.busca.importeTotal" label="**Importe total" name="filtroImporteTotal"/>		
	
	
	var filtrosTabDatosAsunto = new Ext.Panel({
		title:'<s:message code="plugin.busquedaProcedimientos.busca.asunto" text="**Filtros por datos del asunto" />'
		,autoHeight:true
		,bodyStyle:'padding: 0px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroDescripcionAsunto, comboDespachos, comboGestor,comboTiposGestor]
				},{
					layout:'form'
					,items: [filtroEstadoAsunto,filtroComite, filtroImporteTotal.panel, fechaConformacionAsuntoMinMax,fechaAceptacionInicialMinMax]
				}]
	});
	
	
	<%-- *********************************************************************
	********DATOS DEL PROCEDIMIENTO*******************************************
	*************************************************************************--%>	
	<%--
	<pfsforms:dblselect name="filtroEstadoProcedimiento"
		labelKey="plugin.busquedaProcedimientos.busca.estadoProcedimiento"
		label="**Estado"  dd="${ddEstadosProcedimiento}" 
		 />
	 --%> 
	//Listado de tipos de gestor, viene del flow
	var dictfiltroEstadoProcedimiento = <app:dict value="${ddEstadosProcedimiento}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store para los tipos de testor
	var optionsfiltroEstadoProcedimiento = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictfiltroEstadoProcedimiento
	});
	
	//Campo Combo Tipos de Gestor
	var filtroEstadoProcedimiento = new Ext.form.ComboBox({
				store:optionsfiltroEstadoProcedimiento
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,listeners:{
					specialkey: function(f,e){  
			            if(e.getKey()==e.ENTER){  
			                buscarFunc();
			            }  
			        } 
				}
				,fieldLabel : '<s:message code="plugin.busquedaProcedimientos.busca.estadoProcedimiento" text="**Estado"/>'
				<app:test id="filtroEstadoProcedimiento" addComa="true"/>
	});
		 
	
	<pfsforms:ddCombo name="filtroTipoActuacion"
		labelKey="plugin.busquedaProcedimientos.busca.tipoActuacion"
		label="**Tipo de actuación" value="" dd="${ddTiposActuacion}" 
		width="300" />
		
	 var procedimientoRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var procedimientoStore = page.getStore({
	       flow: 'plugin/busquedaProcedimientos/plugin.busquedaProcedimientos.buscaProcedPorActuacion'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'procedimientos'
	    }, procedimientoRecord)
	       
	}); 	
	
    
	<pfsforms:dblselect name="filtroTipoProcedimiento" labelKey="plugin.busquedaProcedimientos.busca.tipoProcedimiento" 
		label="**Tipo de procedimiento" dd="${procedimientos}" store="procedimientoStore" resetAll="true"/>
		
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta funci�n debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboProcedimientos = function(){
		if (filtroTipoActuacion.getValue()!=null && filtroTipoActuacion.getValue()!=''){
			procedimientoStore.webflow({id:filtroTipoActuacion.getValue()});
		}else{
			procedimientoStore.webflow({id:0});
		}
	};
	
    recargarComboProcedimientos();
    
    var limpiarYRecargar = function(){
		//app.resetCampos([comboZonas]);
		recargarComboProcedimientos();
	}
	
	filtroTipoActuacion.on('select',limpiarYRecargar);
 
		
	
	<pfsforms:ddCombo name="filtroTipoActuacionPadre" labelKey="plugin.busquedaProcedimientos.busca.tipoActPadre" 
		label="**Tipo de actuación del procedimiento padre" value="" dd="${ddTiposActuacion}" width="300"/>
	
	var procedimientoPadreStore = page.getStore({
	       flow: 'plugin/busquedaProcedimientos/plugin.busquedaProcedimientos.buscaProcedPorActuacion'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'procedimientos'
	    }, procedimientoRecord)
	       
	}); 
	
	<pfsforms:dblselect name="filtroTipoProcedimientoPadre" labelKey="plugin.busquedaProcedimientos.busca.tipoProcedimientoPadre" 
		label="**Tipo de procedimiento padre" dd="${procedimientosPadre}" store="procedimientoPadreStore" resetAll="true"/>
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta funci�n debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboProcedimientosPadre = function(){
		if (filtroTipoActuacionPadre.getValue()!=null && filtroTipoActuacionPadre.getValue()!=''){
			procedimientoPadreStore.webflow({id:filtroTipoActuacionPadre.getValue()});
		}else{
			procedimientoPadreStore.webflow({id:0});
		}
	};
	
    recargarComboProcedimientosPadre();
    
    var limpiarYRecargarPadre = function(){
		//app.resetCampos([comboZonas]);
		recargarComboProcedimientosPadre();
	}
	
	filtroTipoActuacionPadre.on('select',limpiarYRecargarPadre);
 
		
	<%-- 
	<pfsforms:numberfield name="filtroNumeroAutos" labelKey="plugin.busquedaProcedimientos.busca.numeroAutos" 
		label="**N�mero de Autos" value="" />
	--%>
	<pfsforms:textfield name="filtroNumeroAutos" 
		labelKey="plugin.busquedaProcedimientos.busca.numeroAutos" 
		label="**Número de Autos" 
		value="" searchOnEnter="true"/>	

<%-- 	<pfsforms:textfield name="filtroNumeroCodigoProc" 
		labelKey="plugin.busquedaProcedimientos.busca.numeroAutos" 
		label="**N�mero de Autos" 
		value="" searchOnEnter="true"/>	 --%>
		
<%-- 	<pfsforms:textfield name="filtroAnyoCodigoProc" 
		labelKey="" 
		label="" 
		value="" searchOnEnter="true"/>	 --%>			
	var filtroNumeroCodigoProc = new Ext.form.TextField({
		name : 'filtroNumeroCodigoProc'
		,width : 100
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
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
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
	});	
	
	var filtroNumeroCodigoProclabel = new Ext.form.Label({
		text:'<s:message code="plugin.busquedaProcedimientos.busca.numeroAutos" text="**Número de Autos"/>'+':'
		,style:labelStyle2
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
		fieldLabel: '<s:message code="plugin.busquedaProcedimientos.busqueda.plazas" text="**Plaza de Juzgado" />',		// Pla de juzgado
		loadingText: 'Searching...',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});	
	
	
	<c:if test="${filtroPlaza.value!=null}">
		codPlaza='${filtroPlaza.value}';
	</c:if>	
		
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
		,fieldLabel:'<s:message code="plugin.busquedaProcedimientos.editarPlazo.tipJuzgado" text="**Tipo de Juzgado" />'
		,width:250
		,value:''
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {  
	                buscarFunc();
	            }  
	        } 
		}
		
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
	
	
	<pfs:minmaxmoneda labelKey="plugin.busquedaProcedimientos.busqueda.saldtotal" 
		label="**Saldo Total" name="filtroSaldoTotalContratos"/>
	
	
	<pfs:minmaxporcentaje labelKey="plugin.busquedaProcedimientos.busqueda.filtro.importeestimado" label="**Porcentaje recuperación" name="filtroPorcentajeRecup"/>
	
	filtroPorcentajeRecup.min.setMaxValue(100);
	filtroPorcentajeRecup.max.setMaxValue(100);
	
	filtroPorcentajeRecup.min.on('blur', function(field) {
            	if (!field.isValid()) {
                	Ext.Msg.alert('', 'El valor: ' + field.getValue() + ' es inv&aacute;lido');
                	field.reset();
                }
            });
     
     
	filtroPorcentajeRecup.max.on('blur', function(field) {
            	if (!field.isValid()) {
                	Ext.Msg.alert('', 'El valor: ' + field.getValue() + ' es inv&aacute;lido');
                	field.reset();
                }
            });	

	
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busqueda.creaciondesde" label="**Desde" name="filtroFechaCreacionDesde" searchOnEnter="true"
	/>
	<%--
	<pfsforms:datefield labelKey="" label="" name="filtroFechaCreacionHasta"
	 /> --%>
	var filtroFechaCreacionHasta = new Ext.ux.form.XDateField({
		name : 'filtroFechaCreacionHasta'
		,hideLabel:true
		,listeners:{
			specialkey: function(f,e){				
	           if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
	                buscarFunc();
	            }  
	        } 
		}
	}); 
	
	var fechaCrecionMinMax = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:3
		}
		,width:400
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,bodyStyle:'padding:0px;cellspacing:5px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{width:'0px'}
			<pfs:items items="filtroFechaCreacionDesde" />
			<pfs:items items="filtroFechaCreacionHasta" />
		]
	});
	
	 <%--
	<pfs:panel name="fechaCrecionMinMax" columns="2" collapsible="false" hideBorder="true" >
		<pfs:items items="filtroFechaCreacionDesde" />
		<pfs:items items="filtroFechaCreacionHasta" />
	</pfs:panel> 
	
	 <%--
	var fechaCrecionMinMax = function(){
		var width1 = 45;
		var width2 = 45;
		var widthPanel = 250;
		var widthFieldSet = 200;
		var labelWidth =108;
		var maxLength = "15";
		<pfsforms:datefield labelKey="" label="" name="min"
	 	 width="200"/>
		<pfsforms:datefield labelKey="" label="" name="max"
		 width="200"/> 
		var cfgPanel = {
			style : "margin-top:4px;margin-bottom:2px;"
		};
		if (config.widthPanel){ cfgPanel.width = widthPanel; }
	
		var cfgFieldSet = {};
		if (config.widthFieldSet) { cfgFieldSet.width = widthFieldSet; }
	
	
		return {
			min : min
			,max : max
			,panel : app.creaPanelHz(cfgPanel,[{html:**Fecha creaci�n+ ":", border: false, width : labelWidth, cls: 'x-form-item'}, min, {html : ' ', border:false, width : 5},  max])
		};
	};
	 --%>

	<pfsforms:ddCombo name="filtroTipoReclamacion"
		labelKey="plugin.busquedaProcedimientos.busca.tipoReclamacion"
		label="**Tipo de Reclamacion" value="" dd="${ddTiposReclamacion}" 
		 width="250" searchOnEnter="true"/>

	var filtroNumeroAutosPanel = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:4
		}
		,width:300
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,bodyStyle:'padding:0px;cellspacing:5px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{items:[filtroNumeroCodigoProclabel]}
			//,{width:'60px'}
			,{items:[filtroNumeroCodigoProc]}
			,{items:[{border:false,html:'/'}]}
			,{items:[filtroAnyoCodigoProc]}
		]
	});
	
	
	/*
	 * filtro de DEMANDADOS
	 */
	
	//Template para el combo de demandados
    var demandadoTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{nombre}</p>',
        '</div></tpl>'
    );
    
    //Store del combo de usuarios
    var demandadosComboStore = page.getStore({
        flow:'busquedaprocedimientos/getDemandadosInstant'
        ,remoteSort:false
        ,autoLoad: false
        ,reader : new Ext.data.JsonReader({
            root:'data'
            ,fields:['id', 'nombre']
        })
    });    
    
    //Combo de usuarios
    var filtroUsuarioDemandado = new Ext.form.ComboBox({
        name: 'filtroUsuarioDemandado' 
        ,store:demandadosComboStore
        ,width:300
        ,fieldLabel: '<s:message code="plugin.busquedaProcedimientos.busca.demandado" text="**Demandado"/>'
        ,tpl: demandadoTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,allowBlank:true
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 3
        ,displayField:'nombre'
        ,valueField:'id'
        //,hidden:false
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
    });
		 
		 
	var filtrosTabDatosProcedimiento = new Ext.Panel({
		title:'<s:message code="plugin.busquedaProcedimientos.busca.procedimientos" text="**Filtros por datos del procedimiento" />'
		,autoHeight:true
		,bodyStyle:'padding: 0px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroEstadoProcedimiento,filtroTipoActuacion,filtroTipoProcedimiento,
						filtroTipoActuacionPadre,filtroTipoProcedimientoPadre, filtroUsuarioDemandado]
				},{
					layout:'form'
					,items: [filtroNumeroAutosPanel,filtroPlaza,filtroJuzgado,filtroTipoReclamacion,filtroSaldoTotalContratos.panel,filtroPorcentajeRecup.panel,
						fechaCrecionMinMax]
				}]
	});
		
		
	<%--***************************************************************************************
	************ PESTA�A DE TAREAS*************************************************************
	************************************************************************************** --%>	 
	<%--
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busqueda.finPrimeraTarea" label="**Fecha de fin de la primera tarea" name="filtroFechaFinPrimeraTarea"/>
	
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busqueda.finSegundaTarea" label="**Fecha de fin de la �ltima tarea" name="filtroFechaFinUltimaTarea"/>
	
	
	var filtrosTabDatosTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaProcedimientos.busca.tareas" text="**Filtros por datos de tareas" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroFechaFinPrimeraTarea,filtroFechaFinUltimaTarea]
				}]
	});
	--%>
	
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busqueda.finPrimeraTarea" label="**Fecha de fin de la primera tarea" name="filtroFechaFinPrimeraTareaDesde" searchOnEnter="true"/>
	
	
	
	var filtroFechaFinPrimeraTareaHasta = new Ext.ux.form.XDateField({
		name : 'filtroFechaFinPrimeraTareaHasta'
		,hideLabel:true
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '')) { 
	                buscarFunc();
	            }  
	        } 
		}
	}); 
	
	
	var fechaFinPrimeraTareaMinMax = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:3
		}
		,width:400
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,bodyStyle:'padding:0px;cellspacing:5px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{width:'0px'}
			<pfs:items items="filtroFechaFinPrimeraTareaDesde" />
			<pfs:items items="filtroFechaFinPrimeraTareaHasta" />
		]
	});
	
	<%--
	var fechaFinPrimeraTareaMinMax = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:10px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', style:'margin-top:12px',items:[filtroFechaFinPrimeraTareaDesde]}
			,{layout:'form',items:[filtroFechaFinPrimeraTareaHasta]}
		]
	});  --%>
	
	<pfsforms:datefield labelKey="plugin.busquedaProcedimientos.busqueda.finSegundaTarea" label="**Fecha de fin de la última tarea" name="filtroFechaFinUltimaTareaDesde" searchOnEnter="true"/>
	
	var filtroFechaFinUltimaTareaHasta = new Ext.ux.form.XDateField({
		name : 'filtroFechaFinUltimaTareaHasta'
		,hideLabel:true
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '')) {
	                buscarFunc();
	            }  
	        } 
		}
	});  
	
	var fechaFinUltimaTareaMinMax = new Ext.Panel({
		layout:'table'
		,title : ''
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:3
		}
		,width:400
		,style:'margin-right:20px;margin-left:0px'
		,border:false
		,bodyStyle:'padding:0px;cellspacing:5px;padding-bottom: 0px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			{width:'0px'}
			<pfs:items items="filtroFechaFinUltimaTareaDesde" />
			<pfs:items items="filtroFechaFinUltimaTareaHasta" />
		]
	});
	
	
	var filtrosTabDatosTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaProcedimientos.busca.tareas" text="**Filtros por datos de tareas" />'
		,autoHeight:true
		,bodyStyle:'padding: 0px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [fechaFinPrimeraTareaMinMax,fechaFinUltimaTareaMinMax]
				}]
	});
	
	
	<%--***************************************************************************************
	**************PESTA�A DE C�DIGOS***********************************************************
	*******************************************************************************************
	 --%>
		
	<pfsforms:numberfield name="filtroCodigoInterno" 
		labelKey="plugin.busquedaProcedimientos.busca.codigoProcedimiento" 
		label="**Código del procedimiento" 
		value="" searchOnEnter="true"
		allowDecimals="false" 
		allowNegative="false"/>
		
	<pfsforms:textfield name="filtroCodigoContrato" 
		labelKey="plugin.busquedaProcedimientos.busca.codigoContrato" 
		label="**Código del contrato" 
		value="" searchOnEnter="true"/>
		
	<pfsforms:textfield name="filtroCodigoCliente" 
		labelKey="plugin.busquedaProcedimientos.busca.codigoCliente" 
		label="**Código del cliente" 
		value="" searchOnEnter="true"/>
		
	<pfsforms:textfield name="filtroNifCliente" 
		labelKey="plugin.busquedaProcedimientos.busca.nifCliente" 
		label="**N.I.F. del cliente" 
		value="" searchOnEnter="true"/>
		
	<pfsforms:numberfield name="filtroCodigoAsunto" 
		labelKey="plugin.busquedaProcedimientos.busca.codigoAsunto" 
		label="**Código del asunto" 
		value="" searchOnEnter="true" 
		allowDecimals="false" 
		allowNegative="false"
		/>	
		
	filtroCodigoAsunto.setWidth(177);	 
	  
	 var filtrosTabCodigos = new Ext.Panel({
		title:'<s:message code="plugin.busquedaProcedimientos.busca.codigos" text="**Filtros por códigos" />'
		,autoHeight:true
		,bodyStyle:'padding: 0px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroCodigoInterno,filtroCodigoContrato,filtroCodigoAsunto]
				},
				{
					layout:'form'
					,items: [filtroNifCliente,filtroCodigoCliente]
				}]
	});    			
	
	<%--**************************************************************************
	************DEFINIMOS EL GRID RESULTADO DE LA B�SQUEDA************************
	 *******************************************************************************--%>
			
	<pfs:defineRecordType name="ProcedimientosRT">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="PRC_ID" />
			<pfs:defineTextColumn name="DD_EPR_ID" />
			<pfs:defineTextColumn name="p.asunto.nombre" />
			<pfs:defineTextColumn name="DD_JUZ_ID" />
			<pfs:defineTextColumn name="DD_PLA_ID" />
			<pfs:defineTextColumn name="PRC_COD_PROC_EN_JUZGADO" />
			<pfs:defineTextColumn name="DD_TPO_ID" />
			<pfs:defineTextColumn name="p.auditoria.fechaCrear" />
			<pfs:defineTextColumn name="DES_ID" />
			<pfs:defineTextColumn name="GAS_ID" />
			<pfs:defineTextColumn name="SUP_ID" />
			<pfs:defineTextColumn name="PRC_SALDO_RECUPERACION" />
			<pfs:defineTextColumn name="PRC_PRC_ID" />						
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="procedimientosCM">
		<pfs:defineHeader  dataIndex="PRC_COD_PROC_EN_JUZGADO"
			captionKey="plugin.busquedaProcedimientos.busca.numeroAutos" caption="**Nº Procedimiento en juzgado"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="DD_EPR_ID"
			captionKey="plugin.busquedaProcedimientos.busca.estado" caption="**Estado del procedimiento"
			sortable="true"  />
		<pfs:defineHeader dataIndex="DD_TPO_ID"
			captionKey="plugin.busquedaProcedimientos.busca.tipoProcedimiento" caption="**Tipo de Procedimiento"
			sortable="false" />
		<pfs:defineHeader dataIndex="p.asunto.nombre"
			captionKey="plugin.busquedaProcedimientos.configuracion.asunto" caption="**Asunto"
			sortable="true"  />
		<pfs:defineHeader dataIndex="DD_JUZ_ID"
			captionKey="plugin.busquedaProcedimientos.editarPlazo.tipJuzgado" caption="**Juzgado"
			sortable="true" />
		<pfs:defineHeader dataIndex="DD_PLA_ID"
			captionKey="plugin.busquedaProcedimientos.configuracion.plaza" caption="**Plaza"
			sortable="false" />
		<pfs:defineHeader dataIndex="PRC_SALDO_RECUPERACION"
			captionKey="plugin.busquedaProcedimientos.configuracion.principal" caption="**Procedimiento principal"
			sortable="true"  
			align="right"
			renderer="app.format.moneyRenderer"	/>
		<pfs:defineHeader dataIndex="p.auditoria.fechaCrear"
			captionKey="plugin.busquedaProcedimientos.configuracion.fechaInicio" caption="**Fecha de inicio"
			sortable="true" />
		<pfs:defineHeader dataIndex="DES_ID"
			captionKey="plugin.busquedaProcedimientos.configuracion.despacho" caption="**Despacho"
			sortable="false"  />
				
		<pfs:defineHeader dataIndex="PRC_ID"
			captionKey="plugin.busquedaProcedimientos.configuracion.codigoInterno" caption="**Código interno"
			sortable="true"  hidden="true"/>	
		<pfs:defineHeader dataIndex="GAS_ID"
			captionKey="plugin.busquedaProcedimientos.configuracion.gestor" caption="**Gestor"
			sortable="false" hidden="true" />	
		<pfs:defineHeader dataIndex="SUP_ID"
			captionKey="plugin.busquedaProcedimientos.configuracion.supervisor" caption="**Supervisor"
			sortable="false"  hidden="true"/>
		<pfs:defineHeader dataIndex="PRC_PRC_ID"
			captionKey="plugin.busquedaProcedimientos.configuracion.padre" caption="**Procedimiento Padre"
			sortable="true"  hidden="true"/> 
	</pfs:defineColumnModel>
		
	
	<%--****************************************************************************************************
	********************PANEL DE B�SQUEDA*******************************************************************
	**************************************************************************************************** --%>
	
	<pfs:defineParameters name="getParametros" paramId="" 
		 asunto="filtroDescripcionAsunto" 
		 tipoGestor="comboTiposGestor"
		 comite="filtroComite"
		 gestor="comboGestor"
		 despacho="comboDespachos"
		 estadoAsunto="filtroEstadoAsunto"
		 importeTotalMin="filtroImporteTotal.min"
		 importeTotalMax="filtroImporteTotal.max"
		 tipoReclamacion="filtroTipoReclamacion"
		 fechaConformacionAsuntoDesde_date="filtroFechaConformacionAsuntoDesde"
		 filtroFechaConformacionAsuntoDesde_date="filtroFechaConformacionAsuntoHasta"
		 fechaAceptacionInicialDesde_date="filtroFechaAceptacionInicialDesde"
		 fechaAceptacionInicialHasta_date="filtroFechaAceptacionInicialHasta"
		 
		 estadoProcedimiento="filtroEstadoProcedimiento"
		 codigoProcedimientoEnJuzgado="filtroNumeroAutos"
		 numeroProcedimientoEnJuzgado="filtroNumeroCodigoProc"
		 anyoProcedimientoEnJuzgado="filtroAnyoCodigoProc"
		 tipoActuacion="filtroTipoActuacion"
		 tipoProcedimiento="filtroTipoProcedimiento"
		 tipoActuacionPadre="filtroTipoActuacionPadre"
		 tipoProcedimientoPadre="filtroTipoProcedimientoPadre"
		 plaza="filtroPlaza"
		 juzgado="filtroJuzgado"
		 saldoTotalContratosMin="filtroSaldoTotalContratos.min"
		 saldoTotalContratoMax="filtroSaldoTotalContratos.max"
		 porcentajeRecupMin="filtroPorcentajeRecup.min"
		 porcentajeRecupMax="filtroPorcentajeRecup.max"
		 demandado="filtroUsuarioDemandado"
		 
		 codigoInterno="filtroCodigoInterno"
		 codigoContrato="filtroCodigoContrato"
		 codigoCliente="filtroCodigoCliente"
		 nifCliente="filtroNifCliente"
		 codigoAsunto="filtroCodigoAsunto"
		 fechaCrearDesde_date="filtroFechaCreacionDesde"
		 fechaCrearHasta_date="filtroFechaCreacionHasta"
		 
		 fechaFinPrimeraTareaDesde_date="filtroFechaFinPrimeraTareaDesde"
		 fechaFinPrimeraTareaHasta_date="filtroFechaFinPrimeraTareaHasta"
		 fechaFinUltimaTareaDesde_date="filtroFechaFinUltimaTareaDesde"
		 fechaFinUltimaTareaHasta_date="filtroFechaFinUltimaTareaHasta"
		 
		/>
		
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosProcedimiento,filtrosTabDatosAsunto,filtrosTabCodigos,filtrosTabDatosTareas]
		,id:'idTabFiltrosProcedimientos'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:1
	});
		
	<pfs:searchPage searchPanelTitle="**Búsqueda de Procedimientos"  
			searchPanelTitleKey="plugin.busquedaProcedimientos.panel.title" 
			columnModel="procedimientosCM" columns="1"
			gridPanelTitleKey="plugin.busquedaProcedimientos.configuracion.menu" 
			gridPanelTitle="**Procedimientos" 
			createTitleKey="plugin.busqudaProcedimientos.busqueda.grid.nuevo" 
			createTitle="**Nada" 
			createFlow="noSePuedeDesdeAqui" 
			updateFlow="procedimientos/consultaProcedimiento" 
			updateTitleData="p.asunto.nombre"
			dataFlow="plugin.busquedaProcedimientos.buscaProcedimientosData"
			resultRootVar="procedimientos" 
			resultTotalVar="total"
			recordType="ProcedimientosRT" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			gridName="procedimientosGrid"
			iconCls="icon_procedimiento" >
			<pfs:items
			items="filtroTabPanel"
			/>
						
	</pfs:searchPage>
	
	btnBuscar.on('click', function(grid, rowIndex, e) {
		if(getParametros_validarForm()){
			filtroForm.getTopToolbar().setDisabled(true);
		}
	});
	
	dataStore.on('load',function(){
	       filtroForm.getTopToolbar().setDisabled(false);
    });
    
	
	filtroTabPanel.setActiveTab(0);
	
	btnNuevo.hide();
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
</fwk:page>



