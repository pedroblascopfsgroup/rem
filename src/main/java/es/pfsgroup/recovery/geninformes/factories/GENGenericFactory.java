package es.pfsgroup.recovery.geninformes.factories;


/**
 * @author manuel
 * 
 * Factor�a gen�rica que devuelve objetos de negocio de tipo T.
 *
 * @param <T>
 */
public interface GENGenericFactory<T> {
	

	T getBusinessObject();

}
