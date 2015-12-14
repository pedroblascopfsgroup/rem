<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.config.usuarios.consulta.despachos.title" title="**Despachos Supervisados" items="gridDespachos">
	
	<pfs:defineRecordType name="DespachoExterno">
		<pfs:defineTextColumn name="id" />
		<pfs:defineTextColumn name="despacho" />
		<pfs:defineTextColumn name="tipoVia" />
		<pfs:defineTextColumn name="domicilio" />
		<pfs:defineTextColumn name="domicilioPlaza" />
		<pfs:defineTextColumn name="codigoPostal" />
		<pfs:defineTextColumn name="telefono1" />
		<pfs:defineTextColumn name="telefono2" />
	</pfs:defineRecordType>

	<pfs:hidden name="supervisor" value="${usuario.id}"/>
	
	<pfs:defineParameters name="usuarioDespachoParams" paramId="${usuario.id}" 
		supervisor="supervisor" 
	/>
	
	<pfs:remoteStore name="storeDespachoUsuario"
		dataFlow="pfsadmin/despachosExternos/ADMlistadoBusquedaDespExtData"
		resultRootVar="despachosExternos" recordType="DespachoExterno" autoload="true" 
		parameters="usuarioDespachoParams" />
		

	<pfs:defineColumnModel name="columnasDespachoUsuario">
		<pfs:defineHeader dataIndex="despacho"
			captionKey="plugin.config.despachoExterno.field.despacho" caption="**Despacho"
			sortable="true" firstHeader="true" width="250"/>
		<pfs:defineHeader dataIndex="tipoVia"
			captionKey="plugin.config.despachoExterno.field.tipoVia" caption="**Tipo de via"
			sortable="true" />
		<pfs:defineHeader dataIndex="domicilio"
			captionKey="plugin.config.despachoExterno.field.domicilio" caption="**Domicilio"
			sortable="true" />
		<pfs:defineHeader dataIndex="domicilioPlaza"
			captionKey="plugin.config.despachoExterno.field.domicilioPlaza" caption="**Número"
			sortable="true" />
		<pfs:defineHeader dataIndex="codigoPostal"
			captionKey="plugin.config.despachoExterno.field.codigoPostal" caption="**Codigo Postal"
			sortable="true" width="75"/>	
		<pfs:defineHeader dataIndex="personaContacto"
			captionKey="plugin.config.despachoExterno.field.personaContacto" caption="**Persona de Contacto"
			sortable="true" />
		<pfs:defineHeader dataIndex="telefono1"
			captionKey="plugin.config.despachoExterno.field.telefono1" caption="**Telefono 1"
			sortable="true" width="75" hidden="true"/>
		<pfs:defineHeader dataIndex="telefono2"
			captionKey="plugin.config.despachoExterno.field.telefono2"
			caption="**Telefono 2" sortable="true" width="75" hidden="true"/>
	</pfs:defineColumnModel>
	
	<pfs:buttonadd name="btNuevo" 
		flow="plugin/config/usuarios/ADMsupervisarDespacho"  
		windowTitleKey="plugin.config.usuarios.supervisardespacho.windowTitle" 
		parameters="usuarioDespachoParams" 
		windowTitle="**Nuevo despacho" 
		store_ref="storeDespachoUsuario"/>
		
	<pfs:buttonremove name="btBorrar" 
		flow="plugin/config/usuarios/ADMquitarSupervisor" 
		paramId="idDespachoUsuario" 
		datagrid="gridDespachos" 
		novalueMsg="**Debe seleccionar un despacho de la lista"  
		novalueMsgKey="plugin.config.usuarios.consulta.despachos.message.novalue"
		parameters="usuarioDespachoParams"
		onSuccessMode="tabConMsgGuardando"
		/>

	
	var opendespacho = function (grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		app.openTab(rec.get('despacho')
				,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
				,{id:rec.get('id')}
				,{id:'DespachoExterno'+rec.get('id'), iconCls:'icon_despacho'});
	};
	
	btBorrar.on('click',function(){
        btBorrar.setDisabled(true);
        btNuevo.setDisabled(true);
	});
	<pfs:grid name="gridDespachos" dataStore="storeDespachoUsuario"
		columnModel="columnasDespachoUsuario" title="**Listado de despachos asociados al usuario"
		titleKey="plugin.config.usuarios.consulta.despachos.contro.grid.title" collapsible="false" 
		bbar="btNuevo,btBorrar" 
		rowdblclick="opendespacho" />
	
</pfslayout:tabpage>