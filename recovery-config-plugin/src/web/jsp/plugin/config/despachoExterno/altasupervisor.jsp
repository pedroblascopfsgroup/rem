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

	<pfsforms:textfield name="despacho" 
		labelKey="plugin.config.despachoExterno.field.despacho" 
			label="**Despacho"   
			value="${despacho.despacho}" 
			readOnly="true" labelWidth="150" width="350"/>
	
	<pfsforms:textfield name="despachoid" 
		labelKey="plugin.config.despachoExterno.field.despacho" 
			label="**Despacho"   
			value="${despacho.id}" 
			/>
		
	var listaSupervisores = <fwk:json>
							<json:array name="supervisores" items="${supervisores}" var="s">
								<json:object>
									<json:property name="id" value="${s.id}" />
									<json:property name="nombre" value="${s.apellidoNombre}" />
								</json:object>
							</json:array>
						</fwk:json>;
	
	<pfsforms:combo name="supervisores" 
		dict="listaSupervisores" 
		labelKey="plugin.config.despachoExterno.altasupervisor.control.supervisores" 
		displayField="nombre" 
		root="supervisores" 
		label="**Elija supervisor" 
		value="" 
		valueField="id" labelWidth="150" width="300"/>	
		
	
	<pfs:defineParameters name="parametros" paramId=""
		 idusuario="supervisores" 
		 despachoExterno="despachoid"
		   />

	<pfs:editForm saveOrUpdateFlow="plugin/config/despachoExterno/ADMasignarSupervisorDespacho"
		leftColumFields="despacho,supervisores"
		parameters="parametros" />

</fwk:page>