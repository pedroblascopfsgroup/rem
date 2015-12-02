package es.capgemini.pfs.termino.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.termino.dao.TerminoOperacionesDao;
import es.capgemini.pfs.termino.model.TerminoOperaciones;

/**
 * @author AMQ
 *
 */
@Repository("TerminoOperacionesDao")
public class TerminoOperacionesDaoImpl extends AbstractEntityDao<TerminoOperaciones, Long> implements TerminoOperacionesDao {

 
}
