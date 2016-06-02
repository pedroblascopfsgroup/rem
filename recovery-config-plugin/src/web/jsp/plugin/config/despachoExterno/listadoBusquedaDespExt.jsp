<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>

	<pfs:textfield name="filtroDespacho"
			labelKey="plugin.config.despachoExterno.field.despacho" label="**Despacho"
			value="" searchOnEnter="true" />
	<pfs:textfield name="filtroCodigoPostal"
			labelKey="plugin.config.despachoExterno.field.codigoPostal"
			label="**C.P." value="" searchOnEnter="true" />
	<pfs:textfield name="filtroContacto"
			labelKey="plugin.config.despachoExterno.field.personaContacto"
			label="**Contacto" value="" searchOnEnter="true" />		
	<pfs:textfield name="filtroLocalidad"
			labelKey="plugin.config.despachoExterno.field.domicilioPlaza"
			label="**Localidad" value="" searchOnEnter="true" />
	<pfs:textfield name="filtroUsuario"
			labelKey="plugin.config.despachoExterno.busqueda.control.filtroUsuario"
			label="**Usuario" value="" searchOnEnter="true" />
	<pfs:textfield name="filtroNombreUsuario"
			labelKey="plugin.config.despachoExterno.busqueda.control.filtroNombreUsuario"
			label="**Nombre Usuario" value="" searchOnEnter="true" />
	<pfs:textfield name="filtroApellido1"
			labelKey="plugin.config.despachoExterno.busqueda.control.filtroApellidoUsuario1"
			label="**Apellido 1" value="" searchOnEnter="true" />
	<pfs:textfield name="filtroApellido2"
			labelKey="plugin.config.despachoExterno.busqueda.control.filtroApellidoUsuario2"
			label="**Apellido 2" value="" searchOnEnter="true" />
			
	<pfsforms:ddCombo name="tipoDespacho"
		labelKey="plugin.config.despachoExterno.field.tipoDespacho" label="**Tipo de despacho"
		value="" dd="${tiposDespachos}" />
			
	<pfsforms:fieldset caption="**Datos despacho" name="datosdespacho" captioneKey="plugin.config.despachoExterno.busqueda.control.datosdespacho" 
		items="tipoDespacho,filtroDespacho,filtroCodigoPostal,filtroContacto,filtroLocalidad" width="370"/>
		
	<pfsforms:fieldset caption="**Datos gestor" name="datosgestor" captioneKey="plugin.config.despachoExterno.busqueda.control.datosgestor" 
		items="filtroUsuario,filtroNombreUsuario,filtroApellido1,filtroApellido2" width="350"/>
			
	<pfs:defineRecordType name="DespachoExterno">
		<pfs:defineTextColumn name="despacho" />
		<pfs:defineTextColumn name="tipoVia" />
		<pfs:defineTextColumn name="domicilio" />
		<pfs:defineTextColumn name="domicilioPlaza" />
		<pfs:defineTextColumn name="codigoPostal" />
		<pfs:defineTextColumn name="personaContacto" />
		<pfs:defineTextColumn name="telefono1" />
		<pfs:defineTextColumn name="telefono2" />
		<pfs:defineTextColumn name="tipoDespacho" />
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="columnasDespachoExterno">
		<pfs:defineHeader dataIndex="tipoDespacho"
			captionKey="plugin.config.despachoExterno.field.tipoDespacho" caption="**Tipo"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="despacho"
			captionKey="plugin.config.despachoExterno.field.despacho" caption="**Despacho"
			sortable="true" />
		<pfs:defineHeader dataIndex="tipoVia"
			captionKey="plugin.config.despachoExterno.field.tipoVia" caption="**Tipo de via"
			sortable="true" />
		<pfs:defineHeader dataIndex="domicilio"
			captionKey="plugin.config.despachoExterno.field.domicilio" caption="**Domicilio"
			sortable="true" />
		<pfs:defineHeader dataIndex="domicilioPlaza"
			captionKey="plugin.config.despachoExterno.field.domicilioPlaza" caption="**Localidad"
			sortable="true" />
		<pfs:defineHeader dataIndex="codigoPostal"
			captionKey="plugin.config.despachoExterno.field.codigoPostal" caption="**Codigo Postal"
			sortable="true" />	
		<pfs:defineHeader dataIndex="personaContacto"
			captionKey="plugin.config.despachoExterno.field.personaContacto" caption="**Persona de Contacto"
			sortable="true" />
		<pfs:defineHeader dataIndex="telefono1"
			captionKey="plugin.config.despachoExterno.field.telefono1" caption="**Telefono 1"
			sortable="true" />
		<pfs:defineHeader dataIndex="telefono2"
			captionKey="plugin.config.despachoExterno.field.telefono2"
			caption="**Telefono 2" sortable="true" />
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="id" 
		despacho="filtroDespacho" codigoPostal="filtroCodigoPostal"
		personaContacto="filtroContacto" domicilioPlaza="filtroLocalidad"
		username="filtroUsuario" nombre="filtroNombreUsuario"
		apellido1="filtroApellido1" apellido2="filtroApellido2"  tipoDespacho="tipoDespacho"
		 />
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**lll" 
		flow="plugin/config/despachoExterno/ADMborrarDespachoExterno" 
		paramId="idDespachoExterno"  
		datagrid="despachosGrid" 
		novalueMsgKey="plugin.config.despachoExterno.busqueda.message.noValue"
		parameters="getParametros"/>
		
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
				
	<pfs:searchPage searchPanelTitle="**Búsqueda Despachos Externos"  searchPanelTitleKey="plugin.config.despachoExterno.busqueda.searchpanel.title" 
			columnModel="columnasDespachoExterno" columns="2"
			gridPanelTitleKey="plugin.config.despachoExterno.busqueda.grid.title" gridPanelTitle="**Despachos Externos" 
			createTitleKey="plugin.config.despachoExterno.altadespacho.windowName" createTitle="**Nuevo despachos externo" 
			createFlow="plugin/config/despachoExterno/ADMaltaDespachoExterno" 
			updateFlow="plugin/config/despachoExterno/ADMconsultarDespachoExterno" 
			updateTitleData="despacho"
			dataFlow="plugin/config/despachoExterno/ADMlistadoBusquedaDespExtData"
			resultRootVar="despachosExternos" resultTotalVar="total"
			recordType="DespachoExterno" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			gridName="despachosGrid"
			buttonDelete="btBorrar"
			iconCls="icon_despacho" 
			defaultWidth="1000"
			>
			<pfs:items
			items="datosdespacho"
			/>
			<pfs:items 
			items="datosgestor" 
			/>
			
	</pfs:searchPage>
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	
</fwk:page>


