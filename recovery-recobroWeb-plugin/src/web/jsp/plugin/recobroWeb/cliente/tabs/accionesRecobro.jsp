<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var panel = new Ext.Panel({
        title:'<s:message code="cliente.consulta.tabAccionesRecobro.titulo" text="**Recobro"/>'
        ,height:445
        ,bodyStyle:'padding:10px'   
        ,items:[]
        ,autoHeight:true
        ,nombreTab : 'accionesRecobroTab'
    });
   
    var ciclosRecobroRT = Ext.data.Record.create([
		'id'
		,'idPersona'
		,{name : "fechaAlta"}
		,'agencia'
		,'cartera'
		,'posVivaVencida'
		,'posVivaNoVencida'
		,{name : "fechaBaja"}
		,'motivoBaja'				
	]);
	
	var ciclosRecobroCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.idCiclo" text="**Id ciclo"/>', dataIndex : 'id'}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.fechaCesion" text="**Fecha cesión"/>', dataIndex : 'fechaAlta'}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.agencia" text="**Agencia"/>', dataIndex : 'agencia'}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.cartera" text="**Cartera"/>', dataIndex : 'cartera'}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.RDCedido" text="**RDCedido"/>', dataIndex : 'posVivaVencida',renderer: app.format.moneyRenderer}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.RICedido" text="**RICedido"/>', dataIndex : 'posVivaNoVencida',renderer: app.format.moneyRenderer}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.fechaFin" text="**fechaFin"/>', dataIndex : 'fechaBaja'}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.motivoFin" text="**motivoFin"/>', dataIndex : 'motivoBaja'}
	]);
	
	<pfs:remoteStore name="dataStore" 
		resultRootVar="ciclosRecPer" 
		resultTotalVar="total" 
		recordType="ciclosRecobroRT" 
		dataFlow="ciclorecobroexpediente/getCicloRecPer" />
	
	var pagingBarCiclosRec=fwk.ux.getPaging(dataStore);
    
	var cfg={
		title : '<s:message code="plugin.recobroWeb.cliente.tab.gridCiclosRecobro.title" text="**Ciclos de recobro" />'
		,id: 'ciclosRecobroGridAccionesRecobroPersona'	
		,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:240
		,bbar : [  pagingBarCiclosRec ]
	};
	var ciclosRecobroGrid=app.crearGrid(dataStore,ciclosRecobroCM,cfg);
	
	ciclosRecobroGrid.on('rowclick', function(grid, rowIndex, e){
        var rec = grid.getStore().getAt(rowIndex);
      	var id = rec.get('id');
      	var idPersona= rec.get('idPersona');
        accionesRecobroStore.webflow({idCicloRecobroPer:id});
    });
	//FIN CICLOS RECOBRO CONTRATO   

	//ACCIONES EXTRAJUDICIALES
    var accionesRecobroRT = Ext.data.Record.create([      
         {name:'id'}
        ,{name : "fechaExtraccion"}
		,{name:'idAccion'}
		,{name:'idEnvio'}
		,{name:'apellidoNombre'}
		,{name:'contrato'}
		,{name:'agencia'}
		,{name:"fechaGestion"}
		,{name:'tipoGestion'}
		,{name:'resultadoGestionTelefonica'}
		,{name:'observacionesGestor'}	
		,{name:'importeComprometido'}
		,{name:"fechaPagoComprometido"}
		,{name:'importePropuesto'}
		,{name:'importeAceptado'}
    ]);

	var accionesRecobroStore = page.getStore({
            flow:'accionesextrajudiciales/getAccionesCicloRecobroPersona'
            ,storeId: 'accionesRecobroStoreId'
            ,reader: new Ext.data.JsonReader({
                root: 'accionesExjud'
            }, accionesRecobroRT)
        });
    
   var pagingBarAccionesRec=fwk.ux.getPaging(accionesRecobroStore);
    
	var cfgAcciones={
		title : '<s:message code="plugin.recobroWeb.cliente.tab.gridAccionesRecobro.title" text="**Acciones Extrajudiciales" />'
		,id: 'accionesRecobroGridAccionesRecobroPersona'	
		,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:240
		,bbar : [  pagingBarAccionesRec ]
	};
	
   var accionesRecobroCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabRecobro.gridAcciones.id" text="**Id" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="contrato.tabRecobro.gridAcciones.apellidoNombre" text="**apellidoNombre" />', sortable: false, dataIndex: 'apellidoNombre'},
      	{header:'<s:message code="contrato.tabRecobro.gridAcciones.contrato" text="**contrato" />', sortable: false, dataIndex: 'contrato'},	
        {header:'<s:message code="contrato.tabRecobro.gridAcciones.fechaGestion" text="**fechaGestion" />', sortable: false, dataIndex: 'fechaGestion'},
    	{header:'<s:message code="contrato.tabRecobro.gridAcciones.tipoGestion" text="**tipoGestion" />', sortable: false, dataIndex: 'tipoGestion'},
    	{header:'<s:message code="contrato.tabRecobro.gridAcciones.resultadoGestionTelefonica" text="**resultadoGestionTelefonica" />', sortable: false, dataIndex: 'resultadoGestionTelefonica'},
    	{header:'<s:message code="contrato.tabRecobro.gridAcciones.importeComprometido" text="**importeComprometido" />', sortable: false, dataIndex: 'importeComprometido',renderer: app.format.moneyRenderer},
    	{header:'<s:message code="contrato.tabRecobro.gridAcciones.fechaPagoComprometido" text="**fechaPagoComprometido" />', sortable: false, dataIndex: 'fechaPagoComprometido'}
    ]);
    
    var accionesRecobroGrid=app.crearGrid(accionesRecobroStore,accionesRecobroCM,cfgAcciones); 
 
	
    panel.add(ciclosRecobroGrid);
    panel.add(accionesRecobroGrid);
    
    panel.getValue = function(){};
    
  	panel.setValue = function(){
    	var data = entidad.get("data");
    	var idPersona = data.id;
    	entidad.cacheOrLoad(data, dataStore, {idPersona : idPersona});
    	accionesRecobroStore.removeAll();
  	};
	

	return panel;
})	