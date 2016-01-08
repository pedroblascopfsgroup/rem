<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="bienes" items="${bienes}" var="b">
		<json:object>
			<json:property name="id" value="${b.id}"/>
			<json:property name="tipo" value="${b.tipoBien}"/>
			<json:property name="detalle" value="${b.descripcionBien}"/>
			<json:property name="datosRegistrales" value="${b.datosRegistrales}" />
			<json:property name="refCatastral" value="${b.referenciaCatastral}" />
			<c:if test="${b.class.simpleName=='NMBBien'}">
				<c:forEach items="${b.NMBpersonas}" var="persona">
					<json:property name="participacion" value="${persona.participacion}" />
				</c:forEach>	
			</c:if>
			<c:if test="${b.class.simpleName!='NMBBien'}">
				<json:property name="participacion" value="${b.participacion}" />
			</c:if>
			<json:property name="poblacion" value="${b.poblacion}" />
			<json:property name="importeCargas" value="${b.importeCargas}" />
			<json:property name="valorActual" value="${b.valorActual}" />
			<json:property name="superficie" value="${b.superficie}" />
			<json:property name="descripcion" value="${b.descripcionBien}" />
			<json:property name="origen" value="${b.class.simpleName=='NMBBien' ? b.origen.descripcion : ''}" />
            <json:property name="fechaVerificacion">
                <fwk:date value="${b.fechaVerificacion}" />
            </json:property>
			<%-- detalles de la configuracion--%> 
			<json:property name="email" value="${b.tipoBien.configuracionMailTipoBien.destinatario}" />
			<json:property name="idconfigmail" value="${b.tipoBien.configuracionMailTipoBien.id}" />
			<%-- nuevo modelo de bienes --%>
			<json:property name="marca" value="${b.class.simpleName=='NMBBien' ? b.marcaExternos : ''}" />
			<json:property name="contratos" value="${b.class.simpleName=='NMBBien' ? b.contratos[0].contrato.codigoContrato : ''}" />
			<json:property name="codigoInterno" value="${b.class.simpleName=='NMBBien' ? b.codigoInterno : ''}" />
 		</json:object>
 		
 		<c:if test="${b.class.simpleName=='NMBBien'}">
	 		<c:forEach items="${b.contratos}" var="cnt">
				<c:if test="${cnt.id!=b.contratos[0].id}">
					<json:object>
						<json:property name="contratos" value="${cnt.contrato.codigoContrato}" />
						<json:property name="participacion" value="---" />
						<json:property name="valorActual" value="---" />
						<json:property name="importeCargas" value="---" />
					</json:object>
				</c:if>
			</c:forEach>
		</c:if>
		
	</json:array>
</fwk:json>
