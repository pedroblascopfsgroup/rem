<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:array name="consoleItems" items="${consoleItems}" var="con">
		<json:object>
			<json:property name="name" value="${con.name}" />
			<json:property name="action" value="${con.action}" />
		</json:object>
	</json:array>
</fwk:json>