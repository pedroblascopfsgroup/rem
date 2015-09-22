<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
{
    open: function(){
        app.openTab("<s:message code="tareas.pendientes" text="**tareas pendientes"/>",
            "plugin/procuradores/MEJlistadoTareas",
            {codigoTipoTarea:'1',
             alerta:false,
             espera:false,
             titulo:"<s:message code="tareas.pendientes" text="**tareas pendientes"/>",
             icon:'icon_pendientes_tab'
            },
            {id:'tareas_pendientes',iconCls:'icon_pendientes_tab'}
        );
    }
}
