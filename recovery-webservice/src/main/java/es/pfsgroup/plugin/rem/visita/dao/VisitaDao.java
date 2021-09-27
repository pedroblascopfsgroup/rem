package es.pfsgroup.plugin.rem.visita.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.capgemini.pfs.users.domain.Usuario;

public interface VisitaDao extends AbstractDao<Visita, Long>{
	

	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter);

	public Long getNextNumVisitaRem();
	
	public List<Visita> getListaVisitas(VisitaDto visitaDto);
	
	public DtoPage getListVisitasDetalle(DtoVisitasFilter dtoVisitasFilter, Usuario usuario);

	public List<Visita> getListaVisitasOrdenada(DtoVisitasFilter dtoVisitasFilter);
		
	public VBusquedaVisitasDetalle getVisitaDetalle(DtoVisitasFilter dtoVisitasFilter);
	
	public Visita getVisitaByIdwebcom(Long idWebcom);


}
