<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>

(function(){

	<pfs:defineRecordType name="FaseComun">
		<pfs:defineTextColumn name="numeroAuto"/>
		<pfs:defineTextColumn name="codigoContrato"/>
		<pfs:defineTextColumn name="saldoIrregular"/>
		<pfs:defineTextColumn name="tipoSupervisor"/>
		<pfs:defineTextColumn name="principalSupervisor"/>
		<pfs:defineTextColumn name="tipoExterno"/>
		<pfs:defineTextColumn name="principalExterno"/>
		<pfs:defineTextColumn name="tipoDefinitivo"/>
		<pfs:defineTextColumn name="principalDefinitivo"/>
		<pfs:defineTextColumn name="idProcedimiento"/>
		<pfs:defineTextColumn name="idContratoExpediente"/>
		<pfs:defineTextColumn name="idCredito"/>
		<pfs:defineTextColumn name="estado"/>
		<pfs:defineTextColumn name="producto"/>
<sec:authorize ifAllGranted="PERSONALIZACION-BC">		
		<pfs:defineTextColumn name="fechaVencimiento"/>
</sec:authorize>		
	</pfs:defineRecordType>
	
	<pfs:hidden name="idAsunto" value="${asunto.id}"/>
	<pfs:defineParameters name="params" paramId="" idAsunto="idAsunto"/>

	<pfs:remoteStore name="faseComunDS" resultRootVar="concursos" recordType="FaseComun" dataFlow="plugin/procedimientos/concursal/listadoFaseComunData" parameters="params" autoload="true"/>
		
	<pfs:defineColumnModel name="faseComunCM">
		<pfs:defineHeader dataIndex="numeroAuto" caption="**NºAuto" captionKey="asunto.concurso.tabFaseComun.numeroAuto" sortable="false" firstHeader="true" />
		<pfs:defineHeader dataIndex="codigoContrato" caption="**Contrato" captionKey="asunto.concurso.tabFaseComun.codigoContrato" sortable="false"  />
		<pfs:defineHeader dataIndex="producto" caption="**Producto" captionKey="asunto.concurso.tabFaseComun.producto" sortable="false" />
		<pfs:defineHeader dataIndex="saldoIrregular" caption="**Saldo irregular" captionKey="asunto.concurso.tabFaseComun.saldoIrregular" sortable="false" align="right" width="100"/>
		<pfs:defineHeader dataIndex="tipoSupervisor" caption="**Insinuación inicial." captionKey="asunto.concurso.tabFaseComun.tipoSupervisor" sortable="false"  />
		<pfs:defineHeader dataIndex="principalSupervisor" caption="**Principal inicial." captionKey="asunto.concurso.tabFaseComun.principalSupervisor" sortable="false" align="right" width="100" />
		<pfs:defineHeader dataIndex="tipoExterno" caption="**Insinuación gestor" captionKey="asunto.concurso.tabFaseComun.tipoExterno" sortable="false"  />
		<pfs:defineHeader dataIndex="principalExterno" caption="**Principal gestor" captionKey="asunto.concurso.tabFaseComun.principalExterno" sortable="false" align="right" width="100" />
		<pfs:defineHeader dataIndex="tipoDefinitivo" caption="**Definitivo" captionKey="asunto.concurso.tabFaseComun.tipoDefinitivo" sortable="false"  />
		<pfs:defineHeader dataIndex="principalDefinitivo" caption="**Principal definitivo" captionKey="asunto.concurso.tabFaseComun.principalDefinitivo" sortable="false" align="right" width="100" />
		<pfs:defineHeader dataIndex="estado" caption="**Estado" captionKey="asunto.concurso.tabFaseComun.estado" sortable="false"  />
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">		
		<pfs:defineHeader dataIndex="fechaVencimiento" caption="**Fecha de vencimiento" captionKey="asunto.concurso.tabFaseComun.fechaVencimiento" sortable="false"  />
</sec:authorize>		
	</pfs:defineColumnModel>
	
	<pfs:button name="btAddCredito" caption="**Agregar"  captioneKey="app.agregar" iconCls="icon_mas">
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
								,title : '<s:message code="app.agregar" text="**Agregar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								faseComunDS.webflow(params());
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="app.agregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarContrato" text="**Debe seleccionar un contrato" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarContrato" text="**Debe seleccionar un contrato" />');
			}
	</pfs:button>
	
	<pfs:button name="btEditCredito" caption="**Editar"  captioneKey="app.editar" iconCls="icon_edit">
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
								,title : '<s:message code="app.editar" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								faseComunDS.webflow(params());
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
	</pfs:button>
		
	<pfs:button name="btEditCreditoSupervisor" caption="**Editar Supervisor"  captioneKey="asunto.concurso.tabFaseComun.btnModificarSupervisor" iconCls="icon_edit">
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
								,title : '<s:message code="app.editar" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								faseComunDS.webflow(params());
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
	</pfs:button>
	
	<pfs:button name="btEditCreditoGestor" caption="**Editar Gestor"  captioneKey="asunto.concurso.tabFaseComun.btnModificarGestor" iconCls="icon_edit">
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
								,title : '<s:message code="app.editar" text="**Editar" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								faseComunDS.webflow(params());
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
	</pfs:button>

	<pfs:button name="btEditCreditoDefinitivo" caption="**Editar Definitivos"  captioneKey="asunto.concurso.tabFaseComun.btnModificarDefinitivo" iconCls="icon_edit">
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
								faseComunDS.webflow(params());
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				}else{
					Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
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
								faseComunDS.webflow(params());
							}
						});
					}
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Borrar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.agregar" text="**Borrar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarCredito" text="**Debe seleccionar un crédito" />');
		}
	</pfs:button>

	<pfs:grid name="grid" dataStore="faseComunDS" columnModel="faseComunCM" title="**Fase común" 
		collapsible="false" titleKey="asunto.concurso.tabFaseComun.title" autoexpand="true"
		bbar="btAddCredito, btEditCreditoSupervisor, btEditCreditoGestor, btEditCreditoDefinitivo, btRemoveCredito" />

	var panel = new Ext.Panel({
		title : '<s:message code="asunto.concurso.tabFaseComun.title" text="**Fase común" />'
		,autoHeight : true
		,items : [grid]
	});

	return panel;

})()