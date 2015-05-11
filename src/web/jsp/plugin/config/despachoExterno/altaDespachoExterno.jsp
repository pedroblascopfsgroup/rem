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
	

	<pfs:textfield name="despacho" labelKey="plugin.config.despachoExterno.field.despacho"
		label="**Despacho" value="${despacho.despacho}" obligatory="true" />

	<pfs:textfield name="domicilio" labelKey="plugin.config.despachoExterno.field.domicilio"
		label="**Domicilio" value="${despacho.domicilio}" />

	<pfs:textfield name="domicilioPlaza"
		labelKey="plugin.config.despachoExterno.field.domicilioPlaza" label="**Domicilio plaza"
		value="${despacho.domicilioPlaza}" />

	<pfs:textfield name="personaContacto"
		labelKey="plugin.config.despachoExterno.field.personaContacto" label="**Persona de contacto"
		value="${despacho.personaContacto}" />
		
	<pfs:textfield name="codigoPostal"
		labelKey="plugin.config.despachoExterno.field.codigoPostal" label="**Codigo Postal"
		value="${despacho.codigoPostal}" />

	<pfs:textfield name="telefono1" labelKey="plugin.config.despachoExterno.field.telefono1"
		label="**Telefono 1" value="${despacho.telefono1}" />
		
	<pfs:textfield name="telefono2" labelKey="plugin.config.despachoExterno.field.telefono2"
		label="**Telefono 2" value="${despacho.telefono2}" />

	<pfsforms:ddCombo name="tipoVia"
		labelKey="plugin.config.despachoExterno.field.tipoVia" label="**Tipo de Via"
		value="${despacho.tipoVia}" dd="${ddTipoVia}" width="75" propertyCodigo="codigo"/>
		
	<pfsforms:ddCombo name="tipoDespacho"
		labelKey="plugin.config.despachoExterno.field.tipoDespacho" label="**Tipo de despacho"
		value="${despacho.tipoDespacho.id}" dd="${tiposDespachos}" />
    
	var DDtiposGestor = <app:dict value="${tiposGestor}"/>;
	var tipoGestor = app.creaDblSelect(DDtiposGestor
                              ,'<s:message code="plugin.config.despachoExterno.field.tipoGestor" text="**Tipo de gestor" />'
                              ,{width: 140,height: 140});
                              
	
    tipoGestor.disable();
    
    var consultaGestorProp = function(valorId) {
    	if (valorId==undefined) return false;
    	page.webflow({
			flow : 'plugin/config/despachoExterno/ADMconsultarTipoGestorPropiedad'
			,params : {id:valorId}
			,success : function(response, config)
			{ 
				var recDatos = response['datos'];
				tipoGestor.enable();
				tipoGestor.reset();
				tipoGestor.setValue(recDatos['tiposGestorPropiedad']);
			}
			 ,failure : function(form,action){
			 	tipoGestor.enable();
				tipoGestor.reset();
			 }
		});
    };
	
	
	consultaGestorProp(${despacho.tipoDespacho.id});
	
	tipoDespacho.on('select',function(combo, record, index ){
		consultaGestorProp(combo.getValue());						 
	});                              

	<pfs:defineParameters name="parametros" paramId="${despacho.id}" 
		despacho="despacho"
		tipoVia="tipoVia"
		domicilio="domicilio"
		domicilioPlaza="domicilioPlaza"
		codigoPostal="codigoPostal"
		personaContacto="personaContacto"
		telefono1="telefono1"
		telefono2="telefono2"
		tipoDespacho="tipoDespacho"
		tipoGestor="tipoGestor"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/config/despachoExterno/ADMguardarDespachoExterno"
		leftColumFields="despacho,tipoDespacho,tipoGestor"
		rightColumFields="tipoVia,domicilio,domicilioPlaza,codigoPostal,personaContacto,telefono1,telefono2"
		parameters="parametros" onSuccessMode="tab" 
			tab_titleData="despacho" tab_iconCls="icon_despacho" tab_paramName="id" tab_paramValue="despacho.id" 
			tab_flow="plugin/config/despachoExterno/ADMconsultarDespachoExterno" tab_type="DespachoExterno"/>
			
</fwk:page>