package es.pfsgroup.plugin.rem.historicotarifaplana.dao.impl;

import java.util.Date;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.rem.historicotarifaplana.dao.HistoricoTarifaPlanaDao;
import es.pfsgroup.plugin.rem.model.HistoricoTarifaPlana;


@Repository("HistoricoTarifaPlanaDao")
public class HistoricoTarifaPlanaDaoImpl extends AbstractEntityDao<HistoricoTarifaPlana, Long> implements HistoricoTarifaPlanaDao{

	@SuppressWarnings("unchecked")
	@Override
	public Boolean subtipoTrabajoTieneTarifaPlanaVigente(Long idSubtipoTrabajo, Date fechaSolicitud) {	
		DetachedCriteria criteria = DetachedCriteria.forClass(HistoricoTarifaPlana.class);
        criteria.add(Restrictions.eq("subtipoTrabajo.id", idSubtipoTrabajo))
        		.add(Restrictions.eq("esTarifaPlana", true))
        		.add(Restrictions.le("fechaInicioTarifaPlana", fechaSolicitud))
        		.add(Restrictions.disjunction().add(Restrictions.ge("fechaFinTarifaPlana", fechaSolicitud)).add(Restrictions.isNull("fechaFinTarifaPlana")))
        		.add(Restrictions.eq("auditoria.borrado", false));
        
        List<HistoricoTarifaPlana> listaHistoricoTarifaPlana = getHibernateTemplate().findByCriteria(criteria);
		return !listaHistoricoTarifaPlana.isEmpty();
	}

}
