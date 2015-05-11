<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
   
    var panel = new Ext.Panel({
        title:'<s:message code="contrato.tabCiclosRecobro.titulo" text="**Ciclos Recobro"/>'
        ,bodyStyle:'padding:10px'   
        ,autoHeight:true
    ,nombreTab : 'tabCiclosRecobroExpediente'
    });
    
//CICLO RECOBRO CONTRATO
    var CicloRecCnt = Ext.data.Record.create([      
         {name:'id'}
		,{name:'idEnvio'}
		,{name:'idContrato'}
		,{name:'codContrato'}
		,{name:'idCicloRecobroExpediente'}	
		,{name:'motivoBaja'}	
		,{name:'exceptuacion'}
		,{name:'fechaAlta'}
		,{name:'fechaBaja'}
		,{name:'posVivaNoVencida'}
		,{name:'posVivaVencida'}
		,{name:'interesesOrdDeven'}
		,{name:'interesesMorDeven'}
		,{name:'comisiones'}
		,{name:'gastos'}
		,{name:'impuestos'}
    ]);

   var ciclosRecCntStore = page.getStore({
            flow:'ciclorecobroexpediente/getCicloRecCnt'
            ,storeId: 'ciclosRecCntStoreId'
            ,reader: new Ext.data.JsonReader({
                root: 'ciclosRecCnt'
            }, CicloRecCnt)
        });
    
 
   var ciclosRecCntCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabCiclosRecobro.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="contrato.tabCiclosRecobro.idEnvio" text="**Id. Envio" />', sortable: false, dataIndex: 'idEnvio',fixed:true,hidden:true},
        {header:'<s:message code="contrato.tabCiclosRecobro.idContrato" text="**Id. Contrato" />',dataIndex:'idContrato',width:120,hidden:true},
        {header:'<s:message code="contrato.tabCiclosRecobro.idCicloRecobroExpediente" text="**Id. ciclo Rec. Exp." />',dataIndex:'fechaDato',width:120, hidden:true},
        
        {header:'<s:message code="contrato.tabCiclosRecobro.fechaAlta" text="**F.Cesión" />',dataIndex:'fechaAlta',width:120},
        {header:'<s:message code="contrato.tabCiclosRecobro.codContrato" text="**Cód. Contrato" />',dataIndex:'codContrato',width:120},
        {header:'<s:message code="contrato.tabCiclosRecobro.posVivaNoVencida" text="**R.D. Cedido" />',dataIndex:'posVivaNoVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabCiclosRecobro.posVivaVencida" text="**R.I. Cedido" />',dataIndex:'posVivaVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabCiclosRecobro.interesesOrdDeven" text="**Int. Ord. Deven." />',dataIndex:'interesesOrdDeven',width:120,renderer:app.format.moneyRenderer,align:'right'},        
        {header:'<s:message code="contrato.tabCiclosRecobro.interesesMorDeven" text="**Int. Mor. Deven." />',dataIndex:'interesesMorDeven',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabCiclosRecobro.comisiones" text="**Comisiones" />',dataIndex:'comisiones',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabCiclosRecobro.gastos" text="**Gastos" />',dataIndex:'gastos',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabCiclosRecobro.impuestos" text="**Impuestos" />',dataIndex:'impuestos',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabCiclosRecobro.fechaBaja" text="**F.Fin" />',dataIndex:'fechaBaja',width:120},        
        {header:'<s:message code="contrato.tabCiclosRecobro.motivoBaja" text="**Motivo Fin" />',dataIndex:'motivoBaja',width:120},
        {header:'<s:message code="contrato.tabCiclosRecobro.exceptuacion" text="**Exceptuación" />',dataIndex:'exceptuacion',width:120,hidden:true}
        
    ]);
 	
 	var pagingBarCiclosRecCnt=fwk.ux.getPaging(ciclosRecCntStore);
    
    var ciclosRecCntGrid= app.crearGrid(ciclosRecCntStore,ciclosRecCntCM,{
        title:'<s:message code="contrato.tabCiclosRecobro.cicloRecCnts" text="**Contratos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:240
        ,bbar : [  pagingBarCiclosRecCnt ]
    });

 	ciclosRecCntGrid.on('rowclick', function(grid, rowIndex, e){
        var rec = grid.getStore().getAt(rowIndex);
      	var id = rec.get('id');
        accionesRecobroStore.webflow({idCicloRecobroCnt:id});
    });
//FIN CICLOS RECOBRO CONTRATO   

//ACCIONES EXTRA JUDICIALES
    var accionesRecobroRT = Ext.data.Record.create([      
         {name:'id'}
        ,{name : "fechaExtraccion"}
		,{name:'idAccion'}
		,{name:'idEnvio'}
		,{name:'apellidoNombre'}
		,{name:'contrato'}
		,{name:'agencia'}
		,{name : "fechaGestion"}
		,{name:'tipoGestion'}
		,{name:'resultadoGestionTelefonica'}
		,{name:'observacionesGestor'}	
		,{name:'importeComprometido'}
		,{name:"fechaPagoComprometido"}
		,{name:'importePropuesto'}
		,{name:'importeAceptado'}
    ]);
	
	var accionesRecobroStore = page.getStore({
            flow:'accionesextrajudiciales/getAccionesCicloRecobroContrato'
            ,storeId: 'accionesRecobroStoreId'
            ,reader: new Ext.data.JsonReader({
                root: 'accionesExjud'
            }, accionesRecobroRT)
        });
        
   var pagingBarAccionesRec=fwk.ux.getPaging(accionesRecobroStore);

	var cfgAcciones={
		title : '<s:message code="plugin.recobroWeb.cliente.tab.gridAccionesRecobro.title" text="**Acciones Extrajudiciales" />'
		,id: 'accionesRecobroGridAccionesRecobroContrato'
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


//FIN ACCIONES EXTRAJUDICIALES     

  panel.add(ciclosRecCntGrid);
  panel.add(accionesRecobroGrid);

  panel.getValue = function(){
  }

	panel.getIdContrato = function(){
		return entidad.get("data").id;
	}
	  
  panel.setValue = function(){
    entidad.cacheOrLoad(data, ciclosRecCntStore, {idContrato : panel.getIdContrato()});
    accionesRecobroStore.removeAll();
  }

  return panel;
})
