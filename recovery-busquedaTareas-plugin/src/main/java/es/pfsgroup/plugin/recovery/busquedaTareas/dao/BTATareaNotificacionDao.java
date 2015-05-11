package es.pfsgroup.plugin.recovery.busquedaTareas.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.busquedaTareas.dto.BTADtoBusquedaTareas;
import es.pfsgroup.plugin.recovery.busquedaTareas.model.BTATareaEncontrada;

public interface BTATareaNotificacionDao extends AbstractDao<BTATareaEncontrada, Long>{
	
    /**
     * Busca las tareas o notificaciones para un usuario.
     * @param dto dtoparametro
     * @return lista de tareas
     */
    Page buscarTareas(BTADtoBusquedaTareas dto);
    
    Integer buscarTareasCount(BTADtoBusquedaTareas dto);

}
