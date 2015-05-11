<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>
	
	<pfs:textfield name="filtroUsername"
			labelKey="plugin.config.usuarios.field.username" label="**Usuario"
			value="" searchOnEnter="true" />
	<pfs:textfield name="filtroNombre"
			labelKey="plugin.config.usuarios.field.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
	<pfs:textfield name="filtroApellido1"
			labelKey="plugin.config.usuarios.field.apellido1"
			label="**Primer Apellido" value="" searchOnEnter="true" />
	<pfs:textfield name="filtroApellido2"
			labelKey="plugin.config.usuarios.field.apellido2"
			label="**Segundo Apellido" value="" searchOnEnter="true" />
			
	<pfsforms:ddCombo name="filtroExterno"
		labelKey="plugin.config.usuarios.field.usuarioExterno"
		label="**Usuario Externo" value="" dd="${ddSiNo}" width="50"  propertyCodigo="codigo"/>	
		
	<pfs:dblselect name="filtroDespacho"
			labelKey="plugin.config.usuarios.busqueda.control.filtroDespacho" label="**Despacho"
			dd="${despachos}" height="120" />
			
	filtroDespacho.setDisabled(true);
			
	filtroExterno.on('select',function(){
		if (filtroExterno.getValue() == '01'){
			filtroDespacho.setDisabled(false);
		}else{
			filtroDespacho.setDisabled(true);
		}
	});	
			
	<pfs:dblselect name="filtroPerfil"
			labelKey="plugin.config.usuarios.busqueda.control.filtroPerfil" label="**Perfil"
			dd="${perfiles}" width="160" height="100"/>
			
	<pfs:ddCombo name="comboJerarquia" 
		labelKey="plugin.config.usuarios.busqueda.control.comboJerarquia" label="**Jerarquia"
		value="" dd="${niveles}" />
	
				
	 var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'plugin/config/usuarios/ADMbuscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
	
	<pfs:dblselect name="filtroCentro"
			labelKey="plugin.config.usuarios.busqueda.control.filtroCentro" label="**Centro"
			dd="${zonas}" width="160" height="120" store="optionsZonasStore"/>
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	};
	
    recargarComboZonas();
    
    var limpiarYRecargar = function(){
		//app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
 
	
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
		usuarioExternoSINO="filtroExterno" despachosExternos="filtroDespacho"
		perfiles="filtroPerfil" centros="filtroCentro" />
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="plugin/config/usuarios/ADMbajaUsuario" 
		paramId="id"  
		datagrid="usuariosGrid" 
		novalueMsgKey="plugin.config.usuarios.busqueda.borrar.noValor"
		parameters="getParametros"/>
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
			
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
			items="filtroUsername, filtroNombre,filtroApellido1,filtroApellido2,filtroExterno,filtroDespacho"
			/>
			<pfs:items
			items="filtroPerfil,comboJerarquia,filtroCentro" 
			/>
			
	</pfs:searchPage>
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	
	btnNuevo.setVisible(false);
    btBorrar.setVisible(false);
    
</fwk:page>


