<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ page session="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title><s:message code="editorPaquetes.titulo" text="**Editor de paquetes" /></title>

 	<link rel="stylesheet" type="text/css" href="../js/fwk/ext3.4/resources/css/ext-all.css?devon_version=${appProperties.jsVersion}" />
	<link rel="stylesheet" type="text/css" href="../css/fwk/<c:out value="${theme}" />/<c:out value="${theme}" />.css?devon_version=${appProperties.jsVersion}" />
	    <script type="text/javascript" src="../js/fwk/ext3.4/adapter/ext/ext-base.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="../js/fwk/ext3.4/ext-all.js?devon_version=${appProperties.jsVersion}"></script>

    <script type="text/javascript" src="../js/fwk/ext3.4/locale/ext-lang-es.js?devon_version=${appProperties.jsVersion}"></script>

	<%-- extensiones --%>
    <script type="text/javascript" src="../js/fwk/ext.ux/Toast.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/StaticTextField.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/DDView.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/Multiselect.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/Multiselect/ItemSelector.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="../js/fwk/ext.ux/XDateField.js?devon_version=${appProperties.jsVersion}"></script>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/StaticTextField.css?devon_version=${appProperties.jsVersion}"/>
	<link rel="stylesheet" type="text/css" href="../js/fwk/ext.ux/Multiselect/Multiselect.css?devon_version=${appProperties.jsVersion}"/>
 
 
	<link rel="stylesheet" type="text/css" href="../css/fwk/<c:out value="${theme}" />/<c:out value="${theme}" />.css?devon_version=${appProperties.jsVersion}" />
 	<%-- editor --%>
 	
 	<script>
 	<%@ include file="ux/CheckColumn.js" %>
 	<%@ include file="json.js.jsp" %>
 	
 	<%@ include file="editorDefinitions.js.jsp" %>
 	<%@ include file="utils.js.jsp" %>
 	<%@ include file="debug.js.jsp" %>
 	<%@ include file="editorPanel.js.jsp" %>
 	<%@ include file="editor.js.jsp" %>
 	<%@ include file="canvas.js.jsp" %>

 	<%@ include file="../../../../js/fwk/fwk.js.jsp"%>
 	<%--@ include file="../main/main.js.jsp"%>
 	<%@ include file="../main/shared.js.jsp"--%>


 	/**
 	 * Abre una ventana con el título y contenido que se le pasa
 	 */
 	openWindow=function(config){
 		config = config || {};

 		var closable=config.closable;

 		if(closable==null)
 			closable=false;


 		var cfg = {
 				title: config.title || ''
 				,layout:'fit'
 				,modal:true
 				,x: config.x || 50
 				,y: config.y || 50
 				,autoShow : true
 				,autoHeight : true
 				,closable:closable
 				,width : config.width || 600
 				,bodyBorder : false
 		};

 		fwk.js.copyProperties(cfg,config,['items']);
 		if (config.flow){
 			cfg.autoLoad = {
 					url : app.resolveFlow(config.flow)
 					,scripts : true
 					,params : config.params || {}
 			};
 		}

 		var win = new Ext.Window(cfg);
 		win.show();
 		return win;
 	};
 	
 	</script>
    <script language="javascript" type="text/javascript" src="../js/plugin/editor/editarea/edit_area_full.js"></script>


</head>
	<style>    
 		<%@ include file="canvas.css.jsp" %>
 	</style>
<body>
<style>
    
</style>
<div id="header"><div style="float:right;margin:5px;" class="x-small-editor"></div></div>

<%-- Template used for Feed Items --%>
<div id="preview-tpl" style="display:none;">
    <div class="post-data">
        <span class="post-date">{pubDate:date("M j, Y, g:i a")}</span>
        <h3 class="post-title">{title}</h3>
        <h4 class="post-author">by {author:defaultValue("Unknown")}</h4>
    </div>
    <div class="post-body">{content:this.getBody}</div>
</div>

</body>
</html>
