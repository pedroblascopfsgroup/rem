package es.capgemini.pfs.contrato.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz para el DAO de DDTipoProducto.
 */

public interface TipoProductoDao extends AbstractDao<DDTipoProducto, Long> {

    /**
     * Recupera un tipo de producto por su código.
     * @param codigo String
     * @return DDTipoProducto
     */
    DDTipoProducto findByCodigo(String codigo);

    /**
     * Retorna la lista de tipos de producto en base a la lista de códigos pasada.
     * @param codigos Set String
     * @return List DDTipoProducto
     */
    List<DDTipoProducto> getTiposProductoByCodigos(Set<String> codigos);
}
