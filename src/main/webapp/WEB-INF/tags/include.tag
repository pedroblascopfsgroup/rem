<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="files" type="es.capgemini.pfs.web.IncludeFileItem" required="true"%>
[ '-'
	<c:forEach var="item" items="${files}">
			<jsp:include page="${item.file}" />
		</c:forEach>
		
	].splice(1) 
