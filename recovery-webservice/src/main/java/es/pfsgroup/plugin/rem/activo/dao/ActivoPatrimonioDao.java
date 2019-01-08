package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;

public interface ActivoPatrimonioDao extends AbstractDao<ActivoPatrimonio, Long>{
	
	/**
	 * Devuelve un objeto ActivoPatrimonio a partir del id de un activo
	 * @param idActivo
	 * @return ActivoPatrimonio
	 */
	public ActivoPatrimonio getActivoPatrimonioByActivo(Long idActivo);

	/**
	 * Este método obtiene el campo el diccionario de adecuación alquiler de la entidad de patrimonio por el ID
	 * de activo.
	 *
	 * @param idActivo: ID del activo del que obtener el patrimonio.
	 * @return Devuelve la entidad diccionario adecuación alquiler de la entidad patrimonio.
	 */
	DDAdecuacionAlquiler getAdecuacionAlquilerFromPatrimonioByIdActivo(Long idActivo);
	
}
