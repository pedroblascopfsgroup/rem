package es.pfsgroup.recovery.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.exclusionexpedientecliente.model.ExclusionExpedienteCliente;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ExpedienteApi {
	
	//public static final String SAN_BO_EXP_GETCLIENTESNOEXCLUIDOS="plugin.santander.expediente.getClientesNoExcluidos";

	 /**
     * Incluye los contratos al expediente.
     * @param dto DtoExclusionContratoExpediente
     */
    @SuppressWarnings("unchecked")
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void incluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto);
    
    /**
     * Excluye el contrato del expediente.
     * @param dto DtoExclusionContratoExpediente
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void excluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto);
    
    
    /**
     * Devuelve un expediente a partir de su id.
     *
     * @param idExpediente el id del expediente
     * @return El expediente
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE)
    public Expediente getExpediente(Long idExpediente);
    
    /**
     * Obtiene la solicitud de exclusi�n de clientes en un expediente.
     * @param idExpediente Long: expediente asociado a la exclusi�n
     * @return ExclusionExpedienteCliente
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_FIND_EXCLUSION_EXPEDIENTE_CLIENTE_BY_EXPEDIENTE)
    public ExclusionExpedienteCliente findExclusionExpedienteClienteByExpedienteId(Long idExpediente);
    
    /**
     * Crea un asunto + procedimiento + iter.
     *
     * @param idExpediente id del expediente origen
     * @param dca Decision tomada por el comite de manera automatica
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_DATOS_PARA_DECISION_COMITE_AUTO)
    @Transactional(readOnly = false)
    public Long crearDatosParaDecisionComiteAutomatica(Long idExpediente, DecisionComiteAutomatico dca);
    
    /**
     * Salva un expediente.
     *
     * @param exp el expediente a salvar
     *
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void saveOrUpdate(Expediente exp);
    
    /**
    * cierre de la toma de decision de un expediente.
    * @param idExpediente expediente
    * @param observaciones observaciones de la decision
    * @param automatico automatico
    * @param generaNotificacion generaNotificacion
    */
   @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_TOMAR_DECISION_COMITE_COMPLETO)
   @Transactional(readOnly = false)
   public void tomarDecisionComite(Long idExpediente, String observaciones, boolean automatico, boolean generaNotificacion);
   
   /**
    * Setea el instante en que cambi� el estado de un expediente.
    * @param idExpediente el id del expediente.
    */
   @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_SET_INSTANCE_CAMBIO_ESTADO_EXPEDIENTE)
   @Transactional(readOnly = false)
   public void setInstanteCambioEstadoExpediente(Long idExpediente);
   
   /**
    * Crea un expediente.
    *
    * @param idContrato id del contrato principal
    * @param idArquetipo id del arquetipo del cliente
    * @param idBPMExpediente proceso BPM asociado
    * @param idPersona id
    * @param idBPMCliente proceso bpm del cliente?
    * @return Expediente
    */
   @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_AUTO)
   @Transactional(readOnly = false)
   public Expediente crearExpedienteAutomatico(Long idContrato, Long idPersona, Long idArquetipo, Long idBPMExpediente, Long idBPMCliente);
   
   /**
    * cambia el estado del itinerario del expediente.
    * @param idExpediente id del expediente
    * @param estadoItinerario estado
    */
  @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CAMBIAR_ESTADO_ITINERARIO_EXPEDIENTE)
  @Transactional(readOnly = false)
  public void cambiarEstadoItinerarioExpediente(Long idExpediente, String estadoItinerario);
    
  /**
   * Congela un expediente.
   * @param idExpediente id
   */
  @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_DESCONGELAR_EXPEDIENTE)
  @Transactional(readOnly = false)
  public void desCongelarExpediente(Long idExpediente);
  
  /**
   * calcular el comite del expediente.
   * @param idExpediente id del expediente
   */
  @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CALCULAR_COMITE_EXPEDIENTE)
  @Transactional(readOnly = false)
  public void calcularComiteExpediente(Long idExpediente);
  
  /**
   * Congela un expediente.
   * @param idExpediente id
   */
  @BusinessOperationDefinition(InternaBusinessOperation.BO_EXP_MGR_CONGELAR_EXPEDIENTE)
  @Transactional(readOnly = false)
  public void congelarExpediente(Long idExpediente);
}
