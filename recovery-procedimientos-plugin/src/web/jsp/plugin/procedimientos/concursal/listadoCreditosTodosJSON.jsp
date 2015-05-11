<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
	<json:array name="lista" items="${lista}" var="d">
	        <json:object>
	            <json:property name="codigo" value="${d.idCredito}"/>
	            <json:property name="descripcion" value="${d.codigoContrato}-${d.estadoCredito}"/>
	        </json:object>
	    </json:array>
</fwk:json>