package es.capgemini.pfs.cirbe.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cirbe.dao.DDTipoGarantiaCirbeDao;
import es.capgemini.pfs.cirbe.model.DDTipoGarantiaCirbe;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Dao de clase DDCodigoOperacionCirbe.
 *  @author: Pablo Müller
 */
@Repository("DDTipoGarantiaCirbeDao")
public class DDTipoGarantiaCirbeDaoImpl extends AbstractEntityDao<DDTipoGarantiaCirbe, Long> implements DDTipoGarantiaCirbeDao {
}
