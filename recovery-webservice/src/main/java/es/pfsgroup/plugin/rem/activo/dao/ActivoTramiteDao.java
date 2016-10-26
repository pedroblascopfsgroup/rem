package es.pfsgroup.plugin.rem.activo.dao;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

/**
 * Interfaz para manejar el acceso a datos de los trámites de Activo.
 * @author Daniel Gutiérrez
 */

public interface ActivoTramiteDao extends AbstractDao<ActivoTramite, Long>{

	/**
	 * Devuelve los trámites asociados a un activo.
	 * @param idActivo el id del activo
	 * @return el page de trámites
	 */
	Page getTramitesActivo(Long idActivo, WebDto webDto);
	
	
	/**
	 * Devuelve los trámites asociados a un activo
	 * @param idActivo el id del activo
	 * @return la lista de trámites
	 */
	List<ActivoTramite> getListaTramitesActivo(Long idActivo);
	
	
	/**
	 * Devuelve los trámites de un activo y trabajo
	 * @param idActivo
	 * @param idTrabajo
	 * @param webDto
	 * @return
	 */
	Page getTramitesActivoTrabajo(Long idTrabajo, WebDto webDto);
	
	/**
	 * Devuelve el listado de trámites de admisión asociados a un activo.
	 * @param idActivo
	 * @return
	 */
	List<ActivoTramite> getListaTramitesActivoAdmision(Long idActivo);


	List<ActivoTramite> getTramitesActivoTrabajoList(Long idTrabajo);

}
