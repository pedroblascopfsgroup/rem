<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${listaCarteras.totalCount}" />
	
	<json:array name="carteras" items="${listaCarteras.results}" var="cartera">
		<json:object>			 
			<json:property name="id" value="${cartera.id}" />
			<json:property name="nombre" value="${cartera.nombre}" />
			<json:property name="descripcion" value="${cartera.descripcion}" />
			<json:property name="estado" value="${cartera.estado.descripcion}" />
			<json:property name="regla" value="${cartera.regla.name}" />		
			<json:property name="idRegla" value="${cartera.regla.id}" />
			<json:property name="codigoEstado" value="${cartera.estado.codigo}" />
			<json:property name="propietario" value="${cartera.propietario.username}" />	
			<json:property name="idPropietario" value="${cartera.propietario.id}" />		
			<json:property name="fechaAlta" >
				<fwk:date value="${cartera.fechaAlta}"/>
	  		</json:property>
	  		<json:property name="enEsquemaVigente">
				<c:if test="${cartera.enEsquemaVigente}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!cartera.enEsquemaVigente}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>		
		</json:object>
	</json:array>
	
</fwk:json>
