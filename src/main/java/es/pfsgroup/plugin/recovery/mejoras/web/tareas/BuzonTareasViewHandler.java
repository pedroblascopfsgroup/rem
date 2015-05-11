package es.pfsgroup.plugin.recovery.mejoras.web.tareas;

import es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers.RecoveryViewHandler;

public interface BuzonTareasViewHandler  extends RecoveryViewHandler{

    Object getModel(Long idTarea);

    String getJspName();

}
