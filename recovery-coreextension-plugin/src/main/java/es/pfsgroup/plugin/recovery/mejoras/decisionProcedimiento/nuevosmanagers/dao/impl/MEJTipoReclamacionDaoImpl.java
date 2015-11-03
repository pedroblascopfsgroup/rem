package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.MEJTipoReclamacionDao;

@Repository
public class MEJTipoReclamacionDaoImpl extends AbstractEntityDao<DDTipoReclamacion, Long> implements MEJTipoReclamacionDao{

	@Override
	public DDTipoReclamacion getByCodigo(String codigo) {
		HQLBuilder b = new HQLBuilder("from DDTipoReclamacion");
		b.appendWhere("auditoria.borrado=false");
		HQLBuilder.addFiltroIgualQue(b, "codigo", codigo);
		return HibernateQueryUtils.uniqueResult(this,b);
	}

}
