package es.capgemini.pfs.core.api.expediente;

import java.util.List;

import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EventoApi {
	
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_EXPEDIENTE)
    public List<Evento> getEventosExpediente(Long idExpediente);
	
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_PERSONA)
	public List<Evento> getEventosPersona(Long idPersona); 
	
	@BusinessOperationDefinition(InternaBusinessOperation.BO_EVENTO_MGR_EVENTOS_ASUNTO)
    public List<Evento> getEventosAsunto(Long idAsunto);
	
	/**
     * Devuelve una lista con el historico de eventos para una entidad de informacion.
     * @param tipoEntidad El Codigo de tipo de entidad (Ver {@link TipoEntidad} )
     * @param idEntidad El id de la entidad de informacion
     * @return List Evento
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EVENTO_MGR_HISTORICO_EVENTOS)
    public List<Evento> getHistoricoEventos(String tipoEntidad, Long idEntidad);

}
