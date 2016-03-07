<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
	<json:array name="bienesPrc" items="${bienesPrc}" var="bien">
		<json:object>         	
			<json:property name="idBien" value="${bien.id}" />
            <json:property name="codigo" value="${bien.codigo}" />
            <json:property name="origen" value="${bien.origen}" />
            <json:property name="descripcion" value="${bien.descripcion}" />
            <json:property name="tipo" value="${bien.tipo}" />
            <json:property name="solvencia" value="${bien.solvencia}" /> 
            <json:property name="codSolvencia" value="${bien.codSolvencia}" />
            <json:property name="numeroActivo" value="${bien.numActivo}"/>
			<json:property name="referenciaCatastral" value="${bien.referenciaCatastral}"/>
			<json:property name="numFinca" value="${bien.numFinca}"/>
		</json:object>
	</json:array>	
</fwk:json> 

