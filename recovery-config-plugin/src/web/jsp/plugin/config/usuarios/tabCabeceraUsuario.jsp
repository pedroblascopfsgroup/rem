<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<pfslayout:tabpage titleKey="plugin.config.usuarios.consulta.cabecera.title"
	title="**Datos generales" items="panel">


	<pfsforms:textfield labelKey="plugin.config.usuarios.field.username"
		label="**Usuario" name="username" value="${usuario.username}"
		readOnly="true" />
	<pfsforms:textfield labelKey="plugin.config.usuarios.field.nombre"
		label="**Nombre" name="nombre" value="${usuario.nombre}"
		readOnly="true" />
	<pfsforms:textfield labelKey="plugin.config.usuarios.field.apellido1"
		label="**Apellido 1" name="apellido1" value="${usuario.apellido1}"
		readOnly="true" />
	<pfsforms:textfield labelKey="plugin.config.usuarios.field.apellido2"
		label="**Apellido 2" name="apellido2" value="${usuario.apellido2}"
		readOnly="true" />
	<pfsforms:textfield labelKey="plugin.config.usuarios.field.email"
		label="**Email" name="email" value="${usuario.email}" readOnly="true" />
		
	
	<c:if test="${usuario.usuarioExterno}">
		<c:set var="uext">
			<s:message code="mensajes.si"/>
		</c:set>
	</c:if>
	<c:if test="${!usuario.usuarioExterno}">
		<c:set var="uext">
			<s:message code="mensajes.no"/>
		</c:set>	
	</c:if>		
	
	<c:if test="${usuario.usuarioGrupo}">
		<c:set var="ugru">
			<s:message code="mensajes.si"/>
		</c:set>
	</c:if>
	<c:if test="${!usuario.usuarioGrupo}">
		<c:set var="ugru">
			<s:message code="mensajes.no"/>
		</c:set>	
	</c:if>		
	
	<pfsforms:textfield labelKey="plugin.config.usuarios.field.usuarioExterno"
		label="**Usuario externo" name="externo"
		value="${uext}" readOnly="true" />
		
	<pfsforms:textfield labelKey="plugin.config.usuarios.consulta.cabecera.control.tipoDespacho" label="**Tipo de despacho"
		name="tipoDespacho" value="${despacho!=null?despacho.tipoDespacho.descripcion:''}"
		readOnly="true" />
	<pfsforms:textfield labelKey="plugin.config.usuarios.consulta.cabecera.control.despacho"
		label="**Despacho asociado" name="despacho"
		value="${despacho!=null?despacho.despacho:''}" readOnly="true" />

	<pfsforms:textfield labelKey="plugin.config.usuarios.field.usuarioGrupo"
		label="**Usuario grupo" name="grupo"
		value="${ugru}" readOnly="true" />
	

	<pfs:defineParameters name="modUsuParams" paramId="${usuario.id}" />
	
	var recargar = function (){
		app.openTab('${usuario.username}'
					,'plugin/config/usuarios/ADMconsultarUsuario'
					,{id:${usuario.id}}
					,{id:'Usuario${usuario.id}',iconCls:'icon_usuario'}
				)
	};
	
	<pfs:buttonedit name="btModificar"
		flow="plugin/config/usuarios/ADMmodificarUsuario"
		windowTitleKey="plugin.config.usuarios.modificar.windowTitle"
		parameters="modUsuParams" windowTitle="**Modificar usuario"
		on_success="recargar" />
	
	<%-- Se quitan los campos tipoDespacho y despacho. Si se vuelve a requerir, añadir tipoDespacho y despacho en items2 --%>
	
	<c:set var="items2" value="grupo,email,externo"/>
	<c:if test="${usuario.usuarioExterno}">
		<c:set var="items2" value="grupo,email,externo"/>
	</c:if>
	<sec:authorize ifAllGranted="ROLE_DESACTIVAR_DEPENDENCIA_USU_EXTERNO">
		<c:set var="items2" value="grupo,email,externo"/>
	</sec:authorize>
	
	<pfs:panel titleKey="plugin.config.usuarios.consulta.cabecera.control.datos" name="panel"
		columns="2" collapsible="" title="**Datos Despacho" bbar="btModificar">
		<pfs:items items="username,nombre,apellido1,apellido2" />
		<pfs:items items="${items2}" />
	</pfs:panel>

</pfslayout:tabpage>