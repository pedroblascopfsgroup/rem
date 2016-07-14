<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto" %>

<fwk:page>

	//Variables
	var limit=25;	
	var currentRowId;
	
	//Panel filtros
	
	var plazasData = <app:dict value="${tipoPlaza}"/>;
	var plazasDataStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : plazasData
	       ,root: 'diccionario'
	});
	
    var cmbPlazas = app.creaCombo({
    	store : plazasDataStore
    	,name : 'tipoImporteLit'
    	,fieldLabel : '<s:message code="plugin.procuradores.turnado.grids.plaza" text="**Plaza" />'
		,width : 130
    });
    
    var tpoData = <app:dict value="${tipoProcedimiento}"/>;
	var tpoDataStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : tpoData
	       ,root: 'diccionario'
	});
	
    var cmbTpo = app.creaCombo({
    	store : tpoDataStore
    	,name : 'tipoImporteLit'
    	,fieldLabel : '<s:message code="plugin.procuradores.turnado.detalle.actuacion" text="**Actuacion" />'
		,width : 130
    });
    
    //Boton buscar
	var btnBuscar=new Ext.Button({
		text:'<s:message code="app.buscar" text="**Buscar" />'
		,iconCls:'icon_busquedas'
		,handler:function(){
			datos=getParametrosDto();
			historicoStore.webflow(datos);
			page.fireEvent(app.event.DONE);
			historicoGrid.expand(true);
            panelFiltros.collapse(true);
            panelFiltros.getTopToolbar().setDisabled(true);
			
		}
		,
	});
	//Boton Limpiar
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			resetFiltros();
		}
	});
	
	<pfsforms:textfield labelKey="plugin.procuradores.turnado.detalle.asunto" label="**Asunto" name="txtAsunto" value="" readOnly="false" width="120"/>
		
	<pfsforms:textfield labelKey="plugin.procuradores.turnado.detalle.procuAsig" label="**Procurador asignado" name="txtProcuAsig" value="" readOnly="false" width="120"/>
		
	<pfsforms:textfield labelKey="plugin.procuradores.turnado.detalle.letrado" label="**Letrado" name="txtLetrado" value="" readOnly="false" width="120"/>

	<pfs:datefield name="dateFechaDesde" labelKey="plugin.procuradores.turnado.detalle.fCreacionDesde" label="**F.Creacion desde" width="120"/>
	
	<pfs:datefield name="dateFechaHasta" labelKey="plugin.procuradores.turnado.detalle.fCreacionHasta" label="**F.Creacion hasta" width="120"/>

	var importe = app.creaMinMaxMoneda('<s:message code="plugin.procuradores.turnado.detalle.importe" text="**Importe" />', 'importe',{width : 80});
	
	var panelFiltros = new Ext.Panel({
		title:'<s:message code="plugin.procuradores.turnado.detalle.titBusc" text="**Buscador asignaciones de procuradores" />'
		,collapsible:true
		,collapsed: false
		,titleCollapse : true
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:3}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,style:'padding-bottom:10px; padding-right:10px;'
		,items:[{
				layout:'form'
				,items: [txtAsunto,txtLetrado,txtProcuAsig]
				},{
				layout:'form'
				,style: 'margin-left:20px;'
				,items: [dateFechaDesde,cmbPlazas,cmbTpo]
				},{
				layout:'form'
				,style: 'margin-left:20px; width:270px;'
				,items: [dateFechaHasta,importe.panel]
				}]
		,listeners:{	
			beforeExpand:function(){
				historicoGrid.setHeight(125);
				historicoGrid.collapse(true);							
			}
			,beforeCollapse:function(){
				historicoGrid.setHeight(435);
				historicoGrid.expand(true);			
			}
		}
		,tbar : [btnBuscar,btnClean]
	});
	
	//------------------------------------------------------------------------------------------
	resetFiltros = function(){
			cmbPlazas.reset();
			cmbTpo.reset();
			txtAsunto.reset();
			txtLetrado.reset();
			txtProcuAsig.reset();
			dateFechaDesde.reset();
			dateFechaHasta.reset();
			importe.max.reset();
			importe.min.reset();
	}
	
	var getParametrosDto=function(){
		    var datos={};
			datos.asunto = txtAsunto.getValue();
			datos.letrado = txtLetrado.getValue();
			datos.procurador = txtProcuAsig.getValue();
			datos.fechaDesde = dateFechaDesde.getValue();
			datos.fechaHasta = dateFechaHasta.getValue();
			datos.importeMax = importe.max.getValue();
			datos.importeMin = importe.min.getValue();
			datos.plaza = cmbPlazas.getValue();
			datos.tpo = cmbTpo.getValue();
			return datos;
	}
	
	//Panel grid resultados
	
	var historico = Ext.data.Record.create([
		 {name:'id'}
		 ,{name:'asunto'}
		 ,{name:'plaza'}
		 ,{name:'actuacion'}
		 ,{name:'principalTurnado'}
		 ,{name:'reglaAplicada'}
		 ,{name:'procuAsign'}
		 ,{name:'principalVigente'}
		 ,{name:'letrado'}
		 ,{name:'fecha'}
		 ,{name:'procuGaa'}
	]);				
	
	var historicoStore = page.getStore({
		 flow: 'turnadoprocuradores/buscarDetalleHistorico' 
		,limit: limit
		,reader: new Ext.data.JsonReader({
	    	 root : 'detalleHistorico'
	    	,totalProperty : 'total'
	     }, historico)
	});	
	
	historicoStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
    });
	
	var pagingBar=fwk.ux.getPaging(historicoStore);
	
	var historicoCm = new Ext.grid.ColumnModel([	    
		{header: 'Id', dataIndex: 'id', hidden: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.asunto" text="**Asunto"/>', dataIndex: 'asunto', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.plaza" text="**Plaza"/>', dataIndex: 'plaza', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.actuacion" text="**Actuacion"/>', dataIndex: 'actuacion', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.principalTurnado" text="**Principal turnado"/>', dataIndex: 'principalTurnado', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.reglaAplicada" text="**Regla aplicada"/>', dataIndex: 'reglaAplicada', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.procuradorAsignado" text="**Procurador asignado"/>', dataIndex: 'procuAsign', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.principalVigente" text="**Principal vigente"/>', dataIndex: 'principalVigente', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.procuradorGaa" text="**Procu Gaa"/>', dataIndex: 'procuGaa', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.letrado" text="**Letrado"/>', dataIndex: 'letrado', sortable: true}
		,{header: '<s:message code="plugin.procuradores.turnado.detalle.grid.fecha" text="**Fecha"/>', dataIndex: 'fecha', sortable: true}
		
	]);
	
	var sm = new Ext.grid.RowSelectionModel({
		checkOnly : false
		,singleSelect: true
        ,listeners: {
            rowselect: function(p, rowIndex, r) {
            	if (!this.hasSelection()) {
            		return;
            	}
            }
         }
	});
	
	var historicoGrid = new Ext.grid.EditorGridPanel({
		store: historicoStore
		,cm: historicoCm
		,title:'<s:message code="plugin.procuradores.turnado.detalle.titulo" text="**Asignaciones de procuradores"/>'
		,stripeRows: true
		,autoHeight:true
		,resizable:true
		,collapsible : true
		,collapsed : true
		,titleCollapse : true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,iconCls : 'icon_juzgados'
		,clickstoEdit: 1
		,style:'padding-bottom:10px; padding-right:10px;'
		,viewConfig : {forceFit : true}
		,monitorResize: true
		,selModel: sm
		,bbar : [pagingBar]
	});
	
	historicoGrid.on({
		rowdblclick: function(grid, rowIndex, e) {
		   	var rec = grid.getStore().getAt(rowIndex);
		   	currentRowId = rec.get('id');
		   	currentRowTitle = rec.get('descripcion');
		}
		,rowclick : function(grid, rowIndex, e) {
			var rec = grid.getStore().getAt(rowIndex);
			currentRowId = rec.get('id');
       	}
	});
	
	//PANEL PRINCIPAL ********************************************************************
	var mainPanel = new Ext.Panel({
		items : [panelFiltros, historicoGrid]
	    ,bodyStyle:'padding:15px'
	    ,autoHeight : true
	    ,border: false
	   });

	page.add(mainPanel);

</fwk:page>


