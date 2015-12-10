<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="menu" type="es.capgemini.pfs.web.menu.MenuItem" required="true"%>
<c:if test="${menu.curlyBraces}">{</c:if>
<jsp:include page="${menu.file}" />
<c:if test="${menu.submenu}">
	,menu : [ 
		<c:forEach var="item" items="${menu.menu}" varStatus="status">
			<c:if test="${status.index>0}">,</c:if> <app:menu menu="${item}" />
		</c:forEach>
	]
	<jsp:doBody />
</c:if>
<c:if test="${menu.curlyBraces}">}</c:if>