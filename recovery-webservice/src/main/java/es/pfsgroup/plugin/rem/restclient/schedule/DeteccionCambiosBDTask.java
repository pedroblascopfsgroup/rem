package es.pfsgroup.plugin.rem.restclient.schedule;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;

import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;

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

	/**
	 * Inicia la detección de cambios en BD.
	 */
	public void detectaCambios() {
		if (running){
			logger.warn("El detector de cambios en BD ya se está ejecutando");
			return;
		}
		running = true;
		logger.info("[inicio] Detección de cambios en BD y envío de las modificaciones a WEBCOM mediante REST");
		try {
			if ((registroCambiosHandlers != null) && (!registroCambiosHandlers.isEmpty())) {
				for (DetectorCambiosBD handler : registroCambiosHandlers) {

					logger.debug(handler.getClass().getName() + ": obtenemos los cambios de la BD");
					Class control = handler.getDtoClass();
					List listPendientes = handler.listPendientes(control);

					if ((listPendientes != null) && (!listPendientes.isEmpty())) {
						logger.debug(handler.getClass().getName() + ": invocando al servicio REST");
						handler.invocaServicio(listPendientes);

						logger.debug(handler.getClass().getName() + ": marcando los registros de la BD como enviados");
						handler.marcaComoEnviados(control);

					} else {
						logger.debug("'listPendientes' es nulo o está vacío. No hay datos que enviar por servicio");
					}
				}
			} else {
				logger.warn("El registro de cambios en BD aún no está disponible");
			}
		} finally {
			running = false;
			logger.info("[fin] Detección de cambios en BD y envío de las modificaciones a WEBCOM mediante REST");
		}

	}

	/**
	 * Este método puebla la lista de detectores de cambios una vez el contexto
	 * de Spring ya se encuentra inicializado.
	 */
	@Override
	public void onApplicationEvent(ApplicationEvent event) {
		if (registroCambiosHandlers == null) {
			registroCambiosHandlers = new ArrayList<DetectorCambiosBD>();
		}

		if (registroCambiosHandlers.isEmpty()) {
			if (event instanceof ContextRefreshedEvent) {
				ApplicationContext applicationContext = ((ContextRefreshedEvent) event).getApplicationContext();
				String[] beanNames = applicationContext.getBeanNamesForType(DetectorCambiosBD.class);
				if ((beanNames != null) && (beanNames.length >= 1)) {
					DetectorCambiosBD handler = (DetectorCambiosBD) applicationContext.getBean(beanNames[0]);
					this.addRegistroCambiosBDHandler(handler);
				}

			}
		}

	}

}
