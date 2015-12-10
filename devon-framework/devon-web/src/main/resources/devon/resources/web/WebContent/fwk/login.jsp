<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ page import="org.springframework.security.ui.AbstractProcessingFilter"%>
<%@ page import="org.springframework.security.ui.webapp.AuthenticationProcessingFilter"%>
<%@ page import="org.springframework.security.AuthenticationException"%>

<html>
<head>

    <link rel="shortcut icon" href="../img/favicon.ico">
    <link rel="stylesheet" type="text/css" href="../js/fwk/ext3/resources/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="../js/fwk/ext3/resources/css/xtheme-gray.css" />
    <c:if test="${appProperties.jsDebug}">
    	<script type="text/javascript" src="../js/fwk/ext3/adapter/ext/ext-base-debug.js"></script>
    	<script type="text/javascript" src="../js/fwk/ext3/ext-all-debug.js"></script>
    </c:if>
    <c:if test="${!appProperties.jsDebug}">
    	<script type="text/javascript" src="../js/fwk/ext3/adapter/ext/ext-base.js"></script>
    	<script type="text/javascript" src="../js/fwk/ext3/ext-all.js"></script>
    </c:if>

</head>
<style>
	body {
		background: white url("../img/loginBackground.jpg");
        margin : 0px;
        padding : 0px;
        font-family : arial;
	}
    h1 {
        background : white;
        border-bottom : 1px solid #ccc;
        padding : 5px;
        color : #666;
    }
</style>
<body>
<h1><img src="../img/loginTitle.jpg" />Version 1.0</h1>

<script>

//fwk_login_page_token

//si detectamos el framework, es que esta página está siendo cargada donde no debe.
if (top['app']){
	top.app.loginRedirect();
}
else{
	Ext.onReady(function(){

		var error = new Ext.form.Label({
			text : 'error'
		});

        var loginField = function(config){
            config.allowBlank = true;
            config.enableKeyEvents = true;
            config.onKeyPress = function(e){
                if(e.getKey() == e.ENTER) this.ownerCt.getForm().submit();
            };
            var text = new Ext.form.TextField(config);
            return text;
        };

        usuario =   loginField({
            fieldLabel : '<s:message code="login.field.name.label"/>'
            ,name : 'j_username'
            ,value : ''
        });
    
        var password =  loginField({
            fieldLabel : '<s:message code="login.field.password.label"/>'
            ,name : 'j_password'
            ,inputType: 'password'
            ,value : ''
        });

		var validar = new Ext.Button({
			text : '<s:message code="login.button.submit.label"/>'
			,handler : function(target, e){
				this.ownerCt.getForm().submit();
			}
		});

		var loginForm = new Ext.form.FormPanel({
			url : '<c:url value='/j_spring_security_check' />'
			,defaults : { }
			,items : [
				<c:if test="${not empty param.login_error}">
				error,
				</c:if>
				usuario
				,password
				,validar
			]
			,bodyStyle : "padding:10px"
			,standardSubmit : true
		});

		var loginWindow = new Ext.Window({
			title : 'Control de acceso a la aplicaci&oacute;n'
			,width : 350
			,autoHeight : true
            ,closable: false
			,items : [
				loginForm
			]
			//,modal : true
		});

		loginWindow.on('show', function(){
            usuario.focus(true, 500);
        });

		loginWindow.show();

		//corrige el error de ext-js que al usar standardSubmit
		loginForm.getForm().getEl().dom.action=loginForm.getForm().url;

	});
}
</script>

</body>
</html>
