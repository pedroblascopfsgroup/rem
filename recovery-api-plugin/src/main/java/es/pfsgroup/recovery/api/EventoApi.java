package es.pfsgroup.recovery.api;

import java.util.List;

import es.capgemini.pfs.expediente.model.Evento;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

/**
 * BO para eventos de Recovery
 * @author bruno
 *
 */
public interface EventoApi {

	
	/**
     * Devuelve una lista con el historico de eventos para una entidad de informacion.
     * @param tipoEntidad El Codigo de tipo de entidad (Ver {@link TipoEntidad} )
     * @param idEntidad El id de la entidad de informacion
     * @return List Evento
     */
    @BusinessOperationDefinition(InternaBusinessOperation.BO_EVENTO_MGR_HISTORICO_EVENTOS)
    List<Evento> getHistoricoEventos(String tipoEntidad, Long idEntidad);
}
