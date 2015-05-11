<%@tag import="es.pfsgroup.commons.utils.DateFormat"%>
<%@tag import="es.pfsgroup.commons.utils.Checks"%><%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>
<%@ tag import="java.util.*,java.text.*" %>
<%@ attribute name="value" required="true" type="java.lang.String"%>
<%@ attribute name="max" required="true" type="java.lang.Integer"%>
<%	// si distinto de vacio 
	String valor = (String) jspContext.getAttribute("value");
	Integer max = (Integer) jspContext.getAttribute("max");
	String sval = "";
	if (!Checks.esNulo(valor)){
		if (valor.length() > max ){
			sval = valor.substring(0, max) + "...";
		}else{
			sval = valor;
		}
	}
		
%>
<%=sval%>