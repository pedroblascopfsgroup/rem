<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless" import="java.lang.*"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>

<jsp:doBody var="tabDefinition"/>
<%
String name = (String) jspContext.getAttribute("name");
String content = (String) jspContext.getAttribute("tabDefinition");
String parsed = content.replaceAll("#PARENTNAME#",name);
%>
<%=parsed %>
var ${name}=create_${name}_Tab();




