package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDTendencia;

/**
 * @author Mariano Ruiz
 */
public interface DDTendenciaDao extends AbstractDao<DDTendencia, Long> {

    /**
     * Recupera la tendencia correspondiente al codigo indicado.
     * @param codigo String
     * @return DDTendencia
     */
	DDTendencia findByCodigo(String codigo);
}
