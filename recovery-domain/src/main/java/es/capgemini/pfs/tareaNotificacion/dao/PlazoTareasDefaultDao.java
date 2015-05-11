package es.capgemini.pfs.tareaNotificacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;

/**
 * Interfaz dao para los PlazoTareasDefault.
 * @author pamuller
 *
 */
public interface PlazoTareasDefaultDao extends AbstractDao<PlazoTareasDefault, Long> {

    /**
     * Busca un PlazoTareasDefault por su código.
     * @param codigo el código del PlazoTareasDefault que se busca.
     * @return el PlazoTareasDefault.
     */
    PlazoTareasDefault buscarPorCodigo(String codigo);

}
