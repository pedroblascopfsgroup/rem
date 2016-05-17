package es.capgemini.pfs.core.api.procedimiento;

import java.util.List;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procedimiento.ActualizarProcedimientoDtoInfo;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ProcedimientoApi {
	
	
	public static final String BO_CORE_PROCEDIMIENTO_PRC_SAVE = "core.procedimiento.save";
	public static final String BO_CORE_PROCEDIMIENTO_GET_CONTRATO_PRINCIPAL = "core.procedimiento.getContratoPrincipal";
	public static final String BO_CORE_PROCEDIMIENTO_ADJUNTOSMAPEADOS = "core.procedimiento.adjuntosMapeados";
	
	/**
     * Devuelve un procedimiento a partir de su id.
     * @param idProcedimiento el id del proceimiento
     * @return el procedimiento
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO)
    public Procedimiento getProcedimiento(Long idProcedimiento);
    
    /**
     * Devuelve los tipos de reclamaci�n.
     * @return la lista de Tipos de reclamaci�n
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_GET_TIPOS_RECLAMACION)
    public List<DDTipoReclamacion> getTiposReclamacion() ;
    
    /**
	 * Guarda las modificaciones realizadas en un procedimiento
	 * @param dto
	 */
	@BusinessOperationDefinition(BO_CORE_PROCEDIMIENTO_PRC_SAVE)
	Procedimiento actualizaProcedimiento(ActualizarProcedimientoDtoInfo dto);
	
	/**
	 * Busca el contrato principal del procedimiento
	 * @param id del procedimiento
	 */
	@BusinessOperationDefinition(BO_CORE_PROCEDIMIENTO_GET_CONTRATO_PRINCIPAL)
	Contrato buscaContratoPrincipalProcedimiento(Long idProcedimiento);
	
	
	
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
     * Indica si el Usuario Logado es el supervisor del asunto.
     *
     * @param idProcedimiento
     *            el id del asunto
     * @return true si es el Supervisor.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_ES_SUPERVISOR)
    public Boolean esSupervisor(Long idProcedimiento);
	
    /**
     * Método que devuelve los adjuntos de un procedimiento
     * @param prcId
     * @return
     */
    @BusinessOperationDefinition(BO_CORE_PROCEDIMIENTO_ADJUNTOSMAPEADOS)
    public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId);
    
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_ES_TR_NOTIFICACION_PERSONAL)
	public Boolean compruebaTrNotificacionPersonal(Long idProcedimiento);	
    

}
