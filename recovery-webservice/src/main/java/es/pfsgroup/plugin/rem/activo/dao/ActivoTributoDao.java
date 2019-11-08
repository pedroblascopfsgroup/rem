package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoTributos;

public interface ActivoTributoDao extends AbstractDao<ActivoTributos, Long>{
	Long getNumMaxTributo();
}
