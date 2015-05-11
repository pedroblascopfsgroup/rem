package es.pfsgroup.recovery.ext.api.contrato.model;

/**
 * Información sobre los tipos de información adicional añadida a un contrato
 * 
 * @author Diana
 *
 */
public interface EXTDDTipoInfoContratoInfo {
	
	/**
	 * id del tipo de información
	 * @return
	 */
	Long getId();
	
	/**
	 * código del tipo de información
	 * @return
	 */
	String getCodigo();
	
	/**
	 * descripción del tipo de informacion
	 * @return
	 */
	String getDescripcion();
	
	/**
	 * descripción larga del tipo de información
	 * @return
	 */
	String getDescripcionLarga();
	
	/**
	 * Indica si en las búsquedas se permite buscar por ese código
	 * @return
	 */
	Boolean getPermiteBusqueda();
	
}
