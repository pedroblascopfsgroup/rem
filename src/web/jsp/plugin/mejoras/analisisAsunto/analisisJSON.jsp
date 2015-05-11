<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:object name="analisis">
       <json:property name="observacion">
       <s:message text = "${analisis.observacion}" htmlEscape="false" javaScriptEscape="false"/>
       </json:property>
    </json:object> 
</fwk:json>