package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api;

import java.util.List;

import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoExp;

public interface VListadoPreProyectadoExpDao {

	List<VListadoPreProyectadoExp> getListadoPreProyectadoExp(ListadoPreProyectadoDTO dto);
}