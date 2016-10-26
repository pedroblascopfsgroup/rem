package es.pfsgroup.plugin.rem.rest.dao;

import java.io.Serializable;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;

public interface GenericRestDao extends AbstractDao<Serializable, Serializable>{
	
	public void deleteInformeMediador(ActivoInfoComercial informeComerical) throws Exception;

}
