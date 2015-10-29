package es.pfsgroup.concursal.credito.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.concursal.credito.dao.CreditoDao;
import es.pfsgroup.concursal.credito.model.Credito;

@Repository("CreditoDao")
public class CreditoDaoHibernateImpl extends AbstractEntityDao<Credito, Long> implements CreditoDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<Credito> findByContratoProcedimiento(Long idExpedienteContrato,
			Long idProcedimiento) {
		if (Checks.esNulo(idExpedienteContrato)){
			throw new IllegalArgumentException("idContrato null");
		}
		
		if (Checks.esNulo(idProcedimiento)){
			throw new IllegalArgumentException("idProcedimiento null");
		}
		
		HQLBuilder hql = new HQLBuilder("from Credito");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "borrado", 0);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idProcedimiento", idProcedimiento);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idContratoExpediente", idExpedienteContrato);

		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		
		return query.list();
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Credito> findByContratoProcedimientoDefinitivos(Long idExpedienteContrato, Long idProcedimiento) {
		if (Checks.esNulo(idExpedienteContrato)){
			throw new IllegalArgumentException("idContrato null");
		}
		
		if (Checks.esNulo(idProcedimiento)){
			throw new IllegalArgumentException("idProcedimiento null");
		}
		
		HQLBuilder hql = new HQLBuilder("from Credito");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "borrado", 0);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idProcedimiento", idProcedimiento);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idContratoExpediente", idExpedienteContrato);
		hql.appendWhere(" tipoDefinitivo <> null OR principalDefinitivo <> null ");
		
		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		
		return query.list();
		
	}
}
