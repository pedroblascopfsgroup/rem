package es.capgemini.pfs.cirbe.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.cirbe.dao.DDClaseRiesgoCirbeDao;
import es.capgemini.pfs.cirbe.model.DDClaseRiesgoCirbe;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Dao de clase de riesgo cirbe.
 *  @author: Pablo Müller
 */
@Repository("DDClaseRiesgoCirbeDao")
public class DDClaseRiesgoCirbeDaoImpl extends AbstractEntityDao<DDClaseRiesgoCirbe, Long> implements DDClaseRiesgoCirbeDao {
}
