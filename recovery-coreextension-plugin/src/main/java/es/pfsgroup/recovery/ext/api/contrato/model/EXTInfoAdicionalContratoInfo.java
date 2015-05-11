package es.pfsgroup.recovery.ext.api.contrato.model;

import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Almacena la informaci�n adicional del contrato
 * @author Diana
 *
 */
public interface EXTInfoAdicionalContratoInfo {
	
	/**
	 * id de la informaci�n adicional
	 * @return
	 */
	Long getId();
	
	/**
	 * tipo de informaci�n adicional
	 * @return
	 */
	EXTDDTipoInfoContratoInfo getTipoInfoContrato();
	
	/**
	 * contrato asociado con esa informacion adicional
	 * @return
	 */
	Contrato getContrato();
	
	/**
	 * valor de la informaci�n adicional
	 * @return
	 */
	String getValue();

}
