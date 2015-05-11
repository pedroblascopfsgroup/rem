<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.masivo.procesadoTareas.menu" text="**Procesado de tareas desde archivo" />'
,iconCls : 'icon_comite_actas'
		,handler : function(){
			app.openTab("<s:message code="plugin.masivo.procesadoTareas.menu.tabName" text="**Procesado tareas desde archivo"/>", "msvprocesadotareasarchivo/abrirPantalla",{},{id:'plugin_masivo_procesado_tareas_archivo',iconCls : 'icon_comite_actas'});
		}

