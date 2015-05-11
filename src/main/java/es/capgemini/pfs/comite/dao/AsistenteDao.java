package es.capgemini.pfs.comite.dao;

import es.capgemini.pfs.comite.model.Asistente;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Andrés Esteban
 *
 */
public interface AsistenteDao extends AbstractDao<Asistente, Long> {

    /**
     * Saves the object and flush the hibernate session.
     * @param asistente Asistente
     */
    void saveAndFlush(Asistente asistente);

}
