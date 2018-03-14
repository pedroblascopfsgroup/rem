package es.pfsgroup.plugin.rem.activo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoPatrimonio;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonio;

public interface ActivoPatrimonioDao extends AbstractDao<ActivoHistoricoPatrimonio, Long>{
	
	/**
	 * Metodo que devuelve un objeto ActivoHistoricoPatrimonio a partir de un id Activo
	 * @param idActivo
	 * @return ActivoHistoricoPatrimonio
	 */
	public List<ActivoHistoricoPatrimonio> getHistoricoAdecuacionesAlquilerByActivo(long idActivo);

	
}
