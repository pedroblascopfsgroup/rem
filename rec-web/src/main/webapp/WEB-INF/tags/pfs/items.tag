<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="items" required="true" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.String"%>

,{
	layout:'form'
	<%--,bodyStyle:'padding:5px;cellspacing:10px'--%>
	,items:[
		${items}
		<%--c:if test="${addspaces}">,{border:false,html:'&nbsp;'},{border:false,html:'&nbsp;'}</c:if--%>
	]
	<c:if test="${width != null}">,width: '${width}px'</c:if>
}