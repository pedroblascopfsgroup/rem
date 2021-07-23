package es.pfsgroup.framework.paradise.bulkUpload.bvfactory;

import java.util.List;
import java.util.Map;

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
	 * Como restricción la SQL tiene que devolver una única fila y una única columna con un resultado numérico que quepa en Integer
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

	/**
	 * Ejecuta una SQL y devuelve el resultado como List de objetos.
	 *
	 * @param sqlValidacion
	 * @return
	 */
	List<Object> getExecuteSQLList(String sqlValidacion);
	
	void addParams(Map<String,Object> hashMap);
}
