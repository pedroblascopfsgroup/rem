package es.capgemini.pfs.recuperacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.recuperacion.model.Recuperacion;

/**
 * @author Mariano Ruiz
 */
public interface RecuperacionDao extends AbstractDao<Recuperacion, Long> {

    /**
     * Devuelve la �ltima recuperaci�n generada para el contrato que se le pasa como par�metro.
     * @param idContrato long
     * @return Recuperacion
     */
    Recuperacion getUltimaRecuperacionByContrato(Long idContrato);
}
