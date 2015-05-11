package es.capgemini.pfs.parametrizacion.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;

/**
 * Dao.
 * @author aesteban
 *
 */
public interface ParametrizacionDao extends AbstractDao<Parametrizacion, Long> {

    /**
     * Busca el parametro que corresponda al nombre indicado.
     * Lanza error de parametrizacion si no existe o hay mas de un parámetro.
     * @param nombre string
     * @return Parametrizacion
     */
    Parametrizacion buscarParametroPorNombre(String nombre);

}
