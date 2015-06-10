<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>

	<pfsforms:textfield name="filtroNombre"
			labelKey="plugin.itinerarios.listado.nombre" label="**Nombre"
			value="" searchOnEnter="true" />	
	
	<pfsforms:ddCombo name="filtroTipoItinerario"
		labelKey="plugin.itinerarios.listado.tipoItinerario"
		label="**Tipo de Itinerario" value="" dd="${ddTipoItinerario}" />	
	
	<pfsforms:ddCombo name="filtroAmbitoExpediente"
		labelKey="plugin.itinerarios.listado.ambitoExpediente"
		label="**Ámbito del Expediente" value="" dd="${ddAmbitoExpediente}" />			
	
	<pfs:defineRecordType name="ItinerarioRT">
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="dDtipoItinerario" />
			<pfs:defineTextColumn name="ambitoExpediente" />  
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="itinerarioCM">
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.itinerarios.listado.nombre" caption="**Nombre"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="dDtipoItinerario"
			captionKey="plugin.itinerarios.listado.tipoItinerario" caption="**Tipo de Itinerario"
			sortable="true" />	
		<pfs:defineHeader dataIndex="ambitoExpediente"
			captionKey="plugin.itinerarios.listado.ambitoExpediente" caption="**Ámbito del Expediente"
			sortable="true" />
	</pfs:defineColumnModel>
	
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre"  dDtipoItinerario="filtroTipoItinerario"  ambitoExpediente="filtroAmbitoExpediente"
		/>
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="plugin/itinerarios/plugin.itinerarios.borrarItinerario" 
		paramId="idItinerario"  
		datagrid="itinerariosGrid" 
		novalueMsgKey="plugin.itinerarios.lista.noValor"
		parameters="getParametros" />
	
	Ext.util.CSS.createStyleSheet(".icon_itinerario { background-image: url('../img/plugin/itinerarios/direction-arrow.png');}");
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	<pfs:searchPage searchPanelTitle="**Búsqueda de Itinerarios"  searchPanelTitleKey="plugin.itinerarios.listado.busqueda" 
			columnModel="itinerarioCM" columns="3"
			gridPanelTitleKey="plugin.itinerarios.listado.titulo" gridPanelTitle="**Itinerarios" 
			createTitleKey="plugin.itinerarios.listado.nuevo" createTitle="**Nuevo Itinerario" 
			createFlow="plugin/itinerarios/plugin.itinerarios.altaItinerario" 
			updateFlow="plugin/itinerarios/plugin.itinerarios.consultaItinerario" 
			updateTitleData="nombre"
			dataFlow="plugin/itinerarios/plugin.itinerarios.busquedaItinerariosData"
			resultRootVar="itinerarios" resultTotalVar="total"
			recordType="ItinerarioRT" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			gridName="itinerariosGrid"
			buttonDelete="btBorrar"
			emptySearch="true"
			iconCls="icon_itinerario"
			 >
			<pfs:items
			items="filtroNombre"
			width="350" />
			<pfs:items
			items="filtroTipoItinerario" 
			width="350"/>
			<pfs:items
			items="filtroAmbitoExpediente" 
			width="350"/>
	</pfs:searchPage>

	btnNuevo.hide();
	
	 <pfs:button caption="**Nuevo itinerario" name="btAgregar" 
	 	captioneKey="plugin.itinerarios.listado.nuevo" iconCls="icon_mas">
	 	alert('El alta un nuevo itinerario se hará como copia y modificación de uno ya existente');
	 </pfs:button>
	 filtroForm.getTopToolbar().add(btAgregar);
	 btnNuevo.hide();
	 filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	 filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	 
</fwk:page>


