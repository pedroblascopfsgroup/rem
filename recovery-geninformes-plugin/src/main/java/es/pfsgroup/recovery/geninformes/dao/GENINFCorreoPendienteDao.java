package es.pfsgroup.recovery.geninformes.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.geninformes.model.GENINFCorreoPendiente;

public interface GENINFCorreoPendienteDao  extends AbstractDao<GENINFCorreoPendiente, Long> {

	/**
	 * Devuelve la lista de correos no procesados del día actual
	 * @return
	 */
	public List<GENINFCorreoPendiente> getCorreosPendientes();

}
