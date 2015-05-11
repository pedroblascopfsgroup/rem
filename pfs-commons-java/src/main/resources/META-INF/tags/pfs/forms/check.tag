<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="true" type="java.lang.Boolean"%>
<%@ attribute name="readOnly" required="false" type="java.lang.Boolean"%>
<%@ attribute name="labelWidth" required="false" type="java.lang.Integer"%>

<c:if test="${readOnly}">var ${name}_labelStyle='font-weight:bolder<c:if test="${labelWidth != null}">;width:${labelWidth}</c:if>';</c:if>
var ${name} = new Ext.form.Checkbox({
	fieldLabel : '<s:message code='${labelKey}' text='${label}' />'
	,checked: ${value}
	<c:if test="${readOnly}">,readOnly: ${readOnly}
	,labelStyle: ${name}_labelStyle</c:if>
});