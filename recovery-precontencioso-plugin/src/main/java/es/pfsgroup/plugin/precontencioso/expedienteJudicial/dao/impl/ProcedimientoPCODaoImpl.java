package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

@Repository
public class ProcedimientoPCODaoImpl extends AbstractEntityDao<ProcedimientoPCO, Long> implements ProcedimientoPCODao {

	@Override
	public ProcedimientoPCO getProcedimientoPcoPorIdProcedimiento(Long idProcedimiento) {
		Criteria query = getSession().createCriteria(ProcedimientoPCO.class);

		query.createCriteria("procedimiento", "procedimiento");
		query.add(Restrictions.eq("procedimiento.id", idProcedimiento));

		List<ProcedimientoPCO> procedimientosPco = query.list();

		ProcedimientoPCO procedimientoPco = null;
		if (procedimientosPco.size() == 1) {
			procedimientoPco = procedimientosPco.get(0);
		}

		return procedimientoPco;
	}
}
