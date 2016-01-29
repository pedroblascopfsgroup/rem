<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
			<json:array name="rulesList" items="${rulesList}" var="rule">
						<json:object>
								<json:property name="id" value="${rule.id}"/>
								<json:property name="name" value="${rule.name}"/>
								<json:property name="nameLong" value="${rule.nameLong}"/>
						</json:object>
			</json:array>
</fwk:json>			
			