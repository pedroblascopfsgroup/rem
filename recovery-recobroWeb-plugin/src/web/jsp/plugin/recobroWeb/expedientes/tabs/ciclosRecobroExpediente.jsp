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
        title:'<s:message code="expendiente.tabCiclosRecobro.titulo" text="**Ciclos Recobro"/>'
        ,bodyStyle:'padding:10px'   
        ,autoHeight:true
    ,nombreTab : 'tabCiclosRecobroExpediente'
    });
    
    var CicloRecExp = Ext.data.Record.create([      
         {name:'id'}
        ,{name:'idExpediente'}
        ,{name:'fechaAlta'}
        ,{name:'fechaBaja'}
        ,{name:'posVivaNoVencida'}
        ,{name:'posVivaVencida'}
        ,{name:'interesesOrdDeven'}
        ,{name:'interesesMorDeven'}
        ,{name:'comisiones'}
        ,{name:'gastos'}
        ,{name:'impuestos'}  
    	,{name:'esquema'}
    	,{name:'cartera'}
		,{name:'subcartera'}
		,{name:'modeloFacturacion'}
		,{name:'agencia'}
		,{name:'motivoBaja'}
    ]);

   var cicloRecExpStore = page.getStore({
            flow:'ciclorecobroexpediente/getCicloRecExp'
            ,storeId: 'cicloRecExpStore'
            ,reader: new Ext.data.JsonReader({
                root: 'ciclosRecExp'
            }, CicloRecExp)
        });
    
 
   var cicloRecExpCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="expendiente.tabCiclosRecobro.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.codExpediente" text="**Cód. Expediente" />',dataIndex:'idExpediente',width:120,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.fechaAlta" text="**F.Cesión" />',dataIndex:'fechaAlta',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.agencia" text="**Agencia" />',dataIndex:'agencia',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.cartera" text="**Cartera" />',dataIndex:'cartera',width:120},        
        
        {header:'<s:message code="expendiente.tabCiclosRecobro.posVivaNoVencida" text="**R.D. Cedido" />',dataIndex:'posVivaNoVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.posVivaVencida" text="**R.I Cedido" />',dataIndex:'posVivaVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.interesesOrdDeven" text="**Int. Ord. Deven." />',dataIndex:'interesesOrdDeven',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.interesesMorDeven" text="**Int. Mor. Deven." />',dataIndex:'interesesMorDeven',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.comisiones" text="**Comisiones" />',dataIndex:'comisiones',width:120,renderer:app.format.moneyRenderer,align:'right'},  
        {header:'<s:message code="expendiente.tabCiclosRecobro.gastos" text="**Gastos" />',dataIndex:'gastos',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.impuestos" text="**Impuestos" />',dataIndex:'impuestos',width:120,renderer:app.format.moneyRenderer,align:'right'},

        {header:'<s:message code="expendiente.tabCiclosRecobro.fechaBaja" text="**F.Fin" />',dataIndex:'fechaBaja',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.motivoBaja" text="**Motivo Fin" />',dataIndex:'motivoBaja',width:120},
        
        {header:'<s:message code="expendiente.tabCiclosRecobro.esquema" text="**Esquema" />',dataIndex:'esquema',width:120,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.subcartera" text="**Subcartera" />',dataIndex:'subcartera',width:120,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.modeloFacturacion" text="**Modelo Facturación" />',dataIndex:'modeloFacturacion',width:120,hidden:true}
        
    ]);
 	
 	var pagingBarCicloRecExp=fwk.ux.getPaging(cicloRecExpStore);
    
    var cicloRecExpGrid= app.crearGrid(cicloRecExpStore,cicloRecExpCM,{
        title:'<s:message code="expendiente.tabCiclosRecobro.cicloRecExp" text="**Ciclos de Recobro del Expediente"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:210
        ,bbar : [  pagingBarCicloRecExp ]
    });
	
	var refrescaGrids = function(rec) {
		var id = rec.get('id');
        ciclosRecCntStore.webflow({idCicloRecobroExp:id});
        ciclosRecPerStore.webflow({idCicloRecobroExp:id});
	};

   cicloRecExpGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
        var rec = cicloRecExpGrid.getStore().getAt(rowIndex);
      	refrescaGrids(rec);
    }); 

	//Si ya esta seleccionada la row que entre por el rowclick    
    cicloRecExpGrid.on('rowclick', function(grid, rowIndex, e){
    	var rec = grid.getStore().getAt(rowIndex);
    	refrescaGrids(rec);
    });
    
//FIN CICLO RECOBRO EXPEDIENTE   
    
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
        {header:'<s:message code="expendiente.tabCiclosRecobro.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.idEnvio" text="**Id. Envio" />', sortable: false, dataIndex: 'idEnvio',fixed:true,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.idContrato" text="**Id. Contrato" />',dataIndex:'idContrato',width:120,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.idCicloRecobroExpediente" text="**Id. ciclo Rec. Exp." />',dataIndex:'fechaDato',width:120, hidden:true},
        
        {header:'<s:message code="expendiente.tabCiclosRecobro.fechaAlta" text="**F.Cesión" />',dataIndex:'fechaAlta',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.codContrato" text="**Cód. Contrato" />',dataIndex:'codContrato',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.posVivaNoVencida" text="**R.D. Cedido" />',dataIndex:'posVivaNoVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.posVivaVencida" text="**R.I. Cedido" />',dataIndex:'posVivaVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.interesesOrdDeven" text="**Int. Ord. Deven." />',dataIndex:'interesesOrdDeven',width:120,renderer:app.format.moneyRenderer,align:'right'},        
        {header:'<s:message code="expendiente.tabCiclosRecobro.interesesMorDeven" text="**Int. Mor. Deven." />',dataIndex:'interesesMorDeven',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.comisiones" text="**Comisiones" />',dataIndex:'comisiones',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.gastos" text="**Gastos" />',dataIndex:'gastos',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.impuestos" text="**Impuestos" />',dataIndex:'impuestos',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.fechaBaja" text="**F.Fin" />',dataIndex:'fechaBaja',width:120},        
        {header:'<s:message code="expendiente.tabCiclosRecobro.motivoBaja" text="**Motivo Fin" />',dataIndex:'motivoBaja',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.exceptuacion" text="**Exceptuación" />',dataIndex:'exceptuacion',width:120,hidden:true}
        
    ]);
 	
 	var pagingBarCiclosRecCnt=fwk.ux.getPaging(ciclosRecCntStore);
    
    var ciclosRecCntGrid= app.crearGrid(ciclosRecCntStore,ciclosRecCntCM,{
        title:'<s:message code="expendiente.tabCiclosRecobro.cicloRecCnt" text="**Contrato"/>'
        ,id : 'ciclosRecCntGrid'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:310
        ,bbar : [  pagingBarCiclosRecCnt ]
    });


//FIN CICLOS RECOBRO CONTRATO   

//CICLOS RECOBRO PERSONA
    var CicloRecPer = Ext.data.Record.create([      
         {name:'id'}
		,{name:'idPersona'}
		,{name:'apellidoNombre'}
		,{name:'docPersona'}
		,{name:'idCicloRecobroExpediente'}
		,{name:'motivoBaja'}
		,{name:'exceptuacion'}
		,{name:'fechaAlta'}	
		,{name:'fechaBaja'}
		,{name:'posVivaNoVencida'}
		,{name:'posVivaVencida'}
    ]);
	
   var ciclosRecPerStore = page.getStore({
       flow:'ciclorecobroexpediente/getCicloRecPer'
       ,storeId: 'ciclosRecPerStoreId'
       ,reader: new Ext.data.JsonReader({
           root: 'ciclosRecPer'
       }, CicloRecPer)
   });
    
 
   var ciclosRecPerCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="expendiente.tabCiclosRecobro.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.idPersona" text="**Id. Persona" />',dataIndex:'idPersona',width:120,hidden:true},
        {header:'<s:message code="expendiente.tabCiclosRecobro.idCicloRecobroExpediente" text="**Id. Ciclo Rec. Exp." />',dataIndex:'idCicloRecobroExpediente',width:120,hidden:true},
        
        {header:'<s:message code="expendiente.tabCiclosRecobro.fechaAlta" text="**F.Cesión" />',dataIndex:'fechaAlta',width:120},        
        {header:'<s:message code="expendiente.tabCiclosRecobro.cliente" text="**Nombre Completo" />',dataIndex:'apellidoNombre',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.dniCif" text="**DNI / CIF" />',dataIndex:'docPersona',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobroPersona.posVivaNoVencida" text="**R.D Cedido" />',dataIndex:'posVivaNoVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},        
        {header:'<s:message code="expendiente.tabCiclosRecobroPersona.posVivaVencida" text="**R.I Cedido" />',dataIndex:'posVivaVencida',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="expendiente.tabCiclosRecobro.fechaBaja" text="**F.Fin" />',dataIndex:'fechaBaja',width:120},
        {header:'<s:message code="expendiente.tabCiclosRecobro.motivoBaja" text="**Motivo Fin" />',dataIndex:'motivoBaja',width:120},        

        {header:'<s:message code="expendiente.tabCiclosRecobro.exceptuacion" text="**Exceptuación" />',dataIndex:'exceptuacion',width:120,hidden:true}
        
    ]);
 	
 	var pagingBarCiclosRecPer=fwk.ux.getPaging(ciclosRecPerStore);
    
    var ciclosRecPerGrid = app.crearGrid(ciclosRecPerStore,ciclosRecPerCM,{
        title:'<s:message code="expendiente.tabCiclosRecobro.ciclosRecPer" text="**Clientes"/>'
        ,id : 'ciclosRecPerGrid'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:310
        ,bbar : [  pagingBarCiclosRecPer ]
    });


//FIN CICLO RECOBRO PERSONA     

  panel.add(cicloRecExpGrid);
  
  var cicloTabPanel = new Ext.TabPanel({
	items:[
		ciclosRecCntGrid, ciclosRecPerGrid
	]
	,height : 310
	,border: true
  });
  cicloTabPanel.setActiveTab(ciclosRecCntGrid);
	  
  panel.add(cicloTabPanel);

  panel.getValue = function(){
  }
	
  panel.setValue = function(){
    var data = entidad.get("data");
    var idExpediente = data.id;
    entidad.cacheOrLoad(data, cicloRecExpStore, {idExpediente : idExpediente});
    ciclosRecCntStore.webflow({idCicloRecobroExp:0});
    ciclosRecPerStore.webflow({idCicloRecobroExp:0});
  }
  
  panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente == 'REC';
  }
    
  return panel;
})
