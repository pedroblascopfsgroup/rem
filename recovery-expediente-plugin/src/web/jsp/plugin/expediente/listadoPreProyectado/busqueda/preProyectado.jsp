<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="main.toolbar.buscar.preproyectado" text="**Proyectado/Preproyectado" />' 
		,iconCls : 'icon_expedientes'
		,handler : function(){
				app.openTab("<s:message code="preProyectados" text="**Proyectado/Preproyectado"/>", "listadopreproyectado/abrirListado",{},{id:'busqueda_preproyectados',iconCls:'icon_busquedas'});
		}