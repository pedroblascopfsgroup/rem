package es.pfsgroup.plugin.recovery.liquidaciones.dao.impl;

import java.util.Date;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

@Repository("LIQCobroPagoDao")
public class LIQCobroPagoDaoImpl extends AbstractEntityDao<LIQCobroPago, Long> implements LIQCobroPagoDao{

	@Override
	public List<LIQCobroPago> findEntregasACuenta(Long contrato,
			Date fechaCierre, Date fechaLiquidacion) {
		HQLBuilder b = new HQLBuilder("from LIQCobroPago cp");
		b.appendWhere("cp.auditoria.borrado = false");
		HQLBuilder.addFiltroIgualQue(b, "cp.contrato.id", contrato);
		b.appendWhere("cp.subTipo.codigo = 'EC'");
		HQLBuilder.addFiltroBetweenSiNotNull(b, "cp.fecha", fechaCierre, fechaLiquidacion);
		b.appendWhere("cp.estado.codigo = '04'");
		b.orderBy("cp.fecha", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.list(this, b);
	}
	
    @SuppressWarnings("unchecked")
    @Override
    public List<LIQCobroPago> getByIdAsunto(Long idAsunto) {
//        List<LIQCobroPago> ls = null;
//        DetachedCriteria crit = DetachedCriteria.forClass(LIQCobroPago.class);
//        crit.add(Expression.eq("asunto.id", idAsunto));
//        crit.add(Expression.eq("auditoria.borrado", false));
//
//        try {
//            ls = getHibernateTemplate().findByCriteria(crit);
//        } catch (Exception e) {
//            logger.error(e);
//        }
//        return ls;
    	HQLBuilder hb = new HQLBuilder("from LIQCobroPago cobro");
		hb.appendWhere("cobro.auditoria.borrado=false");

		HQLBuilder.addFiltroIgualQue(hb, "asunto.id", idAsunto);
		
		hb.orderBy("fecha", HQLBuilder.ORDER_DESC);
		
		return HibernateQueryUtils.list(this, hb);
    }

}
