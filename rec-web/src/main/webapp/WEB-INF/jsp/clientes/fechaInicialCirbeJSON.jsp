<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


<fwk:json>
		<json:object name="fecha">
			<json:property name="codigo">
				<fwk:date value="${fecha}" />
			</json:property>
			<json:property name="descripcion">
				<fwk:date value="${fecha}" />
			</json:property>
		</json:object>
</fwk:json>
