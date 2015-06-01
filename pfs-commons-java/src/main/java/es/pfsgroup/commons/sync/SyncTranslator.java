package es.pfsgroup.commons.sync;

public interface SyncTranslator {

	/**
	 * Convierte un objeto en un string con un determinado formato.
	 * @param message
	 * @return
	 */
	String serialize(Object message);
	
	/**
	 * Convierte en un objeto de un determinado tipo un objecto
	 * @param message
	 * @param type 
	 * @return
	 */
	Object deserialize(String formattedMsg, Class<?> type);
	
}
