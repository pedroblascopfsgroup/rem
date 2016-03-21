<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:property name="total" value="${pagina.totalCount}" />
		<json:array name="recordatorios" items="${pagina.results}" var="rec">
			<json:object>
				<json:property name="id" value="${rec.id}"/>
				<json:property name="titulo" value="${rec.titulo}"/>
				<json:property name="descripcion" value="${rec.descripcion}"/>
				<json:property name="fecha" value="${rec.fecha}"/>
				<json:property name="fechaTareaUno" value="${rec.tareaUno.fechaVenc}"/>
				<json:property name="fechaTareaDos" value="${rec.tareaDos.fechaVenc}"/>
				<json:property name="fechaTareaTres" value="${rec.tareaTres.fechaVenc}"/>
				<json:property name="categoria" value="${rec.categoria.nombre}"/>
			</json:object>
		</json:array>
</fwk:json>
