<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="objetivos" items="${listadoObjetivos}" var="objetivo">
		<json:object>
			<json:property name="id" value="${objetivo.id}" />
			<json:property name="idPersona" value="${objetivo.politica.cicloMarcadoPolitica.persona.id}" />
			<json:property name="cliente" value="${objetivo.politica.cicloMarcadoPolitica.persona.apellidoNombre}" />
			<json:property name="resumen" value="${objetivo.resumen}" />
			<json:property name="fvencimiento" >
					<fwk:date value="${objetivo.fechaLimite}"/>
			</json:property>
			
			<json:property name="group">
					<app:groupObjetivos value="${objetivo.fechaLimite}" />
			</json:property>
			
			
			<json:property name="politica" value="${objetivo.politica.tipoPolitica.descripcion}" />
			<json:property name="finiciopolitica" >
					<fwk:date value="${objetivo.politica.auditoria.fechaCrear}"/>
				</json:property>
			<json:property name="objetivos" value="${objetivo.politica.cantidadObjetivos}" />
			
		</json:object>
	</json:array>
</fwk:json>