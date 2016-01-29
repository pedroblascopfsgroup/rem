<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
	<title><spring:message code="admin.title" /></title>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext/resources/css/ext-all.css?devon_version=${appProperties.jsVersion}"/>
    <script type="text/javascript" src="../js/fwk/ext/adapter/ext/Ext-debug.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext/adapter/ext/ext-base-debug.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext/ext-all-debug.js?devon_version=${appProperties.jsVersion}"></script>

	<%-- traducción de ext --%>
    <script type="text/javascript" src="../js/fwk/ext/locale/ext-lang-es-min.js?devon_version=${appProperties.jsVersion}"></script>

	<%-- extensiones --%>
    <script type="text/javascript" src="../js/fwk/ext.ux/Toast.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/StaticTextField.js?devon_version=${appProperties.jsVersion}"></script>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/StaticTextField.css?devon_version=${appProperties.jsVersion}"/>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/Multiselect/Multiselect.css?devon_version=${appProperties.jsVersion}"/>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/Multiselect.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/DDView.js?devon_version=${appProperties.jsVersion}"></script>
    
    <%-- framework --%>
    <script type="text/javascript" src="../js/fwk/fwk.js?devon_version=${appProperties.jsVersion}"></script>
	<link rel="stylesheet" type="text/css" href="../js/fwk/joe.css?devon_version=${appProperties.jsVersion}"/>
    <script type="text/javascript" src="../js/fwk/joe.js?devon_version=${appProperties.jsVersion}"></script>

	<link rel="stylesheet" type="text/css" href="../js/admin/admin_tree.css?devon_version=${appProperties.jsVersion}" />
    <script type="text/javascript" src="../js/admin/admin.js.jsp?devon_version=${appProperties.jsVersion}"></script>
    
</head>
	<body>
	<style>
		body {
			font-family : Arial;
		}
	</style>
	<div id="header"></div>
	<div id="container"></div>
	<div id="west">
    	<div id="admin_tree"></div>
  	</div>
  	<div id="north">
  		<img src="img/logo.gif" />
    	<div id="toolbar"></div>
  	</div>
  	<div id="center2"></div>
  	<div id="center1"></div>
	<div id="south">
	${appProperties.jsVersion}
		<a href="/pfs/logout.jsp">logout</a>
	</div>
                                    
	</body>
</html>