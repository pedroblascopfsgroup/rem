package es.pfsgroup.recovery.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
public interface TareaExternaApi {

	
	 /**
     * Get tarea externa.
     * @param id long
     * @return tarea externa
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET)
    public TareaExterna get(Long id);
    
    /**
     * Borrar tarea externa.
     * @param tareaExterna tareaExterna
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_BORRAR)
    @Transactional(readOnly = false)
    public void borrar(TareaExterna tareaExterna);
    
    
    /**
     * Detiene una tarea por una paralización de BPM. La marca como borrada y detenida
     * @param tareaExterna TareaExterna
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_DETENER)
    @Transactional(readOnly = false)
    public void detener(TareaExterna tareaExterna);
    
    /**
     * Lista de tareas externas activas del procedimiento.
     * @param idProcedimiento long
     * @return Lista de tareas externas
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET_ACTIVAS_BY_PROC)
    public List<TareaExterna> getActivasByIdProcedimiento(Long idProcedimiento);
    
    /**
     * metodo save or update de tarea externa.
     *
     * @param tarea
     *            tarea a grabar
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_SAVE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void saveOrUpdate(TareaExterna tarea);
}
