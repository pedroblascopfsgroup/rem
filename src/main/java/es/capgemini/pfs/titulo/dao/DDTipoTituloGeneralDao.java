package es.capgemini.pfs.titulo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.titulo.model.DDTipoTituloGeneral;

/**
 * Interfase que contiene los métodos de acceso a la entidad DDTipoTituloGeneral.
 *
 */
public interface DDTipoTituloGeneralDao extends AbstractDao<DDTipoTituloGeneral, Long> {

    /**
     * Retorna el tipo de título general para un código determinado.
     * @param codigo String
     * @return DDTipoTitulo
     */
    DDTipoTituloGeneral obtenerTipoTitulo(String codigo);
}
