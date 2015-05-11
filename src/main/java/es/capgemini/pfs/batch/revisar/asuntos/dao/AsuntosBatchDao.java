package es.capgemini.pfs.batch.revisar.asuntos.dao;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

/**
 * Dao de asuntos.
 * @author jbosnjak
 *
 */
public interface AsuntosBatchDao {


	/**
	 * Busca todos los asuntos activos.
	 * @return ids de los asuntos
	 */
    List<Map<String, Object>> obtenerAsuntosActivos();

	/**
	 * @param queryBuscarContratosAsunto the queryBuscarContratosAsunto to set
	 */
	void setQueryBuscarContratosAsunto(String queryBuscarContratosAsunto);


	/**
	 * @param dataSource the dataSource to set
	 */
	void setDataSource(DataSource dataSource);
}
