package es.capgemini.pfs.subfase.dao.impl;


import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.subfase.dao.FaseDao;
import es.capgemini.pfs.subfase.model.DDFase;

/**
 * Clase que implementa los métodos de la interfaz FaseDao.
 *
 */
@Repository("FaseDao")
public class FaseDaoImpl extends AbstractEntityDao<DDFase, Long> implements FaseDao {

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	public DDFase getByCodigo(String codigo) {
        String hql = "from DDFase fmg where fmg.codigo = ? and fmg.auditoria." + Auditoria.UNDELETED_RESTICTION;
        List<DDFase> fmg = getHibernateTemplate().find(hql, new Object[] { codigo });
        if(fmg.size()==0) {
            return null;
        } else if(fmg.size()==1) {
            return fmg.get(0);
        } else {
            throw new BusinessOperationException("fase.error.duplicado");
        }
	}

}
