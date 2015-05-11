package es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers;

import java.util.List;
import java.util.Map;

import es.pfsgroup.commons.utils.Checks;


/**
 * Esta clase debe extenderse en una factor�a que quiera uzar el patr�n gen�rico de sobreescritura de ViewHandlers
 * <p>
 * Seg�n este patr�n existir�n dos conjuntos de manejadores:
 * <dl>
 * <dt><strong>Manejadores gen�ricos</strong></dt>
 * <dd>Son aquellos que se proporcionan por defecto. Estos se distinguir�n por implementar una interfaz gen�rica</dd>
 * <dt><strong>Manejadores personalizados</strong></dt>
 * <dd>Se usan cuando, para un determinado entorno, se necesita que un
 * determinado VH se comporte de distinto modo. Estos implementar�n una interfaz particular que extender� la gen�rica.</dd>
 * <dl>
 * 
 * Ambas interfaces, la gen�rica y la particular deber�n extender de {@link RecoveryViewHandler}
 * 
 * El algoritmo para elegir uno u otro ser�
 * <ol>
 * <li>Se buscar� el VH en la lista de manejadores personalizados</li>
 * <li>Si no se encuentra se buscar� en la lista de gen�ricos</li>
 * <li>Si no se encuentra ninguno se devolver� null</li>
 * </ol>
 * 
 * @author bruno
 * @param <GenericHandler> Interfaz Gen�rica para los ViewHandlers
 * @param <CustomHandler> Interfaz particular para los ViewHandlers personalizados para un entorno.
 */
public abstract class ViewHandlersOverrideDefaultPattern<GenericHandler extends RecoveryViewHandler, CustomHandler extends GenericHandler> {

	/**
	 * Colecci�n de manejadores gen�ricos. Este m�todo debe implementarse en cada factor�a
	 * @return
	 */
	protected abstract List<GenericHandler> getGenericHandlerCollection();
	
	/**
	 * Colecci�n de manejadores personalizados. Este m�todo debe implementarse en cada factor�a.
	 * @return
	 */
	protected abstract List<CustomHandler> getCustomHandlerCollection();

	/**
	 * Busca el ViewHandler correrspondiente a una cadena de b�squeda.
	 * <p>Devolver� un manejador cuyo m�todo isValid(String) devuelva <b>true</b>.
	 * <p>Este m�todo acepta una cach� para mejorar el rendimiento
	 * @param searchString Cadena de b�squeda
	 * @param cache Cache de ViewHandlers. La cache debe crearse en cada factor�a.
	 * 
	 * @return
	 */
	protected GenericHandler getGetHandlerWithCacheSupport(String searchString, RecoveryViewHandlersCache<GenericHandler> cache) {
		if (Checks.esNulo(searchString)) {
			//throw new IllegalArgumentException("subtipoTarea no puede ser NULL");
			return null;
		}
		
		if (Checks.esNulo(cache)) {
			throw new IllegalArgumentException("cache no puede ser NULL");
		}
		
		if (!cache.isInitialized()){
			cache.initializeCache(this.getGenericHandlerCollection(), this.getCustomHandlerCollection());
		}
		
		return cache.get(searchString);

	}

}
