<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<c:forEach items="${i.estados}" var="c">
<p><c:out value="${c.codigo}"></c:out></p>
</c:forEach>
<fwk:page>
	
	
	
</fwk:page>