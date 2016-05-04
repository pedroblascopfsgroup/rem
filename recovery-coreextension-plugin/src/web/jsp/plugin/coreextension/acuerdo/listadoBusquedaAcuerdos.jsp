<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	
	
<%-----------------Campos Pestaña Datos Generales -----------------------%>
	
	//Campo Número Contrato
	var codigoContrato=app.creaNumber('codigo',
			'<s:message code="acuerdo.busqueda.filtro.contrato" text="**Nº Contrato" />','',{autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}<app:test id="idContrato" addComa="true"/>});
	
	//Campo Numero Cliente
	var codigoCliente=app.creaNumber('codigo',
			'<s:message code="acuerdo.busqueda.filtro.cliente" text="**Nº Cliente" />','',{autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}<app:test id="idCliente" addComa="true"/>});
	
	
	//Listado de entidad_acuerdo, viene del flow
	var entidadAcuerdo = <app:dict value="${listadoEntidadAcuerdo}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store generico de combo diccionario
	var optionsEntidadAcuerdoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : entidadAcuerdo
	});
	
	//Campo Combo Entidad Acuerdo
	var comboEntidadAcuerdo = new Ext.form.ComboBox({
				store:optionsEntidadAcuerdoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,width:135
				,mode: 'local'
				,emptyText:'---'
				,editable: false
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="acuerdo.busqueda.filtro.entidadAcuerdo" text="**Tipo de Acuerdo"/>'
				<app:test id="comboEntidadAcuerdo" addComa="true"/>
	});
	
	
	//Campo Solicitante
	var solicitante = new Ext.form.TextField({
		fieldLabel:'<s:message code="acuerdo.busqueda.filtro.solicitante" text="**Solicitante" />'
		,name:'solicitante'
		<app:test id="solicitante" addComa="true"/>
	});
	
	//Listado de tipos de Solicitante, viene del flow
	var tiposSolicitante = <app:dict value="${tiposSolicitante}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store generico de combo diccionario
	var optionsTiposSolicitanteStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : tiposSolicitante
	});
	
	//Campo Combo Tipo Solicitante
	var comboTiposSolicitante = new Ext.form.ComboBox({
				store:optionsTiposSolicitanteStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,width:135
				,mode: 'local'
				,emptyText:'---'
				,editable: false
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="acuerdo.busqueda.filtro.tipoSolicitante" text="**Tipo Solicitante"/>'
				<app:test id="comboTiposSolicitante" addComa="true"/>
	});
	
	
	//Listado de estados del Acuerdo, viene del flow
	var estadosAcuerdo = <app:dict value="${estadosAcuerdo}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store generico de combo diccionario
	var optionsEstadosAcuerdoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : estadosAcuerdo
	});
	
	//Campo Combo Estados Acuerdo
	var comboEstadosAcuerdo = new Ext.form.ComboBox({
				store:optionsEstadosAcuerdoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,width:135
				,mode: 'local'
				,emptyText:'---'
				,editable: false
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="acuerdo.busqueda.filtro.estadoAcuerdo" text="**Estado"/>'
				<app:test id="comboEstadosAcuerdo" addComa="true"/>
	});
	
	var txtDesde = app.creaLabel('<s:message text="Desde" />');
	var txtHasta = app.creaLabel('<s:message text="Hasta" />');
	
	var fechaAltaDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="acuerdo.busqueda.filtro.fechaAlta" text="Fecha Alta" />'
		,name:'fechaAltaDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaAltaHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message text="" />'
		,name:'fechaAltaHasta'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaEstadoDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="acuerdo.busqueda.filtro.fechaEstado" text="Fecha Estado" />'
		,name:'fechaEstadoDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaEstadoHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message text="" />'
		,name:'fechaEstadoHasta'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaVigenteDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="acuerdo.busqueda.filtro.fechaVigente" text="**Fecha Vigente" />'
		,name:'fechaVigenteDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaVigenteHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message text="" />'
		,name:'fechaVigenteHasta'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	
	
	
<%-----------------Campos Pestaña Gestores -----------------------%>
	
	//store para los tipos de testor
	var optionsTiposGestor  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		
	]);
	
	var optionsTipoGestorStore = page.getStore({
	       flow: 'coreextension/getListTipoGestorAdicionalData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoGestores'
	    }, optionsTiposGestor)	       
	});
	
	//Campo Combo Tipos de Gestor
	var comboTiposGestor = new Ext.form.ComboBox({
				store:optionsTipoGestorStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'local'
				,forceSelection: true
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="acuerdo.busqueda.filtro.tipoGestor" text="**Tipo de gestor"/>'
				<app:test id="comboTiposGestor" addComa="true"/>
	});
	
	comboTiposGestor.on('select', function(){
	
		comboDespachos.reset();
		optionsDespachoStore.webflow({'idTipoGestor': comboTiposGestor.getValue(), 'incluirBorrados': true}); 
		
		comboGestor.reset();
		comboGestor.setValue('');
		optionsGestoresStore.removeAll();
		
		comboDespachos.setDisabled(false);		
	});
	
	//store generico de combo diccionario
	var optionsDespachosRecord = Ext.data.Record.create([
		 {name:'cod'}
		,{name:'descripcion'}
	]);
	
	var optionsDespachoStore = page.getStore({
	       flow: 'coreextension/getListTipoDespachoData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoDespachos'
	    }, optionsDespachosRecord)	       
	});
	
	//Campo Combo Despacho
	var comboDespachos = new Ext.form.ComboBox({
				store:optionsDespachoStore
				,displayField:'descripcion'
				,valueField:'cod'
				,mode: 'local'
				,emptyText:'---'
				,forceSelection: true
				,editable: false
				,triggerAction: 'all'
				,disabled:true
				,resizable:true
				,fieldLabel : '<s:message code="acuerdo.busqueda.filtro.despacho" text="**Despacho"/>'
				<app:test id="comboDespachos" addComa="true"/>
	});
	
	var gestores={diccionario:[]};
	
	var Gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);

	
	var optionsGestoresStore =  page.getStore({
	       flow: 'coreextension/getListUsuariosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, Gestor)	       
	});


	//Campo Gestores, double select 
 	var creaDblSelectMio = function(label, config){
	
	var store = config.store ;
	var cfg = {
	    	fieldLabel: label || ''
	    	,displayField:'username'
	    	,valueField: 'id'
	    	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
	    	,dataFields : ['id', 'username']
	    	,fromStore:store
	    	,toData : []
	        ,msHeight : config.height || 130
			,labelStyle:config.labelStyle || ''
	        ,msWidth : config.width || 300
	        ,drawTopIcon:false
	        ,drawBotIcon:false
	        ,drawUpIcon:false
			,drawDownIcon:false
			,disabled:true
			,toSortField : 'codigo'
	    };
	if(config.id) {
		cfg.id = config.id;
	}

	var itemSelector = new Ext.ux.ItemSelector(cfg);
	if (config.funcionReset){
		itemSelector.funcionReset = config.funcionReset;
	}
	
	//modificaciï¿½n al itemSelector porque no tiene un mï¿½todo setValue. Si se cambia de versiï¿½n se tendrï¿½ que revisar la validez de este mï¿½todo
	itemSelector.setValue =  function(val) {
        if(!val) {
            return;
        }
        val = val instanceof Array ? val : val.split(',');
        var rec, i, id;
        for(i = 0; i < val.length; i++) {
            id = val[i];
            if(this.toStore.find('id',id)>=0) {
                continue;
            }
            rec = this.fromStore.find('id',id);
            if(rec>=0) {
            	rec = this.fromStore.getAt(rec);
                this.toStore.add(rec);
                this.fromStore.remove(rec);
            }
        }
    };

	itemSelector.getStore =  function() {
		return this.toStore;
	};

	return itemSelector;
	};

	var comboGestor = creaDblSelectMio('<s:message code="acuerdo.busqueda.filtro.gestor" text="**Gestor" />',{store:optionsGestoresStore, funcionReset:recargarComboGestores});
	
	
	var recargarCombos = function(){
		if (comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
			comboGestor.enable();
		}else{
			//comboSupervisor.setValue('');
			optionsGestoresStore.removeAll();
		}
	}
	
	comboDespachos.on('select', function(){
		comboGestor.reset();
		optionsGestoresStore.webflow({'idTipoDespacho': comboDespachos.getValue(), 'incluirBorrados': true}); 
				
		comboGestor.setDisabled(false);
	});
	
	var recargarComboGestores = function(){
		optionsGestoresStore.webflow({id:0});	
	}
	
	
<%-----------------Campos Pestaña Jerarquía -----------------------%>
	
	var zonas=<app:dict value="${zonas}" />;

	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;

	var comboJerarquia = app.creaCombo({triggerAction: 'all',
	 	data:jerarquia, 
	 	value:jerarquia.diccionario[0].codigo, 
	 	name : 'jerarquia', 
	 	fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});
	 	
	 var listadoCodigoZonas = [];
	 	
	 comboJerarquia.on('select',function(){
		if(comboJerarquia.value != '') {
			comboZonas.setDisabled(false);
			optionsZonasStore.setBaseParam('idJerarquia', comboJerarquia.getValue());
		}else{
			comboZonas.setDisabled(true);
		}
	});
	
	var codZonaSel='';
	var desZonaSel='';
	
	var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	//Template para el combo de zonas
    var zonasTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{descripcion}&nbsp;&nbsp;&nbsp;</p><p>{codigo}</p>',
        '</div></tpl>'
    );
    
     var optionsZonasStore = page.getStore({
	       flow: 'mejexpediente/getZonasInstant'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
	
	//Combo de zonas
    var comboZonas = new Ext.form.ComboBox({
        name: 'comboZonas'
        ,disabled:true 
        ,allowBlank:true
        ,store:optionsZonasStore
        ,width:220
        ,fieldLabel: '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro"/>'
        ,tpl: zonasTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 2 
        ,hidden:false
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,onSelect: function(record) {
        	btnIncluir.setDisabled(false);
        	codZonaSel=record.data.codigo;
        	desZonaSel=record.data.descripcion;
         }
    });	
    
    var recordZona = Ext.data.Record.create([
		{name: 'id'},
		{name: 'codigoZona'},
		{name: 'descripcionZona'}
	]);
	
	var zonasStore = page.getStore({
		flow:''
		,reader: new Ext.data.JsonReader({
	  		root : 'data'
		} 
		, recordZona)
	});
	
	 var zonasCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="expedientes.listado.centros.codigo" text="**Código" />', dataIndex : 'codigoZona' ,sortable:false, hidden:false, width:80}
		,{header : '<s:message code="expedientes.listado.centros.nombre" text="**Nombre" />', dataIndex : 'descripcionZona',sortable:false, hidden:false, width:300}
		]);
		
	var zonasGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="expedientes.listado.centros" text="**Centros" />'
	    ,cm: zonasCM
	    ,store: zonasStore
	    ,autoWidth: true
	    ,height: 150
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,clicksToEdit: 1
	});
	
	var incluirZona = function() {
	    var zonaAInsertar = zonasGrid.getStore().recordType;
   		var p = new zonaAInsertar({
   			codigoZona: codZonaSel,
   			descripcionZona: desZonaSel
   		});
		zonasStore.insert(0, p);
		listadoCodigoZonas.push(codZonaSel);
	}
	
	var btnIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,minWidth:60
		,handler : function(){
			incluirZona();
			codZonaSel='';
   			desZonaSel='';
   			btnIncluir.setDisabled(true);
			comboZonas.focus();
		}
	});
	
	var zonaAExcluir = -1;
	var codZonaExcluir = '';
	
	zonasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		codZonaExcluir = grid.selModel.selections.get(0).data.codigoZona;
   		zonaAExcluir = rowIndex;
   		btnExcluir.setDisabled(false);
	});
	
	var btnExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,minWidth:60
		,handler : function(){
			if (zonaAExcluir >= 0) {
				zonasStore.removeAt(zonaAExcluir);
				listadoCodigoZonas.remove(codZonaExcluir);
			}
			zonaAExcluir = -1;
	   		btnExcluir.setDisabled(true);
		}
	});
	
	
	
	var validarEmptyForm = function(){

		if (tabDatos){
			if (codigoContrato.getValue() != '' && app.validate.validateInteger(codigoContrato.getValue())){
				return true;
			}
			if (codigoCliente.getValue() != '' && app.validate.validateInteger(codigoCliente.getValue())){
				return true;
			}
			////////////////////Revisar//////////////7
			if (comboEntidadAcuerdo.length > 0 ){
					return true;
			}
			if (solicitante.getValue() != '' ){
				return true;
			}
			if (comboTiposSolicitante.getValue() != '' ){
				return true;
			}
			if (comboEstadosAcuerdo.getValue() != '' ){
				return true;
			}
			if (fechaAltaDesde.getValue() != '' ){
				return true;
			}
			if (fechaAltaHasta.getValue() != '' ){
				return true;
			}
			if (fechaEstadoDesde.getValue() != '' ){
				return true;
			}
			if (fechaEstadoHasta.getValue() != '' ){
				return true;
			}
			if (fechaVigenteDesde.getValue() != '' ){
				return true;
			}
			if (fechaVigenteHasta.getValue() != '' ){
				return true;
			}
		}
		if (tabGestores){
			if (comboDespachos.getValue() != '' ){
				return true;
			}
			if (comboGestor.getValue() != '' ){
				return true;
			}
			if (comboTipoGestor.getValue() != '' ){
				return true;
			}
		}
		if (tabJerarquia){
			if (comboJerarquia.getValue() != '' ){
				return true;
			}
			if (listadoCodigoZonas.length > 0 ){
					return true;
			}
			
		}
				
		return false;		
	};
	
	var getParametros = function() {
	 	var p = {};
        	if (tabDatos){
        		p.nroContrato=codigoContrato.getValue();
        		p.nroCliente=codigoCliente.getValue();
        		p.solicitante=solicitante.getValue();
        		p.tipoSolicitante=comboTiposSolicitante.getValue();
        		p.estado=comboEstadosAcuerdo.getValue();
        		p.fechaAltaDesde=app.format.dateRenderer(fechaAltaDesde.getValue());
        		p.fechaAltaHasta=app.format.dateRenderer(fechaAltaHasta.getValue());
        		p.fechaEstadoDesde=app.format.dateRenderer(fechaEstadoDesde.getValue());
        		p.fechaEstadoHasta=app.format.dateRenderer(fechaEstadoHasta.getValue());
        		p.fechaVigenciaDesde=app.format.dateRenderer(fechaVigenteDesde.getValue());
        		p.fechaVigenciaHasta=app.format.dateRenderer(fechaVigenteHasta.getValue());
        	}
        	if (tabGestores){	
        		p.tipoGestor=comboTiposGestor.getValue();
				p.despacho=comboDespachos.getValue();
				p.gestores=comboGestor.getValue();
        	}
        	if (tabJerarquia){
        		p.jerarquia=comboJerarquia.getValue();
				p.codigoZona=listadoCodigoZonas.toString();
        	}

        return p;
    };
    
	
	var buscarFunc = function()
	{
		var params= getParametros();
		acuerdosStore.webflow(params);
		pagingBar.show();	
	};
	
	var btnReset = app.crearBotonResetCampos([
		codigoContrato
		,codigoCliente
		,solicitante
		,comboTiposSolicitante
		,comboEstadosAcuerdo
		,fechaAltaDesde
		,fechaAltaHasta
		,fechaEstadoDesde
		,fechaEstadoHasta
		,fechaVigenteDesde
		,fechaVigenteHasta
		,comboJerarquia
		,comboZonas
		,listadoCodigoZonas
		,zonasStore
		,comboEntidadAcuerdo
		
		
	]);
	
	 var btnExportarXLS=new Ext.Button({
        text:'<s:message code="acuerdo.busqueda.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
                    //insertar aquí función
                }
        }
    );
    
    var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	<%--*************PESTAÑA DE DATOS DEL ACUERDO***************************************** --%>
	tabDatos=false;
	var filtrosTabDatosAcuerdo = new Ext.Panel({
		title:'<s:message code="acuerdo.busqueda.filtros.datosAcuerdos" text="**Datos generales" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:3}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				width:350
				,items:[codigoContrato,codigoCliente,comboEntidadAcuerdo,solicitante,comboTiposSolicitante,comboEstadosAcuerdo
					//espacios en blanco para alinear ambas columnas
					,{border:false,html:'&nbsp;'},{border:false,html:'&nbsp;'}
				]
			},{
				layout:'form'
				,items:[txtDesde,fechaAltaDesde,fechaEstadoDesde,fechaVigenteDesde]
			},{
				layout:'form'
				,items:[txtHasta,fechaAltaHasta,fechaEstadoHasta,fechaVigenteHasta]
			}
		]
	});
	
	filtrosTabDatosAcuerdo.on('activate',function(){
		tabDatos=true;
	});
	<%--*************PESTAÑA DE GESTORES***************************************** --%>
	tabGestores=false;
	var filtrosTabGestores = new Ext.Panel({
		title:'<s:message code="acuerdo.busqueda.filtros.gestores" text="**Gestores" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,items:[comboTiposGestor,comboDespachos,comboGestor]
				}]
				,listeners:{	
					limpiar: function() {
    		   			app.resetCampos([      
    		          		 comboDespachos
    		           		,comboGestor
    		           		,comboTiposGestor
    		           
	           ]); 
	           comboGestor.setDisabled(true);
	           comboDespachos.setDisabled(true);
	           optionsGestoresStore.webflow({'idTipoDespacho': 0}); 
    		}
    		
		}
	});
	
	filtrosTabGestores.on('activate',function(){
		tabGestores=true;
	});
	<%--*************PESTAÑA DE JERARQUÍA***************************************** --%>
	var tabJerarquia=false;
	var filtrosTabJerarquia = new Ext.Panel({
		title: '<s:message code="expedientes.listado.jerarquia" text="**Jerarquia" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:3}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboJerarquia, comboZonas]
				},{
					layout:'form'
					,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
					,items: [btnIncluir, btnExcluir]
				},{
					layout:'form'
					,items: [zonasGrid]
				}]
	});
	
	filtrosTabJerarquia.on('activate',function(){
		tabJerarquia=true;
	});
	
	<%--*************************************************************************************
	*************TABPANEL QUE CONTIENE TODAS LAS PESTAÑAS****************************************
	**************************************************************************************** --%>
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosAcuerdo, filtrosTabGestores,filtrosTabJerarquia]
		,id:'idTabFiltrosAcuerdo'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});
	
	
	<%--***********PANEL QUE CONTIENE EL PANEL DE PESTAÑAS******************** --%>
	var panelFiltros = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,title : '<s:message code="acuerdo.busqueda.filtros" text="**Búsqueda de Acuerdos" />'
			,titleCollapse:true
			,collapsible:true
			,tbar : [btnBuscar,btnReset,btnExportarXLS,'->', app.crearBotonAyuda()] 
			<%--,tbar : [buttonsL,'->', buttonsR]--%>
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,style:'padding-bottom:10px; padding-right:10px;'
			,items:[{items:[{
							layout:'form'
							,items:[
									filtroTabPanel
								   ]
						}
					]	

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

	
	
	var acuerdo = Ext.data.Record.create([
	     {name : 'id'}
		,{name : 'contrato'}
		,{name : 'cliente'}
		,{name : 'tipoTermino'}
		,{name : 'solicitante'}
		,{name : 'tipoSolicitante'}
		,{name : 'estado'}
		,{name : 'fechaAlta'}
		,{name : 'fechaEstado'}
		,{name : 'fechaVigencia'}
			
	]);
	

	var acuerdosStore = page.getStore({
		flow : 'coreextension/listBusquedaAcuerdos'
		,reader: new Ext.data.JsonReader({
	    	root : 'acuerdos'
	    	,totalProperty : 'total'
	    }, acuerdo)
		,remoteSort : true
	});
	
	
	var acuerdosCm = new Ext.grid.ColumnModel([
	{
		header: '<s:message code="acuerdos.listado.id" text="**Id"/>',
		dataIndex: 'id', sortable: true
	}, {
		header: '<s:message code="acuerdos.listado.contrato" text="**Contrato"/>',
		dataIndex: 'contrato', sortable: true
	}, {
		header: '<s:message code="acuerdos.listado.cliente" text="**Cliente"/>',
		dataIndex: 'cliente', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.tipoAcuerdo" text="**Tipo Acuerdo"/>',
		dataIndex: 'tipoTermino', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.solicitante" text="**Solicitante"/>',
		dataIndex: 'solicitante', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.tipoSolicitante" text="**Tipo Solicitante"/>',
		dataIndex: 'tipoSolicitante', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.estadoAcuerdo" text="**Estado"/>',
		dataIndex: 'estado', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.fechaAlta" text="**Fecha Alta"/>',
		dataIndex: 'fechaAlta', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.fechaEstado" text="**Fecha Estado"/>',
		dataIndex: 'fechaEstado', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.fechaVigencia" text="**Fecha Vigencia"/>',
		dataIndex: 'fechaVigencia', sortable: false
	}
	]);
	
	var pagingBar=fwk.ux.getPaging(acuerdosStore);
	pagingBar.hide();
	
	 
	var gridAcuerdos=app.crearGrid(acuerdosStore,acuerdosCm,{
		title: '<s:message code="acuerdos.grid.titulo" text="**Acuerdos" />'	
		//,style:'padding:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_asuntos'
		,height:175
		//,autoWidth : true
		//,bbar : [ botonesTabla  ]
		<app:test id="listaAcuerdos" addComa="true"/>
	});
	
	
	var mainPanel = new Ext.Panel({
		items : [
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[panelFiltros]
			},{
					bodyStyle:'padding:5px;cellspacing:10px'
					,border:false
					,defaults : {xtype:'panel' ,cellCls : 'vtop'}
					,items : [gridAcuerdos]
				  }]
	    //,bodyStyle:'padding:10px'
	    ,autoHeight : true
	    ,border: false
    });
    
    Ext.onReady(function(){
		 optionsTipoGestorStore.webflow({ugCodigo:'3'});
	});
    
	page.add(mainPanel);
	

</fwk:page>