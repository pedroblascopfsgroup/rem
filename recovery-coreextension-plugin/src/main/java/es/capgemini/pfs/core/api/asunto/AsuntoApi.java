package es.capgemini.pfs.core.api.asunto;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.EditAsuntoDtoInfo;
import es.capgemini.pfs.asunto.dto.DtoAsunto;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AsuntoApi {

	String BO_CORE_ASUNTO_GET_HISTORICO_ASUNTO = "core.asunto.getHistoricoAsunto";
	String BO_CORE_ASUNTO_GET_HISTORICO_TAREAS_PROCEDIMIENTO_ASUNTO = "core.asunto.getHistoricoTareasProcedimientoAsunto";
	String BO_CORE_ASUNTO_GET_EXT_HISTORICO_ASUNTO = "core.asunto.getExtHistoricoAsunto";
	String BO_ASU_UPDATE = "core.asunto.update";
	String BO_CORE_ASUNTO_ADJUNTOSMAPEADOS = "core.asunto.adjuntosMapeados";
	String BO_CORE_ASUNTO_ADJUNTOSCONTRATOS = "core.asunto.getAdjuntosContrato";
	String BO_CORE_ASUNTO_ADJUNTOSPERSONA = "core.asunto.getAjuntosPersonas";
	String BO_CORE_ASUNTO_ADJUNTOSEXPEDIENTE = "core.asunto.getAjuntosExpediente";
	String BO_CORE_ASUNTO_ADJUNTOSMAPEADOS_BY_PRC_ID = "core.asunto.adjuntosMapeadosByPrcId";
	String BO_CORE_ASUNTO_PUEDER_VER_TAB_SUBASTA = "core.asunto.puedeVerTabSubasta";	
	String BO_CORE_ASUNTO_PUEDER_VER_TAB_ADJUDICADOS = "core.asunto.puedeVerTabAdjudicados";
	String BO_CORE_ASUNTO_CONTIENE_PROVISIONES = "core.asunto.contieneProvisiones";	
	
	
	 /**
     * Crea un nuevo asunto en estado vacio con un gestor.
     * @param dtoAsunto el Dto de Asuntos.
     * @return el id del nuevo asunto
     */
    //@BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_CREAR_ASUNTO_DTO)
   // @Transactional(readOnly = false)
    //public Long crearAsunto(DtoAsunto dtoAsunto);
    
    /**
     * Crea un nuevo asunto en estado vacio con un gestor.
     * @param gd GestorDespacho gestor
     * @param sup GestorDespacho supervisor
     * @param nombreAsunto String
     * @param exp Expediente
     * @param observaciones String
     * @return el id del nuevo asunto
     */    
   // @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_CREAR_ASUNTO)
   // @Transactional(readOnly = false)
   // public Long crearAsunto(GestorDespacho gd, GestorDespacho sup, GestorDespacho procurador, String nombreAsunto, Expediente exp,
    //        String observaciones);

	@BusinessOperationDefinition(BO_CORE_ASUNTO_GET_HISTORICO_ASUNTO)
	List<? extends HistoricoAsuntoInfo> getHistoricoAsunto(Long idAsunto);
	
	@BusinessOperationDefinition(BO_CORE_ASUNTO_GET_HISTORICO_TAREAS_PROCEDIMIENTO_ASUNTO)
	List<? extends HistoricoAsuntoInfo> getHistoricoTareasProcedimientoAsunto(Long idAsunto);
	
	@BusinessOperationDefinition(BO_CORE_ASUNTO_GET_EXT_HISTORICO_ASUNTO)
	List<? extends HistoricoAsuntoInfo> getExtHistoricoAsunto(Long idAsunto);
	
	/**
     * devuelve un asunto.
     * @param id id
     * @return asunto
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_GET)
    public Asunto get(Long id);
    
    /**
	 * Actualiza un asunto
	 * @param dto Datos editables del Asunto
	 * @return Asunto cambiado
	 */
	@BusinessOperationDefinition(BO_ASU_UPDATE)
	Asunto actualizaAsunto(EditAsuntoDtoInfo dto);
	
	 /**
     * Salva un Asunto.
     * @param asunto el Asunto para salvar.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE)
    public void saveOrUpdateAsunto(Asunto asunto) ;
    
    /**
     * @param idAsunto Long
     * @return List Persona: todas las personas demandadas en los procedimientos del asunto.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_PERSONAS_DE_UN_ASUNTO)
    public List<Persona> obtenerPersonasDeUnAsunto(Long idAsunto);
    
    /**
     * Obtiene las actuaciones (Procedimientos) de un asunto.
     * @param idAsunto long
     * @return lista de procedimientos
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO)
    public List<Procedimiento> obtenerActuacionesAsunto(Long idAsunto); 
    
    @BusinessOperationDefinition(BO_CORE_ASUNTO_ADJUNTOSMAPEADOS)
    public List<? extends AdjuntoDto> getAdjuntosConBorrado(Long id);
    
    /**
     * 
     * @param id del Asunto
     * @return lista ordenada por fecha de subida de todos los adjuntos de los contratos del asunto
     */
    @BusinessOperationDefinition(BO_CORE_ASUNTO_ADJUNTOSCONTRATOS)
    public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id);
    
    /**
     * 
     * @param id del Asunto
     * @return lista ordenada por fecha de subida de todos los adjuntos de los clientes del asunto
     */
    @BusinessOperationDefinition(BO_CORE_ASUNTO_ADJUNTOSPERSONA)
    public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id);
    
    /**
     * 
     * @param id del Asunto
     * @return lista ordenada por fecha de subida de todos los adjuntos de los clientes del asunto
     */
    @BusinessOperationDefinition(BO_CORE_ASUNTO_ADJUNTOSEXPEDIENTE)
    public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id);
    
    /**
     * Indica si el Usuario Logado es el gestor del asunto.
     * @param idAsunto el id del asunto
     * @return true si es el gestor.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_ES_GESTOR)
    public Boolean esGestor(Long idAsunto);
    
    /**
     * Indica si el Usuario Logado es el supervisor del asunto.
     * @param idAsunto el id del asunto
     * @return true si es el Supervisor.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_ES_SUPERVISOR)
    public Boolean esSupervisor(Long idAsunto);
    
    /**
     * Busca asuntos paginados.
     * @param dto los par�metros para la Búsqueda.
     * @return Asuntos paginados
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_FIND_ASUNTOS_PAGINATED)
    public Page findAsuntosPaginated(DtoBusquedaAsunto dto) ;
    
    /**
     * Cambia el gestor del asunto. Elimina historico de accesos al Asunto y sus procedimientos asociados del gestor anterior
     * @param dtoAsunto dtoAsunto
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_CAMBIAR_GESTOR_ASUNTO)
    @Transactional(readOnly = false)
    public void cambiarGestorAsunto(DtoAsunto dtoAsunto); 
    
    /**
     * BusinessOperation para cambiar el supervisor del asunto
     * @param dto el Dto del asunto
     * @param temporal flag para indicar si el cambio es temporal (p.ej. vacaciones=true), o definitivo (false)
     */
    @BusinessOperationDefinition("asuntosManager.cambiarSupervisor")
    @Transactional(readOnly = false)
    public void cambiarSupervisor(DtoAsunto dto, boolean temporal);
    

    /**
     * Indica si el usuario puede tomar una acci�n sobre el asunto o si debe completar la ficha antes.
     * @param idAsunto el id del asunto
     * @return true o false.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_PUEDE_TOMAR_ACCION_ASUNTO)
    public Boolean puedeTomarAccionAsunto(Long idAsunto);
    
    
    /**
     * Devuelve en una lista el expediente del asunto.
     * Se envuelve en una lista para que pueda ser iterado en un JSON gen�rico.
     * @param asuntoId Long
     * @return List Expediente
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_GET_EXPEDIENTE_AS_LIST)
    public List<Expediente> getExpedienteAsList(Long asuntoId);
    
    
    /**
     * Devuelve una lista con todos los bienes de los procedimientos de un asunto
     * @param idAsunto
     * @return
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_GET_BIENES_AS_LIST)
    public List<Bien> getBienesDeUnAsunto(Long idAsunto);

    /**
     * Método que devuelve los adjuntos de un procedimiento
     * @param prcId
     * @return
     */
    @BusinessOperationDefinition(BO_CORE_ASUNTO_ADJUNTOSMAPEADOS_BY_PRC_ID)
    public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId);
    
    /**
	 * Método que detecta si alguno de los procedimientos es subasta BANKIA o SAREB
	 * @param asuId
	 * @return TRUE si encuentra el trámite
	 */
    @BusinessOperationDefinition(BO_CORE_ASUNTO_PUEDER_VER_TAB_SUBASTA)
    public Boolean puedeVerTabSubasta(Long asuId);
    
    /**
	 * Mostrar la pestaña si el asunto tiene un trámite de (Adjudicación, posesión, llaves, adjudicación)
	 * @param asuId
	 * @return TRUE si encuentra el trámite
	 */
    @BusinessOperationDefinition(BO_CORE_ASUNTO_PUEDER_VER_TAB_ADJUDICADOS)
    public Boolean puedeVerTabAdjudicados(Long asuId);
    
    /**
	 * Método que detecta si el asunto contiene provisiones
	 * @param asuId
	 * @return TRUE si encuentra una provisión
	 */
    @BusinessOperationDefinition(BO_CORE_ASUNTO_CONTIENE_PROVISIONES)
    public Boolean contieneProvisiones(Long asuId);
    
}
