package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;

/**
 * Interfaz para acceso a datos del DDEstadoPolitica.
 * @author Andrés Esteban
 *
 */
public interface DDEstadoPoliticaDao extends AbstractDao<DDEstadoPolitica, Long> {

    /**
     * Recupera el estado correspondiente al codigo indicado.
     * @param codigo String
     * @return DDEstadoPolitica
     */
    DDEstadoPolitica buscarPorCodigo(String codigo);
}
