package es.capgemini.pfs.acuerdo.dao;

import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 *
 */
public interface DDSubtipoSolucionAmistosaAcuerdoDao extends AbstractDao<DDSubtipoSolucionAmistosaAcuerdo, Long> {

    /**
     * Busca un DDSubtipoSolucionAmistosaAcuerdo.
     * @param codigo String: el codigo del DDSubtipoSolucionAmistosaAcuerdo
     * @return DDSubtipoSolucionAmistosaAcuerdo
     */
    DDSubtipoSolucionAmistosaAcuerdo buscarPorCodigo(String codigo);
}
