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
			labelKey="plugin.recobroConfig.politicaAcuerdos.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	filtroNombre.id='filtroNombreOpenABMPoliticaAcuerdos';			
				
	<pfsforms:ddCombo name="filtroTiposPalancas"
		labelKey="plugin.recobroConfig.politicaAcuerdos.tipospalancas"
		label="**Tipos de palanca" value="" dd="${tiposPalancas}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
 
	filtroTiposPalancas.id='filtroTiposPalancasOpenABMPoliticaAcuerdos';				
			
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.recobroConfig.modeloRanking.estadoPeticion"
		label="**Estado petición" value="" dd="${ddEstados}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
    
    filtroEstado.id = 'filtroEstadoABMPoliticaAcuerdos';
			
	<pfs:defineRecordType name="Politicas">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="codigo" />
			<pfs:defineTextColumn name="estado" />
			<pfs:defineTextColumn name="codigoEstado" />
			<pfs:defineTextColumn name="propietario" />
			<pfs:defineTextColumn name="idPropietario" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="politicasCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="codigo"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.codigo" caption="**Codigo"
			sortable="true" />	
		<pfs:defineHeader dataIndex="estado"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.estado" caption="**Estado"
			sortable="true" />
		<pfs:defineHeader dataIndex="propietario"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.propietario" caption="**Propietario"
			sortable="true" />																
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" tipoPalanca="filtroTiposPalancas" estado="filtroEstado"/>
	
	var btBorrar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,id :'btBorrarOpenABMPoliticaAcuerdos'
		,disabled: true
		,handler : function(){
			if (politicasGrid.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = getParametros();
    					parms.id = politicasGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobropoliticadeacuerdos/borrarPoliticaAcuerdos'
							,params: parms
							,success : function(){ 
								politicasGrid.store.webflow(parms);
								palancasGrid.store.webflow({idPolitica:politicasGrid.getSelectionModel().getSelected().get('id')}); 
							}
						});
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		}
	});	
		
	var btnEditar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.politicaAcuerdos.editar" text="**Editar" />'
		<app:test id="btnEditar" addComa="true" />
		,iconCls : 'icon_edit'
		,disabled : true
		,id :'btnEditarOpenABMPoliticaAcuerdos'
		,handler :  function(){
			if (politicasGrid.getSelectionModel().getCount()>0){
				var rec = politicasGrid.getSelectionModel().getSelected();
		    	var w= app.openWindow({
								flow: 'recobropoliticadeacuerdos/editPoliticaAcuerdos'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.btnEditar" text="Editar política" />'
								,params: {idPolitica:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								politicasGrid.store.webflow(getParametros());
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.politicaAcuerdos.btnEditar" text="**Editar politica" />','<s:message code="plugin.recobroConfig.politicaAcuerdos.borrar.noValor" text="Debe seleccionar un esquema de la lista" />');
			}				
		}
	});	
	
	var btCopiar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />'
		,iconCls : 'icon_copy'
		,id: 'btCopiarOpenABMPoliticaAcuerdos'
		,disabled : true
		,handler : function(){
			if (politicasGrid.getSelectionModel().getCount()>0){
    					var parms = getParametros();
    					parms.id = politicasGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobropoliticadeacuerdos/copiarPoliticaAcuerdos'
							,params: parms
							,success : function(){ 
								politicasGrid.store.webflow(parms);
								palancasGrid.store.webflow({idPolitica:politicasGrid.getSelectionModel().getSelected().get('id')}); 
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />','<s:message code="plugin.recobroConfig.politicaAcuerdos.noSeleccionado" text="**Debe seleccionar la politica de acuerdos que desea copiar" />');
			}
		}
	});
	
	<%--
	var recargarBotones=function(){
		if (politicasGrid.getSelectionModel().getCount()>0){
			var rec = politicasGrid.getSelectionModel().getSelected();
	    	btnAgregarPalanca.setDisabled(false);
	    	var codigoEstado = politicasGrid.getSelectionModel().getSelected().get('codigoEstado');
	    	var idPropietario = politicasGrid.getSelectionModel().getSelected().get('idPropietario');
	    	btnEditarPalanca.setDisabled(true);
	    	alert(codigoEstado);
	    	if (codigoEstado == ESTADO_BLOQUEADO.getValue()){
	    		btBorrar.setDisabled(true);
	    		btnEditar.setDisabled(true); 
	    		btCopiar.setDisabled(false);
	    		btLiberar.setDisabled(true);
	    		btBorrarPalanca.setDisabled(true);
	    		btnAgregarPalanca.setDisabled(true);
	    	} else {
	    		if (idPropietario != usuarioLogado.getValue()){
	    			btBorrar.setDisabled(true);
	    			btnEditar.setDisabled(true); 
	    			btLiberar.setDisabled(true);
	    			btBorrarPalanca.setDisabled(true);
	    			btnAgregarPalanca.setDisabled(true);
	    		} else {
	    			btBorrar.setDisabled(false);
	    			btnEditar.setDisabled(false); 
	    			btBorrarPalanca.setDisabled(false);
	    			btnAgregarPalanca.setDisabled(false);
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
	    } else {
	    	btnEditar.setDisabled(true); 
	    	btCopiar.setDisabled(true);
	    	btLiberar.setDisabled(true);
	    	btBorrarPalanca.setDisabled(true);
	    	btnAgregarPalanca.setDisabled(true);
	    }	
	}	
	 
	--%>
	 
	var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,id: 'btLiberarOpenABMPoliticaAcuerdos'
		,handler : function(){
			if (politicasGrid.getSelectionModel().getCount()>0){
				// comprobar estado != en definicion 
    					var parms = getParametros();
    					parms.id = politicasGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobropoliticadeacuerdos/liberarPoliticaAcuerdos'
							,params: parms
							,success : function(){ 
								politicasGrid.store.webflow(parms);
								palancasGrid.store.webflow({idPolitica:politicasGrid.getSelectionModel().getSelected().get('id')}); 
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
		resultRootVar="politicas" 
		resultTotalVar="total" 
		recordType="Politicas" 
		dataFlow="recobropoliticadeacuerdos/buscaPoliticasAcuerdos" />


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
		text : '<s:message code="plugin.recobroConfig.politicaAcuerdos.nuevo" text="**Nueva politica acuerdos" />'
		<app:test id="btnNuevo" addComa="true" />
		,iconCls : 'icon_mas'
		,disabled : false
		,id :'btnNuevoOpenABMPoliticaAcuerdos'
		,handler :  function(){
		    	var w= app.openWindow({
								flow: 'recobropoliticadeacuerdos/altaPoliticaAcuerdos'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.nuevo" text="Nueva política de acuerdos" />'
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
		title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.tabName" text="**Configuración de Políticas de Acuerdos" />'
		,autoHeight:true
		,autoWidth:true
		,layout:'table'
		,layoutConfig:{columns:3}
		,titleCollapse : true
		,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[
			{width:'0px'}
			,{
				layout:'form'
				,items:[ filtroNombre, filtroTiposPalancas]
			}
			,{
				layout:'form'
				,items:[ filtroEstado]
			}
		]
		,tbar : [btnBuscar, btnReset, btnNuevo]
		,listeners:{	
			beforeExpand:function(){
				politicasGrid.collapse(true);
				politicasGrid.setHeight(200);
				palancasGrid.collapse(true);
				palancasGrid.setHeight(200);			
			}
			,beforeCollapse:function(){
				politicasGrid.expand(true);
				politicasGrid.setHeight(200);
				palancasGrid.collapse(true);
				palancasGrid.setHeight(200);	
			}
		}
		
	});	
	
	
	var pagingBar=fwk.ux.getPaging(dataStore);
	var cfg={
		title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.grid.title" text="**Politicas de acuerdos" />'
		,collapsible : true
		,collapsed: true
		,id :'politicasGridOpenABMPoliticaAcuerdos'
		,titleCollapse : true
		,stripeRows:true
		,bbar : [  pagingBar,btBorrar,btnEditar,btCopiar,btLiberar]
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,iconCls:'icon_politicas'
	};
	var politicasGrid=app.crearGrid(dataStore,politicasCM,cfg);
	
	
	<%-- grid de carteras de un esquema --%>
		
	var btBorrarPalanca= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,id :'btBorrarPalancaOpenABMPoliticaAcuerdos'
		,disabled: true
		,handler : function(){
			if (palancasGrid.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = {}
    					parms.id = palancasGrid.getSelectionModel().getSelected().get('id');
    					parms.idPolitica = palancasGrid.getSelectionModel().getSelected().get('idPolitica');
    					page.webflow({
							flow: 'recobropoliticadeacuerdos/borrarPalancaPoliticaAcuerdos'
							,params: parms
							,success : function(){ 
								palancasGrid.store.webflow({idPolitica:palancasGrid.getSelectionModel().getSelected().get('idPolitica')}); 
							}
						});
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		}
	});	
		
	var btnAgregarPalanca = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.politicaAcuerdos.palanca.nuevo" text="**Añadir palanca" />'
		,iconCls : 'icon_mas'
		,id :'btnAgregarPalancaOpenABMPoliticaAcuerdos'
		,disabled : true
		,handler :  function(){
			if (politicasGrid.getSelectionModel().getCount()>0){
				var rec = politicasGrid.getSelectionModel().getSelected();
		    	var w= app.openWindow({
								flow: 'recobropoliticadeacuerdos/addPalancaPolitica'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.palanca.nuevo" text="Añadir palanca" />'
								,params: {idPolitica:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								palancasGrid.store.webflow({idPolitica:rec.get('id')});
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.politicaAcuerdos.palanca.nuevo" text="**Añadir palanca" />','<s:message code="plugin.recobroConfig.politicaPalanca.addPalanca.noValor" text="Debe seleccionar una politica de la lista" />');
			}				
		}
	});	
	
	var btnEditarPalanca = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.politicaAcuerdos.palanca.editar" text="**Editar palanca" />'
		,iconCls : 'icon_edit'
		,disabled : true
		,id :'btnEditarPalancaOpenABMPoliticaAcuerdos'
		,handler :  function(){
			if (palancasGrid.getSelectionModel().getCount()>0){
				var rec = palancasGrid.getSelectionModel().getSelected();
		    	var w= app.openWindow({
								flow: 'recobropoliticadeacuerdos/editarPalancaPolitica'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.palanca.editar" text="**Editar palanca" />'
								,params: {idPalanca:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								palancasGrid.store.webflow({idPolitica:rec.get('idPolitica')});
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.politicaAcuerdos.palanca.editar" text="**Editar palanca" />','<s:message code="plugin.recobroConfig.politicaPalanca.editPalanca.noValor" text="Debe seleccionar una palanca de la lista" />');
			}				
		}
	});		
	 
	<pfs:defineRecordType name="Palancas">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="idPolitica" />
			<pfs:defineTextColumn name="tipoPalanca" />
			<pfs:defineTextColumn name="subtipoPalanca" />
			<pfs:defineTextColumn name="delegada" />
			<pfs:defineTextColumn name="prioridad" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="palancaCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.palancaPolitica.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="idPolitica"
			captionKey="plugin.recobroConfig.palancaPolitica.idPolitica" caption="**Id política"
			sortable="true"  hidden="true"/>	
		<pfs:defineHeader dataIndex="tipoPalanca"
			captionKey="plugin.recobroConfig.palancaPolitica.tipoPalanca" caption="**Tipo Palanca"
			sortable="true" />
		<pfs:defineHeader dataIndex="subtipoPalanca"
			captionKey="plugin.recobroConfig.palancaPolitica.subtipoPalanca" caption="**Subtipo Palanca"
			sortable="true" />
		<pfs:defineHeader dataIndex="delegada"
			captionKey="plugin.recobroConfig.palancaPolitica.delegada" caption="**Delegada"
			sortable="true" />			
		<pfs:defineHeader dataIndex="prioridad"
			captionKey="plugin.recobroConfig.palancaPolitica.prioridad" caption="**Prioridad"
			sortable="true" />						
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="palancaStore" 
		resultRootVar="palancas" 
		recordType="Palancas" 
		dataFlow="recobropoliticadeacuerdos/buscaPalancasPolitica" />
		
	
	var cfgPalancas={
		title : '<s:message code="plugin.recobroConfig.palancasPolitica.gridPalanca.title" text="**Palancas asociadas con la política de acuerdos" />'
		,collapsible : true
		,collapsed: true
		,id :'palancasGridOpenABMPoliticaAcuerdos'
		,titleCollapse : true
		,stripeRows:true
		,bbar : [btBorrarPalanca,btnAgregarPalanca,btnEditarPalanca]
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
	};
	
	var palancasGrid=app.crearGrid(palancaStore,palancaCM,cfgPalancas);
	
	<%--Ahora hacemos los métodos para visualizar el grid de carteras --%>
	var createTitle = function(row){
		return row.get('nombre');
	}; 
	 
	politicasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	var w= app.openWindow({
								flow: 'recobropoliticadeacuerdos/editPoliticaAcuerdos'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.btnEditar" text="Editar política" />'
								,params: {idPolitica:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								politicasGrid.store.webflow(getParametros());
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
    }); 
    
    politicasGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
    	var rec = politicasGrid.getStore().getAt(rowIndex);
    	var idPolitica = rec.get('id');
    	palancaStore.webflow({idPolitica:idPolitica});
    	palancasGrid.expand(true);
    	btnAgregarPalanca.setDisabled(false);
    	var codigoEstado = politicasGrid.getSelectionModel().getSelected().get('codigoEstado');
    	var idPropietario = politicasGrid.getSelectionModel().getSelected().get('idPropietario');
    	btnEditarPalanca.setDisabled(true);
    	if (codigoEstado == ESTADO_BLOQUEADO.getValue()){
                btBorrar.setDisabled(true);
                btnEditar.setDisabled(true);
                btCopiar.setDisabled(false);
                btLiberar.setDisabled(true);
                btBorrarPalanca.setDisabled(true);
                btnAgregarPalanca.setDisabled(true);
        } else {
                btBorrar.setDisabled(true);
                btnEditar.setDisabled(true);
                btLiberar.setDisabled(true);
                btBorrarPalanca.setDisabled(true);
                btnAgregarPalanca.setDisabled(true);

                <sec:authorize ifAllGranted="ROLE_CONF_POLITICA">
                        btBorrar.setDisabled(false);
                        btnEditar.setDisabled(false);
                        btBorrarPalanca.setDisabled(false);
                        btnAgregarPalanca.setDisabled(false);
                        if (codigoEstado == ESTADO_DEFINICION.getValue()){
                                btLiberar.setDisabled(false);
                        } else {
                                btLiberar.setDisabled(true);
                        }
                </sec:authorize>

                if (codigoEstado == ESTADO_DEFINICION.getValue()){
                        btCopiar.setDisabled(true);
                } else {

    			btCopiar.setDisabled(false);
    		}
    	}
    });
    
    palancasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	var w= app.openWindow({
								flow: 'recobropoliticadeacuerdos/editarPalancaPolitica'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.politicaAcuerdos.palanca.editar" text="**Editar palanca" />'
								,params: {idPalanca:rec.get('id')}
							});
							w.on(app.event.DONE, function(){
								w.close();
								palancasGrid.store.webflow({idPolitica:rec.get('idPolitica')});
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
    }); 
    
    palancasGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e){
    	btnEditarPalanca.setDisabled(false);
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
    			,items:[politicasGrid]
			},{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[palancasGrid]
			}
    	]
	    //,bodyStyle:'padding:10px'
	    ,autoHeight : true
	    ,border: false
    });
	
	
	//añadimos al padre y hacemos el layout
	page.add(mainPanel);			
	
	
	btnEditar.hide();
	btBorrar.hide();
	btnNuevo.hide();
	btnEditarPalanca.hide();
	btBorrarPalanca.hide();
	btnAgregarPalanca.hide();
	<sec:authorize ifAllGranted="ROLE_CONF_POLITICA">
		btnEditar.show();
		btBorrar.show();
		btnNuevo.show();
		btnEditarPalanca.show();
		btBorrarPalanca.show();
		btnAgregarPalanca.show();
	</sec:authorize>
	
	
</fwk:page>	