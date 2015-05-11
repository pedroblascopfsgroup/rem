package es.pfsgroup.recovery.geninformes.factories;

/**
 * Objeto de negocio gen�rico.
 * Utilizado para ser devuelto por una factor�a que utilice alguno de sus m�todos para seleccionarlo de
 * entre todas las implementaciones posibles.
 * 
 * @author manuel
 *
 */
public interface GENBusinessObjectApi {
	
	/**
	 * Devuleve la prioridad del objeto.
	 * Normalmente la primera implementaci�n tendr� el valor 0 y se ir� subiendo con siguientes implementaciones. 
	 * @return int
	 */
	int getPrioridad();

}
