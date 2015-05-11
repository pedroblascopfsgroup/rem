<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	//envuelve una lista de controles en un fieldSet
	var creaFieldSet = function(items, config){
		var cfg={
			autoHeight:true
			,labelStyle:'font-weight:bolder'
			,border : false
			,items:items
		};
		var ft = new Ext.form.FieldSet(cfg);
		return ft;
	};	
	var estados= <app:dict value="${estados}" />;
	var zonas= <app:dict value="${zonas}" />;
	
	var comboSituacion = app.creaDblSelect(estados, '<s:message code="expedientes.listado.situacion" text="**Situacion" />');
    
	var mmRiesgoTotal = app.creaMinMax('<s:message code="expedientes.listado.riesgoTotal" text="**Riesgo Total" />', 'riesgo');
	var mmSVencido    = app.creaMinMax('<s:message code="expedientes.listado.sVencido" text="**S. Vencido" />', 'svencido');
	
	var tiposPersona = <app:dict value="${tiposPersona}" blankElement="true" blankElementValue="" blankElementText="---" />;
	var comboTipoPersonaTit = app.creaCombo({data:tiposPersona, name : 'tipopersonatit', fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipopersonatitular" text="**Tipo Persona Titular" />' <app:test id="comboTipoPersona" addComa="true" />});	
	
	var txtCodExpediente = new Ext.form.NumberField({
		fieldLabel:'<s:message code="expedientes.listado.codigo" text="**Codigo" />'
		,enableKeyEvents: true
		,allowDecimals: false
		,allowNegative: false
		//,vtype:'numeric'
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER && txtCodExpediente.getValue() > 0) {
      					buscarFunc();
  					}
  				}
		}
		<app:test id="campoCodigoExpediente" addComa="true"/>
	});

	var txtDescripcion=new Ext.form.TextField({
		fieldLabel:'<s:message code="expedientes.listado.descripcion" text="**Descripcion" />'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target,e){
					//Ext.Msg.alert("AA","EE");
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
	});
	
    var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
    
    var comboJerarquia = app.creaCombo({data:jerarquia, 
    									triggerAction: 'all', 
    									value:jerarquia.diccionario[0].codigo, 
    									name : 'jerarquia', 
    									fieldLabel : '<s:message code="expedientes.listado.jerarquia" text="**Jerarquia" />'
    									<app:test id="idComboJerarquia" addComa="true"/>	
    								});

	var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	}
	
	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
	
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
	
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="expedientes.listado.centros" text="**Centros" />',{store:optionsZonasStore, funcionReset:recargarComboZonas});
 
	
		
	recargarComboZonas();
	
	var filtroContrato =new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.contrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,maxLength:10 
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
	});
	
	var dictEstado = {diccionario:[
		{codigo:'1',descripcion:'Activo'}
		,{codigo:'2',descripcion:'Congelado'}
		,{codigo:'3',descripcion:'Decidido'}
		,{codigo:'4',descripcion:'Bloqueado'}
		,{codigo:'5',descripcion:'Cancelado'}
	]};
	
	//store generico de combo diccionario
	var optionsEstadoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictEstado
	});
	
	var comboEstado = new Ext.form.ComboBox({
				store:optionsEstadoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="expedientes.listado.estado" text="**Estado" />'
	});
	Ext.apply(Ext.form.VTypes, {
		numeric: function(val, field) {
			if(app.validate.validateInteger(val)) {
				return true;
			}
			field.focus();
			return false;
		}, numericText: '<s:message code="error.campoNumerico" text="**El campo debe ser un número" />'
	});
		
	var Expediente = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcionExpediente'}
		,{name:'fcreacion'}
		,{name:'origen'}
		,{name:'estadoItinerario'}
		,{name:'oficina'}
		,{name:'estadoExpediente'}
		,{name:'volumenRiesgo'}
		,{name:'volumenRiesgoVencido'}
		,{name:'gestor'}
		,{name:'fcomite'}
		,{name:'comite'}	
	]);
 
	var expStore = page.getStore({
		eventName : 'listado'
		,limit:5
		,flow:'expedientes/listadoExpedientesData'
		,reader: new Ext.data.JsonReader({
	    	root : 'expedientes'
	    	,totalProperty : 'total'
	    }, Expediente)
	});
	
	//Hace la búsqueda inicial
	//expStore.webflow();
	
	var validarEmptyForm = function(){
		if (txtCodExpediente.getValue() != '' && app.validate.validateInteger(txtCodExpediente.getValue())){
			return true;
		}
		if (comboEstado.getValue() != '' ){
			return true;
		}
		if (comboJerarquia.getValue() != '' ){
			return true;
		}
		if (comboZonas.getValue() != '' ){
			return true;
		}
		if (comboSituacion.getValue() != '' ){
			return true;
		}
		if (comboTipoPersonaTit.getValue() != '' ){
			return true;
		}
		if (filtroContrato.getValue() != '' ){
			return true;
		}
		if (txtDescripcion.getValue() != '' ){
			return true;
		}
		if (mmRiesgoTotal.min.getValue() != '' ){
			return true;
		}
		if (mmRiesgoTotal.max.getValue() != '' ){
			return true;
		}
		if (mmSVencido.min.getValue() != '' ){
			return true;
		}
		if (mmSVencido.max.getValue() != '' ){
			return true;
		}
			
		return false;
			
	}
	
	var btnReset = app.crearBotonResetCampos([
		txtCodExpediente,
		txtDescripcion,
		comboEstado,
		comboSituacion,
		mmRiesgoTotal.min,
		mmRiesgoTotal.max,
		mmSVencido.min,
		mmSVencido.max,
		comboTipoPersonaTit,
		comboJerarquia
		,comboZonas
		,filtroContrato
	]);
		
	var validaMinMax = function(){
		if (!app.validaValoresDblText(mmRiesgoTotal)){
			return false;
		}
		if (!app.validaValoresDblText(mmSVencido)){
			return false;
		}
		return true;
	}
		
	var buscarFunc = function(){
		if (validarEmptyForm()){
			if (validaMinMax()){
				expStore.webflow({
					//start:0
					codigo:txtCodExpediente.getValue()
					,descripcion:txtDescripcion.getValue()
					,idEstado:comboEstado.getValue()
					,codigoSituacion:comboSituacion.getValue()
					,minRiesgoTotal:mmRiesgoTotal.min.getValue()
					,maxRiesgoTotal:mmRiesgoTotal.max.getValue()
					,minSaldoVencido:mmSVencido.min.getValue()
					,tipoPersonaTit:comboTipoPersonaTit.getValue()
					,maxSaldoVencido:mmSVencido.max.getValue()
					,codigoEntidad:comboJerarquia.getValue()
					,codigoZona:comboZonas.getValue()
					,codigoContrato:filtroContrato.getValue()
					,busqueda:true
				});
				botonesTabla.show();	
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>')
		}
		
	};
		
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
		<app:test id="btnBuscarExpediente" addComa="true"/>
	});
	
	//Agrego los filtros al panel
	var panelFiltros  = new Ext.Panel({
		layout:'table'
 		,title : '<s:message code="expedientes.listado.filtros" text="**Filtro de Expedientes" />'
		,collapsible : true
		,titleCollapse : true
		,layoutConfig : {
			columns:2
		}
		,autoHeight:true
		,border: false
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items : [
			{ items : [txtCodExpediente,txtDescripcion,comboEstado,mmRiesgoTotal.panel,mmSVencido.panel, comboTipoPersonaTit, filtroContrato] }
			,{ items : [comboJerarquia, comboZonas,comboSituacion] }
		]
		,tbar : [btnBuscar,btnReset, '->', app.crearBotonAyuda()]
		,listeners:{	
			beforeExpand:function(){
				expedientesGrid.setHeight(300);
			}
			,beforeCollapse:function(){
				expedientesGrid.setHeight(500);
			}
		}
	});
	
	

	var expCm = new Ext.grid.ColumnModel([
			{	hidden:true,sortable: false, dataIndex: 'id',fixed:true},
		    {	header: '<s:message code="expedientes.listado.codigo" text="**Codigo"/>', 
		    	width: 40, sortable: false, dataIndex: 'id'},
		    {	header: '<s:message code="expedientes.listado.descripcion" text="**Descripcion"/>', 
		    	width: 132, sortable: true, dataIndex: 'descripcionExpediente'},
		    {	header: '<s:message code="expedientes.listado.fechacreacion" text="**Fecha Creacion"/>', 
		    	width: 68, sortable: false, dataIndex: 'fcreacion'},
		    {	header: '<s:message code="expedientes.listado.origen" text="**Origen"/>', 
		    	width: 40, sortable: false, dataIndex: 'origen'},
		    {	header: '<s:message code="expedientes.listado.estado" text="**Estado"/>',
				hidden:true,width: 80, sortable: true, dataIndex: 'estadoExpediente'},
		    {	header: '<s:message code="expedientes.listado.situacion" text="**Situacion"/>',
				width: 80, sortable: true, dataIndex: 'estadoItinerario'},
			{	header: '<s:message code="expedientes.listado.riesgosD" text="**Riesgos D."/>', 
				width: 105, sortable: false, dataIndex: 'volumenRiesgo',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.riesgosI" text="**Riesgos I."/>', 
		    	width: 105, sortable: false, dataIndex: 'volumenRiesgoVencido',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.oficina" text="**Oficina"/>', 
				width: 50, sortable: false, dataIndex: 'oficina'},
		    {	header: '<s:message code="expedientes.listado.gestor" text="**Gestor"/>', 
				width: 200, sortable: false, dataIndex: 'gestor'},
		    {	header: '<s:message code="expedientes.listado.fvenc" text="**Fecha Vencim."/>', 
				width: 88, sortable: false, dataIndex: 'fcomite'},
		    {	header: '<s:message code="expedientes.listado.comite" text="**Comité"/>', 
				hidden:true,width: 120, sortable: false, dataIndex: 'comite'}
			]
		); 
	
	var botonesTabla = fwk.ux.getPaging(expStore);
	botonesTabla.hide();
		
	var expedientesGrid = app.crearGrid(expStore,expCm,{
			title:'<s:message code="expedientes.consulta.titulo" text="**Expedientes"/>'
			,style : 'padding:10px'
			,iconCls : 'icon_expedientes'
			,height:300
			,dontResizeHeight:true
			,bbar : [ botonesTabla  ]
			<app:test id="listaExpedientes" addComa="true"/>
		});
	var expedientesGridListener =	function(grid, rowIndex, e) {
		
	    	var rec = grid.getStore().getAt(rowIndex);
	    	if(rec.get('id')){
	    		var id = rec.get('id');
	    		var desc = rec.get('descripcionExpediente');
	    		app.abreExpediente(id,desc);
		    	
	    	}
	    };
	    
	expedientesGrid.addListener('rowdblclick', expedientesGridListener);
	
	var mainPanel = new Ext.Panel({
	    items : [
	    		panelFiltros
	    		,expedientesGrid
	    	]
	    ,autoHeight : true
	    ,border: false
    });
	page.add(mainPanel);
</fwk:page>