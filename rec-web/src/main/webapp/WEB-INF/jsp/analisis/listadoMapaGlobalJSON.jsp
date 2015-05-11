<%@page pageEncoding="iso-8859-1" contentType="application/json; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
    <json:array name="analisis" items="${results}" var="p">
        <json:object>
            <json:property name="id" value="${p.id}" />
        </json:object>
    </json:array>
</fwk:json>

