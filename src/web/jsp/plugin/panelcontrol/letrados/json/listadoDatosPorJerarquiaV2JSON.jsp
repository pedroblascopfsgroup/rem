<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" import="java.util.*" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	int c1 = 0;
	int c2 = 0;
	int c3 = 0;
%>
<%!
	String getType(Object obj){
		if (obj instanceof String) {
			return "string";
		}else if (obj instanceof Long){
			return "int";
		}else if (obj instanceof Float){
			return "float";
		}
		else return "auto";
	
	}

%>

{   "total":"${listado.totalCount}",
	"metaData":{
		"root" : "panelControl" ,
		"totalProperty" :"total" ,
		"fields" :[
			<c:forEach var="entry" items="${listado.results[0]}">
				<c:set var="obj" value="${entry.value}" />
					<%Object o = pageContext.getAttribute("obj");%>
	        		<% if (c1 != 0){%>,<%}; c1++; %>{name: '${entry.key}',type: '<%=getType(o)%>'}
	        </c:forEach>
		]	
		
	},
	"panelControl":[
		 <c:forEach var="panel" items="${listado.results}">
	        <% if (c2 != 0){%>,<%}; c2++; %>{
	        	<% c3 = 0; %>
	        	<c:forEach var="entry" items="${panel}">
	        		<% if (c3 != 0){%>,<%}; c3++; %>"${entry.key}":"${entry.value}"
	        	</c:forEach>
	        }
	      </c:forEach>
      ]
}
