package es.capgemini.pfs.itinerario.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;

/**
 * Interfaz ReglasElevacionDao.
 * @author pjimenez
 *
 */
public interface ReglasElevacionDao extends AbstractDao<ReglasElevacion, Long> {

    /**
     * Retorna todas las reglas definidas de un tipo específico para un estado determinado.
     * @param idTipoRegla Long
     * @param idEstado Long
     * @return Lista de reglas de elevación.
     */
    List<ReglasElevacion> findByTipoAndEstado(Long idTipoRegla, Long idEstado);

}
