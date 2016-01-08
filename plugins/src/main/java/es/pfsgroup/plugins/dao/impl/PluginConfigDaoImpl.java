package es.pfsgroup.plugins.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugins.dao.PluginConfigDao;
import es.pfsgroup.plugins.domain.PluginConfig;

@Repository("PluginConfigDao")
public class PluginConfigDaoImpl extends AbstractEntityDao<PluginConfig, Long> implements PluginConfigDao{

	@Override
	public List<PluginConfig> getPluginConfig(String plugin) {
		HQLBuilder b = new HQLBuilder("from PluginConfig pc");
		b.appendWhere("auditoria.borrado = false");
		
		HQLBuilder.addFiltroIgualQue(b, "pc.pluginCode", plugin);
		
		return HibernateQueryUtils.list(this, b);
	}

}
