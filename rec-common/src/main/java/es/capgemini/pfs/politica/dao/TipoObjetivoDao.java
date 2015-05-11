package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDTipoObjetivo;

/**
 * Dao para los tipos de politicas.
 * @author aesteban
*/
public interface TipoObjetivoDao extends AbstractDao<DDTipoObjetivo, Long>{

    /**
     * Busca el tipo de objetivo por codigo.
     * @param codigo string;
     * @return TipoObjetivo
     */
    DDTipoObjetivo findByCodigo(String codigo);
}
