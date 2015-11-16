<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
    <iframe src="/${appProperties.appName}/${reporte}.htm?tipo=${tipo}&${params}" width="100%" height="100%"/>

<%--<meta http-equiv="REFRESH" content="0;url=/${appProperties.appName}/${reporte}.htm?tipo=${tipo}"></HEAD>--%>
