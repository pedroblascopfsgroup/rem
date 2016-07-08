<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:array name="masterStatistics" items="${masterStatistics}" var="d">
       <json:object>
            <json:property name="Label" value="${d[0]}" />
			<json:property name="Number" value="${d[1]}" />
       </json:object>
    </json:array>

<json:array name="entityStatistics" items="${entityStatistics}" var="d">
       <json:object>
            <json:property name="Label" value="${d[0]}" />
			<json:property name="Number" value="${d[1]}" />
       </json:object>
    </json:array>
</fwk:json>
