<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.itinerarios.tabComitesItinerario.titulo" title="**Comités compatibles" 
	items="gridComitesItinerario" >

	//Ext.util.CSS.createStyleSheet(".icon_comites { background-image: url('../img/plugin/itinerarios/user-business.png');}");
		
	<pfs:defineRecordType name="ComitesItiRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="nombre"/>
		<pfs:defineTextColumn name="atribucionMinima"/>
		<pfs:defineTextColumn name="atribucionMaxima"/>
		<pfs:defineTextColumn name="miembros"/>
		<pfs:defineTextColumn name="miembrosRestrict"/>
	</pfs:defineRecordType>
	
	<pfs:defineParameters name="itinerarioParams" paramId="${itinerario.id}"/>	
	
	<pfs:remoteStore name="comitesDS"
			dataFlow="plugin/itinerarios/plugin.itinerarios.listadoComitesItinerarioData"
			resultRootVar="comitesItinerario" 
			recordType="ComitesItiRT" 
			autoload="true"
			parameters="itinerarioParams"
			/>
	
	<pfs:defineColumnModel name="comitesItinerarioCM">
		<pfs:defineHeader captionKey="plugin.itinerarios.comites.nombre" sortable="false" 
			dataIndex="nombre" caption="**Nombre" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.comites.minima" sortable="false" 
			dataIndex="atribucionMinima" caption="**Atribución mínima"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.comites.maxima" sortable="false" 
			dataIndex="atribucionMaxima" caption="**Atribución máxima"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.comites.miembros" sortable="false" 
			dataIndex="miembros" caption="**Número de miembros"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.comites.restrictivos" sortable="false" 
			dataIndex="miembrosRestrict" caption="**Número de miembros restrictivos"/>	
	</pfs:defineColumnModel>
	
	
	<pfs:grid name="gridComitesItinerario" 
		dataStore="comitesDS"  
		columnModel="comitesItinerarioCM" 
		titleKey="plugin.itinerarios.comites.titulo" 
		title="**Comités compatibles con el itinerario" 
		collapsible="false" 
		 iconCls=".icon_comites"/>
	
	
</pfslayout:tabpage>