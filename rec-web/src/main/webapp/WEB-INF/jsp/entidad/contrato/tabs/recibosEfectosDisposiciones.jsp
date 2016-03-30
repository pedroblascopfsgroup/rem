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
   
   var limit = 50;
   
    var panel = new Ext.Panel({
        title:'<s:message code="contrato.tabRecEfecDis.titulo" text="**Recibos/Disposiciones/Efectos"/>'
        ,bodyStyle:'padding:10px'   
        ,autoHeight:true
    ,nombreTab : 'tabRecibosDisposicionesEfectos'
    });
    
    var Recibo = Ext.data.Record.create([      
         {name:'id'}
        ,{name:'idContrato'}
        ,{name:'codigoEntidad'}
        ,{name:'codigoRecibo'}
        ,{name:'fechaVencimiento'}
        ,{name:'fechaFacturacion'}
        ,{name:'ccDomiciliacion'}
        ,{name:'DDtipoRecibo'}
        ,{name:'tipoInteres'}
        ,{name:'importeRecibo'}
        ,{name:'importeImpagado'}  
    	,{name:'capital'}  
    	,{name:'interesesOrdinarios'}  
    	,{name:'interesesMoratorios'}
    	,{name:'comisiones'}
		,{name:'gastosNoCobrados'}
		,{name:'impuestos'}
		,{name:'DDsituacionRecibo'}
		,{name:'DDmotivoDevolucion'}
		,{name:'DDmotivoRechazo'}
		,{name:'fechaExtraccion'}
		,{name:'fechaDato'}
		,{name:'charExtra1'}
		,{name:'charExtra2'}
		,{name:'flagExtra1'}
		,{name:'flagExtra2'}
		,{name:'dateExtra1'}
		,{name:'dateExtra2'}
		,{name:'floatExtra1'}
		,{name:'floatExtra2'}
    ]);

   var recibosStore = page.getStore({
            flow:'contrato/getRecibos'
            ,storeId: 'recibosContratoStore'
            ,reader: new Ext.data.JsonReader({
                root: 'recibos'
            }, Recibo)
        });
    
 
   var recibosCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabRecEfecDis.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.codContrato" text="**Cód. Contrato" />',dataIndex:'idContrato',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.codEntidad" text="**Cód. Entidad" />',dataIndex:'codigoEntidad',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.fechaDato" text="**F.Dato" />',dataIndex:'fechaDato',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.codRecibo" text="**Cód. Recibo" />',dataIndex:'codigoRecibo',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.fVencimiento" text="**F.Vencimiento" />',dataIndex:'fechaVencimiento',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.fFacturacion" text="**F.Facturación" />',dataIndex:'fechaFacturacion',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.tipoRecibo" text="**Tipo Recibo" />',dataIndex:'DDtipoRecibo',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.tipoInteres" text="**Tipo Interés" />',dataIndex:'tipoInteres',width:120,renderer:app.format.moneyRenderer,align:'right'},  
        {header:'<s:message code="contrato.tabRecEfecDis.importeRecibo" text="**importe" />',dataIndex:'importeRecibo',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabRecEfecDis.importeImpagado" text="**importe Impagado" />',dataIndex:'importeImpagado',width:120,renderer:app.format.moneyRenderer,align:'right'},
		{header:'<s:message code="contrato.tabRecEfecDis.capital" text="**Capital" />',dataIndex:'capital',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabRecEfecDis.situacionRecibo" text="**Situación Recibo" />',dataIndex:'DDsituacionRecibo',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.motivoDevolucion" text="**Motivo Devolucion" />',dataIndex:'DDmotivoDevolucion',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.motivoRechazo" text="**Motivo Rechazo" />',dataIndex:'DDmotivoRechazo',width:120},
        
        {header:'<s:message code="contrato.tabRecEfecDis.ccDomiciliacion" text="**CC. Domiciliación" />',dataIndex:'ccDomiciliacion',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.intOrdinarios" text="**Int. Ordinarios" />',dataIndex:'interesesOrdinarios',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.intMoratorios" text="**Int. Moratorios" />',dataIndex:'interesesMoratorios',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.comisiones" text="**Comisiones" />',dataIndex:'comisiones',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.gastosNoCobrados" text="**Gastos no Cobrados" />',dataIndex:'gastosNoCobrados',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.impuestos" text="**Impuestos" />',dataIndex:'impuestos',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.fechaExtraccion" text="**F.Extracción" />',dataIndex:'fechaExtraccion',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.charExtra1" text="**Char. Extra1" />',dataIndex:'charExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.charExtra2" text="**Char. Extra2" />',dataIndex:'charExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.flagExtra1" text="**Flag Extra1" />',dataIndex:'flagExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.flagExtra2" text="**Flag Extra2" />',dataIndex:'flagExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.dateExtra1" text="**F.Extra1" />',dataIndex:'dateExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.dateExtra2" text="**F.Extra2" />',dataIndex:'dateExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.numExtra1" text="**Num.Extra1" />',dataIndex:'floatExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.numExtra2" text="**Num.Extra2" />',dataIndex:'floatExtra2',width:120,hidden:true}
    ]);
 	
 	var pagingBar=fwk.ux.getPaging(recibosStore);
    
    var recibosGrid= app.crearGrid(recibosStore,recibosCM,{
        title:'<s:message code="contrato.tabRecEfecDis.recibo" text="**Recibos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:210
        ,bbar : [  pagingBar ]
    });

    
//FIN RECIBOS   
    
//DISPOSICIONES
    var Disposicion = Ext.data.Record.create([      
         {name:'id'}
		,{name:'idContrato'}
		,{name:'codigoEntidad'}
		,{name:'codigoDisposicion'}
		,{name:'DDtipoDisposicion'}	
		,{name:'DDsubTipoDisposicion'}	
		,{name:'DDsituacionDisposicion'}
		,{name:'DDmoneda'}
		,{name:'importe'}
		,{name:'capital'}
		,{name:'interesesOrdinarios'}
		,{name:'interesesMoratorios'}
		,{name:'comisiones'}
		,{name:'gastosNoCobrados'}
		,{name:'impuestos'}
		,{name:'fechaVencimiento'}
		,{name:'fechaExtraccion'}
		,{name:'fechaDato'}
		,{name:'charExtra1'}
		,{name:'charExtra2'}
		,{name:'flagExtra1'}
		,{name:'flagExtra2'}
		,{name:'dateExtra1'}
		,{name:'dateExtra2'}
		,{name:'numExtra1'}
		,{name:'numExtra2'}
    ]);

   var disposicionesStore = page.getStore({
            flow:'contrato/getDisposiciones'
            ,storeId: 'disposicionesContratoStore'
            ,reader: new Ext.data.JsonReader({
                root: 'disposiciones'
            }, Disposicion)
        });
    
 
   var disposicionesCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabRecEfecDis.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.codContrato" text="**Cód. Contrato" />',dataIndex:'idContrato',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.codEntidad" text="**Cód. Entidad" />',dataIndex:'codigoEntidad',width:120,hidden:true},
        
        {header:'<s:message code="contrato.tabRecEfecDis.fechaDato" text="**F.Dato" />',dataIndex:'fechaDato',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.codDisposicion" text="**Cód. Disposicion" />',dataIndex:'codigoDisposicion',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.tipoDisposicion" text="**Tipo Disposicion" />',dataIndex:'DDtipoDisposicion',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.subTipoDisposicion" text="**Subtipo Disposicion" />',dataIndex:'DDsubTipoDisposicion',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.situacionDisposicion" text="**Situación Disposicion" />',dataIndex:'DDsituacionDisposicion',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.moneda" text="**Moneda" />',dataIndex:'DDmoneda',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.importe" text="**importe" />',dataIndex:'importe',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabRecEfecDis.capital" text="**Capital" />',dataIndex:'capital',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabRecEfecDis.fVencimiento" text="**F.Vencimiento" />',dataIndex:'fechaVencimiento',width:120},
        
        {header:'<s:message code="contrato.tabRecEfecDis.intOrdinarios" text="**Int. Ordinarios" />',dataIndex:'interesesOrdinarios',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.intMoratorios" text="**Int. Moratorios" />',dataIndex:'interesesMoratorios',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.comisiones" text="**Comisiones" />',dataIndex:'comisiones',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.gastosNoCobrados" text="**Gastos no Cobrados" />',dataIndex:'gastosNoCobrados',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.impuestos" text="**Impuestos" />',dataIndex:'impuestos',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.fechaExtraccion" text="**F.Extracción" />',dataIndex:'fechaExtraccion',width:120,hidden:true},

        {header:'<s:message code="contrato.tabRecEfecDis.charExtra1" text="**Char. Extra1" />',dataIndex:'charExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.charExtra2" text="**Char. Extra2" />',dataIndex:'charExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.flagExtra1" text="**Flag Extra1" />',dataIndex:'flagExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.flagExtra2" text="**Flag Extra2" />',dataIndex:'flagExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.dateExtra1" text="**F.Extra1" />',dataIndex:'dateExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.dateExtra2" text="**F.Extra2" />',dataIndex:'dateExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.numExtra1" text="**Num.Extra1" />',dataIndex:'numExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.numExtra2" text="**Num.Extra2" />',dataIndex:'numExtra2',width:120,hidden:true}
    ]);
 	
 	var pagingBarDisp=fwk.ux.getPaging(disposicionesStore);
    
    var disposicionesGrid= app.crearGrid(disposicionesStore,disposicionesCM,{
        title:'<s:message code="contrato.tabRecEfecDis.disposicion" text="**Disposiciones"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:210
        ,bbar : [  pagingBarDisp ]
    });

//FIN DISPOSICIONES   

//EFECTOS
    var Efecto = Ext.data.Record.create([      
         {name:'id'}
		,{name:'idContrato'}
		,{name:'codigoEntidad'}
		,{name:'codigoEfecto'}
		,{name:'codigoLinea'}
		,{name:'codigoAcuerdo'}
		,{name:'DDtipoEfecto'}	
		,{name:'DDsituacionEfecto'}
		,{name:'DDmoneda'}
		,{name:'importe'}
		,{name:'capital'}
		,{name:'interesesOrdinarios'}
		,{name:'interesesMoratorios'}
		,{name:'comisiones'}
		,{name:'gastos'}
		,{name:'impuestos'}
		,{name:'fechaDescuento'}
		,{name:'DDtipoFechaVencimiento'}
		,{name:'fechaVencimiento'}
		,{name:'fechaExtraccion'}
		,{name:'fechaDato'}
		,{name:'charExtra1'}
		,{name:'charExtra2'}
		,{name:'flagExtra1'}
		,{name:'flagExtra2'}
		,{name:'dateExtra1'}
		,{name:'dateExtra2'}
		,{name:'numExtra1'}
		,{name:'numExtra2'}
		,{name:'titulares'}
		,{name:'orden'}
		,{name:'tipoIntervencionEfecto'}
    ]);
	
   var efectosStore = page.getStore({
   		limit:limit
       , flow:'contrato/getEfectos' 
       ,storeId: 'efectosContratoStore'
       ,reader: new Ext.data.JsonReader({
           root: 'efectos'
           ,totalProperty : 'total'
       }, Efecto)
       , remoteSort: true       
   });
    
 
   var efectosCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabRecEfecDis.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.codContrato" text="**Cód. Contrato" />',dataIndex:'idContrato',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.codEntidad" text="**Cód. Entidad" />',dataIndex:'codigoEntidad',width:120,hidden:true},
        
        {header:'<s:message code="contrato.tabRecEfecDis.fechaDato" text="**F.Dato" />',dataIndex:'fechaDato',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.codEfecto" text="**Cód. Efecto" />',dataIndex:'codigoEfecto',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.tipoEfecto" text="**Tipo Efecto" />',dataIndex:'DDtipoEfecto',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.situacionEfecto" text="**Situación Efecto" />',dataIndex:'DDsituacionEfecto',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.moneda" text="**Moneda" />',dataIndex:'DDmoneda',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.importe" text="**importe" />',dataIndex:'importe',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabRecEfecDis.capital" text="**Capital" />',dataIndex:'capital',width:120,renderer:app.format.moneyRenderer,align:'right'},
        
        {header:'<s:message code="contrato.tabRecEfecDis.codLinea" text="**Cód. Línea" />',dataIndex:'codigoLinea',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.codAcuerdo" text="**Cód. Acuerdo" />',dataIndex:'codigoAcuerdo',width:120,hidden:true},        
        {header:'<s:message code="contrato.tabRecEfecDis.fVencimiento" text="**F.Vencimiento" />',dataIndex:'fechaVencimiento',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.intOrdinarios" text="**Int. Ordinarios" />',dataIndex:'interesesOrdinarios',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.intMoratorios" text="**Int. Moratorios" />',dataIndex:'interesesMoratorios',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.comisiones" text="**Comisiones" />',dataIndex:'comisiones',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.gastosNoCobrados" text="**Gastos no Cobrados" />',dataIndex:'gastos',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.impuestos" text="**Impuestos" />',dataIndex:'impuestos',width:120,renderer:app.format.moneyRenderer,align:'right',hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.fechaExtraccion" text="**F.Extracción" />',dataIndex:'fechaExtraccion',width:120,hidden:true},
		{header:'<s:message code="contrato.tabRecEfecDis.fechaDescuento" text="**F.Descuento" />',dataIndex:'fechaDescuento',width:120,hidden:true},
		{header:'<s:message code="contrato.tabRecEfecDis.tipoFechaVencimiento" text="**Tipo F.Vencimiento" />',dataIndex:'DDtipoFechaVencimiento',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.charExtra1" text="**Char. Extra1" />',dataIndex:'charExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.charExtra2" text="**Char. Extra2" />',dataIndex:'charExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.flagExtra1" text="**Flag Extra1" />',dataIndex:'flagExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.flagExtra2" text="**Flag Extra2" />',dataIndex:'flagExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.dateExtra1" text="**F.Extra1" />',dataIndex:'dateExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.dateExtra2" text="**F.Extra2" />',dataIndex:'dateExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.numExtra1" text="**Num.Extra1" />',dataIndex:'numExtra1',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.numExtra2" text="**Num.Extra2" />',dataIndex:'numExtra2',width:120,hidden:true},
        {header:'<s:message code="contrato.tabRecEfecDis.titulares" text="**Titulares" />',dataIndex:'titulares',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.tipoIntervencionEfecto" text="**Tipo Relación" />',dataIndex:'tipoIntervencionEfecto',width:120},
        {header:'<s:message code="contrato.tabRecEfecDis.orden" text="**Orden" />',dataIndex:'orden',width:120}        
    ]);
 	
 	var pagingBarEfecto=fwk.ux.getPaging(efectosStore);
    
    var efectosGrid = app.crearGrid(efectosStore,efectosCM,{
        title:'<s:message code="contrato.tabRecEfecDis.efecto" text="**Efectos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:210
        ,bbar : [ pagingBarEfecto  ]
    });

	efectosStore.on('load', function(efectosStore){

		var me = pagingBarEfecto;
        
        if(me.displayItem){
            var count = 0;
            
			for(var i = 0; i < me.store.data.length; i++) {
            	if(!isNaN(me.store.data.items[i].id)) {
            		count++;
            	}
            }
            var msg = count == 0 ?
                me.emptyMsg :
                String.format(
                    me.displayMsg,
                    me.cursor+1, me.cursor+count, me.store.getTotalCount()
                );
            me.displayItem.setText(msg);
        }
	});

//FIN EFECTOS     

  panel.add(recibosGrid);
  panel.add(disposicionesGrid);
  panel.add(efectosGrid);

  panel.getValue = function(){
  }

  panel.setValue = function(){
    var data = entidad.get("data");
    entidad.cacheOrLoad(data, recibosStore, {idContrato : data.id});
    entidad.cacheOrLoad(data, disposicionesStore, {idContrato : data.id});
    entidad.cacheOrLoad(data, efectosStore, {idContrato : data.id});
  }
    return panel;
})
