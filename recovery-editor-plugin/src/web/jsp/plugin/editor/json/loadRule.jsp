<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	<json:property name="xml" escapeXml="false" value="${rule.ruleDefinition}"/>
	<json:property name="name" escapeXml="false" value="${rule.name}"/>
	<json:property name="nameLong" escapeXml="false" value="${rule.nameLong}"/>
	<json:property name="id" escapeXml="false" value="${rule.id}"/>
	<json:property name="editable" escapeXml="false" value="${editable}"/>
</fwk:json>