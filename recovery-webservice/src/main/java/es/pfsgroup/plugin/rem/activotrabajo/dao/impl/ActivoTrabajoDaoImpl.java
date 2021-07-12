package es.pfsgroup.plugin.rem.activotrabajo.dao.impl;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;

import java.math.BigDecimal;

@Repository("ActivoTrabajoDao")
public class ActivoTrabajoDaoImpl extends AbstractEntityDao<ActivoTrabajo, Long> implements ActivoTrabajoDao{
			
	@Override
	public ActivoTrabajo findOne(Long idActivo,	Long idTrabajo) {
		
		HQLBuilder hql = new HQLBuilder("from ActivoTrabajo");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "activo", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "trabajo", idTrabajo);
		
		Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
		HQLBuilder.parametrizaQuery(q, hql);
		
		return (ActivoTrabajo) q.uniqueResult();
	}

	@Override
	public Float getImporteParticipacionTotal(Long numTrabajo) {

		String sql = " SELECT SUM(ACT_TBJ_PARTICIPACION) FROM REM01.ACT_TBJ ATJ " +
				" JOIN REM01.ACT_TBJ_TRABAJO TBJ ON ATJ.TBJ_ID = TBJ.TBJ_ID " +
				" WHERE TBJ.TBJ_NUM_TRABAJO = :numTrabajo";
	
	
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(sql);

		callFunctionSql.setParameter("numTrabajo", numTrabajo);

		
		BigDecimal resultadoBigD = (BigDecimal)callFunctionSql.uniqueResult();
		return resultadoBigD != null ? resultadoBigD.floatValue() : 0f;
		
	}
}
