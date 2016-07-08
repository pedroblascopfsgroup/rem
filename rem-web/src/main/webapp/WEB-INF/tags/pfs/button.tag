<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="captioneKey" required="true" type="java.lang.String"%>
<%@ attribute name="caption" required="true" type="java.lang.String"%>
<%@ attribute name="iconCls" required="false" type="java.lang.String"%>

var ${name} = new Ext.Button({
		text : '<s:message code="${captioneKey}" text="${caption}" />'
		<c:if test="${iconCls != null}">,iconCls : '${iconCls}'</c:if>
		,handler : function() {
					<jsp:doBody/>	
				   }
	});