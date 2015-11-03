package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;

public interface VListadoPreProyectadoCntDao {

	List<VListadoPreProyectadoCnt> getListadoPreProyectadoCnt(ListadoPreProyectadoDTO dto);
	
	List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntExp(Long expId);

	Page getListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto);
}