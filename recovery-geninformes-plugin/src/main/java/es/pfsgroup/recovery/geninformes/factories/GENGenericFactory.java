package es.pfsgroup.recovery.geninformes.factories;


/**
 * @author manuel
 * 
 * Factoría genérica que devuelve objetos de negocio de tipo T.
 *
 * @param <T>
 */
public interface GENGenericFactory<T> {
	

	T getBusinessObject();

}
