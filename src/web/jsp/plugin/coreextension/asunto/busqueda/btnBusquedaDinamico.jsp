<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: 'Asuntos dinamicos' 
		,iconCls : 'icon_asunto'	
		,handler : function(){
			app.openTab('Asuntos', "plugin/coreextension/asunto/core.listadoBusquedaAsuntosDinamico",{},{});
		}