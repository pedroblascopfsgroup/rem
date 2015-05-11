package es.capgemini.pfs.titulo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.titulo.model.DDTipoTitulo;

/**
 * Interfase que contiene los métodos de acceso a la entidad DDTipoTitulo.
 *
 */
public interface DDTipoTituloDao extends AbstractDao<DDTipoTitulo, Long> {

    /**
     * Retorna el tipo de título para un código determinado.
     * @param codigo String
     * @return DDTipoTitulo
     */
    DDTipoTitulo obtenerTipoTitulo(String codigo);

    /**
     * Retorna el tipo de título para un tipo general determinado.
     * @param codigoTipoDocGen long
     * @return Lista DDTipoTitulo
     */
    List<DDTipoTitulo> buscarPorTipoGeneral(String codigoTipoDocGen);
}
