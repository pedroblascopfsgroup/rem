<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="value" required="true" type="java.lang.String"%>
<%@ attribute name="obligatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="searchOnEnter" required="false" type="java.lang.Boolean"%>
<%@ attribute name="allowNegative" required="false" type="java.lang.Boolean"%>
<%@ attribute name="allowDecimals" required="false" type="java.lang.Boolean"%>

<c:set var="emptyObject" value="true" scope="page"/>

<c:if test="${readOnly}">
var ${name}_labelStyle='font-weight:bolder;width:150px';
var ${name} = app.creaLabel('<s:message code='${labelKey}' text='${label}' />',${value},{labelStyle:${name}_labelStyle});
</c:if>

<c:if test="${!readOnly}">
var ${name} = app.creaNumber("${name}","<s:message code="${labelKey}" text="${label}" />","${value}",{
	<c:if test="${obligatory}">
	allowBlank: false
	<c:set var="emptyObject" value="false" />
	</c:if>
	<c:if test="${searchOnEnter}">
	<c:if test="${!emptyObject}">,</c:if>
	enableKeyEvents: true
	,listeners : {
			keypress : function(target,e){
					if((e.getKey() == e.ENTER) && (this.getValue() != '')) {
      					buscarFunc();
  					}
  				}
		}
		<c:set var="emptyObject" value="false" />
	</c:if>
	<c:if test="${!emptyObject}">,</c:if>
	<c:choose>
		<c:when test="${allowNegative}">allowNegative:true</c:when>
		<c:otherwise>allowNegative:false</c:otherwise>
	</c:choose>
	<c:choose>
		<c:when test="${allowDecimals}">
		,allowDecimals:true
		</c:when>
		<c:otherwise>
		,allowDecimals:false
		</c:otherwise>
	</c:choose>
});
</c:if>
