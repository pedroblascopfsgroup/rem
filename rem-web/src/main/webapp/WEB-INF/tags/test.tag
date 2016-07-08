<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="id" type="java.lang.String" required="true"%>
<%@ attribute name="addComa" type="java.lang.Boolean" required="false"%>
<c:if test="${appProperties.runInSelenium==true}">
	<c:if test="${id!=null && (addComa!=null || addComa)}">,</c:if><c:if test="${id!=null}">id:'${id}'</c:if>
	<jsp:doBody />
</c:if>
