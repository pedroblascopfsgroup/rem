package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

/**
 * Este es un DAO que nos permite realizar consultas lanzando SQL's a pelo
 * @author bruno
 *
 */
public interface MSVRawSQLDao {

	/**
	 * Devuelve la cuenta de resultados que devuelve una determinada query
	 * 
	 * @param sqlQuery
	 * @return
	 */
	int getCount(String sqlQuery);
	
	/**
	 * Devuelve el nombre del master schema
	 * @return
	 */
	String getMasterSchema();

	/**
	 * Ejecuta una SQL y devuelve el resultado.
	 * <p>
	 * Como restricci�n la SQL tiene que devolver una �nica fila y una �nica columna con un resultado num�rico que quepa en Integer
	 * </p>
	 * @param sqlValidacion
	 * @return
	 */
	String getExecuteSQL(String sqlValidacion);

	/**
	 * Ejecuta una SQL y devuelve el resultado como objeto[].
	 * 
	 * @param sqlValidacion
	 * @return
	 */
	Object[] getExecuteSQLArray(String sqlValidacion);
}
