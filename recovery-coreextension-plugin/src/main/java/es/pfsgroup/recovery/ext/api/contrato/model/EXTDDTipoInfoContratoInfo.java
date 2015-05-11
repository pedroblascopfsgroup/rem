package es.pfsgroup.recovery.ext.api.contrato.model;

/**
 * Informaci�n sobre los tipos de informaci�n adicional a�adida a un contrato
 * 
 * @author Diana
 *
 */
public interface EXTDDTipoInfoContratoInfo {
	
	/**
	 * id del tipo de informaci�n
	 * @return
	 */
	Long getId();
	
	/**
	 * c�digo del tipo de informaci�n
	 * @return
	 */
	String getCodigo();
	
	/**
	 * descripci�n del tipo de informacion
	 * @return
	 */
	String getDescripcion();
	
	/**
	 * descripci�n larga del tipo de informaci�n
	 * @return
	 */
	String getDescripcionLarga();
	
	/**
	 * Indica si en las b�squedas se permite buscar por ese c�digo
	 * @return
	 */
	Boolean getPermiteBusqueda();
	
}
