package es.pfsgroup.sidhi.api;

public interface SIDHIIterListener {

	/**
	 * Crea un iter procesal a partir de un prc_id y de un expediente_externo_id
	 * @param idProcedimiento, idExepedienteExterno
	 * @author sergio
	 */
	
	void createIterProcesal (Long idProcedimiento, String idExpedienteExterno);
	
}
