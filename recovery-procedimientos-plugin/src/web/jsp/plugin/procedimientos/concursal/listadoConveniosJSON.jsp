<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
	<json:array name="convenios" items="${pagina}" var="conv">
		<json:object>
			<json:property name="numeroAuto" value="${conv.numeroAuto}" />
			<json:property name="idProcedimiento" value="${conv.idProcedimientoGenerador}" />
		</json:object>
		<c:forEach items="${conv.convenios}" var="c">
			<json:object>
				<json:property name="numeroAutoEnLinea"
					value="${conv.numeroAuto}" />
				<json:property name="tipo"
					value="${c.tipoConvenio.descripcion}" />	
				<json:property name="idConvenio"
					value="${c.id}" />
				<json:property name="fechaPropuesta">
					<fwk:date value="${c.fecha}" />
				</json:property>
				<json:property name="numProponentes"
					value="${c.numProponentes}" />
				<json:property name="totalMasa">
 					<pfsformat:money value="${c.totalMasa}"/>
 				</json:property>  
				<json:property name="porcentaje"
					value="${c.porcentaje}" />
				<json:property name="inicio"
					value="${c.inicioConvenio.descripcion}" />					
				<json:property name="estado"
					value="${c.estadoConvenio.descripcion}" />
				<json:property name="adhesion"
					value="${c.tipoAdhesion.descripcion}" />					
				<json:property name="postura"
					value="${c.posturaConvenio.descripcion}" />															
				<json:property name="descripProponentes"
					value="${c.descripcion}" />
			</json:object>
		</c:forEach>
	</json:array>
</fwk:json>

