<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	//VARS ********************************************************************
	
	var limit=25;	
	var currentRowId;
	
	//PANEL FILTROS ********************************************************************	
	
   	//Creamos el boton buscar
	var btnBuscar=new Ext.Button({
		text:'<s:message code="app.buscar" text="**Buscar" />'
		,iconCls:'icon_busquedas'
		,handler:function(){
			b=getParametrosDto();
			clientesStore.webflow(b);
			page.fireEvent(app.event.DONE);
		}
	});
	var btnClean=new Ext.Button({
	
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			resetFiltros();
		}
	});
	
	<pfsforms:textfield
		labelKey="menu.clientes.listado.lista.nif"
		label="**CIF/NIF"
		name="nif"
		value=""
		readOnly="false" />
	<pfsforms:textfield
		labelKey="menu.clientes.listado.lista.nombre"
		label="**Nombre"
		name="nombre"
		value=""
		readOnly="false" />
	<pfsforms:textfield
		labelKey="menu.clientes.listado.lista.apellidos"
		label="**Apellidos"
		name="apellidos"
		value=""
		readOnly="false" />
	<pfsforms:textfield
		labelKey="menu.clientes.listado.busqueda.codigoContrato"
		label="**Código de contrato"
		name="codigoContrato"
		value=""
		readOnly="false" />

	var panelFiltros = new Ext.Panel({
		title:'<s:message code="menu.clientes.listado.filtro.filtrodeclientes" text="**Buscador de clientes" />'
		,collapsible:true
		,collapsed: false
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{
				layout:'form'
				,items: [nif,nombre]
				},{
				layout:'form'
				,style: 'margin-left:20px;'
				,items: [apellidos,codigoContrato]
				}]
		,listeners:{	
			beforeExpand:function(){
				grid.setHeight(125);
			}
			,beforeCollapse:function(){
				grid.setHeight(435);
				grid.expand(true);			
			}
		}
		,tbar : [btnBuscar,btnClean]
	});
	//------------------------------------------------------------------------------------------
	resetFiltros = function(){
		
		nif.reset();
		nombre.reset();
		apellidos.reset();
		codigoContrato.reset();
	}
	var getParametrosDto=function(){
		    var b={};
			b.nif = nif.getValue();
			b.nombre=nombre.getValue();
			b.apellidos=apellidos.getValue();
			b.codigoContrato=codigoContrato.getValue();
			
			return b;
	}
	
	//PANEL GRID RESULTADOS ********************************************************************	
	
	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			maskPanel=new Ext.LoadMask(compuesto.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});			
		}
		maskPanel.show();
		maskPanelShow=true;
	};
	
	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
			
		maskPanelShow=false
	};
	
	var Cliente = Ext.data.Record.create([
		{name:'id'}
		,{name : 'nombre', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellidos', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellido1', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellido2', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'segmento', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipo', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'codClienteEntidad', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'direccion', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'telefono1', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'docId', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoPersona', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'deudaIrregular',type: 'float', sortType:Ext.data.SortTypes.asFloat}
		,{name : 'totalSaldo',type: 'float', sortType:Ext.data.SortTypes.asFloat}
		,{name : 'diasVencido', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'numContratos'}
		,{name : 'situacion', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellidoNombre', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'diasCambioEstado', sortType:Ext.data.SortTypes.asInt}
        ,{name : 'ofiCntPase', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'arquetipo', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'deudaDirecta', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'riesgoDirectoNoVencidoDanyado', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'situacionFinanciera', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'fechaDato'}
        ,{name : 'relacionExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'itinerario'}
		,{name : 'riesgoAutorizado', type:'float', sortType:Ext.data.SortTypes.asFloat}        
        ,{name : 'dispuestoVencido', type:'string', sortType:Ext.data.SortTypes.asFloat}        
        ,{name : 'dispuestoNoVencido', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'riesgoDispuesto', type:'float', sortType:Ext.data.SortTypes.asFloat}        
	]);
	
	var clientesStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,remoteSort : true
		,loading:false
		,flow:'gestionclientes/getDatosVencidos'
		,reader: new Ext.data.JsonReader({
	    	root : 'clientes'
	    	,totalProperty : 'total'
	    }, Cliente)
	});
	
	clientesStore.on('beforeload',function(){
			maskAll();
		});
	
	
	var dispuestoMoneyRender = function (value, meta, record) {
		var money = record.get('dispuestoVencido');
		if (money){
			return money + ' &euro;';
		}
		return value;
	};
		
	var clientesCm=new Ext.grid.ColumnModel([
			{header : '<s:message code="menu.clientes.listado.lista.nombre" text="**Nombre" />'
			, dataIndex : 'nombre' ,sortable:true,width:120}
			,{header : '<s:message code="menu.clientes.listado.lista.apellidos" text="**Apellidos" />'
			, dataIndex : 'apellidos' ,sortable:true,width:200}
			,{header : '<s:message code="menu.clientes.listado.lista.codigo" text="**Codigo" />'
			, dataIndex : 'codClienteEntidad',sortable:true,width:70,align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.direccion" text="**Direccion" />'
			, dataIndex : 'direccion',sortable:false,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.nif" text="**CIF/NIF" />'
			, dataIndex : 'docId',sortable:true,width:80,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.itinerario" text="**Itinerario" />'
			, dataIndex : 'itinerario',sortable:false,width:70,align:'right',hidden:false}
			,{header : '<s:message code="menu.clientes.listado.lista.segmento" text="**Segmento" />'
			, dataIndex : 'segmento',sortable:false,width:90}
			,{header : '<s:message code="menu.clientes.listado.lista.tipo" text="**Tipo" />'
			, dataIndex : 'tipo',sortable:false,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.telefono" text="**Telefono" />'
			, dataIndex : 'telefono1',sortable:true,hidden:true}
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.riesgoAutorizado" text="**Riesgo autorizado"/>'
			, dataIndex : 'riesgoAutorizado',sortable:true,renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoVencido" text="**Dispuesto vencido" />'
			<%-- , dataIndex : 'dispuestoVencido',sortable:false,renderer: app.format.moneyRenderer, width:100, align:'right'}--%>
			, dataIndex : 'dispuestoVencido',renderer: dispuestoMoneyRender,sortable:false, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoNoVencido" text="**Dispuesto no vencido" />'
			, dataIndex : 'dispuestoNoVencido',sortable:false,renderer: app.format.moneyRenderer, width:100, align:'right', hidden:true}
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.riesgoDispuesto" text="**Riesgo dispuesto"/>'
			, dataIndex : 'riesgoDispuesto',sortable:false,renderer: app.format.moneyRenderer, width:100, align:'right', hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.nrocontratos" text="**Contratos" />'
			, dataIndex : 'numContratos',sortable:true,width:70, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.posantigua" text="**Posicion antigua" />'
			, dataIndex : 'diasVencido',sortable:false,width:90, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.situacion" text="**Situaci&oacute;n" />'
			, dataIndex : 'situacion',sortable:false,width:65}
			,{header : 'id', dataIndex: 'id', hidden:true,fixed:true}
			,{header : 'apellidoNombre', dataIndex: 'apellidoNombre', hidden:true,fixed:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.diaspase" text="**Dias para pase" />', dataIndex: 'diasCambioEstado', sortable:false, fixed:true, align:'right',hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.ofiCntPase" text="**Oficina del contrato de pase" />'
            , dataIndex: 'ofiCntPase', sortable:false,width:80,hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.arquetipo" text="**Arquetipo" />', dataIndex: 'arquetipo', sortable:false, hidden:true,width:80}
            ,{header : '<s:message code="menu.clientes.listado.lista.situacionFinanciera" text="**Situacion Financiera" />', dataIndex: 'situacionFinanciera', sortable:false ,hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.fechaDato" text="**Fecha dato" />', dataIndex: 'fechaDato', sortable:false}
            ,{header : '<s:message code="menu.clientes.listado.lista.relacionExpediente" text="**Relacion Expediente" />', dataIndex: 'relacionExpediente', sortable:false, hidden:true}
		]);
	
	var pagingBar=fwk.ux.getPaging(clientesStore);
	var cfg={
		title: '<s:message code="menu.clientes.listado.lista.title" text="**Clientes" arguments="0"/>'
		,style:'padding: 10px;'
		,cls:'cursor_pointer'
		,iconCls : 'icon_cliente'
		,collapsible : true
		,collapsed: false
		,titleCollapse : true
		,resizable:true
		,dontResizeHeight:true
		,height:200
		,bbar : [  pagingBar ]
		<app:test id="clientesGrid" addComa="true" />
	};
	var grid=app.crearGrid(clientesStore,clientesCm,cfg);
	grid.loadMask=false;

	clientesStore.on('load', function(){
		grid.setTitle('<s:message code="menu.clientes.listado.lista.title" text="**Clientes" arguments="'+clientesStore.getTotalCount()+'"/>');
		unmaskAll();
	});

	grid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_cliente=rec.get('apellidoNombre');
    	app.abreCliente(rec.get('id'), nombre_cliente);
    });
    
    var compuesto = new Ext.Panel({
	    items : [
              {
				bodyStyle:'padding:5px;cellspacing:10px'
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items : [panelFiltros, grid]
			  }
    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
    
	page.add(compuesto);  
	
	Ext.onReady(function(){
		clientesStore.webflow();
	}); 

</fwk:page>
