package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDValoracion;

/**
 * Dao para DDValoracion.
 * @author Pablo Müller
*/
public interface DDValoracionDao extends AbstractDao<DDValoracion, Long>{

    /**
     * Busca DDValoracion por codigo.
     * @param codigo string;
     * @return DDValoracion
     */
	DDValoracion findByCodigo(String codigo);
}
