package es.capgemini.pfs.tareaNotificacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * Interfaz dao para los subtipos de tareas.
 * @author pamuller
 *
 */
public interface TipoEntidadDao extends AbstractDao<DDTipoEntidad, Long> {

    /**
     * Busca un TipoEntidad por su código.
     * @param codigoEntidad el código del entidad que se busca.
     * @return el tipo de entidad si existe.
     */
    DDTipoEntidad buscarPorCodigo(String codigoEntidad);

}
