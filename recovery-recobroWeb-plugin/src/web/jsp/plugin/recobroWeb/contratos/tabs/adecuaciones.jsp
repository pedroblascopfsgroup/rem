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


	var idContrato;
    var limit = 1000;
   
    var panel = new Ext.Panel({
        title:'<s:message code="contrato.tabAdecuaciones.titulo" text="**Adecuaciones"/>'
        ,bodyStyle:'padding:10px'   
        ,autoHeight:true
    ,nombreTab : 'tabAdecuaciones'
    });
    
//Adecuaciones
    var adecuacionesRecord = Ext.data.Record.create([      
         	{name:'id'}
			,{name:'contrato'}
			,{name:'fechaExtraccion'}
			,{name:'codigoRecomendacion'}			
			,{name:'importeFinanciar'}
			,{name:'gastosIncluidos'}
			,{name:'tipo'}
			,{name:'diferencial'}
			,{name:'plazo'}
			,{name:'cuota'}
			,{name:'cuotaTrasCarencia'}
			,{name:'sistemaAmortizacion'}
			,{name:'razonProgresion'}
			,{name:'periodicidadRecibos'}
			,{name:'periodicidadTipo'}
			,{name:'proximaRevision'}
			,{name:'revisionCuota'}
			,{name:'fechaDato'}
    ]);
    		
    
    		

   var adecuacionesStore = page.getStore({
            flow:'accionesextrajudiciales/getAdecuaciones'
            ,storeId: 'adecuacionesStore'
            ,limit: limit
            ,reader: new Ext.data.JsonReader({
                root: 'adecuaciones'
            }, adecuacionesRecord)
        });
    
   var revisionCuotaRenderer = function(value) {  
   		var valueRendered = parseInt(value)/100;   		
   		return Ext.isEmpty(valueRendered) ? "" : valueRendered.toFixed(3).replace(".", app.format.DECIMAL_SEPARATOR);
   }; 
   
   var tipoRenderer = function(value) {
   		var valueRendered = value;
   		
   		return Ext.isEmpty(valueRendered) ? "0,000" : valueRendered.toFixed(3).replace(".", ",");
   }; 
   
   var razonProgresionRenderer = function(value) {
   		var valueRendered = parseInt(value)/100;
   		return Ext.isEmpty(valueRendered) ? "" : valueRendered.toFixed(3).replace(".", app.format.DECIMAL_SEPARATOR);
   };
   
   var cuotaRenderer = function(value) {
   		var valueRendered = value;
   		return Ext.isEmpty(valueRendered) ? "0,00" : valueRendered.toFixed(2).replace(".", ",");
   }; 
 
   var adecuacionesCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabAdecuaciones.id" text="**id" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="contrato.tabAdecuaciones.contrato" text="**Contrato" />', sortable: false, dataIndex: 'contrato'},
        {header:'<s:message code="contrato.tabAdecuaciones.fechaExtraccion" text="**fechaExtraccion" />',dataIndex:'fechaExtraccion',width:120,hidden:true},
        {header:'<s:message code="contrato.tabAdecuaciones.codigoRecomendacion" text="**codigoRecomendacion" />',dataIndex:'codigoRecomendacion',width:120},     
        {header:'<s:message code="contrato.tabAdecuaciones.importeFinanciar" text="**importeFinanciar" />',dataIndex:'importeFinanciar',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabAdecuaciones.gastosIncluidos" text="**gastosIncluidos" />',dataIndex:'gastosIncluidos',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabAdecuaciones.tipo" text="**tipo" />',dataIndex:'tipo',width:120, renderer:tipoRenderer},
        {header:'<s:message code="contrato.tabAdecuaciones.diferencial" text="diferencial" />',dataIndex:'diferencial',width:120,hidden:true, renderer:tipoRenderer},
        {header:'<s:message code="contrato.tabAdecuaciones.plazo" text="**plazo" />',dataIndex:'plazo',width:120,hidden:true},        
        {header:'<s:message code="contrato.tabAdecuaciones.cuota" text="**cuota actual" />',dataIndex:'cuota',width:120,hidden:true, renderer:app.format.moneyRenderer},
        {header:'<s:message code="contrato.tabAdecuaciones.cuotaTrasCarencia" text="**cuotaTrasCarencia" />',dataIndex:'cuotaTrasCarencia',width:120,hidden:true, renderer:app.format.moneyRenderer},
        {header:'<s:message code="contrato.tabAdecuaciones.sistemaAmortizacion" text="**sistemaAmortizacion" />',dataIndex:'sistemaAmortizacion',width:120,hidden:true},
        {header:'<s:message code="contrato.tabAdecuaciones.razonProgresion" text="**razonProgresion" />',dataIndex:'razonProgresion', renderer: razonProgresionRenderer, width:120,hidden:true},
        {header:'<s:message code="contrato.tabAdecuaciones.periodicidadRecibos" text="**periodicidadRecibos" />',dataIndex:'periodicidadRecibos',width:120,hidden:true},
        {header:'<s:message code="contrato.tabAdecuaciones.periodicidadTipo" text="**periodicidadTipo" />',dataIndex:'periodicidadTipo',width:120,hidden:true},        
        {header:'<s:message code="contrato.tabAdecuaciones.proximaRevision" text="**proximaRevision" />',dataIndex:'proximaRevision',width:120,hidden:true},
        {header:'<s:message code="contrato.tabAdecuaciones.revisionCuota" text="**reduccionCuota" />',dataIndex:'revisionCuota', renderer: revisionCuotaRenderer, width:120,hidden:true},
        {header:'<s:message code="contrato.tabAdecuaciones.fechaDato" text="**fechaDato" />',dataIndex:'fechaDato',width:120,hidden:false}
        
    ]);
    

 	var adecuacionesPagingBar=fwk.ux.getPaging(adecuacionesStore);
    
    var adecuacionesGrid= app.crearGrid(adecuacionesStore,adecuacionesCM,{
        title:'<s:message code="contrato.tabAdecuaciones.adecuaciones" text="**Adecuaciones"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:240
        ,bbar : [  adecuacionesPagingBar ]
    });

 	adecuacionesGrid.on('rowclick', function(grid, rowIndex, e){
        var rec = grid.getStore().getAt(rowIndex);
      	var id = rec.get('id');
        //adecuacionesStore.webflow({idAdecuacion:id});
    });
//FIN ADECUACIONES

    

  panel.add(adecuacionesGrid);

  panel.getValue = function(){
  }

	panel.getIdContrato = function(){
		return entidad.get("data").id;
	}
	  
  panel.setValue = function(){
    entidad.cacheOrLoad(data, adecuacionesStore, {idContrato : panel.getIdContrato()});
    adecuacionesStore.removeAll();
  }

  return panel;
})
