<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
 
<!DOCTYPE html>
<html>

<head>
<title>Acceso ADFS</title>
</head>

<body>
<h1>Acceso ADFS a REM</h1>

<%@page import="java.io.InputStream" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="java.util.Properties" %>
<%@page import="java.net.URL" %>


<%
  String ruta="/"+System.getenv("DEVON_HOME")+"/devon.properties";
  InputStream inputStream = new FileInputStream(ruta);
  Properties properties = new Properties();
  properties.load(inputStream);
  String url=properties.getProperty("haya.auth2.server.url");
  url = url.replaceAll("token","authorize");
  url=url.concat("?client_id=".
		  concat(properties.getProperty("haya.auth2.server.param.client_id")));
  url=url.concat("&response_type=code&redirect_uri=");
  String baseUrl = request.getRequestURL().toString();
  if (baseUrl == null || "".equals(baseUrl)) {
 		url=url.concat(properties.getProperty("haya.auth2.server.param.redirect_uri"));
  } else {
	  URL netUrl = new URL(baseUrl);
	  String host  = netUrl.getAuthority();
	  String protocol = "https";
	  url=url.concat(protocol).concat("://").concat(host).concat("/pfs/j_spring_security_check");
  }
  url=url.concat("&response_mode=form_post&resource=".
		  concat(properties.getProperty("haya.auth2.server.param.resource")));
  
%>

      <script>
         setTimeout(function(){
            window.location.href = '<%=url%>';
         }, 2000);
      </script>
      <p>Accediendo a la aplicaci&oacute;n REM.</p>
 
</body>
</html>