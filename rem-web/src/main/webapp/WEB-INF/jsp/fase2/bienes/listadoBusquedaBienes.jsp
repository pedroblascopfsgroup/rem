<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	//Criterios de busqueda
	//Descripción
	var descripcion = app.creaText('descripcion','<s:message code="bienes.busqueda.filtro.descripcion" text="**Tipo"/>','');
	//Número Contrato
	var nroContrato = app.creaText('nroContrato','<s:message code="bienes.busqueda.filtro.contrato" text="**Nro. Contrato"/>','');
	//Nombre, Apellidos, y número de documento de una persona. Buscando todos los bienes relacionados con esa persona.
	var nombre = app.creaText('nombre','<s:message code="bienes.busqueda.filtro.nombre" text="**Nombre"/>','');
	var apellido = app.creaText('apellido','<s:message code="bienes.busqueda.filtro.apellido" text="**Apellido 1"/>','');
	var documento = app.creaText('documento','<s:message code="bienes.busqueda.filtro.documento" text="**Nro. Documento"/>','');
	//Tipo de Bien
	var tipoBien = app.creaCombo({
		data : <app:dict value="${tiposBien}" />
		<app:test id="tipoBienCombo" addComa="true" />
		,name : 'tipoBien'
		,fieldLabel : '<s:message code="bienesCliente.tipo" text="**Tipo" />'
		//,value : '${bien.tipoBien.codigo}'
		
	});
	//Datos registrales
	var datosRegistrales = app.creaText('datosRegistrales','<s:message code="bienes.busqueda.filtro.datosregistrales" text="**Datos Registrales"/>','');
	//Ref Catastral
	var refCatastral = app.creaText('refCatastral','<s:message code="bienes.busqueda.filtro.refcatastral" text="**Ref. Catastral"/>','');
	
	//Población 
	var poblacion = app.creaText('poblacion','<s:message code="bienes.busqueda.filtro.poblacion" text="**Poblacion"/>','');
		
	
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
	
//    recargarComboZonas();
    comboJerarquia.on('select',recargarComboZonas);
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas});
	
	//valor bien
	var mmValorBien = app.creaMinMax('<s:message code="bienes.busqueda.filtro.valor" text="**Valor del Bien" />', 'valorbien');

	//importe Cargas
	var mmImporteCargas = app.creaMinMax('<s:message code="bienes.busqueda.filtro.importecargas" text="**Importe Cargas" />', 'importecargas');
	
	//Participacion
	var mmParticipacion = app.creaMinMax('<s:message code="bienes.busqueda.filtro.participacion" text="**Participacion" />', 'participacion');
	
	//Superficie
	var mmSuperficie = app.creaMinMax('<s:message code="bienes.busqueda.filtro.superficie" text="**Superficie" />', 'superficie');
	
	var buscarFunc=function(){
		
	};
	var btnReset = app.crearBotonResetCampos([
		descripcion
		,nroContrato
		,nombre
		,apellido
		,documento
		,tipoBien 
		,datosRegistrales
		,refCatastral 
		,poblacion
		,comboJerarquia 
		,comboZonas
		,mmValorBien.min
		,mmValorBien.max
		,mmImporteCargas.min 
		,mmImporteCargas.max 
		,mmParticipacion.min
		,mmParticipacion.max
		,mmSuperficie.min
		,mmSuperficie.max
	]);
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	var panelFiltros=new Ext.Panel({
		autoHeight:true
		,layout:'table'
		,title : '<s:message code="bienes.busqueda.filtros" text="**Filtro de Bienes" />'
		,layoutConfig:{columns:2}
		,titleCollapse : true
		//,border:false
		,collapsible:true
		,tbar : [btnBuscar,btnReset, '->', app.crearBotonAyuda()]
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,style:'padding:10 20 10 10'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				//layout:'form'
				//,bodyStyle:'padding:5px;cellspacing:10px'
				width:350
				,items:[
					descripcion
					,nroContrato
					,nombre
					,apellido
					,documento
					,tipoBien
					,datosRegistrales
					,refCatastral 
					,poblacion 
				]
			},{
				items:[
					comboJerarquia 
					,comboZonas
					,mmValorBien.panel
					,mmImporteCargas.panel 
					,mmParticipacion.panel
					,mmSuperficie.panel
				]
			}
		]
		,listeners:{	
			beforeExpand:function(){
				bienesGrid.setHeight(300);
			}
			,beforeCollapse:function(){
				bienesGrid.setHeight(500);
			}
		}
	});

	var bien = Ext.data.Record.create([
				{name:'id'}
				,{name:'tipo'}
				,{name:'detalle'}
				,{name:'participacion'}
				,{name:'poblacion'}
				,{name:'importeCargas'}
				,{name:'valorActual'}
				,{name:'refCatastral'}		
				,{name:'superficie'}		
				,{name:'poblacion'}		
				,{name:'datosRegistrales'}
				,{name:'descripcion'}		
				,{name:'titular'}		
		]);

		var bienesST = page.getStore({
			flow : 'clientes/bienesData'
			,pageSize : 20
			,reader : new Ext.data.JsonReader({root : 'bienes'}, bien)
		});


		var bienesCm = new Ext.grid.ColumnModel([
		//Código del Bien
		{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.codigo" text="**Codigo"/>', 
		    	width: 20, sortable: true, dataIndex: 'id'},
		//Tipo de Bien
		    {	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.tipo" text="**Tipo"/>', 
		    	width: 120, sortable: true, dataIndex: 'tipo'},
		//Descripción (Nombre del bien)		
		    {	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.detalle" text="**Detalle"/>', 
		    	width: 120, dataIndex: 'descripcion'},
		//Cuota de propiedad % de participación del cliente en el bien		
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.participacion" text="**Participacion"/>', 
				width: 120, dataIndex: 'participacion', renderer: app.format.percentRenderer, align:'right'},
		//Valor del Bien
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.valor" text="**Valor"/>',
				width: 135, dataIndex: 'valorActual',renderer: app.format.moneyRenderer, align:'right'},
		//Importe Cargas (en el caso en el que tenga cargas)
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.cargas" text="**Cargas"/>', 
				width: 120, dataIndex: 'importeCargas',renderer: app.format.moneyRenderer, align:'right'},
		//Referencia catastral
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.refcatastral" text="**Referencia Catastral"/>',
				width: 135, dataIndex: 'refCatastral'},
		//Superficie (en m2)
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.superficie" text="**Superficie"/>',
				width: 135, dataIndex: 'superficie', renderer: app.format.sqrMtsRenderer, align:'right'},
		//Población
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.poblacion" text="**Poblacion"/>',
				width: 135, dataIndex: 'poblacion', align:'right'},
		//Datos registrales (Libro, tomo, folio y línea)
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.datosregistrales" text="**Datos Registrales"/>',
				width: 135, dataIndex: 'datosRegistrales'},
		//Titular 
			{	header: '<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.titular" text="**Titular"/>',
				width: 100, dataIndex: 'titular'}
			]
		);

		var bienesGrid=app.crearGrid(bienesST,bienesCm,{
			title:'<s:message code="menu.clientes.consultacliente.solvenciatab.bienes.title" text="**Bienes"/>'
			<app:test id="bienesGrid" addComa="true" />
			,style : 'padding:0 10 10 10'
			,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	        ,iconCls : 'icon_bienes'
		});
	bienesGrid.on('rowdblclick',function(){ 
		
	});
	var panel = new Ext.Panel({
		autoHeight:true
		,items:[panelFiltros,bienesGrid	]
		,border:false
	});
	g_panel=panel;
	page.add(panel);
</fwk:page>