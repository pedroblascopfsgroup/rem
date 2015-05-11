<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="perfiles" items="${centros}" var="c">
		<json:object>
			<json:property name="id" value="${c.id}"/>
			<json:property name="zonid" value="${c.zona.id}"/>
			<json:property name="pefid" value="${c.perfil.id}"/>
			<json:property name="usuid" value="${c.usuario.id}"/>
			<json:property name="centro" value="${c.zona.descripcion}" />
			<json:property name="perfil" value="${c.perfil.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>