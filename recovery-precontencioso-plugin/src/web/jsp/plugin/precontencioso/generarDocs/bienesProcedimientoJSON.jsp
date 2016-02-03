<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
	<json:array name="bienesPrc" items="${bienesPrc}" var="item">
		<json:object>         	
			<json:property name="idBien" value="${item.bien.id}" />
<%--             <json:property name="codigo" value="${item.bien.codigo}" /> --%>
<%--             <json:property name="origen" value="${item.bien.origen}" /> --%>
<%--             <json:property name="descripcion" value="${item.bien.descripcion}" /> --%>
<%--             <json:property name="tipo" value="${item.bien.tipo}" /> --%>
<%--             <json:property name="solvencia" value="${item.bien.solvencia}" />  --%>
<%--             <json:property name="codSolvencia" value="${item.bien.codSolvencia}" /> --%>
<%--             <json:property name="numeroActivo" value="${item.bien.numActivo}"/> --%>
<%-- 			<json:property name="referenciaCatastral" value="${item.bien.referenciaCatastral}"/> --%>
<%-- 			<json:property name="numFinca" value="${item.bien.numFinca}"/> --%>
		</json:object>
	</json:array>	
</fwk:json> 

