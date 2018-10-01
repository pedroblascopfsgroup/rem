package es.pfsgroup.plugin.rem.activotrabajo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;

public interface ActivoTrabajoDao extends AbstractDao<ActivoTrabajo, Long>{
	
	public ActivoTrabajo findOne(Long idActivo, Long idTrabajo);
	
}
