package es.capgemini.pfs.batch.revisar.arquetipos.repo.dao;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

/**
 * Dao capaz de ejecutar cualquier SQL contra la BBDD.
 * @author bruno
 *
 */
public interface ArquetiposBatchDao {

	/**
	 * Ejecuta una determinada SELECT y devuelve el resultado.
	 * @param query
	 * @return
	 */
	public List<Map<String, Object>> executeSelect(final String query);
	
	/**
     * @param dataSource the dataSource to set
     */
    public void setDataSource(DataSource dataSource) ;
}
