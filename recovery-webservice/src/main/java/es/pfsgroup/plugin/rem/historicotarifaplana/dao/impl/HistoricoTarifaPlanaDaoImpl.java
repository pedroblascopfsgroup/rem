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
	public Boolean subtipoTrabajoTieneTarifaPlanaVigente(Long idCarteraActivo, Long idSubtipoTrabajo, Date fechaSolicitud) {
		Boolean resultado = false;
		DetachedCriteria criteria = DetachedCriteria.forClass(HistoricoTarifaPlana.class);
        criteria.add(Restrictions.eq("subtipoTrabajo.id", idSubtipoTrabajo))
        		.add(Restrictions.eq("esTarifaPlana", true))
        		.add(Restrictions.le("fechaInicioTarifaPlana", fechaSolicitud))
        		.add(Restrictions.disjunction().add(Restrictions.ge("fechaFinTarifaPlana", fechaSolicitud)).add(Restrictions.isNull("fechaFinTarifaPlana")))
        		.add(Restrictions.eq("carteraTP.id", idCarteraActivo))
        		.add(Restrictions.eq("auditoria.borrado", false));
        
        List<HistoricoTarifaPlana> listaHistoricoTarifaPlana = getHibernateTemplate().findByCriteria(criteria);
        if(listaHistoricoTarifaPlana != null){
        	resultado = !listaHistoricoTarifaPlana.isEmpty();
        }
        
		return resultado;
	}

}
