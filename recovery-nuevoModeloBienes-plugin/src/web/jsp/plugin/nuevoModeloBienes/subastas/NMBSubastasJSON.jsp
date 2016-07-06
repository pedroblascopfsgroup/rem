<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="subastas" items="${pagina.results}" var="subasta">
		<json:object>		
			<json:property name="id" value="${subasta.id}"/>
			
			<%-- RECOVERY-2222 Comprobación para que dependiendo de a que entidad pertenece muestre unas cosas u otras --%>      
	            <c:if test="${subasta.tramitacion==true}">
	            	<json:property name="tramitacion">
	            		<s:message code="plugin.nuevoModeloBienes.subastas.sElectronica" text="**S. electrónica" />
	            	</json:property>
	            	<c:if test="${usuarioEntidad.entidad.codigo == 'HCJ'}">
	        		    <json:property name="tasacion" value="${subasta.tasacionElectronica}" />
    	    		</c:if>
    	    		<c:if test="${usuarioEntidad.entidad.codigo != 'HCJ'}">
		            	<json:property name="tasacion" value="${subasta.tasacion}" />
					</c:if>           		
	            </c:if>	
				<c:if test="${subasta.tramitacion==false || subasta.tramitacion==null}">
					<json:property name="tramitacion">
						<s:message code="plugin.nuevoModeloBienes.subastas.subasta" text="**Subasta" />
					</json:property>
	            	<json:property name="tasacion" value="${subasta.tasacion}" />	
				</c:if>	
			
			<json:property name="idAsunto" value="${subasta.asunto.id}"/>
			<json:property name="nombreAsunto" value="${subasta.asunto.nombre}"/>
			
			<json:property name="numAutos" value="${subasta.procedimiento.codigoProcedimientoEnJuzgado}" />
			
			<json:property name="fechaSolicitud">
				<fwk:date value="${subasta.fechaSolicitud}"/>
			</json:property>					
			
			
			<json:property name="fechaAnuncio">
				<fwk:date value="${subasta.fechaAnuncio}"/>
			</json:property>			
			
			
			<json:property name="fechaSenyalamiento">
				<fwk:date value="${subasta.fechaSenyalamiento}"/>
			</json:property>
						
			
			<json:property name="fechaPublicacionBoe" >
            	<fwk:date value="${subasta.fechaPublicacionBOE}" />
            </json:property>
            
			<json:property name="estadoSubasta" value="${subasta.estadoSubasta.descripcion}" />
						
			<json:property name="embargo" value="${subasta.embargo}" />

			<json:property name="infLetrado" value="${subasta.infoLetrado}" />
			
			<json:property name="instrucciones" value="${subasta.instrucciones}" />
			
			<json:property name="subastaRevisada" value="${subasta.subastaRevisada}" />
			
			<json:property name="cargasAnteriores" value="${subasta.cargasAnteriores}" />
			
			<json:property name="totalImporteAdjudicado" value="${subasta.totalImporteAdjudicado}" />
			
			<json:property name="plaza" value="${subasta.procedimiento.juzgado.plaza.descripcion}" />
			
			<json:property name="juzgado" value="${subasta.procedimiento.juzgado.descripcion}" />
			
			<json:property name="despacho" value="${subasta.asunto.gestor.despachoExterno.descripcion}" />
			
			<json:property name="procurador" value="${subasta.asunto.procurador.usuario.apellidoNombre}" />

			<c:if test="${subasta.asunto.gestionAsunto != null}">
				<json:property name="gestionAsunto" value="${subasta.asunto.gestionAsunto.descripcion}" />
			</c:if>
			<c:if test="${subasta.asunto.propiedadAsunto != null}">
				<json:property name="propiedadAsunto" value="${subasta.asunto.propiedadAsunto.descripcion}" />
			</c:if>

 		</json:object>
	</json:array>
</fwk:json>