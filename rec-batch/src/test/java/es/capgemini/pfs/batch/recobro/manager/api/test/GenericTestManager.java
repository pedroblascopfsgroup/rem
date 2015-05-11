package es.capgemini.pfs.batch.recobro.manager.api.test;

/**
 * Interfaz del Manager genérico para ejecutar los procesos de preparación y/o validación de los jobs
 * @author Guillem
 *
 */
public interface GenericTestManager {
	
	/**
	 * Método que permite ejecutar una sql de preparación  y/o validación de los jobs según su tipo
	 * @param tipo
	 * @param sql
	 * @param msg
	 * @param expected
	 * @throws Throwable
	 */
	public void ejecutarSQL(String tipo, String sql, String msg, String expected) throws Throwable;
	
}
