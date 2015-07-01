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

	var colorFondo = 'background-color: #473729;';
	
	var coloredRender = function (value, meta, record) {
		return '<span style="color: #C4D600; font-weight: bold;">'+value+'</span>';
	};
		
	var moneyColoredRender = function (value, meta, record) {
		var valor = app.format.moneyRenderer(value, meta, record);
		return coloredRender(valor, meta, record);
	};
	
	var dateColoredRender = function (value, meta, record) {
		var valor = app.format.dateRenderer(value, meta, record);
		return coloredRender(valor, meta, record);
	};	
	
	
	var panel = new Ext.Panel({
        title:'<s:message code="expedientes.consulta.tabClientes.grid.titulo" text="**Clientes"/>'
        ,height:445
        ,bodyStyle:'padding:10px'   
        ,items:[]
        ,autoHeight:true
        ,nombreTab : 'clientesRecobroTab'
    });

	var personaRT = Ext.data.Record.create([
		{name:'id'}
		,{name : 'apellidoNombre', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'vrDirecto', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'vrIndirecto', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'vrIrregular', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'riesgoDirectoDanyado', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'contratosActivos', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : "ciclosRecobroPersona"}
	]);
	
	
		
		var clientesStore = page.getGroupingStore({
        flow: 'ciclorecobroexpediente/getClientesExpedienteRecobro'
        ,storeId : 'clientesStore'
		,groupOnSort:'true'
		,limit:20
        ,reader : new Ext.data.JsonReader(
            {root:'clientes'}
            , personaRT
        )
	}); 
	 
    var expanderCliente = new Ext.ux.grid.RowExpander({
		renderer: function(v,p,record){	
			if (record.data.ciclosRecobroPersona!=undefined) {
				if(record.data.ciclosRecobroPersona.length>0)
						return '<div class="x-grid3-row-expander"> </div>';
					else
						return ' ';
			}
		},
    	tpl : new Ext.Template('<div id="myrow-cli-{id}" ></div>')
	});
	
    var expandAll = function() {
     	for (var i=0; i < clientesStore.getCount(); i++){
	      expanderCliente.expandRow(i);		  
	    }
    };
    
     var collapseAll = function() {
     	for (var i=0; i < clientesStore.getCount(); i++){
	      expanderCliente.collapseRow(i);		  
	    }
    };
    
    var btnCollapseAll =new Ext.Button({
  		tooltip:'<s:message code="plugin.recobroWeb.collapseAll" text="**Contraer todo" />'
        ,iconCls : 'icon_collapse'
	    ,cls: 'x-btn-icon'
	    ,handler:collapseAll
	    ,disabled: false
  	});
  	
  	var btnExpandAll =new Ext.Button({
      	tooltip:'<s:message code="plugin.recobroWeb.expandAll" text="**Expandir todo" />'	    
	    ,iconCls : 'icon_expand'
	    ,cls: 'x-btn-icon'
	    ,handler:expandAll
	    ,disabled: false
  	});
    
    clientesStore.on('load', function(store, records, options){
	 expandAll();
	});
	
      var dateRendererJuniper = function(value) {
          var resultado = "";
          if (value.length > 10) {
	   	var dt = new Date();
	   	dt = Date.parseDate(value, "d/m/Y");
              if (dt != undefined) {
                 resultado = dt.format('d/m/Y');
              } else {
                 resultado = value.substring(8,10) + "/" + value.substring(5,7) + "/" + value.substring(0,4);
              }
          	// otra opcion resultado = app.format.dateRenderer(value, "d/m/y")
	   }
	   return resultado;
      }

    var personaCM = new Ext.grid.ColumnModel([
    	expanderCliente
		,{header : 'Id'
						, dataIndex : 'id' 
						,sortable:true
						,hidden: true
						,renderer : coloredRender
						,css: colorFondo
		}
		,{header : '<s:message code="expediente.consulta.clientesExpediente.grid.cliente" text="**Cliente"/>'
						, dataIndex : 'apellidoNombre' 
						,sortable:true
						,renderer : coloredRender
						,css: colorFondo
		}
		,{header : '<s:message code="expediente.consulta.clientesExpediente.grid.vrDirecto" text="**Descripción"/>'
						, dataIndex : 'vrDirecto' 
						,sortable:true
						,renderer:  moneyColoredRender
						,css: colorFondo
		}
		,{header : '<s:message code="expediente.consulta.clientesExpediente.grid.vrIndirecto" text="**fecha inicio"/>'
						, dataIndex : 'vrIndirecto' 
						,sortable:true
						,renderer: moneyColoredRender
						,css: colorFondo
		}
		,{header : '<s:message code="expediente.consulta.clientesExpediente.grid.vrIrregular" text="**fecha venc"/>'
						, dataIndex : 'vrIrregular' 
						,sortable:true
						,renderer:  moneyColoredRender
						,css: colorFondo
		}	
		,{header : '<s:message code="expediente.consulta.clientesExpediente.grid.riesgoDirectoDanyado" text="**fecha fin"/>'
						, dataIndex : 'riesgoDirectoDanyado' 
						,sortable:true
						,renderer: moneyColoredRender
						,css: colorFondo
		}
		,{header : '<s:message code="expediente.consulta.clientesExpediente.grid.contratosActivos" text="**Nuemro contratos"/>'
						, dataIndex : 'contratosActivos' 
						,sortable:true
						,renderer : coloredRender
						,css: colorFondo
		}
		]);
	var cfg = {	
		title:'<s:message code="expedientes.consulta.tabClientes" text="**Histico de tareas" />'
		,collapsible:false
		,cls:'cursor_pointer' 
		,height:400
		,plugins: expanderCliente
		,bbar : [ btnExpandAll, btnCollapseAll]
		,view: new Ext.grid.GroupingView({
			forceFit:true
			,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			,enableNoGroups:true
		})
	};
		
	var clientesExpedienteGrid = app.crearGrid(clientesStore,personaCM,cfg);
	
	clientesExpedienteGrid.on('rowdblclick',function(grid, rowIndex, e){
		if (!panel.getData("usuario.usuarioExterno")){
		
			var rec=clientesStore.getAt(rowIndex);
			if(!rec) return;
			var nombre_cliente=rec.get('apellidoNombre');
	  		
	  		app.abreCliente(rec.get('id'), nombre_cliente);
	  		
	  	}
	});
  	  	
  	var ciclosRecobroPersonaCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.idCiclo" text="**Id ciclo"/>', dataIndex : 'idCiclo', width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.fechaCesion" text="**Fecha cesión"/>', dataIndex : 'fechaCesion', width:135, renderer:dateRendererJuniper}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.agencia" text="**Agencia"/>', dataIndex : 'agencia', width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.cartera" text="**Cartera"/>', dataIndex : 'cartera', width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.RDCedido" text="**RDCedido"/>', dataIndex : 'RDCedido',renderer: app.format.moneyRenderer, width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.RICedido" text="**RICedido"/>', dataIndex : 'RICedido',renderer: app.format.moneyRenderer, width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.fechaFin" text="**fechaFin"/>', dataIndex : 'fechaFin', width:135, renderer:dateRendererJuniper}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabClienteRecobro.ciclo.motivoFin" text="**motivoFin"/>', dataIndex : 'motivoFin', width:135}
	]);
	
    function expandedRowCliente(obj, record, body, rowIndex){
	    var absId = record.get('id');
	
	 	var row = "myrow-cli-" + record.get("id");
		    
		var ciclos = record.get('ciclosRecobroPersona');
		
		if (ciclos.length) {
			var dynamicStoreCiclos = new Ext.data.JsonStore({
				fields: ['idCiclo'
						 ,{name : "fechaCesion",type:'string'}
						,'agencia'
						,'cartera'
						,'RDCedido'
						,'RICedido'
						,{name : "fechaFin",type:'string'}
						,'motivoFin'
						],
				data: ciclos
			});
			
		   var id2 = "mygrid-cicl-" + record.get("id");
		   
		   var gridXCliente = new Ext.grid.GridPanel({
		        store: dynamicStoreCiclos,
		        stripeRows: true,
		        autoHeight: true,
		        cm: ciclosRecobroPersonaCM,
		        id: id2                  
		    });        
		    gridXCliente.render(row);
		    gridXCliente.getEl().swallowEvent([ 'mouseover', 'mousedown', 'click' ]);
		  }
		  
	}; 
	 
	expanderCliente.on('expand', expandedRowCliente);
	
    panel.add(clientesExpedienteGrid);

	panel.getData = function(id){
   		var parts = id.split(".");
   		var result=entidad.get("data");
   		for(var i=0;i< parts.length;i++){
    		result=result[parts[i]];
   		}
   		return result;
  	};
  
  	panel.getValue = function(){};
  	panel.setValue = function(){
	    var data = entidad.get("data");
	    clientesStore.webflow({id : data.id });
	    //entidad.cacheOrLoad(data,clientesStore, {id:panel.getData("id")});
  	};
  	
	//entidad.cacheStore(clientesExpedienteGrid.getStore());
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente == 'REC';
  }
  
	return panel;
})