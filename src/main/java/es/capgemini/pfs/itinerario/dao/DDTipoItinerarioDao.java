package es.capgemini.pfs.itinerario.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;

/**
 * Interfaz DDTipoItinerarioDao.
 * @author pjimenez
 *
 */
public interface DDTipoItinerarioDao extends AbstractDao<DDTipoItinerario, Long> {

    /**
     * findByCodigo.
     * @param codigo codigo tipo
     * @return estado
     */
    List<DDTipoItinerario> findByCodigo(String codigo);
}
