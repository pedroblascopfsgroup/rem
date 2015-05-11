package es.capgemini.pfs.asunto.dao;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz para manejar el acceso a datos de los procedimientos.
 * @author pamuller
 *
 */
public interface TipoReclamacionDao extends AbstractDao<DDTipoReclamacion, Long> {

    /**
     * Devuelve un TipoReclamacion por su código.
     * @param codigo el codigo del TipoReclamacion
     * @return el TipoReclamacion.
     */
    DDTipoReclamacion getByCodigo(String codigo);
}
