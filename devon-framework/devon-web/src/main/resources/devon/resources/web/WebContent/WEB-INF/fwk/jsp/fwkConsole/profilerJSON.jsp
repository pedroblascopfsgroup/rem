<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:array name="statistics" items="${statistics.data}" var="d">
        <json:object>
            <json:property name="Label" value="${d.Label}" />
            <json:property name="Hits" value="${d.Hits}" />
            <json:property name="AvgActive" value="${d.AvgActive}" />
            <json:property name="Active" value="${d.Active}" />
            <json:property name="MaxActive" value="${d.MaxActive}" />
            <json:property name="Min" value="${d.Min}" />
            <json:property name="Max" value="${d.Max}" />
            <json:property name="LastValue" value="${d.LastValue}" />
            <json:property name="HasListeners" value="${d.HasListeners}" />
            <json:property name="Total" value="${d.Total}" />
            <json:property name="LastAccess" ><fwk:date value="${d.LastAccess}"/></json:property>
            <json:property name="FirstAccess" ><fwk:date value="${d.FirstAccess}"/></json:property>
            <json:property name="Primary" value="${d.Primary}" />
            <json:property name="Avg" value="${d.Avg}" />
            <json:property name="StdDev" value="${d.StdDev}" />
            <json:property name="Enabled" value="${d.Enabled}" />
        </json:object>
    </json:array>
</fwk:json>
