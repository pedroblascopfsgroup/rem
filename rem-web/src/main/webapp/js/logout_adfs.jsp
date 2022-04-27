<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
 
<!DOCTYPE html>
<html>

<head>
<title>Logout de REM</title>
</head>

<body>
<h1>Logout de REM</h1>

<%@page import="java.io.InputStream" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="java.util.Properties" %>
<%@page import="java.net.URL" %>

<%
  String ruta="/"+System.getenv("DEVON_HOME")+"/devon.properties";
  InputStream inputStream = new FileInputStream(ruta);
  Properties properties = new Properties();
  properties.load(inputStream);
  String url = "";
  String baseUrl = request.getRequestURL().toString();
  if (baseUrl == null || "".equals(baseUrl)) {
 		url=url.concat(properties.getProperty("haya.auth2.server.param.redirect_uri"));
  } else {
	  URL netUrl = new URL(baseUrl);
	  String host  = netUrl.getAuthority();
	  String protocol = "https";
	  url=url.concat(protocol).concat("://").concat(host).concat("/pfs/js/acceso_adfs.jsp");
  }
  
%>

	<p>
	Se ha desconectado de REM.
	</p>
	<p>
	Pulse aquí para volver a acceder a <a href="<%=url%>">REM</a>.
	</p>
 
</body>
</html>