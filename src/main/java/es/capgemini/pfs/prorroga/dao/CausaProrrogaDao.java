package es.capgemini.pfs.prorroga.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.prorroga.model.CausaProrroga;

/**
 * Interfaz dao para las causas prorrogas.
 * @author jbosnjak
 *
 */
public interface CausaProrrogaDao extends AbstractDao<CausaProrroga, Long> {

    /**
     * Busca una CausaProrroga por su cÃ³digo.
     * @param codigo el cÃ³digo
     * @return la causa
     */
    CausaProrroga buscarPorCodigo(String codigo);

    /**
     * Devuelve un listado de causas de prorroga filtrados por su tipo de prorroga.
     * @param codigoTipoProrroga Código del tipo de prorroga
     * @return Listado de causas de prorroga
     */
    List<CausaProrroga> getList(String codigoTipoProrroga);
}
