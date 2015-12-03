package es.capgemini.pfs.acuerdo.dao;

import java.util.List;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDTipoAcuerdoDao extends AbstractDao<DDTipoAcuerdo, Long> {

    /**
     * Busca un DDTipoAcuerdo.
     * @param codigo String: el codigo del DDTipoAcuerdo
     * @return DDTipoAcuerdo
     */
    DDTipoAcuerdo buscarPorCodigo(String codigo);
    
    List<DDTipoAcuerdo> buscarTipoAcuerdoPorFiltro(Long ambito, Long ambas);
}
