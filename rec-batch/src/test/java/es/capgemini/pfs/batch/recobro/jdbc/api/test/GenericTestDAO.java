package es.capgemini.pfs.batch.recobro.jdbc.api.test;

/**
 * Interfaz del DAO gen�rico que lanzar� las SQL para el testing
 * @author Guillem
 *
 */
public interface GenericTestDAO {

	/**
	 * Ejecuta una sql de carga para la preparaci�n del entorno de test
	 * Puede ejecutar sql de tipo INSERT y UPDATE
	 * @param sql
	 */
	public Integer ejecutarUPDATESQLCarga(String sql, String msg) throws Throwable;
		
	/**
	 * Ejecuta una sql de tipo CREATE para la preparaci�n del entorno de test
	 * @param sql
	 * @param msg
	 */
	public void ejecutarCREATESQLCarga(String sql, String msg) throws Throwable;
	
	/**
	 * Ejecuta una sql de tipo SELECT COUNT para la validaci�n del entorno de test
	 * @param sql
	 * @param msg
	 */
	public Integer ejecutarCOUNTSQLValidacion(String sql, String msg) throws Throwable;	

}
