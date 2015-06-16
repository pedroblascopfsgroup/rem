<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:array name="bienes" items="${bienes}" var="bien">
        <json:object>
			<json:property name="idLoteBien" value="${s.lote.id}" /> 
			<json:property name="idBien" value="${bien.id}" />
            <json:property name="numActivo" value="${bien.numeroActivo}" />
			<json:property name="referenciaCatastral" value="${bien.referenciaCatastral}"/>
            <json:property name="codigo" value="${bien.codigoInterno}" />
            <json:property name="origen" value="${bien.origen.descripcion}" />
            <json:property name="descripcion" value="${bien.descripcion}" />
            <json:property name="tipo" value="${bien.tipoBien.descripcion}" />
            <json:property name="viviendaHabitual" value="${bien.viviendaHabitual}" />
            <json:property name="sitPosesoria" value="${bien.situacionPosesoria.descripcion}" />
            <json:property name="revCargas">
				<fwk:date value="${bien.adicional.fechaRevision}"/>
			</json:property>
            <c:if test="${bien.valoraciones != null}">
    	        <json:property name="fSolTasacion">
					<fwk:date value="${bien.valoraciones[0].fechaSolicitudTasacion}"/>
				</json:property>
				<json:property name="fTasacion">
					<fwk:date value="${bien.valoraciones[0].fechaValorTasacion}"/>
				</json:property>		            	
           	</c:if>
           	<c:if test="${bien.adjudicacion != null}">
            	<json:property name="Adjudicacion" value="${bien.adjudicacion.entidadAdjudicataria.descripcion}" />
	            <json:property name="impAdjudicado" value="${bien.adjudicacion.importeAdjudicacion}" />		            
            </c:if>
            <c:if test="${bien.adjudicacion == null}">
            	<json:property name="Adjudicacion" value="-" />
	            <json:property name="impAdjudicado" value="" />		            
            </c:if>
            <c:forEach items="${bien.informacionRegistral}" var="infoReg">
				<json:property name="numFinca" value="${infoReg.numFinca}"/>
			</c:forEach>
		</json:object>
    </json:array>
</fwk:json> 

