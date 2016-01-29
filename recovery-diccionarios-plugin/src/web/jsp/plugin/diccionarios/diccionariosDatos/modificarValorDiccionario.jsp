<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

<fwk:page>
	
	<pfs:textfield name="codigo" labelKey="plugin.diccionarios.messages.columnaCodigo"
		label="**Codigo" value="${valorDiccionario.codigo}" obligatory="true" />

	<pfs:textfield name="descripcion" labelKey="plugin.diccionarios.messages.columnaDescripcion"
		label="**Descripcion" value="${valorDiccionario.descripcion}" obligatory="true" />
		
	<pfs:textfield name="descripcionLarga" labelKey="plugin.diccionarios.messages.columnaDescripLarga"
		label="**Descripcion larga" value="${valorDiccionario.descripcionLarga}" obligatory="true" />

	<pfs:hidden name="idDiccionarioEditable" value="${valorDiccionario.idDiccionarioEditable}"/>
	<pfs:hidden name="idLineaEnDiccionario" value="${valorDiccionario.idLineaEnDiccionario}"/>
	
	<pfs:defineParameters name="parametros" paramId="${valorDiccionario.idDiccionarioEditable}" 
		idLineaEnDiccionario="idLineaEnDiccionario"
		idDiccionarioEditable="idDiccionarioEditable"
		descripcionLarga="descripcionLarga"
		codigo="codigo"
		descripcion="descripcion"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/diccionarios/diccionariosDatos/DICguardarModificacionValor"
		leftColumFields="codigo,descripcion"
		rightColumFields="descripcionLarga"
		parameters="parametros" />

</fwk:page>