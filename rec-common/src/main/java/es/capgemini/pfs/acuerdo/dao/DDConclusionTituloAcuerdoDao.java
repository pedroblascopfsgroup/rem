package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDConclusionTituloAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDConclusionTituloAcuerdoDao extends AbstractDao<DDConclusionTituloAcuerdo, Long> {

    /**
     * Busca un DDConclusionTituloAcuerdo.
     * @param codigo String: el codigo del DDConclusionTituloAcuerdo
     * @return DDConclusionTituloAcuerdo
     */
    DDConclusionTituloAcuerdo buscarPorCodigo(String codigo);
}
