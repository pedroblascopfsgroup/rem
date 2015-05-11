package es.capgemini.pfs.exclusionexpedientecliente.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.exclusionexpedientecliente.model.ExclusionExpedienteCliente;

/**
 * @author marruiz
 */
public interface ExclusionExpedienteClienteDao extends AbstractDao<ExclusionExpedienteCliente, Long> {

    /**
     * @param idExpediente Long: expediente asociado a la exclusión
     * @return ExclusionExpedienteCliente
     */
    ExclusionExpedienteCliente findByExpedienteId(Long idExpediente);
}
