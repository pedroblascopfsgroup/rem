package es.pfsgroup.plugin.rem.activo.valoracion.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.activo.valoracion.dao.ActivoValoracionDao;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import org.hibernate.Criteria;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

@Repository("ActivoValoracionDao")
public class ActivoValoracionDaoImpl extends AbstractEntityDao<ActivoValoraciones, Long> implements ActivoValoracionDao {


	@Override
	public Double getImporteValoracionVentaWebPorIdActivo(Long idActivo) {
		Criteria criteria = getSession().createCriteria(ActivoValoraciones.class);
		criteria.setProjection(Projections.property("importe"));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("tipoPrecio").add(Restrictions.eq("codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA));

		return HibernateUtils.castObject(Double.class, criteria.uniqueResult());
	}

	@Override
	public Double getImporteValoracionRentaWebPorIdActivo(Long idActivo) {
		Criteria criteria = getSession().createCriteria(ActivoValoraciones.class);
		criteria.setProjection(Projections.property("importe"));
		criteria.add(Restrictions.eq("activo.id", idActivo)).createCriteria("tipoPrecio").add(Restrictions.eq("codigo", DDTipoPrecio.CODIGO_TPC_APROBADO_RENTA));

		return HibernateUtils.castObject(Double.class, criteria.uniqueResult());
	}
}