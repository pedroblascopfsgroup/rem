<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
	<json:array name="bienesPrc" items="${bienesPrc}" var="item">
		<json:object>         	
			<json:property name="idBien" value="${item.bien.id}" />
<%--             <json:property name="codigo" value="${item.codigo}" /> --%>
<%--             <json:property name="origen" value="${item.origen}" /> --%>
<%--             <json:property name="descripcion" value="${item.descripcion}" /> --%>
<%--             <json:property name="tipo" value="${item.tipo}" /> --%>
<%--             <json:property name="solvencia" value="${item.solvencia}" />  --%>
<%--             <json:property name="codSolvencia" value="${item.codSolvencia}" /> --%>
<%--             <json:property name="numeroActivo" value="${item.numActivo}"/> --%>
<%-- 			<json:property name="referenciaCatastral" value="${item.referenciaCatastral}"/> --%>
<%-- 			<json:property name="numFinca" value="${item.numFinca}"/> --%>
		</json:object>
	</json:array>	
</fwk:json> 

