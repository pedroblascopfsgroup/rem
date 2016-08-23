package es.pfsgroup.plugin.rem.oferta.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Visita;

public interface OfertaDao extends AbstractDao<Oferta, Long>{
	
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter);

}
