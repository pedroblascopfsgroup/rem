<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="bienes" items="${listadoBienesAcuerdo}" var="bien">
		<json:object>
			<json:property name="codigo" value="${bien.id}" />
	        <json:property name="descripcion" value="${bien.datosRegistralesActivo.numRegistro}_${bien.tipoBien.descripcion}" />
	        <c:if test="${not empty bien.referenciaCatastral}"> 
	        	<json:property name="descripcion" value="${bien.datosRegistralesActivo.numRegistro}_${bien.tipoBien.descripcion} / ${bien.referenciaCatastral}" />
	         </c:if>       
		</json:object>
	</json:array>
	
</fwk:json>