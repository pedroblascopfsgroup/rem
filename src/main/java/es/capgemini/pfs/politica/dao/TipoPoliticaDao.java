package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDTipoPolitica;

/**
 * Dao para los tipos de politicas.
 * @author aesteban
*/
public interface TipoPoliticaDao extends AbstractDao<DDTipoPolitica, Long>{

    /**
     * Busca el tipo de politica por codigo.
     * @param codigo string;
     * @return TipoPolitica
     */
    DDTipoPolitica findByCodigo(String codigo);
}
