<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="data" items="${pagina.results}" var="p">
		 <json:object>
		 	   <json:property name="id" value="${p.persona.id}" />	
			   <json:property name="nombre" value="${p.persona.apellidoNombre}" />
			   <json:property name="nif" value="${p.persona.docId}" />
			   <json:property name="tipoPersona" value="${p.persona.tipoPersona.descripcion}"/>
			   <json:property name="tipoRelacionGrupo" value="${p.tipoRelacionGrupo.descripcion}"/>
			   <json:property name="volRiesgoCliente" value="${p.persona.riesgoDirecto}"/>
			   <json:property name="volRiesgoVencidoCliente" value="${p.persona.deudaIrregularDirecta}"/>
			   <json:property name="segmento" value="${p.persona.segmento.descripcion}"/>
			   <json:property name="situacion" value="${p.persona.situacion}"/>
		 </json:object>
	</json:array>
</fwk:json>

