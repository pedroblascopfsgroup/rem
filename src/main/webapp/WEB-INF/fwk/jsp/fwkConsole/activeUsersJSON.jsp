<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="myDate" class="java.util.Date"/>  
<fwk:json>
	<json:array name="data" items="${data}" var="u">
        <json:object>
            <json:property name="username" value="${u.username}" />
			<c:set target="${myDate}" property="time" value="${u.loginTime}"/>
			<fmt:formatDate value="${myDate}" pattern="yyyy/MM/dd HH:mm:ss" var="timestamp_asdate" />  
            <json:property name="loginTime" value="${timestamp_asdate}" />
            <json:property name="remoteAddress" value="${u.remoteAddress}" />
        </json:object>
    </json:array>
</fwk:json>