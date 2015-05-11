package es.capgemini.pfs.core.api.procesosJudiciales;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.procesosJudiciales.dto.EXTDtoCrearTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface TareaExternaApi {
	
	
	public static String BO_CORE_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA = "core.tareaExterna.crearTareaDto";
	public static String BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_USUARIO_POR_PROCEDIMIENTOS = "tareaExternaManager.obtenerTareasDeUsuarioPorProcedimientos";
	public static String BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTOS = "tareaExternaManager.obtenerTareasPorProcedimientos";

	
    /**
     * Get tarea externa.
     * @param id long
     * @return tarea externa
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET)
    public TareaExterna get(Long id);
    
    /**
     * TODO DOCUMENTAR FO.
     * @param idProcedimiento Long
     * @return List TareaExterna
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_USUARIO_POR_PROCEDIMIENTO)
    public List<? extends TareaExterna> obtenerTareasDeUsuarioPorProcedimiento(Long idProcedimiento); 

    /**
     * Recupera tareas para un procedimiento del usuario logado y su grupo
     * @param idProcedimientos
     * @return
     */
    @BusinessOperationDefinition(BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_USUARIO_POR_PROCEDIMIENTOS)
    public List<? extends TareaExterna> obtenerTareasDeUsuarioPorProcedimientos(List<Long> idProcedimientos); 
    
    /**
     * Recupera tareas para un procedimiento
     * @param idProcedimientos
     * @return
     */
    @BusinessOperationDefinition(BO_TAREA_EXTERNA_MGR_OBTENER_TAREAS_POR_PROCEDIMIENTOS)
    public List<? extends TareaExterna> obtenerTareasPorProcedimientos(List<Long> idProcedimientos); 
    
    /**
     * Activa una tarea detenida por una paralizaci�n de BPM. La desmarca de borrada y detenida
     * @param tareaExterna TareaExterna
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_ACTIVAR)
    @Transactional(readOnly = false)
    public void activar(TareaExterna tareaExterna);
    
    /**
     * Borrar tarea externa.
     * @param tareaExterna tareaExterna
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_BORRAR)
    @Transactional(readOnly = false)
    public void borrar(TareaExterna tareaExterna);
    
    
    /**
     * Detiene una tarea por una paralizaci�n de BPM. La marca como borrada y detenida
     * @param tareaExterna TareaExterna
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_DETENER)
    @Transactional(readOnly = false)
    public void detener(TareaExterna tareaExterna);
    
    /**
     * TODO DOCUMENTAR FO.
     * @param tareaExterna tareaExterna
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_ACTIVAR_ALERTA)
    @Transactional(readOnly = false)
    public void activarAlerta(TareaExterna tareaExterna) ;
    
    /**
     * Creaci�n de una tarea externa.
     * @param codigoSubtipoTarea string
     * @param plazo long
     * @param descripcion string
     * @param idProcedimiento long
     * @param idTareaProcedimiento long
     * @param tokenIdBpm long
     * @return Long
     */
    @BusinessOperationDefinition(BO_CORE_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA)
    @Transactional(readOnly = false)
    public Long crearTareaExternaDto(EXTDtoCrearTareaExterna dto);

}
