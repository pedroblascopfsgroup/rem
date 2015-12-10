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
	<pfsforms:textfield name="username" labelKey="plugin.config.usuarios.field.username" label="**Username"   value="${usuario.username}" readOnly="true"/>
	
	<pfs:hidden name="idusuario" value="${usuario.id}" />
	
	<pfsforms:textfield name="usuarioExterno" labelKey="plugin.config.usuarios.field.usuarioExterno" label="**"   value="${usuario.usuarioExterno}" readOnly="true"/>
	
	<pfs:ddCombo  name="despachoExterno" 
		labelKey="plugin.config.usuarios.supervisardespacho.control.despachoExterno" 
		label="**Despachos"
		value="" 
		dd="${despachos}" />

	<pfs:defineParameters name="parametros" paramId="${usuario.id}" 
		idusuario ="idusuario"
		despachoExterno="despachoExterno" 
		usuarioExterno="usuarioExterno"
		/>	

	<pfs:editForm saveOrUpdateFlow="pfsadmin/despachosExternos/ADMasignarSupervisorDespacho"
		leftColumFields="username"
		rightColumFields="despachoExterno"
		parameters="parametros" 
		onSuccessMode="tabGenericoConMsgGuardando" />

</fwk:page>