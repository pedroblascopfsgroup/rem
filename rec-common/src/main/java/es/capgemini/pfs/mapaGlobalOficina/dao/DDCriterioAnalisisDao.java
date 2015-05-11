package es.capgemini.pfs.mapaGlobalOficina.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.mapaGlobalOficina.model.DDCriterioAnalisis;

/**
 * @author marruiz
 */
public interface DDCriterioAnalisisDao extends AbstractDao<DDCriterioAnalisis, Long> {

    /**
     * @param codigo String
     * @return DDCriterioAnalisis
     */
    DDCriterioAnalisis findByCodigo(String codigo);
}
