package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDEstadoObjetivo;

/**
 * @author Mariano Ruiz
 */
public interface DDEstadoObjetivoDao extends AbstractDao<DDEstadoObjetivo,Long> {

	/**
	 * Busca el DD por su código.
	 * @param codigo String
	 * @return DDEstadoObjetivo
	 */
	DDEstadoObjetivo findByCodigo(String codigo);
}
