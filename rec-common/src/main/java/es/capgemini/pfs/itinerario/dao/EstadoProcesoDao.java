package es.capgemini.pfs.itinerario.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.EstadoProceso;

/**
 * Interfaz dao para los estados procesos.
 * @author jpb
 *
 */
public interface EstadoProcesoDao extends AbstractDao<EstadoProceso, Long> {

    /**
     * Busca el EstadoProcese activo para la entidad indicada.
     * @param entidad id de la entidad
     * @param codigoTipoEntidad codigo de la entidad
     * @return EntidadProceso o null si no existe
     */
    EstadoProceso buscarEstadoActivo(Long entidad, String codigoTipoEntidad);

}
