package es.capgemini.pfs.asunto.dao;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz para manejar el acceso a datos de los procedimientos.
 * @author pamuller
 *
 */
public interface TipoActuacionDao extends AbstractDao<DDTipoActuacion, Long> {

    /**
     * Devuelve un tipo de acutaci�n por su código.
     * @param codigo el codigo del tipo de actuci�n
     * @return el tipo de actuaci�n.
     */
    DDTipoActuacion getByCodigo(String codigo);

}
