<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="result" escapeXml="false">
<b>información de la tarea</b><br>
estado : ${tareaExterna.tareaProcedimiento.codigo}<br>
detenida : ${tareaExterna.detenida}<br>
alerta : ${tareaExterna.tareaPadre.alerta}<br>
fechaInicio: ${tareaExterna.tareaPadre.fechaInicio}<br>
fechaFin: ${tareaExterna.tareaPadre.fechaFin}<br>
<b>Información del token</b>
nombre : ${token.fullName}</b>
enter: ${token.nodeEnter}
	</json:property>
</fwk:json>

