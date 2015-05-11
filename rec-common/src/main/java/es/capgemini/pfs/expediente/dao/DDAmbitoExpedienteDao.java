package es.capgemini.pfs.expediente.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;

/**
 * Clase que mapea los ambito de expediente.
 * @author pajimenez
 */

public interface DDAmbitoExpedienteDao extends AbstractDao<DDAmbitoExpediente, Long> {

    /**
     * Devuelve un tipo de ambito expediente por su código.
     * @param codigo el codigo
     * @return el ambito expediente.
     */
    DDAmbitoExpediente getByCodigo(String codigo);
}
