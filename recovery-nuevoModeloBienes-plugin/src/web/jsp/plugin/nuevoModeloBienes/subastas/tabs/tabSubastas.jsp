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

var colorFondo = 'background-color: #473729;';
var winWidth = 920;
var winWidthAgregarBien= 950;
var idSubasta;

var panel = new Ext.Panel({
		title: '<s:message code="plugin.nuevoModeloBienes.subastas.tabTitle" text="**Subastas" />'
		,autoHeight: true
		,nombreTab : 'tabSubastas'			
	});

	panel.getAsuntoId = function(){ return entidad.get("data").id; }

	var OK_KO_Render = function (value, meta, record) {
		if (value) {
			return '<img src="/pfs/css/true.gif" height="16" width="16" alt=""/>';
		} else {
			return '<img src="/pfs/css/false.gif" height="16" width="16" alt=""/>';
		}
	};
	
	var SI_NO_Render = function (value, meta, record) {
		if (value) {
			return '<s:message code="label.si" text="**S&iacute;" />';
		} else {
			return '<s:message code="label.no" text="**No" />';
		}
	};

	var Subasta = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'numAutos'}
		,{name : 'idProcedimiento'}
		,{name : 'prcDescripcion'}
		,{name : 'tipo'}
		,{name : 'fechaSolicitud'}
		,{name : 'fechaAnuncio'}
		,{name : 'fechaSenyalamiento'}
		,{name : 'codEstadoSubasta'}
		,{name : 'estadoSubasta'}
		,{name : 'resultadoComite'}
		,{name : 'motivoSuspension'}
		,{name : 'tasacion'}
		,{name : 'infoLetrado'}
		,{name : 'instrucciones'}
		,{name : 'subastaRevisada'}
	]);

	var storeSubastas = page.getStore({
		flow : 'subasta/getSubastasAsunto'
		,storeId : 'storeSubastas'
		,reader : new Ext.data.JsonReader({
			root : 'subastas'
		},Subasta)
	});

	storeSubastas.on('load', function() {
	   preselectItem(gridSubastas, 'id', idSubasta);
	});		

	var recargarSubastas = function (){
		entidad.refrescar();
		entidad.cacheOrLoad(data, storeSubastas, {id : panel.getAsuntoId()} ); 
	};

	entidad.cacheStore(storeSubastas);


	var cmSubasta = new Ext.grid.ColumnModel([
		{header: 'id',dataIndex:'id',hidden:'true'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.numAuto" text="**N&ordm; Auto" />', dataIndex : 'numAutos'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.idProcedimiento" text="**Procedimiento" />', dataIndex : 'idProcedimiento'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.prcDescripcion" text="**Descripcion" />', dataIndex : 'prcDescripcion', hidden: true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.tipo" text="**Tipo" />', dataIndex : 'tipo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.fSolicitud" text="**F.Solicitud" />', dataIndex : 'fechaSolicitud'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.fAnuncio" text="**F.Anuncio" />', dataIndex : 'fechaAnuncio'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.fSenyalamiento" text="**F.Se&ntilde;alamiento" />', dataIndex : 'fechaSenyalamiento'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.estado" text="**Estado" />', dataIndex : 'estadoSubasta'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.resultadoComite" text="**Resultado comite" />', dataIndex : 'resultadoComite'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.motivoSuspension" text="**Motivo suspensión" />', dataIndex : 'motivoSuspension'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.tasacion" text="**Tasación" />', dataIndex : 'tasacion',renderer : OK_KO_Render, align:'center'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.infoLetrado" text="**Inf. letrado" />', dataIndex : 'infoLetrado',renderer : OK_KO_Render, align:'center'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.instrucciones" text="**Instrucciones" />', dataIndex : 'instrucciones',renderer : OK_KO_Render, align:'center'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.subastaRevisada" text="**Subasta revisada" />', dataIndex : 'subastaRevisada',renderer : OK_KO_Render, align:'center'}
	]);

	var btnInfSubasta = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnInfSubasta" text="**Inf. de subasta" />'
		,iconCls : 'icon_pdf'
		,disabled : true
		,cls: 'x-btn-text-icon'
		,handler:function() {
			//var idAsunto = panel.getAsuntoId();
			//la plantilla se elije en el controller
			//var plantilla='';
			var flow='/pfs/subasta/generarInformeSubastaLetrado';
			//var params={idAsunto:idAsunto,idSubasta:idSubasta, plantilla:plantilla};
			var params={idSubasta:idSubasta};
			app.openBrowserWindow(flow,params);
			page.fireEvent(app.event.DONE);
		}
	});
	
	var btnInstrucSubasta = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnInstrucSubasta" text="**Instrucciones de subasta" />'
		,iconCls : 'icon_pdf'
		,disabled : true
		,cls: 'x-btn-text-icon'
		,hidden: app.usuarioLogado.externo
        ,handler:function() {
        	var idAsunto=panel.getAsuntoId();
        	//la plantilla se elije en el controller
			var plantilla='';
		    var flow='/pfs/subasta/generarInformeSubasta';
	        var params = {idAsunto:idAsunto,idSubasta:idSubasta, plantilla: plantilla};
	        app.openBrowserWindow(flow,params);
		    page.fireEvent(app.event.DONE);
		}
	});
	
	
	
	var gridSubastas = app.crearGrid(storeSubastas, cmSubasta, {
		title : '<s:message code="plugin.nuevoModeloBienes.subastas.grid" text="**Subastas" />'
		,height: 180
		,collapsible:false
		,autoWidth: true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,bbar: [btnInfSubasta, btnInstrucSubasta]
	});

	gridSubastas.on('expand', function(){
		gridSubastas.setHeight(340);				
	});
	
	gridSubastas.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		var idProcedimiento=rec.get('idProcedimiento');
		app.abreProcedimiento(idProcedimiento, rec.get('prcDescripcion'));		
	});

	function preselectItem(grid, name, value) {
	    grid.getSelectionModel().selectRow(grid.getStore().find(name, value));
	}
 
	gridSubastas.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
	
		var rec = gridSubastas.getStore().getAt(rowIndex);
		idSubasta = rec.get('id');
		var codEstadoSubasta = rec.get('codEstadoSubasta');
				
		if(idSubasta!=null && idSubasta!='') {
			lotesStore.webflow({idSubasta:idSubasta});
		}
		
		btnInfSubasta.setDisabled(false);
		btnInstrucSubasta.setDisabled(false);
		if (codEstadoSubasta == 'SUS' || codEstadoSubasta == 'CAN' || codEstadoSubasta == 'CEL' ) {
			btnAgregarBien.setDisabled(true);
			btnExcluirBien.setDisabled(true);
		} else {
			btnAgregarBien.setDisabled(false);
			btnExcluirBien.setDisabled(false);
		}
		
		btnInfSubasta.setDisabled(false);
		btnInstrucSubasta.setDisabled(false);
		btnInstrucLotes.setDisabled(true);
	});
	
	

//PANEL BIENES
	var coloredRender = function (value, meta, record) {
		return '<span style="color: #C4D600; font-weight: bold;">'+value+'</span>';
	};
	
	var moneyColoredRender = function (value, meta, record) {
		var valor = app.format.moneyRenderer(value, meta, record);
		return coloredRender(valor, meta, record);
	};
	
	var dateColoredRender = function (value, meta, record) {
		<%--var valor = app.format.dateRenderer(value, meta, record); --%>
		return coloredRender(value, meta, record);
	};
	
var lotesRT = Ext.data.Record.create([
		{name:'idLote'}
		,{name:'numLote'}
		,{name:'pujaSin'}
		,{name:'pujaConDesde'}
		,{name:'pujaConHasta'}
		,{name:'valorSubasta'}
		,{name:'50porCien'}
		,{name:'60porCien'}
		,{name:'70porCien'}
		,{name:'observaciones'}
		,{name:'bienes'}
	]);
	
    var expanderLote = new Ext.ux.grid.RowExpander({
		renderer: function(v,p,record){	
			if (record.data.bienes!=undefined) {
				if(record.data.bienes.length>0)
						return '<div class="x-grid3-row-expander"> </div>';
					else
						return ' ';
			}
		},
    	tpl : new Ext.Template('<div id="myrow-bien-{idLote}" ></div>')
	});
	
    var expandAll = function() {
     	for (var i=0; i < lotesStore.getCount(); i++){
	      expanderLote.expandRow(i);		  
	    }
    };
    
    var lotesStore = page.getGroupingStore({
        flow: 'subasta/getLotesSubasta'
        ,storeId : 'lotesStore'
		,groupOnSort:'true'
		,limit:20
        ,reader : new Ext.data.JsonReader(
            {root:'lotes'}
            , lotesRT
        )
	}); 
	
    lotesStore.on('load', function(store, records, options){
	   expandAll();
	});
    
    
     var collapseAll = function() {
     	for (var i=0; i < lotesStore.getCount(); i++){
	      expanderLote.collapseRow(i);		  
	    }
    };

	var btnCollapseAll =new Ext.Button({
  		tooltip:'<s:message code="plugin.nuevoModeloBienes.subastas.collapseAll" text="**Contraer todo" />'
        ,iconCls : 'icon_collapse'
	    ,cls: 'x-btn-icon'
	    ,handler:collapseAll
	    ,disabled: false
  	});
  	
  	var btnExpandAll =new Ext.Button({
      	tooltip:'<s:message code="plugin.nuevoModeloBienes.subastas.expandAll" text="**Expandir todo" />'	    
	    ,iconCls : 'icon_expand'
	    ,cls: 'x-btn-icon'
	    ,handler:expandAll
	    ,disabled: false
  	});
    
    var btnAgregarBien = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.agregarBien" text="**Agregar bien" />'
		,iconCls : 'icon_mas'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	if (gridSubastas.getSelectionModel().getCount()>0){
				var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
				
				var w = app.openWindow({
					flow: 'subasta/winAgregarExcluirBien'
					,params: {idSubasta:idSubasta,accion:'AGREGAR'}
					,title: '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.agregarBien" text="**Agregar bien" />'
					,width: winWidthAgregarBien
				});
				w.on(app.event.DONE, function() {
					w.close();
					storeSubastas.webflow({id :panel.getAsuntoId() });
					lotesStore.webflow({idSubasta:idSubasta});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}
	});

	var btnExcluirBien = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.excluirBien" text="**Excluir bien" />'
			,iconCls : 'icon_menos'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	if (gridSubastas.getSelectionModel().getCount()>0){
				var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
				
				var w = app.openWindow({
					flow: 'subasta/winAgregarExcluirBien'
					,params: {idSubasta:idSubasta,accion:'EXCLUIR'}
					,title: '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.excluirBien" text="**Excluir bien" />'
					,width: winWidthAgregarBien
				});
				w.on(app.event.DONE, function() {
					w.close();
					storeSubastas.webflow({id :panel.getAsuntoId() });
					lotesStore.webflow({idSubasta:idSubasta});
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}
	});
	
	var btnInstrucLotes = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnInstrucLotes" text="**Proponer instrucciones" />'
		,iconCls : 'icon_edit'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	if (gridSubastas.getSelectionModel().getCount()>0){
				var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
	        	if (gridLotes.getSelectionModel().getCount()>0){
					var idLote  = gridLotes.getSelectionModel().getSelected().get('idLote');
					
					var w = app.openWindow({
						flow: 'subasta/winInstruccionesLoteSubasta'
						,params: {idLote:idLote}
						,title: '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnInstrucLotes" text="**Proponer Instrucciones" />'
						,width: winWidth
					});
					w.on(app.event.DONE, function() {
						w.close();
						storeSubastas.webflow({id :panel.getAsuntoId() });
						lotesStore.webflow({idSubasta:idSubasta});
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			}
		}
	});

	
    var lotesCM = new Ext.grid.ColumnModel([
    		expanderLote,
    		{header: 'id',dataIndex:'idLote',hidden:'true', renderer : coloredRender,css: colorFondo},
			{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.lote" text="**Lote"/>', width: 60, dataIndex : 'numLote', renderer : coloredRender,css: colorFondo},
	        {header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.pujaSinPostores" text="**Puja sin postores"/>', width: 180,  dataIndex: 'pujaSin', renderer : moneyColoredRender,align:'right',css: colorFondo },
		    {header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.pujaConPostoresDesde" text="**Puja con postores desde"/>', width: 120,  dataIndex: 'pujaConDesde',renderer : moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.pujaConPostoresHasta" text="**Puja con postores hasta"/>', width: 120, dataIndex: 'pujaConHasta',renderer : moneyColoredRender,align:'right',css: colorFondo},
			{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.valorSubasta" text="**Valor de la subasta"/>', width: 120,  dataIndex: 'valorSubasta',renderer: moneyColoredRender,align:'right',css: colorFondo},
		    {header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.50porCien" text="**50% del tipo"/>', width: 120, 	dataIndex: '50porCien',renderer : moneyColoredRender,css: colorFondo},
			{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.60porCien" text="**60% del tipo"/>', width: 135, dataIndex: '60porCien',renderer : moneyColoredRender ,css: colorFondo},
			{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.70porCien" text="**70% del tipo"/>', width: 135, dataIndex: '70porCien',renderer : moneyColoredRender,css: colorFondo} /*,
			{header: '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.observaciones" text="**Observaciones"/>', width: 135, dataIndex: 'observaciones',renderer: Ext.util.Format.htmlDecode,css: colorFondo}*/
		]);
		
	var cfg = {	
		title:'<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.title" text="**Bienes" />'
		,collapsible:false
		,cls:'cursor_pointer' 
		,height:300
		,autoWidth: true
		,style:'padding-right:10px'
		,plugins: expanderLote
		,view: new Ext.grid.GroupingView({
			forceFit:true
			,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			,enableNoGroups:true
		})
		,bbar:[ btnExpandAll, btnCollapseAll, btnAgregarBien, btnExcluirBien, btnInstrucLotes ]
	};
		
	var gridLotes = app.crearGrid(lotesStore,lotesCM,cfg);
	
	gridLotes.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var idLote = rec.get('idLote');
	});
	
	gridLotes.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
		var rec = gridLotes.getStore().getAt(rowIndex);
		var idLote = rec.get('idLote');
		btnInstrucLotes.setDisabled(false);
	});	
  	
  	var bienesCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.numActivo" text="**N&ordm; Activo"/>', dataIndex : 'numActivo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.codigo" text="**C&oacute;digo"/>', hidden:true, dataIndex : 'codigo'}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroFinca" text="**N&uacute;mero finca"/>', sortable: true, dataIndex : 'numFinca' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.referenciaCatastral" text="**Referencia catastral"/>', sortable: true, dataIndex : 'referenciaCatastral' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.origen" text="**Origen"/>', dataIndex : 'origen'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.descripcion" text="**Descripci&oacute;n"/>', dataIndex : 'descripcion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.tipo" text="**Tipo"/>', dataIndex : 'tipo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.viviendaHab" text="**Vivienda habitual"/>', dataIndex : 'viviendaHabitual',renderer : SI_NO_Render}		
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.SitPosesoria" text="**Sit. posesoria"/>', dataIndex : 'sitPosesoria'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.RevCargas" text="**Rev. cargas"/>', dataIndex : 'revCargas' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.FSolTasacion" text="**F. sol. tasaci&oacute;n"/>', dataIndex : 'fSolTasacion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.FTasacion" text="**F. tasaci&oacute;n"/>', dataIndex : 'fTasacion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.Adjudicacion" text="**Adjudicaci&oacute;n"/>', dataIndex : 'Adjudicacion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.ImpAdjudicado" text="**Imp. adjudicado"/>', dataIndex : 'impAdjudicado',renderer: app.format.moneyRenderer}		
	]);
	
    function expandedRowLote(obj, record, body, rowIndex){
	    var absId = record.get('id');
	
	 	var row = "myrow-bien-" + record.get("idLote");
		    
		var bienes = record.get('bienes');
		
		if (bienes.length) {
			var dynamicStoreBienes = new Ext.data.JsonStore({
				fields: ['idBien'
						,'numActivo'
						,'numFinca'
						,'referenciaCatastral'
						,'codigo'
						,'origen'
						,'descripcion'
						,'tipo'
						,'viviendaHabitual'
						,'sitPosesoria'
						,'revCargas'
						,'fSolTasacion'
						,'fTasacion'
						,'Adjudicacion'
						,'impAdjudicado'
						],
				data: bienes
			});
			
		   var id2 = "mygrid-bien-" + record.get("idLote");
		   
		   var gridXLote = new Ext.grid.GridPanel({
		        store: dynamicStoreBienes,
		        stripeRows: true,
		        autoHeight: true,
		        cm: bienesCM,
		        id: id2                  
		    });        
		    gridXLote.render(row);
		    gridXLote.getEl().swallowEvent([ 'mouseover', 'mousedown', 'click', 'dblclick' ]);
		    
		    gridXLote.on('rowdblclick', function(grid, rowIndex, e) {
		    	var rec = grid.getStore().getAt(rowIndex);
		    	var idBien = rec.get('idBien');
		    	var tipoBien = rec.get('tipo');
		    
		    	app.abreBien(idBien, idBien + ' ' + tipoBien);
		    	
		    });
		  }
		  
	}; 
	
	expanderLote.on('expand', expandedRowLote);
	
	

//FIN PANEL BIENES


	function addPanel2Panel(grid){
		panel.add (new Ext.Panel({
			border : false
			,style : 'margin-top:7px; margin-left:5px'
			,items : [grid]
		}));
	}

	addPanel2Panel(gridSubastas);
	addPanel2Panel(gridLotes);


	panel.getValue = function() {}

	panel.setValue = function(){
		lotesStore.removeAll();
		btnAgregarBien.setDisabled(true);
		btnExcluirBien.setDisabled(true);	

		var data = entidad.get("data");
		entidad.cacheOrLoad(data, storeSubastas, {id : panel.getAsuntoId()} );
		
		idSubasta = null;
		if (entidad.ajaxCallParams.idSubasta) {
			idSubasta = entidad.ajaxCallParams.idSubasta;
		} else {
			gridSubastas.getSelectionModel().clearSelections()
		}
		
		btnInfSubasta.setDisabled(true);
		btnInstrucSubasta.setDisabled(true);
		btnInstrucLotes.setDisabled(true);
	}
	
	
 	panel.setVisibleTab = function(data){
		return data.toolbar.puedeVerTabSubasta;
	}
	
	
	return panel;
})
