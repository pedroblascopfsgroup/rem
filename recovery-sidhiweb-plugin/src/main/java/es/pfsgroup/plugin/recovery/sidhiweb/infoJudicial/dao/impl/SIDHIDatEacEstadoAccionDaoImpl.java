package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao.SIDHIDatEacEstadoAccionDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIDatEacEstadoAccion;

@Repository("SIDHIDatEacEstadoAccionDao")
public class SIDHIDatEacEstadoAccionDaoImpl extends AbstractEntityDao<SIDHIDatEacEstadoAccion, Long> implements SIDHIDatEacEstadoAccionDao {

	
	public SIDHIDatEacEstadoAccion getEstadoAccionActualizada(){
		
		HQLBuilder hqlbuilder = new HQLBuilder("from SIDHIDatEacEstadoAccion eac");
		hqlbuilder.appendWhere("eac.id = 3");
		
		return HibernateQueryUtils.uniqueResult(this, hqlbuilder);
	
	}

}
