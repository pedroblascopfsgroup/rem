<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="data" items="${elements}" var="el">
		<json:object>
			<json:property name="name" value="${el.name}"/>
			<json:property name="entity" value="${el.entity}" />
		</json:object>
	</json:array>
</fwk:json>