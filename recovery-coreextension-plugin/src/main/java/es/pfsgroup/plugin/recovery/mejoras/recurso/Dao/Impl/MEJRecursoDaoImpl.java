package es.pfsgroup.plugin.recovery.mejoras.recurso.Dao.Impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.recurso.model.Recurso;
import es.pfsgroup.plugin.recovery.mejoras.recurso.Dao.MEJRecursoDao;

/**
 * poner javadoc FO.
 * @author FO
 *
 */
@Repository("MEJRecursoDao")
public class MEJRecursoDaoImpl extends AbstractEntityDao<Recurso, Long> implements MEJRecursoDao {

	private final Log logger = LogFactory.getLog(getClass());

    /**
     * poner javadoc FO.
     * @param idProcedimiento id de procedimiento
     * @return lista de recursos
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Recurso> getRecursosPorProcedimiento(Long idProcedimiento){
    	List<Recurso> ls = null;
        try {
            ls = getHibernateTemplate().find("from Recurso where procedimiento.id = ? order by RCR_FECHA_RECURSO", new Object[] { idProcedimiento });
        } catch (DataAccessException e) {
        	logger.error(e);
        }
        return ls;
    }
}
