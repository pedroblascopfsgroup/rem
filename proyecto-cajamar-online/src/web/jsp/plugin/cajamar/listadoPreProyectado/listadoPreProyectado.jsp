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
		,fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.estadoGestion" text="**Estado gestión"/>'
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
		,fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.tipoPersona" text="**Tipo Persona"/>'
	});
	
	// Field riesgo total
	var mmRiesgoTotal = app.creaMinMaxMoneda('<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.riesgoTotal" text="**Riesgo Total" />', 'riesgo',{width : 80, labelWidth:105});
	
	// Field deuda irregular
	var mmDeudaIrregular = app.creaMinMaxMoneda('<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.deudaIrregular" text="**Deuda Irregular" />', 'deuda',{width : 80, labelWidth:105});
	mmDeudaIrregular.min.setMinValue(0.01);
	
	//Combo Agrupar por
 	var optionsAgruparPorStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
 	       ,data : [
 	       			{"codigo":"EXP", "descripcion":"Expediente"}
 	       			,{"codigo":"CNT", "descripcion":"Contrato"}
 	       	
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
		,fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.agruparPor" text="**Agrupar por"/>'
	});
	
	var mmDiasVencidos = app.creaMinMax('<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.diasVencidos" text="**Días Vencidos" />', 'diasVencidos',{width : 80, labelWidth:105});		
	
	var tramos = <app:dict value="${tramo}" />;
	var propuestas = <app:dict value="${propuesta}" />;
	
	//Doble sel tramo
	var dobleSelTramo = app.creaDblSelect(tramos
                              ,'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.tramo" text="**Tramo" />'
                              ,{<app:test id="dobleSelTramo" />});
                              
    //Doble sel propuesta
	var dobleSelPropuesta = app.creaDblSelect(propuestas
                              ,'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales.propuesta" text="**Propuesta" />'
                              ,{
               						width:250
           						},{<app:test id="dobleSelPropuesta" />} );	
	
	
	// TAB EXPEDIENTE

// codigo expediente
	var txtCodExpediente = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.expediente.codExpediente" text="**Codigo Expediente" />'
		,enableKeyEvents: true
		,allowDecimals: false
		,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
		//,vtype:'numeric'
		
		});
		
	//Combo jerarquia
	
 	var nivelesExp = <app:dict value="${nivelesExp}" blankElement="true" blankElementValue="" blankElementText="---" />; 
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:nivelesExp, value:nivelesExp.diccionario[0].codigo, name: 'nivelesExp',fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.expediente.jerarquia" text="**JerarquÃ­a"/>' })
	
	
	
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
<%-- 		else{ --%>
<%-- 			optionsCentrosStore.webflow({id:0}); --%>
<%-- 		} --%>
	}
	
	recargarComboCentrosExp();
	
	comboJerarquia.on('select',function(){
		dobleSelCentro.reset();
		recargarComboCentrosExp();
	});
	
	var dobleSelCentro = app.creaDblSelect(centro
                              ,'<s:message code="plugin.cajamar.listadoPreProyectado.expediente.centros" text="**Centro" />'
                              ,{store:optionsCentrosStore, /*funcionReset:recargarComboCentrosExp,*/ width:160});	
	
	
	
	var limpiarYRecargar = function(){
		app.resetCampos([dobleSelCentro]);
		//recargarComboCentrosExp();
	
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
	
	
           	                              
	//Doble sel fase
	var dobleSelFase = app.creaDblSelect(fases
                              ,'<s:message code="plugin.cajamar.listadoPreProyectado.expediente.fase" text="**Fase" />'
						,{
               				width:200
           					},{<app:test id="dobleSelFase" />});	
	
	//TAB CONTRATO
	
	// codigo contrato
	//var txtCodContrato = new Ext.form.NumberField({
	var txtCodContrato = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.contrato.codContrato" text="**Codigo Contrato" />'
		,enableKeyEvents: true
		//,allowDecimals: false
		//,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"50f", autocomplete: "off"}
		//,vtype:'numeric'
		
		});
		
	// Field fecha prevista regularizacion
	<pfsforms:datefield name="filtroFechaDesde"
		labelKey="plugin.cajamar.listadoPreProyectado.contrato.fechaPrevista" 
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
	
	var comboJerarquiaContrato = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name: 'jerarquia',fieldLabel:'<s:message code="plugin.cajamar.listadoPreProyectado.contrato.jerarquia" text="**JerarquÃ­a"/>' })
	
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
                              ,'<s:message code="plugin.cajamar.listadoPreProyectado.contrato.centros" text="**Centro" />'
                              ,{store:optionsCentrosContratoStore, /*funcionReset:recargarComboCentros,*/ width:160});	
    
    
    
    var limpiarYRecargar = function(){
		app.resetCampos([dobleSelCentroContrato]);
	}
	
	comboJerarquiaContrato.on('select',limpiarYRecargar);
	
	
	 //filtro Datos Generales
	var filtrosTabDatosGenerales = new Ext.Panel({
		title:'<s:message code="plugin.cajamar.listadoPreProyectado.datosGenerales" text="**Datos del expediente" />'
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
					,items: [mmDiasVencidos.panel,dobleSelTramo,dobleSelPropuesta]
				}]
		
	});
	
	
	
	//filtro Expediente
	var filtrosTabExpediente = new Ext.Panel({
		title:'<s:message code="plugin.cajamar.listadoPreProyectado.expediente" text="**Expediente" />'
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
		title:'<s:message code="plugin.cajamar.listadoPreProyectado.contrato" text="**Contrato" />'
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
 			mmDiasVencidos.min,
 			mmDiasVencidos.max,
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
		if (!app.validaValoresDblText(mmDiasVencidos)){
			return false;
		}
		return true;
	}
	
	var validaMinDeudaIrregular = function() {
		if (mmDeudaIrregular.min.getValue()!=null 
		&& (!(mmDeudaIrregular.min.getValue()===''))) {
			if (new Number(mmDeudaIrregular.min.getValue()) < 0.01) {
				return false;
			}
		}
		return true;
	}
	
	var validaMinDiasVencidos = function() {
		if (mmDiasVencidos.min.getValue()!=null
			&& (!(mmDiasVencidos.min.getValue()===''))) {
			if (new Number(mmDiasVencidos.min.getValue()) < 0) {
				return false;
			}
		}
		return true;
	}
	
	var limit = 25;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
	};
	
	var contratosRecord = Ext.data.Record.create([
		{name:'cntId'}
		,{name:'contrato'}
		,{name:'expId'}
		,{name:'riesgoTotal'}
		,{name:'deudaIrregular'}
		,{name:'tramo'}
		,{name:'diasVencidos'}
		,{name:'fechaPaseAMoraCnt'}
		,{name:'propuesta'}
		,{name:'estadoGestion'}
		,{name:'fechaPrevReguCnt'}
	]);

	 var preProCntsStore = page.getStore({
		id:'preProStore'
		//,remoteSort:true
		//,event:'listado'
		,storeId : 'preProCntsStore'
		,limit: limit
		,baseParams: paramsBusquedaInicial
		,flow:'listadopreproyectado/getListPreproyectadoCnt'
 		//,reader : new Ext.data.JsonReader({root:'contratos',totalProperty : 'total'}, contratosRecord)
 		,reader : new Ext.data.JsonReader({root:'contratos'}, contratosRecord)
	});
	
	var contratosCM = new Ext.grid.ColumnModel([
		{header: 'Id', dataIndex: 'cntId',sortable:false, hidden: true}
		,{header: '<s:message code="preproyectado.contratos.nrocontrato" text="**Nro. contrato" />',dataIndex: 'contrato',sortable:true}		
		,{header: '<s:message code="preproyectado.contratos.idexpediente" text="**ID Expediente" />',dataIndex: 'expId',sortable:true}
		,{header: '<s:message code="preproyectado.contratos.riesgoTotal" text="**Riesgo Total" />',dataIndex: 'riesgoTotal',sortable:true, renderer: app.format.moneyRenderer, align: 'right'}
		,{header: '<s:message code="preproyectado.contratos.deudaIrregular" text="**Deuda Irregular" />',dataIndex: 'deudaIrregular',sortable:true, renderer: app.format.moneyRenderer, align: 'right'}
		,{header: '<s:message code="preproyectado.contratos.tramo" text="**Tramo" />',dataIndex: 'tramo',sortable:true}
		,{header: '<s:message code="preproyectado.contratos.diasVencidos" text="**Días vencidos" />',dataIndex: 'diasVencidos',sortable:true, align: 'right'}
		,{header: '<s:message code="preproyectado.contratos.fechaPaseAMora" text="**Fecha pase a mora" />',dataIndex: 'fechaPaseAMoraCnt',sortable:true}
		,{header: '<s:message code="preproyectado.contratos.propuesta" text="**Última Propuesta" />',dataIndex: 'propuesta',sortable:true}
		,{header: '<s:message code="preproyectado.contratos.estadoGestion" text="**Estado Gestión" />',dataIndex: 'estadoGestion',sortable:true}
		,{header: '<s:message code="preproyectado.contratos.fechaPrevistaRegularizacion" text="**Fecha prevista regularización" />',dataIndex: 'fechaPrevReguCnt',sortable:true}
	]);
	
	var pagingBar = fwk.ux.getPaging(preProCntsStore);
	
	var contratosGrid=app.crearEditorGrid(preProCntsStore,contratosCM,{
        title:'<s:message code="preproyectado.contratos.cabecera" text="**Contratos" />'
        ,id:'cntId'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:500 //350
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
        ,bbar : [pagingBar]
        ,collapsed: true
        ,hidden: true
    });	
    
	contratosGrid.on('rowdblclick',function(grid, rowIndex, e) {
		var recStore = grid.getStore().getAt(rowIndex);
		if (recStore == null) return;
		
		var cntId = recStore.get('cntId');
		var contrato = recStore.get('contrato');
		
		app.abreContrato(cntId, contrato);
	});    
    
	var expedientesRecord = Ext.data.Record.create([
		{name:'expId'}
		,{name:'titular'}
		,{name:'nifTitular'}
		,{name:'telf1'}
		,{name:'fase'}		
		,{name:'fechaVtoTarea'}
		,{name:'numContratos'}
		,{name:'volRiesgoExp'}
		,{name:'importeInicialExp'}
		,{name:'regularizadoExp'}
		,{name:'importeActual'}
		,{name:'importePteDifer'}
		,{name:'tramoExp'}
		,{name:'diasVencidosExp'}
		,{name:'fechaPaseAMoraExp'}
		,{name:'propuesta'}
		,{name:'fechaPrevReguExp'}
		,{name:'expDescripcion'}
		,{name:"contratos"}	
	]);

	 var preProExpsStore = page.getGroupingStore({
		id:'preProStore'
		//,remoteSort:true
		//,event:'listado'
		,storeId : 'preProExpsStore'
		,limit: limit
		,baseParams: paramsBusquedaInicial
		,flow:'listadopreproyectado/getListPreproyectadoExp'
 		//,reader : new Ext.data.JsonReader({root:'expedientes',totalProperty : 'total'}, expedientesRecord)
 		,reader : new Ext.data.JsonReader({root:'expedientes'}, expedientesRecord)
	});
	
	var expanderExp = new Ext.ux.grid.RowExpander({
		renderer: function(v, p, record) {
			if (record.data.contratos!=undefined) {
				if (record.data.contratos.length>0) {
					return '<div class="x-grid3-row-expander"></div>';
				} else {
					return ' ';
				}
			}
		},
		tpl : new Ext.Template('<div id="myrow-cnt-{expId}"></div>')
	});
	
	function expandedRowExp(obj, record, body, rowIndex) {
		var expId = record.get('expId');
		var row = "myrow-cnt-" + record.get('expId');
		
		var contratos = record.get('contratos');
		
		if (contratos.length) {
			var dynamicStoreExp = new Ext.data.JsonStore({
				fields: ['cntId'
						,'contrato'
						,'expId'
						,'riesgoTotal'
						,'deudaIrregular'
						,'tramo'
						,'diasVencidos'
						,'fechaPaseAMoraCnt'
						,'propuesta'
						,'estadoGestion'
						,'fechaPrevReguCnt'				
				],
				data: contratos
			});
			
			var id2 = "mygrid-exp-" + record.get('expId');
			
			var gridXExpediente = new Ext.grid.GridPanel({
				store: dynamicStoreExp
				,stripeRows: true
				,autoHeight: true
				,cm: contratosCM
				,id: id2
			});
			
			gridXExpediente.render(row);
			gridXExpediente.getEl().swallowEvent(['mouseover','mousedown','click','dblclick']);
			
			
			gridXExpediente.on('rowdblclick',function(grid, rowIndex, e) {
				var recStore = grid.getStore().getAt(rowIndex);
				if (recStore == null) return;
				
				var cntId = recStore.get('cntId');
				var contrato = recStore.get('contrato');
				
				app.abreContrato(cntId, contrato);
			});
		}
	}
	
	expanderExp.on('expand',expandedRowExp);
	
	var cssExp = 'background-color: #99CCFF;';
	
	var expedientesCM = new Ext.grid.ColumnModel([
		expanderExp
		,{header: 'Id', dataIndex: 'expId',sortable:false, hidden: true}
		,{header: '<s:message code="preproyectado.expedientes.idexpediente" text="**IDEXPEDIENTE" />',dataIndex: 'expId',sortable:true, css: cssExp}		
		,{header: '<s:message code="preproyectado.expedientes.titular" text="**Titular" />',dataIndex: 'titular',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.niftitular" text="**NIF Titular" />',dataIndex: 'nifTitular',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.telef1" text="**Telf_1" />',dataIndex: 'telf1',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.fase" text="**Fase" />',dataIndex: 'fase',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.fechaVtoTarea" text="**Fecha vto tarea" />',dataIndex: 'fechaVtoTarea',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.numContratos" text="**Nro. contratos" />',dataIndex: 'numContratos',sortable:true, align: 'right', css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.volRiesgoExp" text="**Vol. Riesgo Exp." />',dataIndex: 'volRiesgoExp',sortable:true, renderer: app.format.moneyRenderer, align: 'right', css: cssExp}		
		,{header: '<s:message code="preproyectado.expedientes.importeInicialExp" text="**Importe inicial" />',dataIndex: 'importeInicialExp',sortable:true, renderer: app.format.moneyRenderer, align: 'right', css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.regularizadoExp" text="**Regularizado" />',dataIndex: 'regularizadoExp',sortable:true, renderer: app.format.moneyRenderer, align: 'right', css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.importeActual" text="**Importe Actual" />',dataIndex: 'importeActual',sortable:true, renderer: app.format.moneyRenderer, align: 'right', css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.importePteDifer" text="**Importe a diferir" />',dataIndex: 'importePteDifer',sortable:true, renderer: app.format.moneyRenderer, align: 'right', css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.tramoExp" text="**Tramo" />',dataIndex: 'tramoExp',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.diasVencidosExp" text="**Días vencidos" />',dataIndex: 'diasVencidosExp',sortable:true, align: 'right', css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.fechaPaseAMoraExp" text="**Fecha pase a mora" />',dataIndex: 'fechaPaseAMoraExp',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.propuesta" text="**Propuesta" />',dataIndex: 'propuesta',sortable:true, css: cssExp}
		,{header: '<s:message code="preproyectado.expedientes.fechaPrevReguExp" text="**Fecha prevista regularización" />',dataIndex: 'fechaPrevReguExp',sortable:true, css: cssExp}		
	]);
	
	var pagingBar = fwk.ux.getPaging(preProExpsStore);
	
    var expandAll = function() {
     	for (var i=0; i < preProExpsStore.getCount(); i++){
	      expanderExp.expandRow(i);		  
	    }
    };
    
     var collapseAll = function() {
     	for (var i=0; i < preProExpsStore.getCount(); i++){
	      expanderExp.collapseRow(i);		  
	    }
    };	
	
	var btnCollapseAll =new Ext.Button({
  		tooltip:'<s:message code="preproyectado.expedientes.collapseAll" text="**Contraer todo" />'
        ,iconCls : 'icon_collapse'
	    ,cls: 'x-btn-icon'
	    ,handler:collapseAll
	    ,disabled: false
  	});
  	
  	var btnExpandAll =new Ext.Button({
      	tooltip:'<s:message code="preproyectado.expedientes.expandAll" text="**Expandir todo" />'	    
	    ,iconCls : 'icon_expand'
	    ,cls: 'x-btn-icon'
	    ,handler:expandAll
	    ,disabled: false
  	});
	
	
	var expedientesGrid=app.crearEditorGrid(preProExpsStore,expedientesCM,{
        title:'<s:message code="preproyectado.expedientes.cabecera" text="**Expedientes" />'
        ,id:'expId'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:500 //350
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
        ,bbar : [btnExpandAll, btnCollapseAll, pagingBar]
        ,collapsed: true
        ,hidden: true
        ,plugins: expanderExp
    });	
    
	expedientesGrid.on('rowdblclick',function(grid, rowIndex, e) {
		var recStore = grid.getStore().getAt(rowIndex);
		if (recStore == null) return;
		
		var expId = recStore.get('expId');
		var expDescripcion = recStore.get('expDescripcion');
		
		app.abreExpediente(expId, expDescripcion);
	});    
	
	var validarEmptyForm = function(){
		if(comboEstadoGestion.getValue() != ''){
			return true;
		}
		
		if(comboTipoPersona.getValue() != ''){
			return true;
		}
		
		if(!(mmRiesgoTotal.min.getValue() === '')){
			return true;
		}
		
 		if(!(mmRiesgoTotal.max.getValue() === '')){
			return true; 			
 		}
		if(!(mmDeudaIrregular.min.getValue() === '')){
			return true;		
		}
		if(!(mmDeudaIrregular.max.getValue() === '')){
			return true;		
		}
		
		if(!(mmDiasVencidos.min.getValue() === '')){
			return true;
		}
		if(!(mmDiasVencidos.max.getValue() === '')){
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
		param.minDiasVencidos=mmDiasVencidos.min.getValue();
		param.maxDiasVencidos=mmDiasVencidos.max.getValue();
		param.tramos=dobleSelTramo.getValue();
		param.propuestas=dobleSelPropuesta.getValue();
			
		return param;
	};
	
	var buscarFunc = function(){
		if(validarEmptyForm()){
			if(validaMinMax()){
				if (validaMinDeudaIrregular()) {
					if (validaMinDiasVencidos()) {
						panelFiltros.collapse(true);
						if (comboAgruparPor.getValue()=='CNT') {
							expedientesGrid.collapse(true);
							expedientesGrid.hide();
							contratosGrid.show();
							contratosGrid.expand(true);
							preProCntsStore.webflow(getParametros());
						}
						if (comboAgruparPor.getValue()=='EXP') {
							contratosGrid.collapse(true);
							contratosGrid.hide();
							expedientesGrid.show();
							expedientesGrid.expand(true);
							preProExpsStore.webflow(getParametros());
						}
					} else {
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.minDiasVencidos"/>');
					}
				} else {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.minDeudaIrregular"/>');
				}
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
				if (validaMinDeudaIrregular()) {
					var params=getParametros();
		        	var flow='/pfs/listadopreproyectado/generarInformeListadoPreProyectado';
		        	app.openBrowserWindow(flow,params);
				} else {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.minDeudaIrregular"/>');
				}		        	
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
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
    			,items:[contratosGrid, expedientesGrid]
			}
		]
		,autoHeight : true
	    ,border: false
	});
	
		
	//añadimos el panel principal a la pagina
	page.add(mainPanel);
	
	expedientesGrid.hide();
	contratosGrid.hide();	
	

</fwk:page>