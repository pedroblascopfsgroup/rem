package es.capgemini.pfs.expediente.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.SancionDao;
import es.capgemini.pfs.expediente.model.Sancion;

/**
 * Implementación del dao de sancion del expediente.
 *
 * @author carlos gil
 */
@Repository("SancionDao")
public class SancionDaoImpl extends AbstractEntityDao<Sancion, Long> implements SancionDao {

}
