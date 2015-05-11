package es.capgemini.pfs.recuperacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.recuperacion.model.Recuperacion;

/**
 * @author Mariano Ruiz
 */
public interface RecuperacionDao extends AbstractDao<Recuperacion, Long> {

    /**
     * Devuelve la última recuperación generada para el contrato que se le pasa como parámetro.
     * @param idContrato long
     * @return Recuperacion
     */
    Recuperacion getUltimaRecuperacionByContrato(Long idContrato);
}
