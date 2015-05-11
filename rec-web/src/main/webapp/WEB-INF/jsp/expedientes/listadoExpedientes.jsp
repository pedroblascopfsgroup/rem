<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var limit=25;
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
	//diccionarios
	var segmentos = <app:dict value="${segmentos}" />;
	var situaciones = <app:dict value="${situacion}" />;
	var zonas = <app:dict value="${zonas}" />;
	var tiposPersona = <app:dict value="${tiposPersona}" blankElement="true" blankElementValue="" blankElementText="---" />;
	var comites = <app:dict value="${comites}" blankElement="true" blankElementValue="" blankElementText="---" />;


	var comboSituacion = app.creaDblSelect(situaciones
                              ,'<s:message code="expedientes.listado.situacion" text="**Situacion" />'
                              ,{<app:test id="comboSituacion" />});
    
	var mmRiesgoTotal = app.creaMinMax('<s:message code="expedientes.listado.riesgoTotal" text="**Riesgo Total" />', 'riesgo',{width : 60});
	var mmSVencido    = app.creaMinMax('<s:message code="expedientes.listado.sVencido" text="**S. Vencido" />', 'svencido',{width : 60});
	
	
	var txtCodExpediente = new Ext.form.NumberField({
		fieldLabel:'<s:message code="expedientes.listado.codigo" text="**Codigo" />'
		,enableKeyEvents: true
		,allowDecimals: false
		,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
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
		,style : 'margin:0px'
		,listeners : {
			keypress : function(target,e){
					//Ext.Msg.alert("AA","EE");
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
	});


    var gestion = <app:dict value="${gestion}" blankElement="true" blankElementValue="" blankElementText="---" />;
    
    var comboGestion = app.creaCombo({data:gestion, 
    									triggerAction: 'all', 
    									value:gestion.diccionario[0].codigo, 
    									name : 'codigoGestion', 
    									fieldLabel : '<s:message code="expedientes.listado.gestion" text="**Gestion" />'
    									<app:test id="idComboGestion" addComa="true"/>	
    								});

	
    var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
    
    var comboJerarquia = app.creaCombo({data:jerarquia, 
    									triggerAction: 'all', 
    									value:jerarquia.diccionario[0].codigo, 
    									name : 'jerarquia', 
    									fieldLabel : '<s:message code="expedientes.listado.jerarquia" text="**Jerarquia" />'
    									<app:test id="idComboJerarquia" addComa="true"/>	
    								});

	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboZonas = function(){
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
	
	var comboZonas = app.creaDblSelect(zonas
               ,'<s:message code="expedientes.listado.centros" text="**Centros" />'
               ,{store:optionsZonasStore
	             <app:test id="comboZonas" addComa="true" />
                 ,funcionReset:recargarComboZonas});

	recargarComboZonas();
	
	var estados = <app:dict value="${estado}" blankElement="true" blankElementValue="" blankElementText="---" />;

	var comboSegmentos = app.creaDblSelect(segmentos, '<s:message code="menu.clientes.listado.filtro.segmento" text="**Segmento" />');

	var comboTipoPersona = app.creaCombo({data:tiposPersona, name : 'tipopersona', fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipopersona" text="**Tipo Persona" />' <app:test id="comboTipoPersona" addComa="true" />,width : 160});

	var comboComite = app.creaCombo({data:comites, name : 'comites', fieldLabel : '<s:message code="expedientes.listado.comite" text="**Comite" />' <app:test id="comboComite" addComa="true" />,width : 160});


	//store generico de combo diccionario
	var optionsEstadoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : estados
	});
	
	var comboEstado = new Ext.form.ComboBox({
				store:optionsEstadoStore
				<app:test id="comboEstado" addComa="true" />
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,style : 'margin:0px'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="expedientes.listado.estado" text="**Estado" />'
	});
	 
	var filtroContrato = new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtrocontrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,maxLength:10
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"10", autocomplete: "off"} 
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
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
		,{name:'descripcionExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'fechacrear',type:'date', dateFormat:'d/m/Y'}
		,{name:'origen'}
		,{name:'estadoItinerario', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'oficina', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'estadoExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'volumenRiesgo', sortType:Ext.data.SortTypes.asFloat}
		,{name:'volumenRiesgoVencido', sortType:Ext.data.SortTypes.asFloat}
		,{name:'gestorActual', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'fechaVencimiento',type:'date', dateFormat:'d/m/Y'}
		,{name:'comite', type:'string', sortType:Ext.data.SortTypes.asText}	
		,{name:'itinerario'}
	]);

	var expStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,flow:'expedientes/listadoExpedientesData'
		,reader: new Ext.data.JsonReader({
	    	root : 'expedientes'
	    	,totalProperty : 'total'
	    }, Expediente)
		,remoteSort : true
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
		if (txtDescripcion.getValue() != '' ){
			return true;
		}
		if (!(mmRiesgoTotal.min.getValue() === '' )){
			return true;
		}
		if (!(mmRiesgoTotal.max.getValue() === '' )){
			return true;
		}
		if (!(mmSVencido.min.getValue() === '' )){
			return true;
		}
		if (!(mmSVencido.max.getValue() === '' )){
			return true;
		}
		if (!(filtroContrato.getValue() === '')){
			return true;
		}
		if (comboSegmentos.getValue() != '' ){
			return true;
		}
		if (comboTipoPersona.getValue() != '' ){
			return true;
		}
		if (comboComite.getValue() != '' ){
			return true;
		}
		if (comboGestion.getValue() != ''){
			return true;
		}
			
		return false;
			
	}
	
	var btnReset = app.crearBotonResetCampos([
		txtCodExpediente,
		txtDescripcion,
		comboEstado,
		comboSituacion,
		comboSegmentos,
		comboTipoPersona,
		comboComite,
		mmRiesgoTotal.min,
		mmRiesgoTotal.max,
		mmSVencido.min,
		mmSVencido.max,
		comboJerarquia,
		comboGestion,
		comboZonas,
		filtroContrato
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

    var getParametros = function() {
        return {
			//start:0
			codigo:txtCodExpediente.getValue()
			,descripcion:txtDescripcion.getValue()
			,idEstado:comboEstado.getValue()
			,codigoSituacion:comboSituacion.getValue()
			,minRiesgoTotal:mmRiesgoTotal.min.getValue()
			,maxRiesgoTotal:mmRiesgoTotal.max.getValue()
			,minSaldoVencido:mmSVencido.min.getValue()
			,maxSaldoVencido:mmSVencido.max.getValue()
			,codigoEntidad:comboJerarquia.getValue()
			,codigoGestion:comboGestion.getValue()
			,codigoZona:comboZonas.getValue()
			,nroContrato:filtroContrato.getValue()
			,segmentos:comboSegmentos.getValue()
			,tipoPersona:comboTipoPersona.getValue()
			,comiteBusqueda:comboComite.getValue()
			,busqueda:true
		};
	};

	var buscarFunc = function(){
		if (validarEmptyForm()){
			if (validaMinMax()){
				panelFiltros.collapse(true);
				expStore.webflow(getParametros());
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
	
    var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a XLS" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
					if (validarEmptyForm()){
						if (validaMinMax()){
							var flow='expedientes/listadoExpedientesExcelData';
		                    var params = getParametros();
		                    params.REPORT_NAME='busqueda.xls';
		                    app.openBrowserWindow(flow,params);
						}else{
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
						}
					}else{
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>')
					}                    

					
                }
        }
    );

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
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items : [
			{ items : [txtCodExpediente,txtDescripcion,comboEstado, comboTipoPersona, mmRiesgoTotal.panel,mmSVencido.panel, filtroContrato, comboComite, comboGestion] }
			,{ items : [comboJerarquia, comboZonas, comboSituacion, comboSegmentos] }
		]
		,tbar : [btnBuscar,btnReset,btnExportarXls,'->',app.crearBotonAyuda()] 
		,listeners:{	
			beforeExpand:function(){
				expedientesGrid.setHeight(175);
			}
			,beforeCollapse:function(){
				expedientesGrid.setHeight(435);
			}
		}
	});
	
	var expCm = new Ext.grid.ColumnModel([
			{	hidden:true,sortable: false, dataIndex: 'id',fixed:true},
		    {	header: '<s:message code="expedientes.listado.codigo" text="**Codigo"/>', 
		    	width: 50,sortable: true, dataIndex: 'id'},
		    {	header: '<s:message code="expedientes.listado.descripcion" text="**Descripcion"/>', 
		    	width: 132,sortable: true, dataIndex: 'descripcionExpediente'},
			{	header: '<s:message code="expedientes.listado.itinerario" text="**Itinerario"/>', 
			sortable: false, dataIndex: 'itinerario'},
		    {	header: '<s:message code="expedientes.listado.fechacreacion" text="**Fecha Creacion"/>', 
		    	width: 75,sortable: true, dataIndex: 'fechacrear',renderer:app.format.dateRenderer},
		    {	header: '<s:message code="expedientes.listado.origen" text="**Origen"/>', 
		    	width: 40,sortable: false, dataIndex: 'origen'},
		    {	header: '<s:message code="expedientes.listado.estado" text="**Estado"/>',
				hidden:true,sortable: true,width: 80, dataIndex: 'estadoExpediente'},
		    {	header: '<s:message code="expedientes.listado.situacion" text="**Situacion"/>',
				width: 80,sortable: true, dataIndex: 'estadoItinerario'},
			{	header: '<s:message code="expedientes.listado.riesgosD" text="**Riesgos D."/>', 
				width: 105,sortable: true, dataIndex: 'volumenRiesgo',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.riesgosI" text="**Riesgos I."/>', 
		    	width: 105,sortable: true, dataIndex: 'volumenRiesgoVencido',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.oficina" text="**Oficina"/>', 
				width: 50,sortable: true, dataIndex: 'oficina'},
		    {	header: '<s:message code="expedientes.listado.gestor" text="**Gestor"/>', 
				width: 60,sortable: false, dataIndex: 'gestorActual'},
		    {	header: '<s:message code="expedientes.listado.fvenc" text="**Fecha Vencim."/>', 
				width: 88,sortable: true, dataIndex: 'fechaVencimiento',renderer:app.format.dateRenderer},
		    {	header: '<s:message code="expedientes.listado.comite" text="**Comité"/>', 
				hidden:true,sortable: true,width: 120, dataIndex: 'comite'}
			]
		); 

	var botonesTabla = fwk.ux.getPaging(expStore);
	botonesTabla.hide();
		
	var expedientesGrid = app.crearGrid(expStore,expCm,{
			title:'<s:message code="expedientes.consulta.titulo" text="**Expedientes"/>'
			,style : 'padding:10px'
			,cls:'cursor_pointer'
			,iconCls : 'icon_expedientes'
			,dontResizeHeight:true
			,height:175			
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
	   			,items:[expedientesGrid]
			}
		]
	    ,autoHeight : true
	    ,border: false
    });
	page.add(mainPanel);
</fwk:page>