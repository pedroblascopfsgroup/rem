<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
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

	/* Grid Bienes asociados al Contrato */

	var contratoBien = Ext.data.Record.create([
		 {name:'id'}
		,{name:'codInterno'}
		,{name:'importeGarantizado'}
		,{name:'idBien'}
		,{name:'relacion'}
		,{name:'estado'}
		,{name:'tipo'}
		,{name:'detalle'}
		,{name:'refCatastral'}
		,{name:'poblacion'}
		,{name:'importeCargas'}
		,{name:'valorActual'}
		,{name:'superficie'}		
       	,{name:'origen'}
       	,{name:'fechaTasacion'}		
       	,{name:'valorTasacion'}
       	,{name:'participacion'}
       	,{name:'personas'}
       	,{name:'idPersona'}
    ]);

	var contratoBienesStore = page.getStore({
		event:'listado'
		,storeId : 'idContratoBienesStore'
		,flow:'plugin/nuevoModeloBienes/contratos/contratoBienesData'
		,reader : new Ext.data.JsonReader({root:'contratosBienes'}, contratoBien)
	});
	
	entidad.cacheStore(contratoBienesStore);
	
 	var contratoBienesCM  = new Ext.grid.ColumnModel([
        {header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaEstadoBien" text="**Estado"/>',width:52, sortable: true, dataIndex: 'estado', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaIdBien" text="**idBien"/>', sortable: true, dataIndex: 'idBien'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaCodInterno" text="**codInterno"/>', sortable: true, dataIndex: 'codInterno'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaTipoBien" text="**Tipo"/>', sortable: true, dataIndex: 'tipo'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaDescripcionBien" text="**Descripción"/>', sortable: true, dataIndex: 'detalle'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaImporteGarantizado" text="**Importe garantizado"/>', align:'right', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeGarantizado'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaValorActualBien" text="**Valor actual"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'valorActual', align:'right', hidden: true }
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaRefCatastralBien" text="**Ref. Catastral"/>',hidden:true, sortable: true, dataIndex: 'refCatastral'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaPoblacionBien" text="**Población"/>', sortable: true, dataIndex: 'poblacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaImporteCargasBien" text="**Cargas"/>', hidden:true, renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeCargas', align:'right',width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaFechaTasacion" text="**Tasación"/>', width:60, sortable: true, dataIndex: 'fechaTasacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaValorTasacion" text="**Valor Tasación"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'valorTasacion', align:'right', hidden: true }
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaSuperficieBien" text="**Superficie"/>',
        	renderer: function (pnumber) {if (pnumber=="---"){return "";} if(pnumber!=null && pnumber!="") {var result = app.format.formatNumber(pnumber,2); return String.format("{0} m<sup>2</sup>",result);}return null;}, sortable: true, dataIndex: 'superficie', align:'right', width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaOrigenBien" text="**Carga"/>', hidden:true, sortable: true, dataIndex: 'origen', align:'right', width:60}
		,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaParticipacionBien" text="**Participacion"/>', 
			dataIndex: 'participacion', renderer: function (val){if (val=="---"){return "";} var result = app.format.formatNumber(val,2);return String.format("{0} %",result);}, align:'right',width:60}
		,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaPersonasBien" text="**Personas"/>', sortable: true, dataIndex: 'personas'}
		,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaIdPersona" text="**idPersona"/>', sortable: true, dataIndex: 'idPersona', hidden: true}
    ]);
 
    var grid= app.crearGrid(contratoBienesStore,contratoBienesCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.contrato.gridBienes.titulo" text="**Bienes"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_bienes'
        ,height : 222
    });
	
	
	
	var bandera = 0;
	<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		grid.on('rowdblclick',function(grid, rowIndex, e){
			var rec = grid.getStore().getAt(rowIndex);
			var idBien= rec.get('idBien');
			var desc = idBien + ' ' +  rec.get('tipo');
			if(!idBien)	return;
			app.abreBien(idBien,desc);
		});
		bandera = 1;
	</sec:authorize>
	
	if (bandera == 0) {
		grid.on('rowdblclick',function(grid, rowIndex, e){
			var rec = grid.getStore().getAt(rowIndex);
			var idBien= rec.get('idBien');
			var idPersona= rec.get('idPersona');
			if(!idBien || !idPersona)	return;
			var w = app.openWindow({
				flow : 'editbien/openByIdBien'
				,width:760
				,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />'
				,params : {idPersona:idPersona, id:idBien}
			});
			w.on(app.event.DONE, function(){
				w.close();
				contratoBienesStore.webflow({idContrato:  panel.getContratoId()});   
				contratoSolvenciasStore.webflow({idContrato:  panel.getContratoId()}); 
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		});
	}
	
	/* Grid Bienes asociados al Contrato */
	
	var personaSolvencia = Ext.data.Record.create([
		  {name:'idPersona'}
		 ,{name:'apellidoNombre'}
		 ,{name:'idPersonaBien'}
		 ,{name:'idBien'}
		 ,{name:'propiedad'}
		 ,{name:'tipo'}
		 ,{name:'detalle'}
		 ,{name:'poblacion'}
		 ,{name:'superficie'}
		 ,{name:'importeCargas'}
		 ,{name:'valorActual'}
		 ,{name:'origen'}
		 ,{name:'contrato'}
		 ,{name:'tipoGarantia'}
		 ,{name:'importeGarantizado'}
    ]);

	var contratoSolvenciasStore = page.getStore({
		event:'listado'
		,storeId : 'idContratoSolvenciasStore'
		,flow:'plugin/nuevoModeloBienes/contratos/contratoSolvenciasData'
		,reader : new Ext.data.JsonReader({root:'personasSolvencias'}, personaSolvencia)
	});
	
	entidad.cacheStore(contratoSolvenciasStore);    
	
 	var contratoSolvenciasCM  = new Ext.grid.ColumnModel([
          {header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaIdPersona" text="**idPersona"/>',width:52, sortable: true, dataIndex: 'idPersona', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaInterviniente" text="**Interviniente"/>', sortable: true, dataIndex: 'apellidoNombre'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaidPersonaBien" text="**idPersonaBien"/>', sortable: true, dataIndex: 'idPersonaBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaidBien" text="**idBien"/>', sortable: true, dataIndex: 'idBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaPropiedad" text="**% Propiedad"/>', 
			dataIndex: 'propiedad', renderer: function (val){if (val=="---"){return "";} var result = app.format.formatNumber(val,2);return String.format("{0} %",result);}, align:'right', width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaTipo" text="**Tipo"/>', sortable: true, dataIndex: 'tipo'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaDescripcion" text="**Descripción"/>', sortable: true, dataIndex: 'detalle'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaPoblacion" text="**Población"/>', sortable: true, dataIndex: 'poblacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaSuperficie" text="**Superficie"/>', hidden:true,
        	renderer: function (pnumber) {if (pnumber=="---"){return "";} if(pnumber!=null && pnumber!="") {var result = app.format.formatNumber(pnumber,2); return String.format("{0} m<sup>2</sup>",result);}return null;}, sortable: true, dataIndex: 'superficie', align:'right', width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaCargas" text="**Cargas"/>', hidden:true, renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeCargas', align:'right', width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaValorActual" text="**Valor actual"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'valorActual', align:'right', width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.solvenciaColumnaOrigen" text="**Origen"/>', sortable: true, dataIndex: 'origen', align:'right', width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.columnaContratosBien" text="**Contratos"/>', sortable: true, dataIndex: 'contrato', align:'right', width:60}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.columnaTipoGarantia" text="**Tipo garantía"/>', sortable: true, dataIndex: 'tipoGarantia'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.contrato.columnaImporteGarantizado" text="**Importe garantizado"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeGarantizado', align:'right'}
    ]);
 
    var gridSolvencia = app.crearGrid(contratoSolvenciasStore, contratoSolvenciasCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.contrato.gridSolvencia.titulo" text="**Solvencia de los intervinientes"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_bienes'
        ,height : 220
    });
	
	
	 
	 bandera = 0;
	<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		gridSolvencia.on('rowdblclick',function(grid, rowIndex, e){
			var rec = grid.getStore().getAt(rowIndex);
			var idBien= rec.get('idBien');
			var desc = idBien + ' ' +  rec.get('tipo');
			if(!idBien)	return;
			app.abreBien(idBien,desc);
		});
		 bandera = 1;
	</sec:authorize>
	
	if (bandera == 0) {
		gridSolvencia.on('rowdblclick',function(grid, rowIndex, e){
			var rec = grid.getStore().getAt(rowIndex);
			var idBien= rec.get('idBien');
			var idPersona= rec.get('idPersona');
			if(!idBien || !idPersona)	return;
			var w = app.openWindow({
				flow : 'editbien/openByIdBien'
				,width:760
				,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />'
				,params : {idPersona:idPersona, id:idBien}
			});
			w.on(app.event.DONE, function(){
				w.close();
				contratoBienesStore.webflow({idContrato:  panel.getContratoId()});   
				contratoSolvenciasStore.webflow({idContrato:  panel.getContratoId()}); 
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		});
	}
	
	var panel = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.contrato.tabBienes.titulo" text="**Bienes"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [grid, gridSolvencia]
		,nombreTab : 'tabContratoBienes'
	});
	
	panel.getContratoId = function(){return entidad.get("data").id;}
	
	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");

		entidad.cacheOrLoad(data, contratoBienesStore, { idContrato : data.id } );
		entidad.cacheOrLoad(data, contratoSolvenciasStore, { idContrato : data.id } );

		var esVisible = [];
		entidad.setVisible(esVisible);
	}

	panel.setVisibleTab = function(data){
		return true;
	}
  
	return panel;
})