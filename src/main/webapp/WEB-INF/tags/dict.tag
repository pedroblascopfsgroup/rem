<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ tag body-content="scriptless"%>
<%@ attribute name="value" required="true" type="java.util.List"%>
<%@ attribute name="blankElement" required="false" type="java.lang.Boolean"%>
<%@ attribute name="blankElementText" required="false" type="java.lang.String"%>
<%@ attribute name="blankElementValue" required="false" type="java.lang.String"%>
<json:object>
		<json:array name="diccionario" items="${value}" var="d">	
			 <c:if test="${blankElement}">
		 	 		<json:object>
			 			<json:property name="codigo" value="${blankElementValue}"/>
				 		<json:property name="descripcion" value="${blankElementText}" />
			 		</json:object>
			 		<c:set var="blankElement" value="false"/>
			 </c:if>
		 <json:object>
		   <json:property name="codigo" value="${d.codigo}" />
		   <json:property name="descripcion" value="${d.descripcion}" />
		 </json:object>
		</json:array>
</json:object>