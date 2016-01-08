package es.pfsgroup.listadoPreProyectado.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoExp;

public interface ListadoPreProyectadoApi {
	
	Page getListPreproyectadoExp(ListadoPreProyectadoDTO dto);
	
	List<VListadoPreProyectadoCnt> getListPreproyectadoCnt(ListadoPreProyectadoDTO dto);
	int getCountListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto);

	List<VListadoPreProyectadoCnt> getListPreproyectadoCntPaginated(ListadoPreProyectadoDTO dto);
}
