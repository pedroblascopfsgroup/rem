<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
text : '<s:message code="plugin.procuradores.procesadoProcuradores.menu" text="**Procesado de resoluciones menu" />'
,iconCls : 'icon_resoluciones'
		,handler : function(){
    		var mascara = new Ext.LoadMask(app.contenido.el.dom, {msg:'Abriendo ventana de Procesado de Procuradores...'});
			var tabResoluciones = Ext.getCmp("plugin_procuradores_procesado_resoluciones_archivo");
			if (tabResoluciones == null) {
				mascara.show();
				app.openTab("<s:message code="plugin.procuradores.procesadoProcuradores.menu.tabName" text="**Procesado de procuradores"/>", 
					"pcdprocesadoresoluciones/abrirPantalla",
					{},
					{id:'plugin_procuradores_procesado_resoluciones_archivo',
					 iconCls : 'icon_resoluciones'
					 }
				);
				//setTimeout(function(){mascara.hide();}, 10000);
				mascara.hide();
			} else {
				Ext.getCmp("contenido").setActiveTab(tabResoluciones);
			}
		}
