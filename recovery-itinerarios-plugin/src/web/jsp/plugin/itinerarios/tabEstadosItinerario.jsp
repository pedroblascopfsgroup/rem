<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.itinerarios.tabEstados.titulo" title="**Estados del itinerario" 
	items="gridEstadosItinerario">

	Ext.util.CSS.createStyleSheet(".icon_estados { background-image: url('../img/plugin/itinerarios/arrow-transition.png');}");
		
	<pfs:defineRecordType name="EstadosItiRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="estadoItinerario"/>
		<pfs:defineTextColumn name="gestor_nombre"/>
		<pfs:defineTextColumn name="supervisor_nombre"/>
		<pfs:defineTextColumn name="plazo"/>
	</pfs:defineRecordType>
	
	<pfs:defineParameters name="itinerarioParams" paramId="${itinerario.id}"/>	
	
	<pfs:remoteStore name="estadosDS"
			dataFlow="plugin/itinerarios/plugin.itinerarios.listadoEstadosItinerario"
			resultRootVar="estadosItinerario" 
			recordType="EstadosItiRT" 
			autoload="true"
			parameters="itinerarioParams"
			/>
	
	<pfs:defineColumnModel name="estadosItinerarioCM">
		<pfs:defineHeader captionKey="plugin.itinerarios.estados.tipoEstado" sortable="false" 
			dataIndex="estadoItinerario" caption="**Tipo de Estado" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.estados.gestor" sortable="false" 
			dataIndex="gestor_nombre" caption="**Perfil del gestor"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.estados.supervisor" sortable="false" 
			dataIndex="supervisor_nombre" caption="**Perfil del supervisor"/>
		<pfs:defineHeader captionKey="plugin.itinerarios.estados.plazo" sortable="false" 
			dataIndex="plazo" caption="**Plazo"/>
		
	</pfs:defineColumnModel>
	<%-- 
	var recargar = function (){
		app.openTab('${modelo.nombre}'
					,'/modelosArquetipos/ARQconsultarModelo'
					,{id:${modelo.id}}
					,{id:'ModeloRT${modelo.id}'}
				)
	};
	--%>
	
	<pfs:buttonedit name="btModificarEstados" 
			flow="plugin/itinerarios/plugin.itienerarios.modificarEstadosItinerario" 
			parameters="itinerarioParams" 
			windowTitle="**Modificar estados" 
			windowTitleKey="plugin.itinerarios.consultar.modificarEstados"
			store_ref="estadosDS"
			/>
	
			
	
	<pfs:grid name="gridEstadosItinerario" 
		dataStore="estadosDS"  
		columnModel="estadosItinerarioCM" 
		titleKey="plugin.itinerarios.estados.titulo" 
		title="**Estados del itinerario" 
		collapsible="false" 
		iconCls="icon_estados"
		bbar="btModificarEstados"
		 />
	
	
</pfslayout:tabpage>