<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<pfslayout:tabpage titleKey="pfsadmin.cabeceraPerfil" title="**Perfil" items="panel1,panel2">
	
	
	<pfsforms:textfield labelKey="pfsadmin.cabeceraPerfil.descripcion" label="**Descripcion" name="descripcion" value="${perfil.descripcion}" readOnly="true" labelWidth="150"/>
	<pfsforms:textfield labelKey="pfsadmin.cabeceraPerfil.descripcionLarga" label="**Descripcion Larga" name="descripcionLarga" value="${perfil.descripcionLarga}" readOnly="true" labelWidth="150"/>
	<pfs:button name="btModificar" captioneKey="pfsadmin.cabeceraPerfil.modificar" caption="**Modificar"  iconCls="icon_edit"/>
	<pfs:panel titleKey="pfsadmin.cabeceraPerfil.datos" name="panel1" columns="2" collapsible="" title="**Datos Perfil" bbar="btModificar" >
		<pfs:items items="descripcion"/>
		<pfs:items items="descripcionLarga"/>	
	</pfs:panel>
	
	
	<pfs:panel titleKey="pfsadmin.cabeceraPerfil.datos" name="panel2" columns="2" collapsible="" title="**Funciones Asociadas"  >
		<%-- 
		<%@ include file="funcionesAsociadas.jsp" %>
		--%>	
	</pfs:panel>
	
</pfslayout:tabpage>