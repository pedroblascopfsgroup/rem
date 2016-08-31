<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.config.usuarios.consulta.grupos.title" title="**Grupos asignados" items="gridGrupos">
	
	<pfs:defineRecordType name="Grupo">
		<pfs:defineTextColumn name="id" />
		<pfs:defineTextColumn name="username" />
		<pfs:defineTextColumn name="nombre" />
		<pfs:defineTextColumn name="apellido1" />
		<pfs:defineTextColumn name="apellido2" />
		<pfs:defineTextColumn name="email" />
		<pfs:defineTextColumn name="usuarioExterno" />
		<pfs:defineTextColumn name="entidad" />
	</pfs:defineRecordType>

	<pfs:hidden name="supervisor" value="${usuario.id}"/>
	
	<pfs:defineParameters name="usuarioGrupoParams" paramId="${usuario.id}" 
		supervisor="supervisor" 
	/>
	
	<pfs:remoteStore name="storeGruposUsuario"
		dataFlow="pfsadmin/usuarios/ADMlistadoBusquedaGruposUsuarioData"
		resultRootVar="usuarios" recordType="Grupo" autoload="true" 
		parameters="usuarioGrupoParams" />
		

	<pfs:defineColumnModel name="columnasGruposUsuario">
		<pfs:defineHeader dataIndex="username"
			captionKey="plugin.config.grupo.field.username" caption="**Nombre de Usuario"
			sortable="true" firstHeader="true" width="250"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.config.grupo.field.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="apellido1"
			captionKey="plugin.config.grupo.field.apellido1" caption="**Primer apellido"
			sortable="true" />
		<pfs:defineHeader dataIndex="apellido2"
			captionKey="plugin.config.grupo.field.apellido2" caption="**Segundo apellido"
			sortable="true" />
		<pfs:defineHeader dataIndex="email"
			captionKey="plugin.config.grupo.field.email" caption="**Email"
			sortable="true" width="150"/>	
		<pfs:defineHeader dataIndex="usuarioExterno"
			captionKey="plugin.config.grupo.field.usuarioExterno" caption="**Usuario Externo"
			sortable="true" />
		<pfs:defineHeader dataIndex="entidad"
			captionKey="plugin.config.grupo.field.entidad" caption="**Entidad"
			sortable="true" width="75" hidden="true"/>
	</pfs:defineColumnModel>
	
	<pfs:buttonadd name="btNuevo" 
		flow="plugin/config/usuarios/ADMasignarGrupo"  
		windowTitleKey="plugin.config.usuarios.asignargrupo.windowTitle" 
		parameters="usuarioGrupoParams" 
		windowTitle="**Nuevo Grupo" 
		store_ref="storeGruposUsuario"/>
		
	<pfs:buttonremove name="btBorrar" 
		flow="plugin/config/usuarios/ADMquitarGrupo" 
		paramId="idGrupoUsuario" 
		datagrid="gridGrupos" 
		novalueMsg="**Debe seleccionar un grupo de la lista"  
		novalueMsgKey="plugin.config.usuarios.consulta.grupos.message.novalue"
		parameters="usuarioGrupoParams"
		/>

	
	var opengrupo = function (grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		app.openTab(rec.get('username')
				,'plugin/config/usuarios/ADMconsultarUsuario'				
				,{id:rec.get('id')}
				,{id:'Usuario'+rec.get('id'), iconCls:'icon_usuario'});
	};
	
	<pfs:grid name="gridGrupos" dataStore="storeGruposUsuario"
		columnModel="columnasGruposUsuario" title="**Listado de grupos asociados al usuario"
		titleKey="plugin.config.usuarios.consulta.grupos.contro.grid.title" collapsible="false" 
		bbar="btNuevo,btBorrar" 
		rowdblclick="opengrupo" />
		
	if ('${usuarioEnOtraCartera}' == 'true') {
		btNuevo.setVisible(false);
		btBorrar.setVisible(false);
	} else {
		btNuevo.setVisible(true);
		btBorrar.setVisible(true);
	}
	
</pfslayout:tabpage>