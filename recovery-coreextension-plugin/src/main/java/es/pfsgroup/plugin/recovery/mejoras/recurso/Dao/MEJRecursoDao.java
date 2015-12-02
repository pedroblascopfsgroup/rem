package es.pfsgroup.plugin.recovery.mejoras.recurso.Dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.recurso.model.Recurso;

/**
 * poner javadoc FO.
 * @author FO.
 *
 */
public interface MEJRecursoDao extends AbstractDao<Recurso, Long> {
    /**
     * poner javadoc FO.
     * @param idProcedimiento id
     * @return recurso
     */
    List<Recurso> getRecursosPorProcedimiento(Long idProcedimiento);
}
