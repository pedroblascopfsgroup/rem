package es.pfsgroup.plugin.rem.activo.publicacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;

public interface HistoricoFasePublicacionActivoDao extends AbstractDao<HistoricoFasePublicacionActivo, Long> {

	/**
	 * Este método devuelve el actual (último registro) HistoricoFasePublicacionActivo según el ID del Activo.
	 *
	 * @param idActivo: ID del Activo.
	 * @return Devuelve el actual HistoricoFasePublicacionActivo.
	 */
	HistoricoFasePublicacionActivo getHistoricoFasesPublicacionActivoActualById(Long idActivo);

}
