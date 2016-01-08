package es.pfsgroup.recovery.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dto.DtoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AsuntoApi {
	
	
	/**
     * devuelve un asunto.
     * @param id id
     * @return asunto
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_GET)
    public Asunto get(Long id);
    
    
	
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
    
    /**
     * Crea un nuevo asunto en estado vacio con un gestor.
     * @param dtoAsunto el Dto de Asuntos.
     * @return el id del nuevo asunto
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_CREAR_ASUNTO_DTO)
    @Transactional(readOnly = false)
    public Long crearAsunto(DtoAsunto dtoAsunto);
    
    /**
     * Aceptacion del asunto por parte del gestor.
     * @param idAsunto id del asunto
     * @param automatico boolean
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_ACEPTAR_ASUNTO)
    @Transactional(readOnly = false)
    public void aceptarAsunto(Long idAsunto, boolean automatico);
    
    
    /**
     * Modifica un Asunto.
     * @param dtoAsunto el dto con los datos nuevos
     * @return el id;
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ASU_MGR_MODIFICAR_ASUNTO)
    @Transactional(readOnly = false)
    public Long modificarAsunto(DtoAsunto dtoAsunto);
    
    
}
