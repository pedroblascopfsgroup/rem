<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var panel = new Ext.Panel({
		title:'<s:message code="expedientes.consulta.tabcontratos.titulo" text="**Contratos"/>'
		,autoHeight:true
    ,height:445
		,bodyStyle:'padding: 10px'
		,nombreTab : 'tabContratosExpediente'
	});
	var limit = 10;
	
	var ContratoVencido = Ext.data.Record.create([
		{name:'cc'}
		,{name:'id'}
		,{name:'tipo'}
		,{name:'diasIrregular'}
		,{name:'saldoNoVencido'}
		,{name:'saldoIrregular'}
		,{name:'fechaExtraccion'}
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
	]);

	var contratosExpedienteStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,flow:'expedientes/contratosDeUnExpediente'
    ,storeId : 'contratosExpedienteId'
		,reader: new Ext.data.JsonReader({
			root: 'contratos'
			,totalProperty : 'total'
		}, ContratoVencido)
	});
	

  entidad.cacheStore(contratosExpedienteStore);


	//ColumnModel para grids contratos
	var contratosExpedienteCm= new Ext.grid.ColumnModel([
	        {hidden:true, dataIndex: 'id'},
			{header: '<s:message code="listadocontratos.pase" text="**Contrato de Pase"/>', width: 60, dataIndex : 'pase', id: 'pase'},
	        {header: '<s:message code="listadocontratos.cc" text="**CC"/>', width: 180,  dataIndex: 'cc', id:'colCodigoContrato' },
		    {header: '<s:message code="listadocontratos.tipoproducto" text="**Tipo Producto"/>', width: 120,  dataIndex: 'tipo'},
			{header: '<s:message code="listadocontratos.saldoirregular" text="**Saldo Irregular"/>', width: 120, dataIndex: 'saldoIrregular',renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.saldonovencido" text="**Saldo No Vencido"/>', width: 120,  dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right'},
		    {header: '<s:message code="listadocontratos.diasirregular" text="**Dias Irregular"/>', width: 120, 	dataIndex: 'diasIrregular'},
			{header: '<s:message code="listadocontratos.fechaextraccion" text="**Fecha Extraccion"/>', width: 135, dataIndex: 'fechaExtraccion', hidden:true},
			{header: '<s:message code="listadocontratos.moneda" text="**Moneda Origen"/>', width: 135, dataIndex: 'moneda', hidden:true},
			{header: '<s:message code="listadocontratos.fechaposvencida" text="**Fecha Pos Vencida"/>', width: 135, dataIndex: 'fechaPosVendida', hidden:true},
			{header: '<s:message code="listadocontratos.saldodudoso" text="**Saldo Dudoso"/>', width: 135, dataIndex: 'saldoDudoso', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.fechadudoso" text="**Fecha Dudoso"/>', width: 135, dataIndex: 'fechaDudoso', hidden:true},
			{header: '<s:message code="listadocontratos.estadofinanc" text="**Estado Financ"/>', width: 135, dataIndex: 'estadoFinanciero'},
			{header: '<s:message code="listadocontratos.estadofinanant" text="**Estado Financ Ant"/>', width: 135, dataIndex: 'estadoFinancieroAnt', hidden:true},
			{header: '<s:message code="listadocontratos.fechaestadofinan" text="**Fecha Estado Finan"/>', width: 135, dataIndex: 'fechaEstadoFinanciero', hidden:true},
			{header: '<s:message code="listadocontratos.fechaestadofinanant" text="**Fecha Estado Finan Ant"/>', width: 135, dataIndex: 'fechaEstadoFinancieroAnt', hidden:true},
			{header: '<s:message code="listadocontratos.provision" text="**Provision"/>', width: 135, dataIndex: 'provision', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.estadocontrato" text="**Estado Contrato"/>', width: 135, dataIndex: 'estadoContrato', hidden:true},
			{header: '<s:message code="listadocontratos.fechaestadocontrato" text="**Fecha Estado Contrato"/>', width: 135, dataIndex: 'fechaEstadoContrato', hidden:true},
			{header: '<s:message code="listadocontratos.interesesremunerat" text="**Intereses Remuneratorios Ptes"/>', width: 135, dataIndex: 'movIntRemuneratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.interesesmorat" text="**Intereses Moratorios Ptes"/>', width: 135, dataIndex: 'movIntMoratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.comisiones" text="**Comisiones"/>', width: 135, dataIndex: 'comisiones', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.gastos" text="**Gastos"/>', width: 135, dataIndex: 'gastos', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.fechacreacion" text="**Fecha Creacion"/>', width: 135, dataIndex: 'fechaCreacion', hidden:true},
		    {header: '<s:message code="listadocontratos.otrosinterviniente" text="**Otros Interviniente"/>', width: 135,dataIndex: 'otrosint', id:'otrosint'},
			{header: '<s:message code="listadocontratos.tipointervencion" text="**Tipo Intervencion"/>', width: 135, dataIndex: 'tipointerv'},
			{hidden:true, dataIndex: 'idPersona',fixed:true}
			
		]
	);
	
	
	
	var botonesTabla = fwk.ux.getPaging(contratosExpedienteStore);
	
	var incluirContrato = new Ext.Button({
		text : '<s:message code="expedientes.consulta.tabcabecera.otrosCont.incluirContratos" text="**Incluir contratos" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
        ,handler:function() {
				var widthPantalla = (app.contenido.getSize(true).width || 900)+20;

				page.webflow({
					flow: 'expedientes/isDecisionIniciada'
					,params:{idExpediente:panel.getData("id")}
					,success: function() {
						var w = app.openWindow({
							flow: 'expedientes/plugin.mejoras.expedientes.incluirContrato'
							,eventName: 'busquedaContrato'
							,params: {idExpediente:panel.getData("id"),busquedaOrInclusion:'inclusion'}
							,title: '<s:message code="expedientes.consulta.tabcabecera.otrosCont.incluirContratos" text="**Incluir contratos" />'
							,width: widthPantalla
						});
						w.on(app.event.DONE, function() {
							w.close();
							contratosExpedienteStore.webflow({idExpediente:panel.getData("id")});
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
					}
				});
			}
	});

	var idContrato;
	var excluirContrato = new Ext.Button({
		text : '<s:message code="expedientes.consulta.tabcabecera.otrosCont.excluirContratos" text="**Excluir contrato" />'
		,iconCls : 'icon_menos'
		,cls: 'x-btn-text-icon'
		,handler: function() {
				Ext.Msg.confirm('<s:message code="expedientes.consulta.tabcabecera.otrosCont.excluirContratos" text="**Excluir contrato" />', '<s:message code="expedientes.consulta.tabcabecera.otrosCont.excluirContratos.confirmar" text="**�Est� seguro que desea excluir el contrato del expediente?" />', this.evaluateAndSend);
		}
		,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {
	            			page.webflow({
								flow: 'expedientes/plugin.mejoras.expedientes.excluirContrato'
								,params:{idExpediente:panel.getData("id"),contratos:idContrato}
								,success: function(){
									contratosExpedienteStore.webflow({idExpediente:panel.getData("id")});
								}
							});
	         			}
	       		}
	});
	excluirContrato.disable();
debugger;
	var contratosExpedienteGrid = app.crearGrid(contratosExpedienteStore,contratosExpedienteCm,{
			title:'<s:message code="expedientes.consulta.tabcabecera.contratos" text="**Contratos del expediente"/>'
			,style : 'margin-bottom:10px;padding-right:10px'
			,iconCls : 'icon_contratos_otros'
			,cls:'cursor_pointer'
			,height:415
			,bbar : [ 
				botonesTabla
				<sec:authorize ifAllGranted="INCLUIR_EXCLUIR_CONTRATOS">
					,incluirContrato,excluirContrato
				</sec:authorize>  
				]
	});

	contratosExpedienteGrid.on('rowdblclick', function(grid, rowIndex, e) {
	    	var rec = grid.getStore().getAt(rowIndex);
			if(e.getTarget().className.indexOf('colCodigoContrato') != -1){
				//ABRO EL CONTRATO
				var cc = rec.get('cc');
				var id = rec.get('id');
				app.abreContrato(id, cc);
			}else if(e.getTarget().className.indexOf('otrosint') != -1){
				//ABRO EL CLIENTE
				var idPersona = rec.get('idPersona');
				var otrosint = rec.get('otrosint');
				app.abreCliente(idPersona, otrosint);
			}
		}
	);

		contratosExpedienteGrid.on('rowclick', function(grid, rowIndex, e) {
        if (panel.getData("contratos.estaDecidido")) return;
		    	//El contrato de pase no se puede excluir
		    	if (rowIndex==0) 
		    	{
		    		excluirContrato.disable();
		    		return;
		    	}
		    	var rec = grid.getStore().getAt(rowIndex);
				var cc = rec.get('cc');
				idContrato = rec.get('id');
				debugger;
				if(cc != '') {
					excluirContrato.enable();
				} else {
					excluirContrato.disable();
				}
			}
		);

  panel.add(contratosExpedienteGrid);


  panel.getData = function(id){
   var parts = id.split(".");
   var result=entidad.get("data");
   for(var i=0;i < parts.length;i++){
    result=result[parts[i]];
   }
   return result;
  };

    panel.getValue = function(){};
	
	panel.setValue = function(){
		entidad.cacheOrLoad(data,contratosExpedienteStore, {idExpediente:panel.getData("id")});
		if (panel.getData("contratos.estaDecidido")) incluirContrato.disable();
	};
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente != 'REC';
  }

	return panel;
})