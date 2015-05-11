package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;


/**
 * Datos a considerar sobre el Bien
 * @author bruno
 *
 */
public interface NMBDDTipoBienContratoInfo {

	/**
	 * Superficie total del Bien
	 * @return
	 */
	Long getId();
	
	/**
	 * Superficie total del Bien
	 * @return
	 */
	String getCodigo();
	
	/**
	 * Superficie construida del Bien
	 * @return
	 */
	String getDescripcion();
	
	/**
	 * Superficie construida del Bien
	 * @return
	 */
	String getDescripcionLarga();
	
}
