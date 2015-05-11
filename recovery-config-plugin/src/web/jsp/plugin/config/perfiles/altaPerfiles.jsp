<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

<fwk:page>


	<pfs:textfield name="descripcionLarga" labelKey="plugin.config.perfiles.field.descripcionLarga"
		label="**Descripcion larga" value="${perfil.descripcionLarga}" obligatory="true" />

	<pfs:textfield name="descripcion" labelKey="plugin.config.perfiles.field.descripcion"
		label="**Descripcion" value="${perfil.descripcion}" obligatory="true" />


	<pfs:defineParameters name="parametros" paramId="${perfil.id}" 
		descripcionLarga="descripcionLarga"
		descripcion="descripcion"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/config/perfiles/ADMguardarPerfil"
		leftColumFields="descripcion"
		rightColumFields="descripcionLarga"
		parameters="parametros" 
		onSuccessMode="tab"
		tab_flow="pfsadmin/usuarios/ADMconsultarPerfil"
		tab_iconCls="icon_perfiles"
		tab_paramName="id"
		tab_paramValue="perfil.id"
		tab_titleData="descripcion"
		tab_type="Perfil"/>

</fwk:page>