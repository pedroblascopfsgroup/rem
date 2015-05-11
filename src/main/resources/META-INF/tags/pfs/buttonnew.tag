<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="flow" required="true" type="java.lang.String"%>
<%@ attribute name="createTitleKey" required="true" type="java.lang.String"%>
<%@ attribute name="createTitle" required="true" type="java.lang.String"%>


<%@ attribute name="onSuccess" required="false" type="java.lang.String"%>
<%@ attribute name="parameters" required="false" type="java.lang.String"%>
<%@ attribute name="windowWidth" required="false" type="java.lang.Integer"%>

<c:set var="width" value="700"/>
<c:if test="${windowWidth != null}">
	<c:set var="width" value="${windowWidth}"/>
</c:if>

var ${name}_parms = {};

<c:if test="${parameters != null}">
${name}_parms = ${parameters}();
</c:if>

var ${name} = app.crearBotonAgregar({
		flow : '${flow}'
		,title : '<s:message code="${createTitleKey}" text="${createTitle}" />'
		,text : '<s:message code="${createTitleKey}" text="${createTitle}" />'
		,params : ${name}_parms
		<c:if test="${onSuccess != null}">,success : ${onSuccess}</c:if>
		,width: ${width}
		//,closable:true
	});