<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="personasBien" items="${personasBien}" var="pb">
		<json:object>
			<json:property name="idPersonaBien" value="${pb.id}"/>
			<json:property name="idBien" value="${pb.bien.id}"/>
			<json:property name="idPersona" value="${pb.persona.id}"/>
			<json:property name="apellidoNombre" value="${pb.persona.apellidoNombre}"/>
			<json:property name="participacion" value="${pb.participacion}"/>
			<json:property name="segmento" value="${pb.persona.segmento.descripcion}" />
			<json:property name="deudaIrregular" value="${pb.persona.deudaIrregular}"/>
			<json:property name="totalSaldo" value="${pb.persona.riesgoTotal}"/>
			<json:property name="deudaDirecta" value="${pb.persona.riesgoDirecto}"/>
			<json:property name="numContratos" value="${pb.persona.numContratos}" />
			<json:property name="diasVencido" value="${pb.persona.diasVencido}" />
			<json:property name="situacion" value="${pb.persona.situacion}" />
 		</json:object>
	</json:array>
</fwk:json>
