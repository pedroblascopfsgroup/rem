<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:array name="boList" items="${boList}" var="bo">
       <json:object>
            <json:property name="Label" value="${bo}" />
       </json:object>
    </json:array>

</fwk:json>
