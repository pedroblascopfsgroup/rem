package es.pfsgroup.plugin.rem.tareasactivo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.TareaActivo;

public interface TareaActivoDao extends AbstractDao<TareaActivo, Long>{
	
	/**
	 * Devuelve las tareas activo asociadas a un trámite
	 * @param idTramite el id del trámite
	 * @return la lista de tareas del trámite
	 */
	public List<TareaActivo> getTareasActivoTramiteHistorico(Long idTramite);

	TareaActivo getUltimaTareaActivoPorIdTramite(Long idTramite);

	public List<TareaActivo> getTareasActivoPorIdActivo(Long idActivo);

}
