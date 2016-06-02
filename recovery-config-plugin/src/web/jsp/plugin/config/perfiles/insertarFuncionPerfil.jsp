<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	<pfsforms:textfield name="descripcion" labelKey="plugin.config.perfiles.field.descripcion" 
		label="**Descripcion" value="${perfil.descripcion}"
		readOnly="true" labelWidth="125" width="500"/>
		
	<pfsforms:textfield name="descripcionLarga"
		labelKey="plugin.config.perfiles.field.descripcionLarga" label="**DescripcionLarga"  
		value="${perfil.descripcionLarga}" readOnly="true" labelWidth="125" width="500"/>

	<pfs:dblselect name="funciones" 
		dd="${restoFunciones}" 
		labelKey="plugin.config.perfiles.nuevo.control.funciones" 
		label="**Funciones" 
		height="200"
		width="275"/>
		
	<pfs:hidden name="idPerfil" value="${perfil.id}"/>
		
    var password = app.creaText('password',
                             '<s:message code="plugin.config.confirmacion.password" text="**Introduzca su password para confirmar el cambio" />', 
                             '',
                             {allowBlank : false, inputType:'password'});

	<pfs:defineParameters name="parametros" paramId="" 
		idPerfil="idPerfil"
		idsFuncion="funciones"
		password="password"/>

	<pfs:editForm saveOrUpdateFlow="plugin/config/perfiles/ADMguardarFuncionPerfilSeguro"
		leftColumFields="descripcion,descripcionLarga,funciones,password"
		parameters="parametros" />

</fwk:page>