package es.pfsgroup.plugin.rem.restclient.schedule;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.registro.RegistroLlamadasManager;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDaoError;
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
		if (handler == null) {
			throw new IllegalArgumentException("'handler' no puede ser NULL");
		}

		if (running) {
			logger.debug("Este proceso está bloqueado por otro hilo de ejecución. Esperando a que finalice");
		}
		int times = 0;
		while (running && (times < 6)) {
			try {
				Thread.sleep(10000);
			} catch (InterruptedException e) {
				String message = "Se ha abortado la espera";
				logger.fatal(message);
				Thread.currentThread().interrupt();
			}
			times++;
		}

		Class<?> control = handler.getDtoClass();

		if (running) {
			logger.fatal("Ha cadudado el tiempo de espera y el proceso aún está bloqueado");
			throw new DeteccionCambiosTaskError("Ha cadudado el tiempo de espera y el proceso aún está bloqueado");
		}
		synchronized (this) {
			running = true;
			this.notifyAll();
		}

		logger.info("[inicio] Envío de información completa a WEBCOM mediante REST");
		RestLlamada registro = new RestLlamada();
		boolean somethingdone = false;
		try {

			long startTime = System.currentTimeMillis();

			logger.debug(handler.getClass().getSimpleName() + ": obtenemos toda la información de la  BD");
			List<?> listPendientes = handler.listDatosCompletos(control, registro);
			somethingdone = ((listPendientes != null) && (!listPendientes.isEmpty()));

			ejecutaTarea(handler, listPendientes, control, registro);

			logger.debug("TIMER DETECTOR FULL enviaInformacionCompleta [" + handler.getClass().getSimpleName() + "]: "
					+ (System.currentTimeMillis() - startTime));

		} finally {
			if (somethingdone && (registroLlamadas != null)) {
				registroLlamadas.guardaRegistroLlamada(registro);
			}
			logger.info("[fin] Envío de información completa a WEBCOM mediante REST");
			running = false;
		}
	}
	
	public void detectaCambios() {
		detectaCambios(null);
	}

	/**
	 * Inicia la detección de cambios en BD.
	 * 
	 * @param class1
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void detectaCambios(DetectorCambiosBD handlerToExecute) {
		if (running) {
			logger.warn("El detector de cambios en BD ya se está ejecutando");
			return;
		}
		synchronized (this) {
			running = true;
			this.notifyAll();
		}

		long iteracion = System.currentTimeMillis();
		logger.info("[inicio] Detección de cambios en BD  WEBCOM mediante REST [it=" + iteracion + "]");
		try {
			List<DetectorCambiosBD> registroCambiosHandlersAjecutar = registroCambiosHandlers;
			if(handlerToExecute!=null){
				registroCambiosHandlersAjecutar = new ArrayList<DetectorCambiosBD>();
				registroCambiosHandlersAjecutar.add(handlerToExecute);
			}
			
			if ((registroCambiosHandlersAjecutar != null) && (!registroCambiosHandlersAjecutar.isEmpty())) {
				for (DetectorCambiosBD handler : registroCambiosHandlersAjecutar) {
					RestLlamada registro = new RestLlamada();
					registro.setIteracion(iteracion);
					boolean somethingdone = false;
					try {
						long startTime = System.currentTimeMillis();

						logger.debug(handler.getClass().getSimpleName() + ": obtenemos los cambios de la BD");
						Class control = handler.getDtoClass();
						List listPendientes = handler.listPendientes(control, registro);
						somethingdone = ((listPendientes != null) && (!listPendientes.isEmpty()));

						ejecutaTarea(handler, listPendientes, control, registro);

						logger.debug("TIMER DETECTOR FULL detectaCambios [" + handler.getClass().getSimpleName() + "]: "
								+ (System.currentTimeMillis() - startTime));
					} catch (CambiosBDDaoError e) {
						logger.error("Detección de cambios [" + handler.getClass().getSimpleName()
								+ "], no se han podido obtener los cambios", e);
					} finally {
						if (somethingdone && (registroLlamadas != null)) {
							registroLlamadas.guardaRegistroLlamada(registro);
						}
					}
				}
			} else {
				logger.warn("El registro de cambios en BD aún no está disponible");
			}
		} finally {
			running = false;
			logger.info("[fin] Detección de cambios en BD  WEBCOM mediante REST [it=" + iteracion + "]");
		}

	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void ejecutaTarea(DetectorCambiosBD<?> handler, List listPendientes, Class control, RestLlamada registro) {

		if ((listPendientes != null) && (!listPendientes.isEmpty())) {
			logger.debug(handler.getClass().getName() + ": invocando al servicio REST");
			try {
				handler.invocaServicio(listPendientes, registro);
			} catch (ErrorServicioWebcom e) {
				if (e.isReintentable()) {
					logger.error(
							"Ha ocurrido un error al invocar al servicio. Se dejan sin marcar los registros para volver a reintentar la llamada",
							e);
					return;
				} else {
					logger.fatal(
							"Ha ocurrido un error al invocar al servicio. Esta petición no se va a volver a enviar ya que está marcada como no reintentable",
							e);
				}
			}

			logger.debug(handler.getClass().getName() + ": marcando los registros de la BD como enviados");
			handler.marcaComoEnviados(control, registro);

		} else {
			logger.debug("'listPendientes' es nulo o está vacío. No hay datos que enviar por servicio");
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

				} else if (! registroCambiosHandlers.isEmpty()){
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
