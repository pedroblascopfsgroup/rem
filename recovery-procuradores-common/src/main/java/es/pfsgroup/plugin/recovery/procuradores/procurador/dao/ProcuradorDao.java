package es.pfsgroup.plugin.recovery.procuradores.procurador.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.ProcuradorDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;


public interface ProcuradorDao  extends AbstractDao<Procurador, Long>{

	public Page getListadoProcuradores(ProcuradorDto dto);
	
	public List<Procurador> getListadoProcuradoresLista(ProcuradorDto dto);
	
	public Procurador getProcurador(Long idProcurador);
}
