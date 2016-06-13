<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
		
	<pfs:dblselect name="filtroPerfil"
		labelKey="plugin.config.usuarios.busqueda.control.filtroPerfil" label="**Perfil"
		dd="${perfiles}" width="160" height="100"/>
		
		var filtrosTabDatosGenerales = new Ext.Panel({
		title:'<s:message code="plugin.config.usuarios.busqueda.control.tab.datosGenerales" text="**Datos Generales" />'
		,autoHeight:true
		,bodyStyle:'padding: 0px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroUsername, filtroNombre, filtroApellido1, filtroApellido2, filtroExterno]
				},{
					layout:'form'
					,items: [filtroPerfil]
				}]
	});
	

