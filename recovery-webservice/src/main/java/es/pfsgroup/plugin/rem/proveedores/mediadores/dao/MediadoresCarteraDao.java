package es.pfsgroup.plugin.rem.proveedores.mediadores.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoMediadorStats;
import es.pfsgroup.plugin.rem.model.VStatsCarteraMediadores;

public interface MediadoresCarteraDao extends AbstractDao<VStatsCarteraMediadores, Long>{

	public Page getStatsCarteraMediador(DtoMediadorStats dtoMediadorStats);
	
}
