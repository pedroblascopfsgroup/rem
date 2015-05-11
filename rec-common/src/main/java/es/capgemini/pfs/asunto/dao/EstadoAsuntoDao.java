package es.capgemini.pfs.asunto.dao;

import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Definici�n de la interfaz para el acceso a datos de los Estados de un Asunto.
 * @author pamuller
 *
 */
public interface EstadoAsuntoDao extends AbstractDao<DDEstadoAsunto, Long> {

    /**
     * Busca un estado de Asunto por su código.
     * @param codigo el codigo del Estado del Asunto,
     * @return el Estado del Asunto.
     */
    DDEstadoAsunto buscarPorCodigo(String codigo);

}
