package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.ActuacionesRealizadasAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author marruiz
 *
 */
@Repository("ActuacionesRealizadasAcuerdoDao")
public class ActuacionesRealizadasAcuerdoDaoImpl extends AbstractEntityDao<ActuacionesRealizadasAcuerdo, Long>
        implements ActuacionesRealizadasAcuerdoDao {

    /**
     * Busca todas las ActuacionesRealizadasAcuerdo del Acuerdo.
     * @param idAcuerdo Long
     * @return List ActuacionesRealizadasAcuerdo
     */
    @SuppressWarnings("unchecked")
    public List<ActuacionesRealizadasAcuerdo> buscarPorAcuerdo(Long idAcuerdo) {
        String hql = "select actuacion from ActuacionesRealizadasAcuerdo actuacion, Acuerdo acuerdo "
                + "where acuerdo.actuacionesRealizadas = actuacion and acuerdo.id = ?";
        return getHibernateTemplate().find(hql, idAcuerdo);
    }

	@SuppressWarnings("unchecked")
	@Override
	public ActuacionesRealizadasAcuerdo getByGuid(String guid) {
		
		ActuacionesRealizadasAcuerdo actuacionesRealizadasAcuerdo = null;
		
		DetachedCriteria crit = DetachedCriteria.forClass(ActuacionesRealizadasAcuerdo.class);
		crit.add(Restrictions.eq("guid", guid));
        crit.add(Restrictions.eq("auditoria.borrado", false));
        
        List<ActuacionesRealizadasAcuerdo> listado = getHibernateTemplate().findByCriteria(crit);
        if(listado != null && listado.size() > 0) {
        	actuacionesRealizadasAcuerdo = listado.get(0);
        }
        
        return actuacionesRealizadasAcuerdo;
	}
}
