<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="cargas" items="${cargas}" var="carga">
		<json:object>
			<json:property name="idCarga" value="${carga.idCarga}"/>
			<json:property name="bien" value="${carga.bien.id}"/>
			<json:property name="tipoCarga" value="${carga.tipoCarga.descripcion}"/>
		    <json:property name="letra" value="${carga.letra}"/>
		    <json:property name="titular" value="${carga.titular}"/>
		    <json:property name="importeRegistral" value="${carga.importeRegistral}"/>
		    <json:property name="importeEconomico" value="${carga.importeEconomico}"/>
		    <json:property name="registral" value="${carga.registral}"/>
		    <json:property name="situacionCarga" value="${carga.situacionCarga.descripcion}"/>
		    <json:property name="situacionCargaEconomica" value="${carga.situacionCargaEconomica.descripcion}"/>
		    <json:property name="fechaPresentacion">
		    	<fwk:date value="${carga.fechaPresentacion}"/>
		    </json:property>
		    <json:property name="fechaInscripcion">
		    	<fwk:date value="${carga.fechaInscripcion}"/>
		    </json:property>
		    <json:property name="fechaCancelacion">
		    	<fwk:date value="${carga.fechaCancelacion}"/>
		    </json:property>
		    <json:property name="economica" value="${carga.economica}"/>
 		</json:object>
	</json:array>
</fwk:json>


    
