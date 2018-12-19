package es.pfsgroup.plugin.rem.trabajo.dao;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

public interface DDSubtipoTrabajoDao extends AbstractDao<DDSubtipoTrabajo, Long>{
	
	/**
	 * Devuelve una lista de subtipos de trabajo de un trabajo que tengan tarifa plana vigente.
	 * @param idTipoTrabajo
	 * @param fechaSolicitud
	 * @return
	 */
	public List<DDSubtipoTrabajo> getSubtipoTrabajoconTarifaPlana(Long idTipoTrabajo, Date fechaSolicitud);
}
