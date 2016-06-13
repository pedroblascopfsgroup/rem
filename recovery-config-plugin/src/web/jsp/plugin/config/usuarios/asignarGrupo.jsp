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
	
	<pfsforms:textfield name="usuarioExterno" labelKey="plugin.config.usuarios.field.usuarioExterno" label="**Usuario Externo"   value="${usuario.usuarioExterno}" readOnly="true"/>
	
	<pfs:dblselect name="grupo"
		labelKey="plugin.config.usuarios.asignargrupo.control.grupo" 
		label="**Grupo"
		width="220" 
		height="120" 
		dd="${grupos}"/>

	<pfs:hidden name="idusuario" value="${usuario.id}" />

	<pfs:defineParameters name="parametros" paramId="" 
		idusuario ="idusuario"
		grupo="grupo" 
		/>	

	<pfs:editForm saveOrUpdateFlow="pfsadmin/usuarios/ADMguardarGrupo"
		leftColumFields="username, grupo"
		parameters="parametros" 
		onSuccessMode="tabGenericoConMsgGuardando" />
	
	<%-- Para deshabilitar los botones mientras se realiza el proceso de Guardado. --%>
	btnGuardar.on('click',function(){
        this.setDisabled(true);
        btnCancelar.setDisabled(true);
	});

</fwk:page>