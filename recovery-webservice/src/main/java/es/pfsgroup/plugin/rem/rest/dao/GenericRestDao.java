package es.pfsgroup.plugin.rem.rest.dao;

import java.io.Serializable;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.rest.dto.InformeMediadorDto;

public interface GenericRestDao extends AbstractDao<Serializable, Serializable>{
	
	public void deleteInformeMediador(InformeMediadorDto informeComerical) throws Exception;

}
