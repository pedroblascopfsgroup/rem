package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDTipoPolitica;

/**
 * Interfaz para acceso a datos del DDTipoPolitica.
 * @author Andrés Esteban
 *
 */
public interface DDTipoPoliticaDao extends AbstractDao<DDTipoPolitica, Long> {

    /**
     * Recupera el TipoPolitica correspondiente al codigo indicado.
     * @param codigo String
     * @return DDTipoPolitica
     */
    DDTipoPolitica buscarPorCodigo(String codigo);

    /**
     * Recupera el TipoPolitica asociado a la politica de la entidad.
     * @param codigoPoliticaEntidad String
     * @return DDTipoPolitica
     */
    DDTipoPolitica buscarTipoPoliticaAsociadaAEntidad(String codigoPoliticaEntidad);
}
