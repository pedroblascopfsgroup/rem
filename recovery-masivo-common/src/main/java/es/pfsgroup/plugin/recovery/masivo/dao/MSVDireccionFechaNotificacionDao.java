package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.List;
import java.util.Map;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;

/**
 * Dao del objeto MSVDireccionFechaNotificacion
 * @author manuel
 *
 */
public interface MSVDireccionFechaNotificacionDao extends AbstractDao<MSVDireccionFechaNotificacion, Long>{
	
	/**
	 * Recupera todas las fechas relativas a la notificaci�n de demandados de un procedimiento.
	 * @param idProcedimiento
	 * @return
	 */
	List<MSVDireccionFechaNotificacion> getFechasNotificacion(Long idProcedimiento);
	
	/**
	 * Recupera todas las fechas relativas a la notificaci�n de demandados de un procedimiento.
	 * @param idProcedimiento
	 * @return
	 */
	List<MSVDireccionFechaNotificacion> getFechasNotificacion(Procedimiento procedimiento);

	/**
	 * Recupera todas las fechas relativas a la notificaci�n de demandados de un procedimiento y las agrupa por persona. 
	 * @param procedimiento
	 * @return
	 */
	Map<Long, List<MSVDireccionFechaNotificacion>> getMapaPersonasFechasNotificacion(Procedimiento procedimiento);
	
	/**
	 * Recupera todas las fechas relativas a la notificaci�n de un demandado de un procedimiento.
	 * @param idProcedimiento
	 * @return
	 */
	List<MSVDireccionFechaNotificacion> getFechasNotificacionPorPersona(Long idProcedimiento, Long idPersona);

	/**
	 * Recupera todas las fechas relativas a la notificaci�n de la direcci�n de un demandado de un procedimiento.
	 * @param idProcedimiento
	 * @param idPersona
	 * @param idDireccion
	 * @return
	 */
	List<MSVDireccionFechaNotificacion> getFechasNotificacionPorDireccion(Long idProcedimiento, Long idPersona, String idDireccion);



}
