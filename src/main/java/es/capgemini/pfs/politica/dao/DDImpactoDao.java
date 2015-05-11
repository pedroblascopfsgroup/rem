package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDImpacto;

/**
 * Dao para DDImpacto.
 * @author Pablo Müller
*/
public interface DDImpactoDao extends AbstractDao<DDImpacto, Long>{

    /**
     * Busca DDImpacto por codigo.
     * @param codigo string;
     * @return DDImpacto
     */
	DDImpacto findByCodigo(String codigo);
}
