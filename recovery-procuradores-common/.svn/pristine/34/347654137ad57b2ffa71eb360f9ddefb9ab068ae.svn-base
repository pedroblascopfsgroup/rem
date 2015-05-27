package es.pfsgroup.plugin.recovery.procuradores.configuracion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.dao.ConfiguracionDespachoExternoDao;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.model.ConfiguracionDespachoExterno;

@Repository
public class ConfiguracionDespachoExternoDaoImpl extends AbstractEntityDao<ConfiguracionDespachoExterno, Long> implements ConfiguracionDespachoExternoDao {

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.configuracion.dao.ConfiguracionDespachoExternoDao#getConfiguracionDespachoExterno(java.lang.Long)
	 */
	@Override
	public ConfiguracionDespachoExterno getConfiguracionDespachoExterno(Long idDespachoExterno) {

		if (idDespachoExterno == null) return null;
			HQLBuilder hb = new HQLBuilder(" from ConfiguracionDespachoExterno cde ");
			HQLBuilder.addFiltroIgualQue(hb, "cde.despachoExterno.id", idDespachoExterno);
			List<ConfiguracionDespachoExterno> lista = HibernateQueryUtils.list(this, hb);
			if (lista != null && lista.size()>0){
				return lista.get(0);
			}
			return null;
	}




}
