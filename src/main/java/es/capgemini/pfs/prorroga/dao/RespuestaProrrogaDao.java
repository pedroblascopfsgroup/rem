package es.capgemini.pfs.prorroga.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.prorroga.model.RespuestaProrroga;

/**
 * Interfaz dao para las respuesta prorrogas.
 * @author jbosnjak
 *
 */
public interface RespuestaProrrogaDao extends AbstractDao<RespuestaProrroga, Long> {

    /**
     * Busca una RespuestaProrroga por su cÃ³digo.
     * @param codigo el cÃ³digo
     * @return la causa
     */
    RespuestaProrroga buscarPorCodigo(String codigo);

    /**
     * Devuelve un listado de respuestas de prorroga filtrados por su tipo de prorroga
     * @param codigoTipoProrroga Código del tipo de prorroga
     * @return Listado de respuestas de prorroga
     */
    List<RespuestaProrroga> getList(String codigoTipoProrroga);
}
