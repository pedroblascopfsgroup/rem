<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="files" type="java.util.List" required="true"%>
[ 
<c:forEach var="item" items="${files}" varStatus="status">
	<c:if test="${status.index>0}">,</c:if><jsp:include page="${item.fileName}" />
</c:forEach>
]
