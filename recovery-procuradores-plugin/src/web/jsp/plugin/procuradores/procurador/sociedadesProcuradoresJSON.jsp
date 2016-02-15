<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:property name="total" value="${pagina.totalCount}" />
		<json:array name="sociedadesProcuradores" items="${pagina.results}" var="sprs">
			<json:object>
				<json:property name="id" value="${sprs.id}"/>
				<json:property name="nombre" value="${sprs.nombre}"/>
			</json:object>
		</json:array>
</fwk:json>
