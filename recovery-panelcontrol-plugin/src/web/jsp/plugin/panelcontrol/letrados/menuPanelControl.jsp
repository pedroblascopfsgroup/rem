<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

text: 'Panel control letrados' 
		,iconCls : 'icon_busquedas'	
		,handler : function(){
			app.openTab('Panel control letrados', "plugin/panelcontrol/letrados/plugin.panelControl.letrados",{nivel:'0',cod:'0',idNivel:'0'},{});
		}
		
