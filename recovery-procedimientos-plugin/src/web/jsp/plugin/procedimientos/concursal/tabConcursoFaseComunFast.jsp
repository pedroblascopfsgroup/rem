<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(page,entidad){


	<pfs:defineRecordType name="FaseComun">
		<pfs:defineTextColumn name="numeroAuto"/>
		<pfs:defineTextColumn name="codigoContrato"/>
		<pfs:defineTextColumn name="saldoIrregular"/>
		<pfs:defineTextColumn name="tipoExterno"/>
		<pfs:defineTextColumn name="principalExterno"/>
		<pfs:defineTextColumn name="tipoSupervisor"/>
		<pfs:defineTextColumn name="principalSupervisor"/>
		<pfs:defineTextColumn name="tipoDefinitivo"/>
		<pfs:defineTextColumn name="principalDefinitivo"/>
		<pfs:defineTextColumn name="idProcedimiento"/>
		<pfs:defineTextColumn name="idContratoExpediente"/>
		<pfs:defineTextColumn name="idCredito"/>
		<pfs:defineTextColumn name="estado"/>
		<pfs:defineTextColumn name="producto"/>
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">		
		<pfs:defineTextColumn name="fechaVencimiento"/>
</sec:authorize>		
	</pfs:defineRecordType>
	
	var faseComunDS = page.getStore({
        flow: 'plugin/procedimientos/concursal/listadoFaseComunData'
        ,storeId : 'faseComunDS'
        ,reader : new Ext.data.JsonReader(
            {root:'concursos'}
            , FaseComun
        )
	}); 
    
	entidad.cacheStore(faseComunDS);
	
	<pfs:defineColumnModel name="faseComunCM">
		<pfs:defineHeader dataIndex="numeroAuto" caption="**NºAuto" captionKey="asunto.concurso.tabFaseComun.numeroAuto" sortable="false" firstHeader="true" />
		<pfs:defineHeader dataIndex="codigoContrato" caption="**Contrato" captionKey="asunto.concurso.tabFaseComun.codigoContrato" sortable="false"  />
		<pfs:defineHeader dataIndex="producto" caption="**Producto" captionKey="asunto.concurso.tabFaseComun.producto" sortable="false" />
		<pfs:defineHeader dataIndex="saldoIrregular" caption="**Saldo irregular" captionKey="asunto.concurso.tabFaseComun.saldoIrregular" sortable="false" align="right" width="100"/>
		<pfs:defineHeader dataIndex="tipoExterno" caption="**Insinuación gestor" captionKey="asunto.concurso.tabFaseComun.tipoExterno" sortable="false"  />
		<pfs:defineHeader dataIndex="principalExterno" caption="**Principal gestor" captionKey="asunto.concurso.tabFaseComun.principalExterno" sortable="false" align="right" width="100" />
		<pfs:defineHeader dataIndex="tipoSupervisor" caption="**Insinuación inicial." captionKey="asunto.concurso.tabFaseComun.insinuacionSupervisor" sortable="false"  />
		<pfs:defineHeader dataIndex="principalSupervisor" caption="**Principal inicial" captionKey="asunto.concurso.tabFaseComun.principalSupervisor" sortable="false" align="right" width="100" />
		<pfs:defineHeader dataIndex="tipoDefinitivo" caption="**Final" captionKey="asunto.concurso.tabFaseComun.tipoApresentar" sortable="false"  />
		<pfs:defineHeader dataIndex="principalDefinitivo" caption="**Principal final" captionKey="asunto.concurso.tabFaseComun.principalApresentar" sortable="false" align="right" width="100" />
		<pfs:defineHeader dataIndex="estado" caption="**Estado" captionKey="asunto.concurso.tabFaseComun.estado" sortable="false"  />
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">		
		<pfs:defineHeader dataIndex="fechaVencimiento" caption="**Fecha de vencimiento" captionKey="asunto.concurso.tabFaseComun.fechaVencimiento" sortable="false"  />
</sec:authorize>		
	</pfs:defineColumnModel>
	
	<pfs:button name="btAddCredito" caption="**Agregar"  captioneKey="asunto.concurso.tabFaseComun.btnAgregar" iconCls="icon_mas">
		if (grid.getSelectionModel().getCount()>0){
				var idProcedimiento = grid.getSelectionModel().getSelected().get('idProcedimiento');
				var idContratoExpediente = grid.getSelectionModel().getSelected().get('idContratoExpediente');
				if ((idProcedimiento != '') || (idContratoExpediente != '')){
					var parametros = {
							idProcedimiento : idProcedimiento
							,idContratoExpediente : idContratoExpediente
					};
					var w= app.openWindow({
								flow: 'plugin/procedimientos/concursal/agregarCredito'
								,closable: true
								,width : 700
								,title : '<s:message code="asunto.concurso.tabFaseComun.btnAgregar" text="**Agregar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnAgregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarContrato" text="**Debe seleccionar un contrato" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnAgregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarContrato" text="**Debe seleccionar un contrato" />');
			}
	</pfs:button>
	
	<pfs:button name="btEditCredito" caption="**Editar"  captioneKey="asunto.concurso.tabFaseComun.btnModificarGestor" iconCls="icon_edit">
		if (grid.getSelectionModel().getCount()>0){
				
				var idCredito = grid.getSelectionModel().getSelected().get('idCredito');	
					
				if (idCredito != '') {
					var parametros = {
							idCredito : idCredito
					};
					var w= app.openWindow({
								flow: 'plugin/procedimientos/concursal/editarCredito'
								,closable: true
								,width : 700
								,title : '<s:message code="asunto.concurso.tabFaseComun.btnModificarGestor" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnModificarGestor" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnModificarGestor" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
	</pfs:button>
		
	<pfs:button name="btEditCreditoSupervisor" caption="**Editar"  captioneKey="asunto.concurso.tabFaseComun.btnModificarSupervisor" iconCls="icon_edit">
		if (grid.getSelectionModel().getCount()>0){
				
				var idCredito = grid.getSelectionModel().getSelected().get('idCredito');	
				 
				if (idCredito != '') {
					var parametros = {
							idCredito : idCredito
					};
					var w= app.openWindow({
								flow: 'plugin/procedimientos/concursal/editarCreditoSupervisor'
								,closable: true
								,width : 700
								,title : '<s:message code="asunto.concurso.tabFaseComun.btnModificarSupervisor" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnModificarSupervisor" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnModificarSupervisor" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
	</pfs:button>
	
	var btnEditarTodos = new Ext.Button({
			text : '<s:message code="asunto.concurso.tabFaseComun.btnModificarTodos" text="**Editar todos los valores" />'
			,iconCls : 'icon_edit'
			,handler : function(){ 
					var data = entidad.get("data");
					var parametros = {
							idAsunto : data.id
					};
					var w= app.openWindow({
								flow: 'credito/editarEstadoTodosLosCreditos'
								,closable: true
								,width : 850
								,title : '<s:message code="app.editar" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
					 }
		});
	
	<pfs:button name="btEditCreditoGestor" caption="**Editar"  captioneKey="asunto.concurso.tabFaseComun.btnModificarGestor" iconCls="icon_edit">
		if (grid.getSelectionModel().getCount()>0){
				
				var idCredito = grid.getSelectionModel().getSelected().get('idCredito');	
					
				if (idCredito != '') {
					var parametros = {
							idCredito : idCredito
					};
					var w= app.openWindow({
								flow: 'plugin/procedimientos/concursal/editarCreditoGestor'
								,closable: true
								,width : 700
								,title : '<s:message code="asunto.concurso.tabFaseComun.btnModificarGestor" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnModificarGestor" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="asunto.concurso.tabFaseComun.btnModificarGestor" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
	</pfs:button>

	<pfs:button name="btEditCreditoDefinitivo" caption="**A presentar"  captioneKey="asunto.concurso.tabFaseComun.btnModificarApresentar" iconCls="icon_edit">
		if (grid.getSelectionModel().getCount()>0){
				
				var idCredito = grid.getSelectionModel().getSelected().get('idCredito');	
					
				if (idCredito != '') {
					var parametros = {
							idCredito : idCredito
					};
					var w= app.openWindow({
								flow: 'plugin/procedimientos/concursal/editarCreditoDefinitivo'
								,closable: true
								,width : 700
								,title : '<s:message code="app.editar" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="app.editar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.editar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
	</pfs:button>
		
 	<pfs:button name="btRemoveCredito" caption="**Borrar" captioneKey="app.borrar" iconCls="icon_cancel">
		if (grid.getSelectionModel().getCount()>0){
			var idCredito = grid.getSelectionModel().getSelected().get('idCredito');
			if (idCredito != ''){
				Ext.Msg.confirm('<s:message code="app.borrar" text="**Borrar" />', '<s:message code="asunto.concurso.tabFaseComun.borrarCredito" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == "yes") {
	    				var parametros = {
	    					idCredito : idCredito
	    				};
	   					page.webflow({
							flow: 'plugin/procedimientos/concursal/borrarCredito'
							,params: parametros
							,success : function(){ 
								entidad.refrescar();
							}
						});
					}
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.borrar" text="**Borrar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.borrar" text="**Borrar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
		}
	</pfs:button>

	<pfs:grid name="grid" dataStore="faseComunDS" columnModel="faseComunCM" title="**Fase com�n" 
		collapsible="false" titleKey="asunto.concurso.tabFaseComun.title" autoexpand="true"
		bbar="btAddCredito,btEditCreditoGestor, btEditCreditoSupervisor, btEditCreditoDefinitivo,btnEditarTodos, btRemoveCredito" />

	<sec:authorize ifAllGranted="SOLO_CONSULTA">
		btAddCredito.hide();
		btEditCreditoGestor.hide();
		btEditCreditoSupervisor.hide();
		btEditCreditoDefinitivo.hide();
		btnEditarTodos.hide();
		btRemoveCredito.hide();
	</sec:authorize>

	grid.on('rowclick', function(grid, rowIndex, e) {
		btEditCredito.setDisabled(true);
		btEditCreditoSupervisor.setDisabled(true);
		btEditCreditoGestor.setDisabled(true);
		btEditCreditoDefinitivo.setDisabled(true);
		btAddCredito.setDisabled(true);
		btRemoveCredito.setDisabled(true);

		if (grid.getSelectionModel().getCount()>0){
			var idCredito = grid.getSelectionModel().getSelected().get('idCredito');
			var idProcedimiento = grid.getSelectionModel().getSelected().get('idProcedimiento');
			var idContratoExpediente = grid.getSelectionModel().getSelected().get('idContratoExpediente');
			if ((idProcedimiento != '') || (idContratoExpediente != '')){
				btAddCredito.setDisabled(false);
				btRemoveCredito.setDisabled(false);
			}
			if (idCredito != ''){
				btEditCredito.setDisabled(false);
				btEditCreditoSupervisor.setDisabled(false);
				btEditCreditoGestor.setDisabled(false);
				btEditCreditoDefinitivo.setDisabled(false);
			}
		}

   	});
   	
   	var funcSuper = false;
   	<sec:authorize ifAllGranted="FUNCION_SUPERVISOR">funcSuper = true;</sec:authorize>

	var panel = new Ext.Panel({
		title : '<s:message code="asunto.concurso.tabFaseComun.title" text="**Fase común" />'
		,autoHeight : true
		,items : [grid]
	});

	panel.getAsuntoId = function(){
		return entidad.get("data").id;
    }
	
	panel.getValue = function() {}

	panel.setValue = function() {
		var data = entidad.get("data");
		entidad.cacheOrLoad(data,faseComunDS, {idAsunto : data.id });	

		btEditCredito.setDisabled(true);
		btEditCreditoSupervisor.setDisabled(true);
		btEditCreditoGestor.setDisabled(true);
		btEditCreditoDefinitivo.setDisabled(true);
		btAddCredito.setDisabled(true);
		btRemoveCredito.setDisabled(true);

		var esVisible = [
			  [btEditCreditoGestor, (data.toolbar.esSupervisor || funcSuper) ? false : data.toolbar.esGestor]
			 ,[btEditCreditoSupervisor, data.toolbar.esSupervisor ? true : funcSuper]
			 ,[btEditCreditoDefinitivo, data.toolbar.esGestor]
		];
		entidad.setVisible(esVisible);
	}
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").concursal.procedimientosConcursales > 0;
	}
	
	return panel;

})