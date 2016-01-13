<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="terminosAcuerdo" items="${listadoTerminosAcuerdo}" var="termino">
		<json:object>
			<json:property name="id" value="${termino.id}" />
	        <json:property name="tipoAcuerdo" value="${termino.tipoAcuerdo.descripcion}" />
	        <json:property name="codigoTipoAcuerdo" value="${termino.tipoAcuerdo.codigo}" />   
	        <json:property name="subTipoAcuerdo" value="${termino.subTipoAcuerdo.descripcion}" />                
	        <json:property name="importe" value="${termino.importe}" />
	        <json:property name="comisiones" value="${termino.comisiones}" />  
	        <json:property name="estadoGestion" value="${termino.estadoGestion.descripcion}" />
	        <c:if test="${termino.contratosTermino[0] != null}">
		        <json:property name="idContrato" value="${termino.contratosTermino[0].id}"/>
	            <json:property name="cc" value="${termino.contratosTermino[0].codigoContrato}" />                 
<%-- 	            <json:property name="tipo" value="${termino.contratosTermino[0].tipoProducto.descripcion}" /> --%>
	            <json:property name="tipo" value="${termino.contratosTermino[0].tipoProductoEntidad.descripcion}" />
	            
	            
	            <json:property name="estadoFinanciero" value="${termino.contratosTermino[0].estadoFinanciero.descripcion}" />
	        </c:if>
		</json:object>
		<c:forEach items="${termino.contratosTermino}" var="cont">
			<c:if test="${cont.id != termino.contratosTermino[0].id}">
				<json:object>
					<json:property name="idContrato" value="${cont.id}"/>
		            <json:property name="cc" value="${cont.codigoContrato}" />                 
		            <json:property name="tipo" value="${cont.tipoProducto.descripcion}" />
		            <json:property name="estadoFinanciero" value="${cont.estadoFinanciero.descripcion}" />
		         </json:object>
		     </c:if>			
        </c:forEach> 
	</json:array>
	
</fwk:json>