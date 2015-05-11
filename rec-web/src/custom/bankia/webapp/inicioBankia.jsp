<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ page language="java" 
	import="org.springframework.security.ui.AbstractProcessingFilter"%>
<%@ page language="java" 
	import="org.springframework.security.ui.webapp.AuthenticationProcessingFilter"%>
<%@ page language="java" import="org.springframework.security.AuthenticationException"%>

<html>
<head>


<meta http-equiv="Cache-Control" content="no-cache,must-revalidate">
<meta http-equiv="Pragma" content="nocache">

<link rel="shortcut icon" href="img/favicon.ico">
<link rel="stylesheet" type="text/css"
	href="js/fwk/ext3.4/resources/css/ext-all.css?devon_version=1.1.0" />
<link rel="stylesheet" type="text/css"
	href="css/fwk/slateGreen/slateGreen.css?devon_version=1.1.0" />

	<script type="text/javascript"
		src="js/fwk/ext3.4/adapter/ext/ext-base.js?devon_version=1.1.0"></script>
	<script type="text/javascript"
		src="js/fwk/ext3.4/ext-all.js?devon_version=1.1.0"></script>

<script type="text/javascript"
	src="js/fwk/ext.ux/StaticTextField.js?devon_version=1.1.0"></script>
<script type="text/javascript"
	src="js/fwk/ext3.4/locale/ext-lang-es.js?devon_version=1.1.0"></script>


<style>
body {
	background: white url("img/loginBackground.jpg");
	margin: 0px;
	padding: 0px;
	font-family: arial;
}

h1 {
	background: white;
	border-bottom: 1px solid #ccc;
	padding: 5px;
	color: #666;
}
</style>
</head>
<body>
	<h1>
	<img width="100px" src="img/pfs-logo.png" style="margin-right:30px;">
	<img width="280px" src="img/recovery-logo.png">
	<span style="float:right;margin-top:60px;margin-right:2px;">Version 9.0 (${version})</span>
	</h1>
        <script>
        		// ${SPRING_SECURITY_LAST_EXCEPTION.class.name} -->
                <c:if test="${SPRING_SECURITY_LAST_EXCEPTION.class.name == 'org.springframework.security.BadCredentialsException'}">
                mensaje = 'El usuario no esta configurado para acceder a esta aplicacion. Consulte con su administrador.';
                alert(mensaje);
                </c:if>
                <c:if test="${SPRING_SECURITY_LAST_EXCEPTION.class.name == 'org.springframework.security.concurrent.ConcurrentLoginException'}">
                mensaje = 'Este usuario ya ha accedido a la aplicacion desde otro lugar. No es posible acceder a la aplicacion simultaneamente mas de una vez con el mismo usuario';
                alert(mensaje);
                </c:if>
        </script>

	<br/><br/><br/><br/><br/><br/><br/><br/>
	<div align="center">
	<h3>Usuario desconectado de PFS-Recovery.<br/><br/><br/></h3>
	Si no se ha desconectado es posible que el usuario no est&eacute; configurado para acceder a esta aplicaci&oacute;n.<br/><br/>
	<a href='j_spring_security_check'>Acceder de nuevo a Recovery</a>
	</div>

</body>
</html>
