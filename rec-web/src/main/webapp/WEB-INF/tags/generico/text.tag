<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="false" type="java.lang.String"%>


	var ${name} = new Ext.form.TextField({
		fieldLabel:"<s:message code="${label}" />"
		<c:if test="${value!=null}">
			,value="${value}"
		</c:if>
	});
