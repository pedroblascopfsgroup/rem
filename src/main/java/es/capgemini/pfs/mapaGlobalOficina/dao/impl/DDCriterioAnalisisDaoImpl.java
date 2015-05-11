package es.capgemini.pfs.mapaGlobalOficina.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.mapaGlobalOficina.dao.DDCriterioAnalisisDao;
import es.capgemini.pfs.mapaGlobalOficina.model.DDCriterioAnalisis;

/**
 * @author marruiz
 */
@Repository("DDCriterioAnalisisDao")
public class DDCriterioAnalisisDaoImpl extends AbstractEntityDao<DDCriterioAnalisis, Long> implements DDCriterioAnalisisDao {

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public DDCriterioAnalisis findByCodigo(String codigo) {
        String hql = "from DDCriterioAnalisis cra where cra.codigo = ? and cra.auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDCriterioAnalisis> criterioAnalisis = getHibernateTemplate().find(hql, new Object[] { codigo });
        if(criterioAnalisis.size()==0) {
            return null;
        } else if(criterioAnalisis.size()==1) {
            return criterioAnalisis.get(0);
        } else {
            throw new BusinessOperationException("DDCriterioAnalisis.error.duplicado");
        }
	}
}
