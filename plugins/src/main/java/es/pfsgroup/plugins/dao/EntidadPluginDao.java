package es.pfsgroup.plugins.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.pfsgroup.plugins.domain.EntidadPlugin;

public interface EntidadPluginDao extends AbstractDao<EntidadPlugin, Long>{

	EntidadPlugin getPluginPorEntidad(String plugin, Long idEntidad);

}
