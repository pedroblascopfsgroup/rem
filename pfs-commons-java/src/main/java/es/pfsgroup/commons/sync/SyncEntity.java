package es.pfsgroup.commons.sync;

public interface SyncEntity {

	/**
	 * Recupera la referencia de sincronización para este objeto.
	 * Esta referencia será única e identificará a un objeto único en todo los sistemas conectados (establece la correspondencia)
	 * 
	 * @return
	 */
	String getReferenciaSincronizacion();
	
	/**
	 * Establece la refencia de sincronización para este objeto.
	 * Esta referencia será única e identificará a un objeto único en todo los sistemas conectados (establece la correspondencia)
	 * 
	 * @param referenciaSincronizacion
	 */
	void setReferenciaSincronizacion(String referenciaSincronizacion);
	
}
