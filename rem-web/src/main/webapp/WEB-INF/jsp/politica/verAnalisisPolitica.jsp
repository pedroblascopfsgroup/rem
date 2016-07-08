<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:page>
	<%@include file="tabAnalisis.jsp" %>
	var panelAnalisis = createAnalisisPanel();
	panelAnalisis.autoWidth = false;
	panelAnalisis.autoHeight = false;
	//panelAnalisis.setWidth(200);
	panelAnalisis.setHeight(500);
	page.add(panelAnalisis);
</fwk:page>