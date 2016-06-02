<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:array name="entidadesAdjudicatorias" items="${entidadesAdjudicatorias}" var="ent">
			<json:object>
				<json:property name="id" value="${ent.id}"/>
				<json:property name="codigo" value="${ent.codigo}"/>
				<json:property name="descripcion" value="${ent.descripcion}"/>
				<json:property name="descripcionLarga" value="${ent.descripcionLarga}"/>
			</json:object>
		</json:array>
</fwk:json>
