package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api;

import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoExp;
import java.util.List;

public interface ListadoPreProyectadoApi {
	
	List<VListadoPreProyectadoExp> getListPreproyectadoExp(ListadoPreProyectadoDTO dto);
	
	List<VListadoPreProyectadoCnt> getListPreproyectadoCnt(ListadoPreProyectadoDTO dto);
}
