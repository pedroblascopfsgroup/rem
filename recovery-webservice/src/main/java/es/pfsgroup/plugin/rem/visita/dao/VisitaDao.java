package es.pfsgroup.plugin.rem.visita.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.Visita;

public interface VisitaDao extends AbstractDao<Visita, Long>{
	
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter);

}
