<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:array name="notarios" items="${notarios}" var="n">
        <json:object>
            <json:property name="codigo" value="${n.codigo}" />
            <json:property name="descripcion" value="${n.descripcion}" />
        </json:object>
    </json:array>
</fwk:json> 

