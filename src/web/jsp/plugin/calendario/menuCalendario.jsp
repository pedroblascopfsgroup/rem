<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


text: '<s:message code="plugin.calendario.menu" text="Calendario" />'
		,iconCls : 'icon_calendario_azul'
		,handler : function(){
			app.contenido.add(calendario()).show();		
		}
