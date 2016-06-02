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

	@SuppressWarnings("unchecked")
	@Override
	public List<LiquidacionPCO> getLiquidacionesPorIdProcedimientoPCO(Long idProcedimientoPCO) {

		Criteria query = getSession().createCriteria(LiquidacionPCO.class).setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
		query.createAlias("procedimientoPCO", "procedimientoPCO");
		query.add(Restrictions.eq("procedimientoPCO.id", idProcedimientoPCO));
		query.add(Restrictions.eq("auditoria.borrado", false));

		List<LiquidacionPCO> liquidaciones = query.list();
		return liquidaciones;
	}

	@Override
	public LiquidacionPCO getLiquidacionDelContrato(Long idContrato, Long idProcPco) {
		
		Criteria query = getSession().createCriteria(LiquidacionPCO.class);
		query.createAlias("contrato", "contrato");
		query.add(Restrictions.eq("contrato.id", idContrato));
		query.add(Restrictions.eq("procedimientoPCO.id", idProcPco));

		LiquidacionPCO liquidacion = null;
		try {
			liquidacion = (LiquidacionPCO) query.uniqueResult();
		} catch (Exception e) {
			logger.error("LiquidacionDaoImpl.getLiquidacionDelContrato]: " + e.getMessage());
		}
		return liquidacion;
	}
}
