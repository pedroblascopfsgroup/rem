<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	<pfs:textfield name="nombre" labelKey="plugin.arquetipos.listado.nombre"
		label="**Nombre" value="${arquetipo.nombre}" obligatory="true" />

	<pfsforms:ddCombo name="rule"
		labelKey="plugin.arquetipos.listado.rule"
		label="**Paquete" value="${arquetipo.rule.id}" dd="${paquetes}" 
		propertyDescripcion="name" propertyCodigo="id" obligatory="true" />
		
	
	<pfsforms:check name="gestion"
		labelKey="plugin.arquetipos.listado.gestion" label="**Gestión"
		value="${arquetipo.gestion}"/>

	<pfsforms:ddCombo name="tipoSaltoNivel"
		labelKey="plugin.arquetipos.listado.tipoSaltoNivel"
		label="**Tipo de Salto" value="${arquetipo.tipoSaltoNivel.id}" dd="${tipoSalto}"  />
		
	<pfs:textfield name="plazoDisparo" labelKey="plugin.arquetipos.listado.plazoDisparo"
		label="**Plazo de disparo" value="${arquetipo.plazoDisparo}" />
	
	<pfs:hidden name="idArquetipo" value="${arquetipo.id}"/>

	<pfs:defineParameters name="parametros" paramId="${arquetipo.id}" 
		id="idArquetipo"
		nombre="nombre" rule="rule" gestion="gestion"
		tipoSaltoNivel="tipoSaltoNivel" plazoDisparo="plazoDisparo"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/arquetipos/arquetipos/ARQguardarArquetipo"
		leftColumFields="nombre,rule,gestion"
		rightColumFields="tipoSaltoNivel, plazoDisparo"
		parameters="parametros"
		 />

</fwk:page>