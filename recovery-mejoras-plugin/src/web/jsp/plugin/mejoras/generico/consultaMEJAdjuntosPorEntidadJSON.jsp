<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="adjuntos" items="${entities}" var="entity">
			<json:object>
				<json:property name="descripcionEntidad" value="${entity.descripcion}" />
				<json:property name="idEntidad" value="${entity.id}" />
					<c:if test="${entity.adjuntosAsList != null}">
						<json:property name="id" value="${entity.adjuntosAsList[0].id}" />
						<json:property name="nombre" value="${entity.adjuntosAsList[0].nombre}" />
						<json:property name="contentType" value="${entity.adjuntosAsList[0].contentType}" />
						<json:property name="length" value="${entity.adjuntosAsList[0].length}" />
						<json:property name="descripcion" >
							<pfsformat:cut value="${entity.adjuntosAsList[0].descripcion}" max="27"/>
						</json:property>
						<json:property name="fechaCrear" >
							<fwk:date value="${entity.adjuntosAsList[0].auditoria.fechaCrear}"/>
						</json:property>
					</c:if>
			</json:object>
			<c:if test="${entity.adjuntos!=null}">
	            <c:forEach items="${entity.adjuntos}" var="adj">
					<c:if test="${adj.id!=entity.adjuntosAsList[0].id}">
			        	<json:object>
							<json:property name="id" value="${adj.id}" />
							<json:property name="nombre" value="${adj.nombre}" />
							<json:property name="contentType" value="${adj.contentType}" />
							<json:property name="length" value="${adj.length}" />
							<json:property name="descripcion" >
								<pfsformat:cut value="${adj.descripcion}" max="27"/>
							</json:property>
							<json:property name="fechaCrear">
							 	<fwk:date value="${adj.auditoria.fechaCrear}"/>
							</json:property>
			            </json:object>
					</c:if>
	            </c:forEach>
            </c:if>
	</json:array>
</fwk:json>
