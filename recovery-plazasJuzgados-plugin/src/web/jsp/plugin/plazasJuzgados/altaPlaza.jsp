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

	<pfsforms:textfield name="descripcion"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcion" label="**Descripci�n"
			value="${plaza.descripcion}" obligatory="true" />
	
	<pfsforms:textfield name="descripcionLarga"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcionLarga" label="**Descripci�n larga"
			value="${plaza.descripcionLarga}"  />
	
	<pfsforms:textfield name="codigo"
			labelKey="plugin.plazasJuzgados.altaPlaza.codigo" label="**C�digo"
			value="${plaza.codigo}" obligatory="true" />
	
	
	
	<pfs:defineParameters name="getParametros" paramId="${plaza.id}" 
		 descripcion="descripcion"
		 descripcionLarga="descripcionLarga"
		 codigo="codigo"/>

	<c:if test="${plaza==null}">
		<pfs:editForm saveOrUpdateFlow="plugin/plazasJuzgados/plugin.plazasJuzgados.guardaPlaza"
		leftColumFields="descripcion,codigo"
		rightColumFields="descripcionLarga"
		parameters="getParametros" />
	</c:if>
	<c:if test="${plaza!=null}">
	<pfs:editForm saveOrUpdateFlow="plugin/plazasJuzgados/plugin.plazasJuzgados.guardaPlaza"
		leftColumFields="descripcion"
		rightColumFields="descripcionLarga"
		parameters="getParametros" />
	</c:if>
	
</fwk:page>	