<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

new Ext.Button({
		text:'<s:message code="app.logout" text="**Desconectar" />'
		,iconCls:'icon_gv_tree'
		,handler:function(){
			Ext.Msg.confirm('<s:message code="app.confirmar" text="**confirmar" />', '<s:message code="main.logout.confirmar" text="**¿Seguro que desea salir de la aplicación?" />', function(boton){
			if (boton=="yes"){
				var conn = new Ext.data.Connection();
                                conn.request({
                                        url : "/${appProperties.appName}/j_spring_security_logout"
                                        ,callback : function(){
                                                top.window.close();
                                                window.location="/${appProperties.appName}/j_spring_security_logout";
                                        }
                                });
			}
		});			
		}
	})