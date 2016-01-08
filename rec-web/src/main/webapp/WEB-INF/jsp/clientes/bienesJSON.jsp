<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:array name="bienes" items="${bienes}" var="b">
		<json:object>
			<json:property name="id" value="${b.id}"/>
			<json:property name="tipo" value="${b.tipoBien}"/>
			<json:property name="detalle" value="${b.descripcionBien}"/>
			<json:property name="datosRegistrales" value="${b.datosRegistrales}" />
			<json:property name="refCatastral" value="${b.referenciaCatastral}" />
			<json:property name="participacion" value="${b.participacion}" />
			<json:property name="poblacion" value="${b.poblacion}" />
			<json:property name="importeCargas" value="${b.importeCargas}" />
			<json:property name="valorActual" value="${b.valorActual}" />
			<json:property name="superficie" value="${b.superficie}" />
			<json:property name="descripcion" value="${b.descripcionBien}" />
            <json:property name="fechaVerificacion">
                <fwk:date value="${b.fechaVerificacion}" />
            </json:property>
			<%-- detalles de la configuracion --%> 
			<json:property name="email" value="${b.tipoBien.configuracionMailTipoBien.destinatario}" />
			<json:property name="idconfigmail" value="${b.tipoBien.configuracionMailTipoBien.id}" />
 		</json:object>
	</json:array>
</fwk:json>
