<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="metaform" tagdir="/WEB-INF/tags/pfs/metaform" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


(function(page,entidad){

	var limit = 25;

	var funcionConsultarValor= function(){
		var rec = accionessGrid.getSelectionModel().getSelected();
        var valor = rec.get('valor');
		if(!valor)
			return;
        var w = app.openWindow({
            flow : 'plugin/sidhiweb/asunto/infoJudicialObservacion'
			,width:770
			,title : '<s:message code="plugin.sidhi.tabInfoJudicial.valor" text="**Valor" />'
            ,params : {valor:valor}
        });
        w.on(app.event.DONE, function(){
			w.close();
            btnEditar.disable();
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
	};
	
	var btConsultarValor = new Ext.Button({
		text : '<s:message code="app.consultar" text="**Consultar" />'
		,iconCls : 'icon_edit'
		,disabled:true
		,handler:funcionConsultarValor
	});
	
    var infoJudicial = Ext.data.Record.create([
        {name:'idAccion'}
        ,{name:'idExpedienteExterno'}
        ,{name:'tipoProcedimientoJudicial'}
        ,{name:'usernameProcurador'}
        ,{name:'codigo'}
        ,{name:'plaza'}
        ,{name:'juzgado'}
        ,{name:'numeroAutos'}
        ,{name:'fechaAccion'}
        ,{name:'estadoProcesal'} 
        ,{name:'subEstadoProcesal'}
        ,{name:'tipoValor'}
        ,{name:'valor'}
    ]);
    
    var accionesStore = page.getStore({
        eventName : 'listado'
        ,limit:limit
        ,storeId:'accionesJudiciales'
        ,flow:'sidhiinfojudicial/getInfoJudicialAsunto'
        ,reader: new Ext.data.JsonReader({
            root: 'acciones'
            ,totalProperty : 'total'
        }, infoJudicial)
    });
    
    entidad.cacheStore(accionesStore);
    
    var accionesCm= new Ext.grid.ColumnModel([
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.idAccion" text="**Id accion" />', width: 13,  dataIndex: 'idAccion', id:'idAccion', hidden: true},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.codigo" text="**codigo" />', width: 13,  dataIndex: 'codigo'},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.estadoProcesal" text="**estadoProcesal" />', width: 30,  dataIndex: 'estadoProcesal'},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.plaza" text="**plaza" />', width: 30,  dataIndex: 'plaza', hidden: true},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.juzgado" text="**juzgado" />', width: 30,  dataIndex: 'juzgado', hidden: true},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.numeroAutos" text="**numeroAutos" />', width: 17,  dataIndex: 'numeroAutos'},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.fechaAccion" text="**fechaAccion" />', width: 17,  dataIndex: 'fechaAccion'},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.procurador" text="**usernameProcurador" />', width: 30,  dataIndex: 'usernameProcurador', hidden: true},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.subEstadoProcesal" text="**subEstadoProcesal" />', width: 13,  dataIndex: 'subEstadoProcesal', hidden: true},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.tipoValor" text="**tipoValor" />', width: 17,  dataIndex: 'tipoValor'},
            {header: '<s:message code="plugin.sidhi.tabInfoJudicial.valor" text="**valor" />',  dataIndex: 'valor'}                    
        ]
    );
    
	var pagina=fwk.ux.getPaging(accionesStore);
	
	var accionessGrid=app.crearGrid(accionesStore,accionesCm,{
        title:'<s:message code="plugin.sidhi.tabInfoJudicial.grid.titulo" text="**Acciones Judiciales"/>'
         <app:test id="accionessGrid" addComa="true" />
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,height : 400
        ,cls:'cursor_pointer'
    	,bbar : [pagina, btConsultarValor]
	});
	
	accionessGrid.on('rowclick', function(grid, rowIndex, e) {
		var rec = accionessGrid.getSelectionModel().getSelected();
        var valor = rec.get('valor');
		if(!valor)
			btConsultarValor.disable();
		else 
			btConsultarValor.enable();
  	});
  
	accionessGrid.on('rowdblclick', function(grid, rowIndex, e) {
    	funcionConsultarValor();
  	});
  
	
	var pagina=fwk.ux.getPaging(accionesStore);
	
	
	 //Panel propiamente dicho
   	var panel =new Ext.Panel({
    	title: '<s:message code="plugin.sidhi.tabInfoJudicial.titulo" text="**Informacion Judicial"/>'
        ,layout:'anchor'
        ,autoHeight:true
        ,bodyStyle : 'padding:10px'
        ,items:[
        	accionessGrid
        ]
        ,nombreTab : 'accionesPanel'
    });

  	panel.getValue = function(){
  	}

  	panel.setValue = function(){
  		var data = entidad.get("data");
  		entidad.cacheOrLoad(data, accionesStore, {id : data.id});
		btConsultarValor.disable();
  	}

  	return panel;

})