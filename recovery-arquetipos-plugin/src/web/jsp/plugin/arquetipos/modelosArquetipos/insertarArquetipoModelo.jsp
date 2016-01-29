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
	
	<pfsforms:dblselect name="arquetipos" labelKey="plugin.arquetipos.modelo.insertarArquetipo.arquetipo" 
		label="**Arquetipos" dd="${restoArquetipos}" propertyCodigo="id" 
		propertyDescripcion="nombre"  height="120" />
	
	<pfs:hidden name="idModelo" value="${modelo.id}"/>
		
	<pfs:defineParameters name="parametros" paramId="${modArquetipo.id}" 
		idModelo="idModelo"
		arquetipos="arquetipos"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/arquetipos/modelosArquetipos/ARQguardarArqModelo"
		leftColumFields="arquetipos"
		parameters="parametros" />

</fwk:page>