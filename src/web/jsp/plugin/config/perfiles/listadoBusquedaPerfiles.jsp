<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>

	<pfsforms:textfield name="filtroDescripcion"
			labelKey="plugin.config.perfiles.field.descripcion" label="**Descripción"
			value="" searchOnEnter="true" width="500" />
	<pfsforms:textfield name="filtroDescripcionLarga"
			labelKey="plugin.config.perfiles.field.descripcionLarga" label="**Descripción larga"
			value="" searchOnEnter="true" width="500" />
	
	<pfs:dblselect name="filtroFunciones"
			labelKey="plugin.config.perfiles.busqueda.control.funciones" label="**Funciones asociadas"
			dd="${funciones}" height="150" width="250"/>	
	
			
	<pfs:defineRecordType name="Perfil">
			<pfs:defineTextColumn name="descripcion" />
			<pfs:defineTextColumn name="descripcionLarga" />
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="perfilesCM">
		<pfs:defineHeader dataIndex="descripcion"
			captionKey="plugin.config.perfiles.field.descripcion" caption="**Descripcion"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="descripcionLarga"
			captionKey="plugin.config.perfiles.field.descripcionLarga" caption="**Descripción Larga"
			sortable="true" />
		
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="id" 
		descripcion="filtroDescripcion" descripcionLarga="filtroDescripcionLarga" 
		funciones="filtroFunciones"  />
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
			
	<pfs:searchPage searchPanelTitle="**Búsqueda Perfiles"  searchPanelTitleKey="plugin.config.perfiles.busqueda.control.searchpanel.title" 
			columnModel="perfilesCM" columns="1"
			gridPanelTitleKey="plugin.config.perfiles.busqueda.control.grid.title" gridPanelTitle="**Perfiles" 
			createTitleKey="plugin.config.perfiles.nuevo.windowTitle" createTitle="**Nuevo perfil" 
			createFlow="pfadmin/perfiles/ADMaltaPerfil" 
			updateFlow="pfsadmin/usuarios/ADMconsultarPerfil" 
			updateTitleData="descripcion"
			dataFlow="plugin/config/perfiles/ADMlistadoBusquedaPerfilesData"
			resultRootVar="perfiles" resultTotalVar="total"
			recordType="Perfil" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			iconCls="icon_perfiles"
			emptySearch="true">
			<pfs:items
			items="filtroDescripcion, filtroDescripcionLarga,filtroFunciones" />	
	</pfs:searchPage>
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	

</fwk:page>


