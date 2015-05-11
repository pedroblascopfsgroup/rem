<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: 'Panel control' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab('<s:message code="plugin.panelControl.titulo" text="**Panel control" />', "plugin/panelcontrol/judicial/plugin.panelControl",{nivel:'0',idNivel:'0',cod:'0'},{});
		}