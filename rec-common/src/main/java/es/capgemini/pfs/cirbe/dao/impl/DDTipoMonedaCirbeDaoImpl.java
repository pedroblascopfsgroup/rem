package es.capgemini.pfs.cirbe.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cirbe.dao.DDTipoMonedaCirbeDao;
import es.capgemini.pfs.cirbe.model.DDTipoMonedaCirbe;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Dao de clase DDCodigoOperacionCirbe.
 *  @author: Pablo Müller
 */
@Repository("DDTipoMonedaCirbeDao")
public class DDTipoMonedaCirbeDaoImpl extends AbstractEntityDao<DDTipoMonedaCirbe, Long> implements DDTipoMonedaCirbeDao {
}
