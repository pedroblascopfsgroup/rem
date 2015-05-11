<%@page pageEncoding="iso-8859-1" contentType="application/json" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	
</fwk:json>
<%
//eliminamos la excepción de la request puesto que ya ha sido tratada. Si no, el tomcat la tratará de manejar
request.removeAttribute("javax.servlet.error.exception");
%>