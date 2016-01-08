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
	var validacionCDD;
	
	// Variable que irá manteniendo los bienes seleccionados de todos los lotes.
	var bienesSeleccionados=[];
	
	// Constantes propietario Asunto
	var asuntoPropiedadBankia = '<fwk:const value="es.pfsgroup.recovery.ext.impl.asunto.model.DDPropiedadAsunto.PROPIEDAD_BANKIA" />';
	var asuntoPropiedadSareb = '<fwk:const value="es.pfsgroup.recovery.ext.impl.asunto.model.DDPropiedadAsunto.PROPIEDAD_SAREB" />';
	
	/**
	* Función que devuelve true si el propietario del asunto coincide con el valor de 
	* la constante asuntoPropiedadBankia
	*/
	var isAsuntoPropiedadBankia = function() {
	
		return entidad.get("data").cabecera.propiedadAsunto == asuntoPropiedadBankia;
	}

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
	 	
	var gridSubastas = app.crearGrid(storeSubastas, cmSubasta, {
		title : '<s:message code="plugin.nuevoModeloBienes.subastas.grid" text="**Subastas" />'
		,height: 180
		,collapsible:false
		,autoWidth: true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,bbar: [btnInfSubasta, btnInstrucSubasta <sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">, btnEditarInfoCierre, btnResetKOCDD</sec:authorize>]
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
	   	btnDescargarPlantillaInstrucciones.setDisabled(false);
		
		bienesSeleccionados = [];

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
	    bienesSeleccionados = [];
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
		    var flow='/pfs/subasta/generarInformeCierreDeuda';
		    
		    var params = "";
		    	
		    if(Ext.isEmpty(bienesSeleccionados) || bienesSeleccionados.length == 0){
        		params = {idSubasta:idSubasta};				
			} else {
				// Sino enviamos los bienes seleccionados
				params = {idSubasta:idSubasta, idBien:bienesSeleccionados};
			} 

			app.openBrowserWindow(flow,params);
		    page.fireEvent(app.event.DONE);
		}
	});
	
	var btnEnviarCierre = new Ext.Button({
		text : '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre" text="**Enviar cierre" />'
		,iconCls : 'icon_aplicar'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	var texto;
        	
        	if (isAsuntoPropiedadBankia()){
        		texto = '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre.sinBien" text="**¿Esta seguro de enviar la operación a cierre de deudas?" />';	
        	} else if(Ext.isEmpty(bienesSeleccionados)) { // Sino es bankia y no tenemos bienes, es agrupación sareb
        		texto = '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre.sinBien.agrupamiento" text="**¿Esta seguro de enviar la operación a cierre de deudas en modo agrupamiento?" />';			
			} else if(bienesSeleccionados.length > 1) {
	        		texto = '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre.conBien2" text="**¿Esta seguro de enviar los bienes a cierre de deudas?" />';
		    }else {	    	
		    	texto = '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.btnEnviarCierre.conBien1" text="**¿Está seguro de enviar el bien a cierre de deudas?" />';
		    }			
			
			Ext.Msg.confirm(fwk.constant.confirmar, texto, this.decide, this);
		}
		,decide : function(boton){
			if (boton=='yes'){ this.enviar(); }
		}
		,enviar : function(){
			var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
		    var params;
		    
		    if(Ext.isEmpty(bienesSeleccionados) || bienesSeleccionados.length == 0){
        		params = {idSubasta:idSubasta};				
			} else {
				params = {idSubasta:idSubasta, idBien:bienesSeleccionados};
			}   				
	    	page.webflow({
	      		flow:'subasta/validarInformeCierreDeuda'
	      		,params: params		      		
	      		,success: function(result,request){
					if(result.msgError==''){
						app.openBrowserWindow('/pfs/subasta/enviarCierreDeuda',params);
		  				page.fireEvent(app.event.DONE);					
					}else{						
						Ext.Msg.show({
							title:'Faltan datos para poder enviar el informe de cierre de deuda',
							msg: result.msgError,
							buttons: Ext.Msg.OK,
							width: 500,
							icon:Ext.MessageBox.WARNING});					
					} 					
				}		    	
			});		    
		}
	});
	
	
	
	var reiniciarKOCDD =  function() {
		panel.el.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />','x-mask-loading');
		Ext.Ajax.request({
			url: page.resolveUrl('subasta/reiniciarKOCDD')
			,method: 'POST'
			,params:{
     				   idAsunto:panel.getAsuntoId()
   				}
			,success: function (result, request){
				panel.el.unmask();	 
				Ext.MessageBox.show({
		            title: 'Guardado',
		            msg: '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.resetCDD.avisoOK" text="**Las propuestas han sido reiniciadas correctamente" />',
		            width:300,
		            buttons: Ext.MessageBox.OK
		        });
			}
			,error: function(){
				panel.el.unmask();
				Ext.MessageBox.show({
		            title: 'Guardado',
		            msg: '<s:message code="plugin.nuevoModeloBienes.subastas.subastasGrid.resetCDD.avisoKO" text="**Ha ocurrido un error al reiniciar las propuestas. Consulte con soporte" />',
		            width:300,
		            buttons: Ext.MessageBox.OK
		        });
			} 
		});
	}
	
	<%-- Modificaciones Operaciones masivas --%>
	var btnAddRelacionContratoBien = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnNuevaRelacionContratoBien" text="**Añadir Relación Contrato Bien" />'
			,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,disabled:true
			
	});
	
	btnAddRelacionContratoBien.on('click', function(){		
			var w = app.openWindow({
				  flow : 'subasta/getRelacionContratoBien'
				  ,width:1150
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnNuevaRelacionContratoBien" text="**Añadir Relación Contrato Bien" />'
				  ,params:{idBienes:bienesSeleccionados}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						
						
				});
				w.on(app.event.CANCEL, function(){w.close();});
			
	
	});
	
	var btnBorrarRelacionContratoBien = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnEliminarRelacionContratoBien" text="**Eliminar Relación Contrato Bien" />'
			,iconCls : 'icon_cancel'
			,cls: 'x-btn-text-icon'
			,disabled:true
			
	});
	
	btnBorrarRelacionContratoBien.on('click', function(){
		var w = app.openWindow({
				  flow : 'subasta/getBorrarRelacionContratoBien'
				  ,width:1150
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnEliminarRelacionContratoBien" text="**Eliminar Relación Contrato Bien" />'
				  ,params:{idBienes:bienesSeleccionados}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						
						
				});
				w.on(app.event.CANCEL, function(){w.close();});	
	
	});
	
	var btnAgregarBienCargas = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.cargas.agregar" text="**Nueva Carga" />'
			,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,disabled:true
			
	});
	
	btnAgregarBienCargas.on('click', function(){
		var w = app.openWindow({
				  flow : 'subasta/getAgregarBienCargas'
				  ,width:800
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.nuevoModeloBienes.cargas.agregar" text="**Nueva carga" />'
				  ,params:{idBienes:bienesSeleccionados}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						
						
				});
				w.on(app.event.CANCEL, function(){w.close();});	
	
	});	
	
	
	var btnEditarRevisionCargas = new Ext.Button({
			text : '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.btnRegistrarNoExistenciaCargas" text="**Registrar No existencia de cargas" />'
			,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,disabled:true
			
	});
	
	btnEditarRevisionCargas.on('click', function(){
		var w = app.openWindow({
				  flow : 'subasta/getEditarRevisionCargas'
				  ,width:430
				  ,autoWidth:true
				  ,closable:true
				  ,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabAdjudicacion.titleEditarRevisionCargas" text="**Editar revisión de cargas" />'
				  ,params:{idBienes:bienesSeleccionados}
				
				});
				w.on(app.event.DONE,function(){
						w.close();
						
						
				});
				w.on(app.event.CANCEL, function(){w.close();});	
	
	});
	
	<%-- 
	var btnDescargarPlantillaInstrucciones = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.descargarExcel" text="**Descargar Excel" />' + '&nbsp;'
	       ,iconCls:'icon_exportar_csv'
	       ,height : 25
	       ,handler:function(){
				var flow='/pfs/msvprocesadotareasarchivo/descargarExcel';
            	var params = {idTipoOperacion:1};
            	app.openBrowserWindow(flow,params);	       
	     	}
	});
	--%>
	
	var btnDescargarPlantillaInstrucciones = new Ext.Button({
	       text : '<s:message code="plugin.masivo.procesadoTareas.descargarExcel" text="**Descargar Excel" />' + '&nbsp;'
	       ,iconCls:'icon_exportar_csv'
	       ,height : 25
	       ,disabled:true
	       ,handler:function(){
	       		var numAutos=storeSubastas.data.items[0].data.numAutos;
	       		var fechaSubasta=storeSubastas.data.items[0].data.fechaSenyalamiento;
	       		var numLotes=[];
	       		for(i=0;i<lotesStore.data.length;i++){
					numLotes.push(lotesStore.data.items[i].data.idLote);	
				}
				
				var flow='/pfs/subasta/descargarPlantillaInstrucciones';
            	var params = {numAutos:numAutos,fechaSubasta:fechaSubasta,numLotes:numLotes};
            	app.openBrowserWindow(flow,params);	       
	     	}
	});
	
	
	var btnSubirInstrucciones = new Ext.Button({
	       text : '<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas" text="**Subida masiva de instrucciones" />' + '&nbsp;'
	       ,iconCls:'icon_exportar_csv'
	       ,height : 25
	})
	
	btnSubirInstrucciones.on('click', function(){
      if (gridSubastas.getSelectionModel().getCount()>0){
		var upload = new Ext.FormPanel({
		        fileUpload: true
		        ,height: 55
		        ,autoWidth: true
		        ,bodyStyle: 'padding: 10px 10px 0 10px;'
		        ,defaults: {
		            allowBlank: false
		            ,msgTarget: 'side'
					,height:45
		        }
		        ,items: [{
			            xtype: 'fileuploadfield'
			            ,emptyText: '<s:message code="fichero.upload.fileLabel.error" text="**Debe seleccionar un fichero" />'
			            ,fieldLabel: '<s:message code="fichero.upload.fileLabel" text="**Fichero" />'
			            ,name: 'path'
			            ,path:'root'
			            ,buttonText: ''
			            ,buttonCfg: {
			                iconCls: 'icon_mas'
			            }
			            ,bodyStyle: 'width:50px;'
		        },{xtype: 'hidden', name:'id', value:0}]
		        ,buttons: [{
		            text: 'Subir',
		            handler: function(){
		            	//var idSubasta=storeSubastas.data.items[0].data.id;
						var idSubasta = gridSubastas.getSelectionModel().getSelected().get('id');
		            	var params = {idSubasta:idSubasta};            	
		                if(upload.getForm().isValid()){
			                upload.getForm().submit({
			                    url:'/${appProperties.appName}/subastas/uploadInstruccionesSubastas.htm'
			                    ,waitMsg: '<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas.procesando" text="**Procesando la información..." />'
			                    ,params:params
			                    ,success: function(upload, o){	
			                    	var resultado = o.result.resultado;
			                    	if (resultado != "ok") {
			                    		Ext.Msg.alert('<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas" text="*** Subida masiva de instrucciones" />',
			                    			'<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas.error" text="** Se ha producido algun error al procesar el fichero de Instrucciones" /><br/><br/>' + resultado);
			                    	} else {
			                    		Ext.Msg.alert('<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas" text="*** Subida masiva de instrucciones" />',
			                    			'<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas.ok" text="*** Se ha procesado correctamente la información." />');
			                    	}
			                    	win.close();
			                    	recargarSubastas();
			                    }
			                });
		                }
		            }
		        },{
		            text: 'Cancelar',
		            handler: function(){
		                win.close();
		            }
		        }]
		    });

			var win =new Ext.Window({
			         width:400
					,minWidth:400
			        ,height:125
					,minHeight:125
			        ,layout:'fit'
			        ,border:false
			        ,closable:true
			        ,title:'<s:message code="adjuntos.nuevo" text="**Agregar fichero" />'
					,iconCls:'icon-upload'
					,items:[upload]
					,modal : true
			});
			win.show();
		} else {
			Ext.Msg.alert('<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas" text="*** Subida masiva de instrucciones" />',
	        	'<s:message code="plugin.nuevoModeloBienes.instruccionesMasivas.debeSeleccionarSubasta" text="** Debe seleccionar una subasta" />');		
		}
	});	
	
	var btnSolicitarNumsActivos = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnSolicitarNumsActivos" text="**Solicitar Numeros de Activos" />'			
		    ,iconCls : 'icon_refresh'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'	    
	        ,height : 25
	       	,disabled:true	       			    
		    ,handler:function(){	    			    
	     			page.webflow({
		      		flow:'editbien/solicitarNumsActivosBienes'
		      		,params:{idBien:bienesSeleccionados}		      		
		      		,success: function(result,request){
						if(result.msgError=='1'){
							Ext.Msg.show({
								title:'Operaci&oacute;n realizada',
								msg: 'La solicitud de n&uacute;meros de activos se realiz&oacute; correctamente',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.INFO});
						
						}else{
							Ext.Msg.show({
								title:'Advertencia',
								msg: result.msgError,
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.WARNING});
						}
			    	}
				});			
	        }
		});	
	
	
	var btnAccionesSubasta = new Ext.Button({
      text    : '<s:message code="plugin.nuevoModeloBienes.subastas.gridLotes.btnAccionesSobreSubastas" text="**Acciones sobre subastas" />',
      style   : 'position:absolute;right:10px;top:5px',
      disabled : false,
      menu : {
      	items: [btnDescargarPlantillaInstrucciones,btnSubirInstrucciones,btnSolicitarNumsActivos,btnAddRelacionContratoBien,btnBorrarRelacionContratoBien,btnAgregarBienCargas,btnEditarRevisionCargas

      		]}
     })	
	<%-- --%>
	

    var lotesCM = new Ext.grid.ColumnModel([
    		expanderLote,
    		{header: 'Id. Lote',width:55, dataIndex:'idLote',renderer : coloredRender,css: colorFondo},
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
			,selectedRowClass : 'x-grid-row-selected'	
		})
		,bbar:[ btnExpandAll, btnCollapseAll 
				<sec:authorize ifNotGranted = "SOLO_CONSULTA">, btnAgregarBien, btnExcluirBien, btnInstrucLotes</sec:authorize>
				<sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">, btnGenerarInformeCierre , btnEnviarCierre</sec:authorize>
				<sec:authorize ifNotGranted = "SOLO_CONSULTA">
					<sec:authorize ifAllGranted="MENU_ACC_MULTIPLES_SUBASTA">
						,btnAccionesSubasta
					</sec:authorize>
				</sec:authorize>]
	};
		
	var gridLotes = app.crearGrid(lotesStore,lotesCM,cfg);
	
	// Se habilita el botón Proponer Instrucciones sólamente cuando se ha seleccionado un lote.
	gridLotes.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
		btnInstrucLotes.setDisabled(false);
	});
	
	function updateStatusBtnSolicitarNumerosActivos(){
		btnSolicitarNumsActivos.setDisabled(true);
		
		var bienesSinNumActivo = getBienesSinNumActivo();
				
		for(i = 0; i < bienesSeleccionados.length; i++){
			var idSeleccionado = bienesSeleccionados[i];
			for(j = 0; j < bienesSinNumActivo.length; j++){
				var idSinNumActivo = bienesSinNumActivo[j];
				if(idSeleccionado == idSinNumActivo){
					btnSolicitarNumsActivos.setDisabled(false);
				}
			}
		}
	}
	
	function getBienesSinNumActivo(){
		var bienesSinNumActivo = [];  
		for(i=0; i < lotesStore.data.length; i++){
			for(j = 0; j < lotesStore.data.items[i].data.bienes.length; j++){
				var idBien = lotesStore.data.items[i].data.bienes[j].idBien;
				var numActivo = lotesStore.data.items[i].data.bienes[j].numActivo;
				if(numActivo == null || numActivo == "" || numActivo == "0"){
					bienesSinNumActivo.push(idBien);
				}
			}				
		}
		return bienesSinNumActivo;	
	}
	
    function expandedRowLote(obj, record, body, rowIndex){ 
    	
	    var absId = record.get('id');
	
	 	var row = "myrow-bien-" + record.get("idLote");
		    
		var bienes = record.get('bienes');
		
		if (bienes.length) {
			var dynamicStoreBienes = new Ext.data.JsonStore({
				fields: [
						'idBien'
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
			
			
		    var smCheckBien = new Ext.grid.CheckboxSelectionModel({
		    		dataIndex: 'envioCDD'
       	        	,checkOnly : !isAsuntoPropiedadBankia() 
       	        	,sortable: false
       	        	,singleSelect: isAsuntoPropiedadBankia() 
       	        	,hidden: isAsuntoPropiedadBankia()       	        	   
       	        	,listeners: { 
       	        	
       	        		// Al seleccionar un bien, sino estamos en Sareb lo añadimos al saco de bienes, comprobando que no esté ya.			
			            rowselect: function( sel, rowIndex, record ) {
							//Habilitamos operaciones masivas
							btnEditarRevisionCargas.setDisabled(false);
							btnAgregarBienCargas.setDisabled(false);
							btnBorrarRelacionContratoBien.setDisabled(false);
							btnAddRelacionContratoBien.setDisabled(false);
							
			            	if(!isAsuntoPropiedadBankia()) {
				            	var idBien = record.get("idBien");
			            		var pos = bienesSeleccionados.indexOf(idBien);
			            		if (pos==-1) {
			            			bienesSeleccionados.push(record.get("idBien"));
			            		}
				            }
				            updateStatusBtnSolicitarNumerosActivos();				           
			            // Al deseleccionar un bien	lo quitamos del saco de bienes
			            }, rowdeselect: function( sel, rowIndex, record ) {
			            	if(!isAsuntoPropiedadBankia()) {   	
				            	var idBien = record.get("idBien");
			            		var pos = bienesSeleccionados.indexOf(idBien);
			            		if (pos!=-1) {
			            			bienesSeleccionados.splice(pos,1);
			            		}	            		
			            	}
			            	
			            	//Si no hay bienes seleccionados desabilitamos operaciones masivas
			            	
			            	if(bienesSeleccionados.length == 0){
								btnEditarRevisionCargas.setDisabled(true);
								btnAgregarBienCargas.setDisabled(true);
								btnBorrarRelacionContratoBien.setDisabled(true);
								btnAddRelacionContratoBien.setDisabled(true);
			            	}  
							updateStatusBtnSolicitarNumerosActivos();							
			            }
					}
			});
	
		  	var bienesCM = new Ext.grid.ColumnModel(
		  			  				    			  	
				  	[
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
					]
			);
		   		   
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
	
	expanderLote.on('collapse', function(obj, record, body, rowIndex){
		// Al colapsar un lote, quitamos todos sus bienes seleccionados del saco de bienes,
		// porque al expandirlo apareceran todos sin seleccionar.
		Ext.each(record.get("bienes"), function(bien, index) {

	  		var pos = bienesSeleccionados.indexOf(bien.idBien);
	  		if (pos!=-1) {
	  			bienesSeleccionados.splice(pos,1);
	  		}	
	
		});
	
	
	});
	
	

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
