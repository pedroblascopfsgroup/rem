<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="titleKey" required="true" type="java.lang.String"%>
<%@ attribute name="title" required="true" type="java.lang.String"%>
<%@ attribute name="items" required="true" type="java.lang.String"%>
<%@ attribute name="iconCls" required="false" type="java.lang.String"%>

var create_#PARENTNAME#_Tab=function(){
	<jsp:doBody/>
	var panel = new Ext.Panel({
		title:'<s:message code="${titleKey}" text="${title}"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		<c:if test="${iconCls != null}">,iconCls : '${iconCls}'</c:if>
		,items:[${items}]
	});
	return panel;
}




