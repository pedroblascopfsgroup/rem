<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<html>
<head>
	<title><s:message code="main.title" text="PFS - Plataforma de Gesti&oacute;n de Recuperaciones"/></title>
	<link rel="shortcut icon" href="../img/favicon.ico">
 	<link rel="stylesheet" type="text/css" href="../js/fwk/ext3/resources/css/ext-all.css?devon_version=${appProperties.jsVersion}" />
	<link rel="stylesheet" type="text/css" href="../css/fwk/<c:out value="${theme}" />/<c:out value="${theme}" />.css?devon_version=${appProperties.jsVersion}" />
    <c:if test="${appProperties.jsDebug}">
		<script type="text/javascript" src="../js/fwk/ext3/adapter/ext/ext-base.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="../js/fwk/ext3/ext-all-debug.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="../js/fwk/ext3/debug-min.js?devon_version=${appProperties.jsVersion}"></script>
    </c:if>
	<c:if test="${!appProperties.jsDebug}">
	    <script type="text/javascript" src="../js/fwk/ext3/adapter/ext/ext-base.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="../js/fwk/ext3/ext-all.js?devon_version=${appProperties.jsVersion}"></script>
	</c:if>

	<%-- traducción de ext --%>
    <script type="text/javascript" src="../js/fwk/ext3/locale/ext-lang-es.js?devon_version=${appProperties.jsVersion}"></script>

	<%-- extensiones --%>
    <script type="text/javascript" src="../js/fwk/ext.ux/Toast.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/StaticTextField.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/DDView.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/Multiselect.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/ItemSelector.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/XDateField.js?devon_version=${appProperties.jsVersion}"></script>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/StaticTextField.css?devon_version=${appProperties.jsVersion}"/>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/Multiselect/Multiselect.css?devon_version=${appProperties.jsVersion}"/>
    <script type="text/javascript" src="../js/ux/DynamicGridPanel.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/ux/RowEditor.js?devon_version=${appProperties.jsVersion}"></script>
    
    <%-- framework --%>
    <script type="text/javascript" src="../js/fwk/fwk.js.jsp?devon_version=${appProperties.jsVersion}"></script>
	<c:if test="${appProperties.jsDebug}">
		<link rel="stylesheet" type="text/css" href="../js/fwk/joe.css?devon_version=${appProperties.jsVersion}"/>
	</c:if>
    <script type="text/javascript" src="../js/fwk/joe.js?devon_version=${appProperties.jsVersion}"></script>
	<link rel="stylesheet" type="text/css" href="../css/main/arbol_tareas.css?devon_version=${appProperties.jsVersion}" />
	

    <script type="text/javascript" src="../js/fwk/ext.ux/FileUpload/Ext.ux.form.BrowseButton.js"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/FileUpload/FileUploadField.js"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/FileUpload/Ext.ux.UploadPanel.js"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/FileUpload/locale.js.jsp"></script>
    <link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/FileUpload/css/fileuploadfield.css">


    <%-- 
    <link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/FileUpload/css/icons.css">
  	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/FileUpload/css/filetype.css">
  	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/FileUpload/css/filetree.css">
     --%>
  

	<link rel="stylesheet" type="text/css" href="../css/app.css" />
</head>
	<body>
	<style>
		body {
			font-family : Arial;
			/*font-size : 0.9em;*/
		}
		#userInfo, #fechaCarga{
			font-size : 11px;
			color : #666;
			position : absolute;
			top : 5px;
			right : 5px;
		}
		
		#fechaCarga {
			top : 20px;
		}
		
		#logout, #logoutClose{ 
			color : #66f; 
		}
	</style>
	<div id="header"></div>
	<div id="container"></div>
	<div id="west">
    	<div id="admin_tree"></div>
  	</div>
  	<div id="north" style="background:url('/${appProperties.appName}/img/logo.gif') no-repeat 50% 0">
		<img src="/${appProperties.appName}/img/<c:out value="${logo}"/>" />
		<div id="userInfo"><s:message code="main.userInfo.usuario" text="**Usuario : "/> ${usuario.username} (<a id="logout" href="#"><s:message code="main.logout" text="**desconectar"/></a> / <a id="logoutClose" href="#"><s:message code="main.logout.close" text="**desconectar y cerrar"/></a>)</div>
		<div id="fechaCarga"><s:message code="main.fechaCarga" text="**&Uacute;ltima fecha de carga : "/><fwk:date value="${ultimaFechaCarga}"/></div>
    	<div id="toolbar"></div>
  	</div>
  	<div id="center2"></div>
  	<div id="center1"></div>
	<div id="south">
	</div>
                                    
	</body>
<script>
    <jsp:include page="/WEB-INF/jsp/main/main.js.jsp" flush="true"></jsp:include>
    <jsp:include page="/WEB-INF/jsp/main/validaciones.js.jsp" flush="true"></jsp:include>
    <jsp:include page="/WEB-INF/jsp/main/formateo.js.jsp" flush="true"></jsp:include>
</script>

</html>