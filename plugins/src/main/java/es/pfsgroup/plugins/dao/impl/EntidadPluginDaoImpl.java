package es.pfsgroup.plugins.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugins.dao.EntidadPluginDao;
import es.pfsgroup.plugins.domain.EntidadPlugin;

@Repository("EntidadPluginDao")
public class EntidadPluginDaoImpl extends AbstractEntityDao<EntidadPlugin, Long> implements EntidadPluginDao {

	@Override
	public EntidadPlugin getPluginPorEntidad(String plugin, Long idEntidad) {
		HQLBuilder b = new HQLBuilder("from EntidadPlugin ep");
		b.appendWhere("auditoria.borrado = false");
		
		HQLBuilder.addFiltroIgualQue(b, "ep.pluginCode", plugin);
		HQLBuilder.addFiltroIgualQue(b, "ep.entidad.id", idEntidad);
		
		return HibernateQueryUtils.uniqueResult(this, b);
	}

}
