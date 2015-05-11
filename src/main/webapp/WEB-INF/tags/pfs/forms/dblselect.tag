<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="scriptless"%>

<%@ attribute name="name" required="true" type="java.lang.String"%>
<%@ attribute name="label" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="dd" required="true" type="java.util.List"%>
<%@ attribute name="width" required="false" type="java.lang.Integer"%>
<%@ attribute name="height" required="false" type="java.lang.Integer"%>
<%@ attribute name="store" required="false" type="java.lang.String"%>
<%@ attribute name="propertyCodigo" required="false" type="java.lang.String"%>
<%@ attribute name="propertyDescripcion" required="false" type="java.lang.String"%>
<%@ attribute name="resetAll" required="false" type="java.lang.Boolean"%>

<c:set value="${name}Diccionario" var="nombreDiccionario"/>


<c:set var="_cod" value="id" />
<c:set var="_des" value="descripcion" />

<c:if test="${propertyCodigo != null}">
	<c:set var="_cod" value="${propertyCodigo}" />
</c:if>

<c:if test="${propertyDescripcion != null}">
	<c:set var="_des" value="${propertyDescripcion}" />
</c:if>

<c:if test="${blankElement == null}">
	<c:set value="false" var="blankElement"/>
</c:if>
<c:if test="${blankElementValue == null}">
	<c:set value="" var="blankElementValue"/>
</c:if>
<c:if test="${blankElementText == null}">
	<c:set value="---" var="blankElementText"/>
</c:if>

var ${nombreDiccionario} = <json:object>
		<json:array name="diccionario" items="${dd}" var="d">	
			 <c:if test="${blankElement}">
		 	 		<json:object>
			 			<json:property name="codigo" value="${blankElementValue}"/>
				 		<json:property name="descripcion" value="${blankElementText}" />
			 		</json:object>
			 		<c:set var="blankElement" value="false"/>
			 </c:if>
		 <json:object>
			 <json:property name="codigo" value="${pageScope['d'][_cod]}" />
		 	 <json:property name="descripcion" value="${pageScope['d'][_des]}" />
		 </json:object>
		</json:array>
</json:object>;

var ${name}_config = {
	a:1
	<c:if test="${width != null}">,width: ${width}</c:if>
	<c:if test="${height != null}">,height: ${height}</c:if>
	<c:if test="${store != null}">,store: ${store}</c:if>
	<c:if test="${resetAll != null && resetAll==true}">,funcionReset: function() { this.toStore.removeAll(); this.fromStore.removeAll(); }</c:if>
};
var ${name} = app.creaDblSelect(${nombreDiccionario}, '<s:message code="${labelKey}" text="${label}" />',${name}_config);