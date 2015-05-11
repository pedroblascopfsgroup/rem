package es.pfsgroup.concursal.concurso.dao.impl;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.concursal.concurso.dao.ExtendedProcedimientoContratoExpedienteDao;

@Repository("ExtendedProcedimientoContratoExpedienteDao")
public class ExtendedProcedimientoContratoExpedienteDaoImpl extends AbstractEntityDao<ProcedimientoContratoExpediente, Long> implements ExtendedProcedimientoContratoExpedienteDao{

	@Override
	public ProcedimientoContratoExpediente buscar(Long idProcedimiento,
			Long idContratoExpediente) {
		HQLBuilder hql = new HQLBuilder("from ProcedimientoContratoExpediente");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "procedimiento", idProcedimiento);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "expedienteContrato", idContratoExpediente);
//		hql.orderBy("procedimiento", "asc");
		
		Query q = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(q, hql);
		return (ProcedimientoContratoExpediente) q.uniqueResult();
	}

}
