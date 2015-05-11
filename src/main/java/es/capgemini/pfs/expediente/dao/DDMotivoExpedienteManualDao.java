package es.capgemini.pfs.expediente.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.expediente.model.DDMotivoExpedienteManual;

/**
 * Clase que agrupa m�todo para la creaci�n y acceso de datos de los
 * Estados del Expediente.
 * @author jbosnjak
 */

public interface DDMotivoExpedienteManualDao extends AbstractDao<DDMotivoExpedienteManual, Long> {

    /**
     * Devuelve un tipo de estado expediente por su código.
     * @param codigo el codigo
     * @return el estado expediente.
     */
    DDMotivoExpedienteManual getByCodigo(String codigo);
}
