package es.capgemini.pfs.expediente.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.PropuestaExpedienteManual;

/**
 * Clase que agrupa método para la creación y acceso de datos de los
 * Estados del Expediente.
 * @author jbosnjak
 */

public interface PropuestaExpedienteManualDao extends AbstractDao<PropuestaExpedienteManual, Long> {

    /**
     * getPropuestaDelExpediente.
     * @param idExpediente idExpediente
     * @return propuesta
     */
    PropuestaExpedienteManual getPropuestaDelExpediente(Long idExpediente);
}
