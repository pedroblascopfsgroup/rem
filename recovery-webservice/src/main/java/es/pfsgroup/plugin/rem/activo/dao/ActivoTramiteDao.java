package es.pfsgroup.plugin.rem.activo.dao;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoScreening;

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
	
	public List<ActivoTramite> getListaTramitesFromActivoTrabajo(Long idActivo);
	
	/**
	 * Devuelve una lista de tramites asociados a un trabajo, y filtrado por el codigo del tipo de tramite
	 * @param idTrabajo
	 * @param codigoTramite
	 * @return
	 */
	public List<ActivoTramite> getTramitesByTipoAndTrabajo(Long idTrabajo, String codigoTramite);
	
	/**
	 * Devuelve true si el activo con el tipo de procedimiento tiene un tramite vigente
	 * @param idActivo
	 * @param codigoTipoProcedimiento
	 * @return
	 */
	public Boolean tieneTramiteVigenteByActivoYProcedimiento(Long idActivo, String codigoTipoProcedimiento);
	
	/**
	 * Devuelve los tramites comercial venta que tenga un trabajo
	 * @param idTrabajo
	 * @return
	 */
	public ActivoTramite getTramiteComercialVigenteByTrabajo(Long idTrabajo);
	
	public Boolean creaTareaValidacion(String username, String idExpediente);

	ActivoTramite getTramiteComercialVigenteByTrabajoT017(Long idTrabajo);

	ActivoTramite getTramiteComercialVigenteByTrabajoT015(Long idTrabajo);
	
	ActivoTramite getTramiteComercialVigenteByTrabajoT018(Long idTrabajo);
	
	Boolean creaTareas(DtoScreening dto);

	/**
	 * Devuelve el ActivoTramite segun el id del trabajo y el tipo de tramite.
	 * @param idTrabajo
	 * @param codTipoTramite
	 * @return ActivoTamite
	 */
	ActivoTramite getTramiteComercialVigenteByTrabajoYCodTipoTramite(Long idTrabajo, String codTipoTramite);

}
