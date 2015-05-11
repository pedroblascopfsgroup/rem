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
	
	var cssIconDownList = 'background-image: url(\'../css/downList.png\');background-repeat:no-repeat;background-position:right;'; 
	
	var ancId;
	var idContrato=0;
	var inicializada = false;
	
	var panel = new Ext.Panel({
			title: '<s:message code="plugin.nuevoModeloBienes.analisisContratos.titulo" text="**Análisis de contratos" />'
			,autoHeight: true
			,nombreTab : 'tabAnalisisContratosNew'			
		});
	
	panel.getAsuntoId = function(){ return entidad.get("data").id; }


<%-- renders --%>

	var text_edit = new Ext.form.TextField();
	
	var num_edit = new Ext.form.NumberField({
    	maxValue:100,
    	minValue:0,
    	decimalPrecision:0,
    	selectOnFocus:true
    });
    
    var date_edit = new Ext.form.DateField({
    	xtype: 'datefield'
    	//type: 'date'
    	,submitFormat: 'd/m/Y'
    	,format : 'd/m/Y'
    	,renderer: date_renderer
    });
    
    var combo_edit = function (store) {
    	var combo = new Ext.form.ComboBox( {
                            typeAhead : true,
                            triggerAction : 'all',
                            listClass : 'x-combo-list-small',
                            mode: 'local',
                            store: store,
                            displayField: 'descripcion',
                            valueField: 'codigo'
                        })
    	return combo;
    }
        
	var OK_KO_Render = function (value, meta, record) {
		if (value=='Sí' || value=='01' || ''+value=='true') {
			return '<img src="/pfs/css/true.gif" height="16" width="16" alt=""/>';
		}if (value=='No' || value=='02' || ''+value=='false') {
			return '<img src="/pfs/css/false.gif" height="16" width="16" alt=""/>';
		}
		return '';
	};
	
	var SI_NO_Render = function (value, meta, record) {
		if (value=='Sí' || value=='01' || ''+value=='true') {
			return '<s:message code="label.si" text="**S&iacute;" />';
		}if (value=='No' || value=='02' || ''+value=='false') {
			return '<s:message code="label.no" text="**No" />';
		}
		return '';
	};
	
	var POS_NEG_Render = function (value, meta, record) {
		if (value=='Positivo' || value=='01' || ''+value=='true') {
			return '<s:message code="label.positivo" text="**Positivo" />';
		}if (value=='Negativo' || value=='02' || ''+value=='false') {
			return '<s:message code="label.negativo" text="**Negativo" />';
		}
		return '';		
	};

	var FAV_DESFAV_Render = function (value, meta, record) {
		if (value=='Favorable' || value=='01' || ''+value=='true') {
			return '<s:message code="label.favorable" text="**Favorable" />';
		} if (value=='No favorable' || value=='02' || ''+value=='false') {
			return '<s:message code="label.desfavorable" text="**No favorable" />';
		}
		return '';
	};
	
	var date_renderer = Ext.util.Format.dateRenderer('d/m/Y');
	
	var diccionarioRecord = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'codigo'}
		,{name : 'descripcion'}
	]);
	
	var sinoStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'sinoStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	sinoStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDSiNo' });
	
	var posNegStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'posNegStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	posNegStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDPositivoNegativo' });

	var favDesfavStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'favDesfavStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	favDesfavStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDFavorable' });
	
<%--contratos --%>

var contratos = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'asuId'}
		,{name : 'contratoId'}
		,{name : 'contrato'}
		,{name : 'tipoContrato'}
		,{name : 'ejecucionIniciada'}
		,{name : 'revisadoA'}
		,{name : 'propuestaEjecucion'}
		,{name : 'iniciarEjecucion'}
		,{name : 'revisadoB'}
		,{name : 'solicitarSolvencia'}
		,{name : 'fechaSolicitarSolvencia'}
		,{name : 'fechaRecepcion'}
		,{name : 'resultado'}
		,{name : 'decisionB'}
		,{name : 'revisadoC'}
		,{name : 'decisionC'}
		,{name : 'fechaProximaRevision'}
		,{name : 'decisionRevision'}
	]);

	var storeContratos = page.getStore({
		flow : 'analisiscontratos/getAnalisisContratos'
		,storeId : 'storeContratos'
		,baseParams: {limit:10, start:0}
		,reader : new Ext.data.JsonReader({
			root : 'contrato'
	    	,totalProperty : 'total'
			},contratos)
	});
	
	var btnGuardarContratos = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.analisisContrato.btnModificar" text="Modificar" />'
		    ,iconCls : 'icon_ok'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
			,disabled:true
		    ,handler : function(){
		    	var rec = gridContratos.getSelectionModel().getSelected();
				var id = rec.get('id');	
				var contratoId = rec.get('contratoId');	
				var w = app.openWindow({
				  flow : 'analisiscontratos/editAnalisisContratos'
				  ,width:930
				  ,closable:true
				  ,title : "Editar analisis contratos"
				  ,params:{ancId: id , contratoId : contratoId }
				
				});			
				w.on(app.event.DONE, function(){
				  w.close();
				  refresh();
				  
				});
				w.on(app.event.CANCEL, function(){
				  w.close();
				});	
			}			
		});
		
	

	var cmContrato = new Ext.grid.ColumnModel([
		{header  : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.id" text="**id" />', dataIndex : 'id', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.idAsunto" text="**Id Asunto" />', dataIndex : 'asuId', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.idContrato" text="**Id Contrato" />', dataIndex : 'contratoId', hidden:true, id:'colIdContrato'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.contrato" text="**Contrato" />', dataIndex : 'contrato', width: 200}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.tipoContrato" text="**Tipo contrato" />', dataIndex : 'tipoContrato'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.ejecIniciada" text="**Ejecución iniciada" />', dataIndex : 'ejecucionIniciada', renderer: SI_NO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.A.revision" text="**Rev." />', id: 'revisadoA', dataIndex : 'revisadoA', renderer: OK_KO_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.A.propuestaEjec" text="**Propuesta ejecución" />', id: 'propuestaEjecucion', dataIndex : 'propuestaEjecucion', renderer: SI_NO_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.A.iniciaEjec" text="**Iniciar ejecución" />', id: 'iniciarEjecucion', dataIndex : 'iniciarEjecucion', renderer: SI_NO_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.revision" text="**Rev." />', id: 'revisadoB', dataIndex : 'revisadoB', renderer: OK_KO_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.solSolvencia" text="**Solicitar solvencia" />', id: 'solicitarSolvencia', dataIndex : 'solicitarSolvencia', renderer: SI_NO_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.fechaSolSolvencia" text="**F. sol. solvencia" />', id: 'fechaSolicitarSolvencia', dataIndex : 'fechaSolicitarSolvencia'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.fechaRecepcion" text="**F. recepción" />', id: 'fechaRecepcion', dataIndex : 'fechaRecepcion' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.resultado" text="**Resultado" />', id: 'resultado', dataIndex : 'resultado', renderer: POS_NEG_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.decision" text="**Decisión" />', id: 'decisionB', dataIndex : 'decisionB', renderer: POS_NEG_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.C.revision" text="**Rev." />', id: 'revisadoC', dataIndex : 'revisadoC', renderer: OK_KO_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.C.decision" text="**Decisión" />', id: 'decisionC', dataIndex : 'decisionC', renderer: POS_NEG_Render }
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.C.fechaProxRevision" text="**F. próx. revisión" />', dataIndex : 'fechaProximaRevision'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.C.decision" text="**Decisión rev." />', id: 'decisionRevision', dataIndex : 'decisionRevision', renderer: POS_NEG_Render }
	]);
	
	//Cabeceras múltiples para ambos grids
    var rowsCabecera = [
        [
             {colspan: 6 }
             ,{header: '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.A.titulo" text="**Garantías adic. o per."/>', colspan: 3, align: 'center'}
             ,{header: '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.titulo" text="**Garantías adic. o per."/>', colspan: 6, align: 'center'}
             ,{header: '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.C.titulo" text="**Garantía"/>', colspan: 4, align: 'center'}             
        ],[
            {colspan: 6 }
            ,{header: '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.A.subtitulo" text="**(prendas, pignoración, IPF, otros)"/>', colspan: 3, align: 'center'}
            ,{header: '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.B.subtitulo" text="**(fiadores, librado, descuento)"/>', colspan: 6, align: 'center'}
            ,{header: '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.C.subtitulo" text="**hipotecaria"/>', colspan: 4, align: 'center'}         
        ]
    ];
    
    var pluginCabecera = [new Ext.ux.grid.ColumnHeaderGroup({rows: rowsCabecera})];

	
	
	var gridContratos = new Ext.grid.EditorGridPanel({
        store: storeContratos
        ,cm: cmContrato
        ,title : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.contratos.titulo" text="**Contratos" />'
        ,stripeRows: true
        ,height: 300
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,plugins: pluginCabecera
		,bbar:[btnGuardarContratos]
    });
	
	<%--BIENES --%>
	var bien = Ext.data.Record.create([
		{name: 'id'}
		,{name : 'ancId'}
		,{name : 'bienId'}
		,{name : 'codigo'}
		,{name : 'origen'}
		,{name : 'tipo'}
		,{name : 'solicitarNoAfeccion'}
		,{name : 'fechaSolicitarNoAfeccion'}
		,{name : 'fechaResolucion'}
		,{name : 'resolucion'}
	]);
	
	var storeBienes = page.getStore({
		flow : 'analisiscontratos/getBienesContrato'
		,storeId : 'storeBienes'
		,baseParams: {limit:10, start:0}
		,reader : new Ext.data.JsonReader({
			root : 'bienes'
	    	,totalProperty : 'total'
		},bien)
	});	
	
	var cmBien = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.id" text="**id" />', dataIndex : 'id', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.ancId" text="**Id AC" />', dataIndex : 'ancId', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.bienId" text="**Id bien" />', dataIndex : 'bienId', hidden:true}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.codigo" text="**Código" />', dataIndex : 'codigo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.origen" text="**Origen" />', dataIndex : 'origen'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.tipo" text="**Tipo" />', dataIndex : 'tipo'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.solNoAfeccion" text="**Solicitar no afección" />', id: 'solicitarNoAfeccion', dataIndex : 'solicitarNoAfeccion', renderer: SI_NO_Render}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.fechaSolNoAfeccion" text="**F. sol. no afección" />', id: 'fechaSolicitarNoAfeccion', dataIndex : 'fechaSolicitarNoAfeccion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.fechaResolucion" text="**F. resolución" />', id:'fechaResolucion', dataIndex : 'fechaResolucion'}
		,{header : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.resolucion" text="**Resolución" />', id:'resolucion', dataIndex : 'resolucion', renderer: FAV_DESFAV_Render }
	]);
	
	 var btnGuardarBienes = new Ext.Button({
		    text: '<s:message code="" text="Modificar" />'
		    ,iconCls : 'icon_ok'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
			,disabled:true
		    ,handler : function(){
		    	var rec = gridBienes.getSelectionModel().getSelected();
				var id = rec.get('id');	
				var bieId = rec.get('bienId');
				var ultimoRegistro = storeContratos.getCount();
				gridContratos.getSelectionModel().selectRow((ultimoRegistro-1));
				gridContratos.fireEvent('rowclick', gridContratos, (ultimoRegistro-1));
				var rec2 = gridContratos.getSelectionModel().getSelected();
				var ancId = rec2.get('id');	
				if(ancId == ""){
					Ext.Msg.alert('<s:message code="analisisContratos.ancId" text="**Información" />','<s:message code="analisisContratos.ancId.mensaje" text="**Debe modificar primero el análisis de contratos" />');
				} else{
				var w = app.openWindow({
				  flow : 'analisiscontratos/editAnalisisContratosBienes'
				  ,autoWidth:true
				  ,closable:true
				  ,title : "Editar analisis contratos bienes"
				  ,params:{id: id, bieId: bieId, ancId: ancId}	
				});			
				w.on(app.event.DONE, function(){
				  w.close();
				  refresh();
				});
				w.on(app.event.CANCEL, function(){
				  w.close();
				});	
				}
			}
		});
		

	var gridBienes = new Ext.grid.EditorGridPanel({
        store: storeBienes
        ,cm: cmBien
        ,title : '<s:message code="plugin.nuevoModeloBienes.analisisContratos.bienes.titulo" text="**Bienes" />'
        ,stripeRows: true
        ,height: 180
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,bbar:[btnGuardarBienes]
    });
    
   
	
	<%--FIN DE BIENES --%>

	function getArrayParam(store){
		var storeValues=[];
		var allRecords = store.getRange();
		for (i=0;i < allRecords.length;i++){
			var rec = allRecords[i];
			storeValues[i] = rec.data;
		}
		var myArrayParam = new MyArrayParam();
		myArrayParam.arrayItems = storeValues;
		return Ext.encode(myArrayParam);
	} 


	MyArrayParam = function() {
		var arrayItems;
	}
	
	gridBienes.on('rowclick', function(grid, rowIndex, e) {
		btnGuardarBienes.enable();
  	});
   	
   	gridContratos.on('rowclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
       	idContrato = rec.get('contratoId');
       	ancId = rec.get('id');
		if (idContrato != '') {
  				btnGuardarContratos.enable();
  				storeBienes.webflow({'cntId': idContrato});
       	}
   	});
 
 
 	panel.add(gridContratos);
 	panel.add(gridBienes);
 	
	panel.getValue = function() {}
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, storeContratos, {asuId : panel.getAsuntoId(), limit: 10, start:0 } );
		var esSupervisor=data.toolbar.esSupervisor; 
		var esGestor=data.toolbar.esGestor;

		if (!inicializada) {
			inicializada = true;
		}
		
		btnGuardarContratos.disable();
		btnGuardarBienes.disable();
		
		gridContratos.getSelectionModel().clearSelections();
		gridBienes.getSelectionModel().clearSelections();
		
		refresh();
	}

	
	function refresh(){
		storeContratos.webflow({asuId: panel.getAsuntoId() });
		storeBienes.webflow({'cntId': idContrato});
	};
	
	return panel;
})