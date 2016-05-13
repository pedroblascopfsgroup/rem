package es.pfsgroup.plugin.recovery.masivo.controller;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVNotificacionDemandadosApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVFechasNotificacionDto;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVDireccionFechaNotificacion;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumen;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoResumenPersona;

/**
 * Controlador para gestionar la funcionalidad de notificaci�n a demandados
 * <p>
 * <img src="doc-files/tumblr_inline_misu5jgtfv1qz4rgp.gif" />
 * </p>
 * 
 * @author bruno
 * 
 */
@Controller
public class MSVNotificacionDemandadosController {

	/**
	 * Define cual va a ser la JSP que implementa la ventana resumen con las
	 * fechas de notificaci�n
	 */
	public static final String JSP_VENTANA_NOTIFICACION = "plugin/masivo/notificacionDemandados/notificacionDemandados";
	public static final String JSP_VENTANA_NOTIFICACIONV4 = "plugin/masivo/procedimientos/tabs/tabNotificacionDemandadosV4Edicion";

	/**
	 * Define cual va a ser la JSP que implementa la ventana de notificaci�n de
	 * domicilios
	 */
	public static final String JSP_VENTANA_NOTIFICACION_DOMICILIOS = null;

	/**
	 * Define el JSON con los datos del resumen de fechas de notificacion
	 */
	public static final String JSON_RESUMEN_FECHAS_NOTIFICACION = "plugin/masivo/notificacionDemandados/resumenFechasNotificacionJSON";
	
	/**
	 * Define el JSON con los datos del detalle de fechas de notificacion
	 */
	public static final String JSON_DETALLE_FECHAS_NOTIFICACION = "plugin/masivo/notificacionDemandados/detalleFechasNotificacionJSON";

	/**
	 * Define el JSON con los datos hist�ricos del detalle de fechas de notificacion
	 */
	public static final String JSON_HISTORICO_DETALLE_FECHAS_NOTIFICACION = "plugin/masivo/notificacionDemandados/detalleHistoricoFechasNotificacionJSON";

	public static final String JSON_UPDATE_NOTIFICACION = "plugin/masivo/notificacionDemandados/detalleUpdateNotificacionJSON";
	
	public static final String JSON_TR_NOTIFICACION_PERSONAL = "plugin/masivo/notificacionDemandados/compruebaTrNotificacionPersonalJSON";

	@Autowired
	private ApiProxyFactory apiProxyFactory;
	
	
	
	/**
	 * <strong>Ventana de notificaci�n masiva</strong>
	 * <p>
	 * Abre una ventana en la que se muestra el resumen de notificaci�n por
	 * demandados y en la que el gestor interactuar� para informar las
	 * notificaciones.
	 * </p>
	 * <p>
	 * <img src="doc-files/ventanaNotificacionMasiva.png" />
	 * </p>
	 * 
	 * @param map
	 * @param idProcedimiento
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreVentanaNotificacion(ModelMap map, Long idProcedimiento) {
		
		map.put("idProcedimiento", idProcedimiento);
		
		return JSP_VENTANA_NOTIFICACION;
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreVentanaNotificacionV4(ModelMap map, Long idProcedimiento) {
		
		map.put("idProcedimiento", idProcedimiento);
		return JSP_VENTANA_NOTIFICACIONV4;
	}
	
	
	/**
	 * <strong>Resumen de fechas de notificaci�n</strong>
	 * <p>
	 * Devuelve los datos con el resumen de fechas que se debe mostrar en la <b>ventana de notificaci�n masiva</b>.
	 * </p>
	 * <p>
	 * <img src="doc-files/getResumenFechasNotificacionData.png" />
	 * </p>
	 * @param map
	 * @param idProcedimiento
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getResumenFechasNotificacionData(ModelMap map, MSVFechasNotificacionDto dto) throws Exception{
		
		List<MSVInfoResumen> listado = apiProxyFactory.proxy(MSVNotificacionDemandadosApi.class).getResumenNotificaciones(dto.getIdProcedimiento());
		map.put("data", listado);
		
		return JSON_RESUMEN_FECHAS_NOTIFICACION;
	}

	/**
	 * <strong>Ventana notificaci�n domicilios</strong>
	 * <p>
	 * Esta ventana se abre cuando el usuario pulsa en el bot�n de <strong>Not.
	 * en domicilio</strong>. Esta ventana muestra los domicilios del demandado
	 * y permite introducir las fechas de solicitud y de resultado de la
	 * notifiacaci�n.
	 * </p>
	 * <p>
	 * <img src="doc-files/ventanaNotificacionDomicilios.png" />
	 * </p>
	 * 
	 * @return
	 */
	@RequestMapping
	@Deprecated
	public String abreVentanaNotificacionDomicilios() {
		return JSP_VENTANA_NOTIFICACION_DOMICILIOS;
	}
	
	/**
	 * <strong>Detalle de fechas de un demandado</strong>
	 * <p>
	 * Devuelve los datos con el detalle de fechas de un demandado</b>.
	 * </p>
	 * @param map
	 * @param idProcedimiento
	 * @param idPersona
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDetalleFechasNotificacionData(ModelMap map, MSVFechasNotificacionDto dto) throws Exception{
		
		List<MSVInfoResumenPersona> listado = apiProxyFactory.proxy(MSVNotificacionDemandadosApi.class).getDetalleNotificaciones(dto.getIdProcedimiento(), dto.getIdPersona());
		map.put("data", listado);
		return JSON_DETALLE_FECHAS_NOTIFICACION;
	}
	
	/**
	 * <strong>Hist�rico Detalle de fechas de un demandado</strong>
	 * <p>
	 * Devuelve los datos con el hist�rico del detalle de fechas de un demandado</b>.
	 * </p>
	 * @param map
	 * @param id
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping	
	public String getHistoricoDetalleFechasNotificacionData(ModelMap map, MSVFechasNotificacionDto dto) throws Exception{
		
		List<MSVDireccionFechaNotificacion> listado = apiProxyFactory.proxy(MSVNotificacionDemandadosApi.class).getHistoricoDetalleNotificaciones(dto);
		map.put("data", listado);
		return JSON_HISTORICO_DETALLE_FECHAS_NOTIFICACION;
	}
	
	/**
	 * Actualiza la informaci�n de una notificaci�n, Fecha de Solicitud, Fecha de Resultado y Resultado.
	 * @param map
	 * @param dto Datos de la notificaci�n
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping	
	public String updateNotificacion(ModelMap map, MSVFechasNotificacionDto dto) throws Exception{
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = apiProxyFactory.proxy(MSVNotificacionDemandadosApi.class).updateNotificacion(dto);
		map.put("data", msvDireccionFechaNotificacion);
		return JSON_UPDATE_NOTIFICACION;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping	
	public String insertNotificacion(ModelMap map, MSVFechasNotificacionDto dto) throws Exception{
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = apiProxyFactory.proxy(MSVNotificacionDemandadosApi.class).insertNotificacion(dto);
		map.put("data", msvDireccionFechaNotificacion);
		return JSON_UPDATE_NOTIFICACION;
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String updateExcluido(ModelMap map, MSVFechasNotificacionDto dto) throws Exception{
		
		MSVDireccionFechaNotificacion msvDireccionFechaNotificacion = apiProxyFactory.proxy(MSVNotificacionDemandadosApi.class).updateExcluido(dto);
		map.put("data", msvDireccionFechaNotificacion);
		return JSON_UPDATE_NOTIFICACION;
	}
	
	
}
