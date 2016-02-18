<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

var esProveedorSolvencia = false;
<sec:authorize ifAllGranted="ROLE_PROVEEDOR_SOLVENCIA">
	esProveedorSolvencia = true;
</sec:authorize>

	var panel=new Ext.Panel({
		title : "Cabecera"
		,layout:'table'
		,border : false
		,layoutConfig: { columns: 1 }
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'tabCabeceraCliente'
	});
	
	function label(id,text){
		  return app.creaLabel(text,"",  {id:'entidad-cliente-'+id});
	}

	function fieldSet(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : items
		});
	}


	var codigo =    label('codigo','<s:message code="menu.clientes.consultacliente.datosTab.codCliente" text="**Codigo"/>');
	var nombre =    label('nombre','<s:message code="menu.clientes.consultacliente.datosTab.nombre" text="**Nombre"/>');
	var apellidos = label('apellidos','<s:message code="menu.clientes.consultacliente.datosTab.apellido" text="**Apellidos"/>');
	var fijo1 =     label('fijo1','<s:message code="menu.clientes.consultacliente.datosTab.telefono1" text="**Fijo1"/>');
	var fijo2 =     label('fijo2','<s:message code="menu.clientes.consultacliente.datosTab.telefono2" text="**Fijo2"/>');
	var tipoPer =   label('tipoPer','<s:message code="menu.clientes.consultacliente.datosTab.tipo" text="**Tipo"/>');
	var nif =       label('nif','docType');
	var segmento =  label('segmento','<s:message code="menu.clientes.consultacliente.datosTab.segmento" text="**Segmento"/>');
	var situacion = label('situacion','<s:message code="menu.clientes.consultacliente.datosTab.situacion" text="**Situacion"/>');
	var estado =    label('estado','<s:message code="menu.clientes.consultacliente.datosTab.estado" text="**Estado"/>');
	var email =     label('email','<s:message code="menu.clientes.consultacliente.datosTab.email" text="**Email"/>');


	var dirs={direcciones:[]};
	var addressStore = new Ext.data.JsonStore({
		data: dirs
		,storeId : 'direccionesStore'
		,root: 'direcciones'
		,fields: ['domicilio','numeroDomicilio','portal','piso','escalera','puerta','municipio','localidad','provincia','codPostal','provincia']
	});

	var addressCM = new Ext.grid.ColumnModel([
		{header: 'Domicilio', width: 180, sortable: true, dataIndex: 'domicilio'},
		{header: 'N&uacute;mero Domicilio', width: 100, sortable: true, dataIndex: 'numeroDomicilio'},
		{header: 'Portal', width: 60, sortable: true, dataIndex: 'portal'},
		{header: 'Piso', width: 60, sortable: true, dataIndex: 'piso'},
		{header: 'Escalera', width: 60, sortable: true, dataIndex: 'escalera'},
		{header: 'Puerta', width: 60, sortable: true, dataIndex: 'puerta'},
		{header: 'Cod. Postal', width: 60, sortable: true, dataIndex: 'codPostal'},
		{header: 'Localidad', width: 100, sortable: true, dataIndex: 'localidad'},
		{header: 'Provincia  ', width: 100, sortable: true, dataIndex: 'provincia'},
		{header: 'Municipio', width: 100, sortable: true, dataIndex: 'municipio'}
	]);

	var getDireccionesGrid = function(){
		return new Ext.grid.GridPanel({	
			frame:false 
			,border:false
			,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
			,store: addressStore
			,cm:addressCM
			,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
			//,autoHeight:true
			,autoWidth : true
			,height:100
		});
	};
	
	var cfg = {
			title:'Direcciones'
			,layout:'fit'
			,modal:true
			,x: 50
			,y: 50
			,autoShow : true
			,autoHeight : true
			,autoScroll:true
			,closable:true
			,closeAction: 'hide'
			,width:920
			,bodyBorder : false
			,items:getDireccionesGrid()
	};
	var win = new Ext.Window(cfg);
	win.hide();
	
	var botonDir=new Ext.Button({
		text:'Direcciones'
		,handler:function(){
			win.show();
				
		}
	});


   var datosPrincipalesFieldSet = fieldSet( '<s:message code="menu.clientes.consultacliente.menu.DatosPrincipales" text="**Datos Principales"/>'
                ,[{items:[codigo, nombre, apellidos,nif, fijo1, email]} ,{items : [tipoPer, situacion, estado, segmento, fijo2, botonDir]} ]);

   var volRiesgoDirecto =        label('volRiesgoDirecto','<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirecto" text="**volRiesgoDirecto"/>');
   var volRiesgoDirectoVencido = label('volRiesgoDirectoVencido','<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoVencido" text="**volRiesgoDirectoVencido"/>');
   var volRiesgoIndirecto =      label('volRiesgoIndirecto','<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoIndirecto" text="**volRiesgoIndirecto"/>');
   var volRiesgoDirectoDaniado=  label('volRiesgoDirectoDaniado','<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoDaniado" text="**volRiesgoDirectoDaniado"/>');
   var volRiesgoOtrasEnt =       label('volRiesgoOtrasEnt','<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoOtrasEnt" text="**volRiesgoOtrasEnt"/>');
   var volRiesgoDaniadoOtrasEnt= label('volRiesgoDaniadoOtrasEnt','<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDaniadoOtrasEnt" text="**volRiesgoOtrasEnt"/>');
   var puntuacionAlerta=         label('puntuacionAlerta','<s:message code="menu.clientes.consultacliente.datosTab.puntuacionAlerta" text="**puntuacionAlerta" />');
   var prePolitica	=             label('prePolitica','<s:message code="menu.clientes.consultacliente.datosTab.prePolitica" text="**Pol&iacute;tica de Seguimiento" />');
   var politica=                 label('politica','<s:message code="menu.clientes.consultacliente.datosTab.politica" text="**Plan de actuaci&oacute;n" />');
   var grupoCliente =            label('grupoCliente','<s:message code="menu.clientes.consultacliente.datosTab.grupoCliente" text="**grupoCliente" />');
   var ultimaOperacionConcedida= label('ultimaOperacionConcedida','<s:message code="menu.clientes.consultacliente.datosTab.ultimaOperacionConcedida" text="**ultima Operacion Concedida" />');
   var ratingExterno =           label('ratingExterno','<s:message code="menu.clientes.consultacliente.datosTab.ratingExterno" text="**rating Externo" />');

   var datosRiesgoFieldSet = fieldSet( '<s:message code="menu.clientes.consultacliente.menu.DatosRiesgo" text="**Datos de Riesgo"/>'
      ,[{items:[volRiesgoDirecto,volRiesgoDirectoVencido,volRiesgoIndirecto,volRiesgoDirectoDaniado,prePolitica,grupoCliente]},
      {items:[volRiesgoOtrasEnt,volRiesgoDaniadoOtrasEnt,puntuacionAlerta,ultimaOperacionConcedida,politica,ratingExterno]} ]);

   panel.add(datosPrincipalesFieldSet);
   panel.add(datosRiesgoFieldSet);

   var expedientes;
   var asuntos;
				
	var recordExpedientes = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'descripcion'}
		,{name:'fcreacion'}
		,{name:'situacion'}	
		,{name:'estado'}	
		,{name:'volumenRiesgo'}	
		,{name:'volumenRiesgoVencido'}	
		,{name:'manual'}	
		,{name:'gestor'}	
		,{name:'oficina'}	
		,{name:'fechaComite'}
		,{name:'comite'}	
	]);
		
	var expStore = page.getStore({
        eventName : 'listado'
        ,storeId : 'expStoreId'
        ,flow : 'clientes/listadoExpedientesDeCliente'
        ,limit:10
        ,reader : new Ext.data.JsonReader({root : 'expedientes',totalProperty : 'total'}, recordExpedientes)
	});

	//Column Model de tabla expedientes
	var expCm = new Ext.grid.ColumnModel([
		{	header: '<s:message code="expedientes.listado.codigo" text="**Codigo"/>', 
			sortable: true, dataIndex: 'codigo',width: 60},
		{	header: '<s:message code="expedientes.listado.descripcion" text="**Descripcion"/>', 
			sortable: true, dataIndex: 'descripcion',width: 150},
		{	header: '<s:message code="expedientes.listado.fechacreacion" text="**Fecha Creacion"/>', 
			sortable: true, dataIndex: 'fcreacion',width: 90},
		{	header: '<s:message code="expedientes.listado.origen" text="**Origen"/>', 
			sortable: true, dataIndex: 'manual',width: 70},
		{	header: '<s:message code="expedientes.listado.estado" text="**Estado"/>',
			sortable: true, dataIndex: 'estado',width: 70},
		{	header: '<s:message code="expedientes.listado.situacion" text="**Situacion"/>',
			sortable: true, dataIndex: 'situacion',width: 110},
		{	header: '<s:message code="expedientes.listado.riesgosD" text="**Riesgos D."/>', 
			sortable: true, dataIndex: 'volumenRiesgo',renderer: app.format.moneyRenderer,align:'right',width: 120},
		{	header: '<s:message code="expedientes.listado.riesgosI" text="**Riesgos I."/>', 
			sortable: true, dataIndex: 'volumenRiesgoVencido',renderer: app.format.moneyRenderer,align:'right',width: 120},
		{	header: '<s:message code="expedientes.listado.oficina" text="**Oficina"/>', 
			sortable: true, dataIndex: 'oficina',width: 70},
		{	header: '<s:message code="expedientes.listado.gestor" text="**Gestor"/>', 
			sortable: true, dataIndex: 'gestor',width: 70},
		{	header: '<s:message code="expedientes.listado.fvenc" text="**Fecha Vencim."/>', 
			sortable: true, dataIndex: 'fechaComite'},
		{	header: '<s:message code="expedientes.listado.comite" text="**Comit�"/>', 
			hidden:true,sortable: false, dataIndex: 'comite',width: 70}
		]
	); 

	var cfg={
		title:""
		,style : 'margin-bottom:10px;padding-right:20px'
		,clicksToEdit:1
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,height : 140
		,collapsible:true
		,collapsed:true
		,titleCollapse : true
		,iconCls : 'icon_expedientes'
		,viewConfig : {  forceFit : true}
		<app:test id="expedientesGrid" addComa="true" />
		,bbar : [ fwk.ux.getPaging(expStore) ]
	};
		
	//Tabla de expedientes			
	panel.expedientesGrid=app.crearGrid(expStore,expCm,cfg);
	
	<c:if test="${!usuario.usuarioExterno}">
		var expedientesGridListener =	function(grid, rowIndex, e) {
			var rec = grid.getStore().getAt(rowIndex);
			if(rec.get('codigo')){
				var id = rec.get('codigo');
				var desc = rec.get('descripcion');
				app.abreExpediente(id,desc);
			}
		};
		panel.expedientesGrid.addListener('rowdblclick', expedientesGridListener);
	</c:if>
		
	var recordAsuntos = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'fcreacion'}
		,{name:'descripcion'}
		,{name:'situacion'}	
		,{name:'gestor'}	
		,{name:'supervisor'}	
		,{name:'despacho'}	
		,{name:'comite'}	
		,{name:'estado'}	
		,{name:'saldoTotal'}
		,{name:'codigoContrato'}
	]);	

	var asStore = page.getStore({
		eventName : 'listado'
		,storeId : 'asStoreId'
		,flow : 'clientes/listadoAsuntosDeCliente'
		,limit:10
		,reader : new Ext.data.JsonReader({root : 'asuntos',totalProperty : 'total'}, recordAsuntos)
	});

	var asuntosCm= new Ext.grid.ColumnModel([
		{header: '<s:message code="asuntos.listado.codigo" text="**Codigo"/>',hidden:true, sortable: true, dataIndex: 'codigo'},
		{header: '<s:message code="asuntos.listado.nombreasunto" text="**Nombre"/>', width: 80, sortable: true, dataIndex: 'descripcion'},
		{header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion"/>', width: 80, sortable: true, dataIndex: 'fcreacion'},
		{header: '<s:message code="asuntos.listado.estado" text="**estado"/>', width: 120, sortable: true, dataIndex: 'estado'},
		{header: '<s:message code="asuntos.listado.gestor" text="**Gestor"/>', width: 115, sortable: true, dataIndex: 'gestor'},
		{header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor"/>', width: 115, sortable: true, dataIndex: 'supervisor'},
		{header: '<s:message code="asuntos.listado.despacho" text="**Despacho"/>', width: 120, sortable: true, dataIndex: 'despacho'},
		{header: '<s:message code="plugin.mejoras.cliente.listado.asunto.comite" text="**Comité"/>', hidden:true, width: 120, sortable: true, dataIndex: 'comite'},
		{header: '<s:message code="plugin.mejoras.cliente.listado.asunto.totalSaldo" text="**Saldo total"/>', width: 120, sortable: true, dataIndex: 'saldoTotal', renderer: app.format.moneyRenderer, align:'right'},
		{header: '<s:message code="plugin.mejoras.cliente.listado.asunto.codigoContrato" text="**Contrato"/>', width: 120, sortable: true, dataIndex: 'codigoContrato'}
	]);
	
	//Tabla de asuntos
	panel.asuntosGrid=app.crearGrid(asStore,asuntosCm,{
		title:""
		,iconCls : 'icon_asuntos'
		,height:140
		,style : 'padding-right:20px'
		,collapsible:true
		,collapsed:true
		,titleCollapse : true
		<app:test id="asuntosGrid" addComa="true" />
		,bbar : [ fwk.ux.getPaging(asStore) ]
	});

	<c:if test="${!usuario.usuarioExterno}">
		var asuntosGridListener =	function(grid, rowIndex, e) {
			var rec = grid.getStore().getAt(rowIndex);
			if(rec.get('codigo')){
				var id = rec.get('codigo');
				var desc = rec.get('descripcion');
				app.abreAsunto(id,desc);
			}
		};
		panel.asuntosGrid.addListener('rowdblclick', asuntosGridListener);
	</c:if>

	if(esProveedorSolvencia == false){ //Si es proveedor de solvencia, no debe mostrar los grid de expedientes ni de asuntos ni hacer las llamadas
		entidad.cacheStore(panel.expedientesGrid.getStore());
		entidad.cacheStore(panel.asuntosGrid.getStore());
	
		panel.add(panel.expedientesGrid);
		panel.add(panel.asuntosGrid);
	}
	panel.getValue = function(){
		return {
			expedientesGridCollapsed : panel.expedientesGrid.collapsed
		}
	}
	
	panel.setValue = function(){
		var data = entidad.get("data");
		var cabecera = data.cabecera;

		entidad.setLabel("codigo", cabecera.codigo);
		entidad.setLabel("nombre", cabecera.nombre);
		entidad.setLabel("apellidos", cabecera.apellidos);	
		entidad.setLabel("nif", cabecera.nif, cabecera.tipoDocumento);	
		entidad.setLabel("segmento", cabecera.segmento);	
		entidad.setLabel("tipoPer", cabecera.tipoPer);
		
		//TODO:cambiar label tipoDocumento
		var str=cabecera.situacion;
		if(cabecera.clienteActivo!=''){
			str+=" / " + cabecera.situacionData;
		}
		entidad.setLabel("situacion", str);
		entidad.setLabel("email", cabecera.email);

		str=cabecera.estadoCliente;
		if(str!='' && cabecera.clienteActivo!=''){
			str += " ("+cabecera.fechaEstado+")";
		}
		entidad.setLabel("estado", str);

		var fijo1='';
		if (cabecera.fijo1!='') fijo1=cabecera.fijo1;
		if (cabecera.tipofijo1!='') fijo1 += " ("+cabecera.tipofijo1+")";
		entidad.setLabel("fijo1", fijo1);
		var fijo2='';
		if (cabecera.fijo2!='') fijo2=cabecera.fijo2;
		if (cabecera.tipofijo2!='') fijo2 += " ("+cabecera.tipofijo2+")";
		entidad.setLabel("fijo2", fijo2);
		addressStore.removeAll();
		if(cabecera.direcciones && cabecera.direcciones.length){
			addressStore.loadData(cabecera);
		}

		entidad.setLabel('volRiesgoDirecto',app.format.moneyRenderer(cabecera.riesgoDirecto));
		entidad.setLabel('volRiesgoDirectoVencido',app.format.moneyRenderer(cabecera.riesgoDirectoVencido));
		entidad.setLabel('volRiesgoIndirecto', app.format.moneyRenderer(cabecera.riesgoIndirecto));
		entidad.setLabel('volRiesgoDirectoDaniado',app.format.moneyRenderer(cabecera.riesgoDirectoDanyado));
		entidad.setLabel('volRiesgoOtrasEnt', app.format.moneyRenderer(cabecera.riesgoVencidoOtrasEnt));
		entidad.setLabel('volRiesgoDaniadoOtrasEnt', app.format.moneyRenderer(cabecera.riesgoDirectoNoVencidoDanyado));
		entidad.setLabel('puntuacionAlerta', cabecera.puntuacion);
		entidad.setLabel('prePolitica', cabecera.prepolitica);
		entidad.setLabel('politica',cabecera.politica);
		entidad.setLabel('grupoCliente', data.grupo.nombre);
		entidad.setLabel('ultimaOperacionConcedida', cabecera.ultimaOperacionConcedida);
		entidad.setLabel('ratingExterno',cabecera.ratingExterno);

		var tituloGridExpedientes ='<s:message code="menu.clientes.consultacliente.datosTab.expedientes" text="**Expedientes"/>'; 
		if (cabecera.numExpedientesActivos!=0){
			tituloGridExpedientes = tituloGridExpedientes + ' [ ' + cabecera.numExpedientesActivos + ' <s:message code="menu.clientes.consultacliente.datosTab.activos" text="**Activos"/> ]'; 
		}else{
			tituloGridExpedientes = tituloGridExpedientes + ' [ <s:message code="menu.clientes.consultacliente.datosTab.ningunoActivo" text="**Ninguno Activo"/> ]'; 
		}

		var tituloGridAsuntos ='<s:message code="menu.clientes.consultacliente.datosTab.asuntos" text="**Asuntos"/>'; 
		if (cabecera.numAsuntosActivos!=0){
			tituloGridAsuntos = tituloGridAsuntos + ' [ ' + cabecera.numAsuntosActivos + ' <s:message code="menu.clientes.consultacliente.datosTab.activos" text="**Activos"/> ]'; 
		}else{
			tituloGridAsuntos = tituloGridAsuntos + ' [ <s:message code="menu.clientes.consultacliente.datosTab.ningunoActivo" text="**Ninguno Activo"/> ]'; 
		}

	   this.expedientesGrid.setTitle(tituloGridExpedientes);
	   this.asuntosGrid.setTitle(tituloGridAsuntos);

		if(esProveedorSolvencia == false){
			entidad.cacheOrLoad(data, panel.expedientesGrid.getStore(), { idPersona : data.id } );
			entidad.cacheOrLoad(data, panel.asuntosGrid.getStore(), { idPersona : data.id } );
		}
		var state=entidad.get("tabCabeceraCliente");
		if (state){
			if (state.expedientesGridCollapsed) panel.expedientesGrid.collapse(); else panel.expedientesGrid.expand();
		}
	}

	return panel;
})
