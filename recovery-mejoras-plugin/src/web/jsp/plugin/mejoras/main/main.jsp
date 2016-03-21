<%
Object view = request.getSession().getAttribute("view");
Object id = request.getSession().getAttribute("id");
if ((view != null) && (id != null)){
        response.sendRedirect(view.toString() + ".htm?id="+ id.toString());
}
%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
	<title><s:message code="main.title" text="PFS - Plataforma de Gesti&oacute;n de Recuperaciones"/></title>

	<meta http-equiv="Cache-Control" content="no-cache,must-revalidate"><meta http-equiv="Pragma" content="nocache">
	
	<link rel="shortcut icon" href="../img/favicon.ico">
 	<link rel="stylesheet" type="text/css" href="../js/fwk/ext3.4/resources/css/ext-all.css?devon_version=${appProperties.jsVersion}" />
	<link rel="stylesheet" type="text/css" href="../css/fwk/<c:out value="${theme}" />/<c:out value="${theme}" />.css?devon_version=${appProperties.jsVersion}" />
    <c:if test="${appProperties.jsDebug}">
		<script type="text/javascript" src="../js/fwk/ext3.4/adapter/ext/ext-base.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="../js/fwk/ext3.4.pfs.1/ext-all-debug.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="../js/fwk/ext3.4/debug-min.js?devon_version=${appProperties.jsVersion}"></script>
    </c:if>
	<c:if test="${!appProperties.jsDebug}">
	    <script type="text/javascript" src="../js/fwk/ext3.4/adapter/ext/ext-base.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="../js/fwk/ext3.4.pfs.1/ext-all.js?devon_version=${appProperties.jsVersion}"></script>
	</c:if>

	<%-- traducción de ext --%>
    <script type="text/javascript" src="../js/fwk/ext3.4/locale/ext-lang-es.js?devon_version=${appProperties.jsVersion}"></script>

	<%-- extensiones --%>
    <script type="text/javascript" src="../js/fwk/ext.ux/Toast.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/StaticTextField.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/DDView.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/Multiselect.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/ItemSelector.js?devon_version=${appProperties.jsVersion}"></script>
    <%--  <script type="text/javascript" src="../js/fwk/ext.ux/XDateField.js?devon_version=${appProperties.jsVersion}"></script>  --%>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/XDateFieldJuniper.js?devon_version=${appProperties.jsVersion}"></script>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/StaticTextField.css?devon_version=${appProperties.jsVersion}"/>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/Multiselect/Multiselect.css?devon_version=${appProperties.jsVersion}"/>
    <script type="text/javascript" src="../js/ux/DynamicGridPanel.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/ux/RowEditor.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/RangeMenu.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/ListMenu.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/GridFilters.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/Filter.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/StringFilter.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/DateFilter.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/ListFilter.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/NumericFilter.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/plugin/mejoras/ux/gridfilters/BooleanFilter.js?devon_version=${appProperties.jsVersion}"></script>
    
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

	<%--  previsiones  --%>

	<script type="text/javascript" src="../js/plugin/mejoras/ux/ColumnHeaderGroup.js?devon_version=${appProperties.jsVersion}"></script>
    <link rel="stylesheet" type="text/css" href="../js/plugin/mejoras/ux/ColumnHeaderGroup.css">

	<%--  libreria de control de navegador  --%>
  	<script type="text/javascript" src="../js/plugin/mejoras/ux/browser.js?devon_version=${appProperties.jsVersion}"></script>
  	
  	<c:forEach var="lib" items="${jsLibraries}">
        <script type="text/javascript" src="<c:out value='${lib.fileName}' />"></script>
	</c:forEach>
    
    <%-- 
    <link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/FileUpload/css/icons.css">
  	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/FileUpload/css/filetype.css">
  	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/FileUpload/css/filetree.css">
     --%>
  

	<link rel="stylesheet" type="text/css" href="../css/app.css" />
	<c:forEach var="css" items="${cssStyles}">
        <link rel="stylesheet" type="text/css" href="<c:out value='${css.fileName}' />">
    </c:forEach>
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
			top : 26px;
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
  	
  	<div id="north" style="background:url('/${appProperties.appName}/img/logo.png') no-repeat 50% 0">
		<img src="/${appProperties.appName}/img/<c:out value="${logo}"/>" />
		<div id="userInfo"><s:message code="main.userInfo.usuario" text="**Usuario : "/> ${usuario.username} 
		<c:if test="${usuario.usuEntidad != null}">
			<c:if test="${fn:length(usuario.usuEntidad)>0}">
				<select id="comboEntidad" >
					<option value='${usuario.entidad.descripcion}'selected>${usuario.entidad.descripcion}</option>
						<c:forEach items='${usuario.usuEntidad}' var='item'>
							<c:if test="${usuario.entidad.descripcion != item.entidad.descripcion}">
		  						<option> <c:out value='${item.entidad.descripcion}'/></option>
		  					</c:if>
						</c:forEach>
				</select> 
			</c:if>
		</c:if>
		</div>
		<div id="fechaCarga"><s:message code="main.fechaCarga" text="**&Uacute;ltima fecha de carga : "/><fwk:date value="${ultimaFechaCarga}"/></div>
    	<div id="toolbar"></div>
  	</div>
  	<div id="center2"></div>
  	<div id="center1"></div>
	<div id="south">
	</div>
                                    
	</body>
	<script>
	    <jsp:include page="/WEB-INF/jsp/plugin/mejoras/main/main.js.jsp" flush="true"></jsp:include>
	    <jsp:include page="/WEB-INF/jsp/main/validaciones.js.jsp" flush="true"></jsp:include>
	    <jsp:include page="/WEB-INF/jsp/main/formateo.js.jsp" flush="true"></jsp:include>
	</script>

	<script src="/pfs/entidad/getEntidad.htm?jsp=entidad/entidad"></script>
	<script src="/pfs/entidad/getEntidad.htm?jsp=entidad/cliente/cliente&br=entidad.cliente.buttons.right.fast&bf=entidad.cliente.buttons.left.fast&tb=tabs.cliente.fast"></script>
	<script src="/pfs/entidad/getEntidad.htm?jsp=entidad/asunto/asunto&br=entidad.asunto.buttons.right.fast&bf=entidad.asunto.buttons.left.fast&tb=tabs.asunto.fast"></script>
	<script src="/pfs/entidad/getEntidad.htm?jsp=entidad/contrato/contrato&br=entidad.contrato.buttons.right.fast&bf=entidad.contrato.buttons.left.fast&tb=tabs.contrato.fast"></script>
	<script src="/pfs/entidad/getEntidad.htm?jsp=entidad/expediente/expediente&br=entidad.expediente.buttons.right.fast&bf=entidad.expediente.buttons.left.fast&tb=tabs.expediente.fast"></script>
	<script src="/pfs/entidad/getEntidad.htm?jsp=entidad/procedimiento/procedimiento&br=entidad.procedimiento.buttons.right.fast&bf=entidad.procedimiento.buttons.left.fast&tb=tabs.procedimiento.fast"></script>
	
	
</html>