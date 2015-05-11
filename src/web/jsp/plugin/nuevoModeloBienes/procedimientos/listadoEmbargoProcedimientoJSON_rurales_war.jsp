<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
		<json:object>
			<json:property name="id" value="${rec.id}"/>
			<json:property name="descripcion" value="${rec.descripcionBien}"/>
			<json:property name="tipo" value="${rec.tipoBien.descripcion}"/>
			<json:property name="origen" value="${rec.class.simpleName=='NMBBien' ? rec.origen.descripcion : ''}" />
			<json:property name="marca" value="${rec.class.simpleName=='NMBBien' ? rec.marcaExternos : ''}" />
			<json:property name="cargaBien" value="${rec.importeCargas}"/>
			<c:if test="${rec.class.simpleName=='NMBBien'}">
				<c:forEach items="${rec.NMBEmbargosProcedimiento}" var="ins">			
					<c:if test="${ins.procedimiento.id == idProcedimiento}">
						<json:property name="idEmbargo" value="${ins.id}"/>
							<json:property name="letra" value="${ins.letra}"/>
						<json:property name="fechaSolicitud" >
							<fwk:date value="${ins.fechaSolicitud}"/>
						</json:property>
						<json:property name="fechaDecreto" >
							<fwk:date value="${ins.fechaDecreto}"/>
						</json:property>
						<json:property name="fechaRegistro" >
							<fwk:date value="${ins.fechaRegistro}"/>
						</json:property>
						<json:property name="fechaAdjudicacion" >
							<fwk:date value="${ins.fechaAdjudicacion}"/>
						</json:property>	
						<json:property name="fechaDenegacion" >
							<fwk:date value="${ins.fechaDenegacion}"/>
						</json:property>
				    	</c:if>
				</c:forEach>
			</c:if>
			<c:forEach items="${rec.personas}" var="per">
				<json:property name="titular" value="${per.apellido1} , ${per.nombre}"/>
			</c:forEach>
		</json:object>
	</json:array>
</fwk:json>

