<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ tag body-content="empty"%>
<%@ tag dynamic-attributes="dynattrs" %>
<%@ tag import="java.util.*" %>

<%@ attribute name="paramId" required="true" type="java.lang.String"%>
<%@ attribute name="name" required="true" type="java.lang.String"%>

var ${name} = function(){
		return {
					"--": "--"
      				 
      				 <c:forEach var="a" items="${dynattrs}">
      				 <c:set var="key" value="${a.key}" />
      				 <c:set var="value" value="${a.value}" />
      				 <%
      				 	String clave =  jspContext.getAttribute("key").toString();
      				 	String control = jspContext.getAttribute("value").toString();
      				 	String valor = control.concat(".getValue()");
      				 	String formato = null;
      				 	StringTokenizer tk = new StringTokenizer(clave,"_");
      				 	clave = tk.nextToken();
      				 	if (tk.hasMoreTokens()){
      				 		formato = tk.nextToken();
      				 	}
      				 	
      				 	if (formato != null){
      				 		if ("date".equals(formato)){
      				 			formato = "d/m/Y";
      				 		}
      				 		
      				 		valor = valor.concat("?").concat(valor).
                           		 concat(".format('").concat(formato).concat("'):").concat(valor);

      				 	}
      				 %>
      				 
      				 ,<%=clave %> : <%=valor %>
      				 </c:forEach>
      				 <c:if test="${paramId != null}">
      				 ,id:'${paramId}'
      				 </c:if>
      			}
 };
 
 var ${name}_validarForm = function(){
		<c:forEach var="a1" items="${dynattrs}">
		if (${a1.value}.getValue() != ''){
			return true;
		}
		</c:forEach>
		return <c:if test="dynattrs!=null">false</c:if><c:if test="dynattrs==null">true</c:if>;
			
	};
<c:set var="coma" value="false"/>
<c:if test="${dynattrs!=null}">var ${name}_camposFormulario = [
	<c:forEach var="a2" items="${dynattrs}">
		<c:if test="${coma}">,</c:if>${a2.value}
		<c:set var="coma" value="true"/>
	</c:forEach>
];</c:if>