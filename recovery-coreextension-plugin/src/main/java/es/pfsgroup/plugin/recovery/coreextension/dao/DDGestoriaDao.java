package es.pfsgroup.plugin.recovery.coreextension.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.coreextension.model.DDGestoria;

public interface DDGestoriaDao extends AbstractDao<DDGestoria, Long> {
	
	   public DDGestoria buscarPorCodigo(String codigo);
	
}
