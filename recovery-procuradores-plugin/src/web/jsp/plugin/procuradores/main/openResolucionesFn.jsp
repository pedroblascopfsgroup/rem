<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
{
    open: function(){
            var mascara = new Ext.LoadMask(app.contenido.el.dom, {msg:'Abriendo ventana de Procesado de Resoluciones...'});
            var tabResoluciones = Ext.getCmp("plugin_procuradores_procesado_resoluciones_archivo");
            mascara.show();
            
            app.openTab("<s:message code="plugin.procuradores.procesadoProcuradores.menu.tabName" text="**Procesado de resoluciones"/>", 
                "pcdprocesadoresoluciones/abrirPantalla",
                {},
                {id:'plugin_procuradores_procesado_resoluciones_archivo',
                 iconCls : 'icon_resoluciones'
                 }
            );
            //setTimeout(function(){mascara.hide();}, 10000);
            mascara.hide();
    }
}