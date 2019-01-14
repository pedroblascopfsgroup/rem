package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;

public interface AdecuacionGencatDao extends AbstractDao<AdecuacionGencat, Long> {

	AdecuacionGencat getAdecuacionByComunicacionGencat(Long comunicacionId);
}
