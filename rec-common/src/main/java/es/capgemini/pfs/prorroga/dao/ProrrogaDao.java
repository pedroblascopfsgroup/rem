package es.capgemini.pfs.prorroga.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.prorroga.model.Prorroga;

/**
 * Interfaz dao para las prorrogas.
 * @author jbosnjak
 *
 */
public interface ProrrogaDao extends AbstractDao<Prorroga, Long> {
    /**
     * Obtiene la decision asociada a una solicitud de prorroga.
     * @param idTaraOriginal long
     * @return Prorroga
     */
    Prorroga obtenerDecisionProrroga(Long idTaraOriginal);

}
