package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoExp;

public interface ListadoPreProyectadoApi {
	
	Page getListPreproyectadoExp(ListadoPreProyectadoDTO dto);
	
	List<VListadoPreProyectadoCnt> getListPreproyectadoCnt(ListadoPreProyectadoDTO dto);
	int getCountListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto);

	List<VListadoPreProyectadoCnt> getListPreproyectadoCntPaginated(ListadoPreProyectadoDTO dto);
}
