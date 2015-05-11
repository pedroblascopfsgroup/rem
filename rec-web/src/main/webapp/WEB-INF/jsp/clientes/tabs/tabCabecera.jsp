<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){

		var limit = 25;
		
		var labelLargo = function(label,text){
			return {html : "<span class='LabelStatic'>"+label+":</span><span class='TextStatic' ext:qtip='"+text+"' >"+text+"</span>",border:false}
		}
		
		var cfg = {labelStyle:"width:185px;font-weight:bolder",width:375};
		var tel1 = '${persona.telefono1}';
		var tel2 = '${persona.telefono2}';	
	
		var tipoTel1 = '${persona.tipoTelefono1.descripcion}';	
		var tipoTel2 = '${persona.tipoTelefono2.descripcion}';	
	
		var descTel1 = '';
		var descTel2 = '';
	
		
		if (tel1 != '')
		{
			descTel1 = tel1;
			if (tipoTel1 != '') descTel1 += ' ('+tipoTel1+')';
		}	
		
		if (tel2 != '')
		{
			descTel2 = tel2;
			if (tipoTel2 != '') descTel2 += ' ('+tipoTel2+')';
		}
		
		//Textfields
		var txtNombre 	= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.nombre" text="**Nombre"/>','<s:message text="${persona.nombre}" javaScriptEscape="true" />' , {<app:test id="txtNombre" />},cfg);
		var txtApe 		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.apellido" text="**Apellidos"/>','<s:message text="${persona.apellido1} ${persona.apellido2}" javaScriptEscape="true" />' , {<app:test id="txtApe" />},cfg);
		var txtNroDoc 	= app.creaLabel('${persona.tipoDocumento}', '${persona.docId}' , {<app:test id="txtNroDoc" />},cfg);
		var fijo1		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.telefono1" text="**Fijo1" />',descTel1, {<app:test id="fijo1" />},cfg);
		var fijo2		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.telefono2" text="**Fijo2" />',descTel2,cfg);
		var tipoPer		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.tipo" text="**Tipo" />','${persona.tipoPersona.descripcion}',cfg);
		var codClienteEntidad=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.codCliente" text="**Codigo" />','${persona.codClienteEntidad}' , {<app:test id="codClienteEntidad" />},cfg);
		var segmento	= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.segmento" text="**Segmento" />','${persona.segmento}: ${persona.segmentoEntidad.descripcion}' ,cfg);
		var situacionData = '${persona.situacion}';
		if('${persona.clienteActivo}'!='' )
			situacionData = situacionData + ' / ${persona.clienteActivo.arquetipo.itinerario.dDtipoItinerario.descripcion}';
		var situacion	= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.situacion" text="**Situacion" />',situacionData,cfg);
		
		var ratingExterno=app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.ratingExterno" text="**rating Externo" />','${persona.ratingExterno}',cfg); 
		
		
		var estadoData = '${persona.estadoCliente}';
		if('${persona.estadoCliente}'!='' && '${persona.clienteActivo}' != '')
			estadoData = estadoData + ' (<fwk:date value="${persona.clienteActivo.fechaEstado}"/>)';
		var estado		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.estado" text="**Estado" />',estadoData, cfg);
		//var newEmail		= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.email" text="**e-mail" />','${persona.email}',cfg);
		var newEmail	= labelLargo('<s:message code="menu.clientes.consultacliente.datosTab.email" text="**e-mail" />','${persona.email}',cfg);
		var nacionalidad= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.nacionalidad" text="**Nacionalidad" />','${persona.nacionalidad.descripcion}',cfg);
		
		
		//Volumen Riesgo Directo*
		var volRiesgoDirecto 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirecto" text="**volRiesgoDirecto"/>',app.format.moneyRenderer('${persona.riesgoDirecto}') ,cfg);
		//Volumen Riesgo Irregular (vencido)
		var volRiesgoDirectoVencido 	= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoVencido" text="**volRiesgoDirectoVencido"/>',app.format.moneyRenderer('${persona.riesgoDirectoVencido}') ,cfg);
		//Volumen Riesgo Indirecto*
		var volRiesgoIndirecto 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoIndirecto" text="**volRiesgoIndirecto"/>',app.format.moneyRenderer('${persona.riesgoIndirecto}') ,cfg);
		//Volumen Riesgo Directo Da�ado
		var volRiesgoDirectoDaniado 	= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoDaniado" text="**volRiesgoDirectoDaniado"/>',app.format.moneyRenderer('${persona.riesgoDirectoDanyado}') ,cfg);
		//Volumen Riesgo en otras entidades
		var volRiesgoOtrasEnt 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoOtrasEnt" text="**volRiesgoOtrasEnt"/>',app.format.moneyRenderer('${persona.riesgoVencidoOtrasEnt}') ,cfg);
		//Volumen Riesgo en otras entidades Da�ado (riesgoDirectoNoVencidoDanyado)
		var volRiesgoDaniadoOtrasEnt 	= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDaniadoOtrasEnt" text="**volRiesgoOtrasEnt"/>',app.format.moneyRenderer('${persona.riesgoDirectoNoVencidoDanyado}') ,cfg);
		//Puntuaci�n de Alertas
		var puntuacionAlerta 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.puntuacionAlerta" text="**puntuacionAlerta" />','${persona.puntuacionTotalActiva.puntuacion}',cfg);
		//Pre-pol�tica*
		var prePolitica 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.prePolitica" text="**prePolitica" />','${persona.prepolitica.descripcion}',cfg);
		//Pol�tica*
		var politica 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.politica" text="**politica" />','${persona.politicaVigente.tipoPolitica.descripcion}',cfg);
		//Grupo (si pertenece a alguno)
		var grupo=''
		if('${persona.grupo}'!=null)
			grupo='${persona.grupo.grupoCliente.nombre}'
		var grupoCliente	 			= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.grupoCliente" text="**grupoCliente" />',grupo,cfg);
		var ultimaOperacionConcedida	= app.creaLabel('<s:message code="menu.clientes.consultacliente.datosTab.ultimaOperacionConcedida" text="**ultima Operacion Concedida" />',"<fwk:date value='${persona.ultimaOperacionConcedida}'/>",cfg);	
	
	
	
			// Datos para rellenar grid direcciones
		var dirs = <json:object>
		<json:array name="direcciones" items="${persona.direcciones}" var="d">
		 <json:object>
		   <json:property name="tipoVia" value="${d.tipoVia.descripcion}" />
		   <json:property name="domicilio" value="${d.domicilio}" />
		   <json:property name="numeroDomicilio" value="${d.domicilio_n}"/>
		   <json:property name="portal" value="${d.portal}"/>
		   <json:property name="piso" value="${d.piso}"/>
		   <json:property name="escalera" value="${d.escalera}"/>
		   <json:property name="puerta" value="${d.puerta}"/>
		   <json:property name="codPostal" value="${d.codigoPostal}" />
		   <json:property name="provincia" value="${d.provincia.descripcion}" />
		   <json:property name="localidad" value="${d.localidad}" />
		   <json:property name="localidad" value="${d.municipio}" />
		 </json:object>
		</json:array>
		</json:object>
		;
		
						
		var addressStore = new Ext.data.JsonStore({
	    	data: dirs
	    	,root: 'direcciones'
	    	,fields: ['domicilio','numeroDomicilio','portal','piso','escalera','puerta','municipio','localidad','provincia','codPostal','provincia']
		});


		var addressCM = new Ext.grid.ColumnModel([
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.domicilio" text="**Domicilio" />', width: 180, sortable: true, dataIndex: 'domicilio'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.numeroDomicilio" text="**Numero Domicilio" />', width: 100, sortable: true, dataIndex: 'numeroDomicilio'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.portal" text="**Portal" />', width: 60, sortable: true, dataIndex: 'portal'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.piso" text="**Piso" />', width: 60, sortable: true, dataIndex: 'piso'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.escalera" text="**escalera" />', width: 60, sortable: true, dataIndex: 'escalera'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.puerta" text="**Puerta" />', width: 60, sortable: true, dataIndex: 'puerta'},
				{header: '<s:message code="menu.clientes.consultacliente.datosTab.codpostal" text="**Cod. Postal" />', width: 60, sortable: true, dataIndex: 'codPostal'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.localidad" text="**Localidad" />', width: 100, sortable: true, dataIndex: 'localidad'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.provincia" text="**Provincia" />', width: 100, sortable: true, dataIndex: 'provincia'},
			    {header: '<s:message code="menu.clientes.consultacliente.datosTab.municipio" text="**Municipio" />', width: 100, sortable: true, dataIndex: 'municipio'}
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
		

		
	
		var getAddress=function(rec){
			if (rec && rec.getAt(0)) return rec.getAt(0).get('domicilio')+", "+addressStore.getAt(0).get('localidad');
			return "";
		}
		
		var direccion=new Ext.ux.form.StaticTextField({
			fieldLabel:'<s:message code="menu.clientes.consultacliente.datosTab.domicilio" text="**Direccion" />'
			,labelStyle:'font-weight:bolder;text-overflow:visible'
			,value:getAddress(addressStore)
		});
		
		
		var botonDir=new Ext.Button({
			text:'<s:message code="menu.clientes.consultacliente.datosTab.masdirec" text="**Mas direcciones.." />'
	            ,handler:function(){
					app.openWindow({
						title:'<s:message code="menu.clientes.consultacliente.datosTab.direcciones" text="**Direcciones" />'
						,width:920
                        ,autoScroll:true
						,closable:true
						,items:getDireccionesGrid()
					}); 
	            }
			//s�lo mostramos si hay direcciones de m�s
			//,hidden : eval(dirs.direcciones.length<2)
		});
	
		var datosPrincipalesFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="menu.clientes.consultacliente.menu.DatosPrincipales" text="**Datos Principales"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[codClienteEntidad,txtNombre,txtApe,txtNroDoc,fijo1,newEmail]},
					  {items:[tipoPer,situacion,estado,segmento,fijo2,botonDir]}
					 ]
		});
		var datosRiesgoFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="menu.clientes.consultacliente.menu.DatosRiesgo" text="**Datos de Riesgo"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[volRiesgoDirecto,volRiesgoDirectoVencido,volRiesgoIndirecto,volRiesgoDirectoDaniado,prePolitica,grupoCliente]},
					  {items:[volRiesgoOtrasEnt,volRiesgoDaniadoOtrasEnt,puntuacionAlerta,ultimaOperacionConcedida,politica,ratingExterno]}
					 ]
		});
		
		
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
				,flow : 'clientes/listadoExpedientesDeCliente'
				,limit:limit
				,reader : new Ext.data.JsonReader({root : 'expedientes',totalProperty : 'total'}, recordExpedientes)
				,remoteSort : true
			});
	
	
	
		//Store Asuntos
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
			]);	

		var asStore = page.getStore({
		        eventName : 'listado'
				,flow : 'clientes/listadoAsuntosDeCliente'
				,limit:limit
				,reader : new Ext.data.JsonReader({root : 'asuntos',totalProperty : 'total'}, recordAsuntos)
				,remoteSort : true
			});
		
	
		//Column Model de tabla expedientes
		var expCm = new Ext.grid.ColumnModel([
		    {	header: '<s:message code="expedientes.listado.codigo" text="**Codigo"/>', 
		    	sortable: false, dataIndex: 'codigo',width: 60},
		    {	header: '<s:message code="expedientes.listado.descripcion" text="**Descripcion"/>', 
		    	sortable: false, dataIndex: 'descripcion',width: 150},
		    {	header: '<s:message code="expedientes.listado.fechacreacion" text="**Fecha Creacion"/>', 
		    	sortable: false, dataIndex: 'fcreacion',width: 90},
		    {	header: '<s:message code="expedientes.listado.origen" text="**Origen"/>', 
		    	sortable: false, dataIndex: 'manual',width: 70},
		    {	header: '<s:message code="expedientes.listado.estado" text="**Estado"/>',
				sortable: false, dataIndex: 'estado',width: 70},
		    {	header: '<s:message code="expedientes.listado.situacion" text="**Situacion"/>',
				sortable: false, dataIndex: 'situacion',width: 110},
			{	header: '<s:message code="expedientes.listado.riesgosD" text="**Riesgos D."/>', 
				sortable: false, dataIndex: 'volumenRiesgo',renderer: app.format.moneyRenderer,align:'right',width: 120},
		    {	header: '<s:message code="expedientes.listado.riesgosI" text="**Riesgos I."/>', 
		    	sortable: false, dataIndex: 'volumenRiesgoVencido',renderer: app.format.moneyRenderer,align:'right',width: 120},
		    {	header: '<s:message code="expedientes.listado.oficina" text="**Oficina"/>', 
				sortable: false, dataIndex: 'oficina',width: 70},
		    {	header: '<s:message code="expedientes.listado.gestor" text="**Gestor"/>', 
				sortable: false, dataIndex: 'gestor',width: 70},
		    {	header: '<s:message code="expedientes.listado.fvenc" text="**Fecha Vencim."/>', 
				sortable: false, dataIndex: 'fechaComite'},
		    {	header: '<s:message code="expedientes.listado.comite" text="**Comit�"/>', 
				hidden:true,sortable: false, dataIndex: 'comite',width: 70}
			]
		); 
		//Column Model de tabla asuntos
		var asuntosCm= new Ext.grid.ColumnModel([
		    {header: '<s:message code="asuntos.listado.codigo" text="**Codigo"/>', sortable: false, dataIndex: 'codigo'},
		    {header: '<s:message code="asuntos.listado.nombreasunto" text="**Nombre"/>', width: 80, sortable: false, dataIndex: 'descripcion'},
		    {header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion"/>', width: 80, sortable: false, dataIndex: 'fcreacion'},
			{header: '<s:message code="asuntos.listado.estado" text="**estado"/>', width: 120, sortable: false, dataIndex: 'estado'},
		    {header: '<s:message code="asuntos.listado.gestor" text="**Gestor"/>', width: 115, sortable: false, dataIndex: 'gestor'},
		    {header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor"/>', width: 115, sortable: false, dataIndex: 'supervisor'},
			{header: '<s:message code="asuntos.listado.despacho" text="**Despacho"/>', width: 120, sortable: false, dataIndex: 'despacho'},
			{header: '<s:message code="asuntos.listado.comite" text="**Comit�"/>',hidden:true, width: 120, sortable: false, dataIndex: 'comite'}
			
			]
		);
		
		var numExpedientesActivos = ${persona.numExpedientesActivos};
		var tituloGridExpedientes ='<s:message code="menu.clientes.consultacliente.datosTab.expedientes" text="**Expedientes"/>'; 
		if(numExpedientesActivos!=0){
			tituloGridExpedientes = tituloGridExpedientes +' ['+	numExpedientesActivos + ' <s:message code="menu.clientes.consultacliente.datosTab.activos" text="**Activos"/> ]';
		}else{
			tituloGridExpedientes = tituloGridExpedientes +' [ <s:message code="menu.clientes.consultacliente.datosTab.ningunoActivo" text="**Ninguno Activo"/> ]';
		}
		var cfg={
			title:tituloGridExpedientes
			,style : 'margin-bottom:10px;padding-right:20px'
		    ,clicksToEdit:1
		    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		    ,height : 140
			,collapsible:true
			,collapsed:true
			,titleCollapse : true
	        //,autoWidth:true
		   	,iconCls : 'icon_expedientes'
		    ,viewConfig : {  forceFit : true}
			<app:test id="expedientesGrid" addComa="true" />
			,bbar : [ fwk.ux.getPaging(expStore) ]
		};
		//Tabla de expedientes			
		var expedientesGrid=app.crearGrid(expStore,expCm,cfg);
		
				
		<c:if test="${!usuario.usuarioExterno}">
		var expedientesGridListener =	function(grid, rowIndex, e) {
		    	var rec = grid.getStore().getAt(rowIndex);
		    	if(rec.get('codigo')){
		    		var id = rec.get('codigo');
		    		var desc = rec.get('descripcion');
		    		app.abreExpediente(id,desc);
			    	
		    	}
		    };

			expedientesGrid.addListener('rowdblclick', expedientesGridListener);
		</c:if>

		var numAsuntosActivos = ${persona.numAsuntosActivos};
		var tituloGridAsuntos ='<s:message code="menu.clientes.consultacliente.datosTab.asuntos" text="**Asuntos"/>'; 
		if(numAsuntosActivos!=0){
			tituloGridAsuntos = tituloGridAsuntos +' ['+	numAsuntosActivos + ' <s:message code="menu.clientes.consultacliente.datosTab.activos" text="**Activos"/> ]';
		}else{
			tituloGridAsuntos = tituloGridAsuntos +' [ <s:message code="menu.clientes.consultacliente.datosTab.ningunoActivo" text="**Ninguno Activo"/> ]';
		}
		//Tabla de asuntos
		var asuntosGrid=app.crearGrid(asStore,asuntosCm,{
			title:tituloGridAsuntos
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
		
			asuntosGrid.addListener('rowdblclick', asuntosGridListener);
		</c:if>
		

		
		
		
		//Panel propiamente dicho...
		var panel=new Ext.Panel({
			title:'<s:message code="contrato.consulta.tabcabecera.titulo" text="**Cabecera"/>'
			//,layout:'anchor'
			//,region: 'south'
			,layout:'table'
			,border : false
		    ,layoutConfig: {
		        // The total column count must be specified here
		        columns: 1
		    }
			,autoScroll:true
			,bodyStyle:'padding:5px;margin:5px'
			,autoHeight:true
			,autoWidth : true
			,items:[
				datosPrincipalesFieldSet
				//,telefonosFieldSet
				,datosRiesgoFieldSet
				,expedientesGrid
				,asuntosGrid
			]
			,nombreTab : 'cabecera'
			
		});
		
		
		Ext.onReady(function(){		
			expStore.webflow({idPersona:"${persona.id}"});
			asStore.webflow({idPersona:"${persona.id}"});			
		});
		
		//panel.idCliente =  ${id};
		return panel;
	})()