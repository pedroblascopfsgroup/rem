package es.capgemini.pfs.politica.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDTipoGestion;

/**
 * Dao para los tipos de gestiones realizadas.
 * @author Pablo Müller
*/
public interface DDTipoGestionDao extends AbstractDao<DDTipoGestion, Long>{

    /**
     * Busca el tipo de gestión realizada por codigo.
     * @param codigo String
     * @return DDTipoGestion
     */
	DDTipoGestion findByCodigo(String codigo);

	/**
	 * Busca los tipos de gestión realizada por sus codigos en la lista.
	 * @param codigos Set String
	 * @return List DDTipoGestion
	 */
	List<DDTipoGestion> findByCodigos(Set<String> codigos);
}
