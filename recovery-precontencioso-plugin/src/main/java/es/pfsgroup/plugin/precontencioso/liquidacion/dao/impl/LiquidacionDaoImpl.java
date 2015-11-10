package es.pfsgroup.plugin.precontencioso.liquidacion.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

@Repository
public class LiquidacionDaoImpl extends AbstractEntityDao<LiquidacionPCO, Long> implements LiquidacionDao {

	@Override
	public List<LiquidacionPCO> getLiquidacionesPorIdProcedimientoPCO(Long idProcedimientoPCO) {

		Criteria query = getSession().createCriteria(LiquidacionPCO.class);
		query.createAlias("procedimientoPCO", "procedimientoPCO");
		query.add(Restrictions.eq("procedimientoPCO.id", idProcedimientoPCO));

		List<LiquidacionPCO> liquidaciones = query.list();
		return liquidaciones;
	}

	@Override
	public LiquidacionPCO getLiquidacionDelContrato(Long idContrato) {
		
		Criteria query = getSession().createCriteria(LiquidacionPCO.class);
		query.createAlias("contrato", "contrato");
		query.add(Restrictions.eq("contrato.id", idContrato));

		LiquidacionPCO liquidacion = (LiquidacionPCO) query.uniqueResult();
		return liquidacion;
	}
}
