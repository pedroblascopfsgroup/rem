<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fwk:json>
	<json:array name="data" items="${data}" var="event">
		<json:object>
			<json:property name="name" value="${event.properties.timestamp}" />
		    <fmt:formatDate value="${event.properties.timestamp_asdate}" pattern="MM/dd/yyyy HH:mm:ss 'GMT'Z" var="timestamp_asdate" />
			<json:property name="time" value="${timestamp_asdate}" />
			<json:property name="count" value="${event.properties.count}" />
			<json:property name="avg" value="${event.properties.avg}" />
		</json:object>
	</json:array>
</fwk:json>