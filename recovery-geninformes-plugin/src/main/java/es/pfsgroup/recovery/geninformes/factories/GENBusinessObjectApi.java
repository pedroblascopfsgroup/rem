package es.pfsgroup.recovery.geninformes.factories;

/**
 * Objeto de negocio genérico.
 * Utilizado para ser devuelto por una factoría que utilice alguno de sus métodos para seleccionarlo de
 * entre todas las implementaciones posibles.
 * 
 * @author manuel
 *
 */
public interface GENBusinessObjectApi {
	
	/**
	 * Devuleve la prioridad del objeto.
	 * Normalmente la primera implementación tendrá el valor 0 y se irá subiendo con siguientes implementaciones. 
	 * @return int
	 */
	int getPrioridad();

}
