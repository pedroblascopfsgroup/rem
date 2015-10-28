package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.MEJTipoProcedimientoDao;

@Repository
public class MEJTipoProcedimientoDaoImpl extends AbstractEntityDao<TipoProcedimiento, Long> implements MEJTipoProcedimientoDao{

	@Override
	public TipoProcedimiento getByCodigo(String codigo) {
		HQLBuilder b = new HQLBuilder("from TipoProcedimiento");
		b.appendWhere("auditoria.borrado=false");
		HQLBuilder.addFiltroIgualQue(b, "codigo", codigo);
		return HibernateQueryUtils.uniqueResult(this, b);
	}

}
