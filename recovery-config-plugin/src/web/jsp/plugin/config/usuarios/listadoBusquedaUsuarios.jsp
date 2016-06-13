<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<%@ include file="listadoBusquedaUsuariosDatosGenerales.jsp" %>
	<%@ include file="listadoBusquedaUsuariosGestores.jsp" %>
	<%@ include file="listadoBusquedaUsuariosJerarquia.jsp" %>
	
	<pfs:defineRecordType name="Usuario">
			<pfs:defineTextColumn name="username" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="apellido1" />
			<pfs:defineTextColumn name="apellido2" />
			<pfs:defineTextColumn name="email" />
			<pfs:defineTextColumn name="usuarioExterno" />
			<pfs:defineTextColumn name="entidad" />
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="usuariosCM">
		<pfs:defineHeader dataIndex="username"
			captionKey="plugin.config.usuarios.field.username" caption="**Username"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.config.usuarios.field.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="apellido1"
			captionKey="plugin.config.usuarios.field.apellido1" caption="**Apellido1"
			sortable="true" />
		<pfs:defineHeader dataIndex="apellido2"
			captionKey="plugin.config.usuarios.field.apellido2" caption="**Apellido2"
			sortable="true" />
		<pfs:defineHeader dataIndex="email"
			captionKey="plugin.config.usuarios.field.email" caption="**Email"
			sortable="true" />
		<pfs:defineHeader dataIndex="usuarioExterno"
			captionKey="plugin.config.usuarios.field.usuarioExterno"
			caption="**Externo" sortable="true" />
		<%--<pfs:defineHeader dataIndex="entidad"
			captionKey="plugin.config.usuarios.field.entidad" caption="**Entidad"
			sortable="true" />--%>
	</pfs:defineColumnModel>
	
	
	<pfs:defineParameters name="getParametros" paramId="id" 
		username="filtroUsername" nombre="filtroNombre" 
		apellido1="filtroApellido1" apellido2="filtroApellido2" 
		usuarioExternoSINO="filtroExterno" despachosExternos="comboDespachos"
		perfiles="filtroPerfil" comboGestor="comboGestor" 
		centros="listadoUsuariosId" />
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="plugin/config/usuarios/ADMbajaUsuario" 
		paramId="id"  
		datagrid="usuariosGrid" 
		novalueMsgKey="plugin.config.usuarios.busqueda.borrar.noValor"
		parameters="getParametros"/>
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosGenerales, filtrosTabGestores, filtrosTabJerarquia]
		,id:'idTabFiltrosProcedimientos'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:1
	});
	
	
	<pfs:searchPage searchPanelTitle="**Búsqueda Usuarios"  searchPanelTitleKey="plugin.config.usuarios.busqueda.control.searchpanel.title" 
			columnModel="usuariosCM" columns="2"
			gridPanelTitleKey="plugin.config.usuarios.busqueda.control.grid.title" gridPanelTitle="**Usuarios" 
			createTitleKey="plugin.config.usuarios.alta.windowTitle" createTitle="**Nuevo usuario" 
			createFlow="pfadmin/usuarios/ADMaltaUsuario" 
			updateFlow="plugin/config/usuarios/ADMconsultarUsuario" 
			updateTitleData="username"
			dataFlow="plugin/config/usuarios/ADMlistadoUsuariosData"
			resultRootVar="usuarios" resultTotalVar="total"
			recordType="Usuario" 
			parameters="getParametros"
			newTabOnUpdate="true"
			iconCls="icon_usuario"
			gridName="usuariosGrid"
			buttonDelete="btBorrar ">
			<pfs:items
			items="filtroTabPanel"
			/>
	</pfs:searchPage>
	
	var listadoUsuariosId = new Ext.form.Field({name:'listUsers',value:''});
	
	btnBuscar.on('click',function() {
		listadoUsuariosId.setValue('');
		for(var i=0 ; i < listadoCodigoZonas.length ; i++) {
			if(i < listadoCodigoZonas.length-1)
				listadoUsuariosId.setValue(listadoUsuariosId.getValue() + listadoCodigoZonas[i] + ',');
			else
				listadoUsuariosId.setValue(listadoUsuariosId.getValue() + listadoCodigoZonas[i]);
		}
		
	});
	
	btnReset.on('click',function() {
		
		comboDespachos.reset();
		optionsDespachoStore.webflow({'idTipoGestor': comboTiposGestor.getValue(), 'incluirBorrados': true}); 
		comboGestor.reset();
		comboTiposGestor.setValue('');
		comboGestor.setValue('');
		optionsGestoresStore.removeAll();
		comboDespachos.setDisabled(true);
		filtroPerfil.setValue('');
		filtroPerfil.reset();
		filtroApellido1.setValue('');
		
		comboJerarquia.setValue('');
		optionsZonasStore.webflow({id:0});
		zonasStore.removeAll();
		listadoUsuariosId.setValue('');
		listadoCodigoZonas=[];
	});
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	
	btnNuevo.setVisible(false);
    btBorrar.setVisible(false);
    
    filtroTabPanel.setActiveTab(0);
  
</fwk:page>

