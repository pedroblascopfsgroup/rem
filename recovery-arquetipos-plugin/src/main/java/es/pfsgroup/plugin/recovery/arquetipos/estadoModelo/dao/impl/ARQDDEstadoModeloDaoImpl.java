package es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao.ARQDDEstadoModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.model.ARQDDEstadoModelo;

@Repository("ARQDDEstadoModeloDao")
public class ARQDDEstadoModeloDaoImpl extends AbstractEntityDao<ARQDDEstadoModelo, Long> implements ARQDDEstadoModeloDao{

	@Override
	public ARQDDEstadoModelo getByCodigo(String codigoEstadoVigente) {
		HQLBuilder b=new HQLBuilder("from ARQDDEstadoModelo est");
		b.appendWhere("est.auditoria.borrado = 0");
		
		HQLBuilder.addFiltroLikeSiNotNull(b, "est.codigo", codigoEstadoVigente);
		
		return HibernateQueryUtils.uniqueResult(this, b);
	}

}
