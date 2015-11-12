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

	<pfs:textfield name="nombre" labelKey="plugin.arquetipos.modelo.nombre"
		label="**Nombre" value="${modelo.nombre}" obligatory="true" />
	
	<pfs:textfield name="descripcion" labelKey="plugin.arquetipos.modelo.descripcion" maxLength="50"
		label="**Descripción" value="${modelo.descripcion}" obligatory="true" />
		
	<pfs:defineParameters name="parametros" paramId="${modelo.id}" 
		nombre="nombre"
		descripcion="descripcion"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/arquetipos/modelosArquetipos/ARQguardarModelo"
		leftColumFields="nombre"
		rightColumFields="descripcion"
		parameters="parametros" />

</fwk:page>