package es.pfsgroup.plugin.recovery.mejoras.web.tareas;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers.RecoveryViewHandlersCache;
import es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers.ViewHandlersOverrideDefaultPattern;

/**
 * Factor�a de ViewHandlers para los Buzones de Tareas por defecto.
 * <p>
 * Esta clase se encarga de localizar y devolver los manejadores para abrir
 * tareas.
 * 
 * @author bruno
 * 
 */
@Component
public class BuzonTareasViewHandlerFactoryImpl extends ViewHandlersOverrideDefaultPattern<BuzonTareasViewHandler, BuzonTareasCustomViewHandler> implements BuzonTareasViewHandlerFactory {

	/**
	 * Tabla de manejadores seg�n subtipo de tarea. Esta tabla se usar� para
	 * evitar un bucle a trav�s de las colecciones y de este modo obtenerlos m�s
	 * r�pidamente. Esa tabla funciona como una cach� y se va rellenando a
	 * medida que se van solicitando los handlers.
	 */
	private static HashMap<String, BuzonTareasViewHandler> viewHandlersBySubtipoTarea = new HashMap<String, BuzonTareasViewHandler>();
	
	private static RecoveryViewHandlersCache<BuzonTareasViewHandler> cacheBySubtipoTarea = new RecoveryViewHandlersCache<BuzonTareasViewHandler>(viewHandlersBySubtipoTarea);  

	@Autowired(required = false)
	private List<BuzonTareasViewHandler> genericViewHandlers;

	@Autowired(required = false)
	private List<BuzonTareasCustomViewHandler> customViewHandlers;

	@Override
	protected List<BuzonTareasViewHandler> getGenericHandlerCollection() {
		return genericViewHandlers;
	}

	@Override
	protected List<BuzonTareasCustomViewHandler> getCustomHandlerCollection() {
		return customViewHandlers;
	}
	
	@Override
	public BuzonTareasViewHandler getHandlerForSubtipoTarea(String subtipoTarea) {
		return getGetHandlerWithCacheSupport(subtipoTarea, cacheBySubtipoTarea);
	}

}
