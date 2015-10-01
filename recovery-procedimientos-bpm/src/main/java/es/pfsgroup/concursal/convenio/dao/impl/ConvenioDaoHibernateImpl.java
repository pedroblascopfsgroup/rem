package es.pfsgroup.concursal.convenio.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.concursal.convenio.dao.ConvenioDao;
import es.pfsgroup.concursal.convenio.model.Convenio;

@Repository("ConvenioDao")
public class ConvenioDaoHibernateImpl extends AbstractEntityDao<Convenio, Long> implements ConvenioDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<Convenio> findByProcedimiento(Long idProcedimiento) {
		if (Checks.esNulo(idProcedimiento)){
			throw new IllegalArgumentException("idProcedimiento null");
		}
		
		HQLBuilder hql = new HQLBuilder("from Convenio c");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "c.procedimiento.id", idProcedimiento);

		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		
		return query.list();
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Convenio> findByNumAuto(String numAuto) {
		if (Checks.esNulo(numAuto)){
			throw new IllegalArgumentException("numAuto null");
		}
		
		HQLBuilder hql = new HQLBuilder("from Convenio c");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "c.procedimiento.codigoProcedimientoEnJuzgado", numAuto);

		Query query = getSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(query, hql);
		
		return query.list();
		
	}

}
