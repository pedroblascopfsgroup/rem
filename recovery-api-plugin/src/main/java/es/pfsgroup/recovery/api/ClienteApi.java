package es.pfsgroup.recovery.api;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface ClienteApi {

	/**
     * Obtiene un cliente.
     * @param id id del cliente
     * @return entidad cliente
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CLI_MGR_GET_WITH_ESTADOS)
    @Transactional
    public Cliente getWithEstado(Long id);
    
    /**
     * Graba o updatea un cliente.
     * @param cliente cliente.
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CLI_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Cliente cliente);
    
    /**
     * Obtiene un cliente.
     * @param id id del cliente
     * @return entidad cliente
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CLI_MGR_GET_WITH_CONTRATOS)
    @Transactional
    public Cliente getWithContratos(Long id);
    
    /**
     * Crea un cliente para el id de la persona indicada.
     * <br>Le asigna todos los contratos de la persona.
     * <br>Y genera los antecedentes para su futura carga
     * @param personaId Long
     * @param idJBPM idProceso
     * @param arquetipoId Long
     * @param manual manual/automatico
     * @return idCliente
     */
    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false)
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CLI_MGR_CREAR_CLIENTE)
    public Long crearCliente(Long personaId, Long idJBPM, Long arquetipoId, Boolean manual);
    
    /**
     * cambia el estado del itinerario del cliente.
     * @param idCliente id del cliente
     * @param estadoItinerario estado
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_CLI_MGR_CAMBIAR_ESTADO_ITINERARIO_CLIENTE)
    public void cambiarEstadoItinerarioCliente(Long idCliente, String estadoItinerario);
}
