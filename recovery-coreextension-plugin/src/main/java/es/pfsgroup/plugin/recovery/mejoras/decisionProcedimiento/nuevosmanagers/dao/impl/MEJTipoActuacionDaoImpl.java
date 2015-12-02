package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.MEJTipoActuacionDao;

@Repository
public class MEJTipoActuacionDaoImpl extends AbstractEntityDao<DDTipoActuacion, Long> implements MEJTipoActuacionDao{

	@Override
	public DDTipoActuacion getByCodigo(String codigo) {
		HQLBuilder b = new HQLBuilder("from DDTipoActuacion");
		b.appendWhere("auditoria.borrado=false");
		HQLBuilder.addFiltroIgualQue(b, "codigo", codigo);
		return HibernateQueryUtils.uniqueResult(this, b);
	}

}
