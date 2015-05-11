package es.capgemini.pfs.expediente.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.PropuestaExpedienteManual;

public interface PropuestaExpedienteManualDao extends AbstractDao<PropuestaExpedienteManual, Long> {

    /**
     * getPropuestaDelExpediente.
     * @param idExpediente idExpediente
     * @return propuesta
     */
    PropuestaExpedienteManual getPropuestaDelExpediente(Long idExpediente);
}
