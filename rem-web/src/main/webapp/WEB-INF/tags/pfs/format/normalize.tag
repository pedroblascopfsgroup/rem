<%@tag import="es.pfsgroup.commons.utils.DateFormat"%>
<%@tag import="es.pfsgroup.commons.utils.Checks"%><%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>
<%@ tag import="java.util.*,java.text.*" %>
<%@ attribute name="value" required="true" type="java.lang.Object"%>
<%	// si distinto de vacio 
	Object valor = jspContext.getAttribute("value");
	String sval = "";
	if (!Checks.esNulo(valor)){
		if (valor instanceof Date){
			sval = DateFormat.toString((Date)valor);
		}else{
			sval = valor.toString();
		}
	}
		
%>
<%=sval%>