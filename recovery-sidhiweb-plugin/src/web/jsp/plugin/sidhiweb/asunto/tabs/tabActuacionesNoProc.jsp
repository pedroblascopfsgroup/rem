<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="metaform" tagdir="/WEB-INF/tags/pfs/metaform" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


(function(){
	
	<pfs:defineParameters name="idAsunto" paramId="${asunto.id}"/>
	
	
	<pfs:defineRecordType name="hitoExtraJudicial">
		<pfs:defineTextColumn name="contrato"/>
		<pfs:defineTextColumn name="iter"/>
		<pfs:defineTextColumn name="tipoPersona"/>
		<pfs:defineTextColumn name="codigoPersona"/>
		<pfs:defineTextColumn name="tipoHito"/>
		<pfs:defineTextColumn name="fechaInicio"/>
		<pfs:defineTextColumn name="fechaCumplimiento"/>
		<pfs:defineTextColumn name="tipoInteraccion"/>
		<pfs:defineTextColumn name="subTipoInteraccion"/>
		<pfs:defineTextColumn name="gestor"/>
		<pfs:defineTextColumn name="observaciones"/>
		<pfs:defineTextColumn name="codigoInterfaz"/>
		<pfs:defineTextColumn name="idHito"/>
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="hitoExtraJudicialCM">
		<pfs:defineHeader dataIndex="contrato" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.contrato" 
			caption="**Contrato" sortable="false" width="150" firstHeader="true"/>
		<pfs:defineHeader dataIndex="tipoHito" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.tipoHito" 
			caption="**tipo de hito" sortable="false" />
		<pfs:defineHeader dataIndex="fechaInicio" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.fechaInicio" 
			caption="**fecha inicio" sortable="false" />
		<pfs:defineHeader dataIndex="fechaCumplimiento" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.fechaCumplimiento" 
			caption="**fecha de cumplimiento" sortable="false" />
		<%--
		<pfs:defineHeader dataIndex="iter" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.iter" 
			caption="**Iter" sortable="false" width="150" hiden="true"/>
		<pfs:defineHeader dataIndex="tipoInteraccion" captionKey="plugin.santander.tabInfoExtraJudicial.tipoInteraccion" 
			caption="**tipo Interacción" sortable="false" />
		<pfs:defineHeader dataIndex="subTipoInteraccion" captionKey="plugin.santander.tabInfoExtraJudicial.subtipoInteraccion" 
			caption="**Subtipo Interacción" sortable="false" />
		 --%>
		<pfs:defineHeader dataIndex="gestor" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.gestor" 
			caption="**Gestor" sortable="false" />
		<pfs:defineHeader dataIndex="observaciones" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.observaciones" 
			caption="**Observaciones" sortable="false" width="250"/>
		<pfs:defineHeader dataIndex="codigoInterfaz" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.codigoInterfaz" 
			caption="**Interfaz" sortable="false"   hidden="true"/>
		<pfs:defineHeader dataIndex="idHito" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.idHito" 
			caption="**IdHito" sortable="false"   hidden="true"/>	
	</pfs:defineColumnModel>
	
	
	<pfs:remoteStore name="hitoExtraJudicialStore" 
		resultRootVar="hitos" 
		recordType="hitoExtraJudicial" 
		dataFlow="sidhiaccionesnoproc/getHitoExtraJudicialAsunto"
		parameters="idAsunto"
		resultTotalVar="total"
		autoload="true"/>
		
	var paginaHito=fwk.ux.getPaging(hitoExtraJudicialStore);	
	
	<pfs:grid  name="hitoExtraJudicialGrid" 
		dataStore="hitoExtraJudicialStore" 
		columnModel="hitoExtraJudicialCM" 
		title="**Informacion ExtraJudicial" 
		collapsible="false" 
		titleKey="plugin.sidhiweb.tabInfoExtraJudicial.grid.titulo"
		bbar="paginaHito"/>
	
	hitoExtraJudicialGrid.setHeight(250); 
		 
	 	 
	<pfs:defineRecordType name="interaccionExtraJudicial">
		<pfs:defineTextColumn name="contrato"/>
		<pfs:defineTextColumn name="iter"/>
		<pfs:defineTextColumn name="tipoPersona"/>
		<pfs:defineTextColumn name="codigoPersona"/>
		<pfs:defineTextColumn name="fechaInteraccion"/>
		<pfs:defineTextColumn name="tipoInteraccion"/>
		<pfs:defineTextColumn name="subtipoInteraccion"/>
		<pfs:defineTextColumn name="gestor"/>
		<pfs:defineTextColumn name="tipoTelefono"/>
		<pfs:defineTextColumn name="telefono"/>
		<pfs:defineTextColumn name="tipoResultado"/>
		<pfs:defineTextColumn name="subtipoResultado"/>
		<pfs:defineTextColumn name="observaciones"/>
		<pfs:defineTextColumn name="codigoInterfaz"/>
		<pfs:defineTextColumn name="idAccion"/>
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="interaccionExtraJudicialCM">
		<pfs:defineHeader dataIndex="contrato" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.contrato" 
			caption="**Contrato" sortable="false" width="150" firstHeader="true"/>
		<pfs:defineHeader dataIndex="tipoInteraccion" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.tipoInteraccion" 
			caption="**tipo de interacción" sortable="false"/>
		<pfs:defineHeader dataIndex="fechaInteraccion" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.fechaInteraccion" 
			caption="**fecha interacción" sortable="false" />
			<%-- 
		<pfs:defineHeader dataIndex="iter" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.iter" 
			caption="**Iter" sortable="false" />	
		<pfs:defineHeader dataIndex="subtipoInteraccion" captionKey="plugin.santander.tabInfoExtraJudicial.subtipoInteraccion" 
			caption="**subtipo de interacción" sortable="false" />
		<pfs:defineHeader dataIndex="tipoTelefono" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.tipoTelefono" 
			caption="**tipo de telefono" sortable="false" hidden="true"/>
		<pfs:defineHeader dataIndex="telefono" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.telefono" 
			caption="**telefono" sortable="false" />	--%>
		<pfs:defineHeader dataIndex="gestor" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.gestor" 
			caption="**gestor" sortable="false" />
		<pfs:defineHeader dataIndex="subtipoResultado" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.tipoResultado" 
			caption="**tipo resultado" sortable="false" width="250"/>
		<pfs:defineHeader dataIndex="observaciones" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.observaciones" 
			caption="**observaciones" sortable="false" width="250"/>
		<pfs:defineHeader dataIndex="codigoInterfaz" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.codigoInterfaz" 
			caption="**Interfaz" sortable="false"  hidden="true"/>
		<pfs:defineHeader dataIndex="idAccion" captionKey="plugin.sidhiweb.tabInfoExtraJudicial.idAccion" 
			caption="**IdAccion" sortable="false"  hidden="true"/>
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="interaccionExtraJudicialStore" 
		resultRootVar="acciones" 
		recordType="interaccionExtraJudicial" 
		dataFlow="sidhiaccionesnoproc/getAccionesNoProcAsunto"
		parameters="idAsunto"
		resultTotalVar="total"
		autoload="true"/>
		
	var paginaInteraccion=fwk.ux.getPaging(interaccionExtraJudicialStore);	
	
	<pfs:grid  name="interaccionExtraJudicialGrid" 
		dataStore="interaccionExtraJudicialStore" 
		columnModel="interaccionExtraJudicialCM" 
		title="**Informacion ExtraJudicial" 
		collapsible="false" 
		titleKey="plugin.sidhiweb.tabInfoExtraJudicial.grid.tituloInteraccion"
		bbar="paginaInteraccion"/>
	 
	interaccionExtraJudicialGrid.setHeight(250);
	 
	
	var panel = new Ext.Panel({
		title:'<s:message code="plugin.sidhiweb.tabInfoExtraJudicial.titulo" text="**Informacion ExtraJudicial"/>'
		,autoHeight:true
		,bodyStyle:'padding: 5px'
		,items:[
				interaccionExtraJudicialGrid
				,hitoExtraJudicialGrid
			]
		,nombreTab : 'informacionExtraJudicial'
	});
	return panel;

})()