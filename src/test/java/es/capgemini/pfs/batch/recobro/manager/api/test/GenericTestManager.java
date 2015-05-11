package es.capgemini.pfs.batch.recobro.manager.api.test;

/**
 * Interfaz del Manager gen�rico para ejecutar los procesos de preparaci�n y/o validaci�n de los jobs
 * @author Guillem
 *
 */
public interface GenericTestManager {
	
	/**
	 * M�todo que permite ejecutar una sql de preparaci�n  y/o validaci�n de los jobs seg�n su tipo
	 * @param tipo
	 * @param sql
	 * @param msg
	 * @param expected
	 * @throws Throwable
	 */
	public void ejecutarSQL(String tipo, String sql, String msg, String expected) throws Throwable;
	
}
