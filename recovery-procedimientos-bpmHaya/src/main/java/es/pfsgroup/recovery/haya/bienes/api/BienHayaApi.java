package es.pfsgroup.recovery.haya.bienes.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface BienHayaApi {
	public static final String SOLICITAR_TASACION = "plugin.haya.bienes.api.solicitarTasacion";
	
	/**
	 * 
	 * @param idBien Identificador del bien
	 * 
	 * Método para solicitar la tasación de un bien
	 * 
	 * */
	@BusinessOperationDefinition(SOLICITAR_TASACION)
	public void solicitarTasacion(Long idBien, Long cuenta, String persona, Long telefono, String observaciones);
}
