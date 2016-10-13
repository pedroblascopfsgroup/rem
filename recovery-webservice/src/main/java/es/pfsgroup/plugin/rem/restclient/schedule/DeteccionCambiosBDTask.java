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
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomStock;
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

	/*
	 * Esa lista se puebla una vez terminado de cargar el contexto de Spring.
	 * Esto se hace capturando el evento ContextRefreshedEvent. Ver el método
	 * onApplicationEvent(ApplicationEvent event)
	 */
	private List<DetectorCambiosBD> registroCambiosHandlers = new ArrayList<DetectorCambiosBD>();

	/**
	 * Este método añade un nuevo handler para gestionar cambios de BD. Este
	 * método es público para permitir realizar esta operación en los tests.
	 * 
	 * @param handler
	 */
	public void addRegistroCambiosBDHandler(DetectorCambiosBD handler) {
		if (handler != null) {
			logger.debug("Añadiendo un nuevo handler para detectar cambios en BD: " + handler.getClass());
			this.registroCambiosHandlers.add(handler);
		}
	}

	public void enviaInformacionCompleta(DetectorCambiosBD handler) {
		if (handler == null) {
			throw new IllegalArgumentException("'handler' no puede ser NULL");
		}

		if (running) {
			logger.debug("Este proceso está bloqueado por otro hilo de ejecución. Esperando a que finalice");

			int times = 0;
			while (running && (times < 6)) {
				try {
					Thread.sleep(10000);
				} catch (InterruptedException e) {
					logger.warn("Se ha abortado la espera");
				}
				times++;
			}
		}

		Class control = handler.getDtoClass();

		if (running) {
			logger.fatal("Ha cadudado el tiempo de espera y el proceso aún está bloqueado");
			throw new RuntimeException("Ha cadudado el tiempo de espera y el proceso aún está bloqueado");
		}
		synchronized (this) {
			running = true;
			this.notifyAll();
		}

		logger.info("[inicio] Envío de información completa a WEBCOM mediante REST");
		try {

			logger.debug(handler.getClass().getName() + ": obtenemos toda la información de la  BD");
			List listPendientes = handler.listDatosCompletos(control);

			ejecutaTarea(handler, listPendientes, control);

		} finally {
			running = false;
			logger.info("[fin] Envío de información completa a WEBCOM mediante REST");
		}
	}

	/**
	 * Inicia la detección de cambios en BD.
	 * 
	 * @param class1
	 */
	public void detectaCambios() {
		if (running) {
			logger.warn("El detector de cambios en BD ya se está ejecutando");
			return;
		}
		synchronized (this) {
			running = true;
			this.notifyAll();
		}

		logger.info("[inicio] Detección de cambios en BD  WEBCOM mediante REST");
		try {
			if ((registroCambiosHandlers != null) && (!registroCambiosHandlers.isEmpty())) {
				for (DetectorCambiosBD handler : registroCambiosHandlers) {

					logger.debug(handler.getClass().getName() + ": obtenemos los cambios de la BD");
					Class control = handler.getDtoClass();
					List listPendientes = handler.listPendientes(control);

					ejecutaTarea(handler, listPendientes, control);

				}
			} else {
				logger.warn("El registro de cambios en BD aún no está disponible");
			}
		} finally {
			running = false;
			logger.info("[fin] Detección de cambios en BD  WEBCOM mediante REST");
		}

	}

	public void ejecutaTarea(DetectorCambiosBD handler, List listPendientes, Class control) {

		if ((listPendientes != null) && (!listPendientes.isEmpty())) {
			logger.debug(handler.getClass().getName() + ": invocando al servicio REST");
			try {
				handler.invocaServicio(listPendientes);
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
			handler.marcaComoEnviados(control);

		} else {
			logger.debug("'listPendientes' es nulo o está vacío. No hay datos que enviar por servicio");
		}
	}

	/**
	 * Este método puebla la lista de detectores de cambios una vez el contexto
	 * de Spring ya se encuentra inicializado.
	 */
	@Override
	public void onApplicationEvent(ApplicationEvent event) {
		if (event instanceof ContextRefreshedEvent) {
			if (registroCambiosHandlers == null) {
				registroCambiosHandlers = new ArrayList<DetectorCambiosBD>();
			}

			if (registroCambiosHandlers.isEmpty()) {
				ApplicationContext applicationContext = ((ContextRefreshedEvent) event).getApplicationContext();
				String[] beanNames = applicationContext.getBeanNamesForType(DetectorCambiosBD.class);
				if ((beanNames != null) && (beanNames.length >= 1)) {
					for (String name : beanNames) {
						DetectorCambiosBD handler = (DetectorCambiosBD) applicationContext.getBean(name);
						this.addRegistroCambiosBDHandler(handler);
					}
				}

			}
		} // end check event

	}

}
