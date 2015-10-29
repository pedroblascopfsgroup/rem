<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<fwk:page>

	var tabExpediente= false;
	var tabContrato = false;

	//TAB DATOS GENERALES
	
	//Combo Estado Gestión
	var estadosGestion = <app:dict value="${estadosGestion}" blankElement="true" blankElementValue=""/>;
	var optionsEstadoGestionStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : estadosGestion
	});
	
	var comboEstadoGestion = new Ext.form.ComboBox({
		store: optionsEstadoGestionStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,style:'margin:0px'
		,width:170
		,triggerAction:'all'
		,editable: false
		,emptyText:'---'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.estadoGestion" text="**Estado gestión"/>'
	});
	
	//Combo Tipo persona
	var tipoPersonas = <app:dict value="${tipoPersonas}" blankElement="false" />;
	
	var optionsTipoPersonaStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : tipoPersonas
	});
	
	var comboTipoPersona = new Ext.form.ComboBox({
		store: optionsTipoPersonaStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,style:'margin:0px'
		,triggerAction:'all'
		,editable: false
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.tipoPersona" text="**Tipo Persona"/>'
	});
	
	// Field riesgo total
	var mmRiesgoTotal = app.creaMinMaxMoneda('<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.riesgoTotal" text="**Riesgo Total" />', 'riesgo',{width : 80, labelWidth:105});
	
	// Field deuda irregular
	var mmDeudaIrregular = app.creaMinMaxMoneda('<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.deudaIrregular" text="**Deuda Irregular" />', 'deuda',{width : 80, labelWidth:105});
	
	//Combo Agrupar por
 	var optionsAgruparPorStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
 	       ,data : [
 	       			{"codigo":"EXP", "descripcion":"Expediente"}
 	       			,{"codigo":"CTO", "descripcion":"Contrato"}
 	       	
 	       ]
 	}); 
	
	var comboAgruparPor = new Ext.form.ComboBox({
 		store: optionsAgruparPorStore 
		,displayField:'descripcion' 
		,valueField:'codigo' 
		,mode:'local'
		,style:'margin:0px'
		,triggerAction:'all'
		,editable: false
		,value:optionsAgruparPorStore.getAt(0).get('codigo')
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.agruparPor" text="**Agrupar por"/>'
	});
	
	
	var tramos = <app:dict value="${tramo}" />;
	var propuestas = <app:dict value="${propuesta}" />;
	
	//Doble sel tramo
	var dobleSelTramo = app.creaDblSelect(tramos
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.tramo" text="**Tramo" />'
                              ,{<app:test id="dobleSelTramo" />});
                              
    //Doble sel propuesta
	var dobleSelPropuesta = app.creaDblSelect(propuestas
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.propuesta" text="**Propuesta" />'
                              ,{
               						width:250
           						},{<app:test id="dobleSelPropuesta" />} );	
	
	
	// TAB EXPEDIENTE

// codigo expediente
	var txtCodExpediente = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.codExpediente" text="**Codigo Expediente" />'
		,enableKeyEvents: true
		,allowDecimals: false
		,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
		//,vtype:'numeric'
		
		});
		
	//Combo jerarquia
	
 	var nivelesExp = <app:dict value="${nivelesExp}" blankElement="true" blankElementValue="" blankElementText="---" />; 
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:nivelesExp, value:nivelesExp.diccionario[0].codigo, name: 'nivelesExp',fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.jerarquia" text="**Jerarquía"/>' })
	
	
	
	var fases = <app:dict value="${fase}" />;
	
	//Doble sel centro
	
	
	var centro = <app:dict value="${centro}" />;
	
	var centrosRecordExp  = Ext.data.Record.create([
		{name:'codigo'}
	   ,{name:'descripcion'}
		
	]);
	
	var optionsCentrosStore = page.getStore({
	       flow: 'clientes/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, centrosRecordExp)
	       
	});    
	
	var recargarComboCentrosExp = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!='' && comboJerarquia.getValue()!='---'){
			optionsCentrosStore.webflow({id:comboJerarquia.getValue()});
		}
<!-- 		else{ -->
<!-- 			optionsCentrosStore.webflow({id:0}); -->
<!-- 		} -->
	}
	
	recargarComboCentrosExp();
	
	comboJerarquia.on('select',function(){
		dobleSelCentro.reset();
		recargarComboCentrosExp();
	});
	
	var dobleSelCentro = app.creaDblSelect(centro
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.centros" text="**Centro" />'
                              ,{store:optionsCentrosStore, /*funcionReset:recargarComboCentrosExp,*/ width:160});	
	
	
	
	var limpiarYRecargar = function(){
		app.resetCampos([dobleSelCentro]);
		//recargarComboCentrosExp();
	
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
	
	
           	                              
	//Doble sel fase
	var dobleSelFase = app.creaDblSelect(fases
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.fase" text="**Fase" />'
						,{
               				width:200
           					},{<app:test id="dobleSelFase" />});	
	
	//TAB CONTRATO
	
	// codigo contrato
	//var txtCodContrato = new Ext.form.NumberField({
	var txtCodContrato = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.codContrato" text="**Codigo Contrato" />'
		,enableKeyEvents: true
		//,allowDecimals: false
		//,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"50f", autocomplete: "off"}
		//,vtype:'numeric'
		
		});
		
	// Field fecha prevista regularizacion
	<pfsforms:datefield name="filtroFechaDesde"
		labelKey="plugin.mejoras.listadoPreProyectado.contrato.fechaPrevista" 
		label="**Fecha prevista refularizacion" width="140"/>
		
	filtroFechaDesde.id='filtroFechaDesdeRecobroListaCarteras';		
	
 	var filtroFechaHasta = new Ext.ux.form.XDateField({ 
 		name : 'filtroFechaAltaHasta' 
 		,hideLabel:true 
 		,width:100 
 	}); 
	
	var panelFechasPrevistaRegul = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'panelFechasPrevistaRegul'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,autoWidth:true
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[filtroFechaDesde]}
			,{layout:'form',items:[filtroFechaHasta]}
		]
	}); 
	
	//Combo jerarquia
	
	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />; 
	
	var comboJerarquiaContrato = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name: 'jerarquia',fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.jerarquia" text="**Jerarquía"/>' })
	
	var centros = <app:dict value="${zonas}" />;
	
	//Doble sel centro
	
	 var centrosRecord  = Ext.data.Record.create([
		{name:'codigo'}
	   ,{name:'descripcion'}
		
	]);
	
	
	var optionsCentrosContratoStore = page.getStore({
	       flow: 'clientes/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, centrosRecord)
	       
	}); 
	
	var recargarComboCentros = function(){
		if (comboJerarquiaContrato.getValue()!=null && comboJerarquiaContrato.getValue()!=''){
			optionsCentrosContratoStore.webflow({id:comboJerarquiaContrato.getValue()});
		}else{
			//optionsCentrosContratoStore.webflow({id:0});
		}
	}
	
	recargarComboCentros();
	
	comboJerarquiaContrato.on('select',function(){
		dobleSelCentroContrato.reset();
		recargarComboCentros();
	});
	
	var dobleSelCentroContrato = app.creaDblSelect(centros
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.centros" text="**Centro" />'
                              ,{store:optionsCentrosContratoStore, /*funcionReset:recargarComboCentros,*/ width:160});	
    
    
    
    var limpiarYRecargar = function(){
		app.resetCampos([dobleSelCentroContrato]);
	}
	
	comboJerarquiaContrato.on('select',limpiarYRecargar);
	
	
	 //filtro Datos Generales
	var filtrosTabDatosGenerales = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales" text="**Datos del expediente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboEstadoGestion,comboTipoPersona,mmRiesgoTotal.panel,mmDeudaIrregular.panel,comboAgruparPor]	
		
				},
				{
					layout:'form'
					,items: [dobleSelTramo,dobleSelPropuesta]
				}]
		
	});
	
	
	
	//filtro Expediente
	var filtrosTabExpediente = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente" text="**Expediente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items:[txtCodExpediente,comboJerarquia,dobleSelCentro]
				},{
					layout:'form'
					,items:[dobleSelFase]
				}
				]
	});
	
	filtrosTabExpediente.on('activate',function(){
		tabExpediente=true;
	});
	
	//Filtro Contrato

	var filtrosTabContrato = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato" text="**Contrato" />'
		,autoWidth:true
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items:[txtCodContrato, panelFechasPrevistaRegul]
					,autoWidth:true
				}
				,{
					layout:'form'
					,items:[comboJerarquiaContrato,dobleSelCentroContrato]
				}]
	});
	
	filtrosTabContrato.on('activate',function(){
		tabContrato=true;
	});
	
	//filtro pestañas
	var filtroTabPanel= new Ext.TabPanel({
		items:[filtrosTabDatosGenerales,filtrosTabExpediente,filtrosTabContrato]
		,layoutOnTabChange:true
		,autoScroll:true
		,autoHeight:true
		,autoWidth:true
		,border:false
		,activeItem:0
	});
	
	//Boton limpiar
	var btnReset = app.crearBotonResetCampos([ 
 			comboEstadoGestion,
 			comboTipoPersona,
 			mmRiesgoTotal.min,
 			mmRiesgoTotal.max,
 			mmDeudaIrregular.min,
 			mmDeudaIrregular.max,
 			comboAgruparPor,
 			dobleSelTramo,
 			dobleSelPropuesta,
 			txtCodExpediente,
 			comboJerarquia,
 			dobleSelCentro,
 			dobleSelFase,
 			txtCodContrato,
 			filtroFechaDesde,
 			filtroFechaHasta,
 			comboJerarquiaContrato,
 			dobleSelCentroContrato
 			
 	]);
 	
 	var validaMinMax = function(){
		if (!app.validaValoresDblText(mmRiesgoTotal)){
			return false;
		}
		if (!app.validaValoresDblText(mmDeudaIrregular)){
			return false;
		}
		return true;
	}
	
	var limit = 25;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
	};

	 var preProStore = page.getStore({
	 
		id:'preProStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'preProStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow:'listadopreproyectado/getListPreproyectadoCnt'
 		,reader : new Ext.data.JsonReader({root:'listado',totalProperty : 'total'})
	});
 	
	var validarEmptyForm = function(){
		if(comboEstadoGestion.getValue() != ''){
			return true;
		}
		
		if(comboTipoPersona.getValue() != ''){
			return true;
		}
		
		if(!mmRiesgoTotal.min.getValue() === ''){
			return true;
		}
		
 		if(!mmRiesgoTotal.max.getValue() === ''){
			return true; 			
 		}
		if(!mmDeudaIrregular.min.getValue() === ''){
			return true;		
		}
		if(!mmDeudaIrregular.max.getValue() === ''){
			return true;		
		}
		
		if(dobleSelTramo.getValue() != ''){
			return true;		
		}
		if(dobleSelPropuesta.getValue() != ''){
			return true;		
		}
		if(tabExpediente){
			if(txtCodExpediente.getValue() != ''){
				return true;		
			}
			
			if(dobleSelCentro.getValue() != ''){  
				return true;
			}
					  
			if(dobleSelFase.getValue() != ''){ 
				return true;
			}
		}
		
		if(tabContrato){		 
			if(txtCodContrato.getValue() != ''){
				return true;		
			}
			if(filtroFechaDesde.getValue() != ''){
				return true;		
			}
			if(filtroFechaHasta.getValue() != ''){
				return true;		
			}
			if(dobleSelCentroContrato.getValue() != ''){
	 			return true;		 
			} 
		}
		
		
		
		return false;
	}
	var param = new Object();
	var getParametrosExpediente = function(){
		if(tabExpediente){
			if(txtCodExpediente.getValue() == 'undefined' || !txtCodExpediente.getValue()){
				txtCodExpediente.setValue('');
			}
			
			if(dobleSelCentro.getValue() == 'undefined' || !dobleSelCentro.getValue()){
				dobleSelCentro.setValue('');
			}
			
			if(dobleSelFase.getValue() == 'undefined' || !dobleSelFase.getValue()){
				dobleSelFase.setValue('');
			}
		}
		if(tabExpediente){
			param.codExpediente=txtCodExpediente.getValue();
			param.zonasExp=dobleSelCentro.getValue();
			param.itinerarios=dobleSelFase.getValue();
		}
		
		return param;
	}
	
	var getParametrosContrato = function(){
		if(tabContrato){
			if(txtCodContrato.getValue() == 'undefined' || !txtCodContrato.getValue()){
				txtCodContrato.setValue('');
			}
			
			if(filtroFechaDesde.getValue() == 'undefined' || !filtroFechaDesde.getValue()){
				filtroFechaDesde.setValue('');
			}
			
			if(filtroFechaHasta.getValue() == 'undefined' || !filtroFechaHasta.getValue()){
				filtroFechaHasta.setValue('');
			}
			
			if(dobleSelCentroContrato.getValue() == 'undefined' || !dobleSelCentroContrato.getValue()){
				dobleSelCentroContrato.setValue('');
			}
		}
		
		if(tabContrato){
			param.codContrato=txtCodContrato.getValue()
			param.fechaPrevRegularizacion=filtroFechaDesde.getValue()
			param.fechaPrevRegularizacionHasta=filtroFechaHasta.getValue()
			param.zonasCto=dobleSelCentroContrato.getValue()
		}
		
		return param;
	}
	
	
	
	var getParametros = function(){
		getParametrosExpediente();
		getParametrosContrato();
		
		
		param.codEstadoGestion=comboEstadoGestion.getValue();
		param.codTipoPersona=comboTipoPersona.getValue();
		param.minRiesgoTotal=mmRiesgoTotal.min.getValue();
		param.maxRiesgoTotal=mmRiesgoTotal.max.getValue();
		param.minDeudaIrregular=mmDeudaIrregular.min.getValue();
		param.maxDeudaIrregular=mmDeudaIrregular.max.getValue();
		param.codAgruparPor=comboAgruparPor.getValue();
		param.tramos=dobleSelTramo.getValue();
		param.propuestas=dobleSelPropuesta.getValue();
			
		return param;
	};
	
	
	var buscarFunc = function(){
		if(validarEmptyForm()){
			if(validaMinMax()){
			
				panelFiltros.collapse(true);
				preProStore.webflow(getParametros());
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>')
		}
	};
	
	var exportarExcel = function(){
		if(validarEmptyForm()){
			if(validaMinMax()){
				var params=getParametros();
		        var flow='/pfs/listadopreproyectado/generarInformeListadoPreProyectado';
		        app.openBrowserWindow(flow,params);
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>')
		}
	};
	
	
	var btnBuscar = new Ext.Button({
			handler: buscarFunc
			,text:'Buscar'
			,iconCls:'icon_busquedas'		
	});
		
	 var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a XLS" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: exportarExcel
    });
    
    

	
	//Agrego los filtros al panel
	var panelFiltros = new Ext.FormPanel({
		title: '<s:message code="preproyectado.listado.filtros" text="**Filtro de PreProyectado" />'
		,defaults : {xtype:'panel' ,cellCls: 'vtop'}
		,bodyStyle:'cellspacing:10px;'
		,collapsible:true
		,titleCollapse:true
		,border:true
		,autoHeight:true
		,autoWidth:true
		,items:[filtroTabPanel]
 		,tbar : [btnBuscar,btnReset,btnExportarXls,'->',app.crearBotonAyuda()] 
	});
	
	//panel principal
	var mainPanel = new Ext.Panel({
		items:[
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[panelFiltros]
			}
		]
		,autoHeight : true
	    ,border: false
	});
	
		
	//añadimos el panel principal a la pagina
	page.add(mainPanel);

</fwk:page>