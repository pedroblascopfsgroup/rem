package es.capgemini.pfs.contrato.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.dao.AdjuntoContratoDao;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz AdjuntoContratoDao.
 *
 */
@Repository("AdjuntoContrato")
public class AdjuntoContratoDaoImpl extends AbstractEntityDao<AdjuntoContrato, Long> implements AdjuntoContratoDao {

}
