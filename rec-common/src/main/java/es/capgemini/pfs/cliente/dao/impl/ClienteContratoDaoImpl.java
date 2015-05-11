package es.capgemini.pfs.cliente.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cliente.dao.ClienteContratoDao;
import es.capgemini.pfs.cliente.model.ClienteContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * DAO de ClienteContrato.
 */
@Repository("ClienteContratoDao")
public class ClienteContratoDaoImpl extends AbstractEntityDao<ClienteContrato, Long> implements ClienteContratoDao {

}
