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
            <json:property name="plaza" value="${d.tipoPlaza.descripcion}"/>
            <json:property name="tipoProcedimiento" value="${d.tipoProcedimiento.descripcion}"/>
            <json:property name="importeDesde" value="${d.configuracion[0].importeDesde}"/>
            <json:property name="importeHasta" value="${d.configuracion[0].importeHasta}"/>
            <json:property name="despacho" value="${d.configuracion[0].usuario.username}"/>
            <json:property name="porcentaje" value="${d.configuracion[0].porcentaje}"/>
        </json:object>
          <c:forEach items="${d.configuracion}" var="c">
           	<c:if test="${c.id!=c.configuracion[0].id}">
		        <json:object>
		            <json:property name="importeDesde" value="${c.importeDesde}"/>
		            <json:property name="importeHasta" value="${c.importeHasta}"/>
		            <json:property name="despacho" value="${c.usuario.username}"/>
		            <json:property name="porcentaje" value="${c.porcentaje}"/>
		        </json:object>
		    </c:if>
	      </c:forEach>  
    </json:array>
    <%-- Fin lista de configuraciones del esquema bien formateada --%>
    
    <json:array name="plazasEsquema" items="${plazasEsquema}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="codigo" value="${d.codigo}"/>
            <json:property name="descripcion" value="${d.descripcion}"/>
        </json:object>
    </json:array>
    <json:array name="tipoProcedimientos" items="${tipoProcedimientos}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="codigo" value="${d.codigo}"/>
            <json:property name="descripcion" value="${d.descripcion}"/>
        </json:object>
    </json:array>
    <json:array name="idTuplas" items="${idTuplas}" var="d">
        <json:object>
            <json:property name="idTupla" value="${d}"/>
        </json:object>
    </json:array>
    <json:property name="resultado" value="${resultado}"/>
</fwk:json>