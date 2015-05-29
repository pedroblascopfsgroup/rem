package es.pfsgroup.commons.sync;

public interface SyncMsgFactory<T> {

	/**
	 * Crea una instancia de mensaje
	 * @return
	 */
	T createMessage();
	
	/**
	 * ID de esta factory y de los mesajes que genera
	 * @return
	 */
	String getID();
	
	/**
	 * Envia un mensaje a través de los conectores.
	 * 
	 * @param message
	 */
	SyncMsgConnector send(T message);
	
	/**
	 * Procesa un mensaje
	 * 
	 * @param message
	 */
	void processMessage(SyncMsgConnector message);
	
}