<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(page,entidad){
	var idExpediente;
	
	var idCobro;
    var limit = 25;
	var isBusqueda= true;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
		,id:idExpediente
	};
	
	var cobrosPagosRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'fechaMovimiento'}
        ,{name:'tipoCobroPago'}
        ,{name:'origenCobro'}
        ,{name:'importe'}
        ,{name:'contrato'}
    ]);
    
    var cobrosPagosStore = page.getStore({
		id:'cobrosPagosStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'cobrosPagosStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow : 'cobrospagos/getListadoCobrosPagos'
		,reader : new Ext.data.JsonReader({root:'listado',totalProperty : 'total'}, cobrosPagosRecord)
	});
	
	
	var cobrosCM = new Ext.grid.ColumnModel([
			{header: '<s:message code="plugin.expediente.cobrosPagos.tab.fechaDato" text="**Fecha dato" />',dataIndex: 'fechaDato',sortable:true}
			,{header: '<s:message code="plugin.expediente.cobrosPagos.tab.fecha" text="**Fecha movimiento" />',dataIndex: 'fechaMovimiento',sortable:true}
			,{header: '<s:message code="plugin.expediente.cobrosPagos.tab.id" text="**Código cobro" />',dataIndex: 'id',sortable:true}
	        ,{header: '<s:message code="plugin.expediente.cobrosPagos.tab.contrato" text="**Contrato" />',dataIndex: 'contrato',sortable:true}
			,{header: '<s:message code="plugin.expediente.cobrosPagos.tab.tipo" text="**Tipo" />',dataIndex: 'tipoCobroPago',sortable:true}
            ,{header: '<s:message code="plugin.expediente.cobrosPagos.tab.origen" text="**Origen" />',dataIndex: 'origenCobro',sortable:true}
            ,{header: '<s:message code="plugin.expediente.cobrosPagos.tab.importe" text="**Importe" />',dataIndex: 'importe',sortable:true, renderer: app.format.moneyRenderer, align: 'right' }
  	 ]);

	var recargar = function(){
		cobrosPagosStore.webflow({
			 start:0
			,limit:limit
			,id:idExpediente
		});
	}
	
	var pagingBar=fwk.ux.getPaging(cobrosPagosStore);
	
	var cobrosGrid=app.crearEditorGrid(cobrosPagosStore,cobrosCM,{
        title:'<s:message code="plugin.expediente.cobrosPagos.tab.tituloGrid" text="**Cobros/Pagos" />'
        ,id:'cobrosGrid'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:350
        ,bbar : [pagingBar]
    });
    
    cobrosGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
    	var recStore=cobrosPagosStore.getAt(rowIndex);
    	
    	if (recStore.get('id')!=null && recStore.get('id')!="") { 
    		id = recStore.get('id');
    	}
    	
	});
	
	cobrosGrid.on('rowdblclick',function(sm, rowIndex, r){
		var recStore=cobrosPagosStore.getAt(rowIndex);
    	
    	if (recStore.get('id')!=null && recStore.get('id')!="") { 
    		id = recStore.get('id');
    	}
    	var w = app.openWindow({
 	  		flow: 'cobrospagos/getDetalleCobroPago'
  	  		,width: 835
	  		,y:1 
	  		,closable:true
	  		,title: '<s:message code="plugin.expediente.cobrosPagos.detalle.titulo" text="**Detalle cobro/pago" />'
			,params : {
				id:id
			}
		});
		w.on(app.event.DONE, function(){
            w.close();
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
		
	});
	 
      
	var getParametrosBusqueda=function(){
		return {
			 start:0
			,limit:limit			
		}
	}
	
	var validarForm=function(){
		return true;
	}

	
	var panel = new Ext.Panel({
        title : '<s:message code="plugin.expediente.cobrosPagos.titulo" text="**Cobros/Pagos" />',
        id: 'panel',
		labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
        items: [{
   					bodyStyle:'padding: 5px',
   					border:false,
   					items:[cobrosGrid]
   				}]
    });
    
	panel.getValue = function(){
	}
	
	var data;
	
	panel.setValue = function(){	
		data = entidad.get("data");
		idExpediente = data.id;
		recargar();
	}

	panel.setVisibleTab = function(data){
		return true;
	}
	
  
	return panel;
})

