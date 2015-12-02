package es.pfsgroup.plugin.recovery.mejoras.procedimiento;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.dto.MEJDtoBloquearProcedimientos;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.dto.MEJDtoInclusionExclusionContratoProcedimiento;

public interface MEJProcedimientoApi {

	public static final String MEJ_MGR_PROCEDIMIENTO_BUTTONS_RIGHT = "plugin.mejoras.web.procedimientos.buttons.right";
	public static final String MEJ_MGR_PROCEDIMIENTO_BUTTONS_LEFT = "plugin.mejoras.web.procedimientos.buttons.left";
	public static final String MEJ_BO_PRC_ES_TRAMITE_SUBASTA_BY_PRC_ID = "es.pfsgroup.recovery.mejoras.procedimiento.api.esTramiteSubastaByPrcId";
	
	/**
	 * 
	 * @param id
	 * @return devuelve true si alguna de las tareas del procimiento est� detenida
	 */
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_PROCEDIMIENTO_PARALIZADO)
	public boolean procedimientoParalizado(Long id);
	
    
    /**
     * Indica si el Usuario Logado tiene que responder alguna comunicaci�n.
     * Se usa para mostrar o no el bot�n responder.
     * @param idProcedimiento el id del procedimiento.
     * @return true o false.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_BUSCAR_TAREA_PENDIENTE)
    public TareaNotificacion buscarTareaPendiente(Long idProcedimiento);
    
    @BusinessOperationDefinition(MEJ_MGR_PROCEDIMIENTO_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsProcedimientoRight();
	
	@BusinessOperationDefinition(MEJ_MGR_PROCEDIMIENTO_BUTTONS_LEFT)
	List<DynamicElement> getButtonsProcedimientoLeft();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_PROCEDIMIENTO_BUTTONS_RIGHT_FAST)
	List<DynamicElement> getButtonsProcedimientoRightFast();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_BO_PROCEDIMIENTO_BUTTONS_LEFT_FAST)
	List<DynamicElement> getButtonsProcedimientoLeftFast();
	
	@BusinessOperationDefinition(PluginMejorasBOConstants.MEJ_MGR_PROCEDIMIENTO_TABS_FAST)
    List<DynamicElement> getTabsProcedimientoFast();
	
    /**
     * PBO: las siguientes constantes y declaraciones de métodos son por la desconexión UNNIM
     */
	public static final String MEJ_BO_PRC_EXCLUIR_CONTRATOS_AL_PROCEDIMIENTO = "es.pfsgroup.recovery.mejoras.procedimiento.api.excluirContratosAlProcedimiento";
    
    /**
     * Excluye los contratos al expediente.
     * @param dto DtoExclusionContratoExpediente
     */
    @BusinessOperationDefinition(MEJ_BO_PRC_EXCLUIR_CONTRATOS_AL_PROCEDIMIENTO)
    @Transactional(readOnly = false)
    public void excluirContratosAlProcedimiento(MEJDtoInclusionExclusionContratoProcedimiento dto);

    
    public static final String MEJ_BO_PRC_ADJUNTAR_CONTRATOS_AL_PROCEDIMIENTO ="es.pfsgroup.recovery.mejoras.procedimiento.api.adjuntarContratosAlProcedimiento";
    /**
     * Crea un nuevo procedimiento de tipo bloqueado.
     * @param dto UNNIMDtoAdjuntarContratoProcedimiento
     */
    @BusinessOperationDefinition(MEJ_BO_PRC_ADJUNTAR_CONTRATOS_AL_PROCEDIMIENTO)
    @Transactional(readOnly = false)
    public void adjuntarContratosAlProcedimiento(MEJDtoBloquearProcedimientos dto);
	
	public static final String MEJ_BO_PRC_INCLUIR_CONTRATOS_AL_PROCEDIMIENTO = "es.pfsgroup.recovery.mejoras.procedimiento.api.incluirContratosAlProcedimiento";
	/**
     * Incluye los contratos al expediente.
     * @param dto DtoExclusionContratoExpediente
     */
    @BusinessOperationDefinition(MEJ_BO_PRC_INCLUIR_CONTRATOS_AL_PROCEDIMIENTO)
    @Transactional(readOnly = false)
    public void incluirContratosAlProcedimiento(MEJDtoInclusionExclusionContratoProcedimiento dto);


	@BusinessOperationDefinition(MEJ_BO_PRC_ES_TRAMITE_SUBASTA_BY_PRC_ID)
    public boolean esTramiteSubastaByPrcId(Long prcId);
    
    
}
