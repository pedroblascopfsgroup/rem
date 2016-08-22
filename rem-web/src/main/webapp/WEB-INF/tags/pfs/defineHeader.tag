<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="captionKey" required="true" type="java.lang.String"%>
<%@ attribute name="caption" required="true" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.String"%>
<%@ attribute name="dataIndex" required="true" type="java.lang.String"%>
<%@ attribute name="sortable" required="true" type="java.lang.String"%>
<%@ attribute name="align" required="false" type="java.lang.String"%>
<%@ attribute name="hidden" required="false" type="java.lang.String"%>
<%@ attribute name="firstHeader" required="false" type="java.lang.String"%>
<%@ attribute name="renderer" required="false" type="java.lang.String"%>

<c:if test="${(firstHeader == null)||(firstHeader!=true) }">,</c:if>{header : '<s:message code="${captionKey}" text="${caption}" />'
				, dataIndex : '${dataIndex}' 
				,sortable:${sortable}
				<c:if test="${width != null}">,width:${width}</c:if>
				<c:if test="${align != null}">,align:'${align}'</c:if>
				<c:if test="${hidden != null}">,hidden:${hidden}</c:if>
				<c:if test="${renderer != null}">,renderer: ${renderer}</c:if>
}