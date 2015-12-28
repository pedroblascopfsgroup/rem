package es.pfsgroup.plugin.recovery.comites.comite.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.comites.comite.dto.CMTDtoBusquedaComite;
import es.pfsgroup.plugin.recovery.comites.comite.model.CMTComite;

public interface CMTComiteDao extends AbstractDao<CMTComite, Long>{

	public Page findComites(CMTDtoBusquedaComite dto);

	public CMTComite createNewComite();

}
