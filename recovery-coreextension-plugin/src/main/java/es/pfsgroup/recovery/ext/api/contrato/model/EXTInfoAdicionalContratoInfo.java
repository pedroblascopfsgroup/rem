package es.pfsgroup.recovery.ext.api.contrato.model;

import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Almacena la información adicional del contrato
 * @author Diana
 *
 */
public interface EXTInfoAdicionalContratoInfo {
	
	/**
	 * id de la información adicional
	 * @return
	 */
	Long getId();
	
	/**
	 * tipo de información adicional
	 * @return
	 */
	EXTDDTipoInfoContratoInfo getTipoInfoContrato();
	
	/**
	 * contrato asociado con esa informacion adicional
	 * @return
	 */
	Contrato getContrato();
	
	/**
	 * valor de la información adicional
	 * @return
	 */
	String getValue();

}
