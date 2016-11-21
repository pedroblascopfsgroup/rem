package es.pfsgroup.plugin.rem.proveedores.mediadores.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoMediadorOferta;
import es.pfsgroup.plugin.rem.model.VListMediadoresOfertas;

public interface MediadoresOfertasDao extends AbstractDao<VListMediadoresOfertas, Long>{

	public Page getListMediadorOfertas(DtoMediadorOferta dtoMediadorOferta);
	
}
