package es.pfsgroup.commons.sync;

public interface SyncFramework {

	/**
	 * Recupera una factory de mensajes para crear mensajes, enviarlos y procesarlos.
	 * 
	 * @param key
	 * @return
	 */
	SyncMsgFactory<?> get(String key);
	
	/**
	 * Inicia la escucha por todos los canales
	 */
	void listen();
	
}
