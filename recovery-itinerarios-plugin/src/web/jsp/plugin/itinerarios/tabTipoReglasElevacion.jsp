<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<pfslayout:tabpage titleKey="plugin.itinerarios.reglasElevacion.titulo" title="**Reglas de elevacion" 
	items="panelCE,panelRE,panelDC,panelFP" >
	var refrescoCompletarActivar = ${ceSiNo};
	var refrescoRevisarActivar = ${reSiNo};
	
	var recargar = function (){
		app.openTab('${itinerario.nombre}'
					,'plugin.itinerarios.consultaItinerario'
					,{id:${itinerario.id}}
					,{id:'ItinerarioRT${itinerario.id}'}
				)
	};
	
	<pfs:defineParameters name="itinerarioParams" paramId="${itinerario.id}"/>	
	
	<%--
	<pfs:buttonnew name=""  createTitle="" 
		createTitleKey="" 
		flow="" parameters="" 
		onSuccess="recargar" />
	 --%>
	 	
	<pfs:buttonadd flow="plugin.itinerarios.nuevaReglaElevacionCE" 
		name="btnAddReglaCE" 
		windowTitleKey="plugin.itinerarios.reglasElevacion.nuevaCE"
		windowTitle="**Añadir regla de elevación" 
		parameters="itinerarioParams"  
		store_ref="reglasElevacionDSCE"/>
		
	<pfs:buttonremove name="btEliminarCE"
		flow="plugin.itinerarios.bajaReglaElevacionEstado"
		novalueMsgKey="plugin.itinerarios.reglasElevacion.message.novalue"
		novalueMsg="**Seleccione una función de la lista"  
		paramId="idRegla"  
		datagrid="gridReglasCE" 
		parameters="itinerarioParams"/>
	
	<pfs:defineRecordType name="ReglasElevacionRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="ddTipoReglasElevacion"/>
		<pfs:defineTextColumn name="ambitoExpediente"/>
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="reglasElevacionCM">
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.tipoRegla" sortable="false" 
			dataIndex="ddTipoReglasElevacion" caption="**Tipo de Regla" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.ambitoExpediente" sortable="false" 
			dataIndex="ambitoExpediente" caption="**Ámbito del Expediente" />
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="reglasElevacionDSCE" 
		resultRootVar="reglasElevacion" 
		recordType="ReglasElevacionRT" 
		dataFlow="plugin.itinerarios.tipoReglasElevacionData"
		parameters="itinerarioParams"
		autoload="true"/>
	 
	//Ext.util.CSS.createStyleSheet(".icon_elevacion { background-image: url('../img/plugin/itinerarios/rocket-fly.png');}");
	
	<%-- <pfsforms:check labelKey="plugin.itinerarios.estados.automatico" label="**Automático" 
		name="ceAutomatico" value="${ceSiNo}" readOnly="true"/> --%>
		
	<pfsforms:textfield name="ceAutomatico" labelKey="plugin.itinerarios.estados.automatico" 
		label="**Automático" value="" readOnly="true" />
		
	if (${ceSiNo}) {
		ceAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.activado" text="**Activado" />');
	 } else {
		ceAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivado" text="**Desactivado" />');
	}		
	
	<pfs:hidden name="idEstado" value="${estadoCE.id}"/>	
	<pfs:defineParameters name="paramEstadoCE" paramId="${itinerario.id}" 
		idEstado="idEstado"/>
	<pfs:button name="btAutomaticoCE" caption=""  captioneKey="" >
			page.webflow({
				flow: 'plugin/itinerarios/plugin.itinerarios.marcaAutomatico'
				,params:paramEstadoCE
			});	
			
			if (!refrescoCompletarActivar) {
				ceAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.activado" text="**Activado" />');
				btAutomaticoCE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivar" text="**Desactivar" />');
				refrescoCompletarActivar = true;
			 } else {
				ceAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivado" text="**Desactivado" />');
				btAutomaticoCE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.activar" text="**Activar" />');
				refrescoCompletarActivar = false;
			}
	</pfs:button>
	
	if (${ceSiNo}){
		btAutomaticoCE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivar" text="**Desactivar" />');
	}else{
		btAutomaticoCE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.activar" text="**Activar" />');
	}
	
	<pfs:grid  name="gridReglasCE" 
		dataStore="reglasElevacionDSCE"
		columnModel="reglasElevacionCM" 
		title="**Reglas de Elevación del Estado Completar Expediente" 
		collapsible="false" 
		titleKey="plugin.itinerarios.tipoReglasElevacion.reglasCE"
		bbar="btnAddReglaCE,btEliminarCE"
		iconCls="icon_elevacion "
		width="1050"/>
	
	gridReglasCE.height = 200;
		
	
	<pfsforms:fieldset caption="**COMPLETAR EXPEDIENTE" name="panelCE" captioneKey="plugin.itinerarios.reglasElevacion.completarExpediente"
		items="ceAutomatico,btAutomaticoCE,gridReglasCE" width="1000"/>
	  
	<%--
	<pfs:buttonedit name="btModificar" 
			flow="plugin/itinerarios/plugin.itinerarios.modificaDatosTelecobro"  
			windowTitleKey="pfsadmin.cabeceraUsuario.modificar" 
			parameters="modTelecobroParams" 
			windowTitle="**Modificar telecobro"
			 />
	
	
	<pfs:panel titleKey="plugin.itinerarios.reglasElevacion.completarExpediente" name="panelCE" columns="1" 
		collapsible="true" title="**COMPLETAR EXPEDIENTE"  >
		<pfs:items items="ceAutomatico,gridReglasCE"/>
	</pfs:panel>

	<pfs:buttonnew name="btnAddReglaRE"  createTitle="**Añadir regla de elevación" 
		createTitleKey="plugin.itinerarios.reglasElevacion.nuevaCE" 
		flow="plugin.itinerarios.nuevaReglaElevacionRE" parameters="itinerarioParams" 
		onSuccess="recargar"/>
			--%>
	<pfs:buttonadd flow="plugin.itinerarios.nuevaReglaElevacionRE" 
		name="btnAddReglaRE" 
		windowTitleKey="plugin.itinerarios.reglasElevacion.nuevaCE"
		windowTitle="**Añadir regla de elevación" 
		parameters="itinerarioParams"  
		store_ref="reglasElevacionDSRE"/>
		
	<pfs:buttonremove name="btEliminarRE"
		flow="plugin.itinerarios.bajaReglaElevacionEstado"
		novalueMsgKey="plugin.itinerarios.reglasElevacion.message.novalue"
		novalueMsg="**Seleccione una regla de la lista"  
		paramId="idRegla"  
		datagrid="gridReglasRE" 
		parameters="itinerarioParams"/>
	
	
	<%-- <pfsforms:check labelKey="plugin.itinerarios.estados.automatico" label="**Automático" 
		name="reAutomatico" value="${reSiNo}" readOnly="true"/> --%>
		
	<pfsforms:textfield name="reAutomatico" labelKey="plugin.itinerarios.estados.automatico" 
		label="**Automático" value="" readOnly="true" />
		
	if (${reSiNo}) {
		reAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.activado" text="**Activado" />');
	 } else {
		reAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivado" text="**Desactivado" />');
	}				
	
	<pfs:remoteStore name="reglasElevacionDSRE" 
		resultRootVar="reglasElevacion" 
		recordType="ReglasElevacionRT" 
		dataFlow="plugin.itinerarios.tipoReglasElevacionREData"
		parameters="itinerarioParams"
		autoload="true"/>
		
	<pfs:defineColumnModel name="reglasElevacionCMRE">
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.tipoRegla" sortable="false" 
			dataIndex="ddTipoReglasElevacion" caption="**Tipo de Regla" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.ambitoExpediente" sortable="false" 
			dataIndex="ambitoExpediente" caption="**Ámbito del Expediente" />
	</pfs:defineColumnModel>		
		
	<pfs:grid name="gridReglasRE" 
		dataStore="reglasElevacionDSRE"
		columnModel="reglasElevacionCMRE" 
		title="**Reglas de Elevación del Estado Revisar Expediente" 
		collapsible="false" 
		titleKey="plugin.itinerarios.tipoReglasElevacion.reglasRE"
		bbar="btnAddReglaRE,btEliminarRE"
		iconCls="icon_elevacion "
		width="1050"/>
	gridReglasRE.height = 200;
	
	<pfs:hidden name="idEstadoRE" value="${estadoRE.id}"/>
	<pfs:defineParameters name="paramEstadoRE" paramId="${itinerario.id}" 
		idEstado="idEstadoRE"/>
	<pfs:button name="btAutomaticoRE" caption=""  captioneKey="" >
			page.webflow({
				flow: 'plugin/itinerarios/plugin.itinerarios.marcaAutomatico'
				,params:paramEstadoRE
			});			
			
			if (!refrescoRevisarActivar) {
				reAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.activado" text="**Activado" />');
				btAutomaticoRE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivar" text="**Desactivar" />');
				refrescoRevisarActivar = true;
			 } else {
				reAutomatico.setValue('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivado" text="**Desactivado" />');
				btAutomaticoRE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.activar" text="**Activar" />');
				refrescoRevisarActivar = false;
			}
	</pfs:button>
	
	if (${reSiNo}){
		btAutomaticoRE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.desactivar" text="**Desactivar" />');
	}else{
		btAutomaticoRE.setText('<s:message code="plugin.itinerarios.tabReglasElevacion.activar" text="**Activar" />');
	}
	
	<pfs:panel name="panelAutoRE" columns="2" collapsible="" hideBorder="true">
		<pfs:items items="reAutomatico" width="300"/>
		<pfs:items items="btAutomaticoRE" width="300"/>
	</pfs:panel>
	
	<pfsforms:fieldset caption="**REVISAR EXPEDIENTE" name="panelRE" captioneKey="plugin.itinerarios.reglasElevacion.revisarExpediente"
		items="reAutomatico,btAutomaticoRE,gridReglasRE" width="1000"/>
		
	
	<pfs:buttonadd flow="plugin.itinerarios.nuevaReglaElevacionDC" 
		name="btnAddReglaDC" 
		windowTitleKey="plugin.itinerarios.reglasElevacion.nuevaCE"
		windowTitle="**Añadir regla de elevación" 
		parameters="itinerarioParams"  
		store_ref="reglasElevacionDSDC"/>
		
	<pfs:buttonremove name="btEliminarDC"
		flow="plugin.itinerarios.bajaReglaElevacionEstado"
		novalueMsgKey="plugin.itinerarios.reglasElevacion.message.novalue"
		novalueMsg="**Seleccione una regla de la lista"  
		paramId="idRegla"  
		datagrid="gridReglasDC" 
		parameters="itinerarioParams"/>
	
		
	<pfs:remoteStore name="reglasElevacionDSDC" 
		resultRootVar="reglasElevacion" 
		recordType="ReglasElevacionRT" 
		dataFlow="plugin.itinerarios.tipoReglasElevacionDCData"
		parameters="itinerarioParams"
		autoload="true"/>
		
	<pfs:defineColumnModel name="reglasElevacionCMDC">
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.tipoRegla" sortable="false" 
			dataIndex="ddTipoReglasElevacion" caption="**Tipo de Regla" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.ambitoExpediente" sortable="false" 
			dataIndex="ambitoExpediente" caption="**Ámbito del Expediente" />
	</pfs:defineColumnModel>		
		
	<pfs:grid  name="gridReglasDC" 
		dataStore="reglasElevacionDSDC"
		columnModel="reglasElevacionCMDC" 
		title="**Reglas de Elevación del Estado Decisión de Comité" 
		collapsible="false" 
		titleKey="plugin.itinerarios.tipoReglasElevacion.reglasDC"
		bbar="btnAddReglaDC,btEliminarDC"
		iconCls="icon_elevacion "
		width="1050"/>
	gridReglasDC.height = 200;
	
	<pfsforms:fieldset caption="**DECISIÓN DE COMITÉ" name="panelDC" captioneKey="plugin.itinerarios.reglasElevacion.decisionComite"
		items="gridReglasDC" width="1000"/>
	
	<pfs:buttonadd flow="plugin.itinerarios.nuevaReglaElevacionFP" 
		name="btnAddReglaFP" 
		windowTitleKey="plugin.itinerarios.reglasElevacion.nuevaCE"
		windowTitle="**Añadir regla de elevación" 
		parameters="itinerarioParams"  
		store_ref="reglasElevacionDCFP"/>
		
	<pfs:buttonremove name="btEliminarFP"
		flow="plugin.itinerarios.bajaReglaElevacionEstado"
		novalueMsgKey="plugin.itinerarios.reglasElevacion.message.novalue"
		novalueMsg="**Seleccione una regla de la lista"  
		paramId="idRegla"  
		datagrid="gridReglasFP" 
		parameters="itinerarioParams"/>
		
	<pfs:remoteStore name="reglasElevacionDCFP" 
		resultRootVar="reglasElevacion" 
		recordType="ReglasElevacionRT" 
		dataFlow="plugin.itinerarios.tipoReglasElevacionFPData"
		parameters="itinerarioParams"
		autoload="true"/>
	
	
	<pfs:defineColumnModel name="reglasElevacionDMFP">
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.tipoRegla" sortable="false" 
			dataIndex="ddTipoReglasElevacion" caption="**Tipo de Regla" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasElevacion.ambitoExpediente" sortable="false" 
			dataIndex="ambitoExpediente" caption="**Ámbito del Expediente" />
	</pfs:defineColumnModel>
	
	
	<pfs:grid name="gridReglasFP"
		dataStore="reglasElevacionDCFP"
		columnModel="reglasElevacionDMFP"
		title="**Reglas de Elevación del Estado Formular Propuesta"
		collapsible="false"
		titleKey="plugin.itinerarios.tipoReglasElevacion.reglasFP"
		bbar="btnAddReglaFP,btEliminarFP"
		iconCls="icon_elevacion"
		width="1050"/>
	gridReglasFP.height = 200;
	
	<pfsforms:fieldset caption="**FORMALIZAR PROPUESTA" name="panelFP" captioneKey="plugin.itinerarios.reglasElevacion.formularPropuesta"
		items="gridReglasFP" width="1000"/>
	
	
	<%--
	<pfs:panel titleKey="plugin.itinerarios.reglasElevacion.revisarExpediente" name="panelRE" columns="1" 
		collapsible="true" title="**REVISAR EXPEDIENTE"  >
		<pfs:items items="reAutomatico,gridReglasRE"/>
	</pfs:panel>
	 --%>
</pfslayout:tabpage>