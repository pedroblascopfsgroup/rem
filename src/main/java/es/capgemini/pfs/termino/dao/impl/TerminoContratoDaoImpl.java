package es.capgemini.pfs.termino.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.termino.dao.TerminoContratoDao;
import es.capgemini.pfs.termino.model.TerminoContrato;

/**
 * @author AMQ
 *
 */
@Repository("TerminoContratoDao")
public class TerminoContratoDaoImpl extends AbstractEntityDao<TerminoContrato, Long> implements TerminoContratoDao {

 
}
