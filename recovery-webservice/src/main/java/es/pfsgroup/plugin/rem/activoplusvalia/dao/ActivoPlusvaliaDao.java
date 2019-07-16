package es.pfsgroup.plugin.rem.activoplusvalia.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPlusvalia;

public interface ActivoPlusvaliaDao extends AbstractDao<ActivoPlusvalia, Long>{
	
	public ActivoPlusvalia getPlusvaliaByIdActivo(Long idActivo);
	
}
