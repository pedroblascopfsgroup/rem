package es.capgemini.pfs.comite.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.comite.dao.TraspasoExpedienteDao;
import es.capgemini.pfs.comite.model.TraspasoExpediente;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Maneja las accesos a BBDD de las entidades TaspasoExpediente.
 * @author pamuller
 *
 */
@Repository("TraspasoExpedienteDao")
public class TraspasoExpedienteDaoImlp extends AbstractEntityDao<TraspasoExpediente, Long> implements TraspasoExpedienteDao {

}
