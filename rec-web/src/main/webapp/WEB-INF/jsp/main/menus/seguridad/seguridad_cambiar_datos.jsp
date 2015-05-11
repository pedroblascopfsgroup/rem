<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text:'<s:message code="main.toolbar.seguridad.cambiarDatos" text="**Cambiar mis datos" />'
,iconCls:'icon_cambiar_datos'
,handler: function(){ 
	
     var w = app.openWindow({
	            flow : 'public/cambiarDatosUsuarioInterno'
	            ,params:{username:'${usuario.username}', passExpired:false}
	            ,title : '<s:message code="usuario.cambiarDatos.titulo" text="*Cambio de datos de usuario" />'
     });
     w.on(app.event.DONE, function(){
         w.close();
     });
     w.on(app.event.CANCEL, function(){ w.close(); });
   }

