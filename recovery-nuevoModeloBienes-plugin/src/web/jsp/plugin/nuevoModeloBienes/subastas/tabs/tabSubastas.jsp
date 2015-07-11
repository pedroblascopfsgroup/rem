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
var deselecciona;
var arrayBienSel=[];
var arrayBienSelId=[];
var arrayBienLote=[];
var validacionCDD;
	
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
        
	var SI_NO_NULL_Render = function (value, meta, record) {
		        if (Ext.isEmpty(value)){
                    return '';
                } else {
                    if (value == '1') {
                            return '<s:message code="label.si" text="**S&iacute;" />';
                    } else {
                            return '<s:message code="label.no" text="**No" />';
                    }
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
	
	var btnEditarInfoCierre = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEditarInfoCierre" text="**Editar información cierre" />'
		,iconCls : 'icon_edit'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	if(validacionCDD) {
	        	Ext.Msg.show({
				   title:'Aviso',
				   msg: '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEditarInfoCierre.aviso" text="**No se puede Editar informaci&oacute;n cierre mientras no se haya celebrado la subasta" />',
				   buttons: Ext.Msg.OK
				});
        	}else{
	        	//la plantilla se elije en el controller
				var plantilla='';
		        var w = app.openWindow({
						flow: 'subasta/editarInformacionCierre'
						,params: {idSubasta:idSubasta}
						,title: '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEditarInfoCierre" text="**Editar información cierre" />'
						,width: winWidth
					});
					w.on(app.event.DONE, function() {
						w.close(); });
					w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}				
	});
	 
	var editarDescripcionAdjuntoExpediente = new  Ext.Button({
		text:'<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcion" text="**Editar descripcion"/>'
		,iconCls : 'icon_edit'
		,handler : function() {
			if (grid.getSelectionModel().getCount()>0){
				if (grid.getSelectionModel().getSelected().get('id')!=''){
    			var idAdjunto = grid.getSelectionModel().getSelected().get('id');
    			var parametros = {
								idAdjunto : idAdjunto
					};
    			var w= app.openWindow({
                                         flow: '/pfs/subasta/editarInformacionCierre'
                                         ,closable: true
                                         ,width : 700
                                         ,title : '<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionExpediente" text="**Editar descripción del adjunto del expediente" />'
                                         ,params: parametros
                        });
           	 		w.on(app.event.DONE, function(){
								w.close();
								recargarAdjuntos() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
			
			}else{
				Ext.Msg.alert('<s:message code="plugin.mejoras.asunto.adjuntos.editarDescripcionExpediente" text="**Editar descripción del adjunto del expediente" />','<s:message code="plugin.mejoras.asunto.adjuntos.noValor" text="**Debe seleccionar un valor de la lista" />');
			}
		}
		}	
		
	});
	
	var gridSubastas = app.crearGrid(storeSubastas, cmSubasta, {
		title : '<s:message code="plugin.nuevoModeloBienes.subastas.grid" text="**Subastas" />'
		,height: 180
		,collapsible:false
		,autoWidth: true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,bbar: [btnInfSubasta, btnInstrucSubasta <sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">, btnEditarInfoCierre</sec:authorize>]
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
		idBien = '';
		idBienEnviarCierre ='';
		var codEstadoSubasta = rec.get('codEstadoSubasta');
				
		if(idSubasta!=null && idSubasta!='') {
			lotesStore.webflow({idSubasta:idSubasta});
			panel.el.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>','x-mask-loading');
			disableBotonesCDDStore.webflow({idSubasta:idSubasta});
		}
		
		btnInfSubasta.setDisabled(false);
		btnInstrucSubasta.setDisabled(false);
		btnInstrucLotes.setDisabled(true);
		btnEditarInfoCierre.setDisabled(false);
	   	btnGenerarInformeCierre.setDisabled(false);
	   	btnEnviarCierre.setDisabled(false);
		
		arrayBienSel=[];
		arrayBienSelId=[];
		arrayBienLote=[];

		if (codEstadoSubasta == 'SUS' || codEstadoSubasta == 'CAN' || codEstadoSubasta == 'CEL' ) {
			btnAgregarBien.setDisabled(true);
			btnExcluirBien.setDisabled(true);
		} else {
			btnAgregarBien.setDisabled(false);
			btnExcluirBien.setDisabled(false);
		}
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
		,{name:'disableBotonesCDD'}		
	]);
	
	var disableBotonesCDD = Ext.data.Record.create([
		{name:'valorDisable'}
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
	
    var disableBotonesCDDStore = page.getStore({
		flow : 'subasta/getDisableBotonesCDD'
		,storeId : 'disableBotonesCDDStore'
		,reader : new Ext.data.JsonReader(
			{root : 'disableBotonesCDD'}
			, disableBotonesCDD
		)
	});
	
    lotesStore.on('load', function(store, records, options){
	   	expandAll();	   	
	});
	
	disableBotonesCDDStore.on('load', function(store, records, options){
	   	validacionCDD = store.getAt(0).get('valorDisable');
	   	panel.el.unmask();
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
	
	var btnGenerarInformeCierre = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnGenerarInforme" text="**Generar informe cierre" />'
		,iconCls : 'icon_pdf'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
        	//la plantilla se elije en el controller
			var plantilla='';
		    var flow='/pfs/subasta/generarInformeValidacionCDD';
		    if (arrayBienLote.length > 0){
		    	var strIds = '';
		    	for(i=1;i < arrayBienLote.length;i++){
		    		if(strIds != '') {
						strIds += ',';
					}
		    		strIds += arrayBienLote[i];	
		    		i++;
		    	}
				var params = {idSubasta:idSubasta,idBien:strIds};
	        	app.openBrowserWindow(flow,params);
			} else {
				var params = {idSubasta:idSubasta};
	        	app.openBrowserWindow(flow,params);
			}
		    page.fireEvent(app.event.DONE);
		}
	});
	
	var btnEnviarCierre = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre" text="**Enviar cierre" />'
		,iconCls : 'icon_aplicar'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
        	if (arrayBienLote.length > 0){
		    	var texto;
		    	if(arrayBienLote.length > 2) {
	        		texto = '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre.conBien2" text="**Esta seguro de enviar los bienes a cierre de deudas" />';
		    	}else{	    	
		    		texto = '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre.conBien1" text="**¿Está seguro de enviar el bien a cierre de deudas?" />';
		    	}
        		Ext.Msg.confirm(fwk.constant.confirmar, texto, this.decide, this);
			} else { 
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre.sinBien" text="**¿Esta seguro de enviar la operación a cierre de deudas?" />', this.decide, this);
			}
		}
		,decide : function(boton){
			if (boton=='yes'){ this.enviar(); }
		}
		,enviar : function(){
			var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
			//la plantilla se elije en el controller
			var plantilla='';
		    var flow='/pfs/subasta/generarInformeCierre';
			if (arrayBienLote.length > 0){
		    	var strIds = '';
		    	for(i=1;i < arrayBienLote.length;i++){
		    		if(strIds != '') {
						strIds += ',';
					}
		    		strIds += arrayBienLote[i];	
		    		i++;
		    	}
				var params = {idSubasta:idSubasta,idBien:strIds};
	        	app.openBrowserWindow(flow,params);
			} else {
				var params = {idSubasta:idSubasta};
	        	app.openBrowserWindow(flow,params);
			}
		    page.fireEvent(app.event.DONE);
		}
	});
	
	var btnResetKOCDD = new Ext.Button({
		 text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.resetCDD" text="**Reiniciar Cierre Deuda" />'
		,iconCls : 'icon_menos'
		,cls: 'x-btn-text-icon'
		,handler : function(){
			Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.resetCDD.aviso" text="**¿Esta seguro de reiniciar las propuestas del asunto pendientes de enviar?" />', this.decide, this);
		}
		,decide : function(boton){
			if (boton=='yes'){ this.reiniciar(); }
		}
		,reiniciar : function(){
			<%-- var flow = '/pfs/subasta/reiniciarKOCDD';
			var params={idAsunto:panel.getAsuntoId()};
			app.openBrowserWindow(flow,params); --%>
			reiniciarKOCDD();
		}
	});
	
	var reiniciarKOCDD =  function() {
		debugger;
		Ext.Ajax.request({
			url: page.resolveUrl('subasta/reiniciarKOCDD')
			,method: 'POST'
			,params:{
     				   idAsunto:panel.getAsuntoId()
   				}
			,success: function (result, request){				 
				Ext.MessageBox.show({
		            title: 'Guardado',
		            msg: '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.resetCDD.avisoOK" text="**Las propuestas han sido reiniciadas correctamente" />',
		            width:300,
		            buttons: Ext.MessageBox.OK
		        });
			}
			,error: function(){
				Ext.MessageBox.show({
		            title: 'Guardado',
		            msg: '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.resetCDD.avisoKO" text="**Ha ocurrido un error al reiniciar las propuestas. Consulte con soporte" />',
		            width:300,
		            buttons: Ext.MessageBox.OK
		        });
			} 
		});
	}
	
	
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
		,bbar:[ btnExpandAll, btnCollapseAll, btnAgregarBien, btnExcluirBien, btnInstrucLotes <sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">, btnGenerarInformeCierre , btnEnviarCierre, btnResetKOCDD</sec:authorize>]
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
						,'idLoteBien'
						],
				data: bienes
			});
		
			function contains(a, obj) {
			    for (var i = 0; i < a.length; i++) {
			        if (a[i] === obj) {
			            return true;
			        }
			    }
			    return false;
			}
			
			function deseleccionado(array, lote, idBien) {
				for (var i = 0; i < array.length; i++) {
					var elemento = array[i];
			        if (elemento.indexOf(lote)==0) {
			        	if(idBien == '') {
			        		return array[i+1];
			        	}else{
							if(array[i].indexOf(idBien) == -1) {
				        		return array[i+1];
				        	}			        	
			        	}
			        }
			    }
			}
			
		    var smCheckBien = new Ext.grid.CheckboxSelectionModel({
       	        	checkOnly : true
       	        	,singleSelect: false
       	        	,listeners: {
           				selectionchange: function(sel) {			            	
			            	var loteSeleccionado = record.get("idLote");
			            	var bienSel = sel.getSelections();
			            	var numBienSelec = sel.getCount();
		            		var indexSeleccionado = numBienSelec - 1;
			            	if(deselecciona) {
				            	if(sel.getCount() == 0) {
				            		var idBienDeseleccionado = deseleccionado(arrayBienSelId, loteSeleccionado, '');
			            			var pos = arrayBienSel.indexOf(idBienDeseleccionado);
			            			arrayBienSel.splice(pos,1);
			            			
			            			var posBL = arrayBienLote.indexOf(idBienDeseleccionado);
			            			arrayBienLote.splice(posBL,1);
			            			arrayBienLote.splice(posBL,1);
				            	}
			            		for(i=0;i < sel.getCount();i++){
			            			var idBienDeseleccionado = deseleccionado(arrayBienSelId, loteSeleccionado, bienSel[i].id);
			            			var pos = arrayBienSel.indexOf(idBienDeseleccionado);
			            			arrayBienSel.splice(pos,1);
			            			
			            			var posBL = arrayBienLote.indexOf(idBienDeseleccionado);
			            			arrayBienLote.splice(posBL,1);
			            			arrayBienLote.splice(posBL,1);
			            		}
			            	}else{
			            		if(!contains(arrayBienSel, bienSel[indexSeleccionado].data.idBien)) {
				            			arrayBienSel.push(bienSel[indexSeleccionado].data.idBien);
				            			arrayBienSelId.push(loteSeleccionado+"."+bienSel[indexSeleccionado].id);
				            			arrayBienSelId.push(bienSel[indexSeleccionado].data.idBien);
				            			arrayBienLote.push(bienSel[indexSeleccionado].data.idBien);
				            			arrayBienLote.push(bienSel[indexSeleccionado].data.idBien+';'+bienSel[indexSeleccionado].data.idLoteBien);
				            	}
			            	}
			            	
			            }, rowselect: function(sel) {
			            	deselecciona = false;
			            }, rowdeselect: function(sel) {
			            	deselecciona = true;
			            }
					}
				});
	
		  	var bienesCM = new Ext.grid.ColumnModel([
	  		 	<sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">smCheckBien,</sec:authorize>
				 {header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.numActivo" text="**N&ordm; Activo"/>', dataIndex : 'numActivo'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.codigo" text="**C&oacute;digo"/>', hidden:true, dataIndex : 'codigo'}		
				,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroFinca" text="**N&uacute;mero finca"/>', sortable: true, dataIndex : 'numFinca' }
				,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.referenciaCatastral" text="**Referencia catastral"/>', sortable: true, dataIndex : 'referenciaCatastral' }
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.origen" text="**Origen"/>', dataIndex : 'origen'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.descripcion" text="**Descripci&oacute;n"/>', dataIndex : 'descripcion'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.tipo" text="**Tipo"/>', dataIndex : 'tipo'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.viviendaHab" text="**Vivienda habitual"/>', dataIndex : 'viviendaHabitual',renderer : SI_NO_NULL_Render}		
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.SitPosesoria" text="**Sit. posesoria"/>', dataIndex : 'sitPosesoria'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.RevCargas" text="**Rev. cargas"/>', dataIndex : 'revCargas' }
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.FSolTasacion" text="**F. sol. tasaci&oacute;n"/>', dataIndex : 'fSolTasacion'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.FTasacion" text="**F. tasaci&oacute;n"/>', dataIndex : 'fTasacion'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.Adjudicacion" text="**Adjudicaci&oacute;n"/>', dataIndex : 'Adjudicacion'}
				,{header : '<s:message code="plugin.nuevoModeloBienes.subastas.bienesGrid.ImpAdjudicado" text="**Imp. adjudicado"/>', dataIndex : 'impAdjudicado',renderer: app.format.moneyRenderer}		
			]);
		   		   
		   var gridXLote = new Ext.grid.EditorGridPanel({
		   		store: dynamicStoreBienes,
		        stripeRows: true,
		        autoHeight: true,
		        cm: bienesCM
		        <sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">, sm: smCheckBien </sec:authorize>
		    });        
		    gridXLote.render(row);
		    
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
		btnEditarInfoCierre.setDisabled(true);
		btnGenerarInformeCierre.setDisabled(true);
		btnEnviarCierre.setDisabled(true);
	}
	
	
 	panel.setVisibleTab = function(data){
		return data.toolbar.puedeVerTabSubasta;
	}
	
	return panel;
})
