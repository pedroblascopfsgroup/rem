package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDTipoOperador;

/**
 * Dao para los tipos de politicas.
 * @author aesteban
*/
public interface TipoOperadorDao extends AbstractDao<DDTipoOperador, Long>{

    /**
     * Busca el tipo de operador por codigo.
     * @param codigo string;
     * @return DDTipoOperador
     */
    DDTipoOperador findByCodigo(String codigo);
}
