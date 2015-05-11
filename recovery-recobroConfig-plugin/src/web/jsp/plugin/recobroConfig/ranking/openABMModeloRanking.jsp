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

	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>

	<pfs:textfield name="filtroNombre"
			labelKey="plugin.recobroConfig.modeloRanking.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	filtroNombre.id='filtroNombreOpenABMModeloRanking';		
				
	<pfsforms:ddCombo name="filtroVariablesRanking"
		labelKey="plugin.recobroConfig.modeloRanking.variablesRanking"
		label="**Variables de ranking" value="" dd="${variables}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
		
	filtroVariablesRanking.id='filtroVariablesRankingRanking';			
				
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.recobroConfig.modeloRanking.estadoPeticion"
		label="**Estado petición" value="" dd="${ddEstados}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
    
    filtroEstado.id = 'filtroEstadoABMRanking';
  	
	<pfs:defineRecordType name="ModeloRanking">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="estado" />
			<pfs:defineTextColumn name="codigoEstado" />
			<pfs:defineTextColumn name="propietario" />
			<pfs:defineTextColumn name="idPropietario" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="modelorankingCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.modeloRanking.columna.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.modeloRanking.columna.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="estado"
			captionKey="plugin.recobroConfig.modeloRanking.columna.estado" caption="**Estado"
			sortable="true" />
		<pfs:defineHeader dataIndex="propietario"
			captionKey="plugin.recobroConfig.modeloRanking.columna.propietario" caption="**Propietario"
			sortable="true" />																
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" variableRanking="filtroVariablesRanking" estado="filtroEstado"/>
		
	var btBorrar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,id: 'btBorrarOpenABMModeloRanking'
		,disabled : true
		,handler : function(){
			if (modelosRankingGrid.getSelectionModel().getCount()>0){
					Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
	    				if (btn == 'yes'){
	    					var parms = getParametros();
	    					parms.id = modelosRankingGrid.getSelectionModel().getSelected().get('id');
	    					page.webflow({
								flow: 'recobromodeloderanking/borrarModeloRanking'
								,params: parms
								,success : function(){ 
									modelosRankingGrid.store.webflow(parms);
									variablesRankingGrid.store.webflow({idModelo:modelosRankingGrid.getSelectionModel().getSelected().get('id')}); 
								}
							});
	    				}
					});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.modeloRanking.borrar.errorEstado" text="**No se puede eliminar este modelo de ranking porque está bloqueado" />');
			}
		}
	});	
	
	
		
	var btnEditar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.editar" text="**Editar" />'
		<app:test id="btnEditar" addComa="true" />
		,iconCls : 'icon_edit'
		,id: 'btnEditarOpenABMModeloRanking'
		,disabled : true
		,handler :  function(){
			if (modelosRankingGrid.getSelectionModel().getCount()>0){
				var rec = modelosRankingGrid.getSelectionModel().getSelected();
		    	var w= app.openWindow({
								flow: 'recobromodeloderanking/editModeloRanking'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.modeloRanking.btnEditar" text="Editar modelo de ranking" />'
								,params: {idModelo:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								modelosRankingGrid.store.webflow(getParametros());
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloRanking.btnEditar" text="**Editar modelo de ranking" />','<s:message code="plugin.recobroConfig.modeloRanking.borrar.noValor" text="Debe seleccionar un esquema de la lista" />');
			}				
		}
	});	
	
	var btCopiar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />'
		,iconCls : 'icon_copy'
		,id: 'btCopiarOpenABMModeloRanking'
		,disabled : true
		,handler : function(){
			if (modelosRankingGrid.getSelectionModel().getCount()>0){
    					var parms = getParametros();
    					parms.idModelo = modelosRankingGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobromodeloderanking/copiarModeloRanking'
							,params: parms
							,success : function(){ 
								modelosRankingGrid.store.webflow(parms);
								variablesRankingGrid.store.webflow({idModelo:modelosRankingGrid.getSelectionModel().getSelected().get('id')}); 
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />','<s:message code="plugin.recobroConfig.modeloRanking.noSeleccionado" text="**Debe seleccionar el modelo de ranking que desea copiar" />');
			}
		}
	});	
	
	var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,id: 'btLiberarOpenABMModeloRanking'
		,handler : function(){
			if (modelosRankingGrid.getSelectionModel().getCount()>0){
				// comprobar estado != en definicion 
    					var parms = getParametros();
    					parms.idModelo = modelosRankingGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobromodeloderanking/liberarModeloRanking'
							,params: parms
							,success : function(){ 
								modelosRankingGrid.store.webflow(parms);
								variablesRankingGrid.store.webflow({idModelo:modelosRankingGrid.getSelectionModel().getSelected().get('id')}); 
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />','<s:message code="plugin.recobroConfig.modeloRanking.liberar.error" text="**Debe seleccionar el modelo de ranking que desea liberar" />');
			}
		}
	});	
	
	var limit=25;
	var DEFAULT_WIDTH=700;

	
	<pfs:remoteStore name="dataStore" 
		resultRootVar="modelos" 
		resultTotalVar="total" 
		recordType="ModeloRanking" 
		dataFlow="recobromodeloderanking/buscaModelosRanking" />


	var validarAntesDeBuscar = function(){
		buscarFunc();
	};


	var buscarFunc = function(){
                var params= getParametros();
                params.start=0;
                params.limit=limit;
                dataStore.webflow(params);
				//Cerramos el panel de filtros y esto hará que se abra el listado de personas
				filtroForm.collapse(true);
	};	
	
	var btnBuscar=app.crearBotonBuscar({
		handler : validarAntesDeBuscar
	});
	
	var btnReset = app.crearBotonResetCampos(getParametros_camposFormulario);
	
	var btnNuevo = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.nuevo" text="**Nuevo modelo de ranking" />'
		<app:test id="btnNuevo" addComa="true" />
		,iconCls : 'icon_mas'
		,id: 'btnNuevoOpenABMModeloRanking'
		,disabled : false
		,handler :  function(){
		    	var w= app.openWindow({
								flow: 'recobromodeloderanking/altaModeloRanking'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.modeloRanking.nuevo" text="Nueva política de acuerdos" />'
								,params: {}
							});
							w.on(app.event.DONE, function(){
								w.close();
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
		}
	});	
	
	var filtroForm = new Ext.Panel({
		title : '<s:message code="plugin.recobroConfig.modeloRanking.tabName" text="**Configuración de Modelos de Ranking" />'
		,autoHeight:true
		,autoWidth:true
		,layout:'table'
		,layoutConfig:{columns:3}
		,titleCollapse : true
		,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,style: 'vertical-align: top'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[
			{width:'0px'}
			,{
				layout:'form'
				,items:[ filtroNombre, filtroVariablesRanking]
			}
			,{
				layout:'form'
				,items:[ filtroEstado]
			}
		]
		,tbar : [btnBuscar, btnReset, btnNuevo]
		,listeners:{	
			beforeExpand:function(){
				modelosRankingGrid.collapse(true);
				modelosRankingGrid.setHeight(200);
				variablesRankingGrid.collapse(true);
				variablesRankingGrid.setHeight(200);			
			}
			,beforeCollapse:function(){
				modelosRankingGrid.expand(true);
				modelosRankingGrid.setHeight(200);
				variablesRankingGrid.collapse(true);
				variablesRankingGrid.setHeight(200);	
			}
		}
		
	});	
	
	
	var pagingBar=fwk.ux.getPaging(dataStore);
	var cfg={
		title : '<s:message code="plugin.recobroConfig.modeloRanking.grid.title" text="**Modelos de ranking" />'
		,id: 'modelosRankingGridOpenABMModeloRanking'	
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,stripeRows:true
		,bbar : [  pagingBar,btBorrar,btnEditar,btCopiar,btLiberar]
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,iconCls:'icon_ranking'
	};
	var modelosRankingGrid=app.crearGrid(dataStore,modelorankingCM,cfg);
	
	
	<%-- grid de carteras de un esquema --%>
		
	var btBorrarVariableRanking= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,disabled : true
		,id: 'btBorrarVariableRankingOpenABMModeloRanking'
		,handler : function(){
			if (variablesRankingGrid.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = {}
    					parms.id = variablesRankingGrid.getSelectionModel().getSelected().get('id');
    					parms.idModelo = variablesRankingGrid.getSelectionModel().getSelected().get('idModelo');
    					page.webflow({
							flow: 'recobromodeloderanking/borrarVariableModeloRanking'
							,params: parms
							,success : function(){ 
								variablesRankingGrid.store.webflow({idModelo:variablesRankingGrid.getSelectionModel().getSelected().get('idModelo')}); 
							}
						});
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		}
	});		
		
	var btnAgregarVariableRanking = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.variable.nuevo" text="**Añadir palanca" />'
		<app:test id="btnAgregarVariableRanking" addComa="true" />
		,iconCls : 'icon_mas'
		,disabled : true
		,id: 'btnAgregarVariableRankingOpenABMModeloRanking'
		,handler :  function(){
			if (modelosRankingGrid.getSelectionModel().getCount()>0){
				var rec = modelosRankingGrid.getSelectionModel().getSelected();
		    	var w= app.openWindow({
								flow: 'recobromodeloderanking/addVariableRankingModelo'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.modeloRanking.variable.nuevo" text="Añadir palanca" />'
								,params: {idModelo:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								variablesRankingGrid.store.webflow({idModelo:rec.get('id')});
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloRanking.variable.nuevo" text="**Añadir palanca" />','<s:message code="plugin.recobroConfig.politicaPalanca.addPalanca.noValor" text="Debe seleccionar una politica de la lista" />');
			}				
		}
	});	
	
	var btnEditarVariable = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.variable.editar" text="**Editar palanca" />'
		<app:test id="btnEditarVariable" addComa="true" />
		,iconCls : 'icon_edit'
		,disabled : true
		,id: 'btnEditarVariableRankingOpenABMModeloRanking'
		,handler :  function(){
			if (variablesRankingGrid.getSelectionModel().getCount()>0){
				var rec = variablesRankingGrid.getSelectionModel().getSelected();
		    	var w= app.openWindow({
								flow: 'recobromodeloderanking/editarVariableModelo'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.modeloRanking.variable.editar" text="**Editar palanca" />'
								,params: {idVariable:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								variablesRankingGrid.store.webflow({idModelo:rec.get('idModelo')});
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloRanking.variable.editar" text="**Editar palanca" />','<s:message code="plugin.recobroConfig.politicaPalanca.editPalanca.noValor" text="Debe seleccionar una palanca de la lista" />');
			}				
		}
	});		
	 
	<pfs:defineRecordType name="VariableRanking">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="idModelo" />
			<pfs:defineTextColumn name="tipoVariable" />
			<pfs:defineTextColumn name="coeficiente" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="variableCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.variableRanking.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="idModelo"
			captionKey="plugin.recobroConfig.variableRanking.idModelo" caption="**IdModelo"
			sortable="true"  hidden="true"/>	
		<pfs:defineHeader dataIndex="tipoVariable"
			captionKey="plugin.recobroConfig.variableRanking.tipoVariable" caption="**Tipo Variable"
			sortable="true" />	
		<pfs:defineHeader dataIndex="coeficiente"
			captionKey="plugin.recobroConfig.variableRanking.coeficiente" caption="**Coeficiente"
			sortable="true" />							
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="variableStore" 
		resultRootVar="variables" 
		recordType="VariableRanking" 
		dataFlow="recobromodeloderanking/buscaVariablesRanking" />
		
	
	var cfgVariable={
		title : '<s:message code="plugin.recobroConfig.VariablesRankingPolitica.gridVariables.title" text="**VariablesRanking asociadas con la política de acuerdos" />'
		,collapsible : true
		,id: 'variablesRankingGridOpenABMModeloRanking'
		,collapsed: true
		,titleCollapse : true
		,stripeRows:true
		,bbar : [btBorrarVariableRanking,btnAgregarVariableRanking,btnEditarVariable]
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
	};
	
	var variablesRankingGrid=app.crearGrid(variableStore,variableCM,cfgVariable);
	
	<%--Ahora hacemos los métodos para visualizar el grid de carteras --%>
	var createTitle = function(row){
		return row.get('nombre');
	}; 
	 
	modelosRankingGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	var w= app.openWindow({
								flow: 'recobromodeloderanking/editModeloRanking'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.modeloRanking.btnEditar" text="Editar política" />'
								,params: {idModelo:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								modelosRankingGrid.store.webflow(getParametros());
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
    }); 
    
    modelosRankingGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
    	var rec = modelosRankingGrid.getStore().getAt(rowIndex);
    	var idModelo = rec.get('id');
    	var codigoEstado = modelosRankingGrid.getSelectionModel().getSelected().get('codigoEstado');
    	var idPropietario = modelosRankingGrid.getSelectionModel().getSelected().get('idPropietario');
    	variableStore.webflow({idModelo:idModelo});
    	variablesRankingGrid.expand(true);
    	if (codigoEstado == ESTADO_BLOQUEADO.getValue()){
    		btBorrar.setDisabled(true);
    		btnEditar.setDisabled(true); 
    		btCopiar.setDisabled(false);
    		btBorrarVariableRanking.setDisabled(true);
    		btnAgregarVariableRanking.setDisabled(true);
    		btnEditarVariable.setDisabled(true);
    		btLiberar.setDisabled(true);
    	} else {
    		if (idPropietario != usuarioLogado.getValue()){
    			btBorrar.setDisabled(true);
    			btnEditar.setDisabled(true); 
    			btBorrarVariableRanking.setDisabled(true);
    			btnAgregarVariableRanking.setDisabled(true);
    			btnEditarVariable.setDisabled(true);
    			btLiberar.setDisabled(true);
    		} else {
    			btBorrar.setDisabled(false);
    			btnEditar.setDisabled(false); 
    			btBorrarVariableRanking.setDisabled(false);
    			btnAgregarVariableRanking.setDisabled(false);
    			btnEditarVariable.setDisabled(false);
    			if (codigoEstado == ESTADO_DEFINICION.getValue()){
    				btLiberar.setDisabled(false);
    			} else {
    				btLiberar.setDisabled(true);
    			}
    		}
    		if (codigoEstado == ESTADO_DEFINICION.getValue()){
    			btCopiar.setDisabled(true);
    		} else {
    			btCopiar.setDisabled(false);
    		}
    	}
    });
    
    variablesRankingGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	var w= app.openWindow({
								flow: 'recobromodeloderanking/editarVariableModelo'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.modeloRanking.variable.editar" text="**Editar palanca" />'
								,params: {idVariable:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								variablesRankingGrid.store.webflow({idModelo:rec.get('idModelo')});
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
    }); 
    
    variablesRankingGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
    	btnEditarVariable.setDisabled(false);
    });
    
    
    
    var mainPanel = new Ext.Panel({
		items : [
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[filtroForm]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[modelosRankingGrid]
			},{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[variablesRankingGrid]
			}
    	]
	    //,bodyStyle:'padding:10px'
	    ,autoHeight : true
	    ,border: false
    });
	
	
	//añadimos al padre y hacemos el layout
	page.add(mainPanel);			
	
	
	btBorrar.hide();
	btnNuevo.hide();
	<sec:authorize ifAllGranted="ROLE_CONF_RANKING">
		btBorrar.show();
		btnNuevo.show();
	</sec:authorize>
	
	
</fwk:page>	