package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;

public interface ActivoPatrimonioDao extends AbstractDao<ActivoPatrimonio, Long>{
	
	/**
	 * Devuelve un objeto ActivoPatrimonio a partir del id de un activo
	 * @param idActivo
	 * @return ActivoPatrimonio
	 */
	public ActivoPatrimonio getActivoPatrimonioByActivo(Long idActivo);

	
}
