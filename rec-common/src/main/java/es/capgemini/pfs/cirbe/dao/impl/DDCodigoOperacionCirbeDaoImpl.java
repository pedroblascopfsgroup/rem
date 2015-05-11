package es.capgemini.pfs.cirbe.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cirbe.dao.DDCodigoOperacionCirbeDao;
import es.capgemini.pfs.cirbe.model.DDCodigoOperacionCirbe;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Dao de clase DDCodigoOperacionCirbe.
 *  @author: Pablo Müller
 */
@Repository("DDCodigoOperacionCirbeDao")
public class DDCodigoOperacionCirbeDaoImpl extends AbstractEntityDao<DDCodigoOperacionCirbe, Long> implements DDCodigoOperacionCirbeDao {
}
