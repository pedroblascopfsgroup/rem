<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%@ page import="org.springframework.security.ui.AbstractProcessingFilter"%>
<%@ page import="org.springframework.security.ui.webapp.AuthenticationProcessingFilter"%>
<%@ page import="org.springframework.security.AuthenticationException"%>

<html>
<head>

	<meta http-equiv="Cache-Control" content="no-cache,must-revalidate"><meta http-equiv="Pragma" content="nocache">
	
	<link rel="shortcut icon" href="img/favicon.ico">
 	<link rel="stylesheet" type="text/css" href="js/fwk/ext3.4/resources/css/ext-all.css?devon_version=${appProperties.jsVersion}" />
	<link rel="stylesheet" type="text/css" href="css/fwk/<c:out value="${theme}" />/<c:out value="${theme}" />.css?devon_version=${appProperties.jsVersion}" />
    <c:if test="${appProperties.jsDebug}">
		<script type="text/javascript" src="js/fwk/ext3.4/adapter/ext/ext-base.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="js/fwk/ext3.4/ext-all-debug.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="js/fwk/ext3.4/debug-min.js?devon_version=${appProperties.jsVersion}"></script>
    </c:if>
	<c:if test="${!appProperties.jsDebug}">
	    <script type="text/javascript" src="js/fwk/ext3.4/adapter/ext/ext-base.js?devon_version=${appProperties.jsVersion}"></script>
	    <script type="text/javascript" src="js/fwk/ext3.4/ext-all.js?devon_version=${appProperties.jsVersion}"></script>
	</c:if>
	
	<script type="text/javascript" src="js/fwk/ext.ux/StaticTextField.js?devon_version=${appProperties.jsVersion}"></script>
    <script type="text/javascript" src="js/fwk/ext3.4/locale/ext-lang-es.js?devon_version=${appProperties.jsVersion}"></script>

<style>
	body {
		background: white url("img/loginBackground.jpg");
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
</head>
<body>
<h1><img src="img/loginTitle.jpg" />Version 4.0</h1>   

<script>

var cambiarDatosWindow;
var loginWindow;
var usuario;

var olvidoPass = function(){
   	webflow({
           flow:'public/recuperarPassword.htm'
   	    ,params: {username:usuario.getValue()} 
           ,success: function(data, config) {
               Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />',data.respuesta.respuesta);
       }});
}



var crearWindow = function(usuario) {
    var datosUsuarioPanel = createDatosUsuarioPanel(usuario);

    var w = new Ext.Window({
        title: 'Cambiar Datos Usuario'
        ,width : 645
        ,autoHeight : true
        ,closable:false
        ,y: 50 
        ,items : [
            datosUsuarioPanel
        ]
    });    
    return w;
}

var webflow = function(config){
    var p = {
        url : config.flow
        ,method : config.method || 'POST'
        ,params : config.params || {}
        ,userConfig : config
        ,options : config.options || {}
        ,scope : config.scope 
    };

    p.success = function(response, config){
        var data = Ext.decode(response.responseText);

        if (config && config.userConfig){
            var f = data.success? config.userConfig.success : config.userConfig.error;
            if (f && typeof(f)=="function"){
                f.call(config.scope || this,data,config.userConfig);
            }
        }

    };

    p.failure = function(response, config){
    	var data = Ext.decode(response.responseText);
        if (config.userConfig && config.userConfig.failure ){
            f = config.userConfig.failure;
            f.call(config.scope || this,data,config.userConfig);            
        }
    };

    Ext.Ajax.request( p );
};

if (top['app']){
	top.app.loginRedirect();
}
else{
	Ext.onReady(function(){

		var error = new Ext.form.Label({
			text : 'error'
		});


		var loginField = Ext.extend(Ext.form.TextField, {
			initComponent : function(){
				Ext.apply(this,{
					allowBlank : true
					,enableKeyEvents : true
					,listeners : {keypress : this.onEnter}
				});
			}
			,onKeyPress : function(e){
				if(e.getKey() == e.ENTER 
						&& validateLogin()
						) this.ownerCt.ownerCt.getForm().submit();
			}
		});
		
		


		function validateLogin(){
			var mensaje = null;
			
			if (usuario.getValue() == '')
			{
				 mensaje = '<s:message code="login.error.login" text="**Falta introducir un nombre para el usuario" />';
			}
			else if (password.getRawValue() == '')
			{
				 mensaje = '<s:message code="login.error.password" text="**Falta introducir una contraseña para el usuario" />';
			}


			if (mensaje == null) {
				return true;
			}
			else {
				Ext.Msg.alert('Error',mensaje);
				return false;
			}
		};
		
		
		usuario = new loginField({			
				fieldLabel : 'Nombre'
				,name : 'j_username'
				,value : ''
				,width:175
		});

		var password = new loginField({
			fieldLabel : 'Contrase&ntilde;a'
			,name : 'j_password'
			,inputType: 'password'
			,value : ''
			,width:175
			,style:'padding-bottom:0px;margin-bottom:0px'         				
		});

		
		var validar = new Ext.Button({
			text : 'Validar'
			,style:'margin-left:0px;padding:0px;margin-top:0px;margin-bottom:0px'         				
			,handler : function(target, e){
				if (validateLogin())
					this.ownerCt.ownerCt.getForm().submit();
			}
		});

        var recuperar = new Ext.Button({
            text : '¿Olvid&oacute; su password?'
            ,handler : function(target, e){
            	webflow({
                    flow:'public/recuperarPassword.htm'
            	    ,params: {username:usuario.getValue()} 
                    ,success: function(data, config) {
                        Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />',data.respuesta.respuesta);
                }});
            }
        });        

        var cambiar = new Ext.Button({
            text : 'Cambiar datos'
            ,handler : function(target, e){
        	    webflow({flow:'public/cambiarDatosUsuario.htm'
        	        ,params: {username:usuario.getValue()} 
        	        ,success: function(data, config) {
                        loginWindow.hide();
                        if(cambiarDatosWindow) {
                        	cambiarDatosWindow.close();
                        }
        	        	cambiarDatosWindow = crearWindow(data.usuario);
                        cambiarDatosWindow.show();
        	    }});
            }
        });       

        var loginForm = new Ext.form.FormPanel({
			url : '<c:url value='j_spring_security_check' />'
			,bodyStyle:'padding:5px;cellspacing:5px'   
            ,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form',bodyStyle:'padding:5px;cellspacing:5px'}
            ,items:[
                {items:[<c:if test="${not empty param.login_error}">error,</c:if>
                        usuario,password]}
                ,{items:[validar]}         
            ]
			,standardSubmit : true
		}); 
 
		loginWindow = new Ext.Window({
			title : 'Control de acceso a la aplicaci&oacute;n'
			,width : 345
			,autoHeight : true
			,closable:false
			,items : [
				loginForm
			]
		});

		loginWindow.on("show", function(){
			<c:if test="${SPRING_SECURITY_LAST_EXCEPTION.class.name == 'org.springframework.security.BadCredentialsException'}">
			mensaje = '<s:message code="login.error.user_password" text="**Usuario o contraseña incorrecta" />';
 	 		Ext.Msg.alert('Error',mensaje);
			</c:if>
			
            usuario.focus(true, 500);
		});

		loginWindow.show();

		loginForm.getForm().getEl().dom.action=loginForm.getForm().url;

		<c:if test="${SPRING_SECURITY_LAST_EXCEPTION.class.name == 'es.capgemini.pfs.security.CredentialsExpiredAuthenticationException'}">
		    webflow({flow:'public/cambiarDatosUsuario.htm'
		        ,params: {username:'<c:out value='${SPRING_SECURITY_LAST_USERNAME}' />'} 
		        ,success: function(data, config) {
	                loginWindow.hide();
	                if(cambiarDatosWindow) {
	                	cambiarDatosWindow.close();
	                }
	                cambiarDatosWindow = crearWindow(data.usuario);
	                cambiarDatosWindow.show();
		    }});
		</c:if>	});

	
		 
			
}
</script>


</body>
</html>
