package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica;

/**
 * Interfaz para acceso a datos del DDEstadoItinerarioPolitica.
 * @author Andrés Esteban
 *
 */
public interface DDEstadoItinerarioPoliticaDao extends AbstractDao<DDEstadoItinerarioPolitica, Long> {

    /**
     * Recupera el estadoItinerario correspondiente al codigo indicado.
     * @param codigo String
     * @return DDEstadoItinerarioPolitica
     */
    DDEstadoItinerarioPolitica buscarPorCodigo(String codigo);
}
