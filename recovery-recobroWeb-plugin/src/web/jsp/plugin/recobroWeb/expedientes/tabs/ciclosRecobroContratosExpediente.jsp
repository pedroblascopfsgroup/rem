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
        title:'<s:message code="expedientes.consulta.tabcontratos.titulo" text="**Contratos"/>'
        ,height:445
        ,bodyStyle:'padding:10px'   
        ,items:[]
        ,autoHeight:true
        ,nombreTab : 'contratosRecobroTab'
    });

	var contratosRT = Ext.data.Record.create([
		{name:'cc'}
		,{name:'id'}
		,{name:'tipo'}
		,{name:'diasIrregular'}
		,{name:'saldoNoVencido'}
		,{name:'saldoIrregular'}
		,{name:'fechaDato'}
		,{name:'moneda'}
		,{name:'fechaPosVendida'}
		,{name:'saldoDudoso'}
		,{name:'fechaDudoso'}
		,{name:'estadoFinanciero'}
		,{name:'fechaEstadoFinanciero'}
		,{name:'estadoFinancieroAnt'}
		,{name:'fechaEstadoFinancieroAnt'}
		,{name:'provision'}
		,{name:'estadoContrato'}
		,{name:'fechaEstadoContrato'}
		,{name:'movIntRemuneratorios'}
		,{name:'movIntMoratorios'}
		,{name:'comisiones'}
		,{name:'gastos'}
		,{name:'fechaCreacion'}	
		,{name:'idPersona'}
		,{name:'otrosint'}
		,{name:'apellido1'}
		,{name:'apellido2'}	
		,{name:'tipointerv'}
		,{name:'pase'}
		,{name : "ciclosRecobroContrato"}
	]);
	
    var expanderContrato = new Ext.ux.grid.RowExpander({
		renderer: function(v,p,record){	
			if (record.data.ciclosRecobroContrato!=undefined) {
				if(record.data.ciclosRecobroContrato.length>0)
						return '<div class="x-grid3-row-expander"> </div>';
					else
						return ' ';
			}
		},
    	tpl : new Ext.Template('<div id="myrow-cli-{id}" ></div>')
	});
	
    var expandAll = function() {
     	for (var i=0; i < contratosStore.getCount(); i++){
	      expanderContrato.expandRow(i);		  
	    }
    };
    
    var contratosStore = page.getGroupingStore({
        flow: 'ciclorecobroexpediente/getContratosExpedienteRecobro'
        ,storeId : 'contratosStore'
		,groupOnSort:'true'
		,limit:20
        ,reader : new Ext.data.JsonReader(
            {root:'contratos'}
            , contratosRT
        )
	}); 
	
    contratosStore.on('load', function(store, records, options){
	   expandAll();
	});
    
    
     var collapseAll = function() {
     	for (var i=0; i < contratosStore.getCount(); i++){
	      expanderContrato.collapseRow(i);		  
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
	   }
	   return resultado; 
      }

      var colorDateRendererJuniper = function(value, meta, record) {
          var resultado = dateRendererJuniper(value);
	   return coloredRender(resultado, meta, record); 
      }

												
    var contratosCM = new Ext.grid.ColumnModel([
    		expanderContrato,
			{header : 'id', dataIndex : 'id', fixed:true, hidden:true,renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="listadocontratos.pase" text="**Contrato de Pase"/>', width: 60, dataIndex : 'pase', id: 'pase',renderer : coloredRender, hidden:true,css: colorFondo},
	        {header: '<s:message code="plugin.listadocontratos.cc" text="**CC"/>', width: 180,  dataIndex: 'cc', id:'colCodigoContrato',renderer : coloredRender,css: colorFondo },
		    {header: '<s:message code="listadocontratos.tipoproducto" text="**Tipo Producto"/>', width: 120,  dataIndex: 'tipo',renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="listadocontratos.saldoirregular" text="**Saldo Irregular"/>', width: 120, dataIndex: 'saldoIrregular',renderer : moneyColoredRender ,align:'right',css: colorFondo},
			{header: '<s:message code="listadocontratos.saldonovencido" text="**Saldo No Vencido"/>', width: 120,  dataIndex: 'saldoNoVencido',renderer: moneyColoredRender,align:'right',css: colorFondo},
		    {header: '<s:message code="listadocontratos.diasirregular" text="**Dias Irregular"/>', width: 120, 	dataIndex: 'diasIrregular',renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="listadocontratos.fechaDato" text="**Fecha Dato"/>', width: 135, dataIndex: 'fechaDato', hidden:true,renderer : colorDateRendererJuniper ,css: colorFondo},
			{header: '<s:message code="listadocontratos.moneda" text="**Moneda Origen"/>', width: 135, dataIndex: 'moneda', hidden:true,renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="listadocontratos.fechaposvencida" text="**Fecha Pos Vencida"/>', width: 135, dataIndex: 'fechaPosVendida', hidden:true,renderer : colorDateRendererJuniper ,css: colorFondo},
			{header: '<s:message code="listadocontratos.saldodudoso" text="**Saldo Dudoso"/>', width: 135, dataIndex: 'saldoDudoso', hidden:true,renderer: moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="listadocontratos.fechadudoso" text="**Fecha Dudoso"/>', width: 135, dataIndex: 'fechaDudoso', hidden:true,renderer : colorDateRendererJuniper ,css: colorFondo},
			{header: '<s:message code="listadocontratos.estadofinanc" text="**Estado Financ"/>', width: 135, dataIndex: 'estadoFinanciero',renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="listadocontratos.estadofinanant" text="**Estado Financ Ant"/>', width: 135, dataIndex: 'estadoFinancieroAnt', hidden:true,renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="listadocontratos.fechaestadofinan" text="**Fecha Estado Finan"/>', width: 135, dataIndex: 'fechaEstadoFinanciero', hidden:true,renderer : colorDateRendererJuniper,css: colorFondo},
			{header: '<s:message code="listadocontratos.fechaestadofinanant" text="**Fecha Estado Finan Ant"/>', width: 135, dataIndex: 'fechaEstadoFinancieroAnt', hidden:true,renderer : colorDateRendererJuniper,css: colorFondo},
			{header: '<s:message code="listadocontratos.provision" text="**Provision"/>', width: 135, dataIndex: 'provision', hidden:true,renderer: moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="listadocontratos.estadocontrato" text="**Estado Contrato"/>', width: 135, dataIndex: 'estadoContrato', hidden:true,renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="listadocontratos.fechaestadocontrato" text="**Fecha Estado Contrato"/>', width: 135, dataIndex: 'fechaEstadoContrato', hidden:true,renderer : colorDateRendererJuniper ,css: colorFondo},
			{header: '<s:message code="listadocontratos.interesesremunerat" text="**Intereses Remuneratorios Ptes"/>', width: 135, dataIndex: 'movIntRemuneratorios', hidden:true,renderer: moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="listadocontratos.interesesmorat" text="**Intereses Moratorios Ptes"/>', width: 135, dataIndex: 'movIntMoratorios', hidden:true,renderer: moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="listadocontratos.comisiones" text="**Comisiones"/>', width: 135, dataIndex: 'comisiones', hidden:true,renderer: moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="listadocontratos.gastos" text="**Gastos"/>', width: 135, dataIndex: 'gastos', hidden:true,renderer: moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="listadocontratos.fechacreacion" text="**Fecha Creacion"/>', width: 135, dataIndex: 'fechaCreacion', hidden:true,renderer : colorDateRendererJuniper ,css: colorFondo}
		    // {header: '<s:message code="listadocontratos.otrosinterviniente" text="**Otros Interviniente"/>', width: 135,dataIndex: 'otrosint', id:'otrosint',renderer : coloredRender,css: colorFondo},
			// {header: '<s:message code="listadocontratos.tipointervencion" text="**Tipo Intervencion"/>', width: 135, dataIndex: 'tipointerv',renderer : coloredRender,css: colorFondo},
			//{header: 'idPersona', hidden:true, dataIndex: 'idPersona',fixed:true,css: colorFondo}
		]);
		
	
	var incluirContrato = new Ext.Button({
		text : '<s:message code="expedientes.consulta.tabcabecera.recobro.vincularContrato" text="**Vincular contratos" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
        ,handler:function() {
				var widthPantalla = (app.contenido.getSize(true).width || 900)+20;
				page.webflow({
					flow: 'expedientes/isDecisionIniciada'
					,params:{idExpediente:panel.getData("id")}
					,success: function() {
						var w = app.openWindow({
							flow: 'plugin/recobroWeb/expedientes/incluirContrato'
							,eventName: 'busquedaContrato'
							,params: {idExpediente:panel.getData("id"),busquedaOrInclusion:'inclusion'}
							,title: '<s:message code="expedientes.consulta.tabcabecera.recobro.vincularContrato" text="**Incluir contratos" />'
							,width: widthPantalla
						});
						w.on(app.event.DONE, function() {
							w.close();
							contratosStore.webflow({id:panel.getData("id")});
							page.fireEvent(app.event.DONE);
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
					}
				});
			}
	});

	var idContrato;
	var excluirContrato = new Ext.Button({
		text : '<s:message code="expedientes.consulta.tabcabecera.recobro.desvincularContrato" text="**Desvincular contrato" />'
		,iconCls : 'icon_menos'
		,cls: 'x-btn-text-icon'
		,handler: function() {
				Ext.Msg.confirm('<s:message code="expedientes.consulta.tabcabecera.recobro.desvincularContrato" text="**Excluir contrato" />', '<s:message code="expedientes.consulta.tabcabecera.otrosCont.excluirContratos.confirmar" text="**�Est� seguro que desea excluir el contrato del expediente?" />', this.evaluateAndSend);
		}
		,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {
	            			page.webflow({
								flow: 'expedientes/excluirContrato'
								,params:{idExpediente:panel.getData("id"),contratos:idContrato}
								,success: function(){
									contratosStore.webflow({id:panel.getData("id")});
									page.fireEvent(app.event.DONE);
								}
							});
	         			}
	       		}
	});
	excluirContrato.disable();
	
	var cfg = {	
		title:'<s:message code="expedientes.consulta.tabcabecera.contratos" text="**Histico de tareas" />'
		,collapsible:false
		,cls:'cursor_pointer' 
		,height:400
		,plugins: expanderContrato
		,view: new Ext.grid.GroupingView({
			forceFit:true
			,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			,enableNoGroups:true
		})
		,bbar:[ btnExpandAll, btnCollapseAll
		<sec:authorize ifAllGranted="INCLUIR_EXCLUIR_CONTRATOS">
		, incluirContrato
		, excluirContrato
		</sec:authorize>
		]
	};
		
	var contratosExpedienteGrid = app.crearGrid(contratosStore,contratosCM,cfg);
	
	contratosExpedienteGrid.on('rowdblclick', function(grid, rowIndex, e) {
		if (!panel.getData("usuario.usuarioExterno")){
	    	var rec = grid.getStore().getAt(rowIndex);
	    	
	    	
			//if(e.getTarget().className.indexOf('colCodigoContrato') != -1){
				//ABRO EL CONTRATO
				var cc = rec.get('cc');
				var id = rec.get('id');
				app.abreContrato(id, cc);
			//}else if(e.getTarget().className.indexOf('otrosint') != -1){
				//ABRO EL CLIENTE
//				var idPersona = rec.get('idPersona');
//				var otrosint = rec.get('otrosint');
//				app.abreCliente(idPersona, otrosint);
//			}
			
		}
	});
	
	
  	
  	var ciclosRecobroContratoCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.idCiclo" text="**Id ciclo"/>', dataIndex : 'idCiclo', width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.fechaCesion" text="**Fecha cesión"/>', dataIndex : 'fechaCesion', width:135, renderer:dateRendererJuniper }
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.agencia" text="**Agencia"/>', dataIndex : 'agencia', width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.cartera" text="**Cartera"/>', dataIndex : 'cartera', width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.RICedido" text="**RICedido"/>', dataIndex : 'RICedido',renderer: app.format.moneyRenderer, width:135}
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.RDCedido" text="**RDCedido"/>', dataIndex : 'RDCedido',renderer: app.format.moneyRenderer, width:135}		
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.fechaFin" text="**fechaFin"/>', dataIndex : 'fechaFin', width:135, renderer:dateRendererJuniper }
		,{header : '<s:message code="plugin.recobroWeb.expediente.tabContratoRecobro.ciclo.motivoFin" text="**motivoFin"/>', dataIndex : 'motivoFin', width:135}
	]);
	
    function expandedRowContrato(obj, record, body, rowIndex){
	    var absId = record.get('id');
	
	 	var row = "myrow-cli-" + record.get("id");
		    
		var ciclos = record.get('ciclosRecobroContrato');
		
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
			
		   var id2 = "mygrid-cnt-" + record.get("id");
		   
		   var gridXContrato = new Ext.grid.GridPanel({
		        store: dynamicStoreCiclos,
		        stripeRows: true,
		        autoHeight: true,
		        cm: ciclosRecobroContratoCM,
		        id: id2                  
		    });        
		    gridXContrato.render(row);
		    gridXContrato.getEl().swallowEvent([ 'mouseover', 'mousedown', 'click', 'dblclick' ]);
		  }
		  
	}; 
	
	expanderContrato.on('expand', expandedRowContrato);
	contratosExpedienteGrid.on('rowclick', function(grid, rowIndex, e) {
        if (panel.getData("contratos.estaDecidido")) return;
		    	//El contrato de pase no se puede excluir
				var rec = grid.getStore().getAt(rowIndex);
       			pase = rec.get('pase');
		    	if (pase==1) {
		    		excluirContrato.disable();
		    		return;
		    	}
		    	var rec = grid.getStore().getAt(rowIndex);
				var cc = rec.get('cc');
				idContrato = rec.get('id');
				if(cc != '') {
					excluirContrato.enable();
				} else {
					excluirContrato.disable();
				}
			}
		);
	
    panel.add(contratosExpedienteGrid);

  	panel.getValue = function(){};
  	panel.setValue = function(){
	    var data = entidad.get("data");
	    var usuario = data.usuario;
	    contratosStore.webflow({id : data.id });
  	};
  	
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
	    contratosStore.webflow({id : data.id });
		//entidad.cacheOrLoad(data,contratosStore, {id:panel.getData("id")});
		if (panel.getData("contratos.estaDecidido")) incluirContrato.disable();
	};

	//entidad.cacheStore(contratosExpedienteGrid.getStore());

	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente == 'REC';
  	}
  
	return panel;
	
})