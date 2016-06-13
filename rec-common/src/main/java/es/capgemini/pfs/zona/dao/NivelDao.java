package es.capgemini.pfs.zona.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;

/**
 * Interfaz dao para los niveles.
 * @author pamuller
 *
 */
public interface NivelDao extends AbstractDao<Nivel, Long> {

	/**
     * Obtiene el código de un nivel por descripcion.
     *
     * @param descripcion del nivel
     * @return codigo del nivel
     */
    Integer buscarCodigoNivelPorDescripcion(String descripcion);
	
}
