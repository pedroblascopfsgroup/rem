<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<%-- 
	<pfs:textfield name="username" labelKey="plugin.config.usuarios.field.username"
		label="**Username" value="${usuario.username}" obligatory="true" />
		--%>
		
	var username = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.config.usuarios.field.username" text="**Username" />'
		,value:'${usuario.username}'
		,maxLength:50
		,width :175
		,allowBlank: false	
	});

	<pfs:textfield name="password" labelKey="plugin.config.usuarios.field.password"
			label="**Password" value="" obligatory="${usuario.id==null}" />
	
	password.setVisible(false);
	
	<pfs:textfield name="nombre" labelKey="plugin.config.usuarios.field.nombre"
		label="**Nombre" value="${usuario.nombre}" obligatory="true" />

	<pfs:textfield name="apellido1"
		labelKey="plugin.config.usuarios.field.apellido1" label="**Apellido 1"
		value="${usuario.apellido1}" />

	<pfs:textfield name="apellido2"
		labelKey="plugin.config.usuarios.field.apellido2" label="**Apellido 2"
		value="${usuario.apellido2}" />

	<pfs:textfield name="email" labelKey="plugin.config.usuarios.field.email"
		label="**Email" value="${usuario.email}" />

	<pfsforms:check name="usuarioExterno"
		labelKey="plugin.config.usuarios.field.usuarioExterno" label="**Usuario externo"
		value="${usuario.usuarioExterno}"/>
		
	<pfsforms:check name="usuarioGrupo"
		labelKey="plugin.config.usuarios.field.usuarioGrupo" label="**Usuario grupo"
		value="${usuario.usuarioGrupo}"/>

	<pfs:ddCombo name="tipoDespacho"
		labelKey="plugin.config.usuarios.alta.control.tipoDespacho" label="**Tipo de despacho"
		value="${despacho!=null?despacho.tipoDespacho.id:''}" dd="${tiposDespachos}"/>
	
	var getdespachosParam = function(){
		return {id:tipoDespacho.getValue()}
	};
	
	<pfsforms:remotecombo name="despachoExterno" 
		labelKey="plugin.config.usuarios.alta.control.despachoExterno" 
		dataFlow="plugin.config.despachoExterno.listDespachosPorTipoData"
		parameters="getdespachosParam"
		label="**Despacho externo" 
		root="despachosExternos" 
		value="${despacho!=null?despacho.id:''}"
		valueField="id"
		displayField="despacho" 
		autoload="${despacho!= null?'true':'false'}" obligatory="true"/>
	
	<%-- Campo oculto para controlar que si se elige un 'Tipo Despacho' no se pueda dejar
	 el campo 'Despacho' vacío --%>
	var permiteGuardar = new Ext.form.TextField({
                hidden: true
                ,value: true
        });	

	tipoDespacho.on('select',function(){
		if(tipoDespacho.getValue() == ""){
			despachoExterno.setValue('');
			despachoExterno.setDisabled(true);
			permiteGuardar.setValue(true);
        }
        else
        {
        	despachoExterno.setDisabled(false);
			despachoExterno.reload(true);
			permiteGuardar.setValue(false);
        }
	});
		
	despachoExterno.on('select',function(){
        if(tipoDespacho.getValue() != ""){
            permiteGuardar.setValue(true);
        }
	});
	
	if (usuarioExterno.checked == true){
			tipoDespacho.setDisabled(false);
			despachoExterno.setDisabled(false);
		}else{
			tipoDespacho.setDisabled(true);
			despachoExterno.setDisabled(true);
			<sec:authorize ifAllGranted="ROLE_DESACTIVAR_DEPENDENCIA_USU_EXTERNO">
			tipoDespacho.setDisabled(false);
			despachoExterno.setDisabled(false);
			</sec:authorize>
		}
			
	usuarioExterno.on('check',function(){
		if (usuarioExterno.getValue() == true){
			tipoDespacho.setDisabled(false);
			despachoExterno.setDisabled(false);
		}else{
			tipoDespacho.setDisabled(true);
			despachoExterno.setDisabled(true);
			<sec:authorize ifAllGranted="ROLE_DESACTIVAR_DEPENDENCIA_USU_EXTERNO">
			tipoDespacho.setDisabled(false);
			despachoExterno.setDisabled(false);
			</sec:authorize>
		}
	});
	
	btnGuardar.on('click',function(){
        this.setDisabled(true);
        btnCancelar.setDisabled(true);
	});

	<pfs:defineParameters name="parametros" paramId="${usuario.id}" 
		username="username"
		password="password"
		nombre="nombre"
		apellido1="apellido1"
		apellido2="apellido2"
		email="email"
		usuarioExterno="usuarioExterno"
		usuarioGrupo="usuarioGrupo"
		despachoExterno="despachoExterno"
		permiteGuardar="permiteGuardar"
		/>


	<pfs:editForm saveOrUpdateFlow="plugin/config/usuarios/ADMguardarUsuario"
			leftColumFields="username,password,nombre,apellido1,apellido2"
			rightColumFields="usuarioGrupo,email,usuarioExterno,tipoDespacho,despachoExterno"
			parameters="parametros"
			onSuccessMode="tabConMsgGuardando"
			tab_flow="plugin/config/usuarios/ADMconsultarUsuario"
			tab_iconCls="icon_usuario"
			tab_paramName="id"
			tab_paramValue="usuario.id"
			tab_titleData="username"
			tab_type="Usuario"/>

</fwk:page>