package es.pfsgroup.plugin.rem.restclient.schedule;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioEnEjecucion;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosList;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;
import net.sf.json.JSONObject;

/**
 * Task de Quartz que comprueba si ha habido algún cambio en BD que requiera de
 * alguna llamada REST a WEBCOM.
 * 
 * La planificación del scheduler la encontraremos en el optional-configuration
 * ac-rem-deteccion-cambios-bd.xml.
 * 
 * Esta clase implementa {@link ApplicationListener} porque necesita saber
 * cuando ha terminado de cargarse el contexto de Spring
 * 
 * @author bruno
 *
 */
public class DeteccionCambiosBDTask implements ApplicationListener {

	private final Log logger = LogFactory.getLog(getClass());

	private Integer tamanyoBloque = null;

	private Integer MAXIMO_INTENTOS = MAXIMO_INTENTOS_DEFAULT;

	private RegistroLlamadasManager registroLlamadas;

	public static final Integer MAXIMO_INTENTOS_DEFAULT = 5;

	@Resource
	private Properties appProperties;

	public enum TIPO_ENVIO {
		COMPLETO, CAMBIOS
	}

	/*
	 * Esa lista se puebla una vez terminado de cargar el contexto de Spring. Esto
	 * se hace capturando el evento ContextRefreshedEvent. Ver el método
	 * onApplicationEvent(ApplicationEvent event)
	 */
	@SuppressWarnings("rawtypes")
	private List<DetectorCambiosBD> registroCambiosHandlers = new ArrayList<DetectorCambiosBD>();

	/**
	 * Este método añade un nuevo handler para gestionar cambios de BD. Este método
	 * es público para permitir realizar esta operación en los tests.
	 * 
	 * @param handler
	 */
	public void addRegistroCambiosBDHandler(DetectorCambiosBD<?> handler) {
		if (handler != null) {
			logger.debug("Añadiendo un nuevo handler para detectar cambios en BD: " + handler.getClass());
			this.registroCambiosHandlers.add(handler);
		}
	}

	public void enviaInformacionCompleta(DetectorCambiosBD<?> handler) throws ErrorServicioWebcom {
		this.detectaCambios(handler, TIPO_ENVIO.COMPLETO);
	}

	public void detectaCambios() throws ErrorServicioWebcom {
		detectaCambios(null);
	}

	/**
	 * Refresca vista materializada
	 */
	public void actualizaVistasMaterializadas() {
		for (DetectorCambiosBD<?> handler : registroCambiosHandlers) {
			handler.actualizarVistaMaterializada();
		}
	}

	@SuppressWarnings("rawtypes")
	public void detectaCambios(DetectorCambiosBD handlerToExecute) throws ErrorServicioWebcom {
		this.detectaCambios(handlerToExecute, TIPO_ENVIO.CAMBIOS);
	}

	@SuppressWarnings("rawtypes")
	public void detectaCambios(DetectorCambiosBD handlerToExecute, Boolean optimizado) throws ErrorServicioWebcom {
		handlerToExecute.setSoloCambiosMarcados(optimizado);
		this.detectaCambios(handlerToExecute, TIPO_ENVIO.CAMBIOS);
		handlerToExecute.setSoloCambiosMarcados(null);
	}

	/**
	 * Inicia la detección de cambios en BD.
	 * 
	 * @param class1
	 * @throws ErrorServicioEnEjecucion
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public void detectaCambios(DetectorCambiosBD handlerToExecute, TIPO_ENVIO tipoEnvio) throws ErrorServicioWebcom {
		obtenerProperties();
		long iteracion = System.currentTimeMillis();
		trace("[DETECCIÓN CAMBIOS] Inicio [it=" + iteracion + "]");
		List<DetectorCambiosBD> registroCambiosHandlersAjecutar = registroCambiosHandlers;
		try {
			if (handlerToExecute != null) {
				registroCambiosHandlersAjecutar = new ArrayList<DetectorCambiosBD>();
				registroCambiosHandlersAjecutar.add(handlerToExecute);
			}

			if ((registroCambiosHandlersAjecutar != null) && (!registroCambiosHandlersAjecutar.isEmpty())) {
				// importante: Si no hacemos esto no se pueden actualizar las
				// vistas materializadas
				registroCambiosHandlersAjecutar.get(0).setdbContext();
				if (!registroCambiosHandlersAjecutar.get(0).isApiRestCerrada()) {
					for (DetectorCambiosBD handler : registroCambiosHandlersAjecutar) {
						procesaHandler(tipoEnvio, handler, iteracion);
					}
				} else {
					trace("La API REST esta cerrada no se ejecutará");
				}
				registroCambiosHandlersAjecutar.get(0).closeSession();
			} else {
				trace("El registro de cambios en BD aún no está disponible");
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new ErrorServicioWebcom(e.getMessage());
		} finally {
			trace("[DETECCIÓN CAMBIOS] Fin [it=" + iteracion + "]");
		}

	}

	/**
	 * Procesa un handler del detector
	 * 
	 * @param tipoEnvio
	 * @param handler
	 * @param iteracion
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void procesaHandler(TIPO_ENVIO tipoEnvio, DetectorCambiosBD handler, long iteracion) {
		if (handler.isActivo()) {
			trace("[DETECCIÓN CAMBIOS] Ejecutando handler: " + handler.getClass().getName());
			ArrayList<RestLlamada> llamadas = new ArrayList<RestLlamada>();
			Class control = handler.getDtoClass();
			CambiosList listPendientes = new CambiosList(tamanyoBloque);

			Integer contError = 0;
			Boolean marcarComoEnviado = true;
			Boolean inicializado = false;
			RestLlamada registro = null;
			do {
				registro = new RestLlamada();
				if (!inicializado) {
					handler.actualizarVistaMaterializada(registro);
					inicializado = true;
				}
				registro.setIteracion(iteracion);
				try {
					if (tipoEnvio.equals(TIPO_ENVIO.CAMBIOS)) {
						listPendientes = handler.listPendientes(control, registro, listPendientes);
					} else {
						listPendientes = handler.listDatosCompletos(control, registro, listPendientes);
					}
					procesaBloque(listPendientes, registro, handler, llamadas);
					contError = 0;
					marcarComoEnviado = true;
				} catch (ErrorServicioWebcom e) {
					// si no es reintentable siguiente bloque
					if (!e.isReintentable()) {
						logger.error(
								"Ha ocurrido un error al invocar al servicio. Esta petición no se va a volver a enviar ya que está marcada como no reintentable",
								e);
						pasarDeBloque(listPendientes);
					} else {
						logger.error(
								"Ha ocurrido un error al invocar al servicio. Se dejan sin marcar los registros para volver a reintentar la llamada",
								e);
						contError++;
						if (contError >= MAXIMO_INTENTOS) {
							marcarComoEnviado = false;
						}
					}
				}
			} while ((listPendientes != null && listPendientes.getPaginacion().getHasMore())
					|| (contError > 0 && contError < MAXIMO_INTENTOS));

			if (marcarComoEnviado) {
				marcarComoEnviado(handler, control, llamadas);
			}
		}

	}

	/**
	 * Procesa un bloque
	 * 
	 * @param listPendientes
	 * @param registro
	 * @param tipoEnvio
	 * @param handler
	 * @param control
	 * @return
	 * @throws ErrorServicioWebcom
	 */
	@SuppressWarnings({ "rawtypes" })
	private JSONObject procesaBloque(CambiosList listPendientes, RestLlamada registro, DetectorCambiosBD handler,
			ArrayList<RestLlamada> llamadas) throws ErrorServicioWebcom {
		JSONObject resultado = null;
		try {
			resultado = ejecutaTarea(handler, listPendientes, registro);
			pasarDeBloque(listPendientes);
		} finally {
			if (!Checks.estaVacio(listPendientes) && registroLlamadas != null) {
				registro.logTiempoBorrarHistorico();
				registro.logTiempoInsertarHistorico();
				registroLlamadas.guardaRegistroLlamada(registro, handler);
				handler.procesaResultado(resultado);

				llamadas.add(registro);
			}
		}
		return resultado;
	}

	/**
	 * Pasa al siguiente bloque, si procede
	 * 
	 * @param listPendientes
	 */
	private void pasarDeBloque(CambiosList listPendientes) {
		if (listPendientes != null && listPendientes.getPaginacion().getTamanyoBloque() != null) {
			if (listPendientes.getPaginacion().getTotalFilas()
					.equals(listPendientes.getPaginacion().getTamanyoBloque())) {
				listPendientes.getPaginacion().setHasMore(true);
				listPendientes.getPaginacion().setNumeroBloque(listPendientes.getPaginacion().getNumeroBloque() + 1);
				trace("[DETECCIÓN CAMBIOS] pasando al bloque " + listPendientes.getPaginacion().getNumeroBloque());

			} else {
				listPendientes.getPaginacion().setHasMore(false);
			}
		}
	}

	/**
	 * Ejecuta una tarea del detector
	 * 
	 * @param handler
	 * @param listPendientes
	 * @param control
	 * @param registro
	 * @throws ErrorServicioWebcom
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public JSONObject ejecutaTarea(DetectorCambiosBD<?> handler, List listPendientes, RestLlamada registro)
			throws ErrorServicioWebcom {
		JSONObject resultado = null;
		if (!Checks.estaVacio(listPendientes)) {
			trace("[DETECCIÓN CAMBIOS] Enviando " + listPendientes.size() + " cambios mediante el handler "
					+ handler.getClass().getName());
		} else {
			trace("[DETECCIÓN CAMBIOS] No se han encontrado cambios para enviar. Handler: "
					+ handler.getClass().getName());
		}

		if ((listPendientes != null) && (!listPendientes.isEmpty())) {
			trace(handler.getClass().getName() + ": invocando al servicio REST");
			resultado = handler.invocaServicio(listPendientes, registro);

		} else {
			logger.trace("'listPendientes' es nulo o está vacío. No hay datos que enviar por servicio");
		}
		return resultado;
	}

	/**
	 * Este método puebla la lista de detectores de cambios una vez el contexto de
	 * Spring ya se encuentra inicializado.
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public void onApplicationEvent(ApplicationEvent event) {
		if (event instanceof ContextRefreshedEvent) {
			if (registroCambiosHandlers == null) {
				registroCambiosHandlers = new ArrayList<DetectorCambiosBD>();
			}

			ApplicationContext applicationContext = ((ContextRefreshedEvent) event).getApplicationContext();

			if (registroCambiosHandlers.isEmpty()) {
				String[] beanNames = applicationContext.getBeanNamesForType(DetectorCambiosBD.class);
				if ((beanNames != null) && (beanNames.length >= 1)) {
					configuraHandlers(applicationContext, beanNames);
				}

			}

			if (registroLlamadas == null) {
				String[] registros = applicationContext.getBeanNamesForType(RegistroLlamadasManager.class);
				if ((registros != null) && (registros.length > 0)) {
					configuraRegistroLlamadas(applicationContext, registros);

				} else if (!registroCambiosHandlers.isEmpty()) {
					logger.warn("*************************************************************");
					logger.warn("No se han encontrado instancias de " + RegistroLlamadasManager.class.getName()
							+ ". No guardarar trazas en la BD de las llamadas a servicios REST de WEBCOM");
					logger.warn("*************************************************************");
				}

			}

		} // end check event

	}

	/**
	 * Obtiene el registro de handlers
	 * 
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List<DetectorCambiosBD> getRegistroCambiosHandlers() {
		return registroCambiosHandlers;
	}

	/**
	 * Configura el registro de llamadas
	 * 
	 * @param applicationContext
	 * @param registros
	 */
	private void configuraRegistroLlamadas(ApplicationContext applicationContext, String[] registros) {
		registroLlamadas = (RegistroLlamadasManager) applicationContext.getBean(registros[0]);
		if (registros.length > 1) {
			trace("Se han encontrado " + registros.length + " implementaciones para "
					+ RegistroLlamadasManager.class.getName() + ". Escogemos una al azar");
		}
	}

	/**
	 * Configura los handlers
	 * 
	 * @param applicationContext
	 * @param beanNames
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void configuraHandlers(ApplicationContext applicationContext, String[] beanNames) {
		for (String name : beanNames) {
			DetectorCambiosBD handler = (DetectorCambiosBD) applicationContext.getBean(name);
			this.addRegistroCambiosBDHandler(handler);
		}
		// ordenamos los handlers por peso
		Collections.sort(registroCambiosHandlers);
	}

	/**
	 * Obtiene las properties basicas
	 */
	private void obtenerProperties() {
		String tamanyoBloqueProperties = !Checks.esNulo(appProperties.getProperty("rest.client.webcom.tamanyobloque"))
				? appProperties.getProperty("rest.client.webcom.tamanyobloque")
				: "10";
		try {
			if (tamanyoBloqueProperties != null) {
				this.tamanyoBloque = Integer.parseInt(tamanyoBloqueProperties);
			}
		} catch (Exception e) {
			logger.error("No se ha podido obtener el tamaño de bloque", e);
		}

		String maximoIntentosProperties = !Checks
				.esNulo(appProperties.getProperty("rest.client.webcom.maximo.intentos"))
						? appProperties.getProperty("rest.client.webcom.maximo.intentos")
						: null;
		try {
			if (maximoIntentosProperties != null) {
				this.MAXIMO_INTENTOS = Integer.parseInt(maximoIntentosProperties);
			}
		} catch (Exception e) {
			logger.error("No se ha podido obtener el maximo de intentos", e);
		}
	}

	/**
	 * Marcar los registros como enviados
	 * 
	 * @param handler
	 * @param control
	 * @param llamadas
	 * @param listPendientesTodosBloques
	 * @param fechaEjecucion
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void marcarComoEnviado(DetectorCambiosBD handler, Class control, ArrayList<RestLlamada> llamadas) {
		trace(handler.getClass().getName() + ": marcando los registros de la BD como enviados");
		handler.marcaComoEnviados(control, llamadas);
	}

	/**
	 * Traza en el log
	 * 
	 * @param mensaje
	 */
	private void trace(String mensaje) {
		Boolean webcomSimulado = Boolean.valueOf(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.WEBCOM_SIMULADO, "true"));
		if (webcomSimulado) {
			logger.error(mensaje);
		} else {
			logger.trace(mensaje);
		}

	}

}
