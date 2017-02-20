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
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDaoError;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosList;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;

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

	private boolean running = false;

	private RegistroLlamadasManager registroLlamadas;

	public static Integer MAXIMO_INTENTOS_DEFAULT = 5;
	@Resource
	private Properties appProperties;

	public enum TIPO_ENVIO {
		COMPLETO, CAMBIOS
	}

	/*
	 * Esa lista se puebla una vez terminado de cargar el contexto de Spring.
	 * Esto se hace capturando el evento ContextRefreshedEvent. Ver el método
	 * onApplicationEvent(ApplicationEvent event)
	 */
	@SuppressWarnings("rawtypes")
	private List<DetectorCambiosBD> registroCambiosHandlers = new ArrayList<DetectorCambiosBD>();

	/**
	 * Este método añade un nuevo handler para gestionar cambios de BD. Este
	 * método es público para permitir realizar esta operación en los tests.
	 * 
	 * @param handler
	 */
	public void addRegistroCambiosBDHandler(DetectorCambiosBD<?> handler) {
		if (handler != null) {
			logger.debug("Añadiendo un nuevo handler para detectar cambios en BD: " + handler.getClass());
			this.registroCambiosHandlers.add(handler);
		}
	}

	public void enviaInformacionCompleta(DetectorCambiosBD<?> handler) {
		this.detectaCambios(handler, TIPO_ENVIO.COMPLETO);
	}

	public void detectaCambios() {
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
	public void detectaCambios(DetectorCambiosBD handlerToExecute) {
		this.detectaCambios(handlerToExecute, TIPO_ENVIO.CAMBIOS);
	}

	/**
	 * Inicia la detección de cambios en BD.
	 * 
	 * @param class1
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void detectaCambios(DetectorCambiosBD handlerToExecute, TIPO_ENVIO tipoEnvio) {
		if (running) {
			logger.warn("El detector de cambios en BD ya se está ejecutando");
			return;
		}
		synchronized (this) {
			running = true;
			this.notifyAll();
		}

		Integer tamanyoBloque = null;
		String tamanyoBloqueProperties = !Checks.esNulo(appProperties.getProperty("rest.client.webcom.tamanyobloque"))
				? appProperties.getProperty("rest.client.webcom.tamanyobloque") : null;
		try {
			if (tamanyoBloqueProperties != null) {
				tamanyoBloque = Integer.parseInt(tamanyoBloqueProperties);
			}
		} catch (Exception e) {
			tamanyoBloque = null;
		}

		Integer MAXIMO_INTENTOS = MAXIMO_INTENTOS_DEFAULT;
		String maximoIntentosProperties = !Checks
				.esNulo(appProperties.getProperty("rest.client.webcom.maximo.intentos"))
						? appProperties.getProperty("rest.client.webcom.maximo.intentos") : null;
		try {
			if (maximoIntentosProperties != null) {
				MAXIMO_INTENTOS = Integer.parseInt(maximoIntentosProperties);
			}
		} catch (Exception e) {
			MAXIMO_INTENTOS = MAXIMO_INTENTOS_DEFAULT;
		}

		long iteracion = System.currentTimeMillis();
		logger.debug("[DETECCIÓN CAMBIOS] Inicio [it=" + iteracion + "]");
		try {
			List<DetectorCambiosBD> registroCambiosHandlersAjecutar = registroCambiosHandlers;
			if (handlerToExecute != null) {
				registroCambiosHandlersAjecutar = new ArrayList<DetectorCambiosBD>();
				registroCambiosHandlersAjecutar.add(handlerToExecute);
			}

			if ((registroCambiosHandlersAjecutar != null) && (!registroCambiosHandlersAjecutar.isEmpty())) {
				// ordenamos los handlers por peso
				Collections.sort(registroCambiosHandlersAjecutar);
				// importante: Si no hacemos esto no se pueden actualizar las
				// vistas materializadas
				registroCambiosHandlersAjecutar.get(0).setdbContext();
				if (!registroCambiosHandlersAjecutar.get(0).isApiRestCerrada()) {
					for (DetectorCambiosBD handler : registroCambiosHandlersAjecutar) {
						if (handler.isActivo()) {
							logger.debug("[DETECCIÓN CAMBIOS] Ejecutando handler: " + handler.getClass().getName());
							ArrayList<RestLlamada> llamadas = new ArrayList<RestLlamada>();
							long startTime = System.currentTimeMillis();

							logger.trace(handler.getClass().getSimpleName() + ": obtenemos los cambios de la BD");
							Class control = handler.getDtoClass();
							CambiosList listPendientes = new CambiosList(tamanyoBloque);
							handler.actualizarVistaMaterializada();
							Boolean marcarComoEnviado = false;
							Integer contError = 0;
							do {
								boolean somethingdone = false;
								RestLlamada registro = new RestLlamada();
								registro.setIteracion(iteracion);
								try {
									if (tipoEnvio.equals(TIPO_ENVIO.CAMBIOS)) {
										listPendientes = handler.listPendientes(control, registro, listPendientes);
									} else {
										listPendientes = handler.listDatosCompletos(control, registro, listPendientes);
									}

									somethingdone = ((listPendientes != null) && (!listPendientes.isEmpty()));
									if (somethingdone) {
										logger.debug("[DETECCIÓN CAMBIOS] Enviando " + listPendientes.size()
												+ " cambios mediante el handler " + handler.getClass().getName());
									} else {
										logger.debug(
												"[DETECCIÓN CAMBIOS] No se han encontrado cambios para enviar. Handler: "
														+ handler.getClass().getName());
									}
									ejecutaTarea(handler, listPendientes, control, registro);
									// pasamos de bloque
									if (listPendientes != null
											&& listPendientes.getPaginacion().getTamanyoBloque() != null) {
										if (listPendientes.size() == listPendientes.getPaginacion()
												.getTamanyoBloque()) {
											listPendientes.getPaginacion().setHasMore(true);
											listPendientes.getPaginacion().setNumeroBloque(
													listPendientes.getPaginacion().getNumeroBloque() + 1);

										} else {
											listPendientes.getPaginacion().setHasMore(false);
										}
									}
									marcarComoEnviado = true;
									contError = 0;
									logger.trace(
											"TIMER DETECTOR FULL detectaCambios [" + handler.getClass().getSimpleName()
													+ "]: " + (System.currentTimeMillis() - startTime));
								} catch (ErrorServicioWebcom e) {
									if (e.isReintentable()) {
										logger.error(
												"Ha ocurrido un error al invocar al servicio. Se dejan sin marcar los registros para volver a reintentar la llamada",
												e);
									} else {
										logger.fatal(
												"Ha ocurrido un error al invocar al servicio. Esta petición no se va a volver a enviar ya que está marcada como no reintentable",
												e);
									}
									// si no es reintentable siguiente bloque
									if (!e.isReintentable()) {
										if (listPendientes.size() == listPendientes.getPaginacion()
												.getTamanyoBloque()) {
											listPendientes.getPaginacion().setHasMore(true);
											listPendientes.getPaginacion().setNumeroBloque(
													listPendientes.getPaginacion().getNumeroBloque() + 1);

										} else {
											listPendientes.getPaginacion().setHasMore(false);
										}
									} else {
										marcarComoEnviado = false;
										contError++;
									}
								} catch (CambiosBDDaoError e) {
									marcarComoEnviado = false;
									logger.error("Detección de cambios [" + handler.getClass().getSimpleName()
											+ "], no se han podido obtener los cambios", e);
									break;
								} finally {
									if (somethingdone && (registroLlamadas != null)) {
										registroLlamadas.guardaRegistroLlamada(registro, handler, contError);
										llamadas.add(registro);
									}
								}
							} while ((listPendientes != null && listPendientes.getPaginacion().getHasMore())
									|| (contError > 0 && contError < MAXIMO_INTENTOS));

							if (marcarComoEnviado) {
								logger.trace(handler.getClass().getName()
										+ ": marcando los registros de la BD como enviados");
								handler.marcaComoEnviados(control, llamadas);
							}
						}
					}
				}else{
					logger.error("La API REST esta cerrada no se ejecutará");
				}
				registroCambiosHandlersAjecutar.get(0).closeSession();
			} else {
				logger.warn("El registro de cambios en BD aún no está disponible");
			}

		} catch (Exception e) {
			running = false;
			logger.error("Imposible ejecutar el detector de cambios", e);
		} finally {
			running = false;
			logger.debug("[DETECCIÓN CAMBIOS] Fin [it=" + iteracion + "]");
		}

	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void ejecutaTarea(DetectorCambiosBD<?> handler, List listPendientes, Class control, RestLlamada registro)
			throws ErrorServicioWebcom {

		if ((listPendientes != null) && (!listPendientes.isEmpty())) {
			logger.trace(handler.getClass().getName() + ": invocando al servicio REST");
			handler.invocaServicio(listPendientes, registro);

		} else {
			logger.trace("'listPendientes' es nulo o está vacío. No hay datos que enviar por servicio");
		}
	}

	/**
	 * Este método puebla la lista de detectores de cambios una vez el contexto
	 * de Spring ya se encuentra inicializado.
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

	private void configuraRegistroLlamadas(ApplicationContext applicationContext, String[] registros) {
		registroLlamadas = (RegistroLlamadasManager) applicationContext.getBean(registros[0]);
		if (registros.length > 1) {
			logger.warn("Se han encontrado " + registros.length + " implementaciones para "
					+ RegistroLlamadasManager.class.getName() + ". Escogemos una al azar");
		}
	}

	@SuppressWarnings("rawtypes")
	private void configuraHandlers(ApplicationContext applicationContext, String[] beanNames) {
		for (String name : beanNames) {
			DetectorCambiosBD handler = (DetectorCambiosBD) applicationContext.getBean(name);
			this.addRegistroCambiosBDHandler(handler);
		}
	}

	@SuppressWarnings("rawtypes")
	public List<DetectorCambiosBD> getRegistroCambiosHandlers() {
		return registroCambiosHandlers;
	}

}
