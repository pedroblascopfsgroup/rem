package es.pfsgroup.recovery.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ProcedimientoApi {
	
	@BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_GET_TIPOS_RECLAMACION)
	List<DDTipoReclamacion> getTiposReclamacion();
	
	/**
	 * Devuelve un procedimiento a partir de su id.
	 * 
	 * @param idProcedimiento
	 *            el id del proceimiento
	 * @return el procedimiento
	 */
	@BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO)
	public Procedimiento getProcedimiento(Long idProcedimiento);
	
	 /**
     * Salva un procedimiento, si ya existia lo modifica, si no lo crea y lo
     * guarda.
     *
     * @param dto
     *            los datos del procedimiento.
     * @return el id del procedimiento.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_GUARDAR_PROCEDIMIMENTO)
    @Transactional
    public Long guardarProcedimiento(ProcedimientoDto dto);
    
    /**
     * Salva un procedimiento, si ya existía lo modifica, si no lo crea y lo guarda.
     * @param dto los datos del procedimiento.
     * @return el id del procedimiento.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_SALVAR_PROCEDIMIMENTO)
    @Transactional(readOnly = false)
    public Long salvarProcedimiento(ProcedimientoDto dto);
    
    /**
     * save procedimiento.
     *
     * @param p
     *            procedimiento
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_SAVE_OR_UPDATE_PROCEDIMIMENTO)
    @Transactional
    public void saveOrUpdateProcedimiento(Procedimiento p) ;
    
    /**
     * save procedimiento.
     * @param p procedimiento
     * @return id
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_SAVE_PROCEDIMIENTO)
    @Transactional
    public Long saveProcedimiento(Procedimiento p);
    
    /**
     * Indica si el Usuario Logado es el gestor del asunto.
     *
     * @param idProcedimiento
     *            el id del asunto
     * @return true si es el gestor.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_ES_GESTOR)
    public Boolean esGestor(Long idProcedimiento);
    
    /**
     * Indica si el Usuario Logado tiene que responder alguna comunicación.
     * Se usa para mostrar o no el botón responder.
     * @param idProcedimiento el id del procedimiento.
     * @return true o false.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_BUSCAR_TAREA_PENDIENTE)
    public TareaNotificacion buscarTareaPendiente(Long idProcedimiento); 

}
