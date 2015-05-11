package es.capgemini.pfs.itinerario.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.DDTipoReglasElevacion;

/**
 * Interfaz DDTipoReglasElevacionDao.
 * @author pjimenez
 *
 */
public interface DDTipoReglasElevacionDao extends AbstractDao<DDTipoReglasElevacion, Long> {

    /**
     * findByCodigo.
     * @param codigo codigo tipo
     * @return tipo regla
     */
    List<DDTipoReglasElevacion> findByCodigo(String codigo);
}
