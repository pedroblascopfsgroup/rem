package es.pfsgroup.plugin.recovery.masivo.api;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVFechasNotificacionDto;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumen;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumenPersona;

public interface MSVNotificacionDemandadosApi {
	
	
	public static final String MSV_BO_GET_RESUMEN_NOTIFICACIONES = "es.pfsgroup.plugin.recovery.masivo.api.getResumenNotificaciones";
	public static final String MSV_BO_GET_DETALLE_NOTIFICACIONES = "es.pfsgroup.plugin.recovery.masivo.api.getDetalleNotificaciones";
	public static final String MSV_BO_GET_HISTORICO_DETALLE_NOTIFICACIONES = "es.pfsgroup.plugin.recovery.masivo.api.getHistoricoDetalleNotificaciones";
	public static final String MSV_BO_UPDATE_NOTIFICACION = "es.pfsgroup.plugin.recovery.masivo.api.updateNotificacion";
	public static final String MSV_BO_INSERT_NOTIFICACION = "es.pfsgroup.plugin.recovery.masivo.api.insertNotificacion";
	public static final String MSV_BO_UPDATE_EXCLUIDO = "es.pfsgroup.plugin.recovery.masivo.api.updateExcluido";
	public static final String MSV_BO_GET_TIPO_NOTIFICACION = "es.pfsgroup.plugin.recovery.masivo.api.getTipoNotificacion";
	public static final String MSV_BO_GET_TIPO_NOTIFICACION_OFICIO_LOCALIZACION = "es.pfsgroup.plugin.recovery.masivo.api.getTipoNotificacionOficioLocalizacion";
	public static final String MSV_BO_GET_TIPO_NOTIFICACION_NOCTURNOS = "es.pfsgroup.plugin.recovery.masivo.api.getTipoNotificacionHorarioNocturno";
	public static final String MSV_BO_TODOS_NOTIFICADOS = "es.pfsgroup.plugin.recovery.masivo.api.todosNotificados";
	
	// Constantes de Requerimiento de Pagos
	public static final String NOTIFICACION_TOTAL = "TOTAL";
	public static final String NOTIFICACION_PARCIAL = "PARCIAL";
	public static final String NOTIFICACION_NEGATIVO = "NEGATIVO";

	// Constantes de Oficios de Localizaci�n
	public static final String OFI_LOC_PRESENT = "PRESENTACION";
	public static final String OFI_LOC_POS_REP = "POSITIVO_REPETIDO";
	public static final String OFI_LOC_POS = "POSITIVO";
	public static final String OFI_LOC_NEG_PAR = "NEGATIVO_PARCIAL";
	public static final String OFI_LOC_NEG_TOT = "NEGATIVO_TOTAL";
	
	// Constantes de Horacios Nocturnos
	public static final String HORARIO_NOCTURNO_PRESENT = "PRESENTACION";
	public static final String HORARIO_NOCTURNO_POSITIVO = "POSITIVO";
	public static final String HORARIO_NOCTURNO_NEGATIVO = "NEGATIVO";
	
	/**
	 * Devuelve un listado resumen del proceso de notificaci�n de un procedimiento.
	 * @param idProcedimiento
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition(MSV_BO_GET_RESUMEN_NOTIFICACIONES)
	public List<MSVInfoResumen> getResumenNotificaciones(Long idProcedimiento) throws Exception;

	/**
	 * Devuelve el de listado de fechas de un demandado.
	 * @param idProcedimiento
	 * @param idPersona
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition(MSV_BO_GET_DETALLE_NOTIFICACIONES)
	public List<MSVInfoResumenPersona> getDetalleNotificaciones(Long idProcedimiento, Long idPersona)  throws Exception;

	/**
	 * Devuelve el hist�rico de fechas de una direcci�n.
	 * @param id
	 * @return
	 * @throws Exception
	 */
//	@BusinessOperationDefinition(MSV_BO_GET_HISTORICO_DETALLE_NOTIFICACIONES)
//	public List<MSVDireccionFechaNotificacion> getHistoricoDetalleNotificaciones(Long idProcedimiento, Long idPersona, Long idDireccion)  throws Exception;

	@BusinessOperationDefinition(MSV_BO_UPDATE_NOTIFICACION)
	MSVDireccionFechaNotificacion updateNotificacion(MSVFechasNotificacionDto dto) throws Exception;

	/**
	 * Guarda los datos de un nuevo hito de notificaci�n.
	 * @param dto con los datos necesarios para identificar correctamente la notificaci�n.
	 * @return {@link MSVDireccionFechaNotificacion} objeto con la nueva notificacion creada. 
	 * @throws Exception
	 */
	@BusinessOperationDefinition(MSV_BO_INSERT_NOTIFICACION)
	public MSVDireccionFechaNotificacion insertNotificacion(MSVFechasNotificacionDto dto) throws Exception;

	/**
	 * Devuelve el hist�rico de fechas de una direcci�n. 
	 * @param dto
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition(MSV_BO_GET_HISTORICO_DETALLE_NOTIFICACIONES)
	public List<MSVDireccionFechaNotificacion> getHistoricoDetalleNotificaciones(MSVFechasNotificacionDto dto) throws Exception;

	/**
	 * Actualiza la propiedad excluido de todas las notificaciones de una persona y procedimiento 
	 */
	@BusinessOperationDefinition(MSV_BO_UPDATE_EXCLUIDO)
	public MSVDireccionFechaNotificacion updateExcluido(MSVFechasNotificacionDto dto) throws Exception;

	/**
	 * Devuelve el tipo de notificaci�n necesario para el c�lculo del input, en funci�n de cu�ntos demandados han sido notificados.
	 * @param prc {@link Procedimiento} procedimiento.
	 * @return String con el tipo de resoluci�n.
	 * 					<p>TOTAL, si todos los demandados han sido notificados.
	 * 					<p>PARCIAL, si alg�n demandado ha sido notificado.
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(MSV_BO_GET_TIPO_NOTIFICACION)
	public String getTipoNotificacionRequerimientoPago(Procedimiento prc);
	
//	@BusinessOperationDefinition(MSV_BO_CREATE_NOTIFICACION)
//	MSVDireccionFechaNotificacion createNotificacion(MSVUpdateNotificacionDto dto) throws Exception; 

	/**
	 * Devuelve el tipo de respuesta necesario para el c�lculo del input de tipo Oficios de Localizacion 
	 * 	en funci�n de varias posibles condiciones.
	 * 
	 * @param prc {@link Procedimiento} procedimiento.
	 * @param idDemandado Long idDemandado para el cual se realizan las comprobaciones
	 * 
	 * @return String con el tipo de resoluci�n.
	 * 					<p>OFI_LOC_PRESENT, si s�lo se ha solicitado.
	 * 					<p>OFI_LOC_POS_REP, positivo repetido.
	 * 					<p>OFI_LOC_POS, positivo sin preintento.
	 * 					<p>OFI_LOC_NEG_PAR, negativo parcial.
	 * 					<p>OFI_LOC_NEG_TOT, negativo total.
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(MSV_BO_GET_TIPO_NOTIFICACION_OFICIO_LOCALIZACION)
	public String getTipoNotificacionOficioLocalizacion(Procedimiento prc, Long idDemandado);
	
	/**
	 * Devuelve el tipo de respuesta necesario para el c�lculo del input de tipo Horas Nocturnas 
	 * 	en funci�n de varias posibles condiciones.
	 * 
	 * @param prc {@link Procedimiento} procedimiento.
	 * @param listaIdDemandados List<Long> lista de ids de demandados para los que realizar la operaci�n
	 * 
	 * @return String con el tipo de resoluci�n.
	 * 					<p>HORARIO_NOCTURNO_PRESENT, si s�lo se ha solicitado.
	 * 					<p>HORARIO_NOCTURNO_POSITIVO, positivo.
	 * 					<p>HORARIO_NOCTURNO_NEGATIVO, negativo.
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(MSV_BO_GET_TIPO_NOTIFICACION_NOCTURNOS)
	public String getTipoNotificacionHorarioNocturno(Procedimiento prc, List<Long> listaIdDemandados);

	@BusinessOperationDefinition(MSV_BO_TODOS_NOTIFICADOS)
	boolean todosNotificados(Long idProcedimiento);
	

}
