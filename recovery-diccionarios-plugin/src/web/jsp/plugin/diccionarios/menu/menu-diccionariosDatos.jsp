<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.diccionarios.messages.tituloMenu" text="**Diccionarios de datos" />' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab("<s:message code="plugin.diccionarios.messages.tituloMenu" text="**Diccionarios de datos"/>", "plugin/diccionarios/diccionariosDatos/DIClistarDiccionariosDatos",{},{id:'plugin_diccionarios_listadoDisccionarios',iconCls:'icon_busquedas'});
		}