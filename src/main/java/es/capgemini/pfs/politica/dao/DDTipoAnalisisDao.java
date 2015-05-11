package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDTipoAnalisis;

/**
 * Dao para los tipos de análisis.
 * @author Pablo Müller
*/
public interface DDTipoAnalisisDao extends AbstractDao<DDTipoAnalisis, Long>{

    /**
     * Busca el tipo de Análisis por codigo.
     * @param codigo string;
     * @return TipoObjetivo
     */
	DDTipoAnalisis findByCodigo(String codigo);
}
