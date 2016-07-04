<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
	
<fwk:json>
    <json:array name="subastas" items="${subastas}" var="s">
        <json:object>
            <json:property name="id" value="${s.id}" />
            <json:property name="numAutos" value="${s.procedimiento.codigoProcedimientoEnJuzgado}" />
            <%-- RECOVERY-2219 Comprobación para que dependiendo de a que entidad pertenece muestre unas cosas u otras --%>
	            <c:if test="${s.tramitacion==true}">
	            	<json:property name="tramitacion">
	            		<s:message code="plugin.nuevoModeloBienes.subastas.sElectronica" text="**S. electrónica" />
	            	</json:property>
	        	    <json:property name="resultadoComite" value="${s.resultadoComiteSub.descripcion}" />	
	           		<json:property name="motivoSuspension" value="${s.motivoSuspensionElec.descripcion}" />
	           		<c:if test="${usuarioEntidad == 'HCJ'}">
	                <json:property name="tasacion" value="${s.tasacionElectronica}" />  
	                </c:if>
	                <c:if test="${usuarioEntidad != 'HCJ'}">
       	            	<json:property name="tasacion" value="${s.tasacion}" />
	                </c:if>	  		
	            </c:if>	
				<c:if test="${s.tramitacion==false || s.tramitacion==null}">
					<json:property name="tramitacion">
						<s:message code="plugin.nuevoModeloBienes.subastas.subasta" text="**Subasta" />
					</json:property>
		            <json:property name="resultadoComite" value="${s.resultadoComite.descripcion}" />
	           		<json:property name="motivoSuspension" value="${s.motivoSuspension.descripcion}" />
	            	<json:property name="tasacion" value="${s.tasacion}" />	
				</c:if>	
            <json:property name="idProcedimiento" value="${s.procedimiento.id}" />
            <json:property name="prcDescripcion" value="${s.procedimiento.nombreProcedimiento}" />
            <json:property name="tipo" value="${s.tipoSubasta.descripcion}" />
            <json:property name="fechaSolicitud" >
            	<fwk:date value="${s.fechaSolicitud}" />
            </json:property>
            <json:property name="fechaAnuncio" >
            	<fwk:date value="${s.fechaAnuncio}" />
            </json:property>
            <json:property name="fechaSenyalamiento" >
            	<fwk:date value="${s.fechaSenyalamiento}" />
            </json:property>
            <json:property name="fechaPublicacionBoe" >
            	<fwk:date value="${s.fechaPublicacionBOE}" />
            </json:property>
            <json:property name="codEstadoSubasta" value="${s.estadoSubasta.codigo}" />
            <json:property name="estadoSubasta" value="${s.estadoSubasta.descripcion}" />
            
            <json:property name="infoLetrado" value="${s.infoLetrado}" />
            <json:property name="instrucciones" value="${s.instrucciones}" />
            <json:property name="subastaRevisada" value="${s.subastaRevisada}" />
        </json:object>
    </json:array>
</fwk:json> 

