<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>
<%@ tag import="java.util.*,java.text.*" %>
<%@ attribute name="value" required="true" type="java.lang.String"%>
<%	// si distinto de vacio 
	String valor = jspContext.getAttribute("value").toString();
	if (valor!="" && valor !=null){
		Double d = Double.parseDouble(valor);
		Locale defaultLocale = new Locale("es", "ES", "EURO");
		NumberFormat nf = NumberFormat.getCurrencyInstance(defaultLocale);
		String formattedValue = nf.format(d);
		valor = formattedValue;
	}
		
%>
<%=valor%>