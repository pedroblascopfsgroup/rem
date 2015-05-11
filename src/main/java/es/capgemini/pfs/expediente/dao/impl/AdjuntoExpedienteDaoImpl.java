package es.capgemini.pfs.expediente.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.AdjuntoExpedienteDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;

/**
 * Implementación del dao de adjuntos.
 *
 * @author Nicolás Cornaglia
 */
@Repository("AdjuntoExpedienteDao")
public class AdjuntoExpedienteDaoImpl extends AbstractEntityDao<AdjuntoExpediente, Long> implements AdjuntoExpedienteDao {

}
