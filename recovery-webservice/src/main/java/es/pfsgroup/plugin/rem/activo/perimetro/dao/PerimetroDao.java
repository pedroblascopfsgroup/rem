package es.pfsgroup.plugin.rem.activo.perimetro.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;

public interface PerimetroDao extends AbstractDao<PerimetroActivo, Long> {

	/**
	 * Este método obtiene el perímetro de un activo por el ID de activo.
	 *
	 * @param idActivo: ID del activo del que obtener su perímetro.
	 * @return Devuelve un objeto PerimetroActivo.
	 */
	PerimetroActivo getPerimetroActivoByIdActivo(Long idActivo);
}
