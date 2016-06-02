package es.capgemini.pfs.dsm.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.dsm.model.EntidadConfig;

/**
 * Dao para EntidadConfig.
 *
 */
public interface EntidadConfigDao extends AbstractDao<EntidadConfig, Long> {

	EntidadConfig findByEntidad(Long idEntidad);

}
