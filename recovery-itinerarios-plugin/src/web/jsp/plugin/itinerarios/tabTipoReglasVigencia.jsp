<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.itinerarios.tabReglasVigencia.titulo" title="**Reglas de Vigencia" 
	items="panelCE,panelRE" >
	debugger;
	var recargar = function (){
		app.openTab('${itinerario.nombre}'
					,'plugin.itinerarios.consultaItinerario'
					,{id:${itinerario.id}}
					,{id:'ItinerarioRT${itinerario.id}'}
				)
	};
	
	//Ext.util.CSS.createStyleSheet(".icon_reglasVigencia { background-image: url('../img/plugin/itinerarios/metronome.png');}");
	<pfsforms:textfield name="reglaConsensoCE" 
		labelKey="plugin.itinerarios.tabReglasVigencia.reglasConsenso"
		label="**Regla de consenso" 
		value="${reglaConsensoCE.tipoReglaVigenciaPolitica.descripcion}" 
		width="700" 
		readOnly="true"/>
	<pfsforms:textfield labelKey="plugin.itinerarios.tabReglasVigencia.reglasEclusion" label="**Reglas de Exclusión" 
		name="reglasExclusionCE" 
		value="${reglasExclusionCE.tipoReglaVigenciaPolitica.descripcion}" 
		width="700"
		readOnly="true"/>
		
	<pfs:defineParameters name="estadoCEParams" paramId="${estadoCE.id}"/>	
	<pfs:buttonedit name="btEditConsensoCE"
		flow="plugin.itinerarios.editarReglaConsensoCE" 
		windowTitleKey="plugin.itinerarios.tabReglaVigencia.editarConsenso" 
		parameters="estadoCEParams" windowTitle="**Cambiar regla de consenso"
		on_success="recargar"/>
	<pfs:buttonedit name="btEditExclusionCE"
		flow="plugin.itinerarios.editarReglasExclusionCE" 
		windowTitleKey="plugin.itinerarios.tabReglaVigencia.editarExclusion" 
		parameters="estadoCEParams" windowTitle="**Asignar reglas de exclusión"
		on_success="recargar"/>
	 
		
	<pfsforms:fieldset caption="**Consenso" name="fieldConsensoCE" 
		captioneKey="plugin.itinerarios.tabReglaVigencia.consenso" 
		items="reglaConsensoCE,btEditConsensoCE"  width="900"/>
	<pfsforms:fieldset caption="**Exclusion" name="fieldExclusionCE"
		captioneKey="plugin.itinerario.tabReglaVigencia.exclusion" items="reglasExclusionCE,btEditExclusionCE"  width="900"/>
	
	<pfsforms:fieldset caption="**COMPLETAR EXPEDIENTE" name="panelCE" 
		items="fieldConsensoCE,fieldExclusionCE" 
		captioneKey="plugin.itinerarios.reglasElevacion.completarExpediente" width="1000" />
	
	<%--
	<pfs:panel titleKey="plugin.itinerarios.reglasElevacion.completarExpediente" name="panelCE" columns="1" 
		collapsible="true" title="**COMPLETAR EXPEDIENTE"  >
		<pfs:items items="fieldConsensoCE,fieldExclusionCE"/>
	</pfs:panel>
	--%>
	<pfsforms:textfield name="reglaConsensoRE" labelKey="plugin.itinerarios.tabReglasVigencia.reglasConsenso"
		label="**Regla de consenso" 
		value="${reglaConsensoRE.tipoReglaVigenciaPolitica.descripcion}" 
		width="700" 
		readOnly="true"/>
	<pfsforms:textfield labelKey="plugin.itinerarios.tabReglasVigencia.reglasEclusion" 
		label="**Reglas de Exclusión" 
		name="reglasExclusionRE" 
		value="${reglasExclusionRE.tipoReglaVigenciaPolitica.descripcion}" 
		width="700"
		readOnly="true" />
	
	<pfs:defineParameters name="estadoREParams" paramId="${estadoRE.id}"/>	
	<pfs:buttonedit flow="plugin.itinerarios.editarReglaConsenso" name="btEditConsensoRE" 
		windowTitleKey="plugin.itinerarios.tabReglaVigencia.editarConsenso" 
		parameters="estadoREParams" windowTitle="**Asignar regla de consenso"
		on_success="recargar"/>
	
	<pfs:buttonedit name="btEditExclusionRE"
		flow="plugin.itinerarios.editarReglasExclusionRE" 
		windowTitleKey="plugin.itinerarios.tabReglaVigencia.editarExclusion" 
		parameters="estadoREParams" windowTitle="**Asignar reglas de exclusión"
		on_success="recargar"/>
		
	<pfsforms:fieldset caption="**Consenso" name="fieldConsensoRE" 
		captioneKey="plugin.itinerarios.tabReglaVigencia.consenso" 
		items="reglaConsensoRE,btEditConsensoRE" width="900" />
	<pfsforms:fieldset caption="**Exclusion" name="fieldExclusionRE"
		captioneKey="plugin.itinerario.tabReglaVigencia.exclusion" items="reglasExclusionRE,btEditExclusionRE"  width="900"/>
	
	<pfsforms:fieldset caption="**REVISAR EXPEDIENTE" name="panelRE" captioneKey="plugin.itinerarios.reglasElevacion.revisarExpediente" 
		items="fieldConsensoRE,fieldExclusionRE" width="1000" />
	 
	<%--	
	<pfs:panel titleKey="plugin.itinerarios.reglasElevacion.revisarExpediente" name="panelRE" columns="1" 
		collapsible="true" title="**REVISAR EXPEDIENTE"  >
		<pfs:items items="fieldConsensoRE,fieldExclusionRE"/>	
	</pfs:panel>
	
	
	<pfs:defineRecordType name="ReglasVigenciaRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="tipoReglaVigenciaPolitica"/>
		<pfs:defineTextColumn name="estado"/>
	</pfs:defineRecordType>
	
	<pfs:defineParameters name="itinerarioParams" paramId="${itinerario.id}"/>	
	
	<pfs:remoteStore name="reglasVigenciaDS"
			dataFlow="plugin.itinerarios.listadoReglasVigenciaData"
			resultRootVar="reglasVigenciaItinerario" 
			recordType="ReglasVigenciaRT" 
			autoload="true"
			parameters="itinerarioParams"
			/>
	
	<pfs:defineColumnModel name="reglasVigenciaCM">
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasVigencia.tipoRegla" sortable="false" 
			dataIndex="tipoReglaVigenciaPolitica" caption="**Tipo de Regla" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.reglasVigencia.estado" sortable="false" 
			dataIndex="estado" caption="**Estado"/>
		
	</pfs:defineColumnModel>
	
	<pfs:grid name="gridReglasVigencia" 
		dataStore="reglasVigenciaDS"  
		columnModel="reglasVigenciaCM" 
		titleKey="plugin.itinerarios.reglasVigencia.titulo" 
		title="**Reglas de vigencia de política" 
		collapsible="false" 
		iconCls="icon_reglasVigencia"
		 />
	--%>	
</pfslayout:tabpage>