<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<%-- Lista de configuraciones del esquema bien formateada --%>
	 <json:array name="rangosEsquema" items="${listaConfiguraciones}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="idPlazaTpo" value="${d.id}"/>
            <c:choose>
	            <c:when test="${d.tipoPlaza!=null}">
	           		<json:property name="plazaId" value="${d.tipoPlaza.id}"/>
	           		<json:property name="plaza" value="${d.tipoPlaza.descripcion}"/>
	           	</c:when>
	           	<c:otherwise>
	           		<json:property name="plazaId" value="-1"/>
	           		<json:property name="plaza" value="PLAZA POR DEFECTO"/>
	           	</c:otherwise>
           	</c:choose>
           	<c:choose>
	           	<c:when test="${d.tipoProcedimiento!=null}">
		            <json:property name="tipoProcedimientoId" value="${d.tipoProcedimiento.id}"/>
	           		<json:property name="tipoProcedimiento" value="${d.tipoProcedimiento.descripcion}"/>
	           	</c:when>
	           	<c:otherwise>
	           		<json:property name="tipoProcedimientoId" value="-1"/>
	           		<json:property name="tipoProcedimiento" value="PROCEDIMIENTO POR DEFECTO"/>
	           	</c:otherwise>
	        </c:choose>
			<c:if test="${nuevaConfig}">
     			<json:property name="plaza" value="---"/>
     			<json:property name="tipoProcedimiento" value="---"/>
   			</c:if>
            <c:if test="${d.configuracion[0]!=null}">
            	<json:property name="rangoId" value="${d.configuracion[0].id}"/>
	            <json:property name="importeDesde" value="${d.configuracion[0].importeDesde}"/>
	            <json:property name="importeHasta" value="${d.configuracion[0].importeHasta}"/>
	            <json:property name="despacho" value="${d.configuracion[0].usuario.nombre}"/>
	            <json:property name="porcentaje" value="${d.configuracion[0].porcentaje}"/>
            </c:if>
        </json:object>
          <c:forEach items="${d.configuracion}" var="c">
           	<c:if test="${c.id!=d.configuracion[0].id}">
		        <json:object>
		        	<json:property name="idPlazaTpo" value="${d.id}"/>
		        	<json:property name="plazaId" value="${d.tipoPlaza.id}"/>
		        	<c:choose>
			           	<c:when test="${d.tipoPlaza!=null}">
				            <json:property name="plazaId" value="${d.tipoPlaza.id}"/>
			           	</c:when>
	           			<c:otherwise>
	           				<json:property name="plazaId" value="-1"/>
	           			</c:otherwise>
	        		</c:choose>
	        		<c:choose>
			           	<c:when test="${d.tipoProcedimiento!=null}">
				            <json:property name="tipoProcedimientoId" value="${d.tipoProcedimiento.id}"/>
			           	</c:when>
	           			<c:otherwise>
	           				<json:property name="tipoProcedimientoId" value="-1"/>
	           			</c:otherwise>
	        		</c:choose>
		            <json:property name="rangoId" value="${c.id}"/>
		            <json:property name="importeDesde" value="${c.importeDesde}"/>
		            <json:property name="importeHasta" value="${c.importeHasta}"/>
		            <json:property name="despacho" value="${c.usuario.nombre}"/>
		            <json:property name="porcentaje" value="${c.porcentaje}"/>
		        </json:object>
		    </c:if>
	      </c:forEach>  
    </json:array>
    <%-- Fin lista de configuraciones del esquema bien formateada --%>
    
    <%-- Lista de plazas del esquema para los combos y grids --%>
    <json:array name="plazasEsquema" items="${plazasEsquema}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="codigo" value="${d.codigo}"/>
            <json:property name="descripcion" value="${d.descripcion}"/>
        </json:object>
    </json:array>
    
    <%-- Lista de tipos de procedimientos para los combos y grids --%>
    <json:array name="tipoProcedimientos" items="${tipoProcedimientos}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="codigo" value="${d.codigo}"/>
            <json:property name="descripcion" value="${d.descripcion}"/>
        </json:object>
    </json:array>
    
    <%-- Lista de ids de los pares plaza-tpo que se han persistido pero no confirmado por no haberse terminado la edicion --%>
    <json:array name="idTuplas" items="${idTuplas}" var="d">
        <json:object>
            <json:property name="idTupla" value="${d}"/>
        </json:object>
    </json:array>
    
    <%-- Lista de ids de los rangos generados --%>
    <json:array name="idsRangos" items="${idsRangos}" var="d">
        <json:object>
            <json:property name="idRango" value="${d}"/>
        </json:object>
    </json:array>
    
    <%-- Lista de ids de los rangos generados --%>
     <json:array name="idsRangosBorrados" items="${idsRangosBorrados}" var="d">
        <json:object>
            <json:property name="idRango" value="${d}"/>
        </json:object>
    </json:array>
    
    <%-- Modificaciones realizadas en los rangos --%>
    <json:array name="modificacionesRangos" items="${modificacionesRangos}" var="d">
        <json:object>
            <json:property name="rango" value="${d}"/>
        </json:object>
    </json:array>
    
    <json:property name="resultado" value="${resultado}"/>
    
</fwk:json>