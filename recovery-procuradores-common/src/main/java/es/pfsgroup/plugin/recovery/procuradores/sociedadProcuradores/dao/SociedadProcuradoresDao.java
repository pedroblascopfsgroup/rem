package es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.dto.SociedadProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model.SociedadProcuradores;


public interface SociedadProcuradoresDao  extends AbstractDao<SociedadProcuradores, Long>{

	public Page getListaSociedadesProcuradores(SociedadProcuradoresDto dto);
	
	public SociedadProcuradores getSociedadProcuradores(Long idSociedad);
	
	
}
