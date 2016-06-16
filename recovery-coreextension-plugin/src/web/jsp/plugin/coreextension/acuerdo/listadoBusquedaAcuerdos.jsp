<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<fwk:page>
	
	
<%-----------------Campos Pestaï¿½a Datos Generales -----------------------%>
	
	var limit=25;
	
	//Campo Nï¿½mero Contrato
	var nroContrato = app.creaText('codigo', '<s:message code="acuerdo.busqueda.filtro.contrato" text="**Cï¿½d. Contrato" />'); 

	//Campo Numero Cliente
	<%--var codigoCliente = app.creaText('codigo', '<s:message code="acuerdo.busqueda.filtro.cliente" text="**Cï¿½d. Cliente" />'); --%>
	var codigoCliente=app.creaNumber('codigo','<s:message code="acuerdo.busqueda.filtro.cliente" text="**Cï¿½d. Cliente" />');
	
	//Listado de entidad_acuerdo
	var entidadAcuerdo = <app:dict value="${listadoEntidadAcuerdo}" blankElement="false" blankElementValue="" blankElementText="---"/>;
	
	var entidadAcuerdoInicial = '';
	if (entidadAcuerdo.diccionario.length >= 1) {
		entidadAcuerdoInicial = entidadAcuerdo.diccionario[0].codigo; 
	}

	if(entidadAcuerdo.diccionario[0].codigo == 'AMBAS'){
		entidadAcuerdo.diccionario[0].descripcion='Todos';
	}
	
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
				,editable: false
				,triggerAction: 'all'
				,value: entidadAcuerdoInicial
				,fieldLabel : '<s:message code="acuerdo.busqueda.filtro.entidadAcuerdo" text="**Origen"/>'
				<app:test id="comboEntidadAcuerdo" addComa="true"/>
	});
	
	comboEntidadAcuerdo.on('select', function(){
		if(comboEntidadAcuerdo.value != '') {
			comboTiposAcuerdo.reset();
			comboTiposAcuerdo.setDisabled(false);
			optionsTiposAcuerdoStore.webflow({'codigo': comboEntidadAcuerdo.getValue()}); 
			
		}else{
			comboTiposAcuerdo.setDisabled(true);
		}
	});
	
	//store generico de combo diccionario
	var optionsTiposAcuerdoRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsTiposAcuerdoStore = page.getStore({
	       flow: 'coreextension/getTipoAcuerdosByEntidad'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'tiposAcuerdo'
	    }, optionsTiposAcuerdoRecord)	       
	});
	
	//Campo Combo Tipo de Acuerdo
	var comboTiposAcuerdo = new Ext.form.ComboBox({
				store:optionsTiposAcuerdoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'---'
				,forceSelection: true
				,width:135
				,editable: false
				,triggerAction: 'all'
				,disabled:true
				,resizable:true
				,fieldLabel : '<s:message code="acuerdo.busqueda.filtro.terminoAcuerdo" text="**Tipo Termino"/>'
				<app:test id="comboTiposAcuerdo" addComa="true"/>
	});
	 
	//Listado de estados del Acuerdo, viene del flow
	var estadosAcuerdo = <app:dict value="${estadosAcuerdo}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	var tiposTerminos = <app:dict value="${tiposTerminos}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
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
	
	//optionsTiposAcuerdoStore.webflow({'codigo': comboEntidadAcuerdo.getValue()}); 
	
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
		,hideLabel:'true'
	});
	
	var fechaEstadoDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="acuerdo.busqueda.filtro.fechaEstado" text="Fecha Estado" />'
		,name:'fechaEstadoDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaEstadoHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message text="h" />'
		,name:'fechaEstadoHasta'
		,style:'margin:0px'
		,hideLabel:'true'
	});
	
	var fechaVigenteDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="acuerdo.busqueda.filtro.fechaVigente" text="**Fecha Vigente" />'
		,name:'fechaVigenteDesde'
		,style:'margin:0px'
		//,labelStyle:'font-weight:bolder;width:150px'
	});
	
	var fechaVigenteHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message text="h" />'
		,name:'fechaVigenteHasta'
		,style:'margin:0px'
		,hideLabel:'true'
	});
	

	
<%-----------------Campos Pestaï¿½a Gestores -----------------------%>
	
	//store para los tipos de testor
	var optionsTiposGestor  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		
	]);
	
	var optionsTipoGestorStore = page.getStore({
	       flow: 'coreextension/getListTipoGestorProponente'
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
				,editable: true
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
	
	
<%-----------------Campos Pestaï¿½a Jerarquï¿½a -----------------------%>
	
	var zonas=<app:dict value="${zonas}" />;

	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;

	var comboJerarquia = app.creaCombo({triggerAction: 'all',
	 	data:jerarquia, 
	 	value:jerarquia.diccionario[0].codigo, 
	 	name : 'jerarquia', 
	 	fieldLabel : '<s:message code="acuerdo.busqueda.filtros.jerarquia" text="**Jerarquía" />'});
	 	
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
        ,fieldLabel: '<s:message code="acuerdo.busqueda.filtros.centro" text="**Centro"/>'
        ,tpl: zonasTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 4 
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
		{header : '<s:message code="expedientes.listado.centros.codigo" text="**Cï¿½digo" />', dataIndex : 'codigoZona' ,sortable:false, hidden:false, width:80}
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
			if (nroContrato.getValue() != '' && app.validate.validateInteger(nroContrato.getValue())){
				return true;
			}
			if (codigoCliente.getValue() != '' && app.validate.validateInteger(codigoCliente.getValue())){
				return true;
			}
			if (comboEntidadAcuerdo.getValue() != '' ){
					return true;
			}
			if (comboTiposAcuerdo.getValue() != '' ){
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
		
			if (comboTiposGestor.getValue() != '' ){
				return true;
			}
			if (comboDespachos.getValue() != '' ){
				return true;
			}
			if (comboGestor.getValue() != '' ){
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
        		p.nroContrato=nroContrato.getValue();
        		p.nroCliente=codigoCliente.getValue();
        		p.tipoAcuerdo=comboEntidadAcuerdo.getValue();
        		p.tipoTermino=comboTiposAcuerdo.getValue();
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
				p.centros=listadoCodigoZonas.toString();
        	}

        return p;
    };
    
	
	var buscarFunc = function()
	{
		panelFiltros.collapse(true);
		var params= getParametros();
		acuerdosStore.webflow(params);
		pagingBar.show();	
	};
	
	var btnReset = app.crearBotonResetCampos([
		nroContrato
		,codigoCliente
		,comboEntidadAcuerdo
		,comboTiposAcuerdo
		,comboEstadosAcuerdo
		,fechaAltaDesde
		,fechaAltaHasta
		,fechaEstadoDesde
		,fechaEstadoHasta
		,fechaVigenteDesde
		,fechaVigenteHasta
		,comboTiposGestor
		,comboDespachos
		,comboJerarquia
		,comboZonas
		,gridAcuerdos

	]);
	
	btnReset.on('click', function(){
		zonasStore.removeAll();
		listadoCodigoZonas = [];
		comboZonas.setDisabled(true);	
		comboDespachos.reset();
		comboGestor.reset();
		comboGestor.setValue('');
		optionsGestoresStore.removeAll();
		comboDespachos.setDisabled(true);
		comboTiposAcuerdo.reset();
		comboTiposAcuerdo.setDisabled(true);	
		gridAcuerdos.collapse(true);
	});
	
	 var btnExportarXLS=new Ext.Button({
        text:'<s:message code="acuerdo.busqueda.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
                    //insertar aquï¿½ funciï¿½n
                }
        }
    );
    
    var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	<%--*************PESTAï¿½A DE DATOS DEL ACUERDO***************************************** --%>
	tabDatos=false;
	var filtrosTabDatosAcuerdo = new Ext.Panel({
		title:'<s:message code="acuerdo.busqueda.filtros.datosAcuerdos" text="**Datos generales" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : { border : false , layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;margin-right:40px'}
		,items:[{
					layout:'form'
					,items: [nroContrato,codigoCliente,comboEntidadAcuerdo,comboTiposAcuerdo,comboEstadosAcuerdo]
				},{
					layout:'table'
                    ,layoutConfig:{columns:2}
                    ,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form'}
					,items: [{items:[fechaAltaDesde,fechaEstadoDesde,fechaVigenteDesde]}, {autoWidth: true,items:[fechaAltaHasta,fechaEstadoHasta,fechaVigenteHasta]}]				
				}]
		
	});
	
	filtrosTabDatosAcuerdo.on('activate',function(){
		tabDatos=true;
	});
	<%--*************PESTAï¿½A DE GESTORES***************************************** --%>
	tabGestores=false;
	var filtrosTabGestores = new Ext.Panel({
		title:'<s:message code="acuerdo.busqueda.filtros.gestores" text="**Gestores del asunto" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,items:[comboTiposGestor,comboDespachos,comboGestor]
				}]	
	});
	
	filtrosTabGestores.on('activate',function(){
		tabGestores=true;
	});
	<%--*************PESTAï¿½A DE JERARQUï¿½A***************************************** --%>
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
	*************TABPANEL QUE CONTIENE TODAS LAS PESTAï¿½AS****************************************
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
	
	
	<%--***********PANEL QUE CONTIENE EL PANEL DE PESTAï¿½AS******************** --%>
	var panelFiltros = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,title : '<s:message code="acuerdo.busqueda.filtros" text="**Bï¿½squeda de Acuerdos" />'
			,titleCollapse:true
			,collapsible:true
			,tbar : [btnBuscar,btnReset,'->', app.crearBotonAyuda()] 
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
				gridAcuerdos.setHeight(175);
			}
			,beforeCollapse:function(){
				gridAcuerdos.setHeight(435);
				gridAcuerdos.expand(true);
			}
		}
	});

	
	
	var termino = Ext.data.Record.create([
		 {name : 'idTermino'}
		,{name : 'idAcuerdo'}
		,{name : 'idAsunto'}
		,{name : 'nombreAsunto'}
		,{name : 'idExpediente'}
		,{name : 'tipoExpediente'}
		,{name : 'descripcionExpediente'}
	    ,{name : 'idContrato'}
		,{name : 'cliente'}
		,{name : 'tipoAcuerdo'}
		,{name : 'solicitante'}
		,{name : 'tipoSolicitante'}
		,{name : 'estado'}
		,{name : 'fechaAlta'}
		,{name : 'fechaEstado'}
		,{name : 'fechaVigencia'}
			
	]);

	
	<c:if test="${busquedaOrInclusion=='inclusion'}">

			Ext.grid.CheckColumn = function(config){
			    Ext.apply(this, config);
			    if(!this.id){
			        this.id = Ext.id();
			    }
			    this.renderer = this.renderer.createDelegate(this);
			};

			Ext.grid.CheckColumn.prototype ={
			    init : function(grid){
			        this.grid = grid;
			        this.grid.on('render', function(){
			            var view = this.grid.getView();
			            view.mainBody.on('mousedown', this.onMouseDown, this);
			        }, this);
			    },

			    onMouseDown : function(e, t){
			        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
			            e.stopEvent();
			            var index = this.grid.getView().findRowIndex(t);
			            var record = this.grid.store.getAt(index);
			            record.set(this.dataIndex, !record.data[this.dataIndex]);
			        }
			    },
			
			    renderer : function(v, p, record){
			        p.css += ' x-grid3-check-col-td'; 
			        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    }
			};

			var checkColumn = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="listadoContratos.listado.incluir" text="**Incluir" />'
		            ,dataIndex : 'incluir', width: 40});

	</c:if>
	
	var acuerdosCm = new Ext.grid.ColumnModel([
	{
		header: '<s:message code="acuerdos.listado.idAcuerdo" text="**Id Acuerdo"/>',
		dataIndex: 'idAcuerdo',  fixed:true
	},<c:if test="${busquedaOrInclusion=='inclusion'}">,checkColumn</c:if>
		{
		header: '<s:message code="acuerdos.listado.idTermino" text="**Id Termino"/>',
		dataIndex: 'idTermino', sortable: false
	},  {
		header: '<s:message code="acuerdos.listado.idAsunto" text="**Id Asunto"/>',
		dataIndex: 'idAsunto', sortable: false,  hidden: true
	},  {
		header: '<s:message code="acuerdos.listado.nombreAsunto" text="**Nombre Asunto"/>',
		dataIndex: 'nombreAsunto', sortable: false,  hidden: true
	}, {
		header: '<s:message code="acuerdos.listado.idExpediente" text="**Id Expediente"/>',
		dataIndex: 'idExpediente', sortable: false,  hidden: true
	}, {
		header: '<s:message code="acuerdos.listado.descripcionExpediente" text="**Descripcion Expediente"/>',
		dataIndex: 'descripcionExpediente', sortable: false,  hidden: true
	}, {
		header: '<s:message code="acuerdos.listado.tipoExpediente" text="**Tipo Expediente"/>',
		dataIndex: 'tipoExpediente', sortable: false,  hidden: true
	}, {
		header: '<s:message code="acuerdos.listado.nroContrato" text="**Contrato Principal"/>',
		dataIndex: 'idContrato', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.cliente" text="**Cliente"/>',
		dataIndex: 'cliente', sortable: false
	}, {
		header: '<s:message code="acuerdos.listado.tipoAcuerdo" text="**Tipo Acuerdo"/>',
		dataIndex: 'tipoAcuerdo', sortable: false
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
	
	
	var acuerdosStore = page.getStore({
		flow : 'coreextension/listBusquedaAcuerdos'
		,limit:limit
		,reader: new Ext.data.JsonReader({
	    	root : 'terminos'
	    	,totalProperty : 'total'
	    }, termino)
		,remoteSort : true
	});
	
	
	var pagingBar=fwk.ux.getPaging(acuerdosStore);
	pagingBar.hide();
	
	acuerdosStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
    });
    
    var cfg={
		title:'<s:message code="acuerdos.grid.titulo" text="**Acuerdos"/>'
		,style:'padding:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_asuntos'
		,height:240
		,bbar : [pagingBar]
		<app:test id="listaAcuerdos" addComa="true" />
       	<c:if test="${busquedaOrInclusion=='inclusion'}">,plugins:checkColumn</c:if>
		,resizable:true
		,dontResizeHeight:true
	};
	
	var gridAcuerdos = app.crearGrid(acuerdosStore,acuerdosCm,cfg);
	
	var gridAcuerdosListener =	function(grid, rowIndex, e) {
	    	var rec = grid.getStore().getAt(rowIndex);
	    	
	    		if(rec.get('idAsunto')){
	    			var idAsunto = rec.get('idAsunto');
	    			var desc = rec.get('nombreAsunto');
	    			app.abreAsuntoTab(idAsunto,desc,'acuerdos');	  				
	    		}else{
	    			if(rec.get('idExpediente')){
	    				var idExpediente = rec.get('idExpediente');
	    				var des = rec.get('descripcionExpediente');
	    				var tipo = rec.get('tipoExpediente');
	    		
	    				if(tipo == 'REC'){
	    					debugger;
	    					app.abreExpedienteTab(idExpediente,des,'acuerdos');	
	    				}else{
	    					debugger;
	    					app.abreExpedienteTab(idExpediente,des,'propuestas');
	    				}
	    			}else{
	    		    	alert('El acuerdo no tiene asociado ningï¿½n expediente o asunto');
	    		    	}
	    		}
 	
	    };
	    
	gridAcuerdos.addListener('rowdblclick', gridAcuerdosListener);
	
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