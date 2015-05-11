package es.pfsgroup.procedimientos.recoveryapi;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface TareaExternaOverridedApi {
	
	public String PRO_BO_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA_OVERRIDED = "plugin.procedimientos.bpm.bo.tareaExternaManager.crearTareaExterna";


	/**
     * Creación de una tarea externa.
     * @param codigoSubtipoTarea string
     * @param plazo long
     * @param descripcion string
     * @param idProcedimiento long
     * @param idTareaProcedimiento long
     * @param tokenIdBpm long
     * @return Long
     */
    @BusinessOperationDefinition(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA)
    @Transactional(readOnly = false)
    public Long crearTareaExterna(String codigoSubtipoTarea, Long plazo, String descripcion, Long idProcedimiento, Long idTareaProcedimiento,
            Long tokenIdBpm);
    
    
	/**
     * Creación de una tarea externa.
     * @param codigoSubtipoTarea string
     * @param plazo long
     * @param descripcion string
     * @param idProcedimiento long
     * @param idTareaProcedimiento long
     * @param tokenIdBpm long
     * @return Long
     */
    @BusinessOperationDefinition(PRO_BO_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA_OVERRIDED)
    @Transactional(readOnly = false)
    public Long crearTareaExterna(PRODtoCrearTareaExterna dto);

}
