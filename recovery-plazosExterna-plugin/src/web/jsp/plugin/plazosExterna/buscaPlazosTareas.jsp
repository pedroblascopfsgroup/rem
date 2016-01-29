<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	Ext.util.CSS.createStyleSheet(".icon_plazos { background-image: url('../img/plugin/plazosExterna/clock-select.png');}");
	
	<pfsforms:ddCombo name="filtroProcedimiento"
		labelKey="plugin.plazosExterna.busqueda.procedimiento"
		label="**Tipo de procedimiento" value="" dd="${tiposProcedimiento}" 
		width="280" />
	
	var idTareaProcedimientoRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcion'}
	]);
	
	var idTareaProcedimientoStore = page.getStore({
		flow:'plugin.plazosExterna.buscarTareasProcedimiento'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id'
			,root:'idTareaProc'
		},idTareaProcedimientoRecord)
	});
	
	var filtroTareaProcedimiento =new Ext.form.ComboBox({
		store: idTareaProcedimientoStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.plazosExterna.editarPlazo.tareas" text="**Tareas" />'
		,width:280
		,value:''
	});
	
	
	var recargarIdTareaProcedimiento = function(){
		filtroTareaProcedimiento.store.removeAll();
		filtroTareaProcedimiento.clearValue();
		if (filtroProcedimiento.getValue()!=null && filtroProcedimiento.getValue()!=''){
			idTareaProcedimientoStore.webflow({id:filtroProcedimiento.getValue()});
		}
		
	}
	
	
	filtroProcedimiento.on('select', function(){
		recargarIdTareaProcedimiento();
	});
	
 
// *************************************************************** //
// ***  AÑADIMOS BUSQUEDA DE PLAZAS FILTRANDO POR DESCRIPCION  *** //
// *************************************************************** //
	var codPlaza = '';
	
	var decenaInicio = 0;
	var dsplazas = new Ext.data.Store({
		autoLoad: false,
		baseParams: {limit:10, start:0},
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('plugin/plazosExterna/plugin.plazosExterna.plazasPorDescripcion')
		}),
		reader: new Ext.data.JsonReader({
			root: 'plazas'
			,totalProperty: 'total'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	
	
	var filtroPlaza = new Ext.form.ComboBox ({
		store:  dsplazas,
		allowBlank: true,
		blankElementText: '--',
		disabled: false,
		displayField: 'descripcion', 	// descripcion
		valueField: 'codigo', 		// codigo
		fieldLabel: '<s:message code="plugin.plazosExterna.busqueda.plazas" text="**Plaza de Juzgado" />',		// Pla de juzgado
		loadingText: 'Searching...',
		width: 300,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});	
	
	
	<c:if test="${filtroPlaza.value!=null}">
		codPlaza='${filtroPlaza.value}';
	</c:if>	
		
	Ext.onReady(function() {
		decenaInicio = 0;
		if (codPlaza!=''){
			Ext.Ajax.request({
					url: page.resolveUrl('plugin/plazosExterna/plugin.plazosExterna.plazasPorCod')
					,params: {codigo: codPlaza}
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText)
						decenaInicio = (r.paginaParaPlaza);
						dsplazas.baseParams.start = decenaInicio;	
						filtroPlaza.store.reload();
						dsplazas.on('load', function(){  
							filtroPlaza.setValue(codPlaza);
							dsplazas.events['load'].clearListeners();
						});
					}				
			});
		}
	});
	filtroPlaza.on('afterrender', function(combo) {
		combo.mode='remote';
	});
	
	
	
	
		<%--
		 
	<pfsforms:ddCombo name="filtroPlaza"
		labelKey="plugin.plazosExterna.busqueda.plazas"
		label="**Plazas" value="" dd="${plazas}" 
		 />	
		 
	 		
	--%>
		 
	
	
	 <%--
	var idTipoJuzgadoStore = new Ext.data.Store({
		autoLoad: false,
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('plugin/plazosExterna/plugin.plazosExterna.juzgadosPorDesc')
		}),
		reader: new Ext.data.JsonReader({
			idProperty: 'codigo'
			,root: 'juzgados'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	
	var filtroJuzgado =new Ext.form.ComboBox({
		store: idTipoJuzgadoStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,loadingText: 'Searching...'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.plazosExterna.editarPlazo.tipJuzgado" text="**Tipo de Juzgado" />'
		,width:400
		,value:''
		
	});
	var codJuzgado='';
	
	codJuzgado='${filtroJuzgado.value}';	
	
	Ext.onReady(function() {
		if (codJuzgado!=''){
			Ext.Ajax.request({
					,params: {descripcion: codJuzgado,codigo:filtroPlaza.getValue()}
					,method: 'POST'
					,success: function (result, request){	
						filtroJuzgado.store.reload();
						idTipoJuzgadoStore.on('load', function(){  
							filtroJuzgado.setValue(codJuzgado);
							idTipoJuzgadoStore.events['load'].clearListeners();
						});
					}				
			});
		}
	});
	filtroJuzgado.on('afterrender', function(combo) {
		combo.mode='remote';
	});
	--%>
	var idTipoJuzgadoRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcion'}
	]);
	
	var idTipoJuzgadoStore = page.getStore({
		flow:'plugin.plazosExterna.buscarJuzgadosPlaza'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id'
			,root:'juzgado'
		},idTipoJuzgadoRecord)
	});
	
	var filtroJuzgado =new Ext.form.ComboBox({
		store: idTipoJuzgadoStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.plazosExterna.editarPlazo.tipJuzgado" text="**Tipo de Juzgado" />'
		,width:300
		,value:''
		
	});	
	
	
	var recargarIdTipoJuzgado = function(){
		filtroJuzgado.store.removeAll();
		filtroJuzgado.clearValue();
		if (filtroPlaza.getValue()!=null && filtroPlaza.getValue()!=''){
			idTipoJuzgadoStore.webflow({codigo:filtroPlaza.getValue()});
		}
		
	}
	
	filtroPlaza.on('select', function(){
		recargarIdTipoJuzgado();
		filtroJuzgado.setDisabled(false);
	});
	     
			 			
				
	<pfs:defineRecordType name="PlazosTareasRT">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="tipoProcedimiento" />
			<pfs:defineTextColumn name="tareaProcedimiento" />
			<pfs:defineTextColumn name="tipoPlaza" />
			<pfs:defineTextColumn name="tipoJuzgado" />
			<pfs:defineTextColumn name="scriptPlazo" />
			<pfs:defineTextColumn name="absoluto" />
			<pfs:defineTextColumn name="observaciones" />		
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="plazosTareasCM">
		<pfs:defineHeader dataIndex="tipoProcedimiento"
			captionKey="plugin.plazosExterna.busqueda.tipoProcedimiento" caption="**Tipo de Procedimiento"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="tareaProcedimiento"
			captionKey="plugin.plazosExterna.busqueda.tipoTarea" caption="**Tipo de Tarea"
			sortable="true" />
		<pfs:defineHeader dataIndex="tipoPlaza"
			captionKey="plugin.plazosExterna.busqueda.tipoPlaza" caption="**Plaza"
			sortable="true" />
		<pfs:defineHeader dataIndex="tipoJuzgado"
			captionKey="plugin.plazosExterna.busqueda.tipoJuzgado" caption="**Juzgado"
			sortable="true" />
		<pfs:defineHeader dataIndex="scriptPlazo"
			captionKey="plugin.plazosExterna.busqueda.scriptPlazo" caption="**Script Plazo"
			sortable="true" />
		<pfs:defineHeader dataIndex="absoluto"
			captionKey="plugin.plazosExterna.busqueda.editable" caption="**Editable"
			sortable="true" />
		<pfs:defineHeader dataIndex="observaciones"
			captionKey="plugin.plazosExterna.busqueda.observaciones" caption="**Observaciones"
			sortable="true" />
		
	</pfs:defineColumnModel>
	
	
	
	<pfs:defineParameters name="getParametros" paramId="" 
		filtroProcedimiento="filtroProcedimiento"
		idTareaProcedimiento="filtroTareaProcedimiento"
		idTipoJuzgado="filtroJuzgado" 
		idTipoPlaza="filtroPlaza" />
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="plugin.plazosExterna.borraPlazo" 
		paramId="id"  
		datagrid="plazosGrid" 
		novalueMsgKey="plugin.plazosExterna.listado.novalor"
		parameters="getParametros"/>
	
	<%--
		if (plazosGrid.getSelectionModel().getSelected().get('absoluto')=0){
				Ext.Msg.alert('<s:message code="plugin.plazosExterna.listado.editar" text="**Editar Plazo" />','<s:message code="plugin.plazosExterna.listado.noEditable" text="**Plazo no editable" />');
				}else{}
	 --%>
	
	<pfs:button caption="**Editar Plazo" name="btEditar" captioneKey="plugin.plazosExterna.listado.editar" iconCls="icon_edit" >
		if (plazosGrid.getSelectionModel().getCount()>0){
			var id = plazosGrid.getSelectionModel().getSelected().get('id');
			var edit = plazosGrid.getSelectionModel().getSelected().get('absoluto');
			if(edit='Si'){
				var parametros = {
					id : id
					,getParametros : getParametros
				};
    			var w= app.openWindow({
                        flow: 'plugin.plazosExterna.editarPlazo'
                       ,closable: true                  
                       ,width : 700
                       ,title : '<s:message code="plugin.plazosExterna.busqueda.modificar" text="**Modificar" />'
                       ,params: parametros
                });
           	 	w.on(app.event.DONE, function(){
						w.close();
						//plazosGrid.store.webflow(parametros);
						//recargar() ;
							
				});
				w.on(app.event.CANCEL, function(){
						 w.close(); 
				});
				
			}else{
				alert('<s:message code="plugin.plazosExterna.listado.noEditable" 
				text="**El plazo seleccionado no es editable" />')	
			}	
		}else{
			Ext.Msg.alert('<s:message code="plugin.plazosExterna.listado.editar" text="**Editar Plazo" />','<s:message code="plugin.plazosExterna.listado.novalor" text="**Debe seleccionar un valor de la lista" />');
		}
		
	</pfs:button>
			
	<pfs:searchPage searchPanelTitle="**Búsqueda de Plazos de Tareas"  searchPanelTitleKey="plugin.plazosExterna.busqueda.panel.title" 
			columnModel="plazosTareasCM" columns="2"
			gridPanelTitleKey="plugin.plazosExterna.configuracion.menu" gridPanelTitle="**Plazos de Tareas Externas" 
			createTitleKey="plugin.plazosExterna.busqueda.grid.nuevo" createTitle="**Nuevo plazo de Tarea" 
			createFlow="plugin.plazosExterna.altaPlazoTarea" 
			updateFlow="plugin.plazosExterna.consultarPlazoTarea" 
			updateTitleData="tareaProcedimiento"
			dataFlow="plugin.plazosExterna.buscaPlazosData"
			resultRootVar="plazos" resultTotalVar="total"
			recordType="PlazosTareasRT" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			gridName="plazosGrid"
			buttonDelete="btBorrar, btEditar"
			iconCls="icon_plazos"  >
			<pfs:items
			items="filtroProcedimiento,filtroTareaProcedimiento"
			/>
			<pfs:items
			items="filtroPlaza,filtroJuzgado"
			/>			
	</pfs:searchPage>
	
	btnNuevo.hide();
	btBorrar.hide();
	btEditar.hide();
	
	<sec:authorize ifAllGranted="ROLE_ADDPLAZOSEXT">
		btnNuevo.show();
	</sec:authorize>
	
	<sec:authorize ifAllGranted="ROLE_BORRAPLAZOSEXT">
		btBorrar.show();
	</sec:authorize>
	
	<sec:authorize ifAllGranted="ROLE_EDITPLAZOSEXT">
		btEditar.show();
	</sec:authorize>
	 
	

</fwk:page>


