package es.pfsgroup.commons.sync;

import java.util.List;

public interface SyncConnector {
	
	/**
	 * Envía un mensaje por el canal conectado
	 * 
	 * @param message
	 */
	void send(SyncMsgConnector message);

	/**
	 * Envía una lista de mensajes por el canal conectado
	 * 
	 * @param messageList
	 */
	void send(List<SyncMsgConnector> messageList);	
	
	/**
	 * Recupera los mensajes del canal conectado.
	 * 
	 * @return
	 */
	List<SyncMsgConnector> receive();
	
	
}
