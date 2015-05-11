package es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers;

import java.util.List;
import java.util.Map;

import es.pfsgroup.commons.utils.Checks;

/**
 * Clase para gestionar una cache de ViewHandlers. Encapsula un
 * Map<String,Object> en donde el String debe ser la cadena de búsqueda.
 * Mediante esta clase controlaremos si una cache está o no inicializada.
 * 
 * @author bruno
 * 
 */
public class RecoveryViewHandlersCache<T extends RecoveryViewHandler> {
	private Map<String, T> cache;

	private boolean initialized = false;

	/**
	 * Crea un objeto cache, si inicializar, encapsulando un Map
	 * 
	 * @param map
	 *            Objeto que almacenará los datos
	 */
	public RecoveryViewHandlersCache(Map<String, T> map) {
		this.cache = map;
	}

	/**
	 * Nos dice si un objeto está inicializado
	 * 
	 * @return
	 */
	public boolean isInitialized() {
		return this.initialized;
	}

	/**
	 * Devuelve un elemento de la caché.
	 * 
	 * @param searchString
	 *            Cadena de búsqueda.
	 * @return Devuelve NULL si no encuentra ninguno
	 */
	public T get(String searchString) {
		return this.cache.get(searchString);
	}

	/**
	 * Inserta un View Handler en la cache
	 * 
	 * @param searchString
	 *            Cadena de búsqueda
	 * @param viewHandler
	 *            View Handler
	 */
	public void put(String searchString, T viewHandler) {
		if ((!Checks.esNulo(searchString)) && (!Checks.esNulo(viewHandler))) {
			this.cache.put(searchString, viewHandler);
		}
	}

	/**
	 * Inicializa la caché.Debeen pasarse dos colecciones, una de manejadores
	 * genéricos y otra de personalizados. Al finalizar este método la cache
	 * estará marcada como inicializada, aunque las colecciones estén vacías.
	 * 
	 * 
	 * @param genericHandlers
	 * @param customHandlers
	 */
	public synchronized void initializeCache(List<T> genericHandlers, List<? extends T> customHandlers) {
		if (!this.initialized) {
			if (!Checks.estaVacio(customHandlers)) {
				for (T cvh : customHandlers) {
					String s = cvh.getValidString();
					if (!Checks.esNulo(s)) {
						this.put(cvh.getValidString(), cvh);
					}
				}
			}

			if (!Checks.estaVacio(genericHandlers)) {
				for (T gvh : genericHandlers) {
					String s = gvh.getValidString();
					if (!Checks.esNulo(s)) {
						if (Checks.esNulo(this.get(s))) {
							this.put(s, gvh);
						}
					}
				}
			}
			this.initialized = true;
		}
	}
}
