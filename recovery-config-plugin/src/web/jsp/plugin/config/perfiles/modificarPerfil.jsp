<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>

	<pfs:textfield name="descripcion" labelKey="plugin.config.perfiles.field.descripcion"
		label="**Descripcion" value="${perfil.descripcion}" />
		
	<pfs:textfield name="descripcionLarga" labelKey="plugin.config.perfiles.field.descripcionLarga"
		label="**Descripcion larga" value="${perfil.descripcionLarga}" />
	
	
	<pfs:defineParameters name="parametros" paramId="id" 
		descripcionLarga="descripcionLarga"
		descripcion="descripcion"
		listaFunciones="listaFunciones"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/config/perfiles/ADMguardarPerfil"
		leftColumFields="descripcion,descripcionLarga"
		rightColumFields="listaFunciones"
		parameters="parametros" />

</fwk:page>