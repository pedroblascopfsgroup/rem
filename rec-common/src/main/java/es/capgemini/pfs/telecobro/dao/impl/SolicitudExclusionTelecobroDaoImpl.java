package es.capgemini.pfs.telecobro.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.telecobro.dao.SolicitudExclusionTelecobroDao;
import es.capgemini.pfs.telecobro.model.SolicitudExclusionTelecobro;

/**
 * Clase que implementa SolicitudExclusionTelecobroDao.
 * @author aesteban
 *
 */
@Repository("SolicitudExclusionTelecobroDao")
public class SolicitudExclusionTelecobroDaoImpl extends AbstractEntityDao<SolicitudExclusionTelecobro, Long> implements SolicitudExclusionTelecobroDao {

}
