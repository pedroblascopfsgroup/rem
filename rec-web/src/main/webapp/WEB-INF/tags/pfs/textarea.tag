<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="true" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>

<c:set var="_width" value="150" />

<c:if test="${width != null}">
	<c:set var="_width" value="${width}" />
</c:if>


var ${name} = new Ext.form.TextArea({
		fieldLabel:'<s:message code="${labelKey}" text="${label}" />'
		,width : ${_width}
		<%--<c:if test="${obligatory}">,allowBlank: false</c:if>--%>	
	});