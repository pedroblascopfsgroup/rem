package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;

public interface ReclamacionGencatDao extends AbstractDao<ReclamacionGencat, Long> {

	ReclamacionGencat getReclamacionByComunicacionGencatId(Long comunicacionId);
	
}
