package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIDatEacEstadoAccion;

public interface SIDHIDatEacEstadoAccionDao extends AbstractDao<SIDHIDatEacEstadoAccion, Long>{
	
	SIDHIDatEacEstadoAccion getEstadoAccionActualizada();
	
}
