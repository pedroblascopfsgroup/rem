package es.pfsgroup.recovery.recobroCommon.esquema.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroCarteraEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;

@Repository("RecobroCarteraEsquemaDao")
public class RecobroCarteraEsquemaDaoImpl extends AbstractEntityDao<RecobroCarteraEsquema, Long> implements RecobroCarteraEsquemaDao{

	
	@Override
	public void reorganizaPrioridades(Long idEsquema, Long id, int prioridad, int prioridadAnt) {
		
		if (prioridadAnt==-1) {
			prioridadAnt = getMaxPrioridad(idEsquema)+1;
		}
		
	    String sql = "";
		
	    if (prioridad>prioridadAnt) { 
			sql = "update rcf_esc_esquema_carteras rcf set rcf.rcf_esc_prioridad = rcf.rcf_esc_prioridad -1 " +
				" where rcf.rcf_esq_id  = " + idEsquema +
				" and rcf.rcf_esc_prioridad >= "+prioridadAnt+" and rcf.rcf_esc_prioridad <= "+ prioridad + " and rcf.rcf_esc_id <> "+id+" and rcf.BORRADO <> 1";
	    } else {
	    	sql = "update rcf_esc_esquema_carteras rcf set rcf.rcf_esc_prioridad = rcf.rcf_esc_prioridad +1 " +
					" where rcf.rcf_esq_id  = " + idEsquema +
					" and rcf.rcf_esc_prioridad >= "+prioridad+" and rcf.rcf_esc_prioridad <= "+ prioridadAnt + " and rcf.rcf_esc_id <> "+id+" and rcf.BORRADO <> 1";
	    	
	    }

		Session sesion = getSession();

		try {
			sesion.createSQLQuery(sql).executeUpdate();
		} finally {
			releaseSession(sesion);
		}
		
	}

	@Override
	public Integer getMaxPrioridad(Long idEsquema) {
			StringBuilder hql = new StringBuilder("select max(rcf.prioridad) from RecobroCarteraEsquema rcf ");
	        hql.append(" where rcf.esquema.id = ?");
		
	        List<Integer> ret = getHibernateTemplate().find(hql.toString(), idEsquema);
	        
	        return Checks.esNulo(ret.get(0)) ? 0 : ret.get(0);

	}

	@Override
	public RecobroCarteraEsquema getCarteraEsquemaPorNombreYEsquema(
			RecobroEsquema esquema, RecobroCarteraEsquema carteraEsquema) {
			
			String hsql = "select distinct ca from RecobroCarteraEsquema ca, RecobroEsquema eq ";
				hsql += " 	WHERE ca.auditoria.borrado = 0 AND " +
						"		eq.id = ca.esquema.id AND "	+
						"       eq.auditoria.borrado = 0 AND " +
						"       eq.id = " + esquema.getId() + " AND " +
						"       ca.cartera.nombre = '" + carteraEsquema.getCartera().getNombre() +"' ";
			
			List<RecobroCarteraEsquema> ret = getHibernateTemplate().find(hsql.toString());
			
			return ret.size() == 0 ? null : ret.get(0);
	        
	}

	@Override
	public RecobroCarteraEsquema getCarteraEsquema(Long idEsquema,
			Long idCartera) {
			
			String hsql = "select distinct ca from RecobroCarteraEsquema ca, RecobroEsquema eq ";
				hsql += " 	WHERE ca.auditoria.borrado = 0 AND " +
						"		eq.id = ca.esquema.id AND "	+
						"       eq.auditoria.borrado = 0 AND " +
						"       eq.id = " + idEsquema + " AND " +
						"       ca.cartera.id = '" +idCartera +"' ";
			
			List<RecobroCarteraEsquema> ret = getHibernateTemplate().find(hsql.toString());
			
			return ret.size() == 0 ? null : ret.get(0);
	}

}
