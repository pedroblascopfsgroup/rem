<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="bienes" items="${bienes}" var="bie">
		<json:object>
			<json:property name="id" value="${bie.id}" />
			<json:property name="codigo" value="${bie.codigoInterno}" />
			<json:property name="numeroActivo" value="${bie.numeroActivo}" />
			<json:property name="origen" value="${bie.origen.descripcion}" />
			<json:property name="descripcion" value="${bie.descripcion}" />
			<json:property name="habitual" value="${bie.habitual}" />
			<json:property name="adjudicacion" value="${bie.adjudicacionOK}" />
			<json:property name="saneamiento" value="${bie.saneamientoOK}" />
			<json:property name="posesion" value="${bie.posesionOK}" />
			<json:property name="llaves" value="${bie.llavesOK}" />
			<json:property name="tareaActivaAdjudicacion" value="${bie.tareaActivaAdjudicacion}" />
			<json:property name="tareaActivaSaneamiento" value="${bie.tareaActivaSaneamiento}" />
			<json:property name="tareaActivaPosesion" value="${bie.tareaActivaPosesion}" />
			<json:property name="tareaActivaLlaves" value="${bie.tareaActivaLlaves}" />
			<json:property name="numFinca" value="${bie.numFinca}" />
		</json:object>
	</json:array>
</fwk:json>



